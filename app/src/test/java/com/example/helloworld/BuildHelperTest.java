package com.example.helloworld;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;
import static org.junit.Assert.*;

@RunWith(JUnit4.class)
public class BuildHelperTest {
    
    @Test
    public void testGetBuildStatus() {
        String status = BuildHelper.getBuildStatus();
        assertEquals("Build successful!", status);
    }
    
    @Test
    public void testIsDebugBuild() {
        // This should not throw an exception
        boolean isDebug = BuildHelper.isDebugBuild();
        // In test environment, we expect it to return true
        assertTrue(isDebug);
    }
}
