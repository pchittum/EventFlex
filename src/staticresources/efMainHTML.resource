<div ng-show="isLoading">LOADING</div>
<ul ng-show="!isLoading">
	<li ng-repeat="event in events">{{event._props.Name}} | {{event._props.Start_date_time__c | date : 'H:mm dd MMM yy'}} - {{event._props.End_date_time__c | date : 'H:mm dd MMM yy'}} - <a href="#/session/{{event._props.Id}}">view</a> | <a href="/{{event._props.Id}}">debug</a> | <button ng-click="toggleModal()">Show Modal</button></li>
</ul>
<div><a href="#/session/{{toSession}}">Go To Session</a></div>
<modal-dialog show="modalShown" width="500px" height="60%">
	<p>this is modal content</p>
</modal-dialog>

<div>
	{{test}}
	{{sessionId}}
	whatever
</div>