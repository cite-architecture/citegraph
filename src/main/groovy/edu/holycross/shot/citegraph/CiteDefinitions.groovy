package edu.harvard.chs.citegraph


/** 
*/
class CiteDefinitions {

    /** Namespace declaration to include in queries
    */
    static String prefixPhrase  = "PREFIX hmt:        <http://www.homermultitext.org/hmt/rdfverbs/>"


    static String belongsTo = "http://www.homermultitext.org/cite/rdf/belongsTo"

    static String hasOnIt = "http://www.homermultitext.org/cite/rdf/hasOnIt"

   

    /** Four distinct kinds of URN reference that we need
    * to distinguish to form SPARQL queries correctly.
    * URNs are either CTS or CITE Object URNs.  CTS URNs
    * may refer either to a single citable node, or to a
    * range of citable nodes.  When the URN is a CITE Object
    * URN, we want to distinguish the extended ChsImg type.
    */
    enum CitationType {
        CTSPASSAGE, CTSRANGE, CITEOBJECT,CITEIMG,RAWDATA
    }

    enum ReplyFormat {
        HMTXML, JSON, RDF
    }


    
    // useful sparql strings
    static String closeQuery = ")\n}\n"



    static String openObjQuery = "${prefixPhrase}\n SELECT   ?s ?v ?o\n  WHERE {\n  ?s  ?v  ?o  . \n	FILTER (str(?o)="





}
