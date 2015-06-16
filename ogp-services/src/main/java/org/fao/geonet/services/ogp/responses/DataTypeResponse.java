package org.fao.geonet.services.ogp.responses;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * Created on 29/01/2015.
 *
 * @author <a href="mailto:juanluisrp@geocat.net">Juan Luis Rodriguez</a>.
 */
@XmlRootElement(name = "response")
public class DataTypeResponse {
    private String dataType;

    public String getDataType() {
        return dataType;
    }

    public void setDataType(String dataType) {
        this.dataType = "TestDataType";
    }
}
