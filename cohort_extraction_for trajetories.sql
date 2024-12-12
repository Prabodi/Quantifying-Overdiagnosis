{\rtf1\ansi\ansicpg1252\cocoartf2820
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 # This isn the Final script (V26) for events extraction for clustering trajetories.\
# This extraction only involved in ***guideline-based Knowledge-based Abstraction***.\
\
# April 2024 - events only using guidelines - USA / Australian / UpToDate\
\
# Included events only after first heparin dose.\
# group icd diagnosed codes and procedure codes when possible.\
# start with raw events\
# can do grouping later.\
\
\
# to do\
-- check whether all events covered from previous script\
-- check whether all diagnosis were coverd (excel sheet)\
-- check whether both icd-9 and 10 codes were defined?\
-- merge possible records\
\
--1. *** labs *** \
\
----------------------------------------------------------------------------------\
--*** 1.1 platelets-related measurements ***\
\
--*** 1.1.1 labevents (hosp) - itemid - 51265 - Platelet Count ***\
--*** 1.1.2 labevents (hosp) - itemid - 51266 - Platelet Smear ***\
--*** 1.1.3 labevents (hosp) - itemid - 51704 - Platelet_Count_chemistry ***\
--*** 1.1.4 labevents (hosp) - itemid - 52105 - Direct Antiplatelet Antibodies ***\
--*** 1.1.5 labevents (hosp) - itemid - 51264 - Platelet Clumps ***\
\
\
--*** 1.1.8 chartevents (ICU) - itemid - 220507 - Activated Clotting Time ***\
\
----------------------------------------------------------------------------------\
\
--*** 1.2 HIT may cause activation of monocytes, neutrophils, and endothelial cells ***\
\
--*** 1.2.1 labevents (hosp) - monocytes - (itemid, label) = (52074 , Absolute Monocyte Count) , (51253 , Monocyte Count) , (51254 , Monocytes) ***\
--*** 1.2.2 labevents (hosp) - monocytes - (itemid, label) = (51537 , Absolute Neutrophil) , (51697 , Neutrophils) , (52075, Absolute Neutrophil Count) , (51256, Neutrophil) ***\
--*** 1.2.3 labevents (hosp) - endothelial cells - No relevant itemid s found.\
--*** 1.2.4 chartevents (icu) - monocytes / Neutrophils / endothelial cells (No relevant itemid s found) - (itemid, label) = (229359,Absolute Count - Monos) , (225642,Differential-Monos), (229355,Absolute Neutrophil Count) ***\
\
----------------------------------------------------------------------------------\
\
--*** 1.3 HIT may cause tests - thrombin / partial thromboplastin time / prothrombin time ***\
\
--*** 1.3.1 labevents (hosp) - thrombin / partial thromboplastin time / prothrombin time  - (itemid, label) which only had records in mimic = (51140 , Antithrombin) , (51297 , Thrombin) ***\
\
-- below itemid s didn't have records in mimic.chartevents, however they too were considered - (52078  , Antithrombin III) , (52948 , Thrombin) , (52187 , Thrombin Time) , (52188 , Thrombin Time Control) , (52189 , Thrombin Time Control) , (52190 , Tissue Thromboplastin Inhibitor)\
\
--*** 1.3.2 chartevents (icu) - thrombin / partial thromboplastin time / prothrombin time  - (itemid, label) = (227465 , Prothrombin time) , (227469 - Thrombin) , (229374 , AT (Antithrombin funct)) , (229372 - AT ( Antithrombin funct))\
\
----------------------------------------------------------------------------------\
\
--*** 1.4 HIT antibody tests ***\
\
--*** 1.4.1 labevents (hosp) - HIT antibody tests  - (itemid, label) = (52132 , HIT-Ab Numerical Result) \
--*** 1.4.2 labevents (hosp) - HIT antibody tests  - (itemid, label) = (52131 , HIT-Ab Interpreted Result)\
\
----------------------------------------------------------------------------------\
\
--*** 1.5  Immunoglobulin G antibodies / IgG antibodies ***\
\
--*** 1.5.1 labevents (hosp) - (itemid, label) = (50950 , Immunoglobulin G)\
\
----------------------------------------------------------------------------------\
\
--2. *** Medication / Inputevents *** \
\
----------------------------------------------------------------------------------\
\
--*** 2.1 non-heparin anticoagulants ***\
\
--*** 2.1.1 emar (hosp) - First instance of direct oral anticoagulants - rivaroxaban. apixaban, dabigatran, edoxaban\
\
--*** 2.1.2 emar (hosp) - parenteral anticoagulants (intravenous) - argatroban, bivalirudin, danaparoid, fondaparinux, lepirudin\
\
--*** 2.1.3 inputevents (icu) - parenteral anticoagulants (intravenous) - argatroban, bivalirudin, danaparoid, fondaparinux, lepirudin\
\
----------------------------------------------------------------------------------\
\
--2.2. *** dextran 70 *** \
\
--*** 2.2.1 emar (hosp) - (mediactions) = dextran 70-hypromellose (PF) , dextran 70-hypromellose\
\
--*** 2.2.2 inputevents (icu) -(itemid,label) = (225796 , Dextran 70) , (221002 , Dextran 70 / Dextrose 5% (Gentran - Macrodex - RescueFlow)) , (221003 , Dextran 70 / Saline 0,9% (Gentran - Macrodex - RescueFlow))\
\
----------------------------------------------------------------------------------\
\
--2.3. *** Warfarin *** \
\
--*** 2.3.1 emar (hosp) - Warfarin\
--*** 2.3.2 inputevents (icu) -(itemid,label) = (225913 , Coumadin (Warfarin)\
\
----------------------------------------------------------------------------------\
\
--2.4. *** Vitamin K *** \
\
-- In the context of the statement "warfarin should be reversed with vitamin K," the term "reverse" refers to the action of counteracting or neutralizing the anticoagulant effects of warfarin.\
-- Warfarin is an anticoagulant medication that works by inhibiting the synthesis of vitamin K-dependent clotting factors in the liver, thereby preventing blood clot formation. However, in certain situations such as bleeding complications or the need for urgent surgery, it may be necessary to rapidly restore the body's ability to form blood clots.\
-- By administering vitamin K, which is essential for the synthesis of clotting factors, the anticoagulant effects of warfarin can be reversed. Vitamin K helps replenish the depleted levels of clotting factors, allowing the blood to clot effectively again.\
-- So, in this context, "reverse" means to counteract or neutralize the anticoagulant effects of warfarin by restoring the synthesis of clotting factors through the administration of vitamin K.\
\
--*** 2.4.1 emar (hosp) - (medication) = Phytonadione (Vitamin K1) (for L&D to NBN order set use only) , Phytonadione (Vitamin K1)\
\
--*** 2.4.2 inputevents (icu) -(itemid,label) = (227535 , Vitamin K (Phytonadione))\
\
----------------------------------------------------------------------------------\
\
--2.5. *** antiplatelet agents - For patients with HIT who require cardiovascular surgery - iloprost , prostacyclin analog , tirofiban , aspirin , dipyridamole *** \
\
-- antiplatelet agents - work by inhibiting platelet function and aggregation, thereby preventing the formation of blood clots. \
\
--*** 2.5.1 emar (hosp) - (medications) = Tirofiban , aspirin (multiple medications) , dipyridamole (multiple medications)\
\
--*** 2.5.2 inputevents (icu) - (itemid, label) = (225157 , Tirofiban (Aggrastat))\
\
----------------------------------------------------------------------------------\
\
--2.6. *** regional citrate *** \
\
-- why Citrate? In patients with subacute HIT A, sub- acute HIT B, or remote HIT who are receiving renal replacement therapy, are not otherwise receiving anticoagulation, and require anticoagulation to prevent thrombosis of the dialysis circuit, the ASH guideline panel suggests regional citrate rather than heparin or other non-heparin anticoagulants Citrate is not appropriate for patients with acute HIT, who require systemic rather than regional anticoagulation\
\
--*** 2.6.1 emar (hosp) - (medications) = citrate (multiple medications)\
\
--*** 2.6.2 inputevents (icu) - (itemid, label) = (228004 , Citrate (ACD-A)) , (227526 , Citrate) , (227528 , ACD-A Citrate (500ml)) , (227529 , ACD-A Citrate (1000ml)) , (225164 , Trisodium Citrate 0.4%) \
\
----------------------------------------------------------------------------------\
\
--2.7. *** antiplatelet agent - ticagrelor - making it appear that the test is negative when in fact HIT is present. One exception to the use of a functional assay is a patient receiving the anti-platelet drug ticagrelor. *** \
\
--*** 2.7.1 emar (hosp) - (medications) = ticagrelor (multiple medications)\
\
--*** 2.7.2 hosp (icd_procedures) - platelet inhibitors ( "platelet inhibitors" and "antiplatelet agents" generally refer to the same class of medications. )\
\
----------------------------------------------------------------------------------\
\
--*** 2.8  Intravenous Immunoglobulin G / IVIG ***\
\
--*** 2.8.1 emar (hosp) - (medications) = (Immune Globulin Intravenous (Human))\
\
--*** 2.8.2 inputevents (icu) - (itemid, label) = (227530 , IV Immune Globulin (IVIG))\
\
----------------------------------------------------------------------------------\
\
--*** 2.9  heparin dose\
\
--*** 2.9.1 Last heparin dose\
\
--*** 2.9.2 Last heparin dose\
\
----------------------------------------------------------------------------------\
\
--*** 2.10  protamine \
\
--*** 2.10.1 emar (hosp) - (medications) = Protamine Sulfate\
--*** 2.10.2 inputevents (icu) - Protamine Sulfate - (itemid, label) = (229068 , Protamine sulfate) \
\
----------------------------------------------------------------------------------\
\
--3. *** Procedures *** \
\
----------------------------------------------------------------------------------\
\
--*** 3.1.platelet tranfusion\
\
--*** 3.1.1 .platelet tranfusion - mimic hosp - has few icd_codes\
-- no records returned for our Hep cohort\
\
--*** 3.1.2 .platelet tranfusion - inputevents (icu) - (itemid, label) = (225170 , Platelets) , (226369 , OR Platelet Intake) , (227071 , PACU Platelet Intake)\
\
----------------------------------------------------------------------------------\
\
--*** 3.2.Amputation\
\
--*** 3.2.1 mimic hosp - has few icd_codes\
-- no records returned - there were few records for the hep cohort where they had amputations, but the procedure_date was before first_hep_admin.\
\
--*** 3.2.2 mimic icu procedureevents - not relevant itemid s.\
\
----------------------------------------------------------------------------------\
\
--*** 3.3.ultrasonography\
\
--*** 3.3.1 hosp (icd_procedures) - ultrasonography of heart / veins / arteries (for icd codes -> https://www.icd10data.com/)\
\
--*** 3.3.2 ultrasound - icu.procedureevents \
\
----------------------------------------------------------------------------------\
\
--*** 3.4.Plasma exchange / Plasma transfusion\
\
--*** 3.4.1 hosp (icd_procedures) - Transfusion of plasma into veins / arteries / circulatory system \
\
--*** 3.4.2 hosp (icd_procedures) - Pheresis of Plasma / Plasma exchange (for icd codes -> https://www.icd10data.com/)\
\
--*** 3.4.3 inputevents (icu) - Pheresis of Plasma - (itemid , label) = (220970,Fresh Frozen Plasma) , (227532,Plasma Pheresis)\
\
--*** 3.4.4 procedureevents (icu) - Pheresis of Plasma - (itemid , label) = (227551 , Plasma Pheresis.) \
\
----------------------------------------------------------------------------------\
\
--*** 3.5.CT scan / Angiography\
\
--*** 3.5.1 hosp (icd_procedures) - CT scan - several icd codes used.\
-- no icd codes found for pulmonary angiography.\
\
--*** 3.5.2 procedureevents (icu) -CT scan - (itemid , label) = (221214 , CT scan) , (229582 , Portable CT scan)\
\
--*** 3.5.3 procedureevents (icu) -Angiography - (itemid , label) = (225427 , Angiography) \
\
----------------------------------------------------------------------------------\
\
--*** 3.6.X-ray / MRI\
\
--*** 3.6.1 hosp (icd_procedures) - X-ray - several icd codes used.\
\
--*** 3.6.2 hosp (icd_procedures) - MRI - several icd codes used.\
\
--*** 3.6.3 procedureevents (icu) -x-ray - (itemid , label) = (221216 , X-ray) , (225457,Abdominal X-Ray) , (225459,Chest X-Ray) , (229581,Portable Chest X-Ray)\
\
--*** 3.6.4 procedureevents (icu) -MRI - (itemid , label) = (223253 , Magnetic Resonance Imaging\
\
----------------------------------------------------------------------------------\
\
--*** 3.7 Skin biopsy\
\
--*** 3.7.1 hosp (icd_procedures) - X-ray - (icd_code, icd_version, long_title) = (8611, 9 , Closed biopsy of skin and subcutaneous tissue)\
-- couldn't find relevant ICD-10 codes.\
-- couldn't find relevant ITEMID s in icd.ditems.\
\
----------------------------------------------------------------------------------\
\
--*** 3.8 'Thrombo' related procedures\
\
--*** 3.8.1 hosp (icd_procedures) - (icd_code, icd_version, long_title) = (8611, 9 , Closed biopsy of skin and subcutaneous tissue)\
\
--*** 3.8.2 hosp (icd_procedures) - Infuse_Prothrombin_complex - (icd_code, icd_version, long_title) = (30280B1, 10 ,Transfusion of Nonautologous 4-Factor Prothrombin Complex Concentrate into Vein, Open Approach) , (30283B1, 10 ,Transfusion of Nonautologous 4-Factor Prothrombin Complex Concentrate into Vein, Percutaneous Approach) , (0096, 9 ,Infusion of 4-Factor Prothrombin Complex Concentrate)\
\
--*** 3.8.3 hosp (icd_procedures) - Infusion thrombolytic agent - (icd_code, icd_version, long_title) = (3604, 9 ,Intracoronary artery thrombolytic infusion) , (9910, 9 ,Injection or infusion of thrombolytic agent)\
\
--*** 3.8.4 no relevant procedures were found in 'icu.procedureevents'.\
\
----------------------------------------------------------------------------------\
\
--4. *** Diagnoses (ICD diagnose codes) *** \
\
--*** 4.1 mimic_hosp.d_icd_diagnoses - skin necrosis  ***\
--*** 4.2 mimic_hosp.d_icd_diagnoses - limb_gangrene  ***\
--*** 4.3 mimic_hosp.d_icd_diagnoses - bleeding  ***\
--*** 4.4 mimic_hosp.d_icd_diagnoses - anaphylaxis  ***\
--*** 4.5 mimic_hosp.d_icd_diagnoses - myocardial infarction  ***\
--*** 4.6 mimic_hosp.d_icd_diagnoses - kideny infarction  ***\
--*** 4.7 mimic_hosp.d_icd_diagnoses - spleen infarction  ***\
--*** 4.8 mimic_hosp.d_icd_diagnoses - thrombotic events - Arterial embolism and thrombosis  ***\
--*** 4.9 mimic_hosp.d_icd_diagnoses - thrombotic events - Other venous embolism and thrombosis  ***\
--*** 4.10 mimic_hosp.d_icd_diagnoses - Pulmonary embolism  ***\
\
----------------------------------------------------------------------------------\
\
--5. *** --5. *** Dermagraphics\
\
-- 5.1 Admission *** \
-- 5.1 Discharge *** \
-- 5.1 Died *** \
\
----------------------------------------------------------------------------------\
\
with all_union as \
(\
--1. *** labs *** \
\
--*** 1.1 platelets-related measurements ***\
\
--*** 1.1.1 labevents (hosp) - itemid - 51265 - Platelet Count ***\
\
select * from \
(\
        select cohort.hadm_id, \
        'Platelet_count_hosp' as event, \
\
        case\
        when (safe_cast(value as NUMERIC) < ref_range_lower) \
        then 'low'\
\
        when (safe_cast(value as NUMERIC) > ref_range_upper) \
        then 'high'\
\
        when (safe_cast(value as NUMERIC) >= ref_range_lower and safe_cast(value as NUMERIC) <= ref_range_upper) \
        then 'normal'\
\
        --when (value is null and flag is not null) \
        --then flag\
\
        when (ref_range_lower is null or ref_range_upper is null) \
        then 'no_ref_range'\
\
        else\
        'na'\
\
        end as value,\
\
        value as details,\
\
        charttime as event_time from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.labevents` labs\
        on cohort.subject_id = labs.subject_id\
         \
        where itemid = 51265\
        and value is not null -- there were few records where 'values' is null, but flag was 'abnormal'. We ignore them too.\
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
)\
\
\
union all\
\
--*** 1.1.2 labevents (hosp) - itemid - 51266 - Platelet Smear ***\
\
select * from \
(\
        select cohort.hadm_id, \
        'Platelet_Smear_hosp' as event,\
\
        case\
\
        when (lower(comments) like 'high%' or lower(comments) like 'very high%')\
        then 'high'\
\
        when (lower(comments) like 'low%' or lower(comments) like 'very low%'or lower(comments) like 'rare%' or comments = 'P0.')          \
        then 'low'\
\
        when (lower(comments) like 'normal%' or comments = 'P6.')\
        then 'normal'\
\
        when (lower(comments) like 'unable to estimate due to platelet clumps%' or lower(comments) like 'unable to report due to plt clumps.%')\
        then 'cannot_estimate_due_to_platelet_clumps'\
\
        when (comments = '___' and flag is not null)\
        then flag\
\
        else -- 2 possibilities. either : (comments = '___' and flag is null) or (comments is null)\
        'na'\
\
        end as value,\
\
        comments as details,\
        \
        charttime as event_time from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.labevents` labs\
        on cohort.subject_id = labs.subject_id\
\
        where itemid = 51266\
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
)\
\
union all\
\
--*** 1.1.3 labevents (hosp) - itemid - 51704 - Platelet_Count_chemistry ***\
\
select * from \
(\
        select cohort.hadm_id, \
        'Platelet_Count_hosp_chemistry' as event, \
        value as value, -- either 'abnormal' or null\
        comments as details,\
        charttime as event_time from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.labevents` labs\
        on cohort.subject_id = labs.subject_id\
\
        where itemid = 51704\
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
)\
\
union all\
\
--*** 1.1.4 labevents (hosp) - itemid - 52105 - Direct Antiplatelet Antibodies ***\
\
select * from \
(\
        select cohort.hadm_id, \
        'Direct_Antiplatelet_Antibodies' as event, \
        value as value, -- either 'abnormal' or null\
        comments as details,\
        charttime as event_time from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.labevents` labs\
        on cohort.subject_id = labs.subject_id\
\
        where itemid = 52105\
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
)\
\
union all\
\
--*** 1.1.5 labevents (hosp) - itemid - 51264 - Platelet Clumps ***\
\
select * from \
(\
        select cohort.hadm_id, \
        'Platelet_Clumps' as event, \
        value as value, -- either 'abnormal' or null\
        comments as details,\
        charttime as event_time from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.labevents` labs\
        on cohort.subject_id = labs.subject_id\
\
        where itemid = 51264\
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
)\
\
/*\
union all\
\
--*** 1.1.8 chartevents (ICU) - itemid - 220507 - Activated Clotting Time *** - Removed this, as the value varies depens on anticoagulation theraphy (https://emedicine.medscape.com/article/2084818-overview?form=fpf)\
\
select * from \
(\
        select cohort.hadm_id, \
        'Activated_Clotting_Time' as event, \
        \
        '' as value, -- because contacatanating this with 'event' is meaningless\
        value as details, -- numerical_value\
\
        --value as value, -- numerical_value\
        --cast(warning as string) as details,\
\
        charttime as event_time from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_icu.chartevents` icuevents\
        on cohort.subject_id = icuevents.subject_id\
\
        where itemid = 220507\
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
)\
*/\
\
union all\
--*** 1.2 HIT may cause activation of monocytes, neutrophils, and endothelial cells ***\
\
--*** 1.2.1 labevents (hosp) - monocytes - (itemid, label) = (52074 , Absolute Monocyte Count) , (51253 , Monocyte Count) , (51254 , Monocytes) ***\
\
select * from \
(\
        select cohort.hadm_id, \
        'Monocytes_hosp' as event, \
\
        case\
\
        when (safe_cast(value as NUMERIC) < ref_range_lower) -- when flag is null\
        then 'low'\
\
        when (safe_cast(value as NUMERIC) > ref_range_upper) \
        then 'high'\
\
        when (safe_cast(value as NUMERIC) >= ref_range_lower and safe_cast(value as NUMERIC) <= ref_range_upper) \
        then 'normal'\
\
        --when (value is null and flag is not null) \
        --then flag\
\
        when (ref_range_lower is null or ref_range_upper is null) \
        then 'no_ref_range'\
\
        else\
        'na'\
\
        end as value,\
\
        value as details,\
\
        charttime as event_time from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.labevents` labs\
        on cohort.subject_id = labs.subject_id\
         \
        where itemid in (52074) --52074, 51253, 51254 - only one measurement (more practical) was considered, otherwise multiple rows will be generated for same 'event_time'.\
        and value is not null -- there were few records where 'values' is null, but flag was 'abnormal'. We ignore them too.\
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
)\
\
union all\
\
--*** 1.2.2 labevents (hosp) - Neutrophils - (itemid, label) = (51537 , Absolute Neutrophil) , (51697 , Neutrophils) , (52075, Absolute Neutrophil Count) , (51256, Neutrophil) ***\
\
select * from \
(\
        select cohort.hadm_id, \
        'Neutrophil_hosp' as event, \
\
        case\
\
        when (safe_cast(value as NUMERIC) < ref_range_lower) -- when flag is null\
        then 'low'\
\
        when (safe_cast(value as NUMERIC) > ref_range_upper) \
        then 'high'\
\
        when (safe_cast(value as NUMERIC) >= ref_range_lower and safe_cast(value as NUMERIC) <= ref_range_upper) \
        then 'normal'\
\
        --when (value is null and flag is not null) \
        --then flag\
\
        when (ref_range_lower is null or ref_range_upper is null) \
        then 'no_ref_range'\
\
        else\
        'na'\
\
        end as value ,\
\
        value as details,\
\
        charttime as event_time from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.labevents` labs\
        on cohort.subject_id = labs.subject_id\
         \
        where itemid in (52075)  -- 51537, 51697, 52075, 51256\
        and value is not null -- there were few records where 'values' is null, but flag was 'abnormal'. We ignore them too.\
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
)\
\
union all\
\
--*** 1.2.3 labevents (hosp) - endothelial cells - No relevant itemid s found.\
\
--*** 1.2.4 chartevents (icu) - monocytes (229359,Absolute Count - Monos) , (225642,Differential-Monos) ***\
\
--*** 1.2.5 chartevents (icu) - Neutrophils (229355,Absolute Neutrophil Count) ***\
\
--*** 1.2.6 chartevents (icu) -  endothelial cells (No relevant itemid s found) \
\
\
--*** 1.3 HIT may cause tests - thrombin / partial thromboplastin time / prothrombin time ***\
\
--*** 1.3.1 labevents (hosp) - thrombin / partial thromboplastin time / prothrombin time  - (itemid, label) which only had records in mimic = (51140 , Antithrombin) , (51297 , Thrombin) ***\
\
-- below itemid s didn't have records in mimic.chartevents, however they too were considered - (52078  , Antithrombin III) , (52948 , Thrombin) , (52187 , Thrombin Time) , (52188 , Thrombin Time Control) , (52189 , Thrombin Time Control) , (52190 , Tissue Thromboplastin Inhibitor)\
\
-- why 'Antithrombin' ? Antithrombin is a naturally occurring protein in the blood that acts as an anticoagulant. Its primary function is to inhibit the activity of several clotting factors, including thrombin and factor Xa. By inhibiting these factors, antithrombin helps regulate and prevent excessive blood clot formation (thrombosis). Testing antithrombin levels can provide insight into the body's ability to regulate clotting and assess the risk of thrombotic events (excessive clot formation) or bleeding disorders.\
\
-- why 'Thrombin' ? Thrombin is a key enzyme in the blood coagulation process. It is responsible for converting soluble fibrinogen into insoluble fibrin, which forms the structural framework of a blood clot. Thrombin also activates other clotting factors, amplifying the clotting process. Testing thrombin levels or activity may be done in certain clinical settings to assess coagulation status or diagnose clotting disorders.\
\
select * from \
(\
        select cohort.hadm_id, \
        concat(label,'_hosp') as event, \
\
        case\
\
        when (safe_cast(value as NUMERIC) < ref_range_lower) -- when flag is null\
        then 'low'\
\
        when (safe_cast(value as NUMERIC) > ref_range_upper) \
        then 'high'\
\
        when (safe_cast(value as NUMERIC) >= ref_range_lower and safe_cast(value as NUMERIC) <= ref_range_upper) \
        then 'normal'\
\
        --when (value is null and flag is not null) \
        --then flag\
\
        when (ref_range_lower is null or ref_range_upper is null) \
        then 'no_ref_range'\
\
        else\
        'na'\
\
        end as value,\
\
        value as details,\
\
        charttime as event_time from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.labevents` labs\
        on cohort.subject_id = labs.subject_id\
\
        left join `physionet-data.mimic_hosp.d_labitems` ditems\
        on labs.itemid = ditems.itemid\
         \
        where labs.itemid in (51140 , 52078 , 51297 , 52948 , 52187 , 52188 , 52189 , 52190, 51274)\
        and value is not null -- there were few records where 'values' is null, but flag was 'abnormal'. We ignore them too.\
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
)\
\
union all\
\
--*** 1.3.2 chartevents (icu) - thrombin / partial thromboplastin time / prothrombin time  - (itemid, label) = (227465 , Prothrombin time) , (227469 - Thrombin) , (229374 , AT (Antithrombin funct)) , (229372 - AT ( Antithrombin funct))\
\
\
--*** 1.4 HIT antibody tests ***\
\
-- merge 4.1 and 4.2 later - -- if test is positive - can consider numerical value only. \
-- but if test is negative, should check both numerical and interpret values, coz some nehative patients have num values, while some may only have interpret value\
\
--*** 1.4.1 labevents (hosp) - HIT antibody tests  - (itemid, label) = (52132 , HIT-Ab Numerical Result) \
select distinct * from\
(\
select * from \
(\
        select cohort.hadm_id, \
        'HIT_Ab_test' as event, \
\
        case\
\
        when (safe_cast(value as NUMERIC) >= ref_range_lower and safe_cast(value as NUMERIC) <= ref_range_upper) \
        then 'negative_HIT-Ab_test'\
\
        when (safe_cast(value as NUMERIC) > ref_range_upper) \
        then 'positive_HIT-Ab_test'\
\
        --when (value is null and flag is not null) \
        --then flag\
\
        else\
        'na'\
\
        end as value,\
\
        '' as details,\
\
        charttime as event_time from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.labevents` labs\
        on cohort.subject_id = labs.subject_id\
         \
        where itemid in (52132)\
        and value is not null -- there were few records where 'values' is null, but flag was 'abnormal'. We ignore them too.\
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
)\
\
union all\
\
--*** 1.4.2 labevents (hosp) - HIT antibody tests  - (itemid, label) = (52131 , HIT-Ab Interpreted Result)\
\
select * from \
(\
        select cohort.hadm_id, \
        'HIT_Ab_test' as event, \
\
        case\
\
        when (lower(value) like '%neg%') \
        then 'negative_HIT-Ab_test'\
\
        when (lower(value) like '%pos%') \
        then 'positive_HIT-Ab_test'\
\
        --when (value is null and flag is not null) \
        --then flag\
\
        else\
        'na'\
\
        end as value,\
        \
        '' as details,\
\
        charttime as event_time from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.labevents` labs\
        on cohort.subject_id = labs.subject_id\
         \
        where itemid in (52131)\
        and value is not null -- there were few records where 'values' is null, but flag was 'abnormal'. We ignore them too.\
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
)\
)\
\
union all\
\
--*** 1.5  Immunoglobulin G antibodies / IgG antibodies ***\
\
--*** 1.5.1 labevents (hosp) - (itemid, label) = (50950 , Immunoglobulin G)\
\
select * from \
(\
        select cohort.hadm_id, \
        'ImmunoglobulinG_antibodies' as event, \
\
        case\
\
        when (safe_cast(value as NUMERIC) < ref_range_lower) \
        then 'low'\
\
        when (safe_cast(value as NUMERIC) > ref_range_upper) \
        then 'high'\
\
        when (safe_cast(value as NUMERIC) >= ref_range_lower and safe_cast(value as NUMERIC) <= ref_range_upper) \
        then 'normal'\
\
        when (ref_range_lower is null or ref_range_upper is null) \
        then 'no_ref_range'\
\
        else\
        'na'\
\
        end as value,\
\
        value as details,\
\
        charttime as event_time from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.labevents` labs\
        on cohort.subject_id = labs.subject_id\
         \
        where itemid in (50950)\
        and value is not null -- there were few records where 'values' is null, but flag was 'abnormal'. We ignore them too.\
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
)\
\
union all\
\
--*** 1.6 labevents - mimic_hosp - 51196  # d-dimer ***--\
-- https://ashpublications.org/blood/article/142/Supplement%201/5522/505702/Use-of-Fibrinogen-and-D-Dimer-to-Predict-Platelet\
\
select * from \
(\
        select cohort.hadm_id, \
        'd_dimer_hosp' as event, \
\
        case\
\
        when (safe_cast(value as NUMERIC) < ref_range_lower) \
        then 'low'\
\
        when (safe_cast(value as NUMERIC) > ref_range_upper) \
        then 'high'\
\
        when (safe_cast(value as NUMERIC) >= ref_range_lower and safe_cast(value as NUMERIC) <= ref_range_upper) \
        then 'normal'\
\
        when (ref_range_lower is null or ref_range_upper is null) \
        then 'no_ref_range'\
\
        else\
        'na'\
\
        end as value,\
\
        value as details,\
\
        charttime as event_time from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.labevents` labs\
        on cohort.subject_id = labs.subject_id\
         \
        where itemid in (51196)\
        and value is not null -- there were few records where 'values' is null, but flag was 'abnormal'. We ignore them too.\
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
)\
\
union all\
\
--*** 1.7 labevents - mimic_hosp - 51214  # Fibrinogen ***--\
-- https://ashpublications.org/blood/article/142/Supplement%201/5522/505702/Use-of-Fibrinogen-and-D-Dimer-to-Predict-Platelet\
\
select * from \
(\
        select cohort.hadm_id, \
        'fibrinogen_hosp' as event, \
\
        case\
\
        when ((safe_cast(value as NUMERIC) < ref_range_lower) or (value = '<35')) \
        then 'low'\
\
        when (safe_cast(value as NUMERIC) > ref_range_upper) \
        then 'high'\
\
        when (safe_cast(value as NUMERIC) >= ref_range_lower and safe_cast(value as NUMERIC) <= ref_range_upper) \
        then 'normal'\
\
        when (ref_range_lower is null or ref_range_upper is null) \
        then 'no_ref_range'\
\
        else\
        'na'\
\
        end as value,\
\
        value as details,\
\
        charttime as event_time from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.labevents` labs\
        on cohort.subject_id = labs.subject_id\
         \
        where itemid in (51214)\
        and value is not null -- there were few records where 'values' is null, but flag was 'abnormal'. We ignore them too.\
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
)\
\
#---------------------------------------------------------------\
\
--2. *** Medication / Inputevents *** \
\
--*** 2.1 non-heparin anticoagulants ***\
\
union all\
\
select * from\
(\
\
with merge_icu_and_hosp as \
\
(\
SELECT \
icu_and_hosp.* , \
row_number() over(partition by hadm_id order by event_time) as rn # last hep_admin appraes first  \
from\
(  \
\
--*** 2.1.1 emar (hosp) - First instance of direct oral anticoagulants - rivaroxaban. apixaban, dabigatran, edoxaban AND --*** 2.1.2 emar (hosp) - parenteral anticoagulants (intravenous) - argatroban, bivalirudin, danaparoid, fondaparinux, lepirudin\
\
select * from \
(     \
        with doac as\
        (\
        select cohort.hadm_id,\
        emar.medication, \
        emar.charttime,\
        event_txt,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by emar.charttime) as rn # earliest event appraes first    \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids \
        inner join `physionet-data.mimic_hosp.emar`emar \
        on cohort.subject_id = emar.subject_id\
\
        where \
\
        (\
                REGEXP_CONTAINS(LOWER(emar.medication), '(rivaroxaban|dabigatran|apixaban|edoxaban)') -- direct oral anticoagulants\
\
                or\
\
                REGEXP_CONTAINS(LOWER(emar.medication), '(argatroban|bivalirudin|danaparoid|fondaparinux|lepirudin)') -- parenteral anticoagulants (intravenous)\
        \
        )\
\
        and\
        \
        (\
                trim(event_txt) not in ('Hold Dose', 'Not Confirmed', 'Removed', 'Not Started', 'Not Applied', 'Delayed', 'Not Assessed','Documented in O.R. Holding', 'Flushed in Other Location', 'Delayed Flushed', 'Delayed Not Confirmed', 'Flushed','Not Given', 'Delayed Not Started', 'Stopped - Unscheduled', 'Stopped in Other Location','Stopped - Unscheduled in Other Location', 'Stopped As Directed', 'Delayed Stopped', 'Stopped', 'Delayed Stopped As Directed', 'Infusion Reconciliation', 'Infusion Reconciliation Not Done')\
\
                or event_txt is null\
        )\
\
        \
        --and emar.event_txt IN ("Administered" , "Confirmed", "Started", "Restarted", "Administered in Other Location", " in other Location")\
        \
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
        )\
\
\
        select hadm_id, \
        'first_non_heparin_anticoagulant_dose_emar' as event,\
        medication as value,\
\
        event_txt as details,\
\
        charttime as event_time\
\
        from doac\
        where rn = 1 \
\
)\
\
--*** 2.1.2 emar (hosp) - parenteral anticoagulants (intravenous) - argatroban, bivalirudin, danaparoid, fondaparinux, lepirudin\
\
union all\
\
--*** 2.1.3 inputevents (icu) - parenteral anticoagulants (intravenous) - argatroban, bivalirudin, danaparoid, fondaparinux, lepirudin\
\
select * from \
(     \
        with parental_anticoagulant_icu as\
        (\
        select cohort.hadm_id,\
        starttime,\
        ditems.label, \
        inputevents.originalamount,\
        statusdescription,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by inputevents.starttime) as rn # earliest event appraes first    \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids \
        inner join `physionet-data.mimic_icu.inputevents` inputevents\
        on cohort.hadm_id = inputevents.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'inputevents' table.\
\
        left join `physionet-data.mimic_icu.d_items` ditems\
        on inputevents.itemid = ditems.itemid\
\
        where \
        REGEXP_CONTAINS(LOWER(ditems.label), '(argatroban|bivalirudin|danaparoid|fondaparinux|lepirudin)')\
\
        --and emar.event_txt IN ("Administered" , "Confirmed", "Started", "Restarted", "Administered in Other Location", " in other Location")\
        \
        and inputevents.starttime > DATETIME(hep_start) \
        )\
\
        select hadm_id, \
        'first_parenteral_anticoagulant_dose_inputevents' as event,\
        label as value,\
\
        statusdescription as details, -- had 4 distinct statusdescription s. - FinishedRunning , Paused, ChangeDose/Rate , Stopped\
        --cast(originalamount as string) as details,\
\
        starttime as event_time\
\
        from parental_anticoagulant_icu\
        where rn = 1 \
\
)\
\
) icu_and_hosp\
\
)\
\
        select hadm_id, \
        'first_non_heparin_anticoagulant_dose' as event,\
        value,\
\
        details,\
\
        event_time\
\
        from merge_icu_and_hosp\
        where rn = 1 \
\
)\
\
\
union all\
\
--2.2. *** dextran 70 *** \
\
--*** 2.2.1 emar (hosp) - (mediactions) = dextran 70-hypromellose (PF) , dextran 70-hypromellose\
\
select * from \
(     \
        with dextran_70_emar as\
        (\
        select cohort.hadm_id,\
        emar.medication, \
        emar.charttime,\
        event_txt,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by emar.charttime) as rn # earliest event appraes first    \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids \
        inner join `physionet-data.mimic_hosp.emar`emar \
        on cohort.subject_id = emar.subject_id\
\
        where \
        REGEXP_CONTAINS(LOWER(emar.medication), '(dextran 70)')\
        \
        and\
        \
        (\
                trim(event_txt) not in ('Hold Dose', 'Not Confirmed', 'Removed', 'Not Started', 'Not Applied', 'Delayed', 'Not Assessed','Documented in O.R. Holding', 'Flushed in Other Location', 'Delayed Flushed', 'Delayed Not Confirmed', 'Flushed','Not Given', 'Delayed Not Started', 'Stopped - Unscheduled', 'Stopped in Other Location','Stopped - Unscheduled in Other Location', 'Stopped As Directed', 'Delayed Stopped', 'Stopped', 'Delayed Stopped As Directed', 'Infusion Reconciliation', 'Infusion Reconciliation Not Done')\
\
                or event_txt is null\
        )\
\
        \
        \
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
        )\
\
\
        select hadm_id, \
        'first_dextran_70_emar' as event,\
        medication as value,\
\
        event_txt as details,\
\
        charttime as event_time\
\
        from dextran_70_emar\
        where rn = 1 # first administration\
\
)\
\
union all\
\
--*** 2.2.2 inputevents (icu) -(itemid,label) = (225796 , Dextran 70) , (221002 , Dextran 70 / Dextrose 5% (Gentran - Macrodex - RescueFlow)) , (221003 , Dextran 70 / Saline 0,9% (Gentran - Macrodex - RescueFlow))\
\
select * from \
(     \
        with dextran_70_inputevents as\
        (\
        select cohort.hadm_id,\
        starttime,\
        ditems.label, \
        inputevents.originalamount,\
        statusdescription,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by inputevents.starttime) as rn # earliest event appraes first    \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids \
        inner join `physionet-data.mimic_icu.inputevents` inputevents\
        on cohort.hadm_id = inputevents.hadm_id\
\
        left join `physionet-data.mimic_icu.d_items` ditems\
        on inputevents.itemid = ditems.itemid\
\
        where \
        REGEXP_CONTAINS(LOWER(ditems.label), '(dextran 70)')\
\
        and inputevents.starttime > DATETIME(hep_start) \
        )\
\
        select hadm_id, \
        'first_dextran_70_inputevents' as event,\
        label as value,\
\
        statusdescription as details, -- had 4 distinct statusdescription s. - FinishedRunning , Paused, ChangeDose/Rate , Stopped\
        --cast(originalamount as string) as details,\
\
        starttime as event_time\
\
        from dextran_70_inputevents\
        where rn = 1 \
\
)\
\
union all\
\
--2.3. *** Warfarin *** \
\
select * from\
(\
\
with merge_icu_and_hosp as \
\
(\
SELECT \
icu_and_hosp.* , \
row_number() over(partition by hadm_id order by event_time) as rn # last hep_admin appraes first  \
from\
(   \
\
--*** 2.3.1 emar (hosp) - Warfarin\
\
select * from \
(     \
        with warfarin_emar as\
        (\
        select cohort.hadm_id,\
        emar.medication, \
        emar.charttime,\
        event_txt,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by emar.charttime) as rn # earliest event appraes first    \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids \
        inner join `physionet-data.mimic_hosp.emar`emar \
        on cohort.subject_id = emar.subject_id\
\
        where \
        REGEXP_CONTAINS(LOWER(emar.medication), '(warfarin)')\
        \
        and\
        \
        (\
                trim(event_txt) not in ('Hold Dose', 'Not Confirmed', 'Removed', 'Not Started', 'Not Applied', 'Delayed', 'Not Assessed','Documented in O.R. Holding', 'Flushed in Other Location', 'Delayed Flushed', 'Delayed Not Confirmed', 'Flushed','Not Given', 'Delayed Not Started', 'Stopped - Unscheduled', 'Stopped in Other Location','Stopped - Unscheduled in Other Location', 'Stopped As Directed', 'Delayed Stopped', 'Stopped', 'Delayed Stopped As Directed', 'Infusion Reconciliation', 'Infusion Reconciliation Not Done')\
\
                or event_txt is null\
        )\
\
        \
        \
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
        )\
\
\
        select hadm_id, \
        'first_warfarin_emar' as event,\
        medication as value,\
\
        event_txt as details,\
\
        charttime as event_time\
\
        from warfarin_emar\
        where rn = 1 \
\
)\
\
union all\
\
--*** 2.3.2 inputevents (icu) -(itemid,label) = (225913 , Coumadin (Warfarin))\
\
select * from \
(     \
        with warfarin_inputevents as\
        (\
        select cohort.hadm_id,\
        starttime,\
        ditems.label, \
        inputevents.originalamount,\
        statusdescription,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by inputevents.starttime) as rn # earliest event appraes first    \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids \
        inner join `physionet-data.mimic_icu.inputevents` inputevents\
        on cohort.hadm_id = inputevents.hadm_id\
\
        left join `physionet-data.mimic_icu.d_items` ditems\
        on inputevents.itemid = ditems.itemid\
\
        where \
        REGEXP_CONTAINS(LOWER(ditems.label), '(warfarin)')\
\
        and inputevents.starttime > DATETIME(hep_start) \
        )\
\
        select hadm_id, \
        'first_warfarin_inputevents' as event,\
        label as value,\
\
        statusdescription as details, -- had 4 distinct statusdescription s. - FinishedRunning , Paused, ChangeDose/Rate , Stopped\
        --cast(originalamount as string) as details,\
\
        starttime as event_time\
\
        from warfarin_inputevents\
        where rn = 1 \
\
)\
\
) icu_and_hosp\
\
)\
\
        select hadm_id, \
        'first_warfarin' as event,\
        value,\
\
        details,\
\
        event_time\
\
        from merge_icu_and_hosp\
        where rn = 1 \
\
)\
\
union all\
\
--2.4. *** Vitamin K *** \
\
-- In the context of the statement "warfarin should be reversed with vitamin K," the term "reverse" refers to the action of counteracting or neutralizing the anticoagulant effects of warfarin.\
-- Warfarin is an anticoagulant medication that works by inhibiting the synthesis of vitamin K-dependent clotting factors in the liver, thereby preventing blood clot formation. However, in certain situations such as bleeding complications or the need for urgent surgery, it may be necessary to rapidly restore the body's ability to form blood clots.\
-- By administering vitamin K, which is essential for the synthesis of clotting factors, the anticoagulant effects of warfarin can be reversed. Vitamin K helps replenish the depleted levels of clotting factors, allowing the blood to clot effectively again.\
-- So, in this context, "reverse" means to counteract or neutralize the anticoagulant effects of warfarin by restoring the synthesis of clotting factors through the administration of vitamin K.\
\
--*** 2.4.1 emar (hosp) - (medication) = Phytonadione (Vitamin K1) (for L&D to NBN order set use only) , Phytonadione (Vitamin K1)\
\
select * from \
(     \
        with vitamin_k_emar as\
        (\
        select cohort.hadm_id,\
        emar.medication, \
        emar.charttime,\
        event_txt,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by emar.charttime) as rn # earliest event appraes first    \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids \
        inner join `physionet-data.mimic_hosp.emar`emar \
        on cohort.subject_id = emar.subject_id\
\
        where \
        REGEXP_CONTAINS(LOWER(emar.medication), '(vitamin k)')\
        \
        and\
        \
        (\
                trim(event_txt) not in ('Hold Dose', 'Not Confirmed', 'Removed', 'Not Started', 'Not Applied', 'Delayed', 'Not Assessed','Documented in O.R. Holding', 'Flushed in Other Location', 'Delayed Flushed', 'Delayed Not Confirmed', 'Flushed','Not Given', 'Delayed Not Started', 'Stopped - Unscheduled', 'Stopped in Other Location','Stopped - Unscheduled in Other Location', 'Stopped As Directed', 'Delayed Stopped', 'Stopped', 'Delayed Stopped As Directed', 'Infusion Reconciliation', 'Infusion Reconciliation Not Done')\
\
                or event_txt is null\
        )\
\
        \
        \
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
        )\
\
        select hadm_id, \
        'first_vitamin_k_emar' as event,\
        medication as value,\
\
        event_txt as details,\
\
        charttime as event_time\
\
        from vitamin_k_emar\
        where rn = 1 \
\
)\
\
union all\
\
--*** 2.4.2 inputevents (icu) -(itemid,label) = (227535 , Vitamin K (Phytonadione))\
\
select * from \
(     \
        with vitamin_k_inputevents as\
        (\
        select cohort.hadm_id,\
        starttime,\
        ditems.label, \
        inputevents.originalamount,\
        statusdescription,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by inputevents.starttime) as rn # earliest event appraes first    \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids \
        inner join `physionet-data.mimic_icu.inputevents` inputevents\
        on cohort.hadm_id = inputevents.hadm_id\
\
        left join `physionet-data.mimic_icu.d_items` ditems\
        on inputevents.itemid = ditems.itemid\
\
        where \
        REGEXP_CONTAINS(LOWER(ditems.label), '(vitamin k)')\
\
        and inputevents.starttime > DATETIME(hep_start) \
        )\
\
        select hadm_id, \
        'first_vitamin_k_inputevents' as event,\
        label as value,\
\
        statusdescription as details, -- had 4 distinct statusdescription s. - FinishedRunning , Paused, ChangeDose/Rate , Stopped\
        --cast(originalamount as string) as details,\
\
        starttime as event_time\
\
        from vitamin_k_inputevents\
        where rn = 1 \
\
)\
\
union all\
\
--2.5. *** antiplatelet agents - For patients with HIT who require cardiovascular surgery - iloprost , prostacyclin analog , tirofiban , aspirin , dipyridamole *** \
\
-- Platelet inhibitors, also known as antiplatelet agents, are medications that prevent the aggregation of platelets, which are cells involved in blood clot formation. \
\
select * from\
(\
\
with merge_icu_and_hosp as \
\
(\
SELECT \
icu_and_hosp.* , \
row_number() over(partition by hadm_id order by event_time) as rn # last hep_admin appraes first  \
from\
(  \
\
--*** 2.5.1 emar (hosp) - (medications) = Tirofiban , aspirin  (multiple medications) , dipyridamole (multiple medications)\
\
select * from \
(     \
        with antiplatelet_agents_emar as\
        (\
        select cohort.hadm_id,\
        emar.medication, \
        emar.charttime,\
        event_txt,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by emar.charttime) as rn # earliest event appraes first    \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids \
        inner join `physionet-data.mimic_hosp.emar`emar \
        on cohort.subject_id = emar.subject_id\
\
        where \
        REGEXP_CONTAINS(LOWER(emar.medication), '(tirofiban|aspirin|dipyridamole|ticagrelor)')\
        \
        and\
        \
        (\
                trim(event_txt) not in ('Hold Dose', 'Not Confirmed', 'Removed', 'Not Started', 'Not Applied', 'Delayed', 'Not Assessed','Documented in O.R. Holding', 'Flushed in Other Location', 'Delayed Flushed', 'Delayed Not Confirmed', 'Flushed','Not Given', 'Delayed Not Started', 'Stopped - Unscheduled', 'Stopped in Other Location','Stopped - Unscheduled in Other Location', 'Stopped As Directed', 'Delayed Stopped', 'Stopped', 'Delayed Stopped As Directed', 'Infusion Reconciliation', 'Infusion Reconciliation Not Done')\
\
                or event_txt is null\
        )\
\
        \
        \
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
        )\
\
\
        select hadm_id, \
        'first_antiplatelet_agent_emar' as event,\
        medication as value,\
\
        event_txt as details,\
\
        charttime as event_time\
\
        from antiplatelet_agents_emar\
        where rn = 1\
\
)\
\
union all\
\
--*** 2.5.2 inputevents (icu) - (itemid, label) = (225157 , Tirofiban (Aggrastat))\
\
select * from \
(     \
        with antiplatelet_agents_inputevents as\
        (\
        select cohort.hadm_id,\
        starttime,\
        ditems.label, \
        inputevents.originalamount,\
        statusdescription,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by inputevents.starttime) as rn # earliest event appraes first    \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids \
        inner join `physionet-data.mimic_icu.inputevents` inputevents\
        on cohort.hadm_id = inputevents.hadm_id\
\
        left join `physionet-data.mimic_icu.d_items` ditems\
        on inputevents.itemid = ditems.itemid\
\
        where \
        REGEXP_CONTAINS(LOWER(ditems.label), '(tirofiban)')\
\
        and inputevents.starttime > DATETIME(hep_start) \
        )\
\
        select hadm_id, \
        'first_antiplatelet_agent_inputevents' as event,\
        label as value,\
\
        statusdescription as details, -- had 4 distinct statusdescription s. - FinishedRunning , Paused, ChangeDose/Rate , Stopped\
        --cast(originalamount as string) as details,\
\
        starttime as event_time\
\
        from antiplatelet_agents_inputevents\
        where rn = 1 \
\
)\
\
) icu_and_hosp\
\
)\
\
        select hadm_id, \
        'first_antiplatelet_agent' as event,\
        value,\
\
        details,\
\
        event_time\
\
        from merge_icu_and_hosp\
        where rn = 1 \
\
)\
\
\
union all\
\
--2.6. *** regional citrate *** \
\
-- why Citrate? In patients with subacute HIT A, sub- acute HIT B, or remote HIT who are receiving renal replacement therapy, are not otherwise receiving anticoagulation, and require anticoagulation to prevent thrombosis of the dialysis circuit, the ASH guideline panel suggests regional citrate rather than heparin or other non-heparin anticoagulants Citrate is not appropriate for patients with acute HIT, who require systemic rather than regional anticoagulation\
\
--*** 2.6.1 emar (hosp) - (medications) = citrate (multiple medications)\
\
select * from\
(\
\
with merge_icu_and_hosp as \
\
(\
SELECT \
icu_and_hosp.* , \
row_number() over(partition by hadm_id order by event_time) as rn # last hep_admin appraes first  \
from\
(    \
\
select * from \
(     \
        with citrate_emar as\
        (\
        select cohort.hadm_id,\
        emar.medication, \
        emar.charttime,\
        event_txt,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by emar.charttime) as rn # earliest event appraes first    \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids \
        inner join `physionet-data.mimic_hosp.emar`emar \
        on cohort.subject_id = emar.subject_id\
\
        where \
        REGEXP_CONTAINS(LOWER(emar.medication), '(citrate)')\
        \
        and\
        \
        (\
                trim(event_txt) not in ('Hold Dose', 'Not Confirmed', 'Removed', 'Not Started', 'Not Applied', 'Delayed', 'Not Assessed','Documented in O.R. Holding', 'Flushed in Other Location', 'Delayed Flushed', 'Delayed Not Confirmed', 'Flushed','Not Given', 'Delayed Not Started', 'Stopped - Unscheduled', 'Stopped in Other Location','Stopped - Unscheduled in Other Location', 'Stopped As Directed', 'Delayed Stopped', 'Stopped', 'Delayed Stopped As Directed', 'Infusion Reconciliation', 'Infusion Reconciliation Not Done')\
\
                or event_txt is null\
        )\
\
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
        )\
\
\
        select hadm_id, \
        'first_citrate_emar' as event,\
        medication as value,\
\
        event_txt as details,\
\
        charttime as event_time\
\
        from citrate_emar\
        where rn = 1\
\
)\
\
union all\
\
--*** 2.6.2 inputevents (icu) - (itemid, label) = (228004 , Citrate (ACD-A)) , (227526 , Citrate) , (227528 , ACD-A Citrate (500ml)) , (227529 , ACD-A Citrate (1000ml)) , (225164 , Trisodium Citrate 0.4%) \
\
select * from \
(     \
        with citrate_inputevents as\
        (\
        select cohort.hadm_id,\
        starttime,\
        ditems.label, \
        inputevents.originalamount,\
        statusdescription,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by inputevents.starttime) as rn # earliest event appraes first    \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids \
        inner join `physionet-data.mimic_icu.inputevents` inputevents\
        on cohort.hadm_id = inputevents.hadm_id\
\
        left join `physionet-data.mimic_icu.d_items` ditems\
        on inputevents.itemid = ditems.itemid\
\
        where \
        REGEXP_CONTAINS(LOWER(ditems.label), '(citrate)')\
\
        and inputevents.starttime > DATETIME(hep_start) \
        )\
\
        select hadm_id, \
        'first_citrate_inputevents' as event,\
        label as value,\
\
        statusdescription as details, -- had 4 distinct statusdescription s. - FinishedRunning , Paused, ChangeDose/Rate , Stopped\
        --cast(originalamount as string) as details,\
\
        starttime as event_time\
\
        from citrate_inputevents\
        where rn = 1 \
\
)\
\
) icu_and_hosp\
\
)\
\
        select hadm_id, \
        'first_citrate' as event,\
        value,\
\
        details,\
\
        event_time\
\
        from merge_icu_and_hosp\
        where rn = 1 \
\
)\
\
--2.7. *** antiplatelet agent - ticagrelor - making it appear that the test is negative when in fact HIT is present. One exception to the use of a functional assay is a patient receiving the anti-platelet drug ticagrelor (from UpToDate). *** \
\
--*** 2.7.1 emar (hosp) - (medications) = ticagrelor (multiple medications)\
\
union all\
\
--*** 2.7.2 hosp (icd_procedures) - platelet inhibitors ( "platelet inhibitors" and "antiplatelet agents" generally refer to the same class of medications. )\
\
select * from \
(\
        with platelet_inhibitors_hosp_icd_procedure as\
        (\
        select cohort.hadm_id, \
        \
        hosp_procedures.icd_code,\
        long_title,\
        chartdate,\
        \
        row_number() over(\
        partition by cohort.hadm_id\
        order by chartdate) as rn # earliest event appraes first   \
           \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.procedures_icd` hosp_procedures\
        on cohort.hadm_id = hosp_procedures.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'procedures_icd' table.\
\
        left join `physionet-data.mimic_hosp.d_icd_procedures` codes\
        on hosp_procedures.icd_code = codes.icd_code\
\
        where \
    (\
\
        (hosp_procedures.icd_code = '9919' and hosp_procedures.icd_version =  9)  -- Injection of anticoagulant\
    or  (hosp_procedures.icd_code = '9920' and hosp_procedures.icd_version =  9)  -- Injection or infusion of platelet inhibitor\
\
    or (hosp_procedures.icd_code = '3E030PZ' and hosp_procedures.icd_version = 10) -- Introduction of Platelet Inhibitor into Peripheral Vein, Open Approach\
    or (hosp_procedures.icd_code = '3E033PZ' and hosp_procedures.icd_version = 10) -- Introduction of Platelet Inhibitor into Peripheral Vein, Percutaneous Approach\
    or (hosp_procedures.icd_code = '3E040PZ' and hosp_procedures.icd_version = 10) -- Introduction of Platelet Inhibitor into Central Vein, Open Approach\
    or (hosp_procedures.icd_code = '3E043PZ' and hosp_procedures.icd_version = 10) -- Introduction of Platelet Inhibitor into Central Vein, Percutaneous Approach\
    or (hosp_procedures.icd_code = '3E050PZ' and hosp_procedures.icd_version = 10) -- Introduction of Platelet Inhibitor into Peripheral Artery, Open Approach\
    or (hosp_procedures.icd_code = '3E053PZ' and hosp_procedures.icd_version = 10) -- Introduction of Platelet Inhibitor into Peripheral Artery, Percutaneous Approach\
    or (hosp_procedures.icd_code = '3E060PZ' and hosp_procedures.icd_version = 10) -- Introduction of Platelet Inhibitor into Central Artery, Open Approach\
    or (hosp_procedures.icd_code = '3E063PZ' and hosp_procedures.icd_version = 10) -- Introduction of Platelet Inhibitor into Central Artery, Percutaneous Approach\
    or (hosp_procedures.icd_code = '3E070PZ' and hosp_procedures.icd_version = 10) -- Introduction of Platelet Inhibitor into Coronary Artery, Open Approach\
    or (hosp_procedures.icd_code = '3E073PZ' and hosp_procedures.icd_version = 10) -- Introduction of Platelet Inhibitor into Coronary Artery, Percutaneous Approach\
    )\
\
    and chartdate > DATETIME(hep_start) \
        )\
\
\
        select hadm_id, \
        'first_platelet_inhibitors_hosp_icd_procedure' as event,\
        icd_code as value,\
\
        long_title as details,\
\
        chartdate as event_time\
\
        from platelet_inhibitors_hosp_icd_procedure\
        where rn = 1\
\
)\
\
--*** 2.8  Intravenous Immunoglobulin G / IVIG ***\
\
union all\
\
--*** 2.8.1 emar (hosp) - (medications) = (Immune Globulin Intravenous (Human))\
\
select * from\
(\
\
with merge_icu_and_hosp as \
\
(\
SELECT \
icu_and_hosp.* , \
row_number() over(partition by hadm_id order by event_time) as rn # last hep_admin appraes first  \
from\
(     \
        \
select * from \
(     \
        with IVIG_emar as\
        (\
        select cohort.hadm_id,\
        emar.medication, \
        emar.charttime,\
        event_txt,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by emar.charttime) as rn # earliest event appraes first    \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids \
        inner join `physionet-data.mimic_hosp.emar`emar \
        on cohort.subject_id = emar.subject_id\
\
        where \
        emar.medication = 'Immune Globulin Intravenous (Human)' \
        \
        and\
\
        (\
                trim(event_txt) not in ('Hold Dose', 'Not Confirmed', 'Removed', 'Not Started', 'Not Applied', 'Delayed', 'Not Assessed','Documented in O.R. Holding', 'Flushed in Other Location', 'Delayed Flushed', 'Delayed Not Confirmed', 'Flushed','Not Given', 'Delayed Not Started', 'Stopped - Unscheduled', 'Stopped in Other Location','Stopped - Unscheduled in Other Location', 'Stopped As Directed', 'Delayed Stopped', 'Stopped', 'Delayed Stopped As Directed', 'Infusion Reconciliation', 'Infusion Reconciliation Not Done')\
\
                or event_txt is null\
        )\
\
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
        )\
\
        select hadm_id, \
        'first_IVIG_emar' as event,\
        medication as value,\
\
        event_txt as details,\
\
        charttime as event_time\
\
        from IVIG_emar\
        where rn = 1 \
\
)\
\
union all\
\
--*** 2.8.2 inputevents (icu) - (itemid, label) = (227530 , IV Immune Globulin (IVIG))\
\
select * from \
(     \
        with IVIG_inputevents as\
        (\
        select cohort.hadm_id,\
        starttime,\
        ditems.label, \
        inputevents.originalamount,\
        statusdescription,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by inputevents.starttime) as rn # earliest event appraes first    \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids \
        inner join `physionet-data.mimic_icu.inputevents` inputevents\
        on cohort.hadm_id = inputevents.hadm_id\
\
        left join `physionet-data.mimic_icu.d_items` ditems\
        on inputevents.itemid = ditems.itemid\
\
        where \
        inputevents.itemid in (227530)\
\
        and inputevents.starttime > DATETIME(hep_start) \
        )\
\
        select hadm_id, \
        'first_IVIG_inputevents' as event,\
        label as value,\
\
        statusdescription as details, -- had 4 distinct statusdescription s. - FinishedRunning , Paused, ChangeDose/Rate , Stopped\
        --cast(originalamount as string) as details,\
\
        starttime as event_time\
\
        from IVIG_inputevents\
        where rn = 1 \
\
)\
\
union all\
\
--*** 2.8.3 inputevents (icu) - (itemid, label) = (227530 , IV Immune Globulin (IVIG))\
\
select * from \
(     \
        with globulin_hosp_icd_procedure as\
        (\
        select cohort.hadm_id, \
        'globulin_hosp_icd_procedure' as event, \
        hosp_procedures.icd_code as value,\
        long_title as details,\
        chartdate as event_time,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by chartdate) as rn # earliest event appraes first    \
          \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.procedures_icd` hosp_procedures\
        on cohort.hadm_id = hosp_procedures.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'procedures_icd' table.\
\
        left join `physionet-data.mimic_hosp.d_icd_procedures` codes\
        on hosp_procedures.icd_code = codes.icd_code\
\
        where \
\
        lower(long_title) like '%globulin%' and\
\
        chartdate > DATETIME(hep_start) \
        )\
\
/*\
       (hosp_procedures.icd_code like '3023%' and hosp_procedures.icd_version = 10) # Transfusion of Autologous / Nonautologous Globulin into Peripheral Vein, Open / Percutaneous Approach\
    or (hosp_procedures.icd_code like '3024%' and hosp_procedures.icd_version = 10) # Transfusion of Autologous / Nonautologous Globulin into Central Vein, Open / Percutaneous Approach\
\
    or (hosp_procedures.icd_code like '3025%' and hosp_procedures.icd_version = 10) # Transfusion of Autologous / Nonautologous Globulin into Peripheral Artery, Open / Percutaneous Approach\
    or (hosp_procedures.icd_code like '3026%' and hosp_procedures.icd_version = 10) # Transfusion of Autologous / Nonautologous Globulin into Central Artery, Open / Percutaneous Approach\
    or (hosp_procedures.icd_code like '3027%' and hosp_procedures.icd_version = 10) # Transfusion of Nonautologous Globulin into Products of Conception, Circulatory, Percutaneous Approach / Via Natural or Artificial Opening\
    or (hosp_procedures.icd_code = '9911' and hosp_procedures.icd_version = 10) # Injection of Rh immune globulin\
    or (hosp_procedures.icd_code = '9914' and hosp_procedures.icd_version = 10) # Injection or infusion of immunoglobulin\
*/\
        select globulin_hosp_icd_procedure.*except(rn)\
\
        from globulin_hosp_icd_procedure\
        where rn = 1 \
)\
\
) icu_and_hosp\
\
)\
\
        select hadm_id, \
        'first_IVIG' as event,\
        value,\
\
        details,\
\
        event_time\
\
        from merge_icu_and_hosp\
        where rn = 1 \
\
)\
\
union all\
\
--*** 2.9  heparin dose\
\
--*** 2.9.1 first heparin dose\
\
select * from \
(\
        select cohort.hadm_id, \
        'first_heparin_dose' as event, \
        hep_types as value,\
\
        treatment_types as details,\
\
        datetime(hep_start) as event_time from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
)\
\
union all\
\
--*** 2.9.2 Last heparin dose\
\
select * from \
(       with last_hep as\
        (\
        select cohort.hadm_id, \
        medication, event_txt,charttime,\
        \
        row_number() over(\
        partition by cohort.hadm_id\
        order by emar.charttime desc) as rn # last hep_admin appraes first    \
\
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.emar`emar \
        on cohort.subject_id = emar.subject_id\
\
        where \
\
        (LOWER(emar.medication) LIKE '%heparin%' OR\
        LOWER(emar.medication) LIKE '%bemiparin%' OR\
        LOWER(emar.medication) LIKE '%dalteparin%' OR\
        LOWER(emar.medication) LIKE '%enoxaparin%' OR\
        LOWER(emar.medication) LIKE '%nadroparin%' OR\
        LOWER(emar.medication) LIKE '%parnaparin%' OR\
        LOWER(emar.medication) LIKE '%reviparin%' OR\
        LOWER(emar.medication) LIKE '%tinzaparin%') \
\
        and lower(medication) not like '%flush%'\
        --and lower(route) not in ('dialys', 'dwell', 'impella', 'femoral vein', 'po', 'ng', 'po/ng', 'ng/po', 'tp', 'ip', 'lock', 'dlpicc')\
        \
        and\
        \
        (\
                trim(event_txt) not in ('Hold Dose', 'Not Confirmed', 'Removed', 'Not Started', 'Not Applied', 'Delayed', 'Not Assessed','Documented in O.R. Holding', 'Flushed in Other Location', 'Delayed Flushed', 'Delayed Not Confirmed', 'Flushed','Not Given', 'Delayed Not Started', 'Stopped - Unscheduled', 'Stopped in Other Location','Stopped - Unscheduled in Other Location', 'Stopped As Directed', 'Delayed Stopped', 'Stopped', 'Delayed Stopped As Directed', 'Infusion Reconciliation', 'Infusion Reconciliation Not Done')\
\
                or event_txt is null\
        )\
        \
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime >= DATETIME(hep_start) -- first and last hep doses would be the same if the patient was given heparin only once.\
        )\
\
        select hadm_id, \
        'last_heparin_dose' as event, \
        medication as value,\
        event_txt as details,\
        charttime as event_time \
\
        from last_hep\
        where rn=1\
\
)\
\
union all\
\
--*** 2.10  protamine - a reversal agent to manage Heparin-associated bleeding\
\
--*** 2.10.1 emar (hosp) - (medications) = Protamine Sulfate\
\
\
select * from\
(\
\
with merge_icu_and_hosp as \
\
(\
SELECT \
icu_and_hosp.* , \
row_number() over(partition by hadm_id order by event_time) as rn # last hep_admin appraes first  \
from\
(           \
select * from \
(     \
        with protamine_emar as\
        (\
        select cohort.hadm_id,\
        emar.medication, \
        emar.charttime,\
        event_txt,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by emar.charttime) as rn # earliest event appraes first    \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids \
        inner join `physionet-data.mimic_hosp.emar`emar \
        on cohort.subject_id = emar.subject_id\
\
        where \
        emar.medication = 'Protamine Sulfate'\
\
        and\
        \
        (\
                trim(event_txt) not in ('Hold Dose', 'Not Confirmed', 'Removed', 'Not Started', 'Not Applied', 'Delayed', 'Not Assessed','Documented in O.R. Holding', 'Flushed in Other Location', 'Delayed Flushed', 'Delayed Not Confirmed', 'Flushed','Not Given', 'Delayed Not Started', 'Stopped - Unscheduled', 'Stopped in Other Location','Stopped - Unscheduled in Other Location', 'Stopped As Directed', 'Delayed Stopped', 'Stopped', 'Delayed Stopped As Directed', 'Infusion Reconciliation', 'Infusion Reconciliation Not Done')\
\
                or event_txt is null\
        )\
\
        and charttime between DATETIME(admittime) and DATETIME(dischtime)\
        and charttime > DATETIME(hep_start) \
        )\
\
\
        select hadm_id, \
        'first_protamine_emar' as event,\
        medication as value,\
\
        event_txt as details,\
\
        charttime as event_time\
\
        from protamine_emar\
        where rn = 1 \
\
)\
\
union all\
\
--*** 2.10.2 inputevents (icu) - Protamine Sulfate - (itemid, label) = (229068 , Protamine sulfate) \
\
select * from \
(     \
        with Protamine_inputevents as\
        (\
        select cohort.hadm_id,\
        starttime,\
        ditems.label, \
        inputevents.originalamount,\
        statusdescription,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by inputevents.starttime) as rn # earliest event appraes first    \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids \
        inner join `physionet-data.mimic_icu.inputevents` inputevents\
        on cohort.hadm_id = inputevents.hadm_id\
\
        left join `physionet-data.mimic_icu.d_items` ditems\
        on inputevents.itemid = ditems.itemid\
\
        where \
        inputevents.itemid in (229068)\
\
        and inputevents.starttime > DATETIME(hep_start) \
        )\
\
        select hadm_id, \
        'first_protamine_inputevents' as event,\
        label as value,\
\
        statusdescription as details, -- had 4 distinct statusdescription s. - FinishedRunning , Paused, ChangeDose/Rate , Stopped\
\
        starttime as event_time\
\
        from Protamine_inputevents\
        where rn = 1 \
\
)\
\
) icu_and_hosp\
\
)\
\
        select hadm_id, \
        'first_protamine' as event,\
        value,\
\
        details,\
\
        event_time\
\
        from merge_icu_and_hosp\
        where rn = 1 \
\
)\
\
union all\
\
#---------------------------------------------------------------\
\
--3. *** Procedures *** \
\
--*** 3.1.platelet tranfusion\
\
select * from\
(\
with merge_icu_and_hosp as \
(\
SELECT \
icu_and_hosp.* , \
row_number() over(partition by hadm_id order by event_time) as rn # last hep_admin appraes first  \
from\
( \
\
select * from \
(     \
\
--*** 3.1.1 .platelet tranfusion - mimic hosp - has few icd_codes\
-- no records returned for our Hep cohort\
\
        with platelet_tranfusion_hosp_icd_procedure as\
        (\
        select cohort.hadm_id, \
        'platelet_tranfusion_hosp_icd_procedure' as event, \
        hosp_procedures.icd_code as value,\
        long_title as details,\
        chartdate as event_time,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by chartdate) as rn # earliest event appraes first    \
          \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.procedures_icd` hosp_procedures\
        on cohort.hadm_id = hosp_procedures.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'procedures_icd' table.\
\
        left join `physionet-data.mimic_hosp.d_icd_procedures` codes\
        on hosp_procedures.icd_code = codes.icd_code\
\
        where \
\
        (LOWER(long_title) like '%platelet%' and  -- has few icd_codes , but no records returned for our Hep cohort.\
        LOWER(long_title) like '%transf%')\
\
-- ex - (hosp_procedures.icd_code like '9905' and hosp_procedures.icd_version = 9) # Transfusion of platelets\
\
        and chartdate > DATETIME(hep_start) \
        )\
\
        select platelet_tranfusion_hosp_icd_procedure.*except(rn)\
\
        from platelet_tranfusion_hosp_icd_procedure\
        where rn = 1 \
)\
\
union all\
\
--*** 3.1.2 .platelet tranfusion - inputevents (icu) - (itemid, label) = (225170 , Platelets) , (226369 , OR Platelet Intake) , (227071 , PACU Platelet Intake)\
\
select * from \
(     \
        with platelet_tranfusion_icu as\
        (\
        select cohort.hadm_id, \
        'platelet_tranfusion_icu_inputevents' as event, \
        cast(originalamount as string) as value,\
\
        statusdescription as details,  -- had 4 distinct statusdescription s. - FinishedRunning , Paused, ChangeDose/Rate , Stopped\
        \
        starttime as event_time,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by starttime) as rn # earliest event appraes first    \
          \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_icu.inputevents` inputevents \
        on cohort.hadm_id = inputevents.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'inputevents' table.\
\
        where inputevents.itemid in (225170 , 226369 , 227071)\
        \
        and starttime > DATETIME(hep_start) \
        )\
\
        select platelet_tranfusion_icu.*except(rn)\
\
        from platelet_tranfusion_icu\
        where rn = 1 \
\
)\
) icu_and_hosp\
\
)\
\
        select hadm_id, \
        'first_platelet_tranfusion' as event,\
        value,\
\
        details,\
\
        event_time\
\
        from merge_icu_and_hosp\
        where rn = 1 \
\
)\
--*** 3.2.Amputation\
\
--*** 3.2.1 mimic hosp - has few icd_codes\
-- no records returned - there were few records for the hep cohort where they had amputations, but the procedure_date was before first_hep_admin.\
\
union all\
\
select * from \
(\
        select cohort.hadm_id, \
        'amputation_hosp_icd_procedure' as event, \
        hosp_procedures.icd_code as value,\
        long_title as details,\
        chartdate as event_time from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.procedures_icd` hosp_procedures\
        on cohort.hadm_id = hosp_procedures.hadm_id\
\
        left join `physionet-data.mimic_hosp.d_icd_procedures` codes\
        on hosp_procedures.icd_code = codes.icd_code\
\
        where lower(long_title) like '%amput%'\
        --and chartdate between DATETIME(admittime) and DATETIME(dischtime)\
        and chartdate > DATETIME(hep_start) \
)\
\
union all\
\
--*** 3.2.2 mimic icu procedureevents - not relevant itemid s.\
\
--*** 3.3.ultrasonography\
\
select * from\
(\
\
with merge_icu_and_hosp as \
\
(\
SELECT \
icu_and_hosp.* , \
row_number() over(partition by hadm_id order by event_time) as rn # last hep_admin appraes first  \
from\
(  \
--*** 3.3.1 hosp (icd_procedures) - ultrasonography of heart / veins / arteries (for icd codes -> https://www.icd10data.com/)\
\
select * from \
(\
        with ultrasonography_hosp_icd_procedure as\
        (\
        select cohort.hadm_id, \
        'ultrasonography_hosp_icd_procedure' as event, \
        hosp_procedures.icd_code as value,\
        long_title as details,\
        chartdate as event_time,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by chartdate) as rn # earliest event appraes first    \
          \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.procedures_icd` hosp_procedures\
        on cohort.hadm_id = hosp_procedures.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'procedures_icd' table.\
\
        left join `physionet-data.mimic_hosp.d_icd_procedures` codes\
        on hosp_procedures.icd_code = codes.icd_code\
\
        where \
    (\
       (hosp_procedures.icd_code like 'B24%' and hosp_procedures.icd_version = 10) \
    or (hosp_procedures.icd_code like 'B34%' and hosp_procedures.icd_version = 10) \
    or (hosp_procedures.icd_code like 'B44%' and hosp_procedures.icd_version = 10) \
    or (hosp_procedures.icd_code like 'B54%' and hosp_procedures.icd_version = 10) \
    )\
    \
    and chartdate > DATETIME(hep_start) \
)\
\
        select ultrasonography_hosp_icd_procedure.*except(rn)\
\
        from ultrasonography_hosp_icd_procedure\
        where rn = 1 \
)\
\
union all\
\
--*** 3.3.2 ultrasound - icu.procedureevents \
\
select * from \
(\
        with ultrasound_icu_procedureevents as\
        (\
        select cohort.hadm_id, \
        'ultrasound_icu_procedureevents' as event, \
        cast(originalamount as string) as value,\
\
        statusdescription as details,  -- had 4 distinct statusdescription s. - FinishedRunning , Paused, ChangeDose/Rate , Stopped\
        \
        starttime as event_time,\
\
        row_number() over(partition by cohort.hadm_id order by starttime) as rn # earliest event appraes first    \
          \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_icu.procedureevents` procedureevents \
        on cohort.hadm_id = procedureevents.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'inputevents' table.\
\
        left join `physionet-data.mimic_icu.d_items` ditems\
        on procedureevents.itemid = ditems.itemid\
\
        where lower(label) like '%ultrasound%'\
        \
        and starttime > DATETIME(hep_start) \
)\
\
        select ultrasound_icu_procedureevents.*except(rn)\
\
        from ultrasound_icu_procedureevents\
        where rn = 1 \
\
)\
\
) icu_and_hosp\
\
)\
\
        select hadm_id, \
        'first_ultrasound' as event,\
        value,\
\
        details,\
\
        event_time\
\
        from merge_icu_and_hosp\
        where rn = 1 \
\
)\
\
--*** 3.4.CT scan\
\
union all\
\
--*** 3.4.1 hosp (icd_procedures) - CT scan - several icd codes used.\
\
select * from\
(\
with merge_icu_and_hosp as \
(\
SELECT \
icu_and_hosp.* , \
row_number() over(partition by hadm_id order by event_time) as rn # last hep_admin appraes first  \
from\
( \
\
select * from \
(     \
        with CT_scan_hosp_icd_procedure as\
        (\
        select cohort.hadm_id, \
        'CT_scan_hosp_icd_procedure' as event, \
        hosp_procedures.icd_code as value,\
        long_title as details,\
        chartdate as event_time, \
        row_number() over(partition by cohort.hadm_id order by chartdate) as rn # earliest event appraes first    \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.procedures_icd` hosp_procedures\
        on cohort.hadm_id = hosp_procedures.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'procedures_icd' table.\
\
        left join `physionet-data.mimic_hosp.d_icd_procedures` codes\
        on hosp_procedures.icd_code = codes.icd_code\
\
        where \
        \
        (\
        (REGEXP_CONTAINS(hosp_procedures.icd_code , '^(B32S|B32T|B52Q|B52R|B52S|BW24|BW25)') and hosp_procedures.icd_version = 10) # any icd_code START with given patterns\
\
     or (hosp_procedures.icd_code = '9215' and hosp_procedures.icd_version = 10) # Pulmonary scan\
        )\
\
        and chartdate > DATETIME(hep_start) \
        )\
\
        select CT_scan_hosp_icd_procedure.*except(rn)\
\
        from CT_scan_hosp_icd_procedure\
        where rn = 1 \
)\
\
union all\
\
--*** 3.4.2 procedureevents (icu) - CT scan - (itemid , label) = (221214 , CT scan) , (229582 , Portable CT scan)\
\
select * from \
(     \
        with CT_scan_icu_procedureevents as\
        (\
        select cohort.hadm_id, \
        'CT_scan_icu_procedureevents' as event, \
        cast(originalamount as string) as value,\
\
        statusdescription as details,  -- had 4 distinct statusdescription s. - FinishedRunning , Paused, ChangeDose/Rate , Stopped\
        \
        starttime as event_time,\
        row_number() over(partition by cohort.hadm_id order by starttime) as rn # earliest event appraes first    \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_icu.procedureevents` procedureevents \
        on cohort.hadm_id = procedureevents.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'inputevents' table.\
\
        left join `physionet-data.mimic_icu.d_items` ditems\
        on procedureevents.itemid = ditems.itemid\
\
        where procedureevents.itemid in (221214 , 229582)\
        \
        and starttime > DATETIME(hep_start) \
\
        )\
\
        select CT_scan_icu_procedureevents.*except(rn)\
\
        from CT_scan_icu_procedureevents\
        where rn = 1 \
\
)\
\
) icu_and_hosp\
\
)\
\
        select hadm_id, \
        'first_CT_scan' as event,\
        value,\
\
        details,\
\
        event_time\
\
        from merge_icu_and_hosp\
        where rn = 1 \
\
\
)\
\
union all\
\
--*** 3.5.CT scan / Angiography\
\
--***  hosp (icd_procedures) - no icd codes found for pulmonary angiography.\
\
\
--*** 3.5.1 procedureevents (icu) -Angiography - (itemid , label) = (225427 , Angiography) \
\
select * from \
(     \
        with platelet_tranfusion_icu as\
        (\
        select cohort.hadm_id, \
        'Angiography_icu_procedureevents' as event, \
        cast(originalamount as string) as value,\
\
        statusdescription as details,  -- had 4 distinct statusdescription s. - FinishedRunning , Paused, ChangeDose/Rate , Stopped\
        \
        starttime as event_time,\
\
        row_number() over(partition by cohort.hadm_id order by starttime) as rn # earliest event appraes first \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_icu.procedureevents` procedureevents \
        on cohort.hadm_id = procedureevents.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'inputevents' table.\
\
        left join `physionet-data.mimic_icu.d_items` ditems\
        on procedureevents.itemid = ditems.itemid\
\
        where procedureevents.itemid in (225427)\
        \
        and starttime > DATETIME(hep_start) \
        )\
\
        select hadm_id, \
        'First_Angiography_icu_procedureevents' as event, \
        value,\
\
        details,  -- had 4 distinct statusdescription s. - FinishedRunning , Paused, ChangeDose/Rate , Stopped\
        \
        event_time,\
\
        from platelet_tranfusion_icu\
        where rn = 1 # first other anticoagulant administration\
\
)\
\
union all\
\
--*** 3.6.X-ray\
\
--*** 3.6.1 hosp (icd_procedures) - X-ray - several icd codes used.\
\
select * from\
(\
with merge_icu_and_hosp as \
(\
SELECT \
icu_and_hosp.* , \
row_number() over(partition by hadm_id order by event_time) as rn # last hep_admin appraes first  \
from\
( \
\
select * from \
(     \
        with Xray_hosp_icd_procedure as\
        (\
        select cohort.hadm_id, \
        'Xray_hosp_icd_procedure' as event, \
        hosp_procedures.icd_code as value,\
        long_title as details,\
        chartdate as event_time,\
        \
        row_number() over(partition by cohort.hadm_id order by chartdate) as rn # earliest event appraes first   \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.procedures_icd` hosp_procedures\
        on cohort.hadm_id = hosp_procedures.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'procedures_icd' table.\
\
        left join `physionet-data.mimic_hosp.d_icd_procedures` codes\
        on hosp_procedures.icd_code = codes.icd_code\
\
        where \
\
(\
        (hosp_procedures.icd_code like '87%' and hosp_procedures.icd_version = 9) #  Diagnostic Radiology (both X-ray and CT scan come under this) - http://www.icd9data.com/2015/Volume3/87-99/87/default.htm?__hstc=93424706.1dc943758edd65a56c9bf8d449b606d4.1712807566965.1712873162869.1712916941336.9&__hssc=93424706.10.1712916941336&__hsfp=3268556682#87.41\
\
       or (lower(long_title) like '%x-ray%' and hosp_procedures.icd_version = 10)\
\
       or (hosp_procedures.icd_code like 'BW0%' and hosp_procedures.icd_version = 10)# Imaging, Anatomical Regions, Plain Radiography\
)\
       and chartdate > DATETIME(hep_start) \
        )\
\
        select Xray_hosp_icd_procedure.*except(rn)\
\
        from Xray_hosp_icd_procedure\
        where rn = 1 \
\
)\
\
union all\
\
--*** 3.6.2 procedureevents (icu) -x-ray - (itemid , label) = (221216 , X-ray) , (225457,Abdominal X-Ray) , (225459,Chest X-Ray) , (229581,Portable Chest X-Ray)\
\
select * from \
(     \
        with xray_icu_procedureevents as\
        (\
        select cohort.hadm_id, \
        'xray_icu_procedureevents' as event, \
        cast(originalamount as string) as value,\
\
        statusdescription as details,  -- had 4 distinct statusdescription s. - FinishedRunning , Paused, ChangeDose/Rate , Stopped\
        \
        starttime as event_time,\
\
        row_number() over(partition by cohort.hadm_id order by starttime) as rn # earliest event appraes first    \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_icu.procedureevents` procedureevents \
        on cohort.hadm_id = procedureevents.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'inputevents' table.\
\
        left join `physionet-data.mimic_icu.d_items` ditems\
        on procedureevents.itemid = ditems.itemid\
\
        where procedureevents.itemid in (221216 , 225457 , 225459, 229581) \
        \
        and starttime > DATETIME(hep_start) \
\
        )\
\
        select xray_icu_procedureevents.*except(rn)\
\
        from xray_icu_procedureevents\
        where rn = 1 \
\
)\
\
) icu_and_hosp\
\
)\
\
        select hadm_id, \
        'first_Xray' as event,\
        value,\
\
        details,\
\
        event_time\
\
        from merge_icu_and_hosp\
        where rn = 1 \
        \
)\
\
union all\
\
--*** 3.7. MRI\
\
--*** 3.7.1 hosp (icd_procedures) - MRI - several icd codes used.\
\
select * from\
(\
with merge_icu_and_hosp as \
(\
SELECT \
icu_and_hosp.* , \
row_number() over(partition by hadm_id order by event_time) as rn # last hep_admin appraes first  \
from\
( \
\
select * from \
(     \
        with MRI_hosp_icd_procedure as\
        (\
        select cohort.hadm_id, \
        'MRI_hosp_icd_procedure' as event, \
        hosp_procedures.icd_code as value,\
        long_title as details,\
        chartdate as event_time,\
        row_number() over(partition by cohort.hadm_id order by chartdate) as rn # earliest event appraes first   \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.procedures_icd` hosp_procedures\
        on cohort.hadm_id = hosp_procedures.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'procedures_icd' table.\
\
        left join `physionet-data.mimic_hosp.d_icd_procedures` codes\
        on hosp_procedures.icd_code = codes.icd_code\
\
        where lower(long_title) like '%magnetic resonance imaging (mri)%'\
\
        and chartdate > DATETIME(hep_start) \
\
        )\
\
        select MRI_hosp_icd_procedure.*except(rn)\
\
        from MRI_hosp_icd_procedure\
        where rn = 1 \
\
)\
\
union all\
\
--*** 3.7.2 procedureevents (icu) -MRI - (itemid , label) = (223253 , Magnetic Resonance Imaging)\
\
select * from \
(     \
        with MRI_icu_procedureevents as\
        (\
        select cohort.hadm_id, \
        'MRI_icu_procedureevents' as event, \
        cast(originalamount as string) as value,\
\
        statusdescription as details,  -- had 4 distinct statusdescription s. - FinishedRunning , Paused, ChangeDose/Rate , Stopped\
        \
        starttime as event_time, \
        \
        row_number() over(partition by cohort.hadm_id order by starttime) as rn # earliest event appraes first   \
\
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_icu.procedureevents` procedureevents \
        on cohort.hadm_id = procedureevents.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'inputevents' table.\
\
        left join `physionet-data.mimic_icu.d_items` ditems\
        on procedureevents.itemid = ditems.itemid\
\
        where procedureevents.itemid in (223253)\
        \
        and starttime > DATETIME(hep_start) \
        )\
\
        select MRI_icu_procedureevents.*except(rn)\
\
        from MRI_icu_procedureevents\
        where rn = 1 \
\
)\
\
) icu_and_hosp\
\
)\
\
        select hadm_id, \
        'first_MRI' as event,\
        value,\
\
        details,\
\
        event_time\
\
        from merge_icu_and_hosp\
        where rn = 1 \
        \
)\
\
union all\
\
--*** 3.8 Skin biopsy\
\
--*** 3.8.1 hosp (icd_procedures) - (icd_code, icd_version, long_title) = (8611, 9 , Closed biopsy of skin and subcutaneous tissue)\
-- couldn't find relevant ICD-10 codes.\
-- couldn't find relevant ITEMID s in icd.ditems.\
\
select * from \
(     \
        with skin_biopsy_hosp_icd_procedure as\
        (\
        select cohort.hadm_id, \
        'skin_biopsy_hosp_icd_procedure' as event, \
        hosp_procedures.icd_code as value,\
        long_title as details,\
        chartdate as event_time,\
        row_number() over(partition by cohort.hadm_id order by chartdate) as rn # earliest event appraes first     \
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.procedures_icd` hosp_procedures\
        on cohort.hadm_id = hosp_procedures.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'procedures_icd' table.\
\
        left join `physionet-data.mimic_hosp.d_icd_procedures` codes\
        on hosp_procedures.icd_code = codes.icd_code\
\
        where (hosp_procedures.icd_code='8611' and hosp_procedures.icd_version = 9)\
\
        and chartdate > DATETIME(hep_start) \
\
        )\
\
        select hadm_id, \
        'first_skin_biopsy' as event,\
        value,\
\
        details,\
\
        event_time\
\
        from skin_biopsy_hosp_icd_procedure\
        where rn = 1 \
\
)\
\
union all\
\
--*** 3.9 Pheresis of Plasma / Plasma exchange \
\
-- Why ? Plasma pheresis, also known as plasmapheresis or plasma exchange, is a therapeutic procedure in which the patient's blood is circulated through a machine that separates plasma from other blood components. The plasma, which contains various proteins, antibodies, and other substances, is then removed from the blood and discarded or replaced with donor plasma or a plasma substitute. The filtered blood components are then returned to the patient's circulation. Plasma pheresis is used to treat various medical conditions, including autoimmune diseases, neurological disorders, and certain toxicities, by removing harmful substances from the bloodstream and replacing them with healthy plasma or a plasma substitute\
\
--*** 3.9.1 hosp (icd_procedures) - Pheresis of Plasma / Plasma exchange (for icd codes -> https://www.icd10data.com/)\
\
select * from\
(\
with merge_icu_and_hosp as \
(\
SELECT \
icu_and_hosp.* , \
row_number() over(partition by hadm_id order by event_time) as rn # last hep_admin appraes first  \
from\
( \
select * from \
(\
        with plasma_exchange_hosp_icd_procedure as\
        (\
        select cohort.hadm_id, \
        'plasma_exchange_hosp_icd_procedure' as event, \
        hosp_procedures.icd_code as value,\
        long_title as details,\
        chartdate as event_time,\
        row_number() over(partition by cohort.hadm_id order by chartdate) as rn # earliest event appraes first   \
          \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.procedures_icd` hosp_procedures\
        on cohort.hadm_id = hosp_procedures.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'procedures_icd' table.\
\
        left join `physionet-data.mimic_hosp.d_icd_procedures` codes\
        on hosp_procedures.icd_code = codes.icd_code\
\
        where \
\
(\
       (hosp_procedures.icd_code like '6A550Z3' and hosp_procedures.icd_version = 10) # Pheresis of Plasma, Single\
\
    or (hosp_procedures.icd_code like '6A551Z3' and hosp_procedures.icd_version = 10) # Pheresis of Plasma, Multiple\
\
    or (hosp_procedures.icd_code like '9971' and hosp_procedures.icd_version = 9) # Therapeutic plasmapheresis\
)\
    and chartdate > DATETIME(hep_start) \
        )\
\
        select plasma_exchange_hosp_icd_procedure.*except(rn)\
\
        from plasma_exchange_hosp_icd_procedure\
        where rn = 1 \
)\
\
union all\
\
--*** 3.9.2 inputevents (icu) - Pheresis of Plasma - (itemid , label) = (227532,Plasma Pheresis)\
\
select * from \
(\
\
        with Plasma_Pheresis_icu_inputevents as\
        (\
        select cohort.hadm_id, \
        'Plasma_Pheresis_icu_inputevents' as event, \
        cast(originalamount as string) as value,\
\
        statusdescription as details,  -- had 4 distinct statusdescription s. - FinishedRunning , Paused, ChangeDose/Rate , Stopped\
        \
        starttime as event_time,\
        \
        row_number() over(partition by cohort.hadm_id order by starttime) as rn # earliest event appraes first   \
\
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_icu.inputevents` inputevents \
        on cohort.hadm_id = inputevents.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'inputevents' table.\
\
        left join `physionet-data.mimic_icu.d_items` ditems\
        on inputevents.itemid = ditems.itemid\
\
        where inputevents.itemid in (227532)\
        \
        and starttime > DATETIME(hep_start) \
        )\
\
        select Plasma_Pheresis_icu_inputevents.*except(rn)\
\
        from Plasma_Pheresis_icu_inputevents\
        where rn = 1 \
)\
\
union all\
\
--*** 3.9.3 procedureevents (icu) - Pheresis of Plasma - (itemid , label) = (227551 , Plasma Pheresis.) \
\
select * from \
(\
        with Plasma_Pheresis_icu_procedureevents as\
        (\
        select cohort.hadm_id, \
        'Plasma_Pheresis_icu_procedureevents' as event, \
        cast(originalamount as string) as value,\
\
        statusdescription as details,  -- had 4 distinct statusdescription s. - FinishedRunning , Paused, ChangeDose/Rate , Stopped\
        \
        starttime as event_time,\
\
        row_number() over(partition by cohort.hadm_id order by starttime) as rn # earliest event appraes first   \
\
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_icu.procedureevents` procedureevents \
        on cohort.hadm_id = procedureevents.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'inputevents' table.\
\
        left join `physionet-data.mimic_icu.d_items` ditems\
        on procedureevents.itemid = ditems.itemid\
\
        where procedureevents.itemid in (227551)\
        \
        and starttime > DATETIME(hep_start)\
        )\
\
        select Plasma_Pheresis_icu_procedureevents.*except(rn)\
\
        from Plasma_Pheresis_icu_procedureevents\
        where rn = 1  \
)\
\
) icu_and_hosp\
\
)\
\
        select hadm_id, \
        'first_plasma_exchange' as event,\
        value,\
\
        details,\
\
        event_time\
\
        from merge_icu_and_hosp\
        where rn = 1 \
\
\
)\
\
union all\
\
--*** 3.10 inputevents (icu) - Fresh Frozen Plasma - (itemid , label) = (220970,Fresh Frozen Plasma)\
\
select * from \
(\
\
        with Fresh_Frozen_Plasma_icu_inputevents as\
        (\
        select cohort.hadm_id, \
        'Fresh_Frozen_Plasma_icu_inputevents' as event, \
        cast(originalamount as string) as value,\
\
        statusdescription as details,  -- had 4 distinct statusdescription s. - FinishedRunning , Paused, ChangeDose/Rate , Stopped\
        \
        starttime as event_time,\
        \
        row_number() over(partition by cohort.hadm_id order by starttime) as rn # earliest event appraes first   \
\
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_icu.inputevents` inputevents \
        on cohort.hadm_id = inputevents.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'inputevents' table.\
\
        left join `physionet-data.mimic_icu.d_items` ditems\
        on inputevents.itemid = ditems.itemid\
\
        where inputevents.itemid in (220970)\
        \
        and starttime > DATETIME(hep_start) \
        )\
\
        select hadm_id, \
        'First_Fresh_Frozen_Plasma_icu_inputevents' as event, \
        value,\
\
        details,  -- had 4 distinct statusdescription s. - FinishedRunning , Paused, ChangeDose/Rate , Stopped\
        \
        event_time,\
\
        from Fresh_Frozen_Plasma_icu_inputevents\
        where rn = 1 # first other anticoagulant administration\
)\
\
--*** 3.11 'Thrombo' related procedures\
\
union all\
\
--*** 3.11.1 hosp (icd_procedures) - Introduse / Infusion thrombolytic agent - (icd_code, icd_version, long_title) = codes started with (3E03|3E04|3E05|3E06|3E07|3E08) , (3604, 9 ,Intracoronary artery thrombolytic infusion) , (9910, 9 ,Injection or infusion of thrombolytic agent)\
\
\
-- why? Thrombolytic agents, also known as fibrinolytics, are medications that work by promoting the breakdown of blood clots (thrombolysis).\
\
select * from \
(     \
        with Introduction_thrombolytic_procedure as\
        (\
        select cohort.hadm_id, \
        'Introduction_thrombolytic_procedure' as event, \
        hosp_procedures.icd_code as value,\
        long_title as details,\
        chartdate as event_time,\
        row_number() over(partition by cohort.hadm_id order by chartdate) as rn\
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.procedures_icd` hosp_procedures\
        on cohort.hadm_id = hosp_procedures.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'procedures_icd' table.\
\
        left join `physionet-data.mimic_hosp.d_icd_procedures` codes\
        on hosp_procedures.icd_code = codes.icd_code\
\
        where \
        \
        (\
        \
        (REGEXP_CONTAINS(hosp_procedures.icd_code , '^(3E03|3E04|3E05|3E06|3E07|3E08)') and hosp_procedures.icd_version = 10 and lower(long_title) like '%thrombolytic%') or\
\
        (hosp_procedures.icd_code='3604' and hosp_procedures.icd_version = 9) or -- Intracoronary artery thrombolytic infusion\
          \
        (hosp_procedures.icd_code='9910' and hosp_procedures.icd_version = 9) -- Injection or infusion of thrombolytic agent\
        )\
        \
        and chartdate > DATETIME(hep_start) \
        )\
\
        select hadm_id, \
        'first_Introduction_thrombolytic_procedure' as event,\
        value,\
\
        details,\
\
        event_time\
\
        from Introduction_thrombolytic_procedure\
        where rn = 1 \
\
\
)\
\
union all\
\
--*** 3.11.2 hosp (icd_procedures) - Infuse_Prothrombin_complex - (icd_code, icd_version, long_title) = (30280B1, 10 ,Transfusion of Nonautologous 4-Factor Prothrombin Complex Concentrate into Vein, Open Approach) , (30283B1, 10 ,Transfusion of Nonautologous 4-Factor Prothrombin Complex Concentrate into Vein, Percutaneous Approach) , (0096, 9 ,Infusion of 4-Factor Prothrombin Complex Concentrate)\
\
-- why?\
-- Prothrombin complex concentrate (PCC) is administered for several therapeutic purposes related to bleeding disorders or coagulopathies. \
-- Management of Acute Bleeding\
-- Reversal of Direct Oral Anticoagulants (DOACs)\
-- Reversal of Vitamin K Antagonists (VKAs)\
\
select * from \
(     \
        with Infuse_Prothrombin_complex_hosp_icd_procedure as\
        (\
        select cohort.hadm_id, \
        'Infuse_Prothrombin_complex_hosp_icd_procedure' as event, \
        hosp_procedures.icd_code as value,\
        long_title as details,\
        chartdate as event_time,\
        row_number() over(partition by cohort.hadm_id order by chartdate) as rn\
        \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.procedures_icd` hosp_procedures\
        on cohort.hadm_id = hosp_procedures.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'procedures_icd' table.\
\
        left join `physionet-data.mimic_hosp.d_icd_procedures` codes\
        on hosp_procedures.icd_code = codes.icd_code\
\
        where \
    (\
        (hosp_procedures.icd_code='30280B1' and hosp_procedures.icd_version = 10) -- Transfusion of Nonautologous 4-Factor Prothrombin Complex Concentrate into Vein, Open Approach\
     or (hosp_procedures.icd_code='30283B1' and hosp_procedures.icd_version = 10) -- Transfusion of Nonautologous 4-Factor Prothrombin Complex Concentrate into Vein, Percutaneous Approach\
           \
     or (hosp_procedures.icd_code='0096' and hosp_procedures.icd_version = 9) -- Infusion of 4-Factor Prothrombin Complex Concentrate\
    )\
\
    and chartdate > DATETIME(hep_start) \
        \
        )\
\
        select hadm_id, \
        'first_Infuse_Prothrombin_complex_procedure' as event,\
        value,\
\
        details,\
\
        event_time\
\
        from Infuse_Prothrombin_complex_hosp_icd_procedure\
        where rn = 1 \
\
)\
\
--*** 3.11.3 hosp (icd_procedures) - Infusion thrombolytic agent - (icd_code, icd_version, long_title) = (3604, 9 ,Intracoronary artery thrombolytic infusion) , (9910, 9 ,Injection or infusion of thrombolytic agent)\
\
--*** 3.11.4 no relevant procedures were found in 'icu.procedureevents'.\
\
--*** 3.12\
\
union all\
\
--*** 3.12.1 hosp (icd_procedures) - Transfusion of Platelets / Plasma into veins / arteries / circulatory system \
\
select * from \
(\
        with transfer_other_blood_products_RedBloodCells_WholeBlood_PlasmaCryoprecipitate as\
        (\
        select cohort.hadm_id, \
        'transfer_other_blood_products_RedBloodCells_WholeBlood_PlasmaCryoprecipitate' as event, \
        hosp_procedures.icd_code as value,\
        long_title as details,\
        chartdate as event_time,\
\
        row_number() over(\
          partition by cohort.hadm_id\
          order by chartdate) as rn # earliest event appraes first    \
          \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.procedures_icd` hosp_procedures\
        on cohort.hadm_id = hosp_procedures.hadm_id -- we can directly join by hadm_id, as there is no 'null' hadm_id records in this 'procedures_icd' table.\
\
        left join `physionet-data.mimic_hosp.d_icd_procedures` codes\
        on hosp_procedures.icd_code = codes.icd_code\
\
        where \
(      \
       (hosp_procedures.icd_code like '3023%' and hosp_procedures.icd_version = 10 and lower(long_title) not like '%globulin%') \
       -- unider 2.8.3, 'like ''%globulin%'' were already considered.\
 \
    or (hosp_procedures.icd_code like '3024%' and hosp_procedures.icd_version = 10 and lower(long_title) not like '%globulin%')\
\
    or (hosp_procedures.icd_code like '3025%' and hosp_procedures.icd_version = 10 and lower(long_title) not like '%globulin%')\
    or (hosp_procedures.icd_code like '3026%' and hosp_procedures.icd_version = 10 and lower(long_title) not like '%globulin%')\
\
    or (hosp_procedures.icd_code like '3027%' and hosp_procedures.icd_version = 10 and lower(long_title) not like '%globulin%')\
\
-- returned only below icd_codes as 'details' to the current cohort\
\
-- Transfusion of Nonautologous Red Blood Cells into Peripheral Vein, Percutaneous Approach\
-- Transfusion of Nonautologous Whole Blood into Central Vein, Percutaneous Approach\
-- Transfusion of Nonautologous Plasma Cryoprecipitate into Peripheral Vein, Percutaneous Approach\
\
)\
    and chartdate > DATETIME(hep_start) \
)\
\
        select hadm_id, \
        'First_Transfer_other_blood_products_RedBloodCells_WholeBlood_PlasmaCryoprecipitate' as event,\
        value,\
\
        details,\
\
        event_time\
\
        from transfer_other_blood_products_RedBloodCells_WholeBlood_PlasmaCryoprecipitate\
        where rn = 1 \
\
)\
\
#---------------------------------------------------------------\
\
--4. *** Diagnoses (ICD diagnose codes) *** \
\
--*** 4.1 mimic_hosp.d_icd_diagnoses - skin necrosis  ***\
-- couldn't find an appropriate ICD_code. But just searched for with string combination - necrosis / erythema / purpura \
-- The appearance of erythema is followed by purpura and hemorrhage with subsequent necrosis (from UpToDate)\
\
union all\
\
select * from \
(     \
        select cohort.hadm_id as hadm_id,\
        'icd_diagnose_skin_necrosis' as event,\
        diagnoses.icd_code as value,\
        icd.long_title as details,     \
\
        datetime(dischtime) as event_time  \
          \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.diagnoses_icd` diagnoses \
        on cohort.hadm_id = diagnoses.hadm_id\
\
        left join `physionet-data.mimic_hosp.d_icd_diagnoses` icd\
        on diagnoses.icd_code = icd.icd_code\
\
        where\
\
      --  (REGEXP_CONTAINS(lower(icd.long_title), '^(necrosis|purpura)')) --'^(necrosis|erythema|purpura)')\
\
      --  (REGEXP_CONTAINS(lower(icd.long_title), '(necrosis|purpura)')) --'^(necrosis|erythema|purpura)')\
\
-- below icd_codes were selectd only based on the current hep cohort.\
\
        (icd.icd_code = '28731' and icd.icd_version = 9) or  -- Immune thrombocytopenic purpura\
\
        (icd.icd_code = 'D693' and icd.icd_version = 10) or  -- Immune thrombocytopenic purpura\
\
        (icd.icd_code = 'D6951' and icd.icd_version = 10) or  -- Posttransfusion purpura\
\
        (icd.icd_code like 'T34%' and icd.icd_version = 10) or  --  Frostbite (injury to the skin and underlying tissues due to freezing) with tissue necrosis (death of tissue)\
\
        (icd.icd_code like 'T875%' and icd.icd_version = 10)  --  Necrosis of amputation stump\
\
)\
\
union all\
\
--*** 4.2 mimic_hosp.d_icd_diagnoses - limb_gangrene  ***\
\
select * from \
(     \
        select cohort.hadm_id as hadm_id,\
        'icd_diagnose_limb_gangrene' as event,\
        diagnoses.icd_code as value,\
        icd.long_title as details,     \
\
        datetime(dischtime) as event_time  \
          \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.diagnoses_icd` diagnoses \
        on cohort.hadm_id = diagnoses.hadm_id\
\
        left join `physionet-data.mimic_hosp.d_icd_diagnoses` icd\
        on diagnoses.icd_code = icd.icd_code\
\
        where\
\
        (diagnoses.icd_code = '7854' and diagnoses.icd_version = 9)  # Gangrene\
     or (diagnoses.icd_code = 'I96' and diagnoses.icd_version = 10)  # Gangrene, not elsewhere classified\
\
)\
\
union all\
\
--*** 4.3 mimic_hosp.d_icd_diagnoses - bleeding / hemorrhage ***\
\
--*** 4.3.1 mimic_hosp.d_icd_diagnoses - bleeding  ***\
\
\
select * from \
(     \
        select cohort.hadm_id as hadm_id,\
        'icd_diagnose_bleeding' as event,\
        diagnoses.icd_code as value,\
        icd.long_title as details,     \
\
        datetime(dischtime) as event_time  \
          \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.diagnoses_icd` diagnoses \
        on cohort.hadm_id = diagnoses.hadm_id\
\
        left join `physionet-data.mimic_hosp.d_icd_diagnoses` icd\
        on diagnoses.icd_code = icd.icd_code\
\
        where\
        (\
                (\
                        \
                (\
                --diagnoses.icd_code = 'D65' or -- Disseminated intravascular coagulation (non-overt)\
                diagnoses.icd_code like 'D683%' or -- Hemorrhagic disorder due to circulating anticoagulants\
                diagnoses.icd_code = 'K920' or -- Hematemesis\
                diagnoses.icd_code = 'K921' or -- Melena\
                diagnoses.icd_code = 'K922' -- Gastrointestinal hemorrhage, unspecified\
                )\
                and diagnoses.icd_version = 10\
                )\
\
                or\
\
                (\
                (\
                --diagnoses.icd_code = '2866' or -- Defibrination syndrome (relevant to ICD-10 code D65)\
                diagnoses.icd_code = '2865%' or \
                --2865 - Hemorrhagic disorder due to intrinsic circulating anticoagulants\
                --28659 - Other hemorrhagic disorder due to intrinsic circulating anticoagulants, antibodies, or inhibitors\
\
                diagnoses.icd_code = '4590' -- Hemorrhage, unspecified\
                )\
                and diagnoses.icd_version = 9\
                )\
        )\
\
--lower(long_title) like '%nerv%' and\
/*\
(lower(long_title) like '%hemorrhage%' or lower(long_title) like '%bleed%') and\
\
lower(long_title) not like '%without bleeding%' and\
lower(long_title) not like '%without mention of bleeding%' and\
\
lower(long_title) not like '%without hemorrhage%' and\
lower(long_title) not like '%without mention of hemorrhage%' and\
\
lower(long_title) not like '%chronic%'\
\
/*\
        (diagnoses.icd_code = 'K922' and diagnoses.icd_version = 10) -- Gastrointestinal hemorrhage, unspecified\
\
        or\
\
        (diagnoses.icd_code = '5789' and diagnoses.icd_version = 9) -- Hemorrhage of gastrointestinal tract, unspecified\
\
        or\
\
        (diagnoses.icd_code = '5789' and diagnoses.icd_version = 10) -- Hemorrhage of gastrointestinal tract, unspecified\
\
        or\
\
        (diagnoses.icd_code = '5789' and diagnoses.icd_version = 9) -- Hemorrhage of gastrointestinal tract, unspecified\
 \
\
 -- R58  Hemorrhage, not elsewhere classified\
/*   \
     --  bleeding\
(\
    (\
        lower(long_title) like '%bleeding%' and --there are ranges of icd_codes for 'bleeding', and not sure what kind of bleeding that may occur in HIT.\
        lower(long_title) not like '%without bleeding%' and\
        lower(long_title) not like '%without mention of bleeding%' and\
        lower(long_title) not like '%chronic%'       \
    )\
\
and\
\
    (\
        (REGEXP_CONTAINS(diagnoses.icd_code, '^(G|I|K)') and diagnoses.icd_version = 10)\
 --(REGEXP_CONTAINS(diagnoses.icd_code, '^(I|K|3E05|3E06|3E07|3E08)') and diagnoses.icd_version = 10)\
\
-- ICD-10 code - https://www.icd10data.com/ICD10CM/Codes\
-- G - Diseases of the nervous system\
-- I - Diseases of the circulatory system\
-- K - Diseases of the digestive system\
\
        or\
\
        (REGEXP_CONTAINS(diagnoses.icd_code, '^(3|4|5)') and diagnoses.icd_version = 9) --^456|^53021$\
\
-- ICD-9 codes - http://www.icd9data.com/2015/Volume1/default.htm\
-- 3 - Diseases Of The Nervous System And Sense Organs\
-- 3 / 4 - Diseases Of The Circulatory System\
-- 5 - Diseases Of The Digestive System\
\
    )\
)\
\
or\
\
-- hemmorage\
(    \
   (\
        lower(long_title) like '%hemorrhage%' and --there are ranges of icd_codes for 'bleeding', and not sure what kind of bleeding that may occur in HIT.\
        lower(long_title) not like '%without hemorrhage%' and\
        lower(long_title) not like '%without mention of hemorrhage%' and\
        lower(long_title) not like '%chronic%'\
    )\
\
and\
\
    (\
       (REGEXP_CONTAINS(diagnoses.icd_code, '^(G|I|K)') and diagnoses.icd_version = 10)\
 -- (REGEXP_CONTAINS(diagnoses.icd_code, '^(I|K|3E05|3E06|3E07|3E08)') and diagnoses.icd_version = 10)\
\
-- I - Diseases of the circulatory system\
-- K - Diseases of the digestive system\
\
        or\
\
        (REGEXP_CONTAINS(diagnoses.icd_code, '^(3|4|5)') and diagnoses.icd_version = 9)\
\
    )\
)  \
*/\
)    \
\
\
union all\
\
--*** 4.3.2 mimic_hosp.d_icd_diagnoses - Disseminated intravascular coagulation [defibrination syndrome]  ***\
\
\
select * from \
(     \
        select cohort.hadm_id as hadm_id,\
        'icd_diagnose_Disseminated_intravascular_coagulation_defibrination_syndrome' as event,\
        diagnoses.icd_code as value,\
        icd.long_title as details,     \
\
        datetime(dischtime) as event_time  \
          \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.diagnoses_icd` diagnoses \
        on cohort.hadm_id = diagnoses.hadm_id\
\
        left join `physionet-data.mimic_hosp.d_icd_diagnoses` icd\
        on diagnoses.icd_code = icd.icd_code\
\
        where\
                (diagnoses.icd_code = 'D65' and diagnoses.icd_version = 10) or -- Disseminated intravascular coagulation (non-overt)\
                (diagnoses.icd_code = '2866' and diagnoses.icd_version = 9)  -- Defibrination syndrome (relevant to ICD-10 code D65)\
\
\
) \
\
\
-- REGEXP_CONTAINS(diagnoses.icd_code, '^a|b$|^c$')\
-- pattern ^a|b$|^c$ would match strings that start with 'a', strings that end with 'b', or strings that are exactly 'c'. However, it doesn't enforce the condition that the string must start with 'a', end with 'b', and be exactly 'c'.\
\
--*** 4.3.3 mimic_hosp.d_icd_diagnoses - hemorrhage  ***\
\
union all\
\
--*** 4.4 mimic_hosp.d_icd_diagnoses - anaphylaxis  ***\
\
select * from \
(     \
        select cohort.hadm_id as hadm_id,\
        'icd_diagnose_other_surgical_and_medical_care_complications' as event,\
        diagnoses.icd_code as value,\
        icd.long_title as details,     \
\
        datetime(dischtime) as event_time  \
          \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.diagnoses_icd` diagnoses \
        on cohort.hadm_id = diagnoses.hadm_id\
\
        left join `physionet-data.mimic_hosp.d_icd_diagnoses` icd\
        on diagnoses.icd_code = icd.icd_code\
\
        where\
\
      (diagnoses.icd_code like 'T80%' and diagnoses.icd_version = 10)  # Complications following infusion, transfusion and therapeutic injection \
\
)\
\
union all\
\
--*** 4.5 mimic_hosp.d_icd_diagnoses - myocardial infarction  ***\
\
select * from \
(     \
        select cohort.hadm_id as hadm_id,\
        'icd_diagnose_myocardial_infarction' as event,\
        diagnoses.icd_code as value,\
        icd.long_title as details,     \
\
        datetime(dischtime) as event_time  \
          \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.diagnoses_icd` diagnoses \
        on cohort.hadm_id = diagnoses.hadm_id\
\
        left join `physionet-data.mimic_hosp.d_icd_diagnoses` icd\
        on diagnoses.icd_code = icd.icd_code\
\
        where\
\
        (diagnoses.icd_code like '410%' and diagnoses.icd_version = 9)  # Acute myocardial infarction of *\
     or (diagnoses.icd_code like 'I21%' and diagnoses.icd_version = 10)  # Acute myocardial infarction\
     or (diagnoses.icd_code like 'I22%' and diagnoses.icd_version = 10)  # Subsequent ST elevation (STEMI) and non-ST elevation (NSTEMI) myocardial infarction I22-\
     or (diagnoses.icd_code like 'I23%' and diagnoses.icd_version = 10)  #  Certain current complications following ST elevation (STEMI) and non-ST elevation (NSTEMI) myocardial infarction (within the 28 day period)\
     or (diagnoses.icd_code like 'I24%' and diagnoses.icd_version = 10)  #  Other acute ischemic heart diseases\
\
-- icd_code - version - long_title\
-- 412 - 9 - Old myocardial infarction\
-- I252 - 10 - Old myocardial infarction\
\
)\
\
\
union all\
\
--*** 4.6 mimic_hosp.d_icd_diagnoses - kideny infarction  ***\
\
select * from \
(     \
        select cohort.hadm_id as hadm_id,\
        'icd_diagnose_kidney_infarction' as event,\
        diagnoses.icd_code as value,\
        icd.long_title as details,     \
\
        datetime(dischtime) as event_time  \
          \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.diagnoses_icd` diagnoses \
        on cohort.hadm_id = diagnoses.hadm_id\
\
        left join `physionet-data.mimic_hosp.d_icd_diagnoses` icd\
        on diagnoses.icd_code = icd.icd_code\
\
        where\
\
        (diagnoses.icd_code like '59381' and diagnoses.icd_version = 9)  # Vascular disorders of kidney\
     or (diagnoses.icd_code like '5849' and diagnoses.icd_version = 9)  # Vascular disorders of kidney\
     or (diagnoses.icd_code like 'N17%' and diagnoses.icd_version = 10) # Acute kidney failure.*\
     or (diagnoses.icd_code like 'N19%' and diagnoses.icd_version = 10) # Unspecified kidney failure.*\
     or (diagnoses.icd_code like 'N280' and diagnoses.icd_version = 10) # Acute kidney failure, unspecified\
\
)\
\
union all\
\
--*** 4.7 mimic_hosp.d_icd_diagnoses - spleen infarction  ***\
\
select * from \
(     \
        select cohort.hadm_id as hadm_id,\
        'icd_diagnose_spleen_infarction' as event,\
        diagnoses.icd_code as value,\
        icd.long_title as details,     \
\
        datetime(dischtime) as event_time  \
          \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort # 13415 hadm_ids\
\
        inner join `physionet-data.mimic_hosp.diagnoses_icd` diagnoses \
        on cohort.hadm_id = diagnoses.hadm_id\
\
        left join `physionet-data.mimic_hosp.d_icd_diagnoses` icd\
        on diagnoses.icd_code = icd.icd_code\
\
        where\
        (diagnoses.icd_code like '28959' and diagnoses.icd_version = 9)  # Other diseases of spleen\
     or (diagnoses.icd_code like 'D735' and diagnoses.icd_version = 10)  # Infarction of spleen\
\
)\
\
union all\
\
--*** 4.8 mimic_hosp.d_icd_diagnoses - thrombotic events - Arterial embolism and thrombosis  ***\
\
 \
select * from \
(     \
        select cohort.hadm_id as hadm_id,\
        'icd_diagnose_arterial_embolism_and_thrombosis' as event,\
        diagnoses.icd_code as value,\
        icd.long_title as details,     \
\
        datetime(dischtime) as event_time  \
\
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort\
\
        inner join `physionet-data.mimic_hosp.diagnoses_icd` diagnoses \
        on cohort.hadm_id = diagnoses.hadm_id\
\
        left join `physionet-data.mimic_hosp.d_icd_diagnoses` icd\
        on diagnoses.icd_code = icd.icd_code\
  \
        where\
\
        (diagnoses.icd_code like '444%' and diagnoses.icd_version = 9)  # Arterial embolism and thrombosis *\
     or (diagnoses.icd_code like 'I74%' and diagnoses.icd_version = 10)  # Arterial embolism and thrombosis\
\
)\
\
union all\
\
--*** 4.9 mimic_hosp.d_icd_diagnoses - thrombotic events - Other venous embolism and thrombosis  ***\
\
 \
select * from \
(     \
        select cohort.hadm_id as hadm_id,\
        'icd_diagnose_other_venous_embolism_and_thrombosis' as event,\
        diagnoses.icd_code as value,\
        icd.long_title as details,     \
\
        datetime(dischtime) as event_time  \
\
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort\
\
        inner join `physionet-data.mimic_hosp.diagnoses_icd` diagnoses \
        on cohort.hadm_id = diagnoses.hadm_id\
\
        left join `physionet-data.mimic_hosp.d_icd_diagnoses` icd\
        on diagnoses.icd_code = icd.icd_code\
\
        where\
\
        (diagnoses.icd_code like '453%' and diagnoses.icd_version = 9)  # Other venous embolism and thrombosis	\
     or (diagnoses.icd_code like 'I82%' and diagnoses.icd_version = 10)  # Other venous embolism and thrombosis\
\
     or (diagnoses.icd_code like '452' and diagnoses.icd_version = 9)  # Portal vein thrombosis\
     or (diagnoses.icd_code like 'I81' and diagnoses.icd_version = 10)  # Portal vein thrombosis\
\
        and\
        (lower(long_title) not like '%chronic%' \
        and lower(long_title) not like '%personal%'\
        and lower(long_title) not like '%history%')\
)\
\
union all\
\
\
--*** 4.10 mimic_hosp.d_icd_diagnoses - Pulmonary embolism  ***\
\
select * from \
(     \
        select cohort.hadm_id as hadm_id,\
        'icd_diagnose_pulmonary_embolism' as event,\
        diagnoses.icd_code as value,\
        icd.long_title as details,     \
\
        datetime(dischtime) as event_time  \
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort\
\
        inner join `physionet-data.mimic_hosp.diagnoses_icd` diagnoses\
        on cohort.hadm_id = diagnoses.hadm_id\
\
        left join `physionet-data.mimic_hosp.d_icd_diagnoses` icd\
        on diagnoses.icd_code = icd.icd_code\
\
        where\
\
        (diagnoses.icd_code like '4151%' and diagnoses.icd_version = 9)  # Pulmonary embolism *\
     or (diagnoses.icd_code like 'I26%' and diagnoses.icd_version = 10)  # # Pulmonary embolism\
     and\
        (lower(long_title) not like '%chronic%' \
        and lower(long_title) not like '%personal%'\
        and lower(long_title) not like '%history%')\
)\
\
#---------------------------------------------------------------\
\
--5. *** --5. *** Dermagraphics\
\
-- 5.1 Admission *** \
\
union all\
\
(     \
        select cohort.hadm_id as hadm_id,\
        'admission' as event,\
        '' as value, -- 1/died , 0/survived\
        '' as details,  \
\
        datetime(admittime) as event_time  \
\
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort\
\
)\
\
-- 5.2 Discharge *** \
\
union all\
\
(     \
        select cohort.hadm_id as hadm_id,\
        'discharge' as event,\
        '' as value, -- 1/died , 0/survived\
        '' as details,  \
\
        datetime(cohort.dischtime) as event_time\
\
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort\
\
        left join `physionet-data.mimic_core.admissions` adm\
        on cohort.hadm_id = adm.hadm_id\
\
        where\
\
        adm.hospital_expire_flag != 1\
\
)\
\
-- 5.3 Died *** \
\
union all\
\
(     \
        select cohort.hadm_id as hadm_id,\
        'hospital_expire_flag_1' as event,\
        '1' as value, -- 1/died , 0/survived\
        '' as details,  \
\
        case\
        when deathtime is not null then\
        deathtime \
\
        else adm.dischtime -- some patient died, but no deathtime was recirded. ex - hadm_id - 20235620, 22823286, 22910121, 22216376\
\
        end as event_time  \
\
        from `physionet-data-313305.HIT_trajectories.Hep_cohort_V7` cohort\
\
        left join `physionet-data.mimic_core.admissions` adm\
        on cohort.hadm_id = adm.hadm_id\
\
        where\
\
        adm.hospital_expire_flag = 1\
\
)\
)\
\
#---------------------------------------------------------------\
--stats\
-------\
-- longest traces - (hadm_id - 23424956 - length - 666) ,  (hadm_id - 23821411 - length - 651) , (hadm_id - 29429159 - length - 651)\
\
-- shortest traces - (hadm_id - 26894611 - length - 2) ,  (hadm_id - 20538078 - length - 2) , (hadm_id - 25430709 - length - 2)\
\
-- 44 distinct event (without conacatanating 'status' column)\
-- 55 distinct event (after conacatanating 'status' column)\
\
-- below tests are repeating within hadm_id, are not 'first' or 'icd_diagnose'.\
\
/*\
'd_dimer_hosp',\
'fibrinogen_hosp',\
'HIT_Ab_test',\
'ImmunoglobulinG_antibodies',\
'last_heparin_dose',\
'Neutrophil_hosp',\
'hospital_expire_flag_1',\
'Platelet_count_hosp',\
'Antithrombin_hosp',\
'Thrombin_hosp',\
'PT_hosp',\
'Monocytes_hosp',\
'Platelet_Smear_hosp',\
*/\
\
/*\
select hadm_id, count(*) as c1 from all_union\
group by hadm_id\
order by c1 desc\
*/\
\
select * from all_union\
\
--where event in ('hospital_expire_flag_1')\
\
--order by value\
--and hadm_id = 25265899\
\
--and hadm_id = 21139779\
\
/*\
\
select * from\
(\
(select * from all_union\
where event in ('first_IVIG_inputevents')) icu\
\
left join\
\
(select * from all_union\
where event in ('first_IVIG_emar')) hosp\
\
on icu.hadm_id = hosp.hadm_id\
\
)\
\
where icu.event_time < hosp.event_time\
\
*/}