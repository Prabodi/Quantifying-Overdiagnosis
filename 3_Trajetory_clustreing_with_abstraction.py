# This will consider concurrent events.
# This will consider only TP and TN cases.

# with previous ground truth - trace_index - [   0    1    2 ... 7600 7601 7602 7603] / with new ground truth [   0    1    2 ... 7606 7607 7608 7609]


# add only TP and TN patients
# remove label column form prevous event log and add the new one

# same as V28_6, however this directly feed df(from csv file) to format for pm4py
# Also this cosider 'concurrent' nature of the events

# hadm_id - 20762263 (previous_trace_index = 1, current_trace_index = 88, previous trace = [first_heparin_dose, PT_hosp_normal, Platelet_count_hosp_normal, last_heparin_dose] , current trace = ((first_heparin_dose,), (PT_hosp_normal,), (Platelet_count_hosp_normal,), (last_heparin_dose,)))
# hadm_id - 20762263 (previous_trace_index = 1, current_trace_index = 1, previous trace = [first_heparin_dose, PT_hosp_normal, Platelet_count_hosp_normal, last_heparin_dose] , current trace = ((first_heparin_dose,), (PT_hosp_normal, Platelet_count_hosp_normal), (last_heparin_dose,))

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import pm4py
import sys
import collections
from datetime import timedelta
import time
from memory_profiler import memory_usage
import random
import os

# Set a random seed for reproducibility
random.seed(0)
np.random.seed(0)

# Open a file for writing
file_name = sys.argv[7]  # '/Users/psenevirathn/Desktop/output_v1.txt'  # Output file. Adjust the path as needed
file_w = open(file_name, 'w')


def calculate_fitness(log, noise_threshold):
    random.seed(0)
    np.random.seed(0)

    process_model, initial_marking, final_marking = pm4py.discover_petri_net_inductive(log,
                                                                                       noise_threshold=noise_threshold, disable_fallthroughs=True)
    # a paper used noise threshold = 0.2 - SaCoFa: Semantics-aware Control-flow Anonymization for Process Mining

    # visualise the petri net

    # gviz = pm4py.visualization.petri_net.visualizer.apply(process_model, initial_marking, final_marking)
    # pm4py.visualization.petri_net.visualizer.view(gviz)

    return process_model, initial_marking, final_marking


# To form the confusion matrix

def determine_class(row):
    if row['HIT_label_actual'] == 1 and row['HIT_label_predicted'] == 1:
        return 'TP'
    elif row['HIT_label_actual'] == 1 and row['HIT_label_predicted'] == 0:
        return 'FN'
    elif row['HIT_label_actual'] == 0 and row['HIT_label_predicted'] == 1:
        return 'FP'
    elif row['HIT_label_actual'] == 0 and row['HIT_label_predicted'] == 0:
        return 'TN'


def calculate_cluster_distribution(cluster_data, event_log_selected_formatted):
    cluster_distribution_list = []

    # Get unique clusters
    unique_clusters = cluster_data['cluster_index'].unique()

    for cluster_index in unique_clusters:
        cluster_patients = cluster_data[cluster_data['cluster_index'] == cluster_index]

        # Total patient count
        patient_count = cluster_patients.shape[0]

        # HIT actual counts
        HIT_positive_actual_count = cluster_patients[cluster_patients['class'] == 'TP'].shape[0]
        HIT_negative_actual_count = cluster_patients[cluster_patients['class'] == 'TN'].shape[0]

        # HIT actual percentages
        HIT_positive_actual_per = (HIT_positive_actual_count / patient_count) * 100
        HIT_negative_actual_per = (HIT_negative_actual_count / patient_count) * 100

        # TP and TN counts
        TP_count = cluster_patients[cluster_patients['class'] == 'TP'].shape[0]
        TN_count = cluster_patients[cluster_patients['class'] == 'TN'].shape[0]

        # Append to list
        cluster_distribution_list.append([
            cluster_index, patient_count, HIT_positive_actual_count, HIT_negative_actual_count,
            HIT_positive_actual_per, HIT_negative_actual_per, TP_count, TN_count
        ])

    # Create DataFrame
    cluster_distribution = pd.DataFrame(cluster_distribution_list, columns=[
        'cluster_index', 'patient_count', 'HIT_positive_actual_count', 'HIT_negative_actual_count',
        'HIT_positive_actual_per', 'HIT_negative_actual_per', 'TP_count', 'TN_count'
    ])

    return cluster_distribution


# Main clustering function
def cluster_traces(event_log_path, train_labels_path, test_labels_path, unique_trace_count_to_cluster,
                   noise_threshold_inductive_miner,
                   target_fitness_clustering, file_w, clusters_hadmid_level_csv_path, clusters_clusters_level_csv_path):
    # input parameters

    unique_trace_count_to_cluster = int(unique_trace_count_to_cluster)  # number of unique traces to consider
    noise_threshold_inductive_miner = float(noise_threshold_inductive_miner)  # noise thershold for inductive miner
    target_fitness_clustering = float(target_fitness_clustering)  # target fitness for conformance checking

    train_labels = pd.read_csv(train_labels_path)
    test_labels = pd.read_csv(test_labels_path)

    train_labels['data_set'] = 'train'
    test_labels['data_set'] = 'test'

    both_train_test_labels = pd.concat([train_labels, test_labels], axis=0).drop('Unnamed: 0', axis=1)

    # -----------------------------------------------

    event_log_full = pd.read_csv(event_log_path)

    event_log_full = event_log_full.drop(['HIT_label'],
                                         axis=1)  # this event_log 'HIT label' is wrong. We changed the ground truth for HIT, from <=150k to <150k. Therefore, drop the previous label, and add the updated label.(after submitting the paper, we add te correct column for this, from script V16.py)

    # Apply the function to each row in the DataFrame
    both_train_test_labels['class'] = both_train_test_labels.apply(determine_class, axis=1)

    event_log_full = pd.merge(event_log_full, both_train_test_labels, on='hadm_id', how='left')[
        ['hadm_id', 'event', 'event_time', 'event_encoded', 'HIT_label_actual', 'HIT_label_predicted', 'class']]

    # --------------------------------------------------------------------------------------------------

    event_log_full['event_time'] = pd.to_datetime(event_log_full['event_time'])

    # if multiple events happened in the same time, sort 'event' by ascending order too.

    event_log_full_sorted = event_log_full.sort_values(by=['hadm_id', 'event_time', 'event'])

    event_log_only_TP_and_TN = event_log_full_sorted[
        (event_log_full_sorted['class'] == 'TP') | (event_log_full_sorted['class'] == 'TN')]

    print(len(event_log_full_sorted['hadm_id'].unique()))  # with previous ground truth - 13415 / with new ground truth - 13415

    print(len(event_log_only_TP_and_TN['hadm_id'].unique()))  # with previous ground truth - 12341 / with new ground truth - 12355

    print(len(event_log_only_TP_and_TN[event_log_only_TP_and_TN['class'] == 'TP']['hadm_id'].unique()))  # with previous ground truth - 1053 / with new ground truth - 909

    print(len(event_log_only_TP_and_TN[event_log_only_TP_and_TN['class'] == 'TN']['hadm_id'].unique()))  # with previous ground truth - 11288 / with new ground truth - 11446
    
    print('check trajetory length stats')

    print(event_log_only_TP_and_TN.head())

    print(event_log_only_TP_and_TN.groupby('hadm_id').agg(
        event_count_per_patient=('hadm_id', lambda x: len(x))).reset_index().describe()) # return stats related to trajetiry length

    print(event_log_only_TP_and_TN['event'].nunique()) # 47 - number of unique events
    # --------------------------------------------------------------------------------------------------

    # Differentiate concurrent and non-concurrent traces

    grouped = event_log_only_TP_and_TN.groupby('hadm_id')

    # Initialize a dictionary to store traces for each case_id

    case_traces = {}

    # Process each group
    for hadm_id, group in grouped:
        # Initialize an empty trace
        trace = []

        # Iterate over events in the group
        for idx, row in group.iterrows():
            event = row['event']
            timestamp = row['event_time']

            # If the trace is empty or the current event timestamp is different from the last one, append a new event
            if not trace or trace[-1][1] != timestamp:
                trace.append(([event], timestamp))
            else:
                # If the timestamp is the same as the last one, it means the events are concurrent
                trace[-1][0].append(event)

        # Sort each list of concurrent events to avoid different orders of the same concurrent events being considered different
        trace = tuple([tuple(sorted(events)) for events, _ in trace])
        case_traces[hadm_id] = trace

    # Convert the dictionary to a DataFrame
    traces = pd.DataFrame(list(case_traces.items()), columns=['hadm_id', 'trace'])

    # --------------------------------------------------------------------------------------------------

    # Calculate the frequency of unique traces
    trace_counter = collections.Counter(traces['trace'])  # Convert lists to tuples for hashing

    # Get the most common trace(s)
    # most_frequent_trace = trace_counter.most_common(1)[0]  # The most common trace and its count

    # print(most_frequent_trace)
    # (('first_heparin_dose',), ('Platelet_count_hosp_normal',), ('last_heparin_dose',)), 448)

    # most_frequent_trace_seq = most_frequent_trace[0]  # The most common trace sequence

    # print(most_frequent_trace_seq)
    # (('first_heparin_dose',), ('Platelet_count_hosp_normal',), ('last_heparin_dose',))

    # --------------------------------------------------------------------------------------------------

    # Create a DataFrame from the Counter object (unique trace count)
    trace_df = pd.DataFrame(list(trace_counter.items()), columns=['trace', 'frequency'])

    # --------------------------------------------------------------------------------------------------

    # Add 'hadm_id' and 'HIT_label' information to the DataFrame

    # Create a mapping from trace to 'hadm_id'

    trace_to_hadm_ids = traces.groupby(traces['trace'])['hadm_id'].apply(list)

    # Create a mapping from trace to 'HIT_label' list

    first_row_of_each_hadm_id = event_log_only_TP_and_TN.groupby('hadm_id').first().reset_index()

    trace_to_HIT_labels_actual = traces.groupby(traces['trace'])['hadm_id'].apply(
        lambda x: first_row_of_each_hadm_id[first_row_of_each_hadm_id['hadm_id'].isin(x)]['HIT_label_actual'].tolist())

    trace_to_HIT_labels_predicted = traces.groupby(traces['trace'])['hadm_id'].apply(
        lambda x: first_row_of_each_hadm_id[first_row_of_each_hadm_id['hadm_id'].isin(x)][
            'HIT_label_predicted'].tolist())

    # --------------------------------------------------------------------------------------------------

    trace_df['hadm_id_list'] = trace_df['trace'].apply(
        lambda x: trace_to_hadm_ids[x])  # 'trace' acts as 'index' in 'trace_to_hadm_ids' (after 'group by')

    trace_df['HIT_label_actual_list'] = trace_df['trace'].apply(lambda x: trace_to_HIT_labels_actual[x])

    trace_df['HIT_label_predicted_list'] = trace_df['trace'].apply(lambda x: trace_to_HIT_labels_predicted[x])

    trace_df['trace_as_list'] = trace_df['trace'].apply(lambda x: list(x))
    trace_df['trace_length'] = trace_df['trace_as_list'].apply(lambda x: len(x))

    trace_df_sorted = trace_df.sort_values(by=['frequency', 'trace_length'], ascending=[False,
                                                                                        True])  # most frequent trace pick first. If have two traces with same frequency, then take the shortest one first.

    trace_df_sorted['trace_index'] = range(len(trace_df_sorted))  # Assign indices starting from 0. with previous ground truth [   0    1    2 ... 7600 7601 7602 7603] / with new ground truth [   0    1    2 ... 7606 7607 7608 7609]

    print(trace_df_sorted['trace_index'].sort_values())
    # trace_df_sorted - with previous ground truth 7604 rows / with new ground truth 7610 rows
    # event_log_formatted - 107730 rows , 13415 unique hadm_ids

    # --------------------------------------------------------------------------------------------------

    # join 'trace' with each row of event_log

    event_log_raw_full_joined_trace = pd.merge(event_log_only_TP_and_TN, traces[['hadm_id', 'trace']], on='hadm_id',
                                               how='left')

    # join other related trace information (trace_index, trace_length, hadm_id list, HIT_list) with each row of event_log

    event_log_raw_full_joined_trace_info = pd.merge(event_log_raw_full_joined_trace, trace_df_sorted, on='trace',
                                                    how='left')

    # --------------------------------------------------------------------------------------------------

    # Get the first N unique 'hadm_id' values

    first_N_unique_traces = np.sort(event_log_raw_full_joined_trace_info['trace_index'].unique())[
                            :unique_trace_count_to_cluster]  # 'trace_index' is the lowest in the most frequent trace

    # Filter the DataFrame to get rows for the first N unique 'hadm_id's
    event_log_selected_raw = event_log_raw_full_joined_trace_info[
        event_log_raw_full_joined_trace_info['trace_index'].isin(first_N_unique_traces)]

    random.seed(0)
    np.random.seed(0)

    event_log_selected_formatted = pm4py.format_dataframe(event_log_selected_raw, case_id='hadm_id',
                                                          activity_key='event', timestamp_key='event_time')

    # --------------------------------------------------------------------------------------------------

    # pick one hadm_id per one trace_index
    first_hadm_id_of_each_trace_index = event_log_selected_formatted.groupby('trace_index').first().reset_index()[
        ['trace_index', 'hadm_id']]

    # ---------------------------------------------------------------------------------

    # Initialize clusters
    clusters = []

    # Add the first trace to the first cluster

    first_trace_group = event_log_selected_formatted[
        event_log_selected_formatted['trace_index'] == 0]  # add all traces in the
    clusters.append(first_trace_group)

    # List to store hadm_id, trace_index, and cluster_index

    cluster_data = []

    # Add hadm_ids with trace_index 0 to the cluster_data
    hadm_ids_with_trace_index_0 = event_log_selected_formatted[event_log_selected_formatted['trace_index'] == 0][
        'hadm_id'].unique()
    for hadm_id in hadm_ids_with_trace_index_0:  # columns=['hadm_id', 'trace_index', 'cluster_index', 'class'])
        cluster_data.append((hadm_id, 0, 0,
                             event_log_selected_formatted[event_log_selected_formatted['hadm_id'] == hadm_id][
                                 'class'].iloc[0]))

    # ---------------------------------------------------------------------------------

    # Step 2: Iterate over the remaining case IDs

    # List to store hadm_id, trace_index, and cluster_index

    case_ids = np.sort(first_hadm_id_of_each_trace_index['trace_index'])[1:]

    for case_id in case_ids:

        hadm_id_of_trace_index_to_consider = \
            first_hadm_id_of_each_trace_index[first_hadm_id_of_each_trace_index['trace_index'] == case_id]['hadm_id']

        current_trace = event_log_selected_formatted[
            event_log_selected_formatted['hadm_id'] == hadm_id_of_trace_index_to_consider.iloc[0]].sort_values(
            by=(['event_time', 'event']))

        best_fitness = 0
        best_cluster_index = -1

        # Try to add the current trace to existing clusters
        for i, cluster in enumerate(clusters):

            process_model, initial_marking, final_marking = calculate_fitness(cluster, noise_threshold_inductive_miner)

            print(f"Case ID: {case_id}, Cluster: {i}", file=file_w)

            print('\n', file=file_w)

            print(f"process_model: {process_model, initial_marking, final_marking}", file=file_w)

            print('\n', file=file_w)

            random.seed(0)
            np.random.seed(0)

            # Calculate the fitness of the new trace against the existing process model
            fitness_new_trace = pm4py.conformance.fitness_alignments(
                current_trace,
                process_model,
                initial_marking,
                final_marking
            )

            if fitness_new_trace['log_fitness'] >= best_fitness:
                # If the fitness meets or exceeds the target, add to the cluster
                best_fitness = fitness_new_trace['log_fitness']
                best_cluster_index = i

        # If no existing cluster can accommodate the trace without decreasing fitness, create a new cluster
        # If the best fitness meets or exceeds the target, add to the best-fitting cluster

        print(case_id, best_cluster_index, best_fitness, 'yes' if best_fitness >= target_fitness_clustering else 'no')  # trace_index | cluster_number | fitness
        sys.stdout.flush()

        file_w.write(
            f"{case_id}, {best_cluster_index}, {best_fitness}, {'yes' if best_fitness >= target_fitness_clustering else 'no'}\n")
        print('\n\n', file=file_w)

        if best_fitness >= target_fitness_clustering:
            clusters[best_cluster_index] = pd.concat([clusters[best_cluster_index], event_log_selected_formatted[
                event_log_selected_formatted['trace_index'] == case_id]])
        else:
            # If no existing cluster can accommodate the trace without decreasing fitness, create a new cluster
            clusters.append(event_log_selected_formatted[event_log_selected_formatted['trace_index'] == case_id])
            best_cluster_index = len(clusters) - 1

        # Append all hadm_ids with that particular trace_index to the list
        hadm_ids_with_trace_index = \
            event_log_selected_formatted[event_log_selected_formatted['trace_index'] == case_id]['hadm_id'].unique()
        for hadm_id in hadm_ids_with_trace_index:
            hadm_class = event_log_selected_formatted[event_log_selected_formatted['hadm_id'] == hadm_id]['class'].iloc[
                0]
            cluster_data.append((hadm_id, case_id, best_cluster_index, hadm_class))

    # Save cluster data to a CSV file

    cluster_data_df = pd.DataFrame(cluster_data, columns=['hadm_id', 'trace_index', 'cluster_index', 'class'])

    #cluster_data_df.to_csv(clusters_hadmid_level_csv_path, index=False)

    # print cluster distribution into a csv file

    # Initialize an empty list to store cluster distribution information
    cluster_distribution = []

    # Get the unique clusters
    unique_clusters = cluster_data_df['cluster_index'].unique()

    # Iterate through each cluster
    for cluster in unique_clusters:
        cluster_df = cluster_data_df[cluster_data_df['cluster_index'] == cluster]

        # Calculate patient_count
        patient_count = cluster_df['hadm_id'].nunique()

        # Calculate TP_count and TN_count
        TP_count = cluster_df[cluster_df['class'] == 'TP'].shape[0]
        TN_count = cluster_df[cluster_df['class'] == 'TN'].shape[0]

        TP_percentage = TP_count / patient_count * 100
        TN_percentage = TN_count / patient_count * 100

        # Append the calculated values to the cluster_distribution list
        cluster_distribution.append([
            cluster,
            patient_count,
            TP_count,
            TN_count,
            TP_percentage,
            TN_percentage
        ])

    # Convert the cluster_distribution list to a DataFrame
    cluster_distribution_df = pd.DataFrame(cluster_distribution, columns=[
        'cluster_index',
        'patient_count',
        'TP_count',
        'TN_count',
        'TP%',
        'TN%'
    ])

    print(cluster_distribution_df)
    #cluster_distribution_df.to_csv(clusters_clusters_level_csv_path, index=False)

    # ---------------------------------------------------------------------------------

    # output - cluster_index, trace_index, sequence (may be add hadm_id list and HIT label list, later)

    print('\n\n', file=file_w)

    for i, cluster in enumerate(clusters):
        case_ids_in_cluster = cluster['trace_index'].unique()

        # for case_id in case_ids_in_cluster:

        print(
            f"Cluster {i}: "
            f"trace_index: {case_ids_in_cluster}: "

        )

        file_w.write(f"Cluster {i}: trace_index: {case_ids_in_cluster}:\n\n")

    # ---------------------------------------------------------------------------------

    print('\n\n', file=file_w)

    # Output the clusters
    print("Clusters after processing:")

    file_w.write("Clusters after processing:\n\n")

    for i, cluster in enumerate(clusters):
        case_ids_in_cluster = cluster['trace_index'].unique()

        hadm_ids_in_cluster = trace_df_sorted[trace_df_sorted['trace_index'].isin(case_ids_in_cluster)]['hadm_id_list']

        actual_HIT_labels_of_hadm_ids_in_cluster = \
            trace_df_sorted[trace_df_sorted['trace_index'].isin(case_ids_in_cluster)][
                'HIT_label_actual_list']

        predicted_HIT_labels_of_hadm_ids_in_cluster = \
            trace_df_sorted[trace_df_sorted['trace_index'].isin(case_ids_in_cluster)][
                'HIT_label_predicted_list']

        # Print cluster details
        print(
            f"Cluster {i}: "
            f"trace_index_list: {list(case_ids_in_cluster)}: "
            f"hadm_id_list: {list(hadm_ids_in_cluster)}: "
            f"HIT_label_actual_list: {list(actual_HIT_labels_of_hadm_ids_in_cluster)}\n"
            f"HIT_label_predicted_list: {list(predicted_HIT_labels_of_hadm_ids_in_cluster)}\n"

        )

        file_w.write(
            f"Cluster {i}: "
            f"trace_index_list: {list(case_ids_in_cluster)}: "
            f"hadm_id_list: {list(hadm_ids_in_cluster)}: "
            f"HIT_label_actual_list: {list(actual_HIT_labels_of_hadm_ids_in_cluster)}\n"
            f"HIT_label_predicted_list: {list(predicted_HIT_labels_of_hadm_ids_in_cluster)}\n"
        )


# ---------------------------------------------------------------------------------
if __name__ == '__main__':
    random.seed(0)
    np.random.seed(0)

    start_time = time.time()
    peak_memory = memory_usage(
        (cluster_traces,
         (sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6], file_w, sys.argv[8],
          sys.argv[9])),

        # event_log_path, train_labels_path, test_labels_path,
        # unique_trace_count_to_cluster, noise_threshold_inductive_miner, target_fitness_clustering,
        # file_w, clusterLs_hadmid_level_csv_path, clusters_clusters_level_csv_path

        # Main clustering function

        interval=0.1,
        retval=False,
        max_usage=True
    )
    end_time = time.time()

    execution_time = end_time - start_time

    with open(file_name, 'a') as file_w:
        print(f"\nTime taken to execute the code: {execution_time} seconds\n")
        print(f"Peak memory utilization: {peak_memory} MiB\n")

        file_w.write(f"\nTime taken to execute the code: {execution_time} seconds\n")
        file_w.write(f"Peak memory utilization: {peak_memory} MiB\n")

        file_w.close()

sys.stdout.flush()

# ----------------------------------------------------------------------------------------------------------------------

# python oldIDE_Trajectories28_5.py 7604

# python /Users/psenevirathn/Desktop/PhD/Coding/Trajectories/oldIDE_Trajectories29_1.py /Users/psenevirathn/Desktop/PhD/Coding/Trajectories/Input/Input_for_clustering/May8_v1.csv /Users/psenevirathn/Desktop/PhD/Coding/Python/input_csv_files/label_train_actual_and_predicted.csv /Users/psenevirathn/Desktop/PhD/Coding/Python/input_csv_files/label_test_actual_and_predicted.csv 100 0.2 0.7 /Users/psenevirathn/Desktop/PM_test/output_v2.txt /Users/psenevirathn/Desktop/PM_test/clusters_hadmid_level_v2.csv /Users/psenevirathn/Desktop/PM_test/clusters_cluster_level_v2.csv

# Inside .slurm file in Sparton
# python /data/gpfs/projects/punim1274/Prabodi/Sparton_test/v1/June21_only_TP_and_TN/EventLogV1_noise0.2_fitness0.7/oldIDE_Trajectories29_1.py /data/gpfs/projects/punim1274/Prabodi/Sparton_test/v1/June21_only_TP_and_TN/EventLogV1_noise0.2_fitness0.7/Event_log_v1_without_adm_and_dischg.csv /data/gpfs/projects/punim1274/Prabodi/Sparton_test/v1/June21_only_TP_and_TN/EventLogV1_noise0.2_fitness0.7/label_train_actual_and_predicted.csv /data/gpfs/projects/punim1274/Prabodi/Sparton_test/v1/June21_only_TP_and_TN/EventLogV1_noise0.2_fitness0.7/label_test_actual_and_predicted.csv 100 0.2 0.7 /data/gpfs/projects/punim1274/Prabodi/Sparton_test/v1/June21_only_TP_and_TN/EventLogV1_noise0.2_fitness0.7/output_LogV1_Noise0.2_Fitness0.7.txt /data/gpfs/projects/punim1274/Prabodi/Sparton_test/v1/June21_only_TP_and_TN/EventLogV1_noise0.2_fitness0.7/clusters_hadm_id_level_LogV1_Noise0.2_Fitness0.7.csv /data/gpfs/projects/punim1274/Prabodi/Sparton_test/v1/June21_only_TP_and_TN/EventLogV1_noise0.2_fitness0.7/cluster_distribution_LogV1_Noise0.2_Fitness0.7.csv

# with new ground truth

# python /Users/psenevirathn/Desktop/PhD/Coding/Trajectories/oldIDE_Trajectories29_1.py /Users/psenevirathn/Desktop/PhD/Coding/Trajectories/Input/Input_for_clustering/May8_v1.csv /Users/psenevirathn/Desktop/PhD/Coding/Python/input_csv_files/label_train_actual_and_predicted_with_updated_ground_truth.csv /Users/psenevirathn/Desktop/PhD/Coding/Python/input_csv_files/label_test_actual_and_predicted_with_updated_ground_truth.csv 100 0.2 0.7 /Users/psenevirathn/Desktop/PM_test/output_v3.txt /Users/psenevirathn/Desktop/PM_test/clusters_hadmid_level_v3.csv /Users/psenevirathn/Desktop/PM_test/clusters_cluster_level_v3.csv

