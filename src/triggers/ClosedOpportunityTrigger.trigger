/**
 * Created by rvivek on 2/9/2018.
 */

trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    List<Task> tasks = new List<Task>();
    Map<Id,Opportunity> opportunitiesByIds = null;
if(Trigger.isInsert){
    opportunitiesByIds =
            new Map<Id,Opportunity>([Select Id,StageName from Opportunity where StageName='Closed Won' and Id IN :Trigger.New ]);

}else{
    Map<Id,Task> existingTasks = new Map<Id,Task>([Select WhatId,Subject from Task where Subject='Follow Up Test Task' and WhatId IN :Trigger.New ]);
    opportunitiesByIds =
            new Map<Id,Opportunity>([Select Id,StageName from Opportunity where StageName='Closed Won' and Id IN :Trigger.New
            and Id NOT in :existingTasks.keySet()]);
}

    for (Id id : opportunitiesByIds.keySet()) {
        tasks.add(new Task(WhatId=id,Subject='Follow Up Test Task'));
    }

    insert tasks;
}