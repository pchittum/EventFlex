eventFlex.service('efSERVICES', function(){
         return{
            getAllEvents : function(callback){
             	var data = new SObjectModel.evt();
               // var whereOb = { where : {OwnerId : {eq:uId}}};
               
                data.retrieve({},function(err, records){
                    //if failure
                    if(err) alert(err.message);
                    else {
                        console.debug(records);
                        callback(records);       
                    }
                });
            },
            getSessionTopics : function(eventId, callback){
                 Visualforce.remoting.Manager.invokeAction(staticItems['getSessionTopics'],eventId, function(result, event){
                    if( event.status ) {
                        callback(result);
                    }
                });
            },
            getSessionSpeakers : function(eventId, callback){
                Visualforce.remoting.Manager.invokeAction(staticItems['getSessionSpeakers'],eventId, function(result, event){
                    if( event.status ) {
                        callback(result);
                    }
                });
            },
            getProfile : function(){

            },
            getSessionDetails : function(){

            },
            enhanceData : function(sourceData, newData, key){
                
                for(var i=0; i<sourceData.length; i++){
                    var sourceKey = sourceData[i]._props.Id;

                    if(newData[sourceKey]!=null){
                        sourceData[i][key] = newData[sourceKey];
                    }

                }

                return sourceData;

            },
            groupDataByArray : function(dataArr, Arr, ArrProperty){
                var tempOb = {};
                var retArr = [];

                for(var i=0; i<dataArr.length; i++){
                    var dataOb = dataArr[i];
                    if(dataOb[Arr]!=null){
                        for(var x=0; x<dataOb[Arr].length; x++){
                            var tempArrVal = dataOb[Arr][x];
                            var tempArrKey = tempArrVal[ArrProperty];

                            if(tempOb[tempArrKey] == null){
                                tempOb[tempArrKey] = [dataOb];
                            }else{
                                 tempOb[tempArrKey].push(dataOb);
                            }

                        }
                    }

                }

                angular.forEach(tempOb, function(value, key){
                    retArr.push({'key' : key, data : value});
                });

                return retArr;

            },
            groupDataByProperty : function(dataArr, property){
                var retArr = [];
                var tempOb = {};
                // [{key:'ABC' : {data : [], properties : {}}];
                for(var i=0; i<dataArr.length; i++){
                    console.debug(dataArr[i]['_props'][property]);
                    var key = dataArr[i]['_props'][property];

                    if(tempOb[key] == null){
                        tempOb[key] = [dataArr[i]];
                    }else{
                        tempOb[key].push(dataArr[i]);
                    }
                    console.debug(tempOb[key]);
                }
                angular.forEach(tempOb, function(value, key){
                    retArr.push({'key' : key, data : value});
                });

                console.debug(retArr);
                return retArr;
            },
            getSessionsForEvent : function(eventId, callback){
            	var data = new SObjectModel.session();
            	var whereOb = { where : {Event__c : {eq:eventId}}};

            	data.retrieve(whereOb,function(err, records){
                    //if failure
                    if(err) alert(err.message);
                    else {
                        console.debug(records);
                        callback(records);       
                    }
                });
            }
         }
       });