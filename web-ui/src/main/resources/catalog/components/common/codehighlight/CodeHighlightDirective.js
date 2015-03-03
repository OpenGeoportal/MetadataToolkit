(function () {
  goog.provide('gn_code_highlight_directive');

  var module = angular.module('gn_code_highlight_directive',
      []);

  /**
   * WARNING: this directive require Prismjs library to be loaded and prismjs.css to be linked.
   * http://prismjs.com/
   */
  module.directive('gnCodeHighlight', ['$compile', '$timeout', '$log', function ($compile, $timeout, $log) {
    return {
      restrict: 'A',
      transclude: true,
      scope: {
        source: '=?',
        code: '@'
      },
      link: function (scope, element, attrs, controller, transclude) {
        if (!Prism) {
          $log.warn("gnCodeHighlight directive requires Prismjs highligh library to be present");
          return;
        }
        scope.$watch('source', function (v) {
          element.find("code").text(v);

          Prism.highlightElement(element.find("code")[0]);
        });
        var c;
        transclude(function (clone) {
          if (clone.html() !== undefined) {
            c = clone.html();
            element.find("code").html(c);
            $compile(element.contents())(scope.$parent);
          }
        });
        scope.$watch('code', function (v) {

          element.find("code").html(c);
          $compile(element.contents())(scope.$parent);
          $timeout(function () {
            Prism.highlightElement(element.find("code")[0]);
          });
        });
      },
      template: "<code></code>"
    };
  }]);
})();