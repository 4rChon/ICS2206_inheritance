import std.stdio;

class Concept
{
    string conceptName;
    
    //adjacent IS-A and IS-NOT-A concepts
    Concept[] adjTrue;
    Concept[] adjFalse;
    
    this(string conceptName)
    {
        this.conceptName = conceptName;
    }
    
    string get_name()
    {
        return this.conceptName;
    }
    
    //join concepts and make the superConcept adjacent to the subConcept
    void join(Concept concept, bool isA)
    {
        bool exists = false;
        
        if(isA)
        {
            foreach(c; adjTrue)
            {
                if(c.compare_concept(concept))
                {
                    writeln("Already adjacent!");
                    exists = true;
                }
            }
            if(!exists) adjTrue ~= concept;
        }
        else 
        {
            foreach(c; adjFalse)
            {
                if(c.compare_concept(concept))
                {
                    writeln("Already adjacent!");
                    exists = true;
                }
            }
            if(!exists) adjFalse ~= concept;
        }
    }
    
    Concept[] get_adjTrue()
    {
        return this.adjTrue;
    }
    
    Concept[] get_adjFalse()
    {
        return this.adjFalse;
    }
    
    Concept[] get_adj(bool isA)
    {
        if(isA)
            return this.adjTrue;
        else
            return this.adjFalse;
    }
    
    int get_adj_length()
    {
        return this.adjTrue.length + this.adjFalse.length;
    }
    
    bool compare_concept(Concept concept)
    {
        if(this.conceptName == concept.get_name)
            return true;
        return false;
    }
}
