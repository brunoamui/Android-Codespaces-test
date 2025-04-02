package com.example.helloworld;

/**
 * Helper class to verify build status
 */
public class BuildHelper {
    
    /**
     * Returns a message indicating build status
     * @return String message
     */
    public static String getBuildStatus() {
        return "Build successful!";
    }
    
    /**
     * Utility method to check if the app is running in debug mode
     * @return boolean indicating debug status
     */
    public static boolean isDebugBuild() {
        try {
            return BuildConfig.DEBUG;
        } catch (Exception e) {
            // For unit tests where BuildConfig might not be available
            return true;
        }
    }
}
