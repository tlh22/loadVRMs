/**
Check the count collected within each pass
**/




**********
-- Check
SELECT "SurveyID",
            SUM(COALESCE("NrCars"::float, 0.0) +
            COALESCE("NrLGVs"::float, 0.0) +
            COALESCE("NrMCLs"::float, 0.0)*0.33 +
            (COALESCE("NrOGVs"::float, 0) + COALESCE("NrMiniBuses"::float, 0) + COALESCE("NrBuses"::float, 0))*1.5 +
            COALESCE("NrTaxis"::float, 0)) As "Demand",
            SUM("NrSpaces") AS "Spaces",
            SUM(COALESCE("NrCars_Suspended"::float, 0.0) +
            COALESCE("NrLGVs_Suspended"::float, 0.0) +
            COALESCE("NrMCLs_Suspended"::float, 0.0)*0.33 +
            (COALESCE("NrOGVs_Suspended"::float, 0) + COALESCE("NrMiniBuses_Suspended"::float, 0) + COALESCE("NrBuses_Suspended"::float, 0))*1.5 +
            COALESCE("NrTaxis_Suspended"::float, 0)) As "Suspended_Demand",
            SUM(COALESCE("NrCarsIdling"::float, 0.0) +
            COALESCE("NrLGVsIdling"::float, 0.0) +
            COALESCE("NrMCLsIdling"::float, 0.0)*0.33 +
            (COALESCE("NrOGVsIdling"::float, 0) + COALESCE("NrMiniBusesIdling"::float, 0) + COALESCE("NrBusesIdling"::float, 0))*1.5 +
            COALESCE("NrTaxisIdling"::float, 0)) As "Idling_Demand",
            SUM(COALESCE("NrCarsParkedIncorrectly"::float, 0.0) +
            COALESCE("NrLGVsParkedIncorrectly"::float, 0.0) +
            COALESCE("NrMCLsParkedIncorrectly"::float, 0.0)*0.33 +
            (COALESCE("NrOGVsParkedIncorrectly"::float, 0) + COALESCE("NrMiniBusesParkedIncorrectly"::float, 0) + COALESCE("NrBusesParkedIncorrectly"::float, 0))*1.5 +
            COALESCE("NrTaxisParkedIncorrectly"::float, 0)) As "ParkedIncorrectly_Demand",
            SUM(COALESCE("NrCars"::float, 0.0) +
            COALESCE("NrLGVs"::float, 0.0) +
            COALESCE("NrMCLs"::float, 0.0)*0.33 +
            (COALESCE("NrOGVs"::float, 0) + COALESCE("NrMiniBuses"::float, 0) + COALESCE("NrBuses"::float, 0))*1.5 +
            COALESCE("NrTaxis"::float, 0) +
            COALESCE("NrSpaces"::float, 0.0) +
            COALESCE("NrCars_Suspended"::float, 0.0) +
            COALESCE("NrLGVs_Suspended"::float, 0.0) +
            COALESCE("NrMCLs_Suspended"::float, 0.0)*0.33 +
            (COALESCE("NrOGVs_Suspended"::float, 0) + COALESCE("NrMiniBuses_Suspended"::float, 0) + COALESCE("NrBuses_Suspended"::float, 0))*1.5 +
            COALESCE("NrTaxis_Suspended"::float, 0)) +
            SUM(COALESCE("NrCarsIdling"::float, 0.0) +
            COALESCE("NrLGVsIdling"::float, 0.0) +
            COALESCE("NrMCLsIdling"::float, 0.0)*0.33 +
            (COALESCE("NrOGVsIdling"::float, 0) + COALESCE("NrMiniBusesIdling"::float, 0) + COALESCE("NrBusesIdling"::float, 0))*1.5 +
            COALESCE("NrTaxisIdling"::float, 0)) +
            SUM(COALESCE("NrCarsParkedIncorrectly"::float, 0.0) +
            COALESCE("NrLGVsParkedIncorrectly"::float, 0.0) +
            COALESCE("NrMCLsParkedIncorrectly"::float, 0.0)*0.33 +
            (COALESCE("NrOGVsParkedIncorrectly"::float, 0) + COALESCE("NrMiniBusesParkedIncorrectly"::float, 0) + COALESCE("NrBusesParkedIncorrectly"::float, 0))*1.5 +
            COALESCE("NrTaxisParkedIncorrectly"::float, 0))
             As "Total"

FROM demand."Counts"
GROUP BY "SurveyID"
ORDER BY "SurveyID";

--

SELECT s."SurveyID", z."SurveyAreaName", z."Total"
FROM demand."Surveys" s
LEFT JOIN
    (SELECT y."SurveyID", a."SurveyAreaName", y."Total"
    FROM mhtc_operations."SurveyAreas" a
    LEFT JOIN

     (SELECT c."SurveyID", r."SurveyAreaID",
            SUM(COALESCE("NrCars"::float, 0.0) +
            COALESCE("NrLGVs"::float, 0.0) +
            COALESCE("NrMCLs"::float, 0.0)*0.33 +
            (COALESCE("NrOGVs"::float, 0) + COALESCE("NrMiniBuses"::float, 0) + COALESCE("NrBuses"::float, 0))*1.5 +
            COALESCE("NrTaxis"::float, 0)) As "Demand",
            SUM("NrSpaces") AS "Spaces",
            SUM(COALESCE("NrCars_Suspended"::float, 0.0) +
            COALESCE("NrLGVs_Suspended"::float, 0.0) +
            COALESCE("NrMCLs_Suspended"::float, 0.0)*0.33 +
            (COALESCE("NrOGVs_Suspended"::float, 0) + COALESCE("NrMiniBuses_Suspended"::float, 0) + COALESCE("NrBuses_Suspended"::float, 0))*1.5 +
            COALESCE("NrTaxis_Suspended"::float, 0)) As "Suspended_Demand",
            SUM(COALESCE("NrCarsIdling"::float, 0.0) +
            COALESCE("NrLGVsIdling"::float, 0.0) +
            COALESCE("NrMCLsIdling"::float, 0.0)*0.33 +
            (COALESCE("NrOGVsIdling"::float, 0) + COALESCE("NrMiniBusesIdling"::float, 0) + COALESCE("NrBusesIdling"::float, 0))*1.5 +
            COALESCE("NrTaxisIdling"::float, 0)) As "Idling_Demand",
            SUM(COALESCE("NrCarsParkedIncorrectly"::float, 0.0) +
            COALESCE("NrLGVsParkedIncorrectly"::float, 0.0) +
            COALESCE("NrMCLsParkedIncorrectly"::float, 0.0)*0.33 +
            (COALESCE("NrOGVsParkedIncorrectly"::float, 0) + COALESCE("NrMiniBusesParkedIncorrectly"::float, 0) + COALESCE("NrBusesParkedIncorrectly"::float, 0))*1.5 +
            COALESCE("NrTaxisParkedIncorrectly"::float, 0)) As "ParkedIncorrectly_Demand",
            SUM(COALESCE("NrCars"::float, 0.0) +
            COALESCE("NrLGVs"::float, 0.0) +
            COALESCE("NrMCLs"::float, 0.0)*0.33 +
            (COALESCE("NrOGVs"::float, 0) + COALESCE("NrMiniBuses"::float, 0) + COALESCE("NrBuses"::float, 0))*1.5 +
            COALESCE("NrTaxis"::float, 0) +
            COALESCE("NrSpaces"::float, 0.0) +
            COALESCE("NrCars_Suspended"::float, 0.0) +
            COALESCE("NrLGVs_Suspended"::float, 0.0) +
            COALESCE("NrMCLs_Suspended"::float, 0.0)*0.33 +
            (COALESCE("NrOGVs_Suspended"::float, 0) + COALESCE("NrMiniBuses_Suspended"::float, 0) + COALESCE("NrBuses_Suspended"::float, 0))*1.5 +
            COALESCE("NrTaxis_Suspended"::float, 0)) +
            SUM(COALESCE("NrCarsIdling"::float, 0.0) +
            COALESCE("NrLGVsIdling"::float, 0.0) +
            COALESCE("NrMCLsIdling"::float, 0.0)*0.33 +
            (COALESCE("NrOGVsIdling"::float, 0) + COALESCE("NrMiniBusesIdling"::float, 0) + COALESCE("NrBusesIdling"::float, 0))*1.5 +
            COALESCE("NrTaxisIdling"::float, 0)) +
            SUM(COALESCE("NrCarsParkedIncorrectly"::float, 0.0) +
            COALESCE("NrLGVsParkedIncorrectly"::float, 0.0) +
            COALESCE("NrMCLsParkedIncorrectly"::float, 0.0)*0.33 +
            (COALESCE("NrOGVsParkedIncorrectly"::float, 0) + COALESCE("NrMiniBusesParkedIncorrectly"::float, 0) + COALESCE("NrBusesParkedIncorrectly"::float, 0))*1.5 +
            COALESCE("NrTaxisParkedIncorrectly"::float, 0))
             As "Total"
          FROM demand."Counts" c, mhtc_operations."Supply" r
          WHERE "SurveyID" > 0
          AND c."GeometryID" = r."GeometryID"
          GROUP BY c."SurveyID", r."SurveyAreaID"
          ORDER BY c."SurveyID", r."SurveyAreaID") AS y

          ON y."SurveyAreaID"::integer = a."Code") AS z
          ON z."SurveyID" = s."SurveyID"
          ORDER BY s."SurveyID", z."SurveyAreaName"

--

-- Step 1: Add new fields

ALTER TABLE demand."Counts"
    ADD COLUMN "Demand" double precision;
ALTER TABLE demand."Counts"
    ADD COLUMN "Stress" double precision;

-- Step 2: calculate demand values using trigger

-- set up trigger for demand and stress

CREATE OR REPLACE FUNCTION "demand"."update_demand"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
	 vehicleLength real := 0.0;
	 vehicleWidth real := 0.0;
	 motorcycleWidth real := 0.0;
	 restrictionLength real := 0.0;
	 Capacity INTEGER := 0;
BEGIN

    select "Value" into vehicleLength
        from "mhtc_operations"."project_parameters"
        where "Field" = 'VehicleLength';

    select "Value" into vehicleWidth
        from "mhtc_operations"."project_parameters"
        where "Field" = 'VehicleWidth';

    select "Value" into motorcycleWidth
        from "mhtc_operations"."project_parameters"
        where "Field" = 'MotorcycleWidth';

    IF vehicleLength IS NULL OR vehicleWidth IS NULL OR motorcycleWidth IS NULL THEN
        RAISE EXCEPTION 'Capacity parameters not available ...';
        RETURN OLD;
    END IF;

    SELECT "Capacity" into Capacity
    FROM mhtc_operations."Supply"
    WHERE "GeometryID" = NEW."GeometryID";

    NEW."Demand" = COALESCE(NEW."NrCars"::float, 0.0) +
                    COALESCE(NEW."NrLGVs"::float, 0.0) +
                    COALESCE(NEW."NrMCLs"::float, 0.0)*0.33 +
                    (COALESCE(NEW."NrOGVs"::float, 0.0) + COALESCE(NEW."NrMiniBuses"::float, 0.0) + COALESCE(NEW."NrBuses"::float, 0.0))*1.5 +
                    COALESCE(NEW."NrTaxis"::float, 0.0);
                    --- added for Camden
                    /***
					+ COALESCE(NEW."NrCars_Suspended"::float, 0.0) +
                    COALESCE(NEW."NrLGVs_Suspended"::float, 0.0) +
                    COALESCE(NEW."NrMCLs_Suspended"::float, 0.0)*0.33 +
                    (COALESCE(NEW."NrOGVs_Suspended"::float, 0) + COALESCE(NEW."NrMiniBuses_Suspended"::float, 0) + COALESCE(NEW."NrBuses_Suspended"::float, 0))*1.5 +
                    COALESCE(NEW."NrTaxis_Suspended"::float, 0);
					***/

	/***NEW."VehiclesInSuspendedArea" = COALESCE(NEW."NrCars_Suspended"::float, 0.0) +
                    COALESCE(NEW."NrLGVs_Suspended"::float, 0.0) +
                    COALESCE(NEW."NrMCLs_Suspended"::float, 0.0)*0.33 +
                    (COALESCE(NEW."NrOGVs_Suspended"::float, 0) + COALESCE(NEW."NrMiniBuses_Suspended"::float, 0) + COALESCE(NEW."NrBuses_Suspended"::float, 0))*1.5 +
                    COALESCE(NEW."NrTaxis_Suspended"::float, 0); ***/
	--NEW."BaysSuspended" = 
	
    /* What to do about suspensions */

    CASE
        WHEN Capacity = 0 THEN
            CASE
                WHEN NEW."Demand" > 0.0 THEN NEW."Stress" = 1.0;
                ELSE NEW."Stress" = 0.0;
            END CASE;
        ELSE

            NEW."Stress" = NEW."Demand" / Capacity::float;

    END CASE;

	RETURN NEW;

END;
$$;

-- Step 3: setup trigger

DROP TRIGGER IF EXISTS "update_demand" ON "demand"."Counts";
CREATE TRIGGER "update_demand" before insert or update on "demand"."Counts" FOR EACH ROW EXECUTE function "demand"."update_demand"();

-- Step 4: trigger trigger

UPDATE "demand"."Counts" SET "DoubleParkingDetails" = "DoubleParkingDetails";

