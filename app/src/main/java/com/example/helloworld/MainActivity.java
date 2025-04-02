package com.example.helloworld;

import android.os.Bundle;
import android.widget.TextView;
import android.util.Log;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {
    
    private static final String TAG = "MainActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        // Log build status
        String buildStatus = BuildHelper.getBuildStatus();
        Log.d(TAG, buildStatus);
        
        // Update the TextView with build information
        TextView textView = findViewById(R.id.text_hello_world);
        if (BuildHelper.isDebugBuild()) {
            textView.append("\n(Debug Build)");
        }
    }
}
