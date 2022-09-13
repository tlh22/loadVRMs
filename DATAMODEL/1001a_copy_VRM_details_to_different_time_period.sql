/***
 * When data is entered into wrong time period, need to move to correct time period
 ***/

-- for VRMs
DO
$do$
DECLARE
    relevant_restriction_in_survey RECORD;
    clone_restriction_id uuid;
    current_done BOOLEAN := false;
	curr_survey_id INTEGER := 209;
	new_survey_id INTEGER := 109;
BEGIN


    FOR relevant_restriction_in_survey IN
        SELECT DISTINCT RiS."SurveyID", RiS."GeometryID", RiS."DemandSurveyDateTime", RiS."Enumerator", RiS."Done", RiS."SuspensionReference", RiS."SuspensionReason", RiS."SuspensionLength", RiS."NrBaysSuspended", RiS."SuspensionNotes", RiS."Photos_01", RiS."Photos_02", RiS."Photos_03"
            FROM "demand_WGR"."RestrictionsInSurveys" RiS, mhtc_operations."Supply" r, mhtc_operations."SurveyAreas" a
        WHERE RiS."GeometryID" = r."GeometryID"
        AND r."SurveyArea" = a.name
        AND r."SurveyArea" IN ('7S-WGR')
        AND RiS."Done" IS true
        AND RiS."SurveyID" = curr_survey_id
		--AND RiS."DemandSurveyDateTime" < '2022-06-29'::date
    LOOP

        RAISE NOTICE '*****--- Processing % moving from (%) to (%)', relevant_restriction_in_survey."GeometryID", curr_survey_id, new_survey_id;

        -- check to see if the restriction already has a value
        SELECT "Done"
        INTO current_done
        FROM "demand_WGR"."RestrictionsInSurveys"
        WHERE "GeometryID" = relevant_restriction_in_survey."GeometryID"
        AND "SurveyID" = new_survey_id;

        IF current_done IS false or current_done IS NULL THEN

            UPDATE "demand_WGR"."RestrictionsInSurveys"
                SET "DemandSurveyDateTime"=relevant_restriction_in_survey."DemandSurveyDateTime", "Enumerator"=relevant_restriction_in_survey."Enumerator", "Done"=relevant_restriction_in_survey."Done", "SuspensionReference"=relevant_restriction_in_survey."SuspensionReference",
                "SuspensionReason"=relevant_restriction_in_survey."SuspensionReason", "SuspensionLength"=relevant_restriction_in_survey."SuspensionLength", "NrBaysSuspended"=relevant_restriction_in_survey."NrBaysSuspended", "SuspensionNotes"=relevant_restriction_in_survey."SuspensionNotes",
                "Photos_01"=relevant_restriction_in_survey."Photos_01", "Photos_02"=relevant_restriction_in_survey."Photos_02", "Photos_03"=relevant_restriction_in_survey."Photos_03"
            WHERE "GeometryID" = relevant_restriction_in_survey."GeometryID"
            AND "SurveyID" = new_survey_id;

            -- Now add VRMs

            INSERT INTO "demand_WGR"."VRMs"(
            "SurveyID", "SectionID", "GeometryID", "PositionID", "VRM", "VehicleTypeID", "RestrictionTypeID", "PermitTypeID", "Notes")
            SELECT new_survey_id, "SectionID", "GeometryID", "PositionID", "VRM", "VehicleTypeID", "RestrictionTypeID", "PermitTypeID", "Notes"
                FROM "demand_WGR"."VRMs"
            WHERE "GeometryID" = relevant_restriction_in_survey."GeometryID"
            AND "SurveyID" = curr_survey_id;

            -- Now tidy up ...

            UPDATE "demand_WGR"."RestrictionsInSurveys"
            SET "Done" = false, "Enumerator" = NULL, "DemandSurveyDateTime" = NULL, "SuspensionReference" = NULL,
            "SuspensionReason" = NULL, "SuspensionLength" = NULL, "NrBaysSuspended"=NULL, "SuspensionNotes"=NULL,
            "Photos_01"=NULL, "Photos_02"=NULL, "Photos_03"=NULL
            WHERE "GeometryID" = relevant_restriction_in_survey."GeometryID"
            AND "SurveyID" = curr_survey_id;

            DELETE FROM "demand_WGR"."VRMs"
            WHERE "GeometryID" = relevant_restriction_in_survey."GeometryID"
            AND "SurveyID" = curr_survey_id;

        ELSE

            RAISE NOTICE '*****--- % already has details on survey id (%) ', relevant_restriction_in_survey."GeometryID", new_survey_id;

        END IF;

    END LOOP;

END;
$do$;
