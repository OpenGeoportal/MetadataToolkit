(function () {
  goog.provide('gn_fields_directive');

  goog.require('gn_metadata_manager_service');

  var module = angular.module('gn_fields_directive',
      []);

  /**
   * Note: ng-model and angular checks could not be applied to
   * the editor form as it would require to init the model
   * from the form content using ng-init for example.
   */
  module.directive('gnCheck',
      function () {
        return {
          restrict: 'A',
          link: function (scope, element, attrs) {

            // Required attribute
            if (attrs.required) {
              element.keyup(function () {
                if ($(this).get(0).value == '') {
                  $(attrs.gnCheck).addClass('has-error');
                } else {
                  $(attrs.gnCheck).removeClass('has-error');
                }
              });
              element.keyup();
            }
          }
        };
      });

  /**
   * @ngdoc directive
   * @name gn_fields.directive:gnFieldTooltip
   * @function
   *
   * @description
   * Initialized field label or fieldset legend tooltip
   * based on the tooltip configuration.
   *
   * If the element is input or textarea, the event to open
   * the tooltip is on focus, if not, the event is on click.
   *
   * @param {string} gnFieldTooltip The tooltip configuration
   *  which identified the schema, the element name and optionally the
   *  element parent name and XPath. eg. 'iso19139|gmd:fileIdentifier'.
   *
   * @param {string} placement Tooltip placement. Default to 'bottom'
   * See {@link http://getbootstrap.com/javascript/#tooltips}
   *
   *
   * @example
   <example>
   <file name="index.html">
   <label for="gn-field-3"
   data-gn-field-tooltip="iso19139|gmd:fileIdentifier|gmd:MD_Metadata|
   /gmd:MD_Metadata/gmd:fileIdentifier"
   data-placement="left">File identifier</label>
   </file>
   </example>
   */
  module.directive('gnFieldTooltip',
      ['gnSchemaManagerService', 'gnCurrentEdit', '$compile',
        function (gnSchemaManagerService, gnCurrentEdit, $compile) {
          var iconTemplate = "<a class='btn field-tooltip'><span class='fa fa-question-circle'></span></a>";

          return {
            restrict: 'A',
            link: function (scope, element, attrs) {
              var isInitialized = false;
              var stopEventBubble = false;
              var tooltipIcon;
              var isField =
                  element.is('input') || element.is('textarea');

              element.on('$destroy', function () {
                element.off();
              });
              var tooltipIconCompiled = $compile(iconTemplate)(scope);

              if (isField && element.attr('type') !== 'hidden') {
                // if element div parent has another div width gn-control class, put the tooltip there.
                var asideCol = element.closest('div').next('div.gn-control');
                if (asideCol.length > 0) {
                  asideCol.append(tooltipIconCompiled);
                } else {
                  // if element is part of a template snippet, look for the previous label and add the icon after it
                  var id = element.attr('id');
                  var re = /^_X[0-9]+_replace_.+$/;
                  if (id && id.match(re)) {
                    var label = element.closest('div').children('label[for=' + id + ']').after(tooltipIconCompiled);
                  } else {
                    // Add tooltip after the input element
                    element.after(tooltipIconCompiled);
                  }
                }
              }

              // if element is a fieldset legend
              if (element.is('legend')) {
                element.contents().first().after(tooltipIconCompiled);
                stopEventBubble = true;
              }
              if (element.is('label')) {
                element.parent().children("div").append(tooltipIconCompiled);
              }
              tooltipIcon = tooltipIconCompiled;

              var initTooltip = function (eventName, event) {
                if (!isInitialized && gnCurrentEdit.displayTooltips) {
                  if (stopEventBubble) {
                    event.stopPropagation();
                  }

                  // Retrieve field information (there is a cache)
                  gnSchemaManagerService
                      .getElementInfo(attrs.gnFieldTooltip).then(function (data) {
                        var info = data[0];
                        if (info.description && info.description.length > 0) {
                          // Initialize tooltip when description returned
                          var html = '';

                          // TODO: externalize in a template.
                          if (angular.isArray(info.help)) {
                            angular.forEach(info.help, function (helpText) {
                              if (helpText['@for']) {
                                html += helpText['#text'];
                              } else {
                                html += helpText;
                              }
                            });
                          } else if (info.help) {
                            html += info.help;
                          }


                          // Right same width as field
                          // For legend, popover is right
                          // Bottom is not recommended when typeahead
                          var placement = attrs.placement || 'right';

                          // TODO : improve. Here we fix the width
                          // to the remaining space between the element
                          // and the right window border.
                          var width = ($(window).width() -
                              tooltipIcon.offset().left -
                              tooltipIcon.outerWidth()) * .95;

                          var closeBtn = '<button onclick="var event = arguments[0] || window.event;event.stopPropagation();$(this).' +
                              'closest(\'div.popover\').prev().' +
                              'popover(\'hide\');" type="button" ' +
                              'class="fa fa-times btn btn-link pull-right"></button>';

                          var trigger = stopEventBubble ? 'manual' : 'click';

                          tooltipIcon.popover({
                            title: info.description,
                            content: html,
                            html: true,
                            placement: placement,
                            template: '<div class="popover gn-popover" ' +
                            'style="max-width:' + width + 'px;' +
                            'width:' + width + 'px"' +
                            '>' +
                            '<div class="arrow">' +
                            '</div><div class="popover-inner">' + closeBtn +
                            '<h3 class="popover-title"></h3>' +
                            '<div class="popover-content"><p></p></div></div></div>',
                            //                       trigger: 'click',
                            trigger: trigger
                          });

                          tooltipIcon.click(function (event) {
                            if (isInitialized && gnCurrentEdit.displayTooltips && stopEventBubble) {
                              event.stopPropagation();
                              tooltipIcon.popover('toggle');
                            }
                          });

                          tooltipIcon.on('shown.bs.popover', function(event) {
                            if ($('div.popover').css('top').charAt(0) === '-') {
                              // move popover under navbar.
                              var oldTopPopover = $('div.popover').position().top;
                              var newTopPopover =
                                  $(".navbar:not('.ng-hide')").outerHeight() + 5;
                              var oldTopArrow = $('.popover>.arrow').position().top;
                              $('div.popover').css('top', newTopPopover);
                              $('.popover>.arrow').css('top',
                                  oldTopArrow - newTopPopover + oldTopPopover);
                            }
                          });

                          isInitialized = true;
                          tooltipIcon.popover('show');
                        }
                      });
                }
              };

              // On hover trigger the tooltip init
              if (tooltipIcon) {
                tooltipIcon.click(function (event) {
                  initTooltip('click', event);
                });
              }
            }
          };
        }]);

  /**
   * @ngdoc directive
   * @name gn_fields.directive:gnEditorControlMove
   *
   * @description
   * Move an element up or down. If direction
   * is not defined, direction is down.
   */
  module.directive('gnEditorControlMove', ['gnEditor',
    function (gnEditor) {
      return {
        restrict: 'A',
        scope: {
          ref: '@gnEditorControlMove',
          domelementToMove: '@',
          direction: '@'
        },
        link: function (scope, element, attrs) {

          element.on('$destroy', function () {
            element.off();
          });

          $(element).click(function () {
            gnEditor.move(scope.ref, scope.direction || 'down',
                scope.domelementToMove);
          });
        }
      };
    }]);

  /**
   * @ngdoc directive
   * @name gn_fields.directive:gnFieldHighlightRemove
   *
   * @description
   * Add a danger class to the element about
   * to be removed by this action
   */
  module.directive('gnFieldHighlightRemove', [
    function () {
      return {
        restrict: 'A',
        link: function (scope, element, attrs) {
          var ref = attrs['gnFieldHighlightRemove'],
              target = $('#gn-el-' + ref);

          element.on('mouseover', function (e) {
            target.addClass('text-danger');
          });
          element.on('mouseout', function () {
            target.removeClass('text-danger');
          });
        }
      };
    }]);

  /**
   * @ngdoc directive
   * @name gn_fields.directive:gnFieldHighlight
   *
   * @description
   * Highlight an element by adding field-bg class
   * and looking for all remove button to make them
   * visible.
   */
  module.directive('gnFieldHighlight', [
    function () {
      return {
        restrict: 'A',
        link: function (scope, element, attrs) {

          element.on('mouseover', function (e) {
            e.stopPropagation();
            // TODO: This may need improvements
            // on touchscreen delete action will not be visible

            element.addClass('field-bg');
            element.find('a').has('.fa-times.text-danger')
                .css('visibility', 'visible');
            element.find('a.field-tooltip')
                .css('visibility', 'visible');
          });
          element.on('mouseout', function () {
            element.removeClass('field-bg');
            element.find('a').has('.fa-times.text-danger')
                .css('visibility', 'hidden');
            element.find('a.field-tooltip')
                .css('visibility', 'hidden');
          });
        }
      };
    }]);

})();
