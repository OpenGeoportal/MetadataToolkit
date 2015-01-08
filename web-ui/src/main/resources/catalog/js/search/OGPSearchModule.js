(function() {

goog.provide('ogp_search');

goog.require('gn');
goog.require('ogp_search_controller');

var module = angular.module('ogp_search',
      ['gn',
      'ogp_search_controller']);

//Define the translation files to load
module.constant('$LOCALES', ['ogpSearch']);

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


})();