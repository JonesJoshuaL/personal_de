/**
 * @description Test class for SurveyWatchController
 * @author Joshua Jones
 * @since 2026-03-22
 */
@isTest
public class SurveyWatchControllerTest {
    /**
     * Tests the getRecentSurveys method to ensure it returns the correct number of records
     * ordered by Last_Survey_Date__c in descending order
     */
    @isTest
    static void testGetRecentSurveys() {
        // Setup test data
        List<Panel_Member__c> testRecords = new List<Panel_Member__c>();

        // Create test Panel_Member__c records
        for (Integer i = 0; i < 7; i++) {
            Panel_Member__c pm = new Panel_Member__c(
                Name = 'Test Member ' + i,
                Total_Points__c = i * 10,
                Last_Survey_Date__c = DateTime.now().addDays(-i)
            );
            testRecords.add(pm);
        }

        insert testRecords;

        // Test the method
        List<Panel_Member__c> result = SurveyWatchController.getRecentSurveys();

        // Verify results
        Assert.isNotNull(result, 'Result should not be null');
        Assert.areEqual(5, result.size(), 'Should return 5 records');

        // Verify records are ordered by Last_Survey_Date__c descending
        for (Integer i = 0; i < result.size() - 1; i++) {
            Assert.isTrue(
                result[i].Last_Survey_Date__c >= result[i + 1].Last_Survey_Date__c,
                'Records should be ordered by Last_Survey_Date__c descending'
            );
        }
    }

    /**
     * Tests that the testEvent method executes without throwing exceptions
     * Note: Since testEvent() publishes to EventBus, we can't easily mock that
     */
    @isTest
    static void testTestEvent() {
        // Test that the method compiles and executes without error
        try {
            SurveyWatchController.testEvent();
            // If we reach here, the method executed successfully
        } catch (Exception e) {
            Assert.fail('testEvent method threw an exception: ' + e.getMessage());
        }
    }
}
