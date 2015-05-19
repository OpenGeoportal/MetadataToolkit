(function() {
  goog.provide('ogp_editor_service');

  var module = angular.module('ogp_editor_service', []);

  module.factory('OgpEditorService', ['$rootScope', '$http', '$q', function($rootScope, $http, $q) {
    var _step = null;
    var _metadataId = null;
    var _mdFileUploaded = false;
    var _ogpImportedMdId = null;

    var service = {};
    service.getStep = function() {
      return _step;
    };

    service.setStep = function(step) {
      var oldStep = _step;
      _step = step;
      $rootScope.$broadcast('ogpEditorStepChanged', step, oldStep);
    };

    service.getMetadataId = function() {
      return _metadataId;
    };

    service.setMetadataId = function(mdId) {
      var oldMdId = _metadataId;
      _metadataId = mdId;
      $rootScope.$broadcast('ogpEditorMdIdChanged', mdId, oldMdId);
    };

    service.getMdFileUploaded = function() {
      return _mdFileUploaded;
    };
    service.setMdFileUploaded = function (mdFileUploaded) {
      var oldMdFileUploaded = _mdFileUploaded;
      _mdFileUploaded = mdFileUploaded;
      $rootScope.$broadcast('ogpEditorMdFileUploaded', mdFileUploaded, oldMdFileUploaded);
    };

    service.setOgpImportedMdId = function (ogpImportedMdId) {
      var oldOgpImportedMdId = _ogpImportedMdId;
      _ogpImportedMdId = ogpImportedMdId;
      $rootScope.$broadcast('ogpImportedMdIdChanged', ogpImportedMdId, oldOgpImportedMdId);
    };

    service.getOgpImportedMdId = function() {
      return _ogpImportedMdId;
    };

    /**
     * Reset the service state.
     */
    service.reset = function() {
      _step = null;
      _metadataId = null;
      _mdFileUploaded = false;
      _ogpImportedMdId = null;

      return $http.get("ogp.edit.clearStatus");

    };

    service.createMetadata = function(group, templateId, datasetImported, localRecordImported, ogpRecordImported) {
      var deferred = $q.defer();
      var params = {
        group: group,
        templateId: templateId,
        datasetImported: datasetImported,
        localRecordImported: localRecordImported,
        ogpRecordImported: ogpRecordImported
      }
      $http.post('ogp.edit.doImport', params).
          success(function(data, status, headers, config) {
            deferred.resolve(data);
          }).error(function(data, status, headers, config) {
            var cause = data;
            if (data && data.error) {
              cause = data.error;
            }
            deferred.reject(cause);
          });
      return deferred.promise;
    } ;




    return service;
  }]);


})();