-- set up fields in RiS

ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrCars" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrLGVs" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrMCLs" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrTaxis" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrPCLs" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrEScooters" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrDocklessPCLs" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrOGVs" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrMiniBuses" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrBuses" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrSpaces" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "Notes" character varying(10000);

ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "DoubleParkingDetails" character varying;

ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrCars_Suspended" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrLGVs_Suspended" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrMCLs_Suspended" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrTaxis_Suspended" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrPCLs_Suspended" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrEScooters_Suspended" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrDocklessPCLs_Suspended" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrOGVs_Suspended" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrMiniBuses_Suspended" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrBuses_Suspended" integer;

ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrCarsIdling" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrCarsParkedIncorrectly" integer;

ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrLGVsIdling" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrLGVsParkedIncorrectly" integer;

ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrMCLsIdling" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrMCLsParkedIncorrectly" integer;

ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrTaxisIdling" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrTaxisParkedIncorrectly" integer;

ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrOGVsIdling" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrOGVsParkedIncorrectly" integer;

ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrMiniBusesIdling" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrMiniBusesParkedIncorrectly" integer;

ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrBusesIdling" integer;
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrBusesParkedIncorrectly" integer;

ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "NrCarsWithDisabledBadgeParkedInPandD" integer;

ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "MCL_Notes" character varying(10000);
ALTER TABLE IF EXISTS demand."RestrictionsInSurveys"
    ADD COLUMN "Supply_Notes" character varying(10000);

-- Now copy

UPDATE demand."RestrictionsInSurveys" AS RiS
SET "NrCars"=c."NrCars", "NrLGVs"=c."NrLGVs", "NrMCLs"=c."NrMCLs", "NrTaxis"=c."NrTaxis", "NrPCLs"=c."NrPCLs",
"NrEScooters"=c."NrEScooters", "NrDocklessPCLs"=c."NrDocklessPCLs", "NrOGVs"=c."NrOGVs", "NrMiniBuses"=c."NrMiniBuses", "NrBuses"=c."NrBuses", "NrSpaces"=c."NrSpaces",
"Notes"=c."Notes", "DoubleParkingDetails"=c."DoubleParkingDetails", "NrCars_Suspended"=c."NrCars_Suspended", "NrLGVs_Suspended"=c."NrLGVs_Suspended", "NrMCLs_Suspended"=c."NrMCLs_Suspended",
"NrTaxis_Suspended"=c."NrTaxis_Suspended", "NrPCLs_Suspended"=c."NrPCLs_Suspended", "NrEScooters_Suspended"=c."NrEScooters_Suspended", "NrDocklessPCLs_Suspended"=c."NrDocklessPCLs_Suspended",
"NrOGVs_Suspended"=c."NrOGVs_Suspended", "NrMiniBuses_Suspended"=c."NrMiniBuses_Suspended", "NrBuses_Suspended"=c."NrBuses_Suspended", "NrCarsIdling"=c."NrCarsIdling",
"NrCarsParkedIncorrectly"=c."NrCarsParkedIncorrectly", "NrLGVsIdling"=c."NrLGVsIdling", "NrLGVsParkedIncorrectly"=c."NrLGVsParkedIncorrectly", "NrMCLsIdling"=c."NrMCLsIdling", "NrMCLsParkedIncorrectly"=c."NrMCLsParkedIncorrectly", 
"NrTaxisIdling"=c."NrTaxisIdling", "NrTaxisParkedIncorrectly"=c."NrTaxisParkedIncorrectly", "NrOGVsIdling"=c."NrOGVsIdling", "NrOGVsParkedIncorrectly"=c."NrOGVsParkedIncorrectly", 
"NrMiniBusesIdling"=c."NrMiniBusesIdling", "NrMiniBusesParkedIncorrectly"=c."NrMiniBusesParkedIncorrectly", "NrBusesIdling"=c."NrBusesIdling", "NrBusesParkedIncorrectly"=c."NrBusesParkedIncorrectly", 
"NrCarsWithDisabledBadgeParkedInPandD"=c."NrCarsWithDisabledBadgeParkedInPandD", "MCL_Notes"=c."MCL_Notes", "Supply_Notes"=c."Supply_Notes"
FROM demand."Counts" c
	WHERE RiS."GeometryID" = c."GeometryID"
	AND RiS."SurveyID" = c."SurveyID";