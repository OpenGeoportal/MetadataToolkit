(function(){
    goog.provide('gn_group_service');

    var module = angular.module('gn_group_service', []);

    module.factory('gnGroupService', [
        '$q',
        '$rootScope',
        '$http',
        '$log',
        function($q, $rootScope, $http, $log) {

            /**
             * Get the list of groups for the requested profile, if passed as parameter.
             */
            var listFn = function(profile) {
                var url = 'info@json?type=groupsIncludingSystemGroups';
                if (profile) {
                    url = 'info@json?type=groups&profile=' + profile;
                }
                var defer = $q.defer();
                $http.get(url, {cache: true}).
                    success(function(data, status){
                        var groups = data !== 'null' ? data.group : null;
                        defer.resolve(groups);

                    }).
                    error(function(data, status){
                        defer.reject(data);
                        $log.warn('Cannot get the group lists');
                    });
                return defer.promise;
            };


            return {
                list: listFn
            };
        }
    ]);
  }
)();