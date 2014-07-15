<div ng-show="isLoading">LOADING</div>
<ul ng-show="!isLoading">
	<li ng-repeat="session in sessions">{{session._props.Name}}</li>
</ul>

<gantt template-url="staticItems[ganttTemplate]" data="ganttData"></gantt>

<a href="#/">Go Back</a>
<div>
	{{test}}
	{{sessionId}}
	blah
</div>