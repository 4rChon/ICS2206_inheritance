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
            pathList.print_pathList(G, "\n");
            
            shortest(pathList, G);
            
            writeln("\nPreferred Path (Inferential Distance):");
            pathList = query_path(parse_input(query), G, true);
            pathList.print_pathList(G, "\n");
        }
        else
            writeln("No Paths found");
    }
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
            p.print_path(G);
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
    {
        if(c.compare_concept(subConcept))
            subExists = true;
        if(c.compare_concept(superConcept))
            superExists = true;
    }
    
    if(subExists && superExists)
    {
        if(!infer)
        {
            foreach(e; G.edgeList)
            {
                if(e.get_sub.compare_concept(subConcept))
                {
                    Path path = new Path(e.get_sub);
                    pathList = query_rec(e.get_super, superConcept, path, pathList, true);
                }
            }
        }
        
        foreach(c; G.conceptList)
        {
            if(c.compare_concept(subConcept))
            {
                subConcept = c;
                break;
            }
        }
        
        if(infer)
        {
            Path path = new Path(subConcept);
            pathList ~= query_infer(G, subConcept, superConcept, path, true);
        }
        
        Path[] newPathList;
        foreach(index, p; pathList)
        {
            if(p.get_tail.get_concept.compare_concept(superConcept))
                newPathList ~= pathList[index];
        }
        pathList = newPathList;
    }
    return pathList;
}

Path[] query_rec(Concept currentConcept, Concept finalConcept, Path path, Path[] pathList, bool isA)
{
    if(currentConcept.compare_concept(finalConcept))
    {
        path.add(currentConcept);
        pathList ~= path;
        return pathList;
    }
    
    if(!isA)
        return pathList;
    
    Concept[] adjTrue = currentConcept.get_adjTrue;
    Concept[] adjFalse = currentConcept.get_adjFalse;
    Concept[] adj = adjTrue ~ adjFalse;
    
    if(adj.length == 0)
    {
        pathList ~= path;
        return pathList;
    }
    
    foreach(c; adj)
    {
        foreach(negativeConcept; adjFalse)
        {
            if(c.compare_concept(negativeConcept))
                isA = false;
        }
        
        Path newPath = new Path(path);
        newPath.add(currentConcept);
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
    {
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
    }
    return path;
}

Concept closest(Graph G, Concept currentConcept, Concept nextA, Concept nextB)
{
    Edge query = new Edge(currentConcept, nextA, true);
    
    if(currentConcept.get_adjFalse.contain_concept(nextB))
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

