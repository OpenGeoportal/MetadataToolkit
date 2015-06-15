package org.fao.geonet.services.ogp.domain;

/**
 * Created on 28/01/2015.
 *
 * @author <a href="mailto:juanluisrp@geocat.net">Juan Luis Rodríguez</a>.
 */
public enum DataType {
    POINT, LINE, POLYGON, RASTER, SCANNED;

    public String toString() {
        if (this.equals(DataType.POINT)) {
            return "Point";
        } else if (this.equals(DataType.LINE)) {
            return "Line";
        } else if (this.equals(DataType.POLYGON)) {
            return "Polygon";
        } else if (this.equals(DataType.RASTER)) {
            return "Raster";
        } else if (this.equals(DataType.SCANNED)) {
            return "Paper Map";
        } else {
            return "";
        }
    }
}
