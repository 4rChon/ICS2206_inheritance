import std.stdio;

import concept;
import node;
import util;

class Path
{
    Concept c_nil = new Concept("nil");
    
    Node n_nil;
    Node head;
    Node tail;
    
    int size;
    
    //initialise with at least one concept
    this(Concept concept)
    {
        this.n_nil = new Node(c_nil, this.n_nil);
        this.head = new Node(concept, this.n_nil);
        
        this.tail = this.head;
        
        this.size = 1;
    }
    
    this(Path path)
    {
        Concept[] conceptList = path.get_conceptList;
        this(conceptList[0]);
        
        foreach(c; conceptList[1..$])
            this.add(c);
    }
    
    Node get_head(){ return this.head; }
    
    Node get_tail(){ return this.tail; }
    
    Node get_nil(){ return this.n_nil; }
    
    int get_size(){ return this.size; }
    
    //simply add a concept to the list
    void add(Concept concept)
    {
        Node newNode = new Node(concept, this.n_nil);
        
        this.tail.nextNode = newNode;
        this.tail = newNode;
        
        this.size++;
    }
    
    Concept pop()
    {
        Node current = this.head;
        Node previous = this.n_nil;
        
        while(current.nextNode != this.n_nil)
        {
            previous = current;
            current = current.nextNode;
        }
        
        if(previous == this.n_nil)
            this.head = current.nextNode;
        else
        {
            previous.nextNode = current.nextNode;
            this.tail = previous;
        }
        
        this.size--;
        
        return current.get_concept;
    }
    
    //join two paths
    void join(Path path)
    {
        Node current = path.get_head;
        
        while(current != path.n_nil)
        {
            if(this == path)
                break;
            
            this.add(current.get_concept);
            current = current.nextNode;
        }
        
        this.size += path.get_size;
    }
    
    Concept[] get_conceptList()
    {
        Concept[] conceptList;
        
        Node current = this.head;
        Node previous = this.n_nil;       
        
        while(current.get_next != this.n_nil)
        {
            conceptList ~= current.get_concept;
            previous = current;
            current = current.get_next;
        }
        conceptList ~= current.get_concept;
        
        return conceptList;
    }
}
