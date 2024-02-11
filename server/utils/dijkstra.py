from inc import *

def dijkstra(graph, start, end):
    distances = {node: float('inf') for node in graph}
    distances[start] = 0
    pq = [(0, start)]  
    previous = {node: None for node in graph}

    while pq:
        current_distance, current_node = heapq.heappop(pq)

        if current_distance > distances[current_node]:
            continue

        for neighbor, weight in graph[current_node].items():
            distance = current_distance + weight
            if distance < distances[neighbor]:
                distances[neighbor] = distance
                previous[neighbor] = current_node
                heapq.heappush(pq, (distance, neighbor))


    path = []
    current_node = end
    while current_node is not None:
        path.append(current_node)
        current_node = previous[current_node]
    path.reverse()

    return path, distances[end], distances

if __name__ == "__main__":

    # TODO Clense the data from shreyesh similar to this
    graph = {
        'A': {'B': 5, 'C': 3},
        'B': {'A': 5, 'C': 2, 'D': 1},
        'C': {'A': 3, 'B': 2, 'D': 4, 'E': 6},
        'D': {'B': 1, 'C': 4, 'E': 8},
        'E': {'C': 6, 'D': 8}
    }

    start_node = 'A'    #SET HERE
    end_node = 'E'      #SET HERE

    shortest_path, shortest_distance, distance_array= dijkstra(graph, start_node, end_node)
    print(f"Shortest path from {start_node} to {end_node}: {shortest_path}")
    print(f"Shortest distance: {shortest_distance}")
    print(distance_array)