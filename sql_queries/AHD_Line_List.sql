WITH FollowUp AS (select follow_up.encounter_id,
                         follow_up.client_id                 AS PatientId,
                         follow_up_status,
                         follow_up_date_followup_            AS follow_up_date,
                         art_antiretroviral_start_date       AS art_start_date,
                         date_started_on_tuberculosis_prophy AS inhprophylaxis_started_date,
                         date_completed_tuberculosis_prophyl AS InhprophylaxisCompletedDate,
                         tb_prophylaxis_type                AS TB_ProphylaxisType,
                         tpt_dispensed_dose_in_days_alternat AS TPT_DoseDaysNumberALT, -- ???
                         tpt_side_effects                    AS TPT_SideEffect,
                         diagnostic_test                     AS DiagnosticTest,
                         tb_diagnostic_test_result           AS DiagnosticTestResult,
                         lf_lam_result                       AS LF_LAM_result,
                         gene_xpert_result                   AS Gene_Xpert_result,
                         tuberculosis_drug_treatment_start_d AS activetbtreatmentStartDate,
                         tpt_dispensed_dose_in_days_inh_     AS TPT_DoseDaysNumberINH,
                         was_the_patient_screened_for_tuberc AS tb_screened,
                         tb_screening_date                   AS tb_screening,
                         Adherence                           AS TPT_Adherance,
                         date_discontinued_tuberculosis_prop AS inhprophylaxisdiscontinuedDate,
                         date_active_tbrx_completed          AS ActiveTBTreatmentCompletedDate,
                         date_active_tbrx_dc                 AS activetbtreatmentDisContinuedDate,
                         cervical_cancer_screening_status    AS CCS_ScreenDoneYes,
                         date_of_reported_hiv_viral_load     AS viral_load_sent_date,
                         date_viral_load_results_received    AS viral_load_perform_date,
                         viral_load_test_status,
                         hiv_viral_load                      AS viral_load_count,
                         viral_load_test_indication,
                         treatment_end_date,
                         sex,
                         weight_text_                        AS Weight,
                         age,
                         uuid,
                         height,
                         date_of_event                       AS date_hiv_confirmed,
                         current_who_hiv_stage,
                         cd4_count,
                         antiretroviral_art_dispensed_dose_i AS art_dose_days,
                         regimen,
                         adherence,
                         pregnancy_status,
                         method_of_family_planning,
                         crag,
                         cotrimoxazole_prophylaxis_start_dat,
                         cotrimoxazole_prophylaxis_stop_date,
                         current_functional_status,
                         patient_diagnosed_with_active_tuber,
                         fluconazole_start_date              AS Fluconazole_Start_Date,
                         weight_for_age_status               AS NSLessthanFive,
                         nutritional_status_of_older_child_a AS NSAdolescent,
                         nutritional_status_of_adult         AS ns_adult,
                         no_opportunistic_illness            AS No_OI,
                         herpes_zoster                       AS Zoster,
                         bacterial_pneumonia                 AS Bacterial_Pneumonia,
                         extra_pulmonary_tuberculosis_tb     AS Extra_Pulmonary_TB,
                         candidiasis_of_the_esophagus        AS Oesophageal_Candidiasis,
                         candidiasis_vaginal                 AS Vaginal_Candidiasis,
                         mouth_ulcer                         AS Mouth_Ulcer,
                         diarrhea_chronic                    AS Chronic_Diarrhea,
                         acute_diarrhea                      AS Acute_Diarrhea,
                         toxoplasmosis                       AS CNS_Toxoplasmosis,
                         meningitis_cryptococcal             AS Cryptococcal_Meningitis,
                         kaposi_sarcoma_oral                 AS Kaposi_Sarcoma,
                         suspected_cervical_cancer           AS Cervical_Cancer,
                         pulmonary_tuberculosis_tb           AS Pulmonary_TB,
                         candidiasis_oral                    AS Oral_Candidiasis,
                         pneumocystis_carinii_pneumonia_pcp  AS Pneumocystis_Pneumonia,
                         malignant_lymphoma_nonhodgkins      AS NonHodgkins_Lymphoma,
                         female_genital_ulcer_disease        AS Genital_Ulcer,
                         other_opportunistic_illnesses       AS OI_Other,
                         fluconazole_stop_date as Fluconazole_End_Date,
                         nutritional_screening_result,
                         dsd_category,
                         other_medications_med_1 Med1,
                         other_medications_med2 Med2
                  FROM mamba_flat_encounter_follow_up follow_up
                           JOIN mamba_flat_encounter_follow_up_1 follow_up_1
                                ON follow_up.encounter_id = follow_up_1.encounter_id
                           JOIN mamba_flat_encounter_follow_up_2 follow_up_2
                                ON follow_up.encounter_id = follow_up_2.encounter_id
                           JOIN mamba_flat_encounter_follow_up_3 follow_up_3
                                ON follow_up.encounter_id = follow_up_3.encounter_id
                      JOIN mamba_flat_encounter_follow_up_4 follow_up_4
                                ON follow_up.encounter_id = follow_up_4.encounter_id
                           JOIN mamba_dim_client_art_follow_up dim_client ON follow_up.client_id = dim_client.client_id
                           JOIN mamba_dim_person person on person.person_id = follow_up.client_id),
     tpt_start AS (SELECT patientid, MAX(inhprophylaxis_started_date) AS inhprophylaxis_started_date
                   FROM FollowUp
                   WHERE inhprophylaxis_started_date IS NOT NULL
                   GROUP BY patientid),
     tpt_completed AS (SELECT patientid, Max(InhprophylaxisCompletedDate) AS InhprophylaxisCompletedDate
                       FROM FollowUp
                       WHERE InhprophylaxisCompletedDate IS NOT NULL
                       GROUP BY patientid),
     tpt_type AS (SELECT patientid, Max(TB_ProphylaxisType) AS TB_ProphylaxisType
                  FROM FollowUp
                  WHERE TB_ProphylaxisType IS NOT NULL
                  GROUP BY patientid),
     tpt_dose_ALT AS (SELECT patientid, Max(TPT_DoseDaysNumberALT) AS TPT_DoseDaysNumberALT
                      FROM FollowUp
                      WHERE TPT_DoseDaysNumberALT IS NOT NULL
                      GROUP BY patientid),

     tpt_dose_INH AS (SELECT patientid,
                             Max(TPT_DoseDaysNumberINH) AS TPT_DoseDaysNumberINH
                      FROM FollowUp
                      WHERE TPT_DoseDaysNumberINH IS NOT NULL

                      GROUP BY patientid),
     tpt_side_effect AS (SELECT patientid, Max(TPT_SideEffect) AS TPT_SideEffect
                         FROM FollowUp
                         WHERE TPT_SideEffect IS NOT NULL
                         GROUP BY patientid),
     tb_diagnostic_test AS (SELECT patientid, Max(DiagnosticTest) AS TB_Diagnostic_Test
                            FROM FollowUp
                            WHERE DiagnosticTest IS NOT NULL
                            GROUP BY patientid),
     tb_diagnostic_result AS (SELECT patientid, Max(DiagnosticTestResult) AS TB_Diagnostic_Result
                              FROM FollowUp
                              WHERE DiagnosticTestResult IS NOT NULL
                              GROUP BY patientid),
     tb_LF_LAM_result AS (SELECT patientid, Max(LF_LAM_result) AS LF_LAM_result
                          FROM FollowUp
                          WHERE LF_LAM_result IS NOT NULL
                          GROUP BY patientid),
     tb_Gene_Xpert_result AS (SELECT patientid, Max(Gene_Xpert_result) AS Gene_Xpert_result
                              FROM FollowUp
                              WHERE Gene_Xpert_result IS NOT NULL
                              GROUP BY patientid),
     tpt_screened AS (SELECT patientid, Max(tb_screened) AS TB_Screened
                      FROM FollowUp
                      WHERE tb_screened IS NOT NULL
                      GROUP BY patientid),
     tpt_screening AS (SELECT patientid, Max(tb_screening) AS TB_Screening_Result
                       FROM FollowUp
                       WHERE tb_screening IS NOT NULL
                       GROUP BY patientid),
     tpt_adherence AS (SELECT patientid, Max(TPT_Adherance) AS TPT_Adherence
                       FROM FollowUp
                       WHERE TPT_Adherance IS NOT NULL
                       GROUP BY patientid),
     ActiveTBTreatmentStarted AS (SELECT patientid, Max(activetbtreatmentStartDate) AS ActiveTBTreatmentStartDate
                                  FROM FollowUp
                                  WHERE  activetbtreatmentStartDate IS NOT NULL
                                  GROUP BY patientid),
     TBTreatmentCompleted AS (SELECT patientid, Max(ActiveTBTreatmentCompletedDate) AS ActiveTBTreatmentCompletedDate
                              FROM FollowUp
                              WHERE ActiveTBTreatmentCompletedDate IS NOT NULL
                              GROUP BY patientid),
     TBTreatmentDiscontinued AS (SELECT patientid,
                                        Max(activetbtreatmentDisContinuedDate) AS ActiveTBTreatmentDiscontinuedDate
                                 FROM FollowUp
                                 WHERE
                                    activetbtreatmentDisContinuedDate IS NOT NULL
                                 GROUP BY patientid),
     cca_screened_tmp AS (SELECT DISTINCT patientid, CCS_ScreenDoneYes AS CCA_Screened,
                                      ROW_NUMBER() OVER (PARTITION BY FollowUp.PatientId ORDER BY follow_up_date DESC, FollowUp.encounter_id DESC) AS row_num
                      FROM FollowUp
                      where CCS_ScreenDoneYes IS NOT NULL),
    cca_screened AS ( select * from cca_screened_tmp where row_num=1),
-- VL Sent Date
     tmp_vl_sent_date AS (select PatientId,
                                 encounter_id,
                                 viral_load_sent_date,
                                 ROW_NUMBER() OVER (PARTITION BY PatientId ORDER BY viral_load_sent_date DESC, encounter_id DESC) AS row_num
                          from FollowUp
                          where follow_up_date <= REPORT_END_DATE),
     vl_sent_date AS (select * from tmp_vl_sent_date where row_num = 1),
-- VL Performed date

     vl_performed_date_tmp AS (SELECT FollowUp.encounter_id,
                                      FollowUp.PatientId,
                                      FollowUp.viral_load_perform_date,
                                      FollowUp.viral_load_test_status,
                                     FollowUp.viral_load_count             AS viral_load_count,
                                      CASE
                                          WHEN vl_sent_date.viral_load_sent_date IS NOT NULL
                                              THEN vl_sent_date.viral_load_sent_date
                                          WHEN FollowUp.viral_load_perform_date IS NOT NULL
                                              THEN FollowUp.viral_load_perform_date
                                          ELSE NULL END                                                                                                     AS viral_load_ref_date,
                                      ROW_NUMBER() OVER (PARTITION BY FollowUp.PatientId ORDER BY viral_load_perform_date DESC, FollowUp.encounter_id DESC) AS row_num
                               FROM FollowUp
                                        LEFT JOIN vl_sent_date ON FollowUp.PatientId = vl_sent_date.PatientId
                               WHERE follow_up_status IS NOT NULL
                                 AND art_start_date IS NOT NULL
                                 AND viral_load_perform_date <= REPORT_END_DATE
     ),
     vl_performed_date AS (select * from vl_performed_date_tmp where row_num = 1),
     tx_curr_all AS (SELECT PatientId,
                            follow_up_date                                                                             AS FollowupDate,
                            encounter_id,
                            ROW_NUMBER() OVER (PARTITION BY PatientId ORDER BY follow_up_date DESC, encounter_id DESC) AS row_num
                     FROM FollowUp
                     WHERE follow_up_status IS NOT NULL
                       AND art_start_date IS NOT NULL
                       AND follow_up_date <= REPORT_END_DATE
                       AND treatment_end_date >= REPORT_END_DATE
                       AND follow_up_status in ('Alive', 'Restart medication')
     ),
     tx_curr AS (select * from tx_curr_all where row_num = 1)
SELECT DISTINCT f_case.sex                                         as Sex,
                f_case.Weight                                      as Weight,
                f_case.Age,
                f_case.uuid                                               as PatientGUID,
                f_case.height                                             as Height,
                f_case.date_hiv_confirmed,
                f_case.art_start_date,
                FLOOR(DATEDIFF(REPORT_END_DATE,f_case.art_start_date)/30.4375) AS MonthsOnART,
                f_case.follow_up_date                              as FollowUpDate,
                f_case.current_who_hiv_stage                              as WHO,
                CASE
                    WHEN f_case.cd4_count REGEXP '^[0-9]+(\.[0-9]+)?$' > 0 THEN CAST(f_case.cd4_count AS DECIMAL(12, 2))
                    ELSE NULL END                                  AS CD4,
                f_case.art_dose_days                                      AS ARTDoseDays,
                f_case.regimen                                            as ARVRegimen,
                f_case.follow_up_status,
                tpt_adherence.tpt_adherence                        AS AdheranceLevel,
                f_case.pregnancy_status                                   as IsPregnant,
                f_case.method_of_family_planning                          as FpMethodUsed,
                f_case.crag                                               as CrAg,
                COALESCE(
                        f_case.ns_adult,
                        f_case.NSAdolescent,
                        f_case.NSLessthanFive
                )                                                  AS NutritionalStatus,
                f_case.current_functional_status                          AS FunctionalStatus,
                f_case.No_OI,
                f_case.Zoster,
                f_case.Bacterial_Pneumonia,
                f_case.Extra_Pulmonary_TB,
                f_case.Oesophageal_Candidiasis,
                f_case.Vaginal_Candidiasis,
                f_case.Mouth_Ulcer,
                f_case.Chronic_Diarrhea,
                f_case.Acute_Diarrhea,
                f_case.CNS_Toxoplasmosis,
                f_case.Cryptococcal_Meningitis,
                f_case.Kaposi_Sarcoma,
                f_case.Cervical_Cancer,
                f_case.Pulmonary_TB,
                f_case.Oral_Candidiasis,
                f_case.Pneumocystis_Pneumonia,
                f_case.NonHodgkins_Lymphoma,
                f_case.Genital_Ulcer,
                f_case.OI_Other,
                f_case.Med1,
                f_case.Med2,
                f_case.cotrimoxazole_prophylaxis_start_dat         as CotrimoxazoleStartDate,
                f_case.cotrimoxazole_prophylaxis_stop_date         as cortimoxazole_stop_date,
                f_case.Fluconazole_Start_Date                      as Fluconazole_Start_Date,
                f_case.Fluconazole_End_Date as Fluconazole_End_Date,
                tpt_type.TB_ProphylaxisType                        AS TPT_Type,
                tpt_start.inhprophylaxis_started_date              as inhprophylaxis_started_date,
                tpt_completed.InhprophylaxisCompletedDate          as InhprophylaxisCompletedDate,
                tpt_dose_ALT.TPT_DoseDaysNumberALT                 as TPT_DoseDaysNumberALT,
                tpt_dose_INH.TPT_DoseDaysNumberINH                 as TPT_DoseDaysNumberINH,
                COALESCE(tpt_dose_INH.TPT_DoseDaysNumberINH,tpt_dose_ALT.TPT_DoseDaysNumberALT) AS TPT_Dispensed_Dose,
                tpt_side_effect.TPT_SideEffect                     as TPT_SideEffect,
                tpt_adherence.TPT_Adherence                        AS TPT_Adherence,
                tpt_screened.TB_Screened                           AS tb_screened,
                tpt_screening.TB_Screening_Result                  AS tb_screening_result,
                tb_diagnostic_result.TB_Diagnostic_Result          AS TB_Diagnostic_Result,
                tb_LF_LAM_result.LF_LAM_result,
                tb_Gene_Xpert_result.Gene_Xpert_result,
                CASE
                    WHEN tb_diagnostic_test.TB_Diagnostic_Test = 'Smear microscopy only' AND tb_diagnostic_result.TB_Diagnostic_Result = 'Positive'
                        THEN 'Positive'
                    WHEN tb_diagnostic_test.TB_Diagnostic_Test = 'Smear microscopy only' AND tb_diagnostic_result.TB_Diagnostic_Result = 'Negative'
                        THEN 'Negative'
                    ELSE '' END                                    AS Smear_Microscopy_Result,
                CASE
                    WHEN tb_diagnostic_test.TB_Diagnostic_Test = 'Additional test other than Gene-Xpert' AND tb_diagnostic_result.TB_Diagnostic_Result = 'Positive'
                        THEN 'Positive'
                    WHEN tb_diagnostic_test.TB_Diagnostic_Test = 'Additional test other than Gene-Xpert' AND tb_diagnostic_result.TB_Diagnostic_Result = 'Negative'
                        THEN 'Negative'
                    ELSE '' END                                    AS Additional_TB_Diagnostic_Test_Result,
                f_case.patient_diagnosed_with_active_tuber                   Active_TB,
                ActiveTBTreatmentStarted.ActiveTBTreatmentStartDate,
                TBTreatmentCompleted.ActiveTBTreatmentCompletedDate,
                TBTreatmentDiscontinued.ActiveTBTreatmentDiscontinuedDate,
                vlperfdate.viral_load_perform_date,
                vlperfdate.viral_load_test_status                  as viral_load_status,
                vlperfdate.viral_load_count,
                vlsentdate.viral_load_sent_date                    as VL_Sent_Date,
                vlperfdate.viral_load_ref_date,
                cca_screened.CCA_Screened                          AS CCA_Screened,
                f_case.dsd_category AS DSD_Category,
                CASE
                    WHEN f_case.age < 5 THEN 'Yes'
                    WHEN f_case.age >= 5 AND f_case.cd4_count IS NOT NULL AND
                         f_case.cd4_count < 200 THEN 'Yes'
                    WHEN f_case.age >= 5 AND f_case.current_who_hiv_stage IS NOT NULL AND
                         (f_case.current_who_hiv_stage = 2 Or f_case.current_who_hiv_stage = 6 Or
                          f_case.current_who_hiv_stage = 7) THEN 'Yes'
                    WHEN (f_case.age >= 5 AND f_case.current_who_hiv_stage IS NOT NULL AND
                          f_case.current_who_hiv_stage = 3) THEN 'Yes'
                    ELSE 'No' END                                  AS AHD,
                f_case.encounter_id                                as Id,
                f_case.PatientId

FROM FollowUp AS f_case
         INNER JOIN tx_curr ON f_case.encounter_id = tx_curr.encounter_id
         LEFT JOIN vl_performed_date AS vlperfdate ON vlperfdate.PatientId = f_case.PatientId
         LEFT JOIN vl_sent_date AS vlsentdate ON vlsentdate.PatientId = f_case.PatientId

         LEFT JOIN tpt_start ON tpt_start.patientid = f_case.PatientId
         LEFT JOIN tpt_completed ON tpt_completed.patientid = f_case.PatientId
         LEFT JOIN tpt_type ON tpt_type.patientid = f_case.PatientId
         LEFT JOIN tpt_dose_ALT ON tpt_dose_ALT.patientid = f_case.PatientId
         LEFT JOIN tpt_dose_INH ON tpt_dose_INH.patientid = f_case.PatientId
         LEFT JOIN tpt_side_effect ON tpt_side_effect.patientid = f_case.PatientId
         LEFT JOIN
     tpt_screened ON tpt_screened.patientid = f_case.PatientId
         LEFT JOIN tpt_screening ON tpt_screening.patientid = f_case.PatientId
         LEFT JOIN tpt_adherence ON tpt_adherence.patientid = f_case.PatientId
         LEFT JOIN tb_diagnostic_result ON tb_diagnostic_result.patientid = f_case.PatientId
         LEFT JOIN tb_diagnostic_test ON tb_diagnostic_test.patientid = f_case.PatientId
         LEFT JOIN tb_LF_LAM_result ON tb_LF_LAM_result.patientid = f_case.PatientId
         LEFT JOIN tb_Gene_Xpert_result ON tb_Gene_Xpert_result.patientid = f_case.PatientId
         LEFT JOIN ActiveTBTreatmentStarted ON ActiveTBTreatmentStarted.patientid = f_case.PatientId
         LEFT JOIN TBTreatmentCompleted ON TBTreatmentCompleted.patientid = f_case.PatientId
         LEFT JOIN TBTreatmentDiscontinued ON TBTreatmentDiscontinued.patientid = f_case.PatientId
         LEFT JOIN cca_screened ON cca_screened.patientid = f_case.PatientId;