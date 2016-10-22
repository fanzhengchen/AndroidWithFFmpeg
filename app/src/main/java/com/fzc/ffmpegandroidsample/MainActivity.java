package com.fzc.ffmpegandroidsample;

import android.Manifest;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;

import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by fanzhengchen on 10/22/16.
 */

public class MainActivity extends AppCompatActivity {


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ActivityCompat.requestPermissions(this,
                new String[]{
                        Manifest.permission.READ_EXTERNAL_STORAGE,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE
                },
                200);
        ButterKnife.bind(this);
    }

    @OnClick(R.id.play_video)
    public void playVideo() {
        startActivity(new Intent(this, PlayActivity.class));
    }

    @OnClick(R.id.transcode_video)
    public void transcodeVideo() {
        startActivity(new Intent(this, TranscodeActivity.class));
    }
}
