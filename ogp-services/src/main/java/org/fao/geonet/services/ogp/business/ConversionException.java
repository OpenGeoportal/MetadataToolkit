package org.fao.geonet.services.ogp.business;

/**
 * Thrown when a conversion from one metadata standard to another cannot be performed.
 * Created by JuanLuis on 20/05/2015.
 */
public class ConversionException  extends RuntimeException {
    public ConversionException() {
        super();
    }

    public ConversionException(String message) {
        super(message);
    }

    public ConversionException(String message, Throwable cause) {
        super(message, cause);
    }

    public ConversionException(Throwable cause) {
        super(cause);
    }

    protected ConversionException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
