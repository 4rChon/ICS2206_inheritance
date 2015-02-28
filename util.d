import std.stdio;
import std.string;
import node;
import concept;
import edge;
import path;
import graph;

bool contain_concept(Concept[] conceptList, Concept concept)
{
    foreach(c; conceptList)
    {
        if(c.compare_concept(concept))
            return true;
    }
    return false;
}

Edge parse_input(string input)
{
    string[] wordList = input.split(" ");
    bool isA;
    Concept subConcept, superConcept;
    foreach(index, word; wordList)
    {
        switch(index)
        {
            case 0: subConcept = new Concept(word);
            break;
            case 1: isA = string_to_bool(word);
            break;
            case 2: superConcept = new Concept(word);
            break;
            default:
            break;
        }
    }
    
    return new Edge(subConcept, superConcept, isA);
}

string get_input(string prompt)
{
    write(prompt);
    return strip(readln);
}

bool string_to_bool(string flag)
{
    if(flag == "IS-A")
        return true;
    return false;
}

string bool_to_string(bool flag)
{
    if(flag)
        return "IS-A";
    return "IS-NOT-A";
}

void print_concept(Concept concept)
{
    write(concept.conceptName);
    
    if(concept.get_adjTrue.length > 0)
    {
        write(" IS-A ");
        foreach(c; concept.get_adjTrue)
            write(c.get_name, ", ");
    }
    
    if(concept.get_adjFalse.length > 0)    
    {
        write(" IS-NOT-A ");
        foreach(c; concept.get_adjFalse)
            write(c.get_name, ", ");    
    }
}

void print_edge(Edge edge)
{
    writeln(edge.get_sub.get_name, " ", bool_to_string(edge.get_isA), " ", edge.get_super.get_name);
}

void print_path(Path path, Graph G)
{
    Node current = path.get_head;
    
    while(current != path.get_nil)
    {
        if(current.nextNode != path.get_nil)
        {
            Edge edge = G.get_edge(current.get_concept, current.nextNode.get_concept);
            write(current.get_concept.get_name, ' ', bool_to_string(edge.get_isA), ' ');
        }
        else
            write(current.get_concept.get_name);
        
        current = current.nextNode;
    }
}

void print_graph(Graph G)
{
    foreach(e; G.edgeList)
    {
        e.print_edge();
    }
}

void print_pathList(Path[] pathList, Graph G, string stringBreak)
{
    foreach(p; pathList)
    {
        p.print_path(G);
        write(stringBreak);
    }
}

Concept[] remove_at_index(Concept[] array, size_t index)
{
    array = array[0..index] ~ array[index+1..$];
    return array;
}
