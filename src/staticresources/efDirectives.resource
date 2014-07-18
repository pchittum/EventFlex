eventFlex.directive('modalDialog', function(){
	return {
		restrict : 'E',
		scope: {
			show : '=',
			modaltitle : '='
		},
		replace: true, 
		transclude: true,
		link: function(scope, element, attrs){
			scope.dialogStyle = {};
			if (attrs.width) scope.dialogStyle.width = attrs.width;
			if (attrs.height) scope.dialogStyle.height = attrs.width;
			scope.hideModal = function() {
				scope.show = false;
			}
		},
		templateUrl: staticItems['efModalTemplateHTML']
	};
});


eventFlex.directive('efContent', function(){
	return {
		restrict : 'A',
		scope: {
			templateurl : '=',
			item: '=' 
		},
		replace: true, 
		link: function(scope, element, attrs){
			console.debug(scope.templateurl);
		},
		templateUrl:staticItems['efSessionModalHTML']
	};
});