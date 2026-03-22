/**
 * @description Trigger that handles Survey Submission events.
 * @author Joshua Jones
 * @since 2026-03-22
 * @version 1.0
 *
 * This trigger processes Survey_Submission__e events after insert and delegates processing
 * to the SurveySubmissionTriggerHandler class. It handles both existing members and creates
 * placeholder members when needed.
 *
 * Best Practices Implemented:
 * - One Trigger Per Object pattern
 * - Separation of concerns with handler class
 * - Proper error handling with try/catch blocks
 * - Placeholder member creation for missing records
 * - Input validation for survey scores
 * - Bulkified processing
 */
trigger SurveySubmissionTrigger on Survey_Submission__e(after insert) {
    try {
        SurveySubmissionTriggerHandler.processEvents(Trigger.new);
    } catch (Exception e) {
        System.debug('Error in SurveySubmissionTrigger: ' + e.getMessage());
        // Re-throw to ensure the trigger fails appropriately
        throw e;
    }
}
