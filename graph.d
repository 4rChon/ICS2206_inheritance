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
        bool edgeExists = false;
        
        Concept subConcept = edge.get_sub;
        Concept superConcept = edge.get_super;
        
        foreach(c; this.conceptList)
        {
            if(subConcept.compare_concept(c) && !subExists)
            {
                subExists = true;
                subConcept = c;
            }
            else
            if(superConcept.compare_concept(c) && !superExists)
            {
                superExists = true;
                superConcept = c;
            }
        }

        if(!subExists)
            conceptList ~= subConcept;
        
        if(!superExists)
            conceptList ~= superConcept;
        
        
        foreach(e; edgeList)
        {
            if(e.get_sub == subConcept && e.get_super == superConcept)
            {
                edgeExists = true;
                writeln("\nEdge already exists!\n");
                break;
            }
        }
        
        if(!edgeExists)
        {
            subConcept.join(superConcept, edge.get_isA);
            edge = new Edge(subConcept, superConcept, edge.get_isA);
            edgeList ~= edge;
        }
        
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
