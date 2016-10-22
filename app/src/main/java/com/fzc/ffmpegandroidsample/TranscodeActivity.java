package com.fzc.ffmpegandroidsample;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;

import java.io.File;

import butterknife.ButterKnife;
import butterknife.OnClick;
import rx.Observable;
import rx.android.schedulers.AndroidSchedulers;
import rx.functions.Action1;
import rx.functions.Func1;
import rx.schedulers.Schedulers;

/**
 * Created by fanzhengchen on 10/22/16.
 */

public class TranscodeActivity extends AppCompatActivity {


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_transcode);
        ButterKnife.bind(this);
    }

    @OnClick(R.id.transcode)
    public void transcode() {


        String basePath = "/storage/emulated/0/Android";
        String[] commands = {
                "ffmpeg",
                "-i",
                basePath + File.separator + "out.mp4",
                basePath + File.separator + "ffmpeg.mp4",
        };

        Observable.just(commands)
                .map(new Func1<String[], Integer>() {
                    @Override
                    public Integer call(String[] strings) {
                        return Player.transcodeVideo(strings);
                    }
                })
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Action1<Integer>() {
                    @Override
                    public void call(Integer result) {
                        System.out.println("transcode result " + result);
                    }
                });
    }
}
