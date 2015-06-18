package org.fao.geonet.services.ogp.business;

import org.apache.commons.lang.StringUtils;
import org.fao.geonet.Logger;
import org.fao.geonet.constants.Geonet;
import org.fao.geonet.kernel.DataManager;
import org.fao.geonet.kernel.SchemaManager;
import org.fao.geonet.utils.Log;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Locale;

/**
 * Transform the metadata from one standard to another.
 *
 * Created by JuanLuis on 20/05/2015.
 */
@Service
public class TransformService {
    protected final Logger logger;
    @Autowired
    private DataManager dataManager;
    @Autowired
    private SchemaManager schemaManager;

    public TransformService() {
        logger = Log.createLogger("ogp.TransformService", "ogp");
    }

    /**
     * Convert a metadata document to the ISO19115-3 standard.
     *
     * @param originalMd
     * @return
     * @throws Exception
     */
    public Element convertToIso19115_3(Element originalMd) throws Exception {
        Element transformedMd;
        String standard = dataManager.autodetectSchema(originalMd);
        String stylesheetName = "";
        boolean mustConvert;
        standard = StringUtils.upperCase(standard, Locale.ENGLISH);
        switch (standard) {
            case "FGDC-STD":
                stylesheetName = "FGDCtoISO19115-3.xsl";
                mustConvert = true;
                break;
            case "ISO19139":
                stylesheetName = "ISO19139to19115-3.xsl";
                mustConvert = true;
                break;
            case "ISO19115-3":
                mustConvert = false;
                break;
            default:
                throw new ConversionException("Conversion from " + standard + " to ISO19115-3 not available");
        }

        if (mustConvert) {
            Path stylesheet = schemaManager.getSchemaDir("iso19115-3").resolve(Geonet.Path.CONVERT_STYLESHEETS)
                    .resolve(stylesheetName);
            if (Files.exists(stylesheet)) {
                transformedMd = Xml.transform(originalMd, stylesheet);
            } else {
                throw new ConversionException("Conversion stylesheet for converting from " + standard
                        + " to ISO19115-3 not available (" + stylesheetName + ")");
            }
        } else {
            transformedMd = originalMd;
        }
        logger.info("Schema detected: " + standard);

        return transformedMd;
    }
}
