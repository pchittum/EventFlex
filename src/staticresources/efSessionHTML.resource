<style>
	.gantt-row-height {
		height: 3em;
	}
</style>
<div ng-show="isLoading">LOADING</div>
<div ng-show="!isLoading">
<div class="navbar navbar-inverse">
  <div class="navbar-header navbar-brand">
    {{eventName}}
  </div>
</div>
<div>
  Group By
  <div class="btn-group">
    <button ng-repeat="grp in groupByOptions" class="btn btn-default" ng-click="refreshGrid(grp)">{{grp.Label}}</button>
  </div>
</div>

<gantt first-day-of-week="1"
           load-data="loadGanttData = fn"
           remove-data="removeData = fn"
           clear-data="clearGanttData = fn"
           sort-mode="mode"
           view-scale="scale"
           column-width="scale === 'month' && 20 || (scale === 'week' && 10 || 4)"
           column-sub-scale="scale === 'week' && 7 || 6"
           work-hours="[8,9,10,11,12,13,14,15,16,17]"
           show-non-work-hours="showNonWorkHours"
           weekend-days="[0,6]"
           show-weekends="showWeekends"
           show-tooltips="false"
           max-height="maxHeight"
           on-gantt-ready="addSamples()"
           on-label-clicked="labelEvent(event)"
           on-label-dbl-clicked="labelEvent(event)"
           on-label-context-clicked="labelEvent(event)"
           on-label-header-clicked="labelHeaderEvent(event)"
           on-label-header-dbl-clicked="labelHeaderEvent(event)"
           on-label-header-context-clicked="labelHeaderEvent(event)"
           on-row-added="rowEvent(event)"
           on-row-clicked="rowEvent(event)"
           on-row-dbl-clicked="rowEvent(event)"
           on-row-context-clicked="rowEvent(event)"
           on-row-updated="rowEvent(event)"
           on-scroll="scrollEvent(event)"
           on-task-clicked="taskEvent(event)"
           on-task-dbl-clicked="taskEvent(event)"
           on-task-context-clicked="taskEvent(event)"
           on-task-updated="taskEvent(event)"
           template-url="/resource/1405341046000/efLibs/angular-gantt/template/gantt.tmpl.html">
</gantt>
<modal-dialog show="modalShown" width="600px" height="50%" modaltitle="sessionDetails._props.Name">
  <div ef-content="" templateurl="modalURL" item="sessionDetails"></div>
</modal-dialog>
<!-- template-url="/resource/1405341046000/efLibs/angular-gantt/template/gantt.tmpl.html -->
<a href="#/">Go Back</a>
<div ng-show="false">
	{{test}}
	{{sessionId}}
	blah
  </div>
</div>