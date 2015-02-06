(function() {
  goog.provide('gn_date_validator_directive');

  var module = angular.module('gn_date_validator_directive', []);

  /**
     * @ngdoc directive
     * @name gn_date_validator_directive.directive:gnValidatorDirective
     * @restrict A
     *
     * @description
     *
     * Validate if the user input match a date pattern. If it doesn't set the model to null
     *
     */
     module.directive('gnDateValidator', [
        function(){
          return {
            restrict: 'A',
            require: ['ngModel', '^form'],
            scope: {
              gnDateFormat: '@',
              model: '=ngModel',
              id: '=gnId',
              gnUseParsedDateInModel: '='
            },
            templateUrl: '../../catalog/components/edit/datevalidator/partials/' +
                        'datevalidator.html',
            link: function(scope, elem, attr, required) {
              var ngModel = required[0];
              var formCtrl = required[1];
              var inputEl   = elem[0].querySelector("[name]");
              // convert the native text box element to an angular element
              var inputNgEl = angular.element(inputEl);

              // only apply the has-error class after the user leaves the text box
              inputNgEl.bind('blur', function() {
                elem.toggleClass('has-error', formCtrl[scope.id].$invalid);
              });


              if (!scope.gnDateFormat) {
                scope.gnDateFormat = 'YYYY-MM-DD';
              }
              var validate = function(dateString, format) {
                var isValid = moment(dateString, format).isValid();
                 return isValid;
              };

              scope.$watch('inputString', function(newVal) {
                if (newVal && newVal.trim() !== "") {
                  ngModel.$setValidity('validDate', validate(newVal, scope.gnDateFormat));
                } else {
                  ngModel.$setValidity('validDate', true);
                }
                scope.buildDate();
              });

              scope.$watch('model', function(newVal){
                if (newVal) {
                  var dateTime = moment(newVal);
                  var format = scope.gnDateFormat;
                  var formattedDate = dateTime.format(format);
                  if (formattedDate !== scope.inputString) {
                    scope.inputString = formattedDate;
                  }
                } else {
                  scope.inputString = null;
                }
              });

              // Format date when datetimepicker is used.
              scope.formatFromDatePicker = function(date) {
                var format = scope.gnDateFormat;
                var dateTime = moment(date);
                scope.inputString = dateTime.format(format);
              };


              scope.buildDate = function() {
                if (scope.inputString === undefined) {
                  scope.model = null;
                  return;
                }

                var parsedDate = moment(scope.inputString, scope.gnDateFormat)
                if (parsedDate && parsedDate.isValid()) {
                  scope.dateFromDropdown = parsedDate.toDate();
                  if (scope.gnUseParsedDateInModel) {
                    scope.model = parsedDate;

                  } else {
                    scope.model = scope.inputString;
                  }
                } else {
                  scope.model = null;
                }
              };
            } // end link function
        };
     }]);

})();
