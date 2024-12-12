# Quantifying-Overdiagnosis

Digital Overdiagnosis Detection: Trajectory Clustering and Clinical Decision Support

This repository provides a framework for identifying overdiagnosed patients using trajectory clustering methods applied to clinical event logs. It leverages tools and methods previously developed in the Clinical Decision Support System repository.

Project Overview

The goal of this project is to detect overdiagnosed patients by analyzing patient-level data, specifically by using trajectory clustering techniques. The analysis is based on extracting phenotype data from the MIMIC-IV database, constructing event logs, and applying abstraction methods to simplify and interpret complex clinical data. Several key steps are involved:

1. Phenotype Extraction: Extracting phenotype information from the MIMIC-IV database to identify true positive (TP) and true negative (TN) patients.


2. Trajectory Clustering: Clustering patient event logs based on clinical features, with and without abstraction methods.


3. Overdiagnosis Identification: Using clustering results to identify overdiagnosed cases, defined as true positive (TP) cases clustered with an unusually high proportion of false negatives (TN) cases.

Files and Notebooks

1. cohort_extraction_for_trajectories.sql

This SQL script extracts phenotype data from the MIMIC-IV database for true positive (TP) and true negative (TN) patients. The extracted data is used to build the foundation for subsequent trajectory analysis.

2. 1_Event_log_without_event_abstraction.ipynb

This Jupyter notebook generates an event log for the extracted phenotypes, without using event log abstraction methods. This version provides raw, detailed data for trajectory clustering.

3. 2_Trajectory_clustering_without_abstraction.ipynb

This notebook performs trajectory clustering on the event log generated in the previous step, without applying any abstraction methods. The clustering algorithm identifies patterns and groupings based on raw event log data.

4. 3_Trajectory_clustering_with_abstraction.ipynb

This notebook applies two abstraction methods to the trajectory clustering process:

Clinical Guidelines Abstraction: Uses guidelines for grouping specific EMR events such as medications, lab tests, procedures, and diagnosis codes into relevant categories (e.g., medications like rivaroxaban or warfarin).

Aggregation: Groups events based on clinical recommendations (e.g., grouping blood product administration events like plasma exchange and platelet transfusion into a single panel).


These abstractions help reduce complexity in the data and provide clearer insights for clustering and interpretation.

5. Event_log_with_event_abstraction.csv

The event log generated after applying the abstraction methods. This log contains simplified, high-level information about patient events, making it easier to identify meaningful patterns for analysis.

6. 4_Selecting_best_parameters_for_inductive_miner.ipynb

This notebook helps in selecting the best parameters for the Inductive Miner algorithm used in the trajectory clustering. Two key parameters are adjusted: the fitness threshold and the rise threshold. The notebook helps determine the optimal parameter set for clustering.

7. 5_Identifying_overdiagnosed_cases.ipynb

This Jupyter notebook identifies overdiagnosed patients. Overdiagnosis is defined as true positive (TP) cases within clusters that have a higher proportion of true negative (TN) cases compared to the baseline TP-to-TN ratio, determined via a chi-squared test.

8. 6_Setting_TP_to_TN_baseline.ipynb

This notebook establishes the baseline TP-to-TN ratio, under the assumption that overdiagnosed patients have clinical outcomes (e.g., length of stay, mortality, thrombotic events) similar to true negative cases. It identifies the point where the clinical outcomes of patients within clusters become statistically significant as the proportion of TP cases increases.

Usage

To use the methods and tools in this repository, follow these steps:

1. Clone the repository:

git clone https://github.com/Prabodi/Quantifying-Overdiagnosis.git


2. Install dependencies: You may need to install the necessary Python libraries, such as pandas, numpy, matplotlib, scikit-learn, and pm4py, for trajectory clustering and event log manipulation.


3. Run the notebooks: Open the Jupyter notebooks in sequence to perform phenotype extraction, event log generation, trajectory clustering, and overdiagnosis detection.

Start with cohort_extraction_for_trajectories.sql to extract the necessary data.

Use 1_Event_log_without_event_abstraction.ipynb and 2_Trajectory_clustering_without_abstraction.ipynb to cluster trajectories without abstraction.

Apply 3_Trajectory_clustering_with_abstraction.ipynb to enhance the clustering with abstraction methods.

Adjust parameters in 4_Selecting_best_parameters_for_inductive_miner.ipynb.

Identify overdiagnosed cases in 5_Identifying_overdiagnosed_cases.ipynb and establish the baseline in 6_Setting_TP_to_TN_baseline.ipynb.

Acknowledgements

This project builds on the tools and methodologies developed in the Clinical Decision Support System repository, which was used for phenotype extraction and event log creation. Thanks to the MIMIC-IV database for providing the clinical data used in this project.
