global with sharing class EventFlexServices {
	@remoteAction
	global static Map<String, List<Topic>> getSessionTopics(String eventId){

		List<TopicAssignment> topicAssigments = new List<TopicAssignment>();
		Map<String, List<Topic>> temp = new Map<String, List<Topic>>();

		for(TopicAssignment ta : [select id, TopicId, EntityId, Topic.Description, Topic.Name, Topic.TalkingAbout from TopicAssignment where EntityId in (select id from Session__c where Event__c = : eventId)]){
			Topic tt = new Topic(id = ta.TopicId, Description = ta.topic.Description, Name = ta.Topic.Name);

			if(temp.containsKey(ta.EntityId)){
				temp.get(ta.EntityId).add(tt);
			}else{
				temp.put(ta.EntityId, new List<Topic>{tt});
			}
		}

		return temp;
	}

	@remoteAction
	global static Map<String, List<Speaker__c>> getSessionSpeakers(String eventId){

		
		Map<String, List<Speaker__c>> temp = new Map<String, List<Speaker__c>>();

		for(Speaker_Slot__c sl : [select id, Speaker_Name__c, Speaker__r.Speaker_Name__c, Speaker__r.Biography__c, Session__c, Speaker__r.Contact__c, Speaker__r.Contact__r.Name, Speaker__r.Contact__r.twitter_user__c, Speaker__c from Speaker_Slot__c where Session__r.Event__c = :eventId]){
			Speaker__c s = new Speaker__c(id = sl.Speaker__c, Speaker_Name__c = sl.Speaker__r.Speaker_Name__c, Biography__c = sl.Speaker__r.Biography__c, Contact__c = sl.Speaker__r.Contact__c);

			if(temp.containsKey(sl.Session__c)){
				temp.get(sl.Session__c).add(s);
			}else{
				temp.put(sl.Session__c, new List<Speaker__c>{s});
			}
		}

		return temp;
	}

}