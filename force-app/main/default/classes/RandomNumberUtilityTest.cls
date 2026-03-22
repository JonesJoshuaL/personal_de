/**
 * @description Test class for RandomNumberUtility
 * @author Joshua Jones
 * @since 2026-03-22
 */
@isTest
public class RandomNumberUtilityTest {
    /**
     * Tests the getRandomInteger method with min/max parameters
     * Verifies that generated numbers are within the specified range
     */
    @isTest
    static void testGetRandomIntegerMinMax() {
        // Test basic functionality with min/max values
        Integer min = 1;
        Integer max = 10;

        // Generate multiple random numbers to test range
        Set<Integer> generatedNumbers = new Set<Integer>();
        for (Integer i = 0; i < 100; i++) {
            Integer result = RandomNumberUtility.getRandomInteger(min, max);
            generatedNumbers.add(result);

            // Verify result is within range
            System.assert(
                result >= min && result <= max,
                'Generated number ' + result + ' should be between ' + min + ' and ' + max
            );
        }

        // Verify we got a variety of numbers (not just one value)
        System.assert(generatedNumbers.size() > 1, 'Should generate multiple different values');
    }

    /**
     * Tests the getRandomInteger method with max-only parameter
     * Verifies that generated numbers are within the range [0, max]
     */
    @isTest
    static void testGetRandomIntegerMaxOnly() {
        // Test with max-only overload
        Integer max = 5;

        // Generate multiple random numbers to test range
        Set<Integer> generatedNumbers = new Set<Integer>();
        for (Integer i = 0; i < 100; i++) {
            Integer result = RandomNumberUtility.getRandomInteger(max);
            generatedNumbers.add(result);

            // Verify result is within range [0, max]
            System.assert(
                result >= 0 && result <= max,
                'Generated number ' + result + ' should be between 0 and ' + max
            );
        }

        // Verify we got a variety of numbers (not just one value)
        System.assert(generatedNumbers.size() > 1, 'Should generate multiple different values');
    }

    /**
     * Tests edge cases for the getRandomInteger method
     * Includes testing when min equals max and when max is 0
     */
    @isTest
    static void testGetRandomIntegerEdgeCases() {
        // Test edge case where min equals max
        Integer min = 5;
        Integer max = 5;
        Integer result = RandomNumberUtility.getRandomInteger(min, max);
        System.assertEquals(min, result, 'When min equals max, should return min value');

        // Test edge case where max is 0
        Integer resultZero = RandomNumberUtility.getRandomInteger(0);
        System.assertEquals(0, resultZero, 'When max is 0, should return 0');
    }

    /**
     * Tests null parameter validation for getRandomInteger method
     * Ensures appropriate exceptions are thrown for invalid inputs
     */
    @isTest
    static void testGetRandomIntegerNullValidation() {
        // Test null parameter validation
        try {
            RandomNumberUtility.getRandomInteger(null, 10);
            System.assert(false, 'Should have thrown exception for null min parameter');
        } catch (IllegalArgumentException e) {
            System.assert(
                e.getMessage().contains('Min and max values cannot be null'),
                'Should get correct error message for null min'
            );
        }

        try {
            RandomNumberUtility.getRandomInteger(10, null);
            System.assert(false, 'Should have thrown exception for null max parameter');
        } catch (IllegalArgumentException e) {
            System.assert(
                e.getMessage().contains('Min and max values cannot be null'),
                'Should get correct error message for null max'
            );
        }

        try {
            RandomNumberUtility.getRandomInteger(null);
            System.assert(false, 'Should have thrown exception for null max parameter');
        } catch (IllegalArgumentException e) {
            System.assert(
                e.getMessage().contains('Max value cannot be null'),
                'Should get correct error message for null max'
            );
        }
    }

    /**
     * Tests invalid range validation for getRandomInteger method
     * Ensures appropriate exceptions are thrown when min > max
     */
    @isTest
    static void testGetRandomIntegerInvalidRange() {
        // Test invalid range where min > max
        try {
            RandomNumberUtility.getRandomInteger(10, 5);
            System.assert(false, 'Should have thrown exception for invalid range');
        } catch (IllegalArgumentException e) {
            System.assert(
                e.getMessage().contains('Min value cannot be greater than max value'),
                'Should get correct error message for invalid range'
            );
        }
    }

    /**
     * Tests negative max value validation for getRandomInteger method
     * Ensures appropriate exceptions are thrown for negative inputs
     */
    @isTest
    static void testGetRandomIntegerNegativeMax() {
        // Test negative max value
        try {
            RandomNumberUtility.getRandomInteger(-5);
            System.assert(false, 'Should have thrown exception for negative max');
        } catch (IllegalArgumentException e) {
            System.assert(
                e.getMessage().contains('Max value cannot be negative'),
                'Should get correct error message for negative max'
            );
        }
    }
}
