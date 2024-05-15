-- DROP SCHEMA reports;

CREATE SCHEMA reports AUTHORIZATION postgres;

-- DROP TYPE reports."operation";

CREATE TYPE reports."operation" AS ENUM (
	'debet',
	'kredit',
	'saldo');

-- DROP SEQUENCE reports.balance_id_balance_seq;

CREATE SEQUENCE reports.balance_id_balance_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE reports.balance_id_balance_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE reports.balance_id_balance_seq TO postgres;

-- DROP SEQUENCE reports.core_id_core_seq;

CREATE SEQUENCE reports.core_id_core_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE reports.core_id_core_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE reports.core_id_core_seq TO postgres;

-- DROP SEQUENCE reports.daybalance_id_daybalance_seq;

CREATE SEQUENCE reports.daybalance_id_daybalance_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE reports.daybalance_id_daybalance_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE reports.daybalance_id_daybalance_seq TO postgres;

-- DROP SEQUENCE reports.extbalance_id_extbalance_seq;

CREATE SEQUENCE reports.extbalance_id_extbalance_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE reports.extbalance_id_extbalance_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE reports.extbalance_id_extbalance_seq TO postgres;
GRANT SELECT, USAGE ON SEQUENCE reports.extbalance_id_extbalance_seq TO "Alef";

-- DROP SEQUENCE reports.finoperation_id_finoper_seq;

CREATE SEQUENCE reports.finoperation_id_finoper_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE reports.finoperation_id_finoper_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE reports.finoperation_id_finoper_seq TO postgres;

-- DROP SEQUENCE reports.job_qtranz_job_seq;

CREATE SEQUENCE reports.job_qtranz_job_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE reports.job_qtranz_job_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE reports.job_qtranz_job_seq TO postgres;
GRANT SELECT, USAGE ON SEQUENCE reports.job_qtranz_job_seq TO "Alef";

-- DROP SEQUENCE reports.payment_qrtanz_seq;

CREATE SEQUENCE reports.payment_qrtanz_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE reports.payment_qrtanz_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE reports.payment_qrtanz_seq TO postgres;
GRANT ALL ON SEQUENCE reports.payment_qrtanz_seq TO apis;
GRANT SELECT, USAGE ON SEQUENCE reports.payment_qrtanz_seq TO "Alef";
-- reports."!balance" определение

-- Drop table

-- DROP TABLE reports."!balance";

CREATE TABLE reports."!balance" (
	id_balance int8 DEFAULT nextval('reports.balance_id_balance_seq'::regclass) NOT NULL,
	amount int4 NULL,
	datetime timestamp(6) DEFAULT now() NULL,
	descript varchar(255) NULL,
	service varchar(5) DEFAULT '00'::character varying NULL,
	firm varchar(5) DEFAULT '00'::character varying NULL,
	region varchar(3) NULL,
	core varchar(10) NULL,
	"operation" reports."operation" NULL,
	id_parent int8 NULL,
	tbl_parent varchar(50) NULL,
	"uuid" varchar(50) NULL,
	CONSTRAINT balance_pkey PRIMARY KEY (id_balance)
);

-- Permissions

ALTER TABLE reports."!balance" OWNER TO postgres;
GRANT ALL ON TABLE reports."!balance" TO postgres;
GRANT UPDATE, INSERT, REFERENCES, SELECT, TRIGGER ON TABLE reports."!balance" TO "Alef" WITH GRANT OPTION;
GRANT UPDATE, INSERT, REFERENCES, SELECT, TRIGGER ON TABLE reports."!balance" TO "AlekzP" WITH GRANT OPTION;
GRANT UPDATE, INSERT, REFERENCES, SELECT, TRIGGER ON TABLE reports."!balance" TO apiw WITH GRANT OPTION;


-- reports."!extbalance" определение

-- Drop table

-- DROP TABLE reports."!extbalance";

CREATE TABLE reports."!extbalance" (
	id_extbalance int8 DEFAULT nextval('reports.extbalance_id_extbalance_seq'::regclass) NOT NULL,
	debet int4 DEFAULT 0 NULL,
	kredit int4 DEFAULT 0 NULL,
	saldo int4 DEFAULT 0 NULL,
	core varchar(12) NULL,
	"uuid" varchar(50) NULL,
	"date" date NULL,
	CONSTRAINT extbalance_pkey PRIMARY KEY (id_extbalance)
);

-- Permissions

ALTER TABLE reports."!extbalance" OWNER TO postgres;
GRANT ALL ON TABLE reports."!extbalance" TO postgres;
GRANT UPDATE, INSERT, REFERENCES, SELECT, TRIGGER, DELETE ON TABLE reports."!extbalance" TO "Alef" WITH GRANT OPTION;
GRANT UPDATE, INSERT, REFERENCES, SELECT, TRIGGER ON TABLE reports."!extbalance" TO "AlekzP" WITH GRANT OPTION;
GRANT UPDATE, INSERT, REFERENCES, SELECT, TRIGGER ON TABLE reports."!extbalance" TO apiw WITH GRANT OPTION;


-- reports.core определение

-- Drop table

-- DROP TABLE reports.core;

CREATE TABLE reports.core (
	id_core bigserial NOT NULL,
	core varchar(10) NULL,
	uuid_user varchar(50) NULL,
	CONSTRAINT core_pkey PRIMARY KEY (id_core)
);

-- Permissions

ALTER TABLE reports.core OWNER TO postgres;
GRANT ALL ON TABLE reports.core TO postgres;


-- reports.daybalance определение

-- Drop table

-- DROP TABLE reports.daybalance;

CREATE TABLE reports.daybalance (
	id_daybalance bigserial NOT NULL,
	saldo_yesterday int4 DEFAULT 0 NULL,
	debet int4 DEFAULT 0 NULL,
	credit int4 DEFAULT 0 NULL,
	saldo_today int4 DEFAULT 0 NULL,
	core varchar(12) NULL,
	"uuid" varchar(50) NULL,
	"date" date NULL,
	CONSTRAINT daybalance_pkey PRIMARY KEY (id_daybalance)
);

-- Permissions

ALTER TABLE reports.daybalance OWNER TO postgres;
GRANT ALL ON TABLE reports.daybalance TO postgres;
GRANT UPDATE, INSERT, REFERENCES, SELECT, TRIGGER ON TABLE reports.daybalance TO "Alef" WITH GRANT OPTION;
GRANT UPDATE, INSERT, REFERENCES, SELECT, TRIGGER ON TABLE reports.daybalance TO "AlekzP" WITH GRANT OPTION;
GRANT UPDATE, INSERT, REFERENCES, SELECT, TRIGGER ON TABLE reports.daybalance TO apiw WITH GRANT OPTION;


-- reports.finoperation определение

-- Drop table

-- DROP TABLE reports.finoperation;

CREATE TABLE reports.finoperation (
	id_finoper bigserial NOT NULL,
	amount_debet int4 NULL,
	amount_credit int4 NULL,
	datetime timestamp(6) DEFAULT now() NULL,
	descript varchar(255) NULL,
	service varchar(5) DEFAULT '00'::character varying NULL,
	firm varchar(50) DEFAULT '00'::character varying NULL,
	region varchar(3) NULL,
	core varchar(10) NULL,
	"operation" reports."operation" NULL,
	id_parent int8 NULL,
	tbl_parent varchar(50) NULL,
	"uuid" varchar(50) NULL,
	CONSTRAINT finoperation_pkey PRIMARY KEY (id_finoper)
);

-- Permissions

ALTER TABLE reports.finoperation OWNER TO postgres;
GRANT ALL ON TABLE reports.finoperation TO postgres;
GRANT UPDATE, INSERT, REFERENCES, SELECT, TRIGGER ON TABLE reports.finoperation TO "Alef" WITH GRANT OPTION;
GRANT UPDATE, INSERT, REFERENCES, SELECT, TRIGGER ON TABLE reports.finoperation TO "AlekzP" WITH GRANT OPTION;
GRANT UPDATE, INSERT, REFERENCES, SELECT, TRIGGER ON TABLE reports.finoperation TO apiw WITH GRANT OPTION;


-- reports.job определение

-- Drop table

-- DROP TABLE reports.job;

CREATE TABLE reports.job (
	qtranz_job bigserial NOT NULL,
	datetime varchar(20) DEFAULT now() NULL,
	service varchar(5) DEFAULT '00'::character varying NULL,
	firm varchar(6) DEFAULT '00'::character varying NULL,
	region varchar(3) DEFAULT '00'::character varying NULL,
	core varchar(10) DEFAULT '000000'::character varying NULL,
	amount int4 NULL,
	"uuid" varchar(50) NULL,
	CONSTRAINT job_pkey PRIMARY KEY (qtranz_job)
);

-- Table Triggers

create trigger tr_job_balance after
insert
    on
    reports.job for each row execute function reports.f_tr_job();

-- Permissions

ALTER TABLE reports.job OWNER TO postgres;
GRANT ALL ON TABLE reports.job TO postgres;
GRANT UPDATE, INSERT, REFERENCES, SELECT, TRIGGER ON TABLE reports.job TO "Alef";
GRANT UPDATE, INSERT, REFERENCES, SELECT, TRIGGER ON TABLE reports.job TO "AlekzP" WITH GRANT OPTION;
GRANT UPDATE, INSERT, REFERENCES, SELECT, TRIGGER ON TABLE reports.job TO apiw WITH GRANT OPTION;


-- reports.payment определение

-- Drop table

-- DROP TABLE reports.payment;

CREATE TABLE reports.payment (
	qtranz int4 DEFAULT nextval('reports.payment_qrtanz_seq'::regclass) NOT NULL,
	"year" int2 NOT NULL,
	idpaymerch jsonb NOT NULL,
	data_json jsonb NULL,
	answer jsonb DEFAULT '{}'::jsonb NULL,
	comm_json jsonb NULL,
	firm_json jsonb NULL,
	merch_json jsonb NULL,
	tarif_json jsonb NULL,
	e_kassa jsonb NULL,
	ekassa_id int8 DEFAULT 0 NULL,
	datetime timestamp(0) DEFAULT now() NULL
)
PARTITION BY RANGE (year);

-- Table Triggers

create trigger tr_payment_balance after
insert
    on
    reports.payment for each row execute function reports.f_tr_payment();

-- Permissions

ALTER TABLE reports.payment OWNER TO postgres;
GRANT ALL ON TABLE reports.payment TO postgres;
GRANT UPDATE, INSERT, REFERENCES, SELECT, TRIGGER ON TABLE reports.payment TO apis;
GRANT SELECT ON TABLE reports.payment TO alexr;
GRANT UPDATE, INSERT, REFERENCES, SELECT, TRIGGER ON TABLE reports.payment TO "AlekzP" WITH GRANT OPTION;
GRANT UPDATE, INSERT, REFERENCES, SELECT, TRIGGER ON TABLE reports.payment TO "Alef" WITH GRANT OPTION;
GRANT UPDATE, INSERT, REFERENCES, SELECT, TRIGGER ON TABLE reports.payment TO apiw WITH GRANT OPTION;


-- reports.payment_2023 определение

CREATE TABLE reports.payment_2023 PARTITION OF reports.payment (
	CONSTRAINT payment_2023_pkey PRIMARY KEY (idpaymerch)
) FOR VALUES FROM ('2023') TO ('2024');


-- reports.payment_2024 определение

CREATE TABLE reports.payment_2024 PARTITION OF reports.payment (
	CONSTRAINT payment_2024_pkey PRIMARY KEY (idpaymerch)
) FOR VALUES FROM ('2024') TO ('2025');


-- reports.payment_2025 определение

CREATE TABLE reports.payment_2025 PARTITION OF reports.payment (
	CONSTRAINT payment_2025_pkey PRIMARY KEY (idpaymerch)
) FOR VALUES FROM ('2025') TO ('2026');


-- reports.payment_2026 определение

CREATE TABLE reports.payment_2026 PARTITION OF reports.payment (
	CONSTRAINT payment_2026_pkey PRIMARY KEY (idpaymerch)
) FOR VALUES FROM ('2026') TO ('2027');


-- reports.payment_2027 определение

CREATE TABLE reports.payment_2027 PARTITION OF reports.payment (
	CONSTRAINT payment_2027_pkey PRIMARY KEY (idpaymerch)
) FOR VALUES FROM ('2027') TO ('2028');


-- reports.payment_2028 определение

CREATE TABLE reports.payment_2028 PARTITION OF reports.payment (
	CONSTRAINT payment_2028_pkey PRIMARY KEY (idpaymerch)
) FOR VALUES FROM ('2028') TO ('2029');


-- reports.payment_2029 определение

CREATE TABLE reports.payment_2029 PARTITION OF reports.payment (
	CONSTRAINT payment_2029_pkey PRIMARY KEY (idpaymerch)
) FOR VALUES FROM ('2029') TO ('2030');



-- DROP FUNCTION reports."!f_balance"(varchar);

CREATE OR REPLACE FUNCTION reports."!f_balance"(xuuid character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
	DECLARE
		xsaldo_in INTEGER;
		xdebet INTEGER;
		xkredit INTEGER;
BEGIN
  SELECT saldo INTO xsaldo_in FROM reports.extbalance 
	WHERE uuid = xuuid AND "date" = CURRENT_DATE - 1;
	SELECT (data_json ->> 'amount')::integer INTO xdebet FROM reports.payment 
	WHERE (data_json ->> 'uuid') = xuuid AND LEFT(data_json ->> 'datetime',10) = CURRENT_DATE::text; 
	SELECT amount INTO xkredit FROM reports.job; 
	RETURN xdebet;
END
$function$
;

-- Permissions

ALTER FUNCTION reports."!f_balance"(varchar) OWNER TO postgres;
GRANT ALL ON FUNCTION reports."!f_balance"(varchar) TO postgres;

-- DROP FUNCTION reports.f_count_balance(bpchar);

CREATE OR REPLACE FUNCTION reports.f_count_balance(xuuid character)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE
		xsaldo_json JSON DEFAULT '[]';
		xsum_debet INTEGER;
		xsum_credit INTEGER;
		xsaldo_in INTEGER; 
		xsaldo_curr INTEGER;
		xcore VARCHAR;
BEGIN
	FOR xcore IN (SELECT DISTINCT core FROM reports.daybalance 
	WHERE uuid = xuuid AND "date"::date = CURRENT_DATE)
		LOOP
			SELECT saldo_yesterday INTO xsaldo_in FROM reports.daybalance 
			WHERE core = xcore AND "date"::date = CURRENT_DATE;
			IF xsaldo_in IS NULL THEN xsaldo_in = 0; END IF;
			SELECT SUM(amount_debet),SUM(amount_credit) INTO xsum_debet,xsum_credit 
			FROM reports.finoperation WHERE core = xcore AND datetime::date = CURRENT_DATE;
			IF xsum_debet IS NULL THEN xsum_debet = 0; END IF;
			IF xsum_credit IS NULL THEN xsum_credit = 0; END IF; 
			xsaldo_curr := xsaldo_in + xsum_debet - xsum_credit;
			xsaldo_json := xsaldo_json::jsonb || jsonb_build_object('core',xcore,'saldo',xsaldo_curr);
		END LOOP;
		xsaldo_json := jsonb_build_object('uuid',xuuid,'balance',xsaldo_json);
	RETURN xsaldo_json;
END
$function$
;

-- Permissions

ALTER FUNCTION reports.f_count_balance(bpchar) OWNER TO postgres;
GRANT ALL ON FUNCTION reports.f_count_balance(bpchar) TO postgres;
GRANT ALL ON FUNCTION reports.f_count_balance(bpchar) TO "Alef";
GRANT ALL ON FUNCTION reports.f_count_balance(bpchar) TO "AlekzP";
GRANT ALL ON FUNCTION reports.f_count_balance(bpchar) TO apiw;

-- DROP FUNCTION reports.f_tr_job();

CREATE OR REPLACE FUNCTION reports.f_tr_job()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
	DECLARE
		xamount INTEGER;
		xid_qtranz INTEGER;
		xservice VARCHAR(5);
		xfirm VARCHAR(6);
		xregion VARCHAR (5);
		xcore VARCHAR (10);
		xuuid VARCHAR;
BEGIN
	SELECT NEW.amount,NEW.service,NEW.firm,NEW.region,NEW.core,NEW.qtranz_job,NEW.uuid 
	INTO xamount,xservice,xfirm,xregion,xcore,xid_qtranz,xuuid FROM reports.job;
  INSERT INTO reports.finoperation (amount_credit,datetime,descript,service,firm,region,core,"operation",id_parent,tbl_parent,uuid)
	VALUES (xamount,now(),'услуга',xservice,xfirm,xregion,xcore,'credit',xid_qtranz,'job',xuuid);
	RETURN NULL;
END
$function$
;

COMMENT ON FUNCTION reports.f_tr_job() IS 'Триггерная функция';

-- Permissions

ALTER FUNCTION reports.f_tr_job() OWNER TO postgres;
GRANT ALL ON FUNCTION reports.f_tr_job() TO postgres;
GRANT ALL ON FUNCTION reports.f_tr_job() TO "Alef";
GRANT ALL ON FUNCTION reports.f_tr_job() TO "AlekzP";
GRANT ALL ON FUNCTION reports.f_tr_job() TO apiw;

-- DROP FUNCTION reports.f_tr_payment();

CREATE OR REPLACE FUNCTION reports.f_tr_payment()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
	DECLARE
		xamount INTEGER;
		xid_qtranz INTEGER;
		xservice INTEGER;
		xnamefirm VARCHAR;
		xfirm VARCHAR(6);
		xregion VARCHAR (50);
		xcore VARCHAR (10);
		xmerchant VARCHAR;
BEGIN
	SELECT NEW.data_json ->> 'amount',(NEW.idpaymerch ->> 'merch')::integer,LEFT(NEW.data_json ->> 'principal',6),NEW.qtranz 
	INTO xamount,xservice,xcore,xid_qtranz FROM reports.payment;
	SELECT fljson_firm ->> 'namefirm', fljson_firm ->> 'city' INTO xnamefirm,xregion 
	FROM common.firmservice WHERE idfirm = xcore;
	SELECT accesuaries ->> 'name' INTO xmerchant 
	FROM common.merchant WHERE idmerch = xservice;
  INSERT INTO reports.finoperation (amount_debet,datetime,descript,service,firm,region,core,"operation",id_parent,tbl_parent,uuid)
	VALUES (xamount,now(),'пополнение',xmerchant,xnamefirm,xregion,xcore,'debet',xid_qtranz,'payment','пока пусто');
	RETURN NULL;
END
$function$
;

-- Permissions

ALTER FUNCTION reports.f_tr_payment() OWNER TO postgres;
GRANT ALL ON FUNCTION reports.f_tr_payment() TO postgres;
GRANT ALL ON FUNCTION reports.f_tr_payment() TO "Alef";
GRANT ALL ON FUNCTION reports.f_tr_payment() TO "AlekzP";
GRANT ALL ON FUNCTION reports.f_tr_payment() TO apiw;

-- DROP FUNCTION reports.f_tr_payment_test();

CREATE OR REPLACE FUNCTION reports.f_tr_payment_test()
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
	DECLARE
		xamount INTEGER;
		xid_qtranz INTEGER;
		xservice INTEGER;
		xnamefirm VARCHAR;
		xfirm VARCHAR(6);
		xregion VARCHAR(50);
		xcore VARCHAR(10);
		xmerchant VARCHAR;
BEGIN
	SELECT data_json ->> 'amount',(idpaymerch ->> 'merch')::integer,LEFT(data_json ->> 'principal',6),qtranz 
	INTO xamount,xservice,xcore,xid_qtranz FROM reports.payment WHERE qtranz = 2366;
	SELECT fljson_firm ->> 'namefirm', fljson_firm ->> 'city' INTO xnamefirm,xregion 
	FROM common.firmservice WHERE idfirm = xcore;
	SELECT accesuaries ->> 'name' INTO xmerchant 
	FROM common.merchant WHERE idmerch = xservice;
  INSERT INTO reports.finoperation (amount_debet,datetime,descript,service,firm,region,core,"operation",id_parent,tbl_parent,uuid)
	VALUES (xamount,now(),'пополнение',xmerchant,xnamefirm,xregion,xcore,'debet',xid_qtranz,'payment','пока пусто');
	RETURN xid_qtranz;
END
$function$
;

-- Permissions

ALTER FUNCTION reports.f_tr_payment_test() OWNER TO postgres;
GRANT ALL ON FUNCTION reports.f_tr_payment_test() TO postgres;


-- Permissions

GRANT ALL ON SCHEMA reports TO postgres;
GRANT USAGE ON SCHEMA reports TO apis;
GRANT USAGE ON SCHEMA reports TO apiataxi;
GRANT USAGE ON SCHEMA reports TO alexr;
GRANT USAGE ON SCHEMA reports TO "AlekzP";
GRANT USAGE ON SCHEMA reports TO "Alef";