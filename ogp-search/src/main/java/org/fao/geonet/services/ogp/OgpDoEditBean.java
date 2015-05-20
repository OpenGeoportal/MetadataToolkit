package org.fao.geonet.services.ogp;

/**
 * Created by JuanLuis on 18/05/2015.
 */
public class OgpDoEditBean {
    private String templateId;
    private boolean datasetImported = false;
    private boolean localRecordImported= false;
    private boolean ogpRecordImported = false;
    private String group;


    public String getTemplateId() {
        return templateId;
    }

    public void setTemplateId(String templateId) {
        this.templateId = templateId;
    }

    public boolean isDatasetImported() {
        return datasetImported;
    }

    public void setDatasetImported(boolean datasetImported) {
        this.datasetImported = datasetImported;
    }

    public boolean isLocalRecordImported() {
        return localRecordImported;
    }

    public void setLocalRecordImported(boolean localRecordImported) {
        this.localRecordImported = localRecordImported;
    }

    public boolean isOgpRecordImported() {
        return ogpRecordImported;
    }

    public void setOgpRecordImported(boolean ogpRecordImported) {
        this.ogpRecordImported = ogpRecordImported;
    }

    public String getGroup() {
        return group;
    }

    public void setGroup(String group) {
        this.group = group;
    }
}
