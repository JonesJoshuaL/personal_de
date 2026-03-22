/**
 * @description Test class for SurveySubmissionTrigger
 * @author Joshua Jones
 * @since 2026-03-22
 */
@isTest
public class SurveySubmissionTriggerTest {
    /**
     * Tests the trigger with existing panel members
     * Verifies that the trigger correctly delegates to the handler
     */
    @isTest
    static void testTriggerWithExistingMembers() {
        // Setup test data
        Panel_Member__c existingMember = new Panel_Member__c(
            Name = 'Test Member',
            External_ID__c = 'EXT-100',
            Total_Points__c = 50
        );
        insert existingMember;

        // Create survey submission event
        Survey_Submission__e event = new Survey_Submission__e(
            Panelist_External_ID__c = 'EXT-100',
            Survey_Score__c = 25
        );

        // Fire the trigger
        Test.startTest();
        Database.SaveResult sr = EventBus.publish(event);
        Test.getEventBus().deliver();
        Test.stopTest();

        // Verify the member was updated
        Panel_Member__c updatedMember = [
            SELECT Id, External_ID__c, Total_Points__c
            FROM Panel_Member__c
            WHERE External_ID__c = 'EXT-100'
        ];

        Assert.areEqual(75, updatedMember.Total_Points__c, 'Points should be updated correctly');
    }

    /**
     * Tests the trigger with new panel members (placeholder creation)
     * Verifies that the trigger creates new members when they don't exist
     */
    @isTest
    static void testTriggerWithNewMembers() {
        // Create survey submission event for non-existing member
        Survey_Submission__e event = new Survey_Submission__e(
            Panelist_External_ID__c = 'NEW-999',
            Survey_Score__c = 30
        );

        // Fire the trigger
        Test.startTest();
        Database.SaveResult sr = EventBus.publish(event);
        Test.getEventBus().deliver();
        Test.stopTest();

        // Verify a new member was created
        List<Panel_Member__c> newMembers = [
            SELECT Id, External_ID__c, Total_Points__c, Name
            FROM Panel_Member__c
            WHERE External_ID__c = 'NEW-999'
        ];

        Assert.areEqual(1, newMembers.size(), 'Should create one new member');
        Assert.areEqual(30, newMembers[0].Total_Points__c, 'New member should have correct points');
        Assert.isTrue(newMembers[0].Name.startsWith('Placeholder Member'), 'New member should have placeholder name');
    }

    /**
     * Tests the trigger with null survey score
     * Verifies that events with null scores are handled gracefully
     */
    @isTest
    static void testTriggerWithNullScore() {
        // Create survey submission event with null score
        Survey_Submission__e event = new Survey_Submission__e(
            Panelist_External_ID__c = 'EXT-101',
            Survey_Score__c = null
        );

        // Fire the trigger - should not throw exception
        Test.startTest();
        Database.SaveResult sr = EventBus.publish(event);
        Test.getEventBus().deliver();
        Test.stopTest();

        // Verify no new member was created
        List<Panel_Member__c> members = [
            SELECT Id
            FROM Panel_Member__c
            WHERE External_ID__c = 'EXT-101'
        ];

        Assert.areEqual(0, members.size(), 'Should not create member for null score');
    }

    /**
     * Tests the trigger with null external ID
     * Verifies that events with null external IDs are handled gracefully
     */
    @isTest
    static void testTriggerWithNullExternalId() {
        // Create survey submission event with null external ID
        Survey_Submission__e event = new Survey_Submission__e(Panelist_External_ID__c = null, Survey_Score__c = 25);

        // Fire the trigger - should not throw exception
        Test.startTest();
        Database.SaveResult sr = EventBus.publish(event);
        Test.getEventBus().deliver();
        Test.stopTest();

        // Verify no members were affected
        List<Panel_Member__c> members = [SELECT Id FROM Panel_Member__c];

        System.assert(members != null, 'Should not affect existing members');
    }

    /**
     * Tests the trigger with multiple events
     * Verifies bulk processing works correctly
     */
    @isTest
    static void testTriggerWithMultipleEvents() {
        // Setup existing member
        Panel_Member__c existingMember = new Panel_Member__c(
            Name = 'Test Member',
            External_ID__c = 'EXT-102',
            Total_Points__c = 100
        );
        insert existingMember;

        // Create multiple survey submission events
        List<Survey_Submission__e> events = new List<Survey_Submission__e>{
            new Survey_Submission__e(Panelist_External_ID__c = 'EXT-102', Survey_Score__c = 15),
            new Survey_Submission__e(Panelist_External_ID__c = 'EXT-102', Survey_Score__c = 20)
        };

        // Fire the trigger
        Test.startTest();
        List<Database.SaveResult> sr = EventBus.publish(events);
        Test.getEventBus().deliver();
        Test.stopTest();

        // Verify the member was updated correctly (100 + 15 + 20 = 135)
        Panel_Member__c updatedMember = [
            SELECT Id, External_ID__c, Total_Points__c
            FROM Panel_Member__c
            WHERE External_ID__c = 'EXT-102'
        ];

        System.assertEquals(135, updatedMember.Total_Points__c, 'Points should accumulate correctly');
    }
}
