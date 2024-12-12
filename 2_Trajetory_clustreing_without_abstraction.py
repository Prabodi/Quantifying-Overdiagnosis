# Input - event log from 1000 HIT positive patients and 1000 HIT negative patients.
# Output - Applying K-medoid clustering for the event log. The distance matrix was calulated using 'Needleman-Wunsch' algorithm. (one trace per one hadm_id)

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import sys
import pm4py
import editdistance  # first executed pip install editdistance - To install the library
from sklearn.cluster import KMeans  # pip install editdistance scikit-learn matplotlib pandas
from sklearn.decomposition import PCA
from collections import Counter
from sklearn.cluster import DBSCAN
from sklearn_extra.cluster import KMedoids
import hashlib
import random

# count differnce? - need to re-train the classifier with updates required (check notes)
# total admissions - 13457
# HIT positive - 2023 (15%)
# HIT negative - 11434 (85%)

# 2. Import files

events_full = pd.read_csv(sys.argv[1])
label_df = pd.read_csv(sys.argv[2])

events = events_full.copy()  # ['hadm_id', 'HIT', 'HIT_time', 'first_hep', 'event', 'details', 'event_time']

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# select only 'N' (defined below) of HIT positive patients and 1000 HIT negative patients - to check with PRoM (when tryed to visualise clusters with full dat set, out of memory erro occured.)

# Number of unique HADM_IDs to select
N = 10

print(events.shape)  # (4558418, 4)

print(label_df.shape)  # (13457, 30) - one row per one hadm_id

# -----------

eventlog_join_label = pd.merge(events, label_df[['hadm_id', 'HIT_both_c1_and_c2_5_10_days']], on='hadm_id', how='left')

seq_length = eventlog_join_label.groupby('hadm_id').agg(count=('hadm_id', lambda x: len(x)),
                                                        sequence=('event', lambda x: x)).reset_index()

# To print - hadm_id, number of events for that hadm_id, label - one row per one hadm_id

seq_length_join_label = pd.merge(seq_length[['hadm_id', 'count']], label_df[['hadm_id', 'HIT_both_c1_and_c2_5_10_days']], on='hadm_id', how='left')

# ---------------
# plot trace length - HIT positive

trace_lengths_HIT_positive = seq_length_join_label[(seq_length_join_label['HIT_both_c1_and_c2_5_10_days'] == 1)]['count'].value_counts()

print(seq_length_join_label[(seq_length_join_label['HIT_both_c1_and_c2_5_10_days'] == 1) & (seq_length_join_label['count'] == 16)])

print(trace_lengths_HIT_positive[trace_lengths_HIT_positive.index == 16])

# plt.bar(trace_lengths_HIT_positive.index, trace_lengths_HIT_positive.values)
# plt.xlabel('trace_length')
# plt.ylabel('Count')
# plt.title('trace_length distribution')
# plt.show()

# -------------------

plt.figure(figsize=(10, 5))  # Create a new figure with specified size

# plot histogram - HIT positive

plt.subplot(1, 2, 1)  # 1 row, 2 columns, first subplot

list_seq_lengths_of_each_hadm_id_when_HIT_positive = seq_length_join_label[seq_length_join_label['HIT_both_c1_and_c2_5_10_days'] == 1]['count'].tolist()

# Custom bins

# (min, max length for traces) - HIT positive (16, 7443) , HIT negative (3, 10257)

bins = list(range(0, 10300, 100))  # list(range(0, 9000, 1000)) -> [0, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000]

# print(len(list_seq_lengths_of_each_hadm_id_when_HIT_positive)) #- 2023

# Plot histogram
plt.hist(list_seq_lengths_of_each_hadm_id_when_HIT_positive, bins=bins, edgecolor='black')

# Set x ticks
plt.xticks(bins, rotation='vertical', fontsize=5)

# Set y ticks

#print(plt.hist(list_seq_lengths_of_each_hadm_id_when_HIT_positive, bins=bins)) # returns an array of two arrays, where first array contain frquency of each bin, and the second array contain bin edges values

plt.yticks(range(0, int((max(plt.hist(list_seq_lengths_of_each_hadm_id_when_HIT_positive, bins=bins)[0]) + 1)), 5), fontsize=6)

# Labeling
plt.xlabel('trace length')
plt.ylabel('patient count')
plt.title('Trace length distribution - HIT positive')

# Add labels on top of each bar
#for i in range(len(bins) - 1):
#    plt.text(bins[i], plt.hist(list_seq_lengths_of_each_hadm_id_when_HIT_positive, bins=bins)[0][i] + 10, str(int(plt.hist(list_seq_lengths_of_each_hadm_id_when_HIT_positive, bins=bins)[0][i])), fontsize=6)

# Add grid
plt.grid(True)

# Show plot
#plt.show()

# -------------------

# Stats - trace_length distribution - HIT positive

trace_length_stats_HIT_positive = pd.DataFrame(trace_lengths_HIT_positive.index).describe()
print(trace_length_stats_HIT_positive)

# ---------------

# plot trace length - HIT negative

trace_lengths_HIT_negative = seq_length_join_label[(seq_length_join_label['HIT_both_c1_and_c2_5_10_days'] == 0)]['count'].value_counts()

# plt.bar(trace_lengths_HIT_negative.index, trace_lengths_HIT_negative.values)
# plt.xlabel('trace_length')
# plt.ylabel('Count')
# plt.title('trace_length distribution')
# plt.show()

# -------------------

# plot histogram - HIT _negative

plt.subplot(1, 2, 2)  # 1 row, 2 columns, second subplot

list_seq_lengths_of_each_hadm_id_when_HIT_negative = seq_length_join_label[seq_length_join_label['HIT_both_c1_and_c2_5_10_days'] == 0]['count'].tolist()

# Custom bins

# (min, max length for traces) - HIT positive (16, 7443) , HIT negative (3, 10257)

# print(len(list_seq_lengths_of_each_hadm_id_when_HIT_positive)) #- 2023

# Plot histogram
plt.hist(list_seq_lengths_of_each_hadm_id_when_HIT_negative, bins=bins, edgecolor='black')

# Set x ticks
plt.xticks(bins, rotation='vertical', fontsize=5)

# Set y ticks

#print(plt.hist(list_seq_lengths_of_each_hadm_id_when_HIT_positive, bins=bins)) # returns an array of two arrays, where first array contain frquency of each bin, and the second array contain bin edges values

plt.yticks(range(0, int((max(plt.hist(list_seq_lengths_of_each_hadm_id_when_HIT_negative, bins=bins)[0]) + 1)), 50), fontsize=6)

# Labeling

plt.xlabel('trace length')
plt.ylabel('patient count')
plt.title('Trace length distribution - HIT negative')

# Add labels on top of each bar
#for i in range(len(bins) - 1):
#    plt.text(bins[i], plt.hist(list_seq_lengths_of_each_hadm_id_when_HIT_positive, bins=bins)[0][i] + 10, str(int(plt.hist(list_seq_lengths_of_each_hadm_id_when_HIT_positive, bins=bins)[0][i])), fontsize=6)

# Add grid
plt.grid(True)

# Show plot
#plt.show()

# Show plot - subplot

plt.tight_layout()  # Adjust layout to prevent overlapping
plt.show()

#---------------------------------------

# Stats -  trace_length distribution - HIT negative

trace_length_stats_HIT_negative = pd.DataFrame(trace_lengths_HIT_negative.index).describe()
print(trace_length_stats_HIT_negative)

# ---------------

# plot Cummalative (%) trace length - HIT negative




# ---------------



# ---------------


# ---------------

# ---------------


# HIT positive

# Get unique IDs from the DataFrame- HIT positive

unique_hadm_ids_HIT_positive = seq_length_join_label[
    (seq_length_join_label['HIT_both_c1_and_c2_5_10_days'] == 1) & (seq_length_join_label['count'] < 200)][
    'hadm_id'].unique()

print(len(unique_hadm_ids_HIT_positive))
# Randomly select N unique IDs from HIT positive data

selected_hadm_ids_HIT_positive = random.sample(list(unique_hadm_ids_HIT_positive), N)

# Filter rows corresponding to selected IDs

filtered_df_HIT_positive = eventlog_join_label[eventlog_join_label['hadm_id'].isin(selected_hadm_ids_HIT_positive)][
    ['hadm_id', 'event', 'event_time', 'HIT_both_c1_and_c2_5_10_days']]

filtered_df_HIT_positive = filtered_df_HIT_positive.rename(columns={'HIT_both_c1_and_c2_5_10_days': 'label'})

print(filtered_df_HIT_positive)

# ----------------------------------------------------------------------------

# HIT negative

# Get unique IDs from the DataFrame- HIT negative

unique_hadm_ids_HIT_negative = seq_length_join_label[
    (seq_length_join_label['HIT_both_c1_and_c2_5_10_days'] == 0) & (seq_length_join_label['count'] < 200)][
    'hadm_id'].unique()

print(len(unique_hadm_ids_HIT_negative))

# Randomly select N unique IDs from HIT positive data

selected_hadm_ids_HIT_negative = random.sample(list(unique_hadm_ids_HIT_negative), N)

# Filter rows corresponding to selected IDs
filtered_df_HIT_negative = eventlog_join_label[eventlog_join_label['hadm_id'].isin(selected_hadm_ids_HIT_negative)][
    ['hadm_id', 'event', 'event_time', 'HIT_both_c1_and_c2_5_10_days']]

filtered_df_HIT_negative = filtered_df_HIT_negative.rename(columns={'HIT_both_c1_and_c2_5_10_days': 'label'})

print(filtered_df_HIT_negative)

# ----------------------------------------------------------------------------

# Join vertically (stack on top of each other)
filtered_df = pd.concat([filtered_df_HIT_positive, filtered_df_HIT_negative], axis=0)

# read as a .csv - to feed into PRoM

file_path = '/Users/psenevirathn/Desktop/PhD/Coding/PROM/Project2-clinical_trajectories/Events_of_10_HIT_pos_and_neg_length_max_100_events_per_trace.csv'

# filtered_df.to_csv(file_path, index=False)  # index=False specifies that you don't want to include the DataFrame index in the CSV file. If you want to include the index, you can remove this parameter or set it to True

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

print(events.shape)  # (3871342, 4)

# events = events[(events['HIT_both_c1_c2_3_10_days'] == 0)]  # & (events['event_time'].notnull())]  # Take events of HIT positive patinets

events['event_time'] = pd.to_datetime(events['event_time'])

events['event'] = events[
    'event'].str.strip()  # some elements in column 'event' had leading space (ex - ' po2_bgART_abnormal'). Need to reomve it.

# update new events

dict_activity_idx = {

    'glucose_lab_abnormal': 'A',
    'icd_diagnose_kideny_infarction': 'B',
    'chloride_lab_abnormal': 'C',
    'chest_scan_icu_procedureevent': 'D',
    'icd_diagnose_skin_necrosis': 'E',
    'methemoglobin_bgART_abnormal': 'F',
    'heart_rate_vitalsign_abnormal': 'G',
    'sodium_bgART_abnormal': 'H',
    'carboxyhemoglobin_bg_abnormal': 'I',
    'ck_mb_lab_abnormal': 'J',
    'bicarbonate_lab_abnormal': 'K',
    'basophils_abs_lab_abnormal': 'L',
    'first_thrombo_hosp_icd_procedure': 'M',
    'icd_diagnose_limb_gangrene': 'N',
    'hospital_expire_flag-died': 'O',
    'glucose_bgART_abnormal': 'P',
    'high_labs_HIT_Ab_Numerical': 'Q',
    'potassium_bgART_abnormal': 'R',
    'glucose_bg_abnormal': 'S',
    'alt_lab_abnormal': 'T',
    'ggt_lab_abnormal': 'U',
    'first_heparin_dose': 'V',
    'ultrasonography_icu_procedureevent': 'W',
    'hematocrit_bgART_abnormal': 'X',
    'eosinophils_abs_lab_abnormal': 'Y',
    'atypical_lymphocytes_lab_abnormal': 'Z',
    'sbp_vitalsign_abnormal': 'AA',
    'bun_lab_abnormal': 'AB',
    'calcium_lab_abnormal': 'AC',
    'chloride_bgART_abnormal': 'AD',
    'albumin_lab_abnormal': 'AE',
    'normal_labs_HIT_Ab_Numerical': 'AF',
    'carboxyhemoglobin_bgART_abnormal': 'AG',
    'glucose_vitalsign_abnormal': 'AH',
    'nrbc_lab_abnormal': 'AI',
    'first_warfarin_dose': 'AJ',
    'resp_rate_vitalsign_abnormal': 'AK',
    'bilirubin_total_lab_abnormal': 'AL',
    'neutrophils_abs_lab_abnormal': 'AM',
    'bands_lab_abnormal': 'AN',
    'ld_ldh_lab_abnormal': 'AO',
    'icd_diagnose_other-venous_embolism_and-thrombosis': 'AP',
    'spo2_vitalsign_abnormal': 'AQ',
    'po2_bg_abnormal': 'AR',
    'chloride_bg_abnormal': 'AS',
    'wbc_lab_abnormal': 'AT',
    'hemoglobin_bgART_abnormal': 'AU',
    'icd_diagnose_pulmonary_embolism': 'AV',
    'pt_lab_abnormal': 'AW',
    'inr_lab_abnormal': 'AX',
    'thrombin_lab_abnormal': 'AY',
    'negative_labs_HIT_Ab_Interpreted': 'AZ',
    'totalco2_bgART_abnormal': 'BA',
    'icd_diagnose_other_thrombocytopenia': 'BB',
    'hematocrit_bg_abnormal': 'BC',
    'd_dimer_lab_abnormal': 'BD',
    'IV_Immune_Globulin_ICU': 'BE',
    'hematocrit_lab_abnormal': 'BF',
    'methemoglobin_bg_abnormal': 'BG',
    'mbp_vitalsign_abnormal': 'BH',
    'bicarbonate_bgART_abnormal': 'BI',
    'ptt_lab_abnormal': 'BJ',
    'lymphocytes_abs_lab_abnormal': 'BK',
    'monocytes_abs_lab_abnormal': 'BL',
    'hosp_emar_immune_globulin_intravenous': 'BM',
    'metamyelocytes_lab_abnormal': 'BN',
    'first_anitiplatelet_agent_dose': 'BO',
    'potassium_lab_abnormal': 'BP',
    'amylase_lab_abnormal': 'BQ',
    'ultrasonography_heart_veins_arteries_hosp_icd_procedure': 'BR',
    'temperature_vitalsign_abnormal': 'BS',
    'pco2_bg_abnormal': 'BT',
    'platelet_lab_abnormal': 'BU',
    'icd_diagnose_arterial_embolism_and_thrombosis': 'BV',
    'lactate_bg_abnormal': 'BW',
    'calcium_bg_abnormal': 'BX',
    'sodium_lab_abnormal': 'BY',
    'dbp_vitalsign_abnormal': 'BZ',
    'ph_bg_abnormal': 'CA',
    'sodium_bg_abnormal': 'CB',
    'total_protein_lab_abnormal': 'CC',
    'inferior_vena_cava_hosp_icd_procedure': 'CD',
    'calcium_bgART_abnormal': 'CE',
    'lactate_bgART_abnormal': 'CF',
    'positive_labs_HIT_Ab_Interpreted': 'CG',
    'icd_diagnose_spleen_infarction': 'CH',
    'temperature_bg_abnormal': 'CI',
    'fibrinogen_lab_abnormal': 'CJ',
    'icd_diagnose_myocardial_infarction': 'CK',
    'temperature_bgART_abnormal': 'CL',
    'alp_lab_abnormal': 'CM',
    'bilirubin_direct_lab_abnormal': 'CN',
    'ph_bgART_abnormal': 'CO',
    'totalco2_bg_abnormal': 'CP',
    'bicarbonate_bg_abnormal': 'CQ',
    'potassium_bg_abnormal': 'CR',
    'hemoglobin_lab_abnormal': 'CS',
    'gcs_min_abnormal': 'CT',
    'last_heparin_dose': 'CU',
    'first_other_anticoagulant_dose': 'CV',
    'ck_cpk_lab_abnormal': 'CW',
    'po2_bgART_abnormal': 'CX',
    'hemoglobin_bg_abnormal': 'CY',
    'ast_lab_abnormal': 'CZ',
    'aniongap_lab_abnormal': 'DA',
    'immature_granulocytes_lab_abnormal': 'DB',
    'hospital_expire_flag-survived': 'DC',
    'globulin_lab_abnormal': 'DD',
    'pco2_bgART_abnormal': 'DE',
    'creatinine_lab_abnormal': 'DF'
}

# Dictionaries store key-value pairs. Keys are analogous to indexes of a list. When using lists you access the elements via the index. With dictionaries you access values via the keys.
# The keys can be of any datatype (int, float, string, and even tuple). A dictionary may contain duplicate values inside it, but the keys MUST be unique (so it isn't possible to access different values via the same key).

for key in dict_activity_idx.keys():
    events['event'] = np.where(events['event'] == key, dict_activity_idx[key],
                               events['event'])

events['event'] = events['event'].astype(str)
events['hadm_id'] = events['hadm_id'].astype(str)

df_simulation_baseline = events[['hadm_id', 'event', 'event_time']]

print(len(df_simulation_baseline))
print(len(df_simulation_baseline['hadm_id'].unique()))

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 2. Convert events into sequences (one sequence per hadm_id)
# Initially we tried to use - Long to wide conversion - https://stackoverflow.com/questions/22798934/pandas-long-to-wide-reshape-by-two-variables
# But we didn't follow it.

# checking a random hadm_id in events
# print(df_simulation_baseline[df_simulation_baseline['hadm_id'] == '20003008'])

# 2.1 - we need to organize the events into ascending order accourding to 'eventtime' inside each hadm_id
# For this, we first tried to follow below COMMENTED function (using lamda), but as the format of the output table ir returned was complicated (not oandas), we omit it.

# order_hadm_id_with_time = df_simulation_baseline.groupby('hadm_id').apply(lambda x: x.sort_values('event_time'))
# print(order_hadm_id_with_time[order_hadm_id_with_time['hadm_id'] == '20003008']) # check the random patient

# 2.2 - Therefore we first organized 'hadm_id' into ascending order, and then each event in each hadm_id according to ascending order of the eventtime.

order_hadm_id_with_time = df_simulation_baseline.sort_values(['hadm_id', 'event_time'])
# print(order_hadm_id_with_time[order_hadm_id_with_time['hadm_id'] == '20003008'])  # check the random patient

# 2.3 For each hadm_id, organize events into a vector (now the events are in acsending order of the time, as we already organized in that way)

# Refer - # https://stackoverflow.com/questions/58596439/how-to-aggregate-column-of-vectors-in-pandas-after-groupby
# # https://www.shanelynn.ie/summarising-aggregation-and-grouping-data-in-python-pandas/

events_to_traces = order_hadm_id_with_time.groupby('hadm_id').agg(count=('hadm_id', lambda x: len(x)),
                                                                  sequence=('event', lambda x: x)).reset_index()

# Print trace_length distribution

trace_length = events_to_traces['count'].value_counts()

plt.bar(trace_length.index, trace_length.values)
plt.xlabel('trace_length')
plt.ylabel('Count')
plt.title('trace_length distribution')
plt.show()

# Stats -  trace_length distribution

trace_length_stats = pd.DataFrame(trace_length.index).describe()
print(trace_length_stats)

# convert Pandas
events_to_traces_df = pd.DataFrame(events_to_traces)

# Another simple way to try below command (without 'count')
# events_to_traces_1 = order_hadm_id_with_time.groupby('hadm_id', as_index=False).agg('event')

# 2.4 - Convert activities into strings, and convert traces (each trace is a one list) into a list

events_to_traces_list = [list(map(str, sublist)) if isinstance(sublist, list) else sublist.tolist() for sublist in
                         events_to_traces_df['sequence']]


print(events_to_traces_list)

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------

def encode_activities(trace):
    # Create a mapping between unique activities and hashed values
    activity_mapping = {activity: hashlib.sha256(activity.encode()).hexdigest()[:8] for activity in set(trace)}

    # Encode the trace using the mapping
    encoded_trace = [activity_mapping[activity] for activity in trace]

    return encoded_trace, activity_mapping


def edit_distance(trace1, trace2):
    # Dynamic programming approach for calculating the EDIT distance
    matrix = [[0] * (len(trace2) + 1) for _ in range(len(trace1) + 1)]

    for i in range(len(trace1) + 1):
        matrix[i][0] = i

    for j in range(len(trace2) + 1):
        matrix[0][j] = j

    for i in range(1, len(trace1) + 1):
        for j in range(1, len(trace2) + 1):
            cost = 0 if trace1[i - 1] == trace2[j - 1] else 1
            matrix[i][j] = min(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1, matrix[i - 1][j - 1] + cost)

    return matrix[len(trace1)][len(trace2)]


def distance_matrix(traces):
    # Calculate distance matrix between all pairs of traces
    num_traces = len(traces)
    matrix = [[0] * num_traces for _ in range(num_traces)]

    for i in range(num_traces):
        for j in range(i + 1, num_traces):
            encoded_trace1, _ = encode_activities(traces[i])
            encoded_trace2, _ = encode_activities(traces[j])
            distance = edit_distance(encoded_trace1, encoded_trace2)
            matrix[i][j] = matrix[j][i] = distance

    return matrix


def kmedoids_clustering(traces, num_clusters):
    # Calculate distance matrix
    matrix = distance_matrix(traces)

    # Print the distance matrix
    print("Distance Matrix:")
    for row in matrix:
        print(row)

    # Convert distance matrix to a numpy array
    distance_array = np.array(matrix)

    # Apply K-Medoids clustering
    kmedoids = KMedoids(n_clusters=num_clusters, random_state=0).fit(distance_array)

    # Assign cluster labels to each trace
    cluster_labels = kmedoids.labels_

    return cluster_labels


# --------------------------------------------------------------------------------------------------------------------------------------------------------------------

# # Example usage with more than 2 traces:
# trace1 = ['Activity with a long name', 'Another long activity name', 'Activity with a long name', 'Third activity']
# trace2 = ['Another long activity name', 'New activity', 'Third activity']
# trace3 = ['Activity with a long name', 'Another long activity name', 'New activity']
#
# traces = [trace1, trace2, trace3]

# Specify the number of clusters
num_clusters = 5

# Perform K-Medoids clustering
cluster_labels = kmedoids_clustering(events_to_traces_list, num_clusters)

# Print cluster labels
print("Cluster Labels:", cluster_labels)

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------
#
# python Trajectories_V8.py /Users/psenevirathn/Desktop/PhD/Coding/Trjectories/Input/hep_events_v15.csv /Users/psenevirathn/Desktop/PhD/Coding/Trjectories/Input/hep_events_v10.csv

# python Trajectories_V10.py /Users/psenevirathn/Desktop/PhD/Coding/Trjectories/Input/hep_events_v15.csv /Users/psenevirathn/Desktop/PhD/Research/Project_3-Disease_trajectories/cohort_creation_in SQL/Input_file_to_SQL/cohort_with_firstheptime_and_HITtime.csv

# python Trajectories_V10.py /Users/psenevirathn/Desktop/PhD/Coding/Trjectories/Input/hep_events_v15.csv /Users/psenevirathn/Desktop/PhD/Research/Project_3-Disease_trajectories/cohort_creation_in_SQL/Input_file_to_SQL/cohort_with_firstheptime_and_HITtime.csv
