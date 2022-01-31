SET AUTOCOMMIT=1;

DROP DATABASE IF EXISTS empresa_20220131;

CREATE DATABASE IF NOT EXISTS empresa_20220131;

USE empresa_20220131; 

CREATE TABLE IF NOT EXISTS DEPARTAMENTS (
 codi_dept  TINYINT (2) UNSIGNED NOT NULL AUTO_INCREMENT,
 nom_dept     VARCHAR(14) NOT NULL UNIQUE,
 localitat      VARCHAR(14),
 PRIMARY KEY (codi_dept) ) ;



CREATE TABLE IF NOT EXISTS TREBALLADORS (
 codi_treb    SMALLINT (4) UNSIGNED NOT NULL AUTO_INCREMENT,
 cognom_treb    VARCHAR (10) NOT NULL,
 ofici_treb     VARCHAR (15),
 resp_treb       SMALLINT (4) UNSIGNED,
 alta_treb DATE,
 sou_treb    SMALLINT UNSIGNED,
 comissio_treb  SMALLINT UNSIGNED,
 codi_dept   TINYINT (2) UNSIGNED NOT NULL,
 PRIMARY KEY (codi_treb),
 INDEX IDX_EMP_CAP (resp_treb),
 INDEX IDX_EMP_DEPT_NO (codi_dept),
 FOREIGN KEY (codi_dept) REFERENCES DEPARTAMENTS(codi_dept)) ;


CREATE INDEX EMP_COGNOM ON TREBALLADORS (cognom_treb);
CREATE INDEX EMP_DEPT_NO_EMP ON TREBALLADORS (codi_dept,codi_treb);


ALTER TABLE TREBALLADORS
ADD FOREIGN KEY (resp_treb) REFERENCES TREBALLADORS(codi_treb);


CREATE TABLE IF NOT EXISTS CLIENTS (
 codi_client          INT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
 nom_client                 VARCHAR (50) NOT NULL,
 adressa_client              VARCHAR (40) NOT NULL,
 ciutat_client              VARCHAR (30) NOT NULL,
 estat_client               VARCHAR (2),
 cp_client         VARCHAR (9) NOT NULL,
 area_client                SMALLINT(3),
 telefon_client             VARCHAR (9),
 codi_representant_client            SMALLINT(4) UNSIGNED,
 limit_credit_client        DECIMAL(9,2) UNSIGNED,
 observacions_client        TEXT,
 PRIMARY KEY (codi_client),
 INDEX IDX_CLIENT_REPR_COD (codi_representant_client),
 FOREIGN KEY (codi_representant_client) REFERENCES TREBALLADORS(codi_treb));

CREATE INDEX CLIENT_NOM ON CLIENTS (nom_client);
CREATE INDEX CLIENT_REPR_CLI ON CLIENTS (codi_representant_client, codi_client);



CREATE TABLE IF NOT EXISTS PRODUCTES (
 codi_producte     INT (6) UNSIGNED NOT NULL AUTO_INCREMENT,
 desc_producte     VARCHAR (35) NOT NULL,
 PRIMARY KEY (codi_producte),
 UNIQUE (desc_producte)
);



CREATE TABLE IF NOT EXISTS COMANDES  (
 codi_comanda          SMALLINT(4) UNSIGNED AUTO_INCREMENT,
 data_comanda          DATE,
 tipus_comanda         CHAR (1) CHECK (tipus_comanda IN ('A','B','C')),
 codi_cli_cda          INT (6) UNSIGNED NOT NULL,
 data_tramesa_comanda  DATE,
 total_comanda         DECIMAL(8,2) UNSIGNED,
 PRIMARY KEY (codi_comanda),
 FOREIGN KEY (codi_cli_cda) REFERENCES CLIENTS(codi_client) );

CREATE INDEX IDX_COMANDA_CLIENT_COD  ON COMANDES (codi_cli_cda);
CREATE INDEX COMANDA_DATA_NUM ON COMANDES (data_comanda,codi_comanda);
CREATE INDEX COMANDA_TRAMESA_NUM ON COMANDES (data_tramesa_comanda,codi_comanda);


CREATE TABLE IF NOT EXISTS DETALLS_COMANDA  (
 codi_comanda             SMALLINT(4) UNSIGNED,
 num_detall          SMALLINT(4) UNSIGNED,
 codi_prod_cda            INT(6) UNSIGNED NOT NULL,
 preu_prod_cda          DECIMAL(8,2) UNSIGNED,
 quantitat_prod_cda           INT (8),
 import_prod_cda              DECIMAL(8,2),
 CONSTRAINT DETALL_PK PRIMARY KEY (codi_comanda,num_detall),
 INDEX IDX_DETAL_COM_NUM (codi_comanda),
 INDEX IDX_PROD_NUM (codi_prod_cda),
 FOREIGN KEY (codi_comanda) REFERENCES COMANDES(codi_comanda),
 FOREIGN KEY (codi_prod_cda) REFERENCES PRODUCTES(codi_producte));

CREATE INDEX DETALL_PROD_COM_DET ON DETALLS_COMANDA (codi_prod_cda,codi_comanda,num_detall);

INSERT INTO DEPARTAMENTS VALUES
        (10, 'Comptabilitat', 'Sevilla'),
        (20, 'Investigacio', 'Madrid'),
        (30, 'Vendes', 'Barcelona'),
        (40, 'Produccio', 'Bilbao');

INSERT INTO TREBALLADORS VALUES
(7839,'REY','President',NULL,'1981-11-17',3907,NULL,10),
(7566,'JIMENEZ','Director',7839,'1981-04-02',2324,NULL,20),
(7698,'NEGRO','Director',7839,'1981-05-01',2227,NULL,30),
(7902,'FERNANDEZ','Analista',7566,'1981-12-03',2344,NULL,20),
(7369,'SANCHEZ','Treballador',7902,'1980-12-17',625,NULL,20),
(7499,'ARROYO','Venedor',7698,'1980-02-20',1250,234,30),
(7521,'SALA','Venedor',7698,'1981-02-22',977,391,30),
(7654,'MARTIN','Venedor',7698,'1981-09-29',977,1094,30),
(7782,'CEREZO','Director',7839,'1981-06-09',1914,NULL,10),
(7788,'GIL','Analista',7566,'1981-11-09',2344,NULL,20),
(7844,'TOVAR','Venedor',7698,'1981-09-08',1172,0,30),
(7876,'ALONSO','Treballador',7788,'1981-09-23',859,NULL,20),
(7900,'JIMENO','Treballador',7698,'1981-12-03',742,NULL,30),
(7934,'MUNYOZ','Treballador',7782,'1982-01-23',1016,NULL,10);

INSERT INTO CLIENTS VALUES
        (default, 'ESPORTS GREBOL', '345 VIEWRIDGE', 'BELMONT', 'CA', '96711', 415,'598-6609', 7844, 5000, 'Gent molt amable per treballar: al representant de vendes li agrada que li diguin Miqui.'),
        (default, 'BOTIGA ESPORTS TKB', '490 BOLI RD.', 'REDWOOD CIUTAT', 'CA', '94061', 415,'368-1223', 7521, 10000, 'El representant va trucar al 5/8 per canviar la comanda; contacteu amb el comercial.'),
        (default, 'VOLLEI RITA', '9722 HAMILTON', 'BURLINGAME', 'CA', '95133', 415,'644-3341', 7654, 7000, 'Empresa fent una gran promocio a partir del 10/2010. Prepareu-vos per a grans comandes durant hivern.'),
        (default, 'NOMES TENIS', 'HILLVIEW MALL', 'BURLINGAME', 'CA', '97544', 415,'677-9312', 7521, 3000, 'Contactar amb el representant sobre la nova linia de raquetes de tenis.'),
        (default, 'CADA MUNTANYA', '574 SURRY RD.', 'CUPERTINO', 'CA', '93301', 408,'996-2323', 7499, 10000,'CLIENTS amb una quota de mercat molt elevada (23%) a causa de la publicitat agressiva.'),
        (default, 'ESPORTS TKB', '3476 EL PASEO', 'SANTA CLARA', 'CA', '91003', 408, '376-9966', 7844, 5000, 'Acostuma a demanar grans quantitats de mercaderia alhora. La comptabilitat esta considerant augmentar el seu limit de credit. Normalment es paga a temps.'),
        (default, 'POSAR_SE EN FORMA', '908 SEQUOIA', 'PALO ALTO', 'CA', '94301', 415,'364-9777', 7521, 6000, 'Suport intensiu. Comandes petites quantitats (< 800) de mercaderia alhora.'),
        (default, 'ESPORTS FEMENINS', 'VALCO VILLAGE', 'SUNNYVALE', 'CA', '93301', 408, '967-4398', 7499, 10000, 'Primera botiga amb articles esportius adressada exclusivament a dones. Promocio amb un estil inusual i molt disposat a arriscar-se amb nous PRODUCTESS!'),
        (default, 'CENTRE DE PROVESTIMENT DE SALUT I FITNESS DEL NORD', '98 LONE PINE WAY', 'HIBBING', 'MN', '55649', 612, '566-9123', 7844, 8000, ''),
        (default, 'CENTRAL NUCLEAR DE VANDELLOS', '13 PERCEBE STR.', 'SPRINGFIELD', 'NT', '0000', 636, '999-6666', NULL, 10000, '');


INSERT INTO PRODUCTES VALUES
        (default, 'RAQUETA DE TENIS FEMENINA I'),
        (default, 'RAQUETA DE TENIS ACE II'),
        (default, 'PACK DE 3 PILOTES DE TENIS ACE'),
        (default, 'PACK DE 6 PILOTES DE TENIS ACE'),
        (default, 'XARXA DE TENIS ACE'),
        (default, 'RAQUETA DE TENIS SP'),
        (default, 'RAQUETA SP JUNIOR'),
        (default, 'RH: "GUIDE TO TENIS"'),
        (default, 'SB ENERGY PACK DE 6 BARRETES'),
        (default, 'SB VITA PACK DE 6 SNACKS');

INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2017-01-07','A' ,'2017-01-08', codi_client, 101.4 FROM CLIENTS WHERE nom_client='BOTIGA ESPORTS TKB' LIMIT 1;
INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2017-01-11','B' ,'2017-01-11', codi_client, 45 FROM CLIENTS WHERE nom_client='VOLLEI RITA' LIMIT 1;
INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2017-01-15','C' ,'2017-01-20', codi_client, 5860 FROM CLIENTS WHERE nom_client='CADA MUNTANYA' LIMIT 1;
INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2016-05-01','A' ,'2016-05-30', codi_client, 2.4 FROM CLIENTS WHERE nom_client='POSAR_SE EN FORMA' LIMIT 1;
INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2016-06-05','B' ,'2016-06-20', codi_client, 56 FROM CLIENTS WHERE nom_client='VOLLEI RITA' LIMIT 1;
INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2016-06-15','A' ,'2016-06-30', codi_client, 698 FROM CLIENTS WHERE nom_client='POSAR_SE EN FORMA' LIMIT 1;
INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2016-07-14','A' ,'2016-07-30', codi_client, 8324 FROM CLIENTS WHERE nom_client='POSAR_SE EN FORMA' LIMIT 1;
INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2016-07-14','A' ,'2016-07-30', codi_client, 3.4 FROM CLIENTS WHERE nom_client='Esports Grebol' LIMIT 1;
INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2016-08-01','B' ,'2016-08-15', codi_client, 97.5 FROM CLIENTS WHERE nom_client='Esports Grebol' LIMIT 1;
INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2016-07-18','C' ,'2016-07-18', codi_client, 5.6 FROM CLIENTS WHERE nom_client='CADA MUNTANYA' LIMIT 1;
INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2016-07-25','C' ,'2016-07-25', codi_client, 35.2 FROM CLIENTS WHERE nom_client='CADA MUNTANYA' LIMIT 1;
INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2016-06-05',NULL,'2016-06-05', codi_client, 224 FROM CLIENTS WHERE nom_client='VOLLEI RITA' LIMIT 1;
INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2017-03-12',NULL,'2017-03-12', codi_client, 4450 FROM CLIENTS WHERE nom_client='Esports Grebol' LIMIT 1;
INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2017-02-01',NULL,'2017-02-01', codi_client, 6400 FROM CLIENTS WHERE nom_client='CENTRE DE PROVESTIMENT DE SALUT I FITNESS DEL NORD' LIMIT 1;
INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2017-02-01',NULL,'2017-02-05', codi_client, 23940 FROM CLIENTS WHERE nom_client='VOLLEI RITA' LIMIT 1;
INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2017-02-03',NULL,'2017-02-10', codi_client, 764 FROM CLIENTS WHERE nom_client='NOMES TENIS' LIMIT 1;
INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2017-02-22',NULL,'2017-02-04', codi_client, 1260 FROM CLIENTS WHERE nom_client='CADA MUNTANYA' LIMIT 1;
INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2017-02-05',NULL,'2017-03-03', codi_client, 46370 FROM CLIENTS WHERE nom_client='CADA MUNTANYA' LIMIT 1;
INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2017-02-01',NULL,'2017-02-06', codi_client, 710 FROM CLIENTS WHERE nom_client='ESPORTS FEMENINS' LIMIT 1;
INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2017-02-15','A' ,'2017-03-06', codi_client, 3510.5 FROM CLIENTS WHERE nom_client='VOLLEI RITA' LIMIT 1;
INSERT INTO COMANDES(data_comanda,tipus_comanda,data_tramesa_comanda,codi_cli_cda,total_comanda) SELECT '2017-03-15','A' ,'2017-01-01', codi_client, 730 FROM CLIENTS WHERE nom_client='Esports Grebol' LIMIT 1;



INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 3, codi_producte , 58, 1, 58 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-01-07' AND tipus_comanda= 'A' AND data_tramesa_comanda='2017-01-08' AND total_comanda=101.4   AND desc_producte = 'XARXA DE TENIS ACE' LIMIT 1; 
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 1, codi_producte , 45, 1, 45 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-01-11' AND tipus_comanda= 'B' AND data_tramesa_comanda='2017-01-11' AND total_comanda=45      AND desc_producte = 'RAQUETA DE TENIS ACE II' LIMIT 1; 
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 1, codi_producte , 30, 100, 3000 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-01-15' AND tipus_comanda= 'C' AND data_tramesa_comanda='2017-01-20' AND total_comanda=5860    AND  desc_producte = 'RAQUETA DE TENIS FEMENINA I' LIMIT 1; 
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 1, codi_producte , 2.4, 1, 2.4 FROM  COMANDES,PRODUCTES WHERE data_comanda='2016-05-01' AND tipus_comanda= 'A' AND data_tramesa_comanda='2016-05-30' AND total_comanda=2.4     AND desc_producte = 'SB ENERGY PACK DE 6 BARRETES' LIMIT 1; 
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 1, codi_producte , 2.8, 20, 56 FROM  COMANDES,PRODUCTES WHERE data_comanda='2016-06-05' AND tipus_comanda= 'B' AND data_tramesa_comanda='2016-06-20' AND total_comanda=56      AND desc_producte = 'PACK DE 3 PILOTES DE TENIS ACE' LIMIT 1; 
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 1, codi_producte , 58, 3, 174 FROM  COMANDES,PRODUCTES WHERE data_comanda='2016-06-15' AND tipus_comanda= 'A' AND data_tramesa_comanda='2016-06-30' AND total_comanda=698     AND desc_producte = 'XARXA DE TENIS ACE' LIMIT 1; 
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 2, codi_producte , 42, 2, 84 FROM  COMANDES,PRODUCTES WHERE data_comanda='2016-06-15' AND tipus_comanda= 'A' AND data_tramesa_comanda='2016-06-30' AND total_comanda=698     AND desc_producte = 'RAQUETA DE TENIS ACE II' LIMIT 1; 
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 3, codi_producte , 44, 10, 440 FROM  COMANDES,PRODUCTES WHERE data_comanda='2016-06-15' AND tipus_comanda= 'A' AND data_tramesa_comanda='2016-06-30' AND total_comanda=698     AND  desc_producte = 'RAQUETA DE TENIS FEMENINA I' LIMIT 1; 
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 2, codi_producte , 56, 4, 224 FROM  COMANDES,PRODUCTES WHERE data_comanda='2016-06-05' AND data_tramesa_comanda='2016-06-05' AND total_comanda=224     AND  desc_producte = 'RAQUETA DE TENIS FEMENINA I' LIMIT 1; 
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 1, codi_producte , 35, 1, 35 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-01-07' AND tipus_comanda= 'A' AND data_tramesa_comanda='2017-01-08' AND total_comanda=101.4   AND  desc_producte = 'RAQUETA DE TENIS FEMENINA I' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 2, codi_producte , 2.8, 3, 8.4 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-01-07' AND tipus_comanda= 'A' AND data_tramesa_comanda='2017-01-08' AND total_comanda=101.4   AND desc_producte = 'PACK DE 3 PILOTES DE TENIS ACE' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 4, codi_producte , 2.2, 200, 440 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-01' AND data_tramesa_comanda='2017-02-01' AND total_comanda=6400    AND desc_producte = 'SB ENERGY PACK DE 6 BARRETES' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 1, codi_producte , 35, 444, 15540 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-01' AND data_tramesa_comanda='2017-02-05' AND total_comanda=23940   AND  desc_producte = 'RAQUETA DE TENIS FEMENINA I' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 2, codi_producte , 2.8, 1000, 2800 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-01' AND data_tramesa_comanda='2017-02-05' AND total_comanda=23940   AND desc_producte = 'PACK DE 3 PILOTES DE TENIS ACE' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 2, codi_producte , 40.5, 20, 810 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-01-15' AND tipus_comanda= 'C' AND data_tramesa_comanda='2017-01-20' AND total_comanda=5860    AND desc_producte = 'RAQUETA DE TENIS ACE II' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 3, codi_producte , 10, 150, 1500 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-01-15' AND tipus_comanda= 'C' AND data_tramesa_comanda='2017-01-20' AND total_comanda=5860    AND desc_producte = 'RAQUETA SP JUNIOR' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 1, codi_producte , 35, 10, 350 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-03-12' AND data_tramesa_comanda='2017-03-12' AND total_comanda=4450    AND  desc_producte = 'RAQUETA DE TENIS FEMENINA I' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 2, codi_producte , 2.4, 1000, 2400 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-03-12' AND data_tramesa_comanda='2017-03-12' AND total_comanda=4450    AND desc_producte = 'SB ENERGY PACK DE 6 BARRETES' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 3, codi_producte , 3.4, 500, 1700 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-03-12' AND data_tramesa_comanda='2017-03-12' AND total_comanda=4450    AND desc_producte = 'RH: "GUIDE TO TENIS"' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 1, codi_producte , 5.6, 100, 560 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-01' AND data_tramesa_comanda='2017-02-01' AND total_comanda=6400    AND desc_producte = 'PACK DE 6 PILOTES DE TENIS ACE' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 2, codi_producte , 24, 200, 4800 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-01' AND data_tramesa_comanda='2017-02-01' AND total_comanda=6400    AND desc_producte = 'RAQUETA DE TENIS SP' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 3, codi_producte , 4, 150, 600 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-01' AND data_tramesa_comanda='2017-02-01' AND total_comanda=6400    AND desc_producte = 'SB VITA PACK DE 6 SNACKS' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 3, codi_producte , 3.4, 100, 340 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-22' AND data_tramesa_comanda='2017-02-04' AND total_comanda=1260    AND desc_producte = 'RH: "GUIDE TO TENIS"' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 1, codi_producte , 35, 50, 1750 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-05' AND data_tramesa_comanda='2017-03-03' AND total_comanda=46370   AND  desc_producte = 'RAQUETA DE TENIS FEMENINA I' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 2, codi_producte , 45, 100, 4500 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-05' AND data_tramesa_comanda='2017-03-03' AND total_comanda=46370   AND desc_producte = 'RAQUETA DE TENIS ACE II' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 3, codi_producte , 5.6, 1000, 5600 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-01' AND data_tramesa_comanda='2017-02-05' AND total_comanda=23940   AND desc_producte = 'PACK DE 6 PILOTES DE TENIS ACE' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 1, codi_producte , 45, 10, 450 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-03' AND data_tramesa_comanda='2017-02-10' AND total_comanda=764     AND desc_producte = 'RAQUETA DE TENIS ACE II' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 2, codi_producte , 2.8, 50, 140 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-03' AND data_tramesa_comanda='2017-02-10' AND total_comanda=764     AND desc_producte = 'PACK DE 3 PILOTES DE TENIS ACE' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 3, codi_producte , 58, 2, 116 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-03' AND data_tramesa_comanda='2017-02-10' AND total_comanda=764     AND desc_producte = 'XARXA DE TENIS ACE' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 4, codi_producte , 3.4, 10, 34 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-03' AND data_tramesa_comanda='2017-02-10' AND total_comanda=764     AND desc_producte = 'RH: "GUIDE TO TENIS"' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 5, codi_producte , 2.4, 10, 24 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-03' AND data_tramesa_comanda='2017-02-10' AND total_comanda=764     AND desc_producte = 'SB ENERGY PACK DE 6 BARRETES' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 1, codi_producte , 4, 100, 400 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-22' AND data_tramesa_comanda='2017-02-04' AND total_comanda=1260    AND desc_producte = 'SB VITA PACK DE 6 SNACKS' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 2, codi_producte , 2.4, 100, 240 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-22' AND data_tramesa_comanda='2017-02-04' AND total_comanda=1260    AND desc_producte = 'SB ENERGY PACK DE 6 BARRETES' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 1, codi_producte , 45, 4, 180 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-01' AND data_tramesa_comanda='2017-02-06' AND total_comanda=710     AND desc_producte = 'RAQUETA DE TENIS ACE II' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 1, codi_producte , 5.6, 1, 5.6 FROM  COMANDES,PRODUCTES WHERE data_comanda='2016-07-18' AND tipus_comanda= 'C' AND data_tramesa_comanda='2016-07-18' AND total_comanda=5.6     AND desc_producte = 'PACK DE 6 PILOTES DE TENIS ACE' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 2, codi_producte , 2.8, 100, 280 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-01' AND data_tramesa_comanda='2017-02-06' AND total_comanda=710     AND desc_producte = 'PACK DE 3 PILOTES DE TENIS ACE' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 3, codi_producte , 2.8, 500, 1400 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-05' AND data_tramesa_comanda='2017-03-03' AND total_comanda=46370   AND desc_producte = 'PACK DE 3 PILOTES DE TENIS ACE' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 4, codi_producte , 5.6, 500, 2800 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-05' AND data_tramesa_comanda='2017-03-03' AND total_comanda=46370   AND desc_producte = 'PACK DE 6 PILOTES DE TENIS ACE' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 5, codi_producte , 58, 500, 29000 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-05' AND data_tramesa_comanda='2017-03-03' AND total_comanda=46370   AND desc_producte = 'XARXA DE TENIS ACE' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 6, codi_producte , 24, 100, 2400 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-05' AND data_tramesa_comanda='2017-03-03' AND total_comanda=46370   AND desc_producte = 'RAQUETA DE TENIS SP' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 7, codi_producte , 12.5, 200, 2500 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-05' AND data_tramesa_comanda='2017-03-03' AND total_comanda=46370   AND desc_producte = 'RAQUETA SP JUNIOR' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 8, codi_producte , 3.4, 100, 340 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-05' AND data_tramesa_comanda='2017-03-03' AND total_comanda=46370   AND desc_producte = 'RH: "GUIDE TO TENIS"' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 9, codi_producte , 2.4, 200, 480 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-05' AND data_tramesa_comanda='2017-03-03' AND total_comanda=46370   AND desc_producte = 'SB ENERGY PACK DE 6 BARRETES' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 10,codi_producte , 4, 300, 1200 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-05' AND data_tramesa_comanda='2017-03-03' AND total_comanda=46370   AND desc_producte = 'SB VITA PACK DE 6 SNACKS' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 2, codi_producte , 2.5, 5, 12.5 FROM  COMANDES,PRODUCTES WHERE data_comanda='2016-08-01' AND tipus_comanda= 'B' AND data_tramesa_comanda='2016-08-15' AND total_comanda=97.5    AND desc_producte = 'PACK DE 3 PILOTES DE TENIS ACE' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 3, codi_producte , 50, 1, 50 FROM  COMANDES,PRODUCTES WHERE data_comanda='2016-08-01' AND tipus_comanda= 'B' AND data_tramesa_comanda='2016-08-15' AND total_comanda=97.5    AND desc_producte = 'XARXA DE TENIS ACE' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 1, codi_producte , 35, 23, 805 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-15' AND tipus_comanda= 'A' AND data_tramesa_comanda='2017-03-06' AND total_comanda=3510.5  AND  desc_producte = 'RAQUETA DE TENIS FEMENINA I' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 2, codi_producte , 45.11, 50, 2255.5 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-15' AND tipus_comanda= 'A' AND data_tramesa_comanda='2017-03-06' AND total_comanda=3510.5  AND desc_producte = 'RAQUETA DE TENIS ACE II' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 3, codi_producte , 45, 10, 450 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-15' AND tipus_comanda= 'A' AND data_tramesa_comanda='2017-03-06' AND total_comanda=3510.5  AND desc_producte = 'PACK DE 3 PILOTES DE TENIS ACE' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 1, codi_producte , 45, 10, 450 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-03-15' AND tipus_comanda= 'A' AND data_tramesa_comanda='2017-01-01' AND total_comanda=730     AND desc_producte = 'RAQUETA DE TENIS ACE II' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 2, codi_producte , 2.8, 100, 280 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-03-15' AND tipus_comanda= 'A' AND data_tramesa_comanda='2017-01-01' AND total_comanda=730     AND desc_producte = 'PACK DE 3 PILOTES DE TENIS ACE' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 3, codi_producte , 5, 50, 250 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-02-01' AND data_tramesa_comanda='2017-02-06' AND total_comanda=710     AND desc_producte = 'PACK DE 6 PILOTES DE TENIS ACE' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 1, codi_producte , 24, 1, 24 FROM  COMANDES,PRODUCTES WHERE data_comanda='2016-07-25' AND tipus_comanda= 'C' AND data_tramesa_comanda='2016-07-25' AND total_comanda=35.2    AND desc_producte = 'RAQUETA DE TENIS SP' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 2, codi_producte , 5.6, 2, 11.2 FROM  COMANDES,PRODUCTES WHERE data_comanda='2016-07-25' AND tipus_comanda= 'C' AND data_tramesa_comanda='2016-07-25' AND total_comanda=35.2    AND desc_producte = 'PACK DE 6 PILOTES DE TENIS ACE' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 1, codi_producte , 35, 1, 35 FROM  COMANDES,PRODUCTES WHERE data_comanda='2016-08-01' AND tipus_comanda= 'B' AND data_tramesa_comanda='2016-08-15' AND total_comanda=97.5    AND desc_producte = 'RAQUETA DE TENIS ACE II' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 1, codi_producte , 3.4, 1, 3.4 FROM  COMANDES,PRODUCTES WHERE data_comanda='2016-07-14' AND tipus_comanda= 'A' AND data_tramesa_comanda='2016-07-30' AND total_comanda=3.4     AND desc_producte = 'RH: "GUIDE TO TENIS"' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 1, codi_producte , 45, 100, 4500 FROM  COMANDES,PRODUCTES WHERE data_comanda='2016-07-14' AND tipus_comanda= 'A' AND data_tramesa_comanda='2016-07-30' AND total_comanda=8324    AND desc_producte = 'RAQUETA DE TENIS ACE II' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 2, codi_producte , 2.8, 500, 1400 FROM  COMANDES,PRODUCTES WHERE data_comanda='2016-07-14' AND tipus_comanda= 'A' AND data_tramesa_comanda='2016-07-30' AND total_comanda=8324    AND desc_producte = 'PACK DE 3 PILOTES DE TENIS ACE' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 3, codi_producte , 58, 5, 290 FROM  COMANDES,PRODUCTES WHERE data_comanda='2016-07-14' AND tipus_comanda= 'A' AND data_tramesa_comanda='2016-07-30' AND total_comanda=8324    AND desc_producte = 'XARXA DE TENIS ACE' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 4, codi_producte , 24, 50, 1200 FROM  COMANDES,PRODUCTES WHERE data_comanda='2016-07-14' AND tipus_comanda= 'A' AND data_tramesa_comanda='2016-07-30' AND total_comanda=8324    AND desc_producte = 'RAQUETA DE TENIS SP' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 5, codi_producte , 9, 100, 900 FROM  COMANDES,PRODUCTES WHERE data_comanda='2016-07-14' AND tipus_comanda= 'A' AND data_tramesa_comanda='2016-07-30' AND total_comanda=8324    AND desc_producte = 'RAQUETA SP JUNIOR' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 6, codi_producte , 3.4, 10, 34 FROM  COMANDES,PRODUCTES WHERE data_comanda='2016-07-14' AND tipus_comanda= 'A' AND data_tramesa_comanda='2016-07-30' AND total_comanda=8324    AND desc_producte = 'RH: "GUIDE TO TENIS"' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 4, codi_producte , 5.5, 100, 550 FROM  COMANDES,PRODUCTES WHERE data_comanda='2017-01-15' AND tipus_comanda= 'C' AND data_tramesa_comanda='2017-01-20' AND total_comanda=5860    AND desc_producte = 'PACK DE 6 PILOTES DE TENIS ACE' LIMIT 1;
INSERT INTO DETALLS_COMANDA (codi_comanda,num_detall,codi_prod_cda,preu_prod_cda,quantitat_prod_cda,import_prod_cda)  SELECT codi_comanda, 4, codi_producte , 5.6, 50, 280 FROM COMANDES,PRODUCTES WHERE data_comanda='2017-02-22' AND data_tramesa_comanda='2017-02-04' AND total_comanda=1260    AND desc_producte = 'PACK DE 6 PILOTES DE TENIS ACE' LIMIT 1;
