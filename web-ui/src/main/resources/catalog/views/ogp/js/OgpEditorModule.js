/**
 * Created by JuanLuis on 07/04/2015.
 */
(function() {
  goog.provide('ogp_editor');

  goog.require('gn_module');
  goog.require('ogp_editor_controller');
  goog.require('ogp_editor_service');

  var module = angular.module('ogp_editor', [
    'gn_module', 'ogp_editor_controller']);

  // Define the translation files to load
  module.constant('$LOCALES', ['ogp']);

  module.constant('gnViewerSettings', {});

  module.config(['$translateProvider', '$LOCALES',
    function($translateProvider, $LOCALES) {
      $translateProvider.useLoader('localeLoader', {
        locales: $LOCALES,
        prefix: '../../catalog/views/ogp/locales/',
        suffix: '.json'
      });

      var lang = location.href.split('/')[5].substring(0, 2) || 'en';
      $translateProvider.preferredLanguage(lang);
      moment.lang(lang);
    }]);
})();
