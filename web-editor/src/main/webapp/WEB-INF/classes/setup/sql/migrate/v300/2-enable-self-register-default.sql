UPDATE Settings SET value='true' WHERE name='system/userSelfRegistration/enable';
UPDATE Settings SET value='ogp'  WHERE name = 'system/ui/defaultView';
UPDATE Settings SET value='{"iso19110":{"defaultTab":"default","displayToolTip":false,"related":{"display":true,"readonly":true,"categories":["dataset"]},"validation":{"display":true}},"iso19139":{"defaultTab":"default","displayToolTip":false,"related":{"display":true,"categories":[]},"suggestion":{"display":true},"validation":{"display":true}},"dublin-core":{"defaultTab":"default","related":{"display":true,"readonly":false,"categories":["parent","onlinesrc"]}},"iso19115-3":{"defaultTab":"tufts-standard-tab-identification", "displayToolTip":true, "hideScrollSpy": false, "related":{"display":true, "disableResourceUpload": true, "categories":[]},"suggestion":{"display":true},"validation":{"display":true}}}'
WHERE name='metadata/editor/schemaConfig';

--Update map projection list (reduce it to EPSG:4326
UPDATE Settings SET value='{"viewerMap": "../../map/config-viewer.xml", "listOfServices": {"wms": [], "wmts": []}, "useOSM":true,"context":"","layer":{"url":"http://www2.demis.nl/mapserver/wms.asp?","layers":"Countries","version":"1.1.1"},"projection":"EPSG:3857","projectionList":[{"code":"EPSG:4326","label":"WGS84 (EPSG:4326)"}]}'
WHERE name='map/config';

