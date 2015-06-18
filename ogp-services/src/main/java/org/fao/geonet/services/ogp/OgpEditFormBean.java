package org.fao.geonet.services.ogp;

import org.jdom.Element;

/**
 * Session bean for the editor wizard.
 * Created by JuanLuis on 15/05/2015.
 */

public class OgpEditFormBean {
    private Element datasetMetadata;
    private Element localMetadataRecord;
    private Element ogpImportedMetadata;

    public void setDatasetMetadata(Element datasetMetadata) {
        this.datasetMetadata = datasetMetadata;
    }

    public Element getDatasetMetadata() {
        return datasetMetadata;
    }

    public void setLocalMetadataRecord(Element localMetadataRecord) {
        this.localMetadataRecord = localMetadataRecord;
    }

    public Element getLocalMetadataRecord() {
        return localMetadataRecord;
    }

    public void setOgpImportedMetadata(Element ogpImportedMetadata) {
        this.ogpImportedMetadata = ogpImportedMetadata;
    }

    public Element getOgpImportedMetadata() {
        return ogpImportedMetadata;
    }
}
