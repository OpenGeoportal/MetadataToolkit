(function() {

  goog.provide('ogp_login_controller');


  goog.require('gn_catalog_service');
  goog.require('gn_utility');
  goog.require('gn_utility_directive');
  goog.require('gn_show_errors_directive');
  goog.require('validation.match');

  var module = angular.module('ogp_login_controller', [
    'gn_utility',
    'gn_catalog_service',
    'gn_show_errors_directive',
    'validation.match',
    'gn_utility_directive'
  ]);

  /**
   *    Take care of login action, reset and update password.
   */
  module.controller('OgpLoginController',
      ['$scope', '$http', '$rootScope', '$translate',
       '$location', '$window', '$timeout',
       'gnUtilityService', 'gnConfig', '$q',
       function($scope, $http, $rootScope, $translate, 
           $location, $window, $timeout,
               gnUtilityService, gnConfig, $q) {
          $scope.registerForm = {
            'password': null,
            'repeatPassword': null
          };
          $scope.registrationStatus = null;
          $scope.gnConfig = gnConfig;


          // TODO: https://github.com/angular/angular.js/issues/1460
          // Browser autofill does not work properly
          $timeout(function() {
            $('input[data-ng-model], select[data-ng-model]').each(function() {
              angular.element(this).controller('ngModel')
                .$setViewValue($(this).val());
            });
          }, 300);


         /**
          * Register user. An email will be sent to the new
          * user and another to the catalog admin if a profile
          * higher than registered user is requested.
          */
         $scope.register = function() {
           $scope.registrationStatus = null;

           $scope.$broadcast('show-errors-check-validity');
           if ($scope.userinfo.$invalid) {
             return $q(function(resolve) {
               $timeout(function() {
                 resolve('fields not valid');
                 });
               }, 1000);
           }

          return $http.post('ogp.create.account', $scope.registerForm)
          .success(function(data) {
             $scope.registrationStatus = data;
           })
          .error(function(data) {
             $rootScope.$broadcast('StatusUpdated', {
               title: $translate('registrationError'),
               error: data,
               timeout: 0,
               type: 'danger'});
           });
         };
       }]);

})();
