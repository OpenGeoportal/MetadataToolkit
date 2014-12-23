(function() {
  goog.provide('gn_login');

  goog.require('gn');
  goog.require('gn_login_controller');

  var module = angular.module('gn_login', [
    'gn',
    'gn_login_controller'
  ]);

  //Define the translation files to load
  module.constant('$LOCALES', ['core']);

  module.config(['$translateProvider', '$LOCALES',
                 function($translateProvider, $LOCALES) {
      $translateProvider.useLoader('localeLoader', {
        locales: $LOCALES,
        prefix: '../../catalog/locales/',
        suffix: '.json'
      });


      var lang = location.href.split('/')[5].substring(0, 2) || 'en';
      $translateProvider.preferredLanguage(lang);
      moment.lang(lang);
    }]);
})();
