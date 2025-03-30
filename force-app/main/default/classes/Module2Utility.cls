public with sharing class Module2Utility {

    public static Unresolved_Item__c createUnresolvedItem(String itemName, String obj, String method, String description, Id ownerId) {
        description = description.length() > 131072 ? description.substring(0, 131072) : description;
        Unresolved_Item__c item = new Unresolved_Item__c(
            Name = itemName,
            Object__c = obj,
            Method__c = method,
            Description__c = description,
            Owner__c = ownerId
        );
        return item;
    }
    public static void debugException(Exception e) {
        System.debug(LoggingLevel.ERROR, '*** Exception occured!!***');
        System.debug(LoggingLevel.ERROR,'Exception Type caught: ' + e.getTypeName());
        System.debug(LoggingLevel.ERROR,'Message: ' + e.getMessage());
        System.debug(LoggingLevel.ERROR,'Cause: ' + e.getCause());
        System.debug(LoggingLevel.ERROR,'Line Number: ' + e.getLineNumber());
        System.debug(LoggingLevel.ERROR,'Stack trace: ' + e.getStackTraceString());
    }
}