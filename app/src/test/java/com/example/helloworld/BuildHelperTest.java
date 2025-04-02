package com.example.helloworld;

import org.junit.Test;
import static org.junit.Assert.*;

public class BuildHelperTest {
    
    @Test
    public void testGetBuildStatus() {
        String status = BuildHelper.getBuildStatus();
        assertEquals("Build successful!", status);
    }
}
