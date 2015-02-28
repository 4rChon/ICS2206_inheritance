import concept;

class Node
{
    Concept concept;
    Node nextNode;
    
    this(Concept concept, Node nextNode)
    {
        this.concept = concept;
        this.nextNode = nextNode;    
    }
    
    Concept get_concept()
    {
        return this.concept;
    }
    
    Node get_next()
    {
        return nextNode;
    }
}
