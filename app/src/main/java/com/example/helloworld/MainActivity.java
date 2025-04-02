package com.example.helloworld;

import android.app.Activity;
import android.os.Bundle;

public class MainActivity extends Activity {
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Simple version that doesn't require androidx libraries
        System.out.println("Hello World from MainActivity");
    }
}
