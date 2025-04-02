package com.example.helloworld;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        System.out.println("Hello World from MainActivity");
        System.out.println(BuildHelper.getBuildStatus());
        
        // Find the button by ID
        Button clickMeButton = findViewById(R.id.button_click_me);
        
        // Set click listener
        clickMeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Show a toast message when button is clicked
                Toast.makeText(MainActivity.this, 
                    "Button clicked! " + BuildHelper.getBuildStatus(), 
                    Toast.LENGTH_SHORT).show();
                
                // Update the TextView
                TextView textView = findViewById(R.id.text_hello_world);
                textView.setText("Hello Android World!");
            }
        });
    }
}
