(function() {

goog.provide('ogp_search_controller');

goog.require('gn_date_picker_directive');
goog.require('gn_date_validator_directive');

var module = angular.module('ogp_search_controller',
      ['ui.bootstrap.datetimepicker', 'gn_date_validator_directive',
      'ui.bootstrap', 'ui.select']);

/**
 * Controller for OpenGeoPortal search.
 */
module.controller('OgpSearchController', [
    '$scope', '$filter',
    function($scope, $filter) {
      $scope.test="my test";
      $scope.searchForm = {};
      $scope.topicList = [
        { "id": "1", "label": "Topic 1"},
        { "id": "2", "label": "Topic 2"},
        { "id": "3", "label": "Topic 3"},
        { "id": "4", "label": "Topic 4"},
        { "id": "5", "label": "Topic 5"},
        { "id": "6", "label": "Topic 6"},
        { "id": "7", "label": "Topic 7"},
        { "id": "8", "label": "Topic 8"},
        { "id": "9", "label": "Topic 9"},
        { "id": "10", "label": "Topic 10"},
        { "id": "11", "label": "Topic 11"}
      ];

      $scope.dataTypeList = [
        { "id": "1", "label": "Data type 1"},
        { "id": "2", "label": "Data type 2"},
        { "id": "3", "label": "Data type 3"},
        { "id": "4", "label": "Data type 4"},
        { "id": "5", "label": "Data type 5"},
        { "id": "6", "label": "Data type 6"},
        { "id": "7", "label": "Data type 7"},
        { "id": "8", "label": "Data type 8"},
        { "id": "9", "label": "Data type 9"},
        { "id": "10", "label": "Data type 10"},
        { "id": "11", "label": "Data type 11"}
      ];
      $scope.dataRepositoryList = [
        { "id": "1", "label": "Data repository 1"},
        { "id": "2", "label": "Data repository 2"},
        { "id": "3", "label": "Data repository 3"},
        { "id": "4", "label": "Data repository 4"},
        { "id": "5", "label": "Data repository 5"},
        { "id": "6", "label": "Data repository 6"},
        { "id": "7", "label": "Data repository 7"},
        { "id": "8", "label": "Data repository 8"},
        { "id": "9", "label": "Data repository 9"},
        { "id": "10", "label": "Data repository 10"},
        { "id": "11", "label": "Data repository 11"}
        ];



    }]);








})();