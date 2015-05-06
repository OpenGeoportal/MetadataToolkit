(function () {
  goog.provide('gn_new_metadata_from_file_controller');


  goog.require('gn_group_service');
  goog.require('gn_code_highlight');
  goog.require('ogp_editor_service');

  var module = angular.module('gn_new_metadata_from_file_controller',
      ['blueimp.fileupload', 'gn_group_service', 'ui.bootstrap', 'gn_code_highlight', 'ogp_editor_service']);

  /**
   * Constants
   */
  module.constant('CONSTANTS', {
    'EDITOR_PROFILE': 'Editor'
  });

  module.controller('GnNewMetadataFromFileController',
      ['$scope', '$location', 'gnGroupService', '$filter', '$http', '$modal', '$log', 'OgpEditorService', 'CONSTANTS',
        function ($scope, $location, gnGroupService, $filter, $http, $modal, $log, OgpEditorService, CONSTANTS) {

          $scope.fileName = null;
          $scope.metadataId = null;

          gnGroupService.list(CONSTANTS.EDITOR_PROFILE).then(
              function (groups) {
                $scope.groups = groups;
                var first = $scope.getFirstGroupNonSpecial(groups);
                $scope.firstGroupNonSpecial = first != null ? first['@id'] : '-1'
              }, function (reason) {

              }
          );

          $scope.getFirstGroupNonSpecial = function (groups) {
            var sortedGroups = $filter('orderBy')(groups, function (obj) {
              return parseInt(obj["@id"]);
            });
            var i = 0;
            var first = null;
            while (i < sortedGroups.length && !first) {
              if (parseInt(groups[i]["@id"]) > 1) {
                first = groups[i];
              }
              i++;
            }
            return first;
          };


          var uploadXmlRecordDone = function (evt, uploader) {
            var mdId = uploader.response().result[0];
            if (mdId && mdId.lastIndexOf(';') != -1) {
              mdId = mdId.substring(0, mdId.lastIndexOf(';'));
            }
            $log.info("Metadata id created " + mdId);
            $scope.metadataId = mdId;
            OgpEditorService.setMetadataId(mdId);
            OgpEditorService.setMdFileUploaded(true);
          };

          var uploadXmlRecordError = function (evt, data) {
            $scope.metadataId = null;
            OgpEditorService.setMetadataId(null);
            OgpEditorService.setMdFileUploaded(false);
            $scope.errorText = data.response().jqXHR.responseText;
          };

          var uploadXmlStart = function (evt, data) {
            $scope.errorText = false;
            $scope.uploading = true;
          };

          /* Callback for completed (success, abort or error) upload requests. */
          var uploadXmlAlways = function (event, data) {
            $scope.uploading = false;
          };

          $scope.xmlRecordUploadOptions = {
            autoUpload: false,
            maxNumberOfFiles: 1,
            send: uploadXmlStart,
            done: uploadXmlRecordDone,
            fail: uploadXmlRecordError,
            always: uploadXmlAlways
          };

          $scope.fileNameChanged = function (fileElement) {
            OgpEditorService.setMetadataId(null);
            OgpEditorService.setMdFileUploaded(false);
            $scope.metadataId = null;
            if (fileElement.files.length != 0) {
              $scope.fileName = fileElement.files[0].name;
            } else {
              $scope.fileName = null;
            }
          };

          $scope.goToEditor = function () {
            OgpEditorService.setMdFileUploaded(true);

            /*var path = '/metadata/' + $scope.metadataId;
            $location.path(path);*/
            return $timeout(angular.noop, 500)
          };

          $scope.metadataPreview = function () {
            if (!$scope.metadataId) {
              return;
            }

            var modalInstance = $modal.open({
              templateUrl: '../../catalog/js/edit/'
              + 'partials/previewMetadadaPopup.html',
              controller: 'PreviewMetadataPopupController',
              size: 'lg',
              windowClass: 'modal-large',
              resolve: {
                metadataId: function () {
                  return $scope.metadataId;
                }
              }
            });
            
            
            


          };


        }]);
  
  module.controller('PreviewMetadataPopupController', ['$scope', '$http', '$sce', '$modalInstance', '$log', 'metadataId',
    function ($scope, $http, $sce, $modalInstance, $log, metadataId) {
      $scope.metadataId = metadataId;
      $scope.loading = true;
      $scope.error = false;
      
      // retrieve the medatata from the server
      $http.get("xml.metadata.get", {
        params: {id: $scope.metadataId}
      }).success(function(data, status, headers, config) {
        $scope.response = data;
        $scope.loading = false;
        $scope.error = false;
      }).
          error(function(data, status, headers, config) {
            $log.warn("Error retrieving metadata with id=" + $scope.metadataId);
            $scope.loading = false;
            $scope.error = true;
          });


      $scope.ok = function () {
        $modalInstance.close();
      };
      
      
    }]);

})();