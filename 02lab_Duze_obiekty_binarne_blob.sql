
create table MOVIES
(
    ID NUMBER(12) PRIMARY KEY,
    TITLE VARCHAR2(400) NOT NULL,
    CATEGORY VARCHAR2(50),
    YEAR CHAR(4),
    CAST VARCHAR2(4000),
    DIRECTOR VARCHAR2(4000),
    STORY VARCHAR2(4000),
    PRICE NUMBER(5,2),
    COVER BLOB,
    MIME_TYPE VARCHAR2(50)
);


Insert into MOVIES 
select 
    d.ID, 
    d.TITLE, 
    d.category, 
    TRIM(d.year) as YEAR, 
    d.cast, 
    d.director, 
    d.story, 
    d.price,
    c.IMAGE,
    c.MIME_TYPE
from DESCRIPTIONS d
full outer join COVERS c
on d.ID = c.MOVIE_ID;


select ID, title 
from movies 
where COVER is null;


select ID, title, length(cover) as FILESIZE 
from movies 
where COVER is not null;


select ID, title, length(cover)  as FILESIZE 
from movies 
where COVER is  null;


select * 
from ALL_DIRECTORIES;


UPDATE MOVIES
set
    COVER = EMPTY_BLOB(),
    MIME_TYPE = 'image/jpeg'
where ID = 66;


select ID, title, length(cover) 
from movies 
where ID in (65,66);


DECLARE
     lobd blob;
     fils BFILE := BFILENAME('ZSBD_DIR','escape.jpg');
BEGIN
     SELECT cover into lobd from movies
     where id = 66
     FOR UPDATE;
     DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
     DBMS_LOB.LOADFROMFILE(lobd,fils,DBMS_LOB.GETLENGTH(fils));
     DBMS_LOB.FILECLOSE(fils);
     COMMIT;
END;


CREATE TABLE TEMP_COVERS
(
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR2(50)
);


INSERT INTO temp_covers 
VALUES(65, BFILENAME('ZSBD_DIR','eagles.jpg'),'image/jpeg');
COMMIT;


select movie_id, DBMS_LOB.GETLENGTH(image) 
from temp_covers


DECLARE
     mime VARCHAR2(50);
     image BFILE;
     lobd blob;
BEGIN
    
    SELECT mime_type into mime from temp_covers;
    SELECT image into image from temp_covers;
    
    dbms_lob.createtemporary(lobd, TRUE);
    
    DBMS_LOB.fileopen(image, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(lobd, image, DBMS_LOB.GETLENGTH(image));
    DBMS_LOB.FILECLOSE(image);
    
    update movies
    set cover = lobd,
    mime_type = mime
    where id = 65;
    
    dbms_lob.freetemporary(lobd);
    COMMIT;
END;


select ID, title, length(cover) 
from movies 
where ID = 65 or ID = 66;


drop table MOVIES;
drop table TEMP_COVERS;







