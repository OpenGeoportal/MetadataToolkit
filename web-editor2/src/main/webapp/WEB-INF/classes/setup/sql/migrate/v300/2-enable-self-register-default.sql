UPDATE Settings SET value='true' WHERE name='system/userSelfRegistration/enable';
UPDATE Settings SET value='ogp'  WHERE name = 'system/ui/defaultView';
UPDATE Settings SET value='{"iso19110":{"defaultTab":"default","displayToolTip":false,"related":{"display":true,"readonly":true,"categories":["dataset"]},"validation":{"display":true}},"iso19139":{"defaultTab":"default","displayToolTip":false,"related":{"display":true,"categories":[]},"suggestion":{"display":true},"validation":{"display":true}},"dublin-core":{"defaultTab":"default","related":{"display":true,"readonly":false,"categories":["parent","onlinesrc"]}},"iso19115-3":{"defaultTab":"tufts-standard-tab-identification", "displayToolTip":false, "related":{"display":true,"categories":[]},"suggestion":{"display":true},"validation":{"display":true}}}'
WHERE name='metadata/editor/schemaConfig';

