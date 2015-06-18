package common
import jeeves.server.context.ServiceContext
import org.fao.geonet.constants.Geonet
import org.fao.geonet.guiservices.metadata.GetRelated
import org.fao.geonet.kernel.GeonetworkDataDirectory
import org.fao.geonet.services.metadata.format.groovy.Environment
import org.fao.geonet.services.metadata.format.groovy.util.*
import org.fao.geonet.utils.Xml

public class Handlers {
    private org.fao.geonet.services.metadata.format.groovy.Handlers handlers;
    private org.fao.geonet.services.metadata.format.groovy.Functions f
    private Environment env

    common.Matchers matchers
    common.Functions func
    boolean requireValidMetadataForPublish = false;

    public Handlers(handlers, f, env) {
        this.handlers = handlers
        this.f = f
        this.env = env
        func = new common.Functions(handlers: handlers, f:f, env:env)
        matchers =  new common.Matchers(handlers: handlers, f:f, env:env)
    }

    def addDefaultStartAndEndHandlers() {
        handlers.start htmlOrXmlStart
        handlers.end htmlOrXmlEnd
    }

    def entryEl(labeller) {
        return entryEl(labeller, null)
    }
    /**
     * Creates a function that will process all children and sort then according to the sorter that applies to the elements. Then
     * returns the default html for the container elements.
     *
     * @param labeller a function for creating a label from the element
     * @param classer a function taking the element class(es) to add to the entry element.  The method should return a string.
     */
    def entryEl(labeller, classer) {
        return { el ->
            def childData = handlers.processElements(el.children(), el);
            def replacement = [label: labeller(el), childData: childData, name:'']

            if (classer != null) {
                replacement.name = classer(el);
            }

            if (!childData.isEmpty()) {
                return handlers.fileResult('html/2-level-entry.html', replacement)
            }
            return null
        }
    }
    def processChildren(childSelector) {
        return {el ->
            handlers.processElements(childSelector(el), el);
        }
    }
    /**
     * Creates a function which will:
     *
     * 1. Select a single element using the selector function
     * 2. Process all children of the element selected in step 1 with sorter that applies to the element selected in step 1
     * 3. Create a label using executing the labeller on the element passed to handler functions (not element selected in step 1)
     *
     * @param selector a function that will select a single element from the descendants of the element passed to it
     * @param labeller a function for creating a label from the element
     */
    def flattenedEntryEl(selector, labeller) {
        return { parentEl ->
            def el = selector(parentEl)
            def childData = handlers.processElements(el.children(), el);

            if (!childData.isEmpty()) {
                return handlers.fileResult('html/2-level-entry.html', [label: labeller(el), childData: childData])
            }
            return null
        }
    }

    def selectIsotype(name) {
        return {
            it.children().find { ch ->
                ch.name() == name || ch['@gco:isoType'].text() == name
            }
        }
    }

    def htmlOrXmlStart = {
        if (func.isHtmlOutput()) {
            def minimize = ''
            if (env.param("debug").toBool()) {
                minimize = '?minimize=false'
            }
            return """
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8"/>
    <link rel="stylesheet" href="../../static/gn_bootstrap.css$minimize"/>
    <link rel="stylesheet" href="../../static/gn_metadata.css$minimize"/>
    <script src="../../static/lib.js$minimize"></script>
</head>
<body>
"""
        } else {
            return ''
        }
    }

    def htmlOrXmlEnd = {
        def required = """
<script type="text/javascript">
//<![CDATA[
        ${handlers.fileResult("js/std-footer.js", [:])}
//]]>
</script>"""
        if (func.isHtmlOutput()) {
            return required + '</body></html>'
        } else {
            return required
        }
    }


    NavBarItem createXmlNavBarItem() {
        return new NavBarItem(f.translate("xml"), f.translate("xml"), "", "xml.metadata.get?uuid=${env.metadataUUID}")
    }

    def loadHierarchyLinkBlocks() {
        def relatedTypes = ["service","children","related","parent","dataset","fcat","siblings","associated","source","hassource"]
        def uuid = this.env.metadataUUID
        def id = this.env.metadataId

        LinkBlock hierarchy = new LinkBlock("hierarchy", "fa fa-sitemap")
        def bean = this.env.getBean(GetRelated.class)
        def relatedXsl = this.env.getBean(GeonetworkDataDirectory).getWebappDir().resolve("xsl/metadata/relation.xsl");
        def raw = bean.getRelated(ServiceContext.get(), id, uuid, relatedTypes.join("|"), 1, 1000, true)
        def related = Xml.transform(new org.jdom.Element("root").addContent(raw), relatedXsl);

        related.getChildren("relation").each { rel ->
            def type = rel.getAttributeValue("type")
            def icon = this.env.localizedUrl + "../../images/formatter/" + type + ".png";

            def linkType = new LinkType(type, icon, null)

            def md = rel.getChild("metadata")

            def mdEl, relUuid;
            if (md != null) {
                relUuid = md.getChild("info", Geonet.Namespaces.GEONET).getChildText("uuid")
                mdEl = md;
            } else {
                relUuid = rel.getChildText("uuid")
                mdEl = rel
            }

            if (relUuid != null) {
                def href = createShowMetadataHref(relUuid)
                def title = mdEl.getChildText("title")
                if (title == null || title.isEmpty()) {
                    title = mdEl.getChildText("defaultTitle")
                }

                if (title != null && title.length() > 60) {
                    title = title.substring(0, 57) + "...";
                }

                if (title == null || title.isEmpty()) {
                    title = relUuid;
                }

                hierarchy.put(linkType, new Link(href, title))
            }
        }

        return hierarchy;
    }

    private String createShowMetadataHref(String uuid) {
        if (uuid.trim().isEmpty()) {
            return "javascript:alert('" + this.f.translate("noUuidInLink") + "');"
        } else {
            return this.env.localizedUrl + "md.format.html?xsl=full_view&amp;schema=iso19139&amp;uuid=" + URLEncoder.encode(uuid, "UTF-8")
        }
    }

}