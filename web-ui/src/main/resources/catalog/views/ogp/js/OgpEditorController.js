/**
 * Created by JuanLuis on 07/04/2015.
 */
(function() {
  goog.provide('ogp_editor_controller');

  goog.require('gn_catalog_service');
  goog.require('gn_group_service');
  goog.require('gn_search_manager_service');
  goog.require('gn_locale');
  goog.require('gn_new_metadata_from_file_controller');
  goog.require('ogp_search');
  goog.require('ogp_editor_service');

  var module = angular.module('ogp_editor_controller', [
    'ui.bootstrap',
    'ngRoute',
    'gn_group_service',
    'gn_search_manager_service',
    'ui.bootstrap',
    'gn_locale',
    'gn_catalog_service',
    'gn_new_metadata_from_file_controller',
    'ogp_search_controller',
    'ogp_editor_service'
  ]);

  /**
   * Constants
   */
  module.constant('TEMPLATES', {
    'BLANK_TEMPLATE_NAME': 'Blank Template',
    'EDITOR_PROFILE': 'Editor'
  });

  var tplFolder = '../../catalog/views/ogp/templates/editor/';
  var gnTplFolder = '../../catalog/templates/editor/';

  module.config(['$routeProvider',
    function($routeProvider) {
      $routeProvider.
          when('/metadata/:id', {
            templateUrl: tplFolder + "redirect.html",
            controller: 'OgpRedirectController'}).
          when('/new/:from/optionalAdditions', {
            templateUrl: tplFolder + "optional-additions.html",
            controller: 'OgpEditorBoardController'
          }).
          when('/new/:from/:templateId', {
            templateUrl: tplFolder + "optional-additions.html",
            controller: 'OgpEditorBoardController'
          }).
          when('/new/:from', {
            templateUrl: tplFolder + "optional-additions.html",
            controller: 'OgpEditorBoardController'
          }).
          otherwise({
            templateUrl: tplFolder + 'ogp-wizard-first-step.html',
            controller: 'OgpEditorBoardController'
          });

    }]);


  module.controller('OgpRedirectController', ['$scope', '$routeParams', '$window',
    function($scope, $routeParams, $window) {
      if ($routeParams.id) {
        // show editor for this metadata
        var path = '/metadata/' + $routeParams.id;
        var pathPart = $window.location.pathname.split('/');
        pathPart[pathPart.length - 1] = "catalog.edit";
        var pathname = pathPart.join('/');
        pathname = pathname + "#" + path;
        $window.location.href = pathname;
      }
  }]);

  module.controller('OgpEditorBoardController', [
    '$scope', '$routeParams', 'gnGroupService', 'gnSearchManagerService', 'gnMetadataManager', '$filter', '$location',
    '$window', '$log', 'OgpEditorService', 'TEMPLATES',
    function($scope, $routeParams, gnGroupService, gnSearchManagerService, gnMetadataManager, $filter, $location,
             $window, $log, OgpEditorService, TEMPLATES) {
      $scope.controllerName= "OgpEditorBoardController";
      $scope.from = $routeParams.from;
      $scope.templateId = $routeParams.templateId;
      $scope.importXmlMetadataStep = 'importLocalRecord';
      $scope.isTemplate = false;
      $scope.hasTemplates = true;
      $scope.mdList = null;
      $scope.blankTemplate = null;
      $scope.newFromTemplateIsCollapsed = true;
      $scope.showMyTemplatesOnly = false;
      $scope.editDisabled = ($scope.from === 'existingXmlRecord');

      $scope.step = OgpEditorService.getStep();


      if ($location.path() === '/') {
        OgpEditorService.reset();
      }

      if ($scope.from && ($scope.from !== 'fromBlankRecord' && $scope.from !== 'fromTemplate' && $scope.from !== 'existingXmlRecord')) {
        $log.debug("Not valid 'from' path part. Redirecting to '/'");
        OgpEditorService.reset().success(function() { $location.path("/"); });
        return;
      }

      if (!OgpEditorService.getStep() && $location.path() !== "/") {
        OgpEditorService.reset().success(function(){ $location.path("/");});
        return;
      }
      if ($scope.from === 'fromTemplate' && !$scope.templateId) {
        OgpEditorService.reset().success(function() { $location.path("/");});
        return;
      }



      // List of record type to not take into account
      // Could be avoided if a new index field is created FIXME ?
      var dataTypesToExclude = ['staticMap'];
      var defaultType = 'dataset';
      var unknownType = 'unknownType';
      var fullPrivileges = true;

      $scope.changeStep = function(step) {
        OgpEditorService.setStep(step);
        $scope.step = step;
      };

      $scope.switchXmlStep = function(xmlStep) {
        $scope.importXmlMetadataStep = xmlStep;
      };

      $scope.$on('ogpEditorMdIdChanged', function(event, newValue) {
        // User uploads a file
        if ($scope.step === 'importDataProperties' ) {
          $scope.datasetImported = newValue;
        } else if ($scope.step === 'importXmlMetadata') {
          $scope.localRecordImported = newValue;
          if ($scope.ogpRecordImported && $scope.localRecordImported) {
            OgpEditorService.setOgpImportedMdId(null);
          }
        }
        $scope.isEditDisabled();
      });

      $scope.$on('ogpImportedMdIdChanged', function(event, newValue) {
        // From OGP cloud
        $scope.ogpRecordImported = newValue;
        if ($scope.localRecordImported) {
          OgpEditorService.setMetadataId(null);
        }
        $scope.isEditDisabled();
      });

      $scope.isEditDisabled = function() {
        var disabled = false;
        if ($scope.from === 'existingXmlRecord' && !($scope.localRecordImported || $scope.datasetImported || $scope.ogpRecordImported)) {
          disabled = true;
        }
        $scope.editDisabled = disabled;;
      }

      $scope.doEdit = function () {
        var id;
        var templateId;
        var group = $scope.groups[0]['@id']
        if ($scope.from === 'fromBlankRecord') {
          templateId = $scope.blankTemplate['geonet:info'].id
        } else if ($scope.from === 'fromTemplate') {
          templateId = $scope.templateId;
        }
        $scope.editError = null;
        OgpEditorService.createMetadata(group, templateId, $scope.datasetImported, $scope.localRecordImported,
            $scope.ogpRecordImported).then(
            function(result) {
              var path = '/metadata/' + result;
              $location.path(path);
            },
            function(reason) {
              $scope.editError = reason;
              $log.error("Error creating metadata: " + reason);
            }
        );

      };

    $scope.loadGroups = function() {
      gnGroupService.list(TEMPLATES.EDITOR_PROFILE).then(
          function (groups) {
            $scope.groups = groups;
            var first = $scope.getFirstGroupNonSpecial(groups);
            $scope.firstGroupNonSpecial = first != null ? first['@id'] : '-1'
          }, function (reason) {

          });
    };

    $scope.getFirstGroupNonSpecial = function (groups) {
      var sortedGroups = $filter('orderBy')(groups, function (obj) {
        return parseInt(obj["@id"]);
      });
      var i = 0;
      var first = null;
      while (i < sortedGroups.length && !first) {
        if (parseInt(groups[i]["@id"]) > 1) {
          first = groups[i];
        }
        i++;
      }
      return first;
    };

    $scope.$watchCollection('groups', function() {
      if (!angular.isUndefined($scope.groups)) {
        if ($scope.groups.length == 1) {
          $scope.ownerGroup = $scope.groups[0]['@id'];
        }
      }
    });

    $scope.loadTemplates = function() {
      var query = 'template=y';
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
        return false;
      };

      $scope.setBlankRecord = function() {
        $scope.activeTpl = $scope.blankTemplate;
      };

      $scope.setFromFile = function(fromFile) {
        $scope.fromFile = fromFile;
      };

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
      };

      var init = function() {
        $scope.loadGroups();
        $scope.loadTemplates();
      };



      $scope.filterOwnTemplates = function(template) {
        return function(t) {
          if(!$scope.showMyTemplatesOnly) {
            return true;
          } else {
            if (t.owner === $scope.user.id){
              return true;
            }
          }

        };
      };

      $scope.newFromBlankTemplate = function() {
        if (!$scope.working) {
          // create method parameters: id, groupId, withFullPrivileges,
          // isTemplate, isChild, tab
          $scope.working = true;
          $scope.creatingFrom = 'blankTemplate';
          OgpEditorService.setStep('importDataProperties');
          $location.path("/new/fromBlankRecord/optionalAdditions");

         /* gnMetadataManager.copy(
              $scope.blankTemplate['geonet:info'].id,
              $scope.groups[0]['@id'],
              false,
              false,
              false
          ).success(function (data) {
                var path = '/metadata/' + data.id;
                var pathPart = $window.location.pathname.split('/');
                pathPart[pathPart.length - 1] = "catalog.edit";
                var pathname = pathPart.join('/');
                pathname = pathname + "#" + path;
                $window.location.href = pathname;
              }).error(function () {
                $scope.working = false;
                $scope.creatingFrom = false;
              }
          );*/
        }
      };

      $scope.importOgpCloud = function() {
        if (!$scope.working) {
          $scope.working = true;
          $scope.creatingFrom = 'ogpCloud';
          var path = '/ogpSearch/search';
          var pathPart = $window.location.pathname.split('/');
          pathPart[pathPart.length - 1] = "catalog.edit";
          var pathname = pathPart.join('/');
          pathname = pathname + "#" + path;
          $window.location.href = pathname;
        }
      };

      $scope.importLocalRecord = function() {
        if (!$scope.working) {
          $scope.working = true;
          $scope.creatingFrom = 'localRecord';
          OgpEditorService.setStep('importDataProperties');
          $location.path('/new/existingXmlRecord');
        }
      };

      $scope.nextStepFromTemplate = function(tpl) {
        if (!$scope.working) {
          $scope.working = true;
          $scope.creatingFrom = 'template';
          $scope.activeTpl = tpl;
          OgpEditorService.setStep('importDataProperties');
          $location.path('/new/fromTemplate/' + tpl['geonet:info'].id);
        }
      }

      $scope.createFromTemplate = function(tpl) {
        if (!$scope.working) {
          $scope.activeTpl = tpl;
          $scope.working = true;
          $scope.creatingFrom = 'template';
          gnMetadataManager.copy(
              $scope.activeTpl['geonet:info'].id,
              $scope.groups[0]['@id'],
              false,
              false,
              false
          ).success(function (data) {
                $log.debug($location.url());
                var path = '/metadata/' + data.id;
                var pathPart = $window.location.pathname.split('/');
                pathPart[pathPart.length - 1] = "catalog.edit";
                var pathname = pathPart.join('/');
                pathname = pathname + "#" + path;
                $window.location.href = pathname;
              }).error(function () {
                $scope.working = false;
                $scope.creatingFrom = false;
              }
          );
        }
      };

      $scope.createNewMetadata = function(isPublic) {
        if ($scope.activeTpl) {
          return gnMetadataManager.create(
              $scope.activeTpl['geonet:info'].id,
              $scope.ownerGroup,
              isPublic || false,
              $scope.isTemplate,
              $routeParams.childOf ? true : false
          );
        } else if($scope.fromFile === 'xmlFile') {
          return $timeout(function(){
            return  $location.path('/create/fromFile');
          }, 200);
        } else if ($scope.fromFile === 'ogpSearch') {
          return $timeout(function() {
            $location.path('/ogpSearch/search');
          }, 200);
        }
      };


      init();
  }]);




})();