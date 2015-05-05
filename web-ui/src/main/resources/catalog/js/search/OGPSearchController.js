(function () {

    goog.provide('ogp_search_controller');

    goog.require('gn_date_picker_directive');
    goog.require('gn_date_validator_directive');
    goog.require('gn_map');
    goog.require('gn_group_service');
    goog.require('ogp_editor_service');

    var module = angular.module('ogp_search_controller',
        ['gn_date_validator_directive', 'ui.bootstrap', 'ui.select', 'ngSanitize', 'gn_map_directive', 'gn_group_service', 'ogp_editor_service']);

    /**
     * Constants
     */
    module.constant('CONSTANTS', {
        'EDITOR_PROFILE': 'Editor'
    });

    /**
     * Controller for OpenGeoPortal search.
     */
    module.controller('OgpSearchController', [
        '$scope', '$filter', '$http', '$modal', '$rootScope', '$timeout', '$location', 'gnGroupService', 'OgpEditorService', 'CONSTANTS',
        function ($scope, $filter, $http, $modal, $rootScope, $timeout, $location, gnGroupService, OgpEditorService, CONSTANTS) {

            $scope.searchForm = {};
            $scope.resultBean = {};
            $scope.searchResults = [];
            $scope.initBbox = function () {
                $scope.searchForm.minx = -180;
                $scope.searchForm.miny = -90;
                $scope.searchForm.maxx = 180;
                $scope.searchForm.maxy = 90;
                $scope.searchForm.useExtent = false;
            };
            $scope.step = 'searchForm';
            $scope.searching = false;
            $scope.noResultsFound = false;
            $scope.initBbox();
            $scope.page = 1;
            $scope.totalItems = 0;
            $scope.paginatorMaxSize = 8;
            $scope.itemsPerPage = 50;
            $scope.performingImport = false;

            gnGroupService.list(CONSTANTS.EDITOR_PROFILE).then(
                function (groups) {
                    $scope.groups = groups;
                    var first = $scope.getFirstGroupNonSpecial(groups);
                    $scope.firstGroupNonSpecial = first != null ? first['@id'] : '-1'
                }, function (reason) {

                }
            );

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

            $scope.topicList = [
                {"id": "farming", "label": "ogpTopicFarming"},
                {"id": "biota", "label": "ogpTopicBiota"},
                {"id": "boundaries", "label": "ogpTopicBoundaries"},
                {"id": "climatologyMeteorologyAtmosphere", "label": "ogpTopicClimatologyMeteorologyAtmosphere"},
                {"id": "economy", "label": "ogpTopicEconomy"},
                {"id": "elevation", "label": "ogpTopicElevation"},
                {"id": "environment", "label": "ogpTopicEnvironment"},
                {"id": "geoscientificinformation", "label": "ogpTopicGeoscientificInformation"},
                {"id": "health", "label": "ogpTopicHealth"},
                {"id": "imageryBaseMapsEarthCover", "label": "ogpTopicImageryBaseMapsEarthCover"},
                {"id": "intelligenceMilitary", "label": "ogpTopicIntelligenceMilitary"},
                {"id": "inlandWaters", "label": "ogpTopicInlandWaters"},
                {"id": "location", "label": "ogpTopicLocation"},
                {"id": "oceans", "label": "ogpTopicOceans"},
                {"id": "planningCadastre", "label": "ogpTopicPlanningCadastre"},
                {"id": "society", "label": "ogpTopicSociety"},
                {"id": "structure", "label": "ogpTopicStructure"},
                {"id": "transportation", "label": "ogpTopicTransportation"},
                {"id": "utilitiesCommunication", "label": "ogpTopicUtilitiesCommunication"}
            ];


            $scope.dataTypeList = [
                {"id": "POINT", "label": "ogpDataTypePOINT"},
                {"id": "LINE", "label": "ogpDataTypeLINE"},
                {"id": "POLYGON", "label": "ogpDataTypePOLYGON"},
                {"id": "RASTER", "label": "ogpDataTypeRASTER"},
                {"id": "SCANNED", "label": "ogpDataTypeSCANNED"}];

            $scope.dataRepositoryList = [
                {"id": "Tufts", "label": "Tufts"},
                {"id": "Harvard", "label": "Harvard"},
                {"id": "Berkeley", "label": "Berkeley"},
                {"id": "MIT", "label": "MIT"},
                {"id": "MassGIS", "label": "MassGIS"},
                {"id": "Columbia", "label": "Columbia"}
            ];

            $scope.triggerSearch = function () {
                //Validate input form.
                $scope.searching = true;
                $scope.step = "searchResults";
                // Do search
                $scope.doSearch();
            };

            $scope.doSearch = function() {
                var formBean = $scope.processSearchForm();
                formBean.page = $scope.page - 1;

                $http.post("ogp.dataTypes.search", formBean).
                    success(function (data, status, headers, config) {
                        if (data && data.response) {
                            $scope.response = data.response;
                        }
                        if (data && data.response && data.response.docs) {
                            $scope.resultBean = {};
                            $scope.totalItems =  data.response.numFound;
                            $scope.itemsPerPage = data.responseHeader.params.rows;
                            $scope.searchResults = data.response.docs;
                            //for (var i=0; i < data.response.docs.length; i++) {
                            //    $scope.searchResults.push(data.response.docs[i]);
                            //}
                        }
                        if (data && data.response && data.response.numFound == 0) {
                            $scope.noResultsFound = true;
                        }
                        console.log(data);
                        $scope.searching = false;
                        $scope.busy = false;

                    }).
                    error(function (data, status, headers, config) {
                        console.log(data);
                        $scope.searching = false;
                        $scope.busy = false;
                        //log error
                    });
            };

            $scope.reviseSearch = function () {
                $scope.searchResults = [];
                $scope.searching = false;
                $scope.step = "searchForm";
                $scope.noResultsFound = false;
                $scope.response = null;
                $scope.resultBean = {};
                $scope.page = 1;
            };

            $scope.newSearch = function () {
                $scope.searchResults = [];
                $scope.searching = false;
                $scope.noResultsFound = false;
                $scope.searchForm = {};
                $scope.initBbox();
                $scope.step = "searchForm";
                $scope.response = null;
                $scope.resultBean = {};
                $scope.page = 1;
            };

            $scope.processSearchForm = function () {
                var copy = angular.copy($scope.searchForm);
                if (copy.topic) {
                    copy.topic = $scope.getPropertyFromObjectArray(copy.topic, 'id');
                }
                if (copy.dataType) {
                    copy.dataType = $scope.getPropertyFromObjectArray(copy.dataType, 'id');
                }
                if (copy.dataRepository) {
                    copy.dataRepository = $scope.getPropertyFromObjectArray(copy.dataRepository, 'id');
                }

                return copy;
            };

            $scope.getPropertyFromObjectArray = function (dataset, property) {
                var out = [];
                for (var i = 0; i < dataset.length; i++) {
                    var item = dataset[i];
                    if (item) {
                        out.push(item[property]);
                    }
                }
                return out;
            };

            $scope.openMetadata = function (item) {
                console.log(item);
                var modalInstance = $modal.open({
                    templateUrl: '../../catalog/js/search/'
                    + 'partials/ogpMetadataPopup.html',
                    controller: 'OgpMetadataPopupController',
                    size: 'lg',
                    windowClass: 'modal-large',
                    resolve: {
                        document: function () {
                            return item;
                        }
                    }
                });
            };

            $scope.openMap = function () {
                var modalInstance = $modal.open({
                    templateUrl: '../../catalog/js/search/'
                    + 'partials/ogpMapPopup.html',
                    controller: 'OgpMapController',
                    size: 'lg',
                    windowClass: 'map-popup',
                    resolve: {
                        minx: function () {
                            return $scope.searchForm.minx
                        },
                        miny: function () {
                            return $scope.searchForm.miny
                        },
                        maxx: function () {
                            return $scope.searchForm.maxx
                        },
                        maxy: function () {
                            return $scope.searchForm.maxy
                        }
                    }
                });
                modalInstance.result.then(function (bbox) {

                    if (bbox) {
                        $scope.searchForm.minx = bbox.minx;
                        $scope.searchForm.miny = bbox.miny;
                        $scope.searchForm.maxx = bbox.maxx;
                        $scope.searchForm.maxy = bbox.maxy;
                        $scope.searchForm.useExtent = true;
                    }
                });

                modalInstance.opened.then(function () {
                    $timeout(function () {
                        $rootScope.$broadcast('renderMap');
                    }, 500);
                });
            }; // end openMap

            $scope.haveSolrParams = function () {
                if (typeof String.prototype.trim !== 'function') {
                    String.prototype.trim = function () {
                        return this.replace(/^\s+|\s+$/g, '');
                    }
                }
                var solrParams = false;
                if ($scope.searchForm.solrQuery !== undefined && $scope.searchForm.solrQuery != null && $scope.searchForm.solrQuery.trim() !== "") {
                    solrParams = true;
                }

                return solrParams;
            };

            // Import metadata
            $scope.importMetadata = function () {
                if (!$scope.resultBean && !$scope.resultBean.selectedMetadata && !$scope.resultBean.selectedMetadata.LayerId) {
                    return;
                }


                $scope.performingImport = true;
                $http.post("ogp.dataTypes.import", {},
                    {
                        "params": {
                            "layerId": $scope.resultBean.selectedMetadata.LayerId,
                            "group": $scope.firstGroupNonSpecial
                        }
                    }).
                    success(function (data, status, headers, config) {
                        if (data && data.response) {
                            $scope.response = data.response;
                        }
                        console.log(data);
                        $scope.metadataId = data;
                        OgpEditorService.setOgpImportedMdId($scope.metadataId);
                        //$timeout($scope.goToEditor, 4000);
                        return $timeout(function(){
                            $scope.performingImport = false;
                        }, 4000);

                    }).
                    error(function (data, status, headers, config) {
                        $scope.performingImport = false;
                        console.log(data);
                    });
            };

            $scope.goToEditor = function () {
                var path = '/metadata/' + $scope.metadataId;
                $location.path(path);
            };

            // resultPagination
            $scope.setPage = function () {

                if ($scope.busy) {
                    console.log("nextPage aborting. Busy is true");
                    return;
                }
                this.busy = true;
                $scope.doSearch();
                console.log("Next page called");
            };

            $scope.isScrollDisabled = function() {
                return $scope.step !== 'searchResults' || $scope.busy;
            }


        }]);

    module.controller('OgpMetadataPopupController', ['$scope', '$http', '$sce', '$modalInstance', 'document',
        function ($scope, $http, $sce, $modalInstance, document) {
            $scope.document = document;

            $scope.ok = function () {
                $modalInstance.close();
            };
            $scope.layerId = $scope.document.LayerId;
            $scope.metadataUrl = $sce.trustAsResourceUrl("ogp.dataTypes.getMetadata?layerId=" + $scope.layerId);


            // retrieve the medatata from the server
            /* $http.get("ogp.dataTypes.getMetadata", {
             params: {layerId: $scope.document.LayerId}
             }).success(function(data, status, headers, config) {
             $scope.response = data;
             }).
             error(function(data, status, headers, config) {
             console.log("Error retrieving metadata")
             });
             */

        }]);

    module.directive('iframeSetDimentionsOnload', [function () {
        return {
            restrict: 'A',
            link: function (scope, element, attrs) {
                element.on('load', function () {
                    /* Set the dimensions here,
                     I think that you were trying to do something like this: */
                    var iFrameHeight = element[0].contentWindow.document.body.scrollHeight + 'px';
                    var iFrameWidth = '100%';
                    element.css('width', iFrameWidth);
                    element.css('height', iFrameHeight);
                })
            }
        }
    }])


    module.controller('OgpMapController', ['$scope', '$modalInstance', 'minx', 'miny', 'maxx', 'maxy',
        function ($scope, $modalInstance, minx, miny, maxx, maxy) {
            $scope.bbox = {};
            $scope.bbox.minx = minx;
            $scope.bbox.miny = miny;
            $scope.bbox.maxx = maxx;
            $scope.bbox.maxy = maxy;

            $scope.mapId = Math.floor((Math.random() * 100000) + 1);

            $scope.ok = function () {
                $modalInstance.close($scope.bbox);
            };

        }]);


})();
