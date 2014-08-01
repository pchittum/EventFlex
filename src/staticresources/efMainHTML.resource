<div ng-show="isLoading">LOADING</div>
<section class="section" ng-show="!isLoading">
	<header class="page-header page-header-anchor context-c-ticket">
		<div class="container">
			<h1>Events</h1>
		</div>
	</header>
	<section class="well well-lg" ng-repeat="event in events">
		{{event._props.Name}} | {{event._props.Start_date_time__c | date : 'H:mm dd MMM yy'}} - {{event._props.End_date_time__c | date : 'H:mm dd MMM yy'}} - <a href="#/session/{{event._props.Id}}">view</a> | <a href="/{{event._props.Id}}">debug</a> | <button ng-click="toggleModal()">Show Modal</button>
	</section>
</section class="section">

<!--
<ul ng-show="!isLoading">
	<li ng-repeat="event in events">{{event._props.Name}} | {{event._props.Start_date_time__c | date : 'H:mm dd MMM yy'}} - {{event._props.End_date_time__c | date : 'H:mm dd MMM yy'}} - <a href="#/session/{{event._props.Id}}">view</a> | <a href="/{{event._props.Id}}">debug</a> | <button ng-click="toggleModal()">Show Modal</button></li>
</ul>
<div><a href="#/session/{{toSession}}">Go To Session</a></div>
<modal-dialog show="modalShown" width="600px" height="50%">
	<p>this is modal content</p>
</modal-dialog>

<div>
	{{test}}
	{{sessionId}}
	whatever
</div>
-->