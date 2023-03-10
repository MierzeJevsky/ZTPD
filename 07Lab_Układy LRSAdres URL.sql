CREATE TABLE A6_LRS (
    GEOM SDO_GEOMETRY
);


INSERT INTO A6_LRS
SELECT S.GEOM
FROM STREETS_AND_RAILROADS S
WHERE S.ID = (
    SELECT SR.ID
    FROM STREETS_AND_RAILROADS SR, MAJOR_CITIES C
    WHERE SDO_RELATE(SR.GEOM,SDO_GEOM.SDO_BUFFER(C.GEOM, 10, 1, 'unit=km'), 'mask=ANYINTERACT') = 'TRUE'
    AND C.CITY_NAME = 'Koszalin'
);

SELECT * FROM A6_LRS;


SELECT 
    SDO_GEOM.SDO_LENGTH(A.GEOM, 1, 'unit=km') DISTANCE,
    ST_LINESTRING(A.GEOM) .ST_NUMPOINTS() ST_NUMPOINTS
FROM A6_LRS A;


UPDATE A6_LRS A
SET GEOM = SDO_LRS.CONVERT_TO_LRS_GEOM(A.GEOM, 0, SDO_LRS.GEOM_SEGMENT_LENGTH(A.GEOM));


INSERT INTO USER_SDO_GEOM_METADATA 
VALUES (
    'A6_LRS',
    'GEOM',
    MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', 12.603676, 26.369824, 1),
    MDSYS.SDO_DIM_ELEMENT('Y', 45.8464, 58.0213, 1),
    MDSYS.SDO_DIM_ELEMENT('M', 0, 300, 1)),
    8307
);


CREATE INDEX A6_LRS_IDX
ON A6_LRS(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX;


SELECT SDO_LRS.VALID_MEASURE(GEOM, 500) VALID_500
FROM A6_LRS;


SELECT SDO_LRS.GEOM_SEGMENT_END_PT(A.GEOM) END_PT
FROM A6_LRS A;


SELECT SDO_LRS.LOCATE_PT(GEOM, 150, 0) KM150
FROM A6_LRS;



SELECT SDO_LRS.CLIP_GEOM_SEGMENT(GEOM, 120, 160)
FROM A6_LRS;



SELECT SDO_LRS.GET_NEXT_SHAPE_PT(
    A.GEOM,
    C.GEOM) WJAZD_NA_A6
FROM A6_LRS A, MAJOR_CITIES C
WHERE C.CITY_NAME = 'Slupsk';



SELECT SDO_GEOM.SDO_LENGTH(
        SDO_LRS.OFFSET_GEOM_SEGMENT(
            A6.GEOM, M.DIMINFO, 50, 200, 50, 'unit=m'), 1, 'unit=m') KOSZT
FROM A6_LRS A6, USER_SDO_GEOM_METADATA M
WHERE M.TABLE_NAME = 'A6_LRS'
AND M.COLUMN_NAME = 'GEOM';
    
    
    