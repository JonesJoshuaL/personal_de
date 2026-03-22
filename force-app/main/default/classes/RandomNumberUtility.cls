/**
 * @description Utility class for generating random numbers in Salesforce Apex
 * @author Joshua Jones
 * @since 2026-03-22
 * @version 1.0
 */
public with sharing class RandomNumberUtility {
    /**
     * Generates a random integer between min (inclusive) and max (inclusive)
     * @param min The minimum value (inclusive)
     * @param max The maximum value (inclusive)
     * @return A random integer between min and max (inclusive)
     * @throws IllegalArgumentException if min > max or if parameters are null
     */
    public static Integer getRandomInteger(Integer min, Integer max) {
        if (min == null || max == null) {
            throw new IllegalArgumentException('Min and max values cannot be null');
        }
        if (min > max) {
            throw new IllegalArgumentException('Min value cannot be greater than max value');
        }

        // Handle edge case where min equals max
        if (min == max) {
            return min;
        }

        // Generate random integer in range [min, max]
        return min + Math.floor(Math.random() * (max - min + 1)).intValue();
    }

    /**
     * Generates a random integer between 0 (inclusive) and max (inclusive)
     * @param max The maximum value (inclusive)
     * @return A random integer between 0 and max (inclusive)
     * @throws IllegalArgumentException if max is negative or null
     */
    public static Integer getRandomInteger(Integer max) {
        if (max == null) {
            throw new IllegalArgumentException('Max value cannot be null');
        }
        if (max < 0) {
            throw new IllegalArgumentException('Max value cannot be negative');
        }

        // Handle edge case where max is 0
        if (max == 0) {
            return 0;
        }

        // Generate random integer in range [0, max]
        return Math.floor(Math.random() * (max + 1)).intValue();
    }
}
