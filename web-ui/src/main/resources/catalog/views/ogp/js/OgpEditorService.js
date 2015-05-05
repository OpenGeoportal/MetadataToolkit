(function() {
  goog.provide('ogp_editor_service');

  var module = angular.module('ogp_editor_service', []);

  module.factory('OgpEditorService', ['$rootScope', function($rootScope) {
    var _step;
    var _metadataId;
    var _mdFileUploaded = false;
    var _ogpImportedMdId;

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
    }




    return service;
  }]);


})();