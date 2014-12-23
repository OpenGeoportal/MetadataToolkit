(function() {
  goog.provide('gn_new_metadata_from_file_controller');

  var module = angular.module('gn_new_metadata_from_file_controller',
    ['blueimp.fileupload']);

   module.controller('GnNewMetadataFromFileController',
    ['$scope', '$rootScope', '$routeParams', '$translate',
    function($scope, $rootScope, $routeParams, $translate){

    $scope.fileName = null;

    var uploadXmlRecordDone = function(data) {
        console.info("file uploaded");
    };

    var uploadXmlRecordError = function(e, data) {
        $rootScope.$broadcast('StatusUpdated', {
                  title: $translate('xmlRecordUploadError'),
                  error: data.jqXHR.responseJSON,
                  timeout: 0,
                  type: 'danger'});
        console.error("Error uploading XML register: " + e);
        console.error("Data: " + data);
    };

    $scope.xmlRecordUploadOptions = {
        autoUpload: true,
        done: uploadXmlRecordDone,
        fail: uploadXmlRecordError
    };

    $scope.fileNameChanged = function(fileElement) {
        if(fileElement.files.length != 0) {
            $scope.fileName = fileElement.files[0].name;
        } else {
            $scope.fileName = null;
        }
    };



   }]);

})();