/**
 * @description Handler class for SurveySubmissionTrigger that processes survey submission events
 * @author Joshua Jones
 * @since 2026-03-22
 * @version 1.0
 *
 * This handler processes Survey_Submission__e events and updates corresponding Panel_Member__c records.
 * It handles both existing members and creates placeholder members when needed.
 */
public with sharing class SurveySubmissionTriggerHandler {
    /**
     * Processes survey submission events to update panel member points
     * @param events List of Survey_Submission__e events to process
     */
    public static void processEvents(List<Survey_Submission__e> events) {
        if (events == null || events.isEmpty()) {
            return;
        }

        // 1. Collect External IDs from the incoming events
        Set<String> externalIds = new Set<String>();
        for (Survey_Submission__e event : events) {
            if (event.Panelist_External_ID__c != null) {
                externalIds.add(event.Panelist_External_ID__c);
            }
        }

        if (externalIds.isEmpty()) {
            return;
        }

        // 2. Query existing members into a base map
        Map<String, Panel_Member__c> existingMembersMap = new Map<String, Panel_Member__c>();
        for (Panel_Member__c pm : [
            SELECT Id, External_ID__c, Total_Points__c, Last_Survey_Date__c
            FROM Panel_Member__c
            WHERE External_ID__c IN :externalIds
        ]) {
            existingMembersMap.put(pm.External_ID__c, pm);
        }

        // 3. Process events and aggregate points using Maps to prevent duplicate List elements
        Map<String, Panel_Member__c> membersToUpdate = new Map<String, Panel_Member__c>();
        Map<String, Panel_Member__c> membersToInsert = new Map<String, Panel_Member__c>();

        for (Survey_Submission__e event : events) {
            String externalId = event.Panelist_External_ID__c;

            // Skip invalid events
            if (externalId == null || event.Survey_Score__c == null) {
                continue;
            }

            // Scenario A: Updating an existing member
            if (existingMembersMap.containsKey(externalId)) {
                Panel_Member__c pm = existingMembersMap.get(externalId);

                // Aggregate points directly on the instance memory
                pm.Total_Points__c = (pm.Total_Points__c == null ? 0 : pm.Total_Points__c) + event.Survey_Score__c;
                pm.Last_Survey_Date__c = System.now();

                // Put in the update map (overwrites the key with the updated instance)
                membersToUpdate.put(externalId, pm);
            }
            // Scenario B: Creating/Updating a new placeholder member
            else {
                // Check if we already created a placeholder for this ID in a previous loop iteration
                if (membersToInsert.containsKey(externalId)) {
                    Panel_Member__c newMember = membersToInsert.get(externalId);
                    newMember.Total_Points__c += event.Survey_Score__c;
                    newMember.Last_Survey_Date__c = System.now();
                } else {
                    // Create the initial placeholder member for this transaction
                    Panel_Member__c newMember = new Panel_Member__c(
                        External_ID__c = externalId,
                        Total_Points__c = event.Survey_Score__c,
                        Last_Survey_Date__c = System.now(),
                        Name = 'Placeholder Member - ' + externalId
                    );
                    membersToInsert.put(externalId, newMember);
                }
            }
        }

        // 4. Perform DML operations using the Map values
        try {
            if (!membersToUpdate.isEmpty()) {
                update membersToUpdate.values();
            }

            if (!membersToInsert.isEmpty()) {
                insert membersToInsert.values();
            }
        } catch (DmlException e) {
            System.debug('Error processing survey submissions: ' + e.getMessage());
            throw e;
        }
    }
}
