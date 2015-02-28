import std.stdio;
import concept;
import util;

class Edge
{
    Concept subConcept;
    Concept superConcept;
    
    bool isA;
    
    this(Concept subConcept, Concept superConcept, bool isA)
    {
        this.subConcept = subConcept;
        this.superConcept = superConcept;
        this.isA = isA;
    }
    
    Concept get_sub(){ return this.subConcept; }
    
    Concept get_super(){ return this.superConcept; }
    
    bool get_isA(){ return this.isA; }
    
    void set_sub(Concept subConcept){ this.subConcept = subConcept; }
    
    bool compare_edge(Edge edge)
    {
        return ((this.subConcept.compare_concept(edge.get_sub)) && (this.superConcept.compare_concept(edge.get_super)) && (this.isA == edge.get_isA));
    }
}
