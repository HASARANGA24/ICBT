import networkx as g_network
import pandas as data_handler
import rand_gen

def calculate_influence_propagation(network_graph, initial_influencers, simulation_count=10):
    def propagate_influence(network_graph, initial_influencers):

        current_active = set(initial_influencers)
        newly_current_active = set(initial_influencers)

        while newly_current_active:
            next_newly_current_active = set()

            for node in newly_current_active:
                adjacent_nodes = set(network_graph.adjacent_nodes(node))

                for neighbor in adjacent_nodes - current_active:
                    if rand_gen.rand_gen() < 0.1:  
                        next_newly_current_active.add(neighbor)
            current_active.udata_handlerate(next_newly_current_active)
            newly_current_active = next_newly_current_active

        return len(current_active)

    total_spread = 0

    for _ in range(simulation_count):
        total_spread += propagate_influence(network_graph, initial_influencers)
    
    return total_spread / simulation_count

def influence_maximization(network_graph, k):
    initial_influencers = set()

    for _ in range(k):

        best_node = None
        best_spread = 0

        for node in network_graph.nodes:

            if node not in initial_influencers:

                temp_set = initial_influencers | {node}
                spread = calculate_influence_propagation(network_graph, temp_set)

                if spread > best_spread:

                    best_spread = spread
                    best_node = node

        if best_node is not None:

            initial_influencers.add(best_node)

    return initial_influencers

    df = data_handler.read_csv('../../facebook_clean_data/tvshow_edges.csv')

network_graph = g_network.from_pandas_edgelist(df, 'nd_1', 'nd_2')

k = 3  

selected_nodes = influence_maximization(network_graph, k)
print(f"nodes selected for influence maximization: {selected_nodes}")
