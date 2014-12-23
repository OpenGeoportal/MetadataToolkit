(function() {
  goog.provide('gn_new_metadata_controller');

  goog.require('gn_catalog_service');

  var module = angular.module('gn_new_metadata_controller',
      ['gn_catalog_service']);


  /**
   * Constants
   */
   module.constant('TEMPLATES', {
    'BLANK_TEMPLATE_NAME': 'Blank Template'
   });

  /**
   * Controller to create new metadata record.
   */
  module.controller('GnNewMetadataController', [
    '$scope', '$routeParams', '$http', '$rootScope', '$translate', '$compile',
    'gnSearchManagerService',
    'gnUtilityService',
    'gnMetadataManager', '$location','TEMPLATES',
    function($scope, $routeParams, $http, $rootScope, $translate, $compile,
            gnSearchManagerService, 
            gnUtilityService,
            gnMetadataManager, $location, TEMPLATES) {

      $scope.isTemplate = false;
      $scope.hasTemplates = true;
      $scope.mdList = null;
      $scope.blankTemplate = null;

      // Default group is Guest (-1)
      $scope.ownerGroup = -1;


      // A map of icon to use for each types
      var icons = {
        featureCatalog: 'fa-table',
        service: 'fa-cog',
        map: 'fa-globe',
        staticMap: 'fa-globe',
        dataset: 'fa-file'
      };

      $scope.$watchCollection('groups', function() {
        if (!angular.isUndefined($scope.groups)) {
          if ($scope.groups.length == 1) {
            $scope.ownerGroup = $scope.groups[0]['@id'];
          }
        }
      });

      // List of record type to not take into account
      // Could be avoided if a new index field is created FIXME ?
      var dataTypesToExclude = ['staticMap'];
      var defaultType = 'dataset';
      var unknownType = 'unknownType';
      var fullPrivileges = true;

      $scope.getTypeIcon = function(type) {
        return icons[type] || 'fa-square-o';
      };

      var init = function() {
        if ($routeParams.id) {
          gnMetadataManager.create(
              $routeParams.id,
              $routeParams.group,
              fullPrivileges,
              $routeParams.template,
              false,
              $routeParams.tab);
        } else {

          // Metadata creation could be on a template
          // or by duplicating an existing record
          var query = '';
          if ($routeParams.childOf || $routeParams.from) {
            query = '_id=' + ($routeParams.childOf || $routeParams.from);
          } else {
            query = 'template=y';
          }


          // TODO: Better handling of lots of templates
          gnSearchManagerService.search('qi@json?' +
              query + '&fast=index&from=1&to=200').
              then(function(data) {

                $scope.mdList = data;
                $scope.hasTemplates = data.count != '0';

                var types = [];
                // TODO: A faster option, could be to rely on facet type
                // But it may not be available
                for (var i = 0; i < data.metadata.length; i++) {
                  var type = data.metadata[i].type || unknownType;
                  if (type instanceof Array) {
                    for (var j = 0; j < type.length; j++) {
                      if ($.inArray(type[j], dataTypesToExclude) === -1 &&
                          $.inArray(type[j], types) === -1) {
                        types.push(type[j]);
                      }
                    }
                  } else if ($.inArray(type, dataTypesToExclude) === -1 &&
                      $.inArray(type, types) === -1) {
                    types.push(type);
                  }
                }
                types.sort();
                $scope.mdTypes = types;

                // Select the default one or the first one
                if (defaultType && $.inArray(defaultType, $scope.mdTypes)) {
                  $scope.getTemplateNamesByType(defaultType);
                } else if ($scope.mdTypes[0]) {
                  $scope.getTemplateNamesByType($scope.mdTypes[0]);
                } else {
                  // No templates available ?
                }
              });
        }
      };

      $scope.isBlankTemplate = function(tpl) {
        if (tpl && tpl.defaultTitle && tpl.defaultTitle === TEMPLATES.BLANK_TEMPLATE_NAME) {
          return true;
        } else {
          return false;
        }
      };

      /**
       * Get all the templates for a given type.
       * Will put this list into $scope.tpls variable.
       */
      $scope.getTemplateNamesByType = function(type) {
        var tpls = [];
        for (var i = 0; i < $scope.mdList.metadata.length; i++) {
          var currentTpl = $scope.mdList.metadata[i];
          var mdType = currentTpl.type || unknownType;
          if ($scope.isBlankTemplate(currentTpl)) {
            // Do not add blank template to tpls list. Instead save it in an independent variable.
            $scope.blankTemplate = currentTpl;
          } else {
            if (mdType instanceof Array) {
              if (mdType.indexOf(type) >= 0 ) {
                tpls.push(currentTpl);
              }
            } else if (mdType == type) {
              tpls.push(currentTpl);
            }
          }
        }

        // Sort template list
        function compare(a, b) {
          if (a.title < b.title)
            return -1;
          if (a.title > b.title)
            return 1;
          return 0;
        }
        tpls.sort(compare);

        $scope.tpls = tpls;
        $scope.activeType = type;
        $scope.setActiveTpl($scope.tpls[0]);
        return false;
      };

      $scope.setActiveTpl = function(tpl) {
        $scope.activeTpl = tpl;
      };

      $scope.setFromFile = function(fromFile) {
        $scope.fromFile = fromFile;
      };

      $scope.setBlankRecord = function() {
        $scope.activeTpl = $scope.blankTemplate;
      }

      $scope.useTemplate = function(tpl) {
        $scope.setFromFile(null);
        $scope.setActiveTpl(tpl);
      };

      $scope.useFile = function(file) {
        $scope.setActiveTpl(null);
        $scope.setFromFile(file)
      };

      $scope.useBlankTemplate = function() {
        $scope.setFromFile(null);
        $scope.setBlankRecord();
      }


      if ($routeParams.childOf) {
        $scope.title = $translate('createChildOf');
      } else if ($routeParams.from) {
        $scope.title = $translate('createCopyOf');
      } else {
        $scope.title = $translate('createA');
      }

      $scope.createNewMetadata = function(isPublic) {
        if ($scope.activeTpl) {
         gnMetadataManager.create(
              $scope.activeTpl['geonet:info'].id,
              $scope.ownerGroup,
              isPublic || false,
              $scope.isTemplate,
              $routeParams.childOf ? true : false
          );
        } else if($scope.fromFile) {
          $location.path('/create/fromFile');

        }
      };

      init();
    }
  ]);
})();
