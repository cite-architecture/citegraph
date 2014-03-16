package edu.harvard.chs.citegraph

import edu.harvard.chs.cite.CiteUrn
import edu.harvard.chs.cite.CtsUrn
import groovy.json.*
 

import groovyx.net.http.*
import groovyx.net.http.HttpResponseException
import static groovyx.net.http.ContentType.*
import static groovyx.net.http.Method.*

/** Class for working with triplet graph of HMT project content.
*/
class CiteGraph {

    def debug = 8

    /** SPARQL query endpoint for HMT graph triples.  */
    String tripletServerUrl

    /** Source for SPARQL query strings. */
    QueryGenerator qg

    /** XML namespace for sparql results, as a groovy object. */
    static groovy.xml.Namespace sparql = new groovy.xml.Namespace("http://www.w3.org/2005/sparql-results#")

    /** List of URNs identifying CITE Collections with RDF type property
    * cite:ImageArchive.
    */
    def imgCollections = []


    /** Constructor with URL as a String.
    * @param serverUrl SPARQL endpoint for this graph.
    */
    CiteGraph(String serverUrl) {
        this.tripletServerUrl = serverUrl
        this.qg = new QueryGenerator()
        String imgColls =  getSparqlReply("application/json", qg.findImgColls())
        def slurp1 = new JsonSlurper()
        def imgReply = slurp1.parseText(imgColls)
        imgReply.results.bindings.each { b ->
            // add qmark
            imgCollections.add(b.s?.value)
        }
    }

    /** Submits a query to the configured SPARQL end point.
    * Assuming that a SPARQL end point like fuseki recognizes
    * an HTTP parameter named 'output', it chooses what value
    * to use for 'output' based on the acceptParameter of this method.
    * @param acceptType Value to use for HTTP Accept header.
    * @param query A SPARQL query string to submit.
    * @returns The text of the reply from the SPARQL endpoint.
    */
    String getSparqlReply(String acceptType, String query) {
        def encodedQuery = URLEncoder.encode(query)
        def q = "${tripletServerUrl}query?query=${encodedQuery}"
        if (acceptType == "application/json") {
            q +="&output=json"
        }

		URL queryUrl = new URL(q)
        return queryUrl.getText("UTF-8")
    }

    /** Finds all relations to a given object
    * one degree distant in the graph.
    * @param urnStr CITE URN value of the object to query about.
    * @returns The <graph> component of the CITE Index
    * reply element.
    */
    String findAdjacent(String urnStr) {
        return findAdjacent(urnStr, true)
    }


    // tbd ... Need to develop a better test data set first, using
    // HMT project ordered collection of Aristarchan critical signs
    String processObjectSequence(String urnStr, ArrayList bindingList) {
        StringBuffer reply = new StringBuffer()
        def clusteredBindings = clusterObjectSequences(bindingList)
        clusteredBindings.keySet().each {  coll ->
            String label = getLabel(coll)
            ArrayList binding = clusteredBindings[coll]
            reply.append(formatObjectSequence(label, binding))
        }
        return reply.toString()
    }

    LinkedHashMap clusterObjectSequences(ArrayList bindings) {
        def objSeqq = [:]
        def prevVerb = ""
        bindings.each { b ->
            if (b != null) {
            try {
                    String currentVerb = b.v?.value
                CiteUrn obj = new CiteUrn(b.o?.value) 
                String key = "urn:cite:${obj.getNs()}:${obj.getCollection()}"
                if (! objSeqq[key] ) {
                    def bindingList = [b]
                    objSeqq[key] = bindingList
                    prevVerb = currentVerb
                } else if (currentVerb != prevVerb) {
                    // emit as a single...
                    // NS HERE
                    // Can we count on ordering of these by verb??
                    // Is that connected to seq ordering in any way?
                } else {

                    objSeqq[key].add(b)
                }

            } catch (Exception e) {
                //System.err.println "Could not analyze ${b.o?.value}"
                //System.err.println "Exception: ${e}"
            }
        } }
        return objSeqq
    }



    /** Groups an ordered list of JSON bindings by the text source
    * they are drawn from.
    * @param bindings A list of JSON bindings returned from a SPARQL query.
    * @returns A map of JSON bindings keyed by CTS URN values.
    */
    LinkedHashMap clusterTextSequences(ArrayList bindings) {
        def textSeqq = [:]
        bindings.each { b ->
            if (b != null) {
            try {
                CtsUrn obj = new CtsUrn(b.o?.value) 
                String key = "urn:cts:${obj.getCtsNamespace()}:${obj.getTextGroup()}.${obj.getWork()}.${obj.getVersion()}"
                if (! textSeqq[key] ) {
                    def bindingList = [b]
                    textSeqq[key] = bindingList
                } else {
                    textSeqq[key].add(b)
                }

            } catch (Exception e) {
                //System.err.println "Could not analyze ${b.o?.value}"
                //System.err.println "Exception: ${e}"
            }
        } }
        return textSeqq
    }


    /** Formats an ordered set of JSON bindings drawn from a single text source
    * in the CITE Index XML format.
    * @param urnStr URN of the work the bindings refer to.
    * @param bindings An ordered list of bindings to a SPARQL query reply.
    * @returns A single <sequence> element, or an empty String if bindings
    * contains no bindings.
    */
    String formatTextSequence(String sequenceLabel, ArrayList bindings) {
        def rdfSubj =  bindings[0]['s']['value']
        def rdfVerb = bindings[0]['v']['value']
        def ln = bindings[0]

        if (bindings.size() == 1) {
            if (ln != null) {
                String obj = ln['o']['value']
                String lab = ln['lab']['value']
                return """<node s="${rdfSubj}" v="${rdfVerb}" type="text">\n<label>${lab}</label>\n<value>${obj}</value>\n</node>\n"""
            } else {
                System.err.println "CiteGraph:formatTextSequence: Single, null object in bindings."
                return ""
            }
        }
        if (ln != null) {
        String firstUrnVal = ln['o']['value']
        def lastBind = bindings[bindings.size() - 1]
        String lastUrnVal
        if (lastBind != null) {
            lastUrnVal = lastBind['o']['value']
        }
        String range
        String rangeLabel
        try {
            CtsUrn urn1 = new CtsUrn(firstUrnVal)
            CtsUrn urn2 = new CtsUrn(lastUrnVal)
            range = "${firstUrnVal}-${urn2.getPassageComponent()}"
            rangeLabel = "${urn1.getPassageComponent()}-${urn2.getPassageComponent()}"
        } catch (Exception e) {
            throw new Exception ("formatTextSequence: unable to work with ${lastUrnVal}: ${e}")
        }

        StringBuffer lines = new StringBuffer("""<sequence s="${rdfSubj}" v="${rdfVerb}" type="text" urn="${range}">\n """)
        lines.append("<label>${sequenceLabel}: ${rangeLabel}</label>\n<value>\n")
        bindings.each { b ->
            if (b) {
                def subj = b['s']['value']
                def obj = b['o']['value']
                def lab = b['lab']['value']
                lines.append """<node s="${subj}" v="${rdfVerb}" type="text">\n<label>${lab}</label>\n<value>${obj}</value>\n</node>\n"""
            }
        }
        
        lines.append ("</value>\n</sequence>\n")
        return lines.toString()
        }
    }


    /** Formats bindings for sequences of text nodes.  It
    * clusters a list of nodes by the text they belong to, 
    * and finds a label for the text as a whole.
    * @param urnStr The URN, as a String, of the subject of the
    * SPARQL query that generated this group of JSON bindings.
    * @param bindingList A list of JSON bindings resulting from
    * a SPARQL query about urnStr.
    * @returns A series of <sequence> elements for the CITE Index reply.
    */
    String processTextSequences(String urnStr, ArrayList bindingList) {
        StringBuffer reply = new StringBuffer()
        def clusteredBindings = clusterTextSequences(bindingList)
        clusteredBindings.keySet().each {  txt ->
            String label = getLabel(txt)
            ArrayList binding = clusteredBindings[txt]
            reply.append(formatTextSequence(label, binding))
        }
        return reply.toString()
    }        

    /**  Finds all relations to a given object that are
    * one degree distant in the graph, and belong to a sequence. 
    * @param urnStr CITE URN value of the object to query about.
    * @param inclusive True if queries should also look for extended
    * URN references for the CITE Object or CTS text node cited in
    * the URN.
    * @returns A String composed of <sequence> statements.
    */
    String getSequencedRelations(String urnStr, boolean inclusive) {
        StringBuffer reply = new StringBuffer()


//        String seq1 = getSparqlReply("application/json", qg.sequencedQuery(urnStr))
        String seq1 = getSparqlReply("application/json", qg.sequencedTexts(urnStr))
        def txtslurper = new groovy.json.JsonSlurper()
        def sequencedReply = txtslurper.parseText(seq1)
        reply.append(processTextSequences(urnStr, sequencedReply.results.bindings))

        String seq1b = getSparqlReply("application/json", qg.sequencedObjects(urnStr))
        def objslurper = new groovy.json.JsonSlurper()
        def sequencedObjReply = objslurper.parseText(seq1b)

        reply.append(processObjectSequence(urnStr, sequencedObjReply.results.bindings) + "\n")


        if  (inclusive) {

            String seq2 = getSparqlReply("application/json", qg.inclusiveSequencedTexts(urnStr))
        def slurper = new groovy.json.JsonSlurper()
        def reply2 = slurper.parseText(seq2)
        reply.append(processTextSequences(urnStr, reply2.results.bindings))


        String seq2b = getSparqlReply("application/json", qg.inclusiveSequencedObjects(urnStr))
        def reply2b = slurper.parseText(seq2b)
        reply.append(processObjectSequence(urnStr, reply2b.results.bindings) + "\n")

        } 

        return reply.toString()
    }


    /** Finds all relations to a given object
    * one degree distant in the graph.
    * First queries the SPARQL end point for objects related to 
    * urnStr that do *not* belong to a sequence, and adds them
    * directly to the reply. Then queries for objects related to
    * urnStr that *do* belong to a sequence, and groups them in a 
    * containing <sequence> element.
    * @param urnStr CITE URN value of the object to query about.
    * @param inclusive True if queries should also look for extended
    * URN references for the CITE Object or CTS text node cited in
    * the URN.
    * @returns The <graph> component of the CITE Index
    * reply element.
    */
    String findAdjacent(String urnStr, boolean inclusive) {
        // use this to choose XSLT to associate
        def ctype = determineCitationType(urnStr)

        // Build reply in three parts.
        StringBuffer reply = new StringBuffer("""<graph urn="${urnStr}">\n""")

        // Part 1: get namespace info:
        reply.append(getNsStatements())

        // Part 2: relations not in a sequence
        reply.append(getSimpleRelations(urnStr, inclusive))

        // Part 3: sequences of related objects
        reply.append(getSequencedRelations(urnStr, inclusive))

        reply.append("</graph>\n")

        return reply.toString()
    }


    /** Finds which of four possible citation types a given
    * String represents.
    * @param urnString String representation of a URN value.
    * @returns A CITE CitationType.
    */
    CiteDefinitions.CitationType determineCitationType (String urnString) 
    throws Exception {
        CiteDefinitions.CitationType citeType = null
        try {
            CtsUrn urn = new CtsUrn(urnString)
            if (urn.isRange()) {
                citeType = CiteDefinitions.CitationType.CTSRANGE
            } else {
                citeType = CiteDefinitions.CitationType.CTSPASSAGE
            }
        } catch (Exception ctse) {
        }

        try {
            CiteUrn urn = new CiteUrn(urnString)
            String collectionUrn = "urn:cite:${urn.getNs()}:${urn.getCollection()}"
            if (imgCollections.contains(collectionUrn) ) {
                citeType = CiteDefinitions.CitationType.CITEIMG
            } else {
                citeType = CiteDefinitions.CitationType.CITEOBJECT
                }
        } catch (Exception obje) {
        }

        if (!citeType) {
            citeType = CiteDefinitions.CitationType.RAWDATA
        }
        return citeType
    }


    /** Finds all CITE namespace abbreviations in the graph,
    * and formats them for the XML reply.
    * @returns A String composed of <citeNamespace> elements.
    */
    String getNsStatements() {
        StringBuffer reply = new StringBuffer()
        String nsData =  getSparqlReply("application/json", qg.nsQuery())
        def slurp1 = new JsonSlurper()
        def nsReply = slurp1.parseText(nsData)

        nsReply.results.bindings.each { b ->
            reply.append """<citeNamespace uri="${b?.s?.value}" abbr="${b?.o?.value}" />\n"""
        }
        return reply.toString()
    }


    /** Finds a human-readable label for an object by querying
    * the graph for an rdf:label statement.
    * @param urnStr The object to label.
    * returns The direct object of the rdf:label statement.
    */
    String getLabel(String urnStr) {
        StringBuffer reply = new StringBuffer()
        String labelData =  getSparqlReply("application/json", qg.labelQuery(urnStr))
        def slurp1 = new JsonSlurper()
        def labelReply = slurp1.parseText(labelData)
        def oneLabel = labelReply.results.bindings[0]
        return oneLabel?.o?.value
    }


    /**  Finds all relations to a given object that are
    * one degree distant in the graph, and do NOT belong to sequence. 
    * @param urnStr CITE URN value of the object to query about.
    * @param inclusive True if queries should also look for extended
    * URN references for the CITE Object or CTS text node cited in
    * the URN.
    * @returns A String composed of <node> statements.
    */
    String getSimpleRelations(String urnStr, boolean inclusive) {
        StringBuffer reply = new StringBuffer()
        String singleRelations  =  getSparqlReply("application/json", qg.simpleQuery(urnStr))
        def slurper = new JsonSlurper()
        def simpleReply = slurper.parseText(singleRelations)
        reply.append(formatSimple(simpleReply.results.bindings))

        if  (inclusive) {
            if (debug > 2) {
                System.err.println "simle relations: inclusive ${inclusive}, so query"
                System.err.println qg.inclusiveSimpleQuery(urnStr)
            }

            String includedRelations =  getSparqlReply("application/json", qg.inclusiveSimpleQuery(urnStr))
            def slurp2 = new JsonSlurper()
            def inclusiveReply = slurp2.parseText(includedRelations)
            reply.append(formatSimple(inclusiveReply.results.bindings))
        }
        return reply.toString()
    }

    String formatSimple(ArrayList bindings) {
        StringBuffer reply = new StringBuffer()
        bindings.each { b ->
            String label = ""
            if (b.lab?.value) { label = b.lab?.value }
            String taxon
            switch (determineCitationType(b?.o?.value)) {
                case CiteDefinitions.CitationType.CTSPASSAGE:
                case CiteDefinitions.CitationType.CTSRANGE:
                    taxon = "text"
                break
                case CiteDefinitions.CitationType.CITEOBJECT:
                    taxon = "object"
                break
                case CiteDefinitions.CitationType.CITEIMG:
                    taxon = "image"
                break
                case CiteDefinitions.CitationType.RAWDATA:
                    taxon = "data"
                break

            }
            reply.append("""<node s="${b.s?.value}" v="${b.v?.value}" type="${taxon}"><label>${label}</label><value>${b?.o?.value}</value></node>\n""")
        }
        return reply.toString()
    }


// this isn't really right.  Should only cluster and  format if objects
// share the same verb, I think.
    String formatObjectSequence(String sequenceLabel, ArrayList bindings) {
        def rdfSubj =  bindings[0]['s']['value']
        def rdfVerb = bindings[0]['v']['value']
        def ln = bindings[0]

        if (bindings.size() == 1) {
            if (ln != null) {
                String obj = ln['o']['value']
                String lab = ln['lab']['value']
                return """<node s="${rdfSubj}" v="${rdfVerb}" type="object">\n<label>${lab}</label>\n<value>${obj}</value>\n</node>\n"""
            } else {
                System.err.println "CiteGraph:formatObjectSequence: Single, null object in bindings."
                return ""
            }
        }

        if (ln != null) {
        String firstUrnVal = ln['o']['value']
        def lastBind = bindings[bindings.size() - 1]
        String lastUrnVal
        if (lastBind != null) {
            lastUrnVal = lastBind['o']['value']
        }
        String range
        String rangeLabel
        try {
            CiteUrn urn1 = new CiteUrn(firstUrnVal)
            CiteUrn urn2 = new CiteUrn(lastUrnVal)
            range = "${firstUrnVal}-${urn2.getObjectId()}"
            rangeLabel = "${urn1.getObjectId()}-${urn2.getObjectId()}"
        } catch (Exception e) {
            throw new Exception ("formatObjectSequence: unable to work with ${lastUrnVal}: ${e}")
        }

        StringBuffer lines = new StringBuffer("""<sequence s="${rdfSubj}" v="${rdfVerb}" type="text" urn="${range}">\n """)
        lines.append("<label>${sequenceLabel}: ${rangeLabel}</label>\n<value>\n")
        bindings.each { b ->
            if (b) {
                def subj = b['s']['value']
                def obj = b['o']['value']
                def lab = b['lab']['value']
                lines.append """<node s="${subj}" v="${rdfVerb}" type="text">\n<label>${lab}</label>\n<value>${obj}</value>\n</node>\n"""
            }
        }
        
        lines.append ("</value>\n</sequence>\n")
        return lines.toString()
        }
}


}
