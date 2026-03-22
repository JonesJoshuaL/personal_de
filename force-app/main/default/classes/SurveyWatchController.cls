/**
 * @description Controller for managing survey watch functionality including retrieving recent surveys and triggering test events
 * @author Joshua Jones
 * @since 2026-03-22
 */
public with sharing class SurveyWatchController {
    /**
     * Retrieves the 5 most recently surveyed panel members
     * @return List of Panel_Member__c records ordered by Last_Survey_Date__c descending
     */
    @AuraEnabled(cacheable=false)
    public static List<Panel_Member__c> getRecentSurveys() {
        return [
            SELECT Id, Name, Total_Points__c, Last_Survey_Date__c
            FROM Panel_Member__c
            ORDER BY Last_Survey_Date__c DESC
            LIMIT 5
        ];
    }

    /**
     * Publishes a test survey submission event with a randomly selected panelist ID
     * @throws Exception if EventBus publishing fails
     * This is purely for testing purposes and should not be used in production code.
     */
    @AuraEnabled(cacheable=false)
    public static void testEvent() {
        List<String> panelistIds = new List<String>{ 'EXT-100', 'EXT-101', 'EXT-102', 'EXT-103', 'EXT-104', 'JPN-999' };
        Integer randomIndex = RandomNumberUtility.getRandomInteger(panelistIds.size() - 1);
        EventBus.publish(
            new Survey_Submission__e(Panelist_External_ID__c = panelistIds[randomIndex], Survey_Score__c = 32)
        );
    }
}
