import std.stdio;

import concept;
import edge;
import path;
import util;

class Graph
{
    Concept[] conceptList;
    Edge[] edgeList;
    
    void add(Edge edge)
    {
        bool subExists = false;
        bool superExists = false;
        
        Concept subConcept;
        Concept superConcept;
        
        foreach(c; this.conceptList)
        {
            if(edge.get_sub.compare_concept(c))
            {
                subExists = true;
                subConcept = c;
            }
            else
            if(edge.get_super.compare_concept(c))
            {
                superExists = true;
                superConcept = c;
            }
        }
        
        if(subExists)
        {
            if(superExists)
            {
                subConcept.join(superConcept, edge.get_isA);
                edge = new Edge(subConcept, superConcept, edge.get_isA);
            }
            else
            {
                subConcept.join(edge.get_super, edge.get_isA);
                edge = new Edge(subConcept, edge.get_super, edge.get_isA);
                conceptList ~= edge.get_super;
            }
        }
        else
        {
            
            if(superExists)
                edge = new Edge(edge.get_sub, superConcept, edge.get_isA);
            else
            {
                edge.get_sub.join(edge.get_super, edge.get_isA);
                edge = new Edge(edge.get_sub, edge.get_super, edge.get_isA);
                conceptList ~= edge.get_super;
            }
            conceptList ~= edge.get_sub;
        }
        edgeList ~= edge;
        
    }
    
    void add(Concept subConcept, Concept superConcept, bool isA)
    {
        Edge edge = new Edge(subConcept, superConcept, isA);
        
        add(edge);
    }
    
    Edge get_edge(Concept subConcept, Concept superConcept)
    {
        foreach(e; this.edgeList)
        {
            if(e.get_sub.compare_concept(subConcept) && e.get_super.compare_concept(superConcept))
                return e;
        }
        return new Edge(subConcept, superConcept, false);
    }  
}
