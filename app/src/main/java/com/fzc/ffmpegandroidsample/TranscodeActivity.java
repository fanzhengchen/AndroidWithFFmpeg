package com.fzc.ffmpegandroidsample;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;

import com.orhanobut.logger.Logger;

import java.io.File;
import java.util.Arrays;
import java.util.List;

import butterknife.ButterKnife;
import butterknife.OnClick;
import rx.Observable;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.functions.Func1;
import rx.schedulers.Schedulers;

/**
 * Created by fanzhengchen on 10/22/16.
 */

public class TranscodeActivity extends AppCompatActivity {

    private TranscodeService mRemoteService;
    private ITranscodeAidlInterface aidlInterface;
    private final String basePath = "/storage/emulated/0/Android";
    private final String[] commands = {
            "ffmpeg",
            "-i",
            basePath + File.separator + "video.mp4",
            "-b",
            "1.5M",
            "-s",
            "1080x1920",
            "-r", "24",
            basePath + File.separator + System.currentTimeMillis() + "out.mkv",
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_transcode);
        ButterKnife.bind(this);
    }

    @OnClick(R.id.start_remote_service)
    public void startRemoteService() {
        Intent intent = new Intent(getApplicationContext(), TranscodeService.class);
        bindService(intent, sc, Context.BIND_AUTO_CREATE);
    }

    @OnClick(R.id.transcode_remote_process)
    public void transcodeInRemoteProcess() {
        startRemoteService();
        List<String> cmds = Arrays.asList(commands);
        try {
            aidlInterface.transcode(cmds);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @OnClick(R.id.transcode_io_thread)
    public void transcode() {


        Observable.just(commands)
                .map(new Func1<String[], Integer>() {
                    @Override
                    public Integer call(String[] strings) {
                        return Player.transcodeVideo(strings);
                    }
                })
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<Integer>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        Logger.e(e.getMessage());
                    }

                    @Override
                    public void onNext(Integer integer) {
                        Logger.d("transcode result " + integer);
                    }
                });

    }


    private ServiceConnection sc = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {

            aidlInterface = ITranscodeAidlInterface.Stub.asInterface(service);
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            aidlInterface = null;
        }
    };

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (aidlInterface != null) {
            unbindService(sc);
        }
    }
}
