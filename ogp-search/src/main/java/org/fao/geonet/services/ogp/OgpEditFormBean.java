package org.fao.geonet.services.ogp;

import org.jdom.Element;

/**
 * Created by JuanLuis on 15/05/2015.
 */

public class OgpEditFormBean {
    private Element datasetMetadata;
    private Element localMetadataRecord;

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
}
