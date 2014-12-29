(function() {
  goog.provide('gn_new_metadata_from_file_controller');


  goog.require('gn_group_service');

  var module = angular.module('gn_new_metadata_from_file_controller',
    ['blueimp.fileupload', 'gn_group_service']);

      /**
       * Constants
       */
     module.constant('CONSTANTS', {
        'EDITOR_PROFILE': 'Editor'
    });

   module.controller('GnNewMetadataFromFileController',
    ['$scope', '$rootScope', '$routeParams', '$location', '$translate', 'gnGroupService', '$filter', 'CONSTANTS',
    function($scope, $rootScope, $routeParams, $location, $translate, gnGroupService, $filter, CONSTANTS){

    $scope.fileName = null;

    gnGroupService.list(CONSTANTS.EDITOR_PROFILE).then(
        function(groups) {
              $scope.groups = groups;
              var first = $scope.getFirstGroupNonSpecial(groups) ;
              $scope.firstGroupNonSpecial = first != null ? first['@id']: '-1'
            }, function(reason) {

        }
    );

    $scope.getFirstGroupNonSpecial = function(groups) {
        var sortedGroups = $filter('orderBy')(groups, function(obj) {
            return parseInt(obj["@id"]);
        });
        var i = 0;
        var first = null;
        while(i < sortedGroups.length && !first) {
            if (parseInt(groups[i]["@id"]) > 1) {
                first = groups[i];
            }
            i++;
        }
        return first;
    };


    var uploadXmlRecordDone = function(evt, uploader) {
        var mdId = uploader.response().result[0];
        if (mdId && mdId.lastIndexOf(';') != -1) {
            mdId = mdId.substring(0, mdId.lastIndexOf(';'));
        }
        console.info("Metadata id created " + mdId);
        $scope.metadataId = mdId;
    };

    var uploadXmlRecordError = function(evt, data) {
       /* $rootScope.$broadcast('StatusUpdated', {
                  title: $translate('xmlRecordUploadError'),
                  error: data.jqXHR.responseJSON,
                  timeout: 0,
                  type: 'danger'});*/
        $scope.errorText = data.response().jqXHR.responseText;
    };

    var uploadXmlStart = function(evt, data) {
        $scope.errorText = false;
        $scope.uploading = true;
    };

    /* Callback for completed (success, abort or error) upload requests. */
    var uploadXmlAlways = function(event, data) {
        $scope.uploading = false;
    };

    $scope.xmlRecordUploadOptions = {
        autoUpload: true,
        send: uploadXmlStart,
        done: uploadXmlRecordDone,
        fail: uploadXmlRecordError,
        always: uploadXmlAlways
    };

    $scope.fileNameChanged = function(fileElement) {
        $scope.metadataId = null;
        if(fileElement.files.length != 0) {
            $scope.fileName = fileElement.files[0].name;
        } else {
            $scope.fileName = null;
        }
    };

    $scope.goToEditor = function() {
        var path = '/metadata/' + $scope.metadataId;
        $location.path(path);
    };



   }]);

})();