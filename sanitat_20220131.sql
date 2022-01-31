SET AUTOCOMMIT=1;

DROP DATABASE IF EXISTS sanitat_20220131;

CREATE DATABASE IF NOT EXISTS sanitat_20220131;

USE sanitat_20220131;

CREATE TABLE IF NOT EXISTS HOSPITALS (
 codi_hospital      TINYINT (2) PRIMARY KEY,
 nom_hospital       VARCHAR(50) NOT NULL,
 adressa_hospital   VARCHAR(40) NOT NULL,
 pob_hospital       VARCHAR(40) NOT NULL,
 telefon_hospital   VARCHAR(9),
 qtat_llits         SMALLINT(3) UNSIGNED DEFAULT 0);

CREATE INDEX HOSPITAL_NOM ON HOSPITALS (nom_hospital);

INSERT INTO HOSPITALS (codi_hospital,nom_hospital,adressa_hospital,pob_hospital,telefon_hospital) VALUES
    (13,'Hospital Universitari de Bellvitge','Carrer de la Feixa Llarga, s/n','Hospitalet de Llobregat','932607500'),
    (18,'Hospital Universitari General de Catalunya','Carrer Pedro i Pons, 1','Sant Cugat del Valles', '935656000'),
    (22,'Hospital de la Santa Creu i Sant Pau','C. Sant Antoni Maria Claret, 167','Barcelona','935537801'),
    (45,'Hospital Clinic i Provincial de Barcelona','C. de Villarroel, 170','Barcelona','932275400');


CREATE TABLE IF NOT EXISTS SALES (
 codi_hospital  TINYINT (2),
 codi_sala      TINYINT (2),
 nom_sala       VARCHAR(20) NOT NULL,
 qtat_llits     SMALLINT(3) UNSIGNED DEFAULT 0,
 CONSTRAINT SALA_PK PRIMARY KEY (codi_hospital, codi_sala),
 INDEX IDX_SALA_HOSPITAL_COD (codi_hospital),
 FOREIGN KEY (codi_hospital) REFERENCES HOSPITALS(codi_hospital)) ;

INSERT INTO SALES VALUES (13,1,'Quirofans',50);
INSERT INTO SALES VALUES (13,2,'Llits de critics',136);
INSERT INTO SALES VALUES (13,3,'Cures Intensives UCI',121);
INSERT INTO SALES VALUES (13,4,'Boxs urgencies',67);
INSERT INTO SALES VALUES (13,5,'Llits de recuperacio',486);

INSERT INTO SALES VALUES (18,1,'Quirofans',18);
INSERT INTO SALES VALUES (18,2,'Llits de critics',45);
INSERT INTO SALES VALUES (18,3,'Cures Intensives UCI',10);
INSERT INTO SALES VALUES (18,4,'Boxs urgencies',13);
INSERT INTO SALES VALUES (18,5,'Llits de recuperacio',210);

INSERT INTO SALES VALUES (22,1,'Quirofans',32);
INSERT INTO SALES VALUES (22,2,'Llits de critics',81);
INSERT INTO SALES VALUES (22,3,'Cures Intensives UCI',10);
INSERT INTO SALES VALUES (22,4,'Boxs urgencies',53);
INSERT INTO SALES VALUES (22,5,'Llits de recuperacio',468);

INSERT INTO SALES VALUES (45,1,'Quirofans',21);
INSERT INTO SALES VALUES (45,2,'Llits de critics',74);
INSERT INTO SALES VALUES (45,3,'Cures Intensives UCI',30);
INSERT INTO SALES VALUES (45,4,'Boxs urgencies',25);
INSERT INTO SALES VALUES (45,5,'Llits de recuperacio',246);

UPDATE HOSPITALS 
SET qtat_llits = (SELECT SUM(qtat_llits) 
                  FROM SALES 
                  WHERE HOSPITALS.codi_hospital = SALES.codi_hospital);

CREATE TABLE IF NOT EXISTS TREBALLADORS (
 codi_hospital  TINYINT (2),
 codi_sala      TINYINT (2),
 codi_treb      SMALLINT(4) NOT NULL,
 nom_treb       VARCHAR (15) NOT NULL,
 cognom_treb    VARCHAR (15) NOT NULL,
 funcio_treb    VARCHAR (10), 
 torn_treb      VARCHAR (1) CHECK (torn_treb IN ('M','T','N')),
 sou_treb       INT (10),
 CONSTRAINT PLANTILLA_PK PRIMARY KEY (codi_hospital, codi_sala, codi_treb),
 INDEX IDX_PLANTILLA_HOSP_SALA (codi_hospital, codi_sala),
 FOREIGN KEY (codi_hospital, codi_sala) REFERENCES SALES (codi_hospital, codi_sala)) ;  

CREATE INDEX PLANTILLA_HOSP_COGNOM ON TREBALLADORS (codi_hospital, cognom_treb);
CREATE INDEX PLANTILLA_HOSP_FUNCIO ON TREBALLADORS (codi_hospital, funcio_treb);
CREATE INDEX PLANTILLA_FUNCIO_HOSP_SALA ON TREBALLADORS (funcio_treb, codi_hospital, codi_sala);

INSERT INTO TREBALLADORS VALUES(13,5,3754,'Anna Belen','Alonso','Infermera','T',13500);
INSERT INTO TREBALLADORS VALUES(13,5,3106,'Joan Carles','Hernandez','Infermer','T',16600); 
INSERT INTO TREBALLADORS VALUES(18,4,6357,'Carles','Jimenez','Intern','T',20400);
INSERT INTO TREBALLADORS VALUES(22,5,1009,'Laura','Pastor','Infermera','T',12000);
INSERT INTO TREBALLADORS VALUES(22,5,8422,'Alfonso','Bravo','Infermer','M',10000);
INSERT INTO TREBALLADORS VALUES(22,2,9901,'Guillem','Garrido','Intern','M',13300);
INSERT INTO TREBALLADORS VALUES(22,1,6065,'Iolanda','Caballero','Infermera','N',10000);
INSERT INTO TREBALLADORS VALUES(22,1,7379,'Ainhoa','Nunyez','Infermera','T',12800);
INSERT INTO TREBALLADORS VALUES(45,4,1280,'Ferran','Molina','Intern','N',13300);
INSERT INTO TREBALLADORS VALUES(45,1,8526,'Martina','Hidalgo','Infermera','T',15200);

CREATE TABLE IF NOT EXISTS MALALTS (
 inscripcio     INT (5) PRIMARY KEY,  
 nom_malalt     VARCHAR (15) NOT NULL,
 cognom_malalt  VARCHAR (15) NOT NULL,
 adressa_malalt VARCHAR (20),
 data_naix      DATE,
 sexe_malalt    CHAR (1) NOT NULL CHECK (sexe_malalt = 'H' OR sexe_malalt = 'D'),
 num_seg_social CHAR(9)) ;

CREATE INDEX MALALT_NAIX_COGNOM ON MALALTS (data_naix, cognom_malalt);
CREATE INDEX MALALT_COGNOM_NAIX ON MALALTS (cognom_malalt, data_naix);


INSERT INTO MALALTS VALUES(10995,'Maria','Laguna','Goya 20','1985-05-16','D',280862482);
INSERT INTO MALALTS VALUES(18004,'Joan','Serrano','Alcala 12','1998-05-21','H',284991452);
INSERT INTO MALALTS VALUES(14024,'Gloria','Fernandez','Recoletos 50','1999-06-23','D',321790059);
INSERT INTO MALALTS VALUES(36658,'Mateu','Guimenez','Mayor 71','2005-01-01','H',160657471);
INSERT INTO MALALTS VALUES(38702,'Immaculada','Moreno','Orense 11','1974-06-18','D',380010217);
INSERT INTO MALALTS VALUES(39217,'Vicente','Cervantes','Peron 38','1982-02-24','H',440294390);
INSERT INTO MALALTS VALUES(59076,'Margarita','Fuentes','Lopez de Hoyos 2','1965-09-16','D',311969044);
INSERT INTO MALALTS VALUES(63827,'Jordi','Ruiz','Esquerdo 103','1980-12-26','H',100973253);
INSERT INTO MALALTS VALUES(64823,'Noelia','Flores','Soto 3','1980-07-10','D',285201776);
INSERT INTO MALALTS VALUES(74835,'Juan','Benitez','Argentina 5','1987-10-05','H',154811767);


CREATE TABLE IF NOT EXISTS INGRESSOS (
 inscripcio     INT (5) PRIMARY KEY,
 codi_hospital  TINYINT (2) NOT NULL,
 codi_sala      TINYINT (2) NOT NULL,
 codi_llit      SMALLINT(4) UNSIGNED,
 INDEX IDX_INGRESSOS_INSCRIPCIO (inscripcio),
 INDEX IDX_INGRESSOS_HOSP_SALA (codi_hospital, codi_sala),
 FOREIGN KEY (inscripcio) REFERENCES MALALTS(inscripcio),
 FOREIGN KEY (codi_hospital, codi_sala) REFERENCES SALES (codi_hospital, codi_sala));

CREATE INDEX INGRESSOS_HOSP_SALA ON INGRESSOS (codi_hospital, codi_sala);


INSERT INTO INGRESSOS VALUES(10995,13,3,1);
INSERT INTO INGRESSOS VALUES(18004,13,3,2);
INSERT INTO INGRESSOS VALUES(14024,13,3,3);
INSERT INTO INGRESSOS VALUES(36658,18,4,1);
INSERT INTO INGRESSOS VALUES(38702,18,4,2);
INSERT INTO INGRESSOS VALUES(39217,22,5,1);
INSERT INTO INGRESSOS VALUES(59076,22,5,2);
INSERT INTO INGRESSOS VALUES(63827,22,5,3);
INSERT INTO INGRESSOS VALUES(64823,22,2,1);

CREATE TABLE IF NOT EXISTS DOCTORS (
 codi_hospital  TINYINT (2),
 codi_doctor    SMALLINT(3),
 nom_doctor     VARCHAR(13) NOT NULL,
 cognom_doctor  VARCHAR(13) NOT NULL,
 espec_doctor   VARCHAR(16) NOT NULL,
 CONSTRAINT DOCTOR_PK PRIMARY KEY (codi_hospital, codi_doctor),
 INDEX IDX_DOCTOR_HOSP (codi_hospital),
 FOREIGN KEY (codi_hospital) REFERENCES HOSPITALS(codi_hospital)) ;


INSERT INTO DOCTORS VALUES(13,435,'Jaume','Lopez','Cardiologia');
INSERT INTO DOCTORS VALUES(18,585,'Marc','Martinez','Ginecologia');
INSERT INTO DOCTORS VALUES(18,982,'Ramon','Cajal','Cardiologia');
INSERT INTO DOCTORS VALUES(22,453,'Ignasi','Bravo','Pediatria');
INSERT INTO DOCTORS VALUES(22,398,'Patricia','Aguilar','Urologia');
INSERT INTO DOCTORS VALUES(22,386,'Antonio','Cabeza','Psiquiatria');
INSERT INTO DOCTORS VALUES(45,607,'Rosa Maria','Marquez','Pediatria');
INSERT INTO DOCTORS VALUES(45,522,'Jose Luis','Moya','Neurologia');


CREATE INDEX DOCTOR_ESP_HOSP ON DOCTORS (espec_doctor, codi_hospital);
CREATE INDEX DOCTOR_HOSP_ESP ON DOCTORS (codi_hospital, espec_doctor);

