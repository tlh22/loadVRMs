/***
 *  identify different user types within amended VRMs

    There are three types of user category:
     - Resident: VRM observed overnight
     - Commuter: VRM observed in morning and afternoon beat
     - Visitor: VRM observed in either morning or afternoon beat

 ***/

ALTER TABLE demand."VRMs_Final"
    ADD COLUMN "UserTypeID" INTEGER;

UPDATE demand."VRMs_Final"
SET "UserTypeID" = NULL;

-- Residents
UPDATE demand."VRMs_Final" v
SET "UserTypeID" = 1
FROM demand."Surveys" s
WHERE s."SurveyID" = v."SurveyID"
AND s."BeatStartTime" = '0000';

UPDATE demand."VRMs_Final"
SET "UserTypeID" = 1
WHERE "VRM" IN (
    SELECT "VRM"
    FROM demand."VRMs_Final"
    WHERE "UserTypeID" = 1
);

-- Commuter
UPDATE demand."VRMs_Final"
SET "UserTypeID" = 2
WHERE "UserTypeID" IS NULL
AND "VRM" IN (
    SELECT v1."VRM"
    FROM demand."VRMs_Final" v1, demand."VRMs_Final" v2
    WHERE v1."VRM" = v2."VRM"
    AND v1."ID" < v2."ID"
    AND (
            (v1."SurveyID" = 101 AND v2."SurveyID" = 102)
            OR (v1."SurveyID" = 202 AND v2."SurveyID" = 203)
            OR (v1."SurveyID" = 302 AND v2."SurveyID" = 303)
        )
);

-- Visitor
UPDATE demand."VRMs_Final"
SET "UserTypeID" = 3
WHERE "UserTypeID" IS NULL;

-- final output

SELECT v."ID", v."SurveyID", s."SurveyDay", CONCAT(s."BeatStartTime", '-', "BeatEndTime") As "SurveyTime",
        v."RoadName", v."RestrictionType Description", v."SideOfStreet",
		v."GeometryID", v."VRM", v."VehicleTypeID", v."VehicleType Description",
        v."PCU",
        "UserType Description",
        --v."PermitTypeID", v."PermitType Description",
        v."Notes"

FROM
(SELECT "ID", "SurveyID", a."GeometryID", "PositionID", "VRM",
"VehicleTypeID", "VehicleTypes"."Description" AS "VehicleType Description",
       su."RestrictionTypeID",
		"BayLineTypes"."Description" AS "RestrictionType Description",
        "PermitTypeID", "PermitTypes"."Description" AS "PermitType Description",
        a."Notes", su."RoadName", su."SideOfStreet", "UserTypes"."Description" AS "UserType Description", "VehicleTypes"."PCU"

FROM
     (((((demand."VRMs_Final" AS a
	 LEFT JOIN mhtc_operations."Supply" AS su ON a."GeometryID" = su."GeometryID")
     LEFT JOIN "toms_lookups"."BayLineTypes" AS "BayLineTypes" ON su."RestrictionTypeID" is not distinct from "BayLineTypes"."Code")
     LEFT JOIN "demand_lookups"."VehicleTypes" AS "VehicleTypes" ON a."VehicleTypeID" is not distinct from "VehicleTypes"."Code")
     LEFT JOIN "demand_lookups"."PermitTypes" AS "PermitTypes" ON a."PermitTypeID" is not distinct from "PermitTypes"."Code")
     LEFT JOIN "demand_lookups"."UserTypes" AS "UserTypes" ON a."UserTypeID" is not distinct from "UserTypes"."Code")
ORDER BY "GeometryID", "VRM") As v
	 	, demand."Surveys" s
		, demand."RestrictionsInSurveys" r
WHERE v."SurveyID" = s."SurveyID"
AND r."SurveyID" = s."SurveyID"
AND r."GeometryID" = v."GeometryID"
--AND su."CPZ" = 'HS'
--AND s."SurveyID" > 20 and s."SurveyID" < 30
ORDER BY "GeometryID", "VRM", "SurveyID";

--- Where a resident is a vehicle seen in the first and last beats



DO
$do$
DECLARE
   row RECORD;
BEGIN
    FOR row IN SELECT "SurveyDay", min("SurveyID") as first, max("SurveyID") as last
                FROM demand."Surveys" s
                GROUP BY "SurveyDay"
                ORDER BY min("SurveyID")
    LOOP

        RAISE NOTICE '***** Considering (%)', row."SurveyDay";

        UPDATE demand."VRMs_Final"
        SET "UserType" = 'Resident'
        WHERE "UserType" IS NULL
        AND "VRM" IN (
            SELECT v1."VRM"
            FROM demand."VRMs_Final" v1, demand."VRMs_Final" v2
            WHERE v1."VRM" = v2."VRM"
            AND v1."ID" < v2."ID"
            AND (
                    (v1."SurveyID" = row.first AND v2."SurveyID" = row.last)
                    OR (v1."SurveyID" = row.last AND v2."SurveyID" = row.first)
                )
        );

    END LOOP;
END
$do$;

UPDATE demand."VRMs_Final"
SET "UserType" = 'Visitor'
WHERE "UserType" IS NULL;

-- Check

SELECT "UserType", COUNT("UserType")
FROM (
SELECT DISTINCT "VRM", "UserType"
FROM demand."VRMs_Final"
	) AS y
GROUP BY "UserType"

-- Output "VRMs_Final"

SELECT v."ID", v."SurveyID", --s."BeatTitle",
        v."GeometryID", --v."RoadName",
		v."VRM", v."VehicleTypeID", --v."VehicleType Description",
        v."RestrictionTypeID", --v."RestrictionType Description",
        --v."PermitTypeID", v."PermitType Description",
        v."Notes"
        --, "Enumerator", "DemandSurveyDateTime"
        , "UserType"
        , "isFirst", "isLast", "orphan"

FROM
(SELECT "ID", "SurveyID", a."GeometryID", "PositionID", "VRM",
"VehicleTypeID", "VehicleTypes"."Description" AS "VehicleType Description",
       su."RestrictionTypeID",
		"BayLineTypes"."Description" AS "RestrictionType Description",
        "PermitTypeID", "PermitTypes"."Description" AS "PermitType Description",
        a."Notes", "RoadName"
        , a."UserType"
        , a."isFirst", a."isLast", a."orphan"

FROM
     ((((demand."VRMs_Final" AS a
	 LEFT JOIN mhtc_operations."Supply" AS su ON a."GeometryID" = su."GeometryID")
     LEFT JOIN "toms_lookups"."BayLineTypes" AS "BayLineTypes" ON su."RestrictionTypeID" is not distinct from "BayLineTypes"."Code")
     LEFT JOIN "demand_lookups"."VehicleTypes" AS "VehicleTypes" ON a."VehicleTypeID" is not distinct from "VehicleTypes"."Code")
     LEFT JOIN "demand_lookups"."PermitTypes" AS "PermitTypes" ON a."PermitTypeID" is not distinct from "PermitTypes"."Code")
ORDER BY "GeometryID", "VRM") As v
	 	, demand."Surveys" s
		, demand."RestrictionsInSurveys" r
WHERE v."SurveyID" = s."SurveyID"
AND r."SurveyID" = s."SurveyID"
AND r."GeometryID" = v."GeometryID"
--AND su."CPZ" = 'HS'
--AND s."SurveyID" > 20 and s."SurveyID" < 30
ORDER BY "SurveyID", "GeometryID", "VRM"



/***
 * Re-export VRMs
 ***/

SELECT v."ID", v."SurveyID", s."BeatTitle", v."GeometryID", v."RoadName",
		v."PositionID", v."VRM", v."VehicleTypeID", v."VehicleType Description", v."PCU",
        v."RestrictionTypeID", v."RestrictionType Description",
        v."PermitTypeID", v."PermitType Description",
        v."Notes", v."UserType Description"

FROM
(SELECT "ID", "SurveyID", a."GeometryID", "PositionID", "VRM",
"VehicleTypeID", "VehicleTypes"."Description" AS "VehicleType Description", "VehicleTypes"."PCU" AS "PCU",
       su."RestrictionTypeID",
		"BayLineTypes"."Description" AS "RestrictionType Description",
        "PermitTypeID", "PermitTypes"."Description" AS "PermitType Description",
        a."Notes", "RoadName", "UserTypes"."Description" AS "UserType Description"

FROM
     (((((demand."VRMs_Final" AS a
	 LEFT JOIN mhtc_operations."Supply" AS su ON a."GeometryID" = su."GeometryID")
     LEFT JOIN "toms_lookups"."BayLineTypes" AS "BayLineTypes" ON su."RestrictionTypeID" is not distinct from "BayLineTypes"."Code")
     LEFT JOIN "demand_lookups"."VehicleTypes" AS "VehicleTypes" ON a."VehicleTypeID" is not distinct from "VehicleTypes"."Code")
     LEFT JOIN "demand_lookups"."PermitTypes" AS "PermitTypes" ON a."PermitTypeID" is not distinct from "PermitTypes"."Code")
     LEFT JOIN "demand_lookups"."UserTypes" AS "UserTypes" ON a."UserTypeID" is not distinct from "UserTypes"."Code")
ORDER BY "GeometryID", "VRM") As v
	 	, demand."Surveys" s
		, demand."RestrictionsInSurveys_Final" r
WHERE v."SurveyID" = s."SurveyID"
AND r."SurveyID" = s."SurveyID"
AND r."GeometryID" = v."GeometryID"
AND s."SurveyID" > 0
--AND su."CPZ" = 'HS'
--AND s."SurveyID" > 20 and s."SurveyID" < 30
ORDER BY "GeometryID", "VRM", "SurveyID"


SELECT d."SurveyID", d."SurveyDay", d."BeatStartTime" || '-' || d."BeatEndTime" AS "SurveyTime", d."GeometryID", d."RestrictionTypeID", d."RestrictionType Description", d."RoadName", d."SideOfStreet",
d."DemandSurveyDateTime", d."Enumerator", d."Done", d."SuspensionReference", d."SuspensionReason", d."SuspensionLength", d."NrBaysSuspended", d."SuspensionNotes",
d."Photos_01", d."Photos_02", d."Photos_03", d."Capacity", d."Demand"
FROM
(SELECT ris."SurveyID", su."SurveyDay", su."BeatStartTime", su."BeatEndTime", su."BeatTitle", ris."GeometryID", s."RestrictionTypeID", s."Description" AS "RestrictionType Description", s."RoadName", s."SideOfStreet",
"DemandSurveyDateTime", "Enumerator", "Done", "SuspensionReference", "SuspensionReason", "SuspensionLength", "NrBaysSuspended", "SuspensionNotes",
ris."Photos_01", ris."Photos_02", ris."Photos_03", s."Capacity", v."Demand"
FROM demand."RestrictionsInSurveys_Final" ris, demand."Surveys" su,
(mhtc_operations."Supply" AS a
 LEFT JOIN "toms_lookups"."BayLineTypes" AS "BayLineTypes" ON a."RestrictionTypeID" is not distinct from "BayLineTypes"."Code") AS s
 WHERE ris."SurveyID" = su."SurveyID"
 AND ris."GeometryID" = s."GeometryID"
 --AND s."CPZ" = '7S'
 --AND substring(su."BeatTitle" from '\((.+)\)') LIKE '7S%'
 ) as d

ORDER BY d."SurveyID", d."GeometryID";