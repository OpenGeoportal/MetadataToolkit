//=============================================================================
//===	Copyright (C) 2001-2007 Food and Agriculture Organization of the
//===	United Nations (FAO-UN), United Nations World Food Programme (WFP)
//===	and United Nations Environment Programme (UNEP)
//===
//===	This program is free software; you can redistribute it and/or modify
//===	it under the terms of the GNU General Public License as published by
//===	the Free Software Foundation; either version 2 of the License, or (at
//===	your option) any later version.
//===
//===	This program is distributed in the hope that it will be useful, but
//===	WITHOUT ANY WARRANTY; without even the implied warranty of
//===	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//===	General Public License for more details.
//===
//===	You should have received a copy of the GNU General Public License
//===	along with this program; if not, write to the Free Software
//===	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
//===
//===	Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
//===	Rome - Italy. email: geonetwork@osgeo.org
//==============================================================================

package org.fao.geonet.services.group;

import jeeves.constants.Jeeves;
import jeeves.interfaces.Service;
import jeeves.server.ServiceConfig;
import jeeves.server.context.ServiceContext;
import org.fao.geonet.kernel.GeonetworkDataDirectory;
import org.fao.geonet.repository.GroupRepository;
import org.fao.geonet.repository.specification.GroupSpecs;
import org.fao.geonet.resources.Resources;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;

import java.nio.file.Path;

import static org.springframework.data.jpa.domain.Specifications.not;

//=============================================================================

/**
 * Retrieves all groups in the system
 */

public class List implements Service {
    public void init(Path appPath, ServiceConfig params) throws Exception {
    }

    // --------------------------------------------------------------------------
    // ---
    // --- Service
    // ---
    // --------------------------------------------------------------------------

    public Element exec(Element params, ServiceContext context)
            throws Exception {
        Element elRes = context.getBean(GroupRepository.class).findAllAsXml(
                not(GroupSpecs.isReserved()));
        final Path resourcesDir = context.getBean(GeonetworkDataDirectory.class).getResourcesDir();
        final Path logosDir = Resources.locateLogosDir(context);
        final java.util.List<?> logoElements = Xml.selectNodes(elRes, "*//logo");
        for (Object logoObj : logoElements) {
            Element logoEl = (Element) logoObj;
            final String logoRef = logoEl.getTextTrim();
            if (logoRef != null && !logoRef.isEmpty() && !logoRef.startsWith("http://")) {
                final Path imagePath = Resources.findImagePath(logoRef, logosDir);
                if (imagePath != null) {
                    String relativePath = resourcesDir.relativize(imagePath).toString().replace('\\', '/');
                    logoEl.setText(context.getBaseUrl() + '/' + relativePath);
                }
            }
        }

        Element elOper = params.getChild(Jeeves.Elem.OPERATION);

        if (elOper != null)
            elRes.addContent(elOper.detach());

        return elRes.setName(Jeeves.Elem.RESPONSE);
    }
}

// =============================================================================

