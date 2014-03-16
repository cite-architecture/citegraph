package edu.harvard.chs.citegraph


/** Class to formulate SPARQL queries needed for CITE Index service.
*/
class QueryGenerator {
    
    /** String with prefix statements for SPARQL queries. */
    String prefix = "prefix hmt:        <http://www.homermultitext.org/hmt/rdf/> \nprefix cts:        <http://www.homermultitext.org/cts/rdf/> \nprefix cite:        <http://www.homermultitext.org/cite/rdf/> \nprefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> \nprefix dcterms: <http://purl.org/dc/terms/> \n"

    /** Nothing to construct. */
    QueryGenerator() {
    }

    /** Constructs SPARQL query to find CITE Image Archives. */
    String findImgColls() {
return """select ?s where {
?s <http://www.w3.org/1999/02/22-rdf-syntax-ns#type>  <http://www.homermultitext.org/cite/rdf/ImageArchive>  .
}"""
    }

    /** Constructs SPARQL query find the value of an rdf:label statement
    * for a specified object.
    * @param URN, as a String, of the object to label.
    * @returns Text of a SPARQL query.
    */
    String labelQuery(String urnStr) {
        String q = """
select ?s ?o where {
		BIND ( <${urnStr}> as ?s )
		?s  <http://www.w3.org/1999/02/22-rdf-syntax-ns#label> ?o .
}
"""
    return q
    }



    /** Constructs SPARQL query to find abbreviations of CITE namespaces */
    String nsQuery() {
return """
${prefix}
select ?s ?o where {
?s  cts:abbreviatedBy   ?o .
}"""
    }

    /** Constructs SPARQL query to find, by exact match of URN 
    * (excluding citations using extended notation),  objects that
    * are NOT in an ordered sequence, at one degree of relation in
    * the graph.
    * @param urnStr URN of object of interest, as a String value.
    * @returns Valid SPARQL query.
    */
    String simpleQuery(String urnStr) {
      return """
${prefix}
select ?s ?v ?o ?lab where {
BIND (<${urnStr}> as ?s )
{  ?s ?v ?o .
  ?o rdf:label ?lab .
} UNION {
?s ?v ?o . 
?o cite:isExtendedRef  ?par .
?par rdf:label ?lab .
}
}
"""
    }
//?o cite:ordered ?notsomuch .
    /** Constructs SPARQL query to find objects that
    * are NOT in an ordered sequence, by match of URN including
    * including extended citation, at one degree of relation in
    * the graph.
    * @param urnStr URN of object of interest, as a String value.
    * @returns Valid SPARQL query.
    */
//?o cite:ordered ?notsomuch .
    String inclusiveSimpleQuery(String urnStr) {
        return """
${prefix}

select ?s ?v ?o ?lab where {
 { 
   BIND (<${urnStr}> as ?s )
		?s ?v ?o .
   ?o rdf:label ?lab .

} UNION  { 
   BIND (<${urnStr}> as ?s )
   ?s <http://www.homermultitext.org/cite/rdf/isExtendedRef> ?trimmed .
   ?trimmed ?v ?o .
   ?o rdf:label ?lab .

} UNION {
   BIND (<${urnStr}> as ?s )
?s ?v ?o . 
?o cite:isExtendedRef  ?par .
?par rdf:label ?lab .



} UNION  { 
   BIND (<${urnStr}> as ?trimmed )
  ?trimmed <http://www.homermultitext.org/cite/rdf/hasExtendedRef>  ?s .
  ?s ?v ?o .
  ?o rdf:label ?lab .

  FILTER (str(?v) != "http://www.homermultitext.org/cite/rdf/isExtendedRef") .
 }

}

"""
    }

    /** Constructs SPARQL query to find an ordered sequence of objects by 
    * exact match of URN (excluding citations using extended notation),
    * at one degree of relation in the graph.
    * @param urnStr String value of the URN to query for.
    * @returns Valid SPARQL query.
    */


    String sequencedTexts(String urnStr) {
        return """
${prefix}
select ?s ?v ?o ?nxt ?lab where {
  BIND(<${urnStr}> as ?s )
   ?s ?v ?o .
  ?o  <http://www.homermultitext.org/cts/rdf/hasSequence>   ?nxt .
  ?o rdf:label ?lab .
}
ORDER BY ?nxt 
"""
}


String sequencedObjects(String urnStr) {
        return """
${prefix}
select ?s ?v ?o ?nxt ?lab where {
  BIND(<${urnStr}> as ?s )
 ?s ?v ?o .
  ?o  <http://purl.org/ontology/olo/core#item> ?nxt .
  ?o rdf:label ?lab .

}
ORDER BY ?nxt 
"""

}


    String inclusiveSequencedTexts(String urnStr) {
        return """
${prefix}
select ?s ?v ?o ?nxt ?lab where {
  BIND(<${urnStr}> as ?trimmed)
   ?trimmed <http://www.homermultitext.org/cite/rdf/hasExtendedRef>  ?s .
   ?s ?v ?o .
   ?o rdf:label ?lab .
   ?o  <http://www.homermultitext.org/cts/rdf/hasSequence>    ?nxt .
  FILTER (str(?v) != "http://www.homermultitext.org/cite/rdf/isExtendedRef") . 
}
ORDER BY ?nxt
"""
}

String inclusiveSequencedObjects(String urnStr) {
        return """
${prefix}
select ?s ?v ?o ?nxt ?lab where {
  BIND(<${urnStr}> as ?trimmed)
   ?trimmed <http://www.homermultitext.org/cite/rdf/hasExtendedRef>  ?s .
   ?s ?v ?o .
   ?o rdf:label ?lab .
   ?o  <http://purl.org/ontology/olo/core#item>   ?nxt .
  FILTER (str(?v) != "http://www.homermultitext.org/cite/rdf/isExtendedRef") . 
}
ORDER BY ?nxt
"""
}


}



