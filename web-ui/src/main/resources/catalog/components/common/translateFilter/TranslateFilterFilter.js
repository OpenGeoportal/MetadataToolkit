(function(){
goog.provide('gn_translatefilter_filter');

var module = angular.module('gn_translatefilter_filter', []);

/**
 * Like the original AngularJS 'filter' but search in the internationalized version of the keys.
 */
module.filter('gnTranslateFilter', ['$translate',
    function($translate) {
      return function(input, param) {
        if(!param){
          return input;
        }
        var searchVal = param.key.toLowerCase();
        var result = [];
        angular.forEach(input, function(value){
          var translated = $translate(value.key);
          if(translated.toLowerCase().indexOf(searchVal)!== -1) {
            result.push(value);
          }
        });
        return result;
      };


    }]);


})();