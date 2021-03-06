--  Created by: Markus A. Litters
--  Created:    03.08.2020

CREATE SCHEMA IBMSQL ; 
  
GRANT CREATEIN , USAGE   
ON SCHEMA IBMSQL 
TO PUBLIC ; 
  
GRANT CREATEIN , USAGE   
ON SCHEMA IBMSQL 
TO QWSERVICE ; 
  
  
CREATE TABLE IBMSQL.CUSTOMERS ( 
	CUSTOMERID FOR COLUMN CUSTID     BIGINT GENERATED ALWAYS AS IDENTITY ( 
	START WITH 1 INCREMENT BY 1 
	NO MINVALUE NO MAXVALUE 
	NO CYCLE NO ORDER 
	CACHE 20 ) 
	, 
	CUSTOMERNUMBER FOR COLUMN CUSTNO     INTEGER NOT NULL , 
	CUSTOMERNAME FOR COLUMN CUSTNAME   VARCHAR(128) CCSID 273 NOT NULL , 
	CONSTRAINT IBMSQL.Q_IBMSQL_CUSTOMERS_CUSTID_00001 PRIMARY KEY( CUSTOMERID ) ) 	  
	  
	RCDFMT CUSTOMERS  ; 
  
ALTER TABLE IBMSQL.CUSTOMERS 
	ADD CONSTRAINT IBMSQL.Q_IBMSQL_CUSTOMERS_CUSTNO_00001 
	UNIQUE( CUSTOMERNUMBER ) ; 
  
LABEL ON TABLE IBMSQL.CUSTOMERS 
	IS 'Customers' ; 
  
LABEL ON COLUMN IBMSQL.CUSTOMERS 
( CUSTOMERID IS 'Customer Id          ' , 
	CUSTOMERNUMBER IS 'Customer Number      ' , 
	CUSTOMERNAME IS 'Customer Name        ' ) ; 
  
LABEL ON COLUMN IBMSQL.CUSTOMERS 
( CUSTOMERID TEXT IS 'Unique Id' , 
	CUSTOMERNUMBER TEXT IS 'Customer Number' , 
	CUSTOMERNAME TEXT IS 'Customer Name' ) ; 
   
GRANT DELETE , INSERT , SELECT , UPDATE   
ON IBMSQL.CUSTOMERS TO QWSERVICE ; 
  
  
CREATE TABLE IBMSQL.ORDERHEAD ( 
	ORDERID BIGINT GENERATED ALWAYS AS IDENTITY ( 
	START WITH 1 INCREMENT BY 1 
	NO MINVALUE NO MAXVALUE 
	NO CYCLE NO ORDER 
	CACHE 20 ) 
	, 
	ORDERNUMBER FOR COLUMN ORDERNO    BIGINT NOT NULL , 
	CUSTOMERNUMBER FOR COLUMN CUSTNO     INTEGER NOT NULL , 
	ORDERDATE DATE NOT NULL DEFAULT CURRENT_DATE , 
	CONSTRAINT IBMSQL.Q_IBMSQL_ORDERHEAD_ORDERID_00001 PRIMARY KEY( ORDERID ) ) 	
	  
	RCDFMT ORDERHEADF ; 
  
ALTER TABLE IBMSQL.ORDERHEAD 
	ADD CONSTRAINT IBMSQL.Q_IBMSQL_ORDERHEAD_ORDER00001_00001 
	UNIQUE( ORDERNUMBER ) ; 
  
LABEL ON TABLE IBMSQL.ORDERHEAD 
	IS 'Order Header' ; 
  
LABEL ON COLUMN IBMSQL.ORDERHEAD 
( ORDERID IS 'Order Id             ' , 
	ORDERNUMBER IS 'Order Number         ' , 
	CUSTOMERNUMBER IS 'Customer  Number     ' , 
	ORDERDATE IS 'Order Date           ' ) ; 
  
LABEL ON COLUMN IBMSQL.ORDERHEAD 
( ORDERID TEXT IS 'Unique Id' , 
	ORDERNUMBER TEXT IS 'Order Number' , 
	CUSTOMERNUMBER TEXT IS 'Customer Number' , 
	ORDERDATE TEXT IS 'Order Date' ) ; 
    
GRANT DELETE , INSERT , SELECT , UPDATE   
ON IBMSQL.ORDERHEAD TO QWSERVICE ; 
  
  
CREATE TABLE IBMSQL.ORDERPOSITION FOR SYSTEM NAME ORDERPOS ( 
	ORDERID BIGINT GENERATED ALWAYS AS IDENTITY ( 
	START WITH 1 INCREMENT BY 1 
	NO MINVALUE NO MAXVALUE 
	NO CYCLE NO ORDER 
	CACHE 20 ) 
	, 
	ORDERNUMBER FOR COLUMN ORDERNO    BIGINT NOT NULL , 
	ORDERPOSITION FOR COLUMN ORDER00001 INTEGER NOT NULL , 
	ARTICLENUMBER FOR COLUMN ARTICLENO  INTEGER NOT NULL , 
	QUANTITY INTEGER NOT NULL , 
	PRICE DECIMAL(10, 2) NOT NULL , 
	CONSTRAINT IBMSQL.Q_IBMSQL_ORDERPOS_ORDERID_00001 PRIMARY KEY( ORDERID ) )   
	  
	RCDFMT ORDERPOS   ; 
  
ALTER TABLE IBMSQL.ORDERPOSITION 
	ADD CONSTRAINT IBMSQL.Q_IBMSQL_ORDERPOS_ORDER00001_00001 
	UNIQUE( ORDERNUMBER , ORDERPOSITION ) ; 
  
LABEL ON TABLE IBMSQL.ORDERPOSITION 
	IS 'Order Position' ; 
  
LABEL ON COLUMN IBMSQL.ORDERPOSITION 
( ORDERID IS 'Order Id             ' , 
	ORDERNUMBER IS 'Order Number         ' , 
	ORDERPOSITION IS 'Order Position       ' , 
	ARTICLENUMBER IS 'Article Number       ' , 
	QUANTITY IS 'Quantity             ' , 
	PRICE IS 'Price                ' ) ; 
  
LABEL ON COLUMN IBMSQL.ORDERPOSITION 
( ORDERID TEXT IS 'Unique Id' , 
	ORDERNUMBER TEXT IS 'Order Number' , 
	ORDERPOSITION TEXT IS 'Order Position' , 
	ARTICLENUMBER TEXT IS 'Article Number' , 
	QUANTITY TEXT IS 'Quantity' , 
	PRICE TEXT IS 'Price' ) ; 
    
GRANT DELETE , INSERT , SELECT , UPDATE   
ON IBMSQL.ORDERPOSITION TO QWSERVICE ; 
  
  
CREATE TABLE IBMSQL.QSQDSRC ( 
--  SQL150B   10   REUSEDLT(*NO) in Tabelle QSQDSRC in IBMSQL ignoriert. 
	SRCSEQ NUMERIC(6, 2) NOT NULL DEFAULT 0 , 
	SRCDAT NUMERIC(6, 0) NOT NULL DEFAULT 0 , 
	SRCDTA CHAR(148) CCSID 273 NOT NULL DEFAULT '' )   
	  
	RCDFMT QSQDSRC    ; 
  
LABEL ON TABLE IBMSQL.QSQDSRC 
	IS 'SQL PROCEDURES' ; 
  
GRANT ALTER , DELETE , INDEX , INSERT , REFERENCES , SELECT , UPDATE   
ON IBMSQL.QSQDSRC TO LITTERSMA WITH GRANT OPTION ; 
  
GRANT DELETE , INSERT , SELECT , UPDATE   
ON IBMSQL.QSQDSRC TO PUBLIC ; 
  
GRANT DELETE , INSERT , SELECT , UPDATE   
ON IBMSQL.QSQDSRC TO QWSERVICE ; 
  
  
SET PATH "QSYS","QSYS2","SYSPROC","SYSIBMADM"; 
  
CREATE PROCEDURE IBMSQL.ADDORDER ( 
	IN JSONDATA VARCHAR(32000) ) 
	LANGUAGE SQL 
	SPECIFIC IBMSQL.ADDORDER 
	NOT DETERMINISTIC 
	MODIFIES SQL DATA 
	CALLED ON NULL INPUT 
	SET OPTION  ALWBLK = *ALLREAD , 
	ALWCPYDTA = *OPTIMIZE , 
	COMMIT = *NONE , 
	DBGVIEW = *SOURCE , 
	DECRESULT = (31, 31, 00) , 
	DYNDFTCOL = *NO , 
	DYNUSRPRF = *USER , 
	SRTSEQ = *HEX   
	BEGIN 
DECLARE SQLSTATE CHAR ( 5 ) ; 
DECLARE SQLCODE INTEGER ; 
DECLARE EXIT HANDLER FOR SQLEXCEPTION 
   /* enter your error handling here */
  
INSERT INTO IBMSQL . ORDERHEAD ( ORDERNUMBER , CUSTOMERNUMBER , ORDERDATE ) VALUES ( JSON_VALUE ( JSONDATA , '$.ordernumber' RETURNING BIGINT ) , 
JSON_VALUE ( JSONDATA , '$.customer.customernumber' RETURNING INTEGER ) , JSON_VALUE ( JSONDATA , '$.date' RETURNING DATE ) ) ; 
  
INSERT INTO IBMSQL . ORDERPOSITION ( ORDERNUMBER , ORDERPOSITION , ARTICLENUMBER , QUANTITY , PRICE ) SELECT J . ORDERNUMBER , J . ORDERPOSITION , J . ARTICLENUMBER , 
J . QUANTITY , J . PRICE FROM 
JSON_TABLE ( JSONDATA , '$' COLUMNS ( 
ORDERNUMBER BIGINT PATH '$.ordernumber' , 
NESTED PATH '$.positions[*]' 
COLUMNS ( 
ORDERPOSITION INTEGER PATH '$.position' , 
ARTICLENUMBER INTEGER PATH '$.articlenumber' , 
QUANTITY INTEGER PATH '$.quantity' , 
PRICE DECIMAL ( 10 , 2 ) PATH '$.price' ) 
) ) 
AS J ; 
END  ; 
   
GRANT EXECUTE   
ON SPECIFIC PROCEDURE IBMSQL.ADDORDER 
TO QWSERVICE ; 

CREATE VIEW IBMSQL.JSONORDER ( 
	JSONDATA ) 
	AS 
	SELECT JSON_ARRAYAGG(JSON_OBJECT ('ordernumber' VALUE OH.ORDERNUMBER, 
	'date' VALUE OH.ORDERDATE, 
	'customer' VALUE JSON_OBJECT ( 
	 'customernumber' VALUE OH.CUSTOMERNUMBER, 
	 'customername' VALUE C.CUSTOMERNAME) FORMAT JSON, 
	'positions' VALUE (SELECT JSON_ARRAYAGG ( 
	 JSON_OBJECT( 
	 'position' VALUE ORDERPOSITION, 
	 'articlenumber' VALUE ARTICLENUMBER, 
	 'quantity' VALUE QUANTITY, 
	 'price' VALUE PRICE) 
	 ) FROM IBMSQL.ORDERPOS OP WHERE OH.ORDERNUMBER = OP.ORDERNUMBER GROUP BY ORDERNUMBER) FORMAT JSON)) 
	FROM IBMSQL.ORDERHEAD OH JOIN IBMSQL.CUSTOMERS C  
	ON OH.CUSTOMERNUMBER = C.CUSTOMERNUMBER   
	RCDFMT JSONORDER  ; 
   
