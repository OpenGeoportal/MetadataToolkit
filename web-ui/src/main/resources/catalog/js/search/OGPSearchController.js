(function() {

goog.provide('ogp_search_controller');

goog.require('gn_date_picker_directive');
goog.require('gn_date_validator_directive');

var module = angular.module('ogp_search_controller',
      ['gn_date_validator_directive',
      'ui.bootstrap', 'ui.select', 'ngSanitize']);

/**
 * Controller for OpenGeoPortal search.
 */
module.controller('OgpSearchController', [
    '$scope', '$filter', '$http', '$modal',
    function($scope, $filter, $http, $modal) {
      $scope.step = 'searchForm';
      $scope.searching = false;
      $scope.noResultsFound = false;
      $scope.searchForm = {};
      $scope.topicList =[
        {"id": "farming", "label": "ogpTopicFarming"},
        {"id": "biota", "label": "ogpTopicBiota"},
        {"id": "boundaries", "label": "ogpTopicBoundaries"},
        {"id": "climatologyMeteorologyAtmosphere", "label": "ogpTopicClimatologyMeteorologyAtmosphere"},
        {"id": "economy", "label": "ogpTopicEconomy"},
        {"id": "elevation", "label": "ogpTopicElevation"},
        {"id": "environment", "label": "ogpTopicEnvironment"},
        {"id": "geoscientificinformation", "label": "ogpTopicGeoscientificInformation"},
        {"id": "health", "label": "ogpTopicHealth"},
        {"id": "imageryBaseMapsEarthCover", "label": "ogpTopicImageryBaseMapsEarthCover"},
        {"id": "intelligenceMilitary", "label": "ogpTopicIntelligenceMilitary"},
        {"id": "inlandWaters", "label": "ogpTopicInlandWaters"},
        {"id": "location", "label": "ogpTopicLocation"},
        {"id": "oceans", "label": "ogpTopicOceans"},
        {"id": "planningCadastre", "label": "ogpTopicPlanningCadastre"},
        {"id": "society", "label": "ogpTopicSociety"},
        {"id": "structure", "label": "ogpTopicStructure"},
        {"id": "transportation", "label": "ogpTopicTransportation"},
        {"id": "utilitiesCommunication", "label": "ogpTopicUtilitiesCommunication"}
       ];

      $scope.dataTypeList = [
        {"id": "POINT", "label": "ogpDataTypePOINT"},
        {"id": "LINE", "label": "ogpDataTypeLINE"},
        {"id": "POLYGON", "label": "ogpDataTypePOLYGON"},
        {"id": "RASTER", "label": "ogpDataTypeRASTER"},
        {"id": "SCANNED", "label": "ogpDataTypeSCANNED"}];

      $scope.dataRepositoryList = [
        { "id": "Tufts", "label": "Tufts"},
        { "id": "Harvard", "label": "Harvard"},
        { "id": "Berkeley", "label": "Berkeley"},
        { "id": "MIT", "label": "MIT"},
        { "id": "MassGIS", "label": "MassGIS"},
        { "id": "Columbia", "label": "Columbia"}
        ];

      $scope.triggerSearch = function() {
        //Validate input form.
        $scope.searching = true;
        $scope.step = "searchResults";
        // Do search

        var formBean = $scope.processSearchForm();

        $http.post("ogp.dataTypes.search", formBean).
          success(function(data, status, headers, config){
            if (data && data.response) {
              $scope.response = data.response;
            }
            if (data && data.response && data.response.docs) {
              $scope.searchResults = data.response.docs;
            }
            if (data && data.response && data.response.numFound == 0) {
              $scope.noResultsFound = true;
            }
            console.log(data);
            $scope.searching = false;
          }).
          error(function(data, status, headers, config){
            console.log(data);
            $scope.searching = false;
            //log error
          });
      };

      $scope.reviseSearch = function() {
        $scope.searchResults = [];
        $scope.searching = false;
        $scope.step ="searchForm";
        $scope.noResultsFound = false;
        $scope.response = null;
      };

      $scope.newSearch = function() {
        $scope.searchResults = [];
        $scope.searching = false;
        $scope.noResultsFound = false;
        $scope.searchForm = {};
        $scope.step ="searchForm";
        $scope.response = null;
      };

      $scope.processSearchForm = function() {
        var copy = angular.copy($scope.searchForm);
        if (copy.topic) {
          copy.topic = $scope.getPropertyFromObjectArray(copy.topic, 'id');
        }
        if (copy.dataType) {
          copy.dataType = $scope.getPropertyFromObjectArray(copy.dataType, 'id');
        }
        if (copy.dataRepository) {
          copy.dataRepository = $scope.getPropertyFromObjectArray(copy.dataRepository, 'id');
        }

        return copy;
      };

      $scope.getPropertyFromObjectArray = function(dataset, property) {
        var out = [];
        for (var i = 0; i < dataset.length; i++) {
          var item = dataset[i];
          if (item) {
            out.push(item[property]);
          }
        }
        return out;
      };

      $scope.openMetadata = function(item) {
        console.log(item);
        var modalInstance = $modal.open({
          templateUrl: '../../catalog/js/search/'
            + 'partials/ogpMetadataPopup.html',
          controller: 'OgpMetadataPopupController',
          size: 'lg',
          windowClass: 'modal-large',
          resolve: {
            document: function() {
              return item;
            }
          }

        });
      };


    }]);

module.controller('OgpMetadataPopupController', ['$scope', '$http', '$sce','$modalInstance', 'document',
function($scope, $http, $sce, $modalInstance, document) {
    $scope.document = document;

    $scope.ok = function () {
      $modalInstance.close();
    };
    $scope.layerId = $scope.document.LayerId;
    $scope.metadataUrl = $sce.trustAsResourceUrl("ogp.dataTypes.getMetadata?layerId="+  $scope.layerId);


    // retrieve the medatata from the server
   /* $http.get("ogp.dataTypes.getMetadata", {
      params: {layerId: $scope.document.LayerId}
    }).success(function(data, status, headers, config) {
        $scope.response = data;
    }).
    error(function(data, status, headers, config) {
      console.log("Error retrieving metadata")
    });
*/

}]);

module.directive('iframeSetDimentionsOnload', [function(){
       return {
           restrict: 'A',
           link: function(scope, element, attrs){
               element.on('load', function(){
                   /* Set the dimensions here,
                      I think that you were trying to do something like this: */
                      var iFrameHeight = element[0].contentWindow.document.body.scrollHeight + 'px';
                      var iFrameWidth = '100%';
                      element.css('width', iFrameWidth);
                      element.css('height', iFrameHeight);
               })
           }
       }}])

})();