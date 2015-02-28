import std.stdio;
import std.string;
import util;
import concept;
import edge;
import path;
import graph;

void construct(Graph G)
{
    string input = "\n";
    
    while(input != "")    
    {
        input = get_input("\nEnter statement: <Sub-Concept> <IS-A | IS-NOT-A> <Super-Concept>\n");
        
        if(input == "")
            break;
        
        G.add(parse_input(input));
    }
}

void query(Graph G)
{
    string query = "\n";
    
    while(query != "")
    {
        Path[] pathList = [];
        query = get_input("\nEnter query: <Sub-Concept> <IS-A> <Super-Concept>\n");
        
        if(query == "")
            break;
            
        pathList = query_path(parse_input(query), G, false);

        if(pathList.length > 0)
        {
            writeln("\nAll paths:");
            pathList.print_pathList;
            
            shortest(pathList, G);
            
            writeln("\nPreferred Path (Inferential Distance):");
            pathList = query_path(parse_input(query), G, true);
            pathList.print_pathList;
        }
        else
            writeln("No Paths found");
    }
}

void inferential()
{
    
}

void shortest(Path[] pathList, Graph G)
{
    writeln("\nPreferred Path (Shortest Distance):");
    
    int shortest = pathList[0].get_size;
    
    foreach(p; pathList)
        if(shortest > p.get_size)
            shortest = p.get_size;
    
    foreach(p; pathList)
        if(shortest == p.get_size)
        {
            p.print_path;
            writeln();
        }
}

Path[] query_path(Edge query, Graph G, bool infer)
{
    Path[] pathList = [];
    
    bool subExists = false;
    bool superExists = false;
    
    Concept subConcept = query.get_sub;
    Concept superConcept = query.get_super;
    bool isA = query.get_isA;
    
    subExists = contain_concept(G.conceptList, subConcept);
    superExists = contain_concept(G.conceptList, superConcept);
    
    if(subExists && superExists)
    {
        
        foreach(e; G.edgeList)                          //iterate over all edges in subconcept
            if(e.get_sub.compare_concept(subConcept)) 
            {
                if(!infer)
                {
                    e.print_edge;
                    Path path = new Path(e.get_sub);
                    pathList = query_rec(e.get_super, superConcept, path, pathList, e.get_isA);
                }
                
                if(infer)
                {
                    Path path = new Path(e.get_sub);
                    pathList ~= query_infer(G, subConcept, superConcept, path, true);
                }
            }
        
        Path[] newPathList;
        
        foreach(index, p; pathList)
            if(p.get_tail.get_concept.compare_concept(superConcept))
                newPathList ~= pathList[index];

        pathList = newPathList;
    }
    return pathList;
}

Path[] query_rec(Concept currentConcept, Concept finalConcept, Path path, Path[] pathList, bool isA)
{
    writeln("current concept: ");
    currentConcept.print_concept;
    writeln("\n");
    Concept[] adjTrue = currentConcept.get_adjTrue;
    Concept[] adjFalse = currentConcept.get_adjFalse;
    Concept[] adj = adjTrue ~ adjFalse;
    
    if(currentConcept.compare_concept(finalConcept))
    {
        path.add(currentConcept);
        pathList ~= path;
        return pathList;
    }
    
    if(!isA)
        return pathList;
    
    writeln("adj.length: ", adjTrue.length + adjFalse.length);
    if(adj.length == 0)
        return pathList;
    
    foreach(c; adj)
    {
        if(adjFalse.contain_concept(c))
            isA = false;
        
        Path newPath = new Path(path);
        newPath.add(currentConcept);
        writeln("-----------\nconcept:");
        currentConcept.print_concept;
        writeln("\n-----------\npathList:");
        pathList.print_pathList;
        writeln("-----------");
        pathList = query_rec(c, finalConcept, newPath, pathList, isA);
    }

    return pathList;
}  

Path query_infer(Graph G, Concept currentConcept, Concept finalConcept, Path path, bool isA)
{
    Concept[] adjTrue = currentConcept.get_adjTrue;
    Concept[] adjFalse = currentConcept.get_adjFalse;
    Concept[] adj = adjTrue ~ adjFalse;
    
    Concept closestConcept = finalConcept;
    
    if(currentConcept.compare_concept(finalConcept))
        return path;
    
    if(!isA)
        return path;
    
    if(adj.length > 0)
        while(adj.length > 0)
        {
            int closestIndex = 0;
            
            foreach(index, c; adj)
            {
                closestConcept = closest(G, currentConcept, closestConcept, c);
                closestIndex = index;
            }
            
            if(adjFalse.contain_concept(closestConcept))
                isA = false;
            
            path.add(closestConcept);
            
            query_infer(G, closestConcept, finalConcept, path, isA);
            isA = true;
            
            if(!path.get_tail.get_concept.compare_concept(finalConcept))
            {
                path.pop;
                adj = adj[0..closestIndex] ~ adj[closestIndex+1..$];
            }
            else
                return path;
        }
    return path;
}

Concept closest(Graph G, Concept currentConcept, Concept nextA, Concept nextB)
{
    Edge query = new Edge(currentConcept, nextA, true);
    
    if(currentConcept.get_adjFalse.contain_concept(nextB)) //IS-NOT-A priority
        return nextB;
    
    Path[] pathList = [];
    pathList = query_path(query, G, false);
    
    foreach(p; pathList)
        if(p.get_conceptList[0..$-1].contain_concept(nextB))
            return nextB;
        
    return nextA;
}

void main()
{
    Graph G = new Graph;
    
    construct(G);
    query(G);
}

