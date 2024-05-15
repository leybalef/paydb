-- DROP SCHEMA public;

CREATE SCHEMA public AUTHORIZATION postgres14;

COMMENT ON SCHEMA public IS 'standard public schema';

-- DROP SEQUENCE public.t_24alltime_qtranz_seq;

CREATE SEQUENCE public.t_24alltime_qtranz_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_24alltime_qtranz_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_24alltime_qtranz_seq TO postgres;

-- DROP SEQUENCE public.t_breakesum_idbreake_seq;

CREATE SEQUENCE public.t_breakesum_idbreake_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_breakesum_idbreake_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_breakesum_idbreake_seq TO postgres;

-- DROP SEQUENCE public.t_ckassa_qtranz_seq;

CREATE SEQUENCE public.t_ckassa_qtranz_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_ckassa_qtranz_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_ckassa_qtranz_seq TO postgres;

-- DROP SEQUENCE public.t_commparam_idcommparam_seq;

CREATE SEQUENCE public.t_commparam_idcommparam_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_commparam_idcommparam_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_commparam_idcommparam_seq TO postgres;

-- DROP SEQUENCE public.t_commun_idcommun_seq;

CREATE SEQUENCE public.t_commun_idcommun_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_commun_idcommun_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_commun_idcommun_seq TO postgres;

-- DROP SEQUENCE public.t_department_id_seq;

CREATE SEQUENCE public.t_department_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_department_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_department_id_seq TO postgres;

-- DROP SEQUENCE public.t_descriptions_id_seq;

CREATE SEQUENCE public.t_descriptions_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_descriptions_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_descriptions_id_seq TO postgres;

-- DROP SEQUENCE public.t_firmservice_qtranz_seq;

CREATE SEQUENCE public.t_firmservice_qtranz_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_firmservice_qtranz_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_firmservice_qtranz_seq TO postgres;

-- DROP SEQUENCE public.t_groupusers_qtranz_seq;

CREATE SEQUENCE public.t_groupusers_qtranz_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_groupusers_qtranz_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_groupusers_qtranz_seq TO postgres;

-- DROP SEQUENCE public.t_merchant_idmerch_seq;

CREATE SEQUENCE public.t_merchant_idmerch_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_merchant_idmerch_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_merchant_idmerch_seq TO postgres;

-- DROP SEQUENCE public.t_onlinecassa_id_cassa_seq;

CREATE SEQUENCE public.t_onlinecassa_id_cassa_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_onlinecassa_id_cassa_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_onlinecassa_id_cassa_seq TO postgres;

-- DROP SEQUENCE public.t_paybarry_qtranz_seq;

CREATE SEQUENCE public.t_paybarry_qtranz_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_paybarry_qtranz_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_paybarry_qtranz_seq TO postgres;

-- DROP SEQUENCE public.t_payment2022_qtranz_seq;

CREATE SEQUENCE public.t_payment2022_qtranz_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2299999999
	START 2200000000
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_payment2022_qtranz_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_payment2022_qtranz_seq TO postgres;

-- DROP SEQUENCE public.t_payment2023_qtranz_seq;

CREATE SEQUENCE public.t_payment2023_qtranz_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2399999999
	START 2300000000
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_payment2023_qtranz_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_payment2023_qtranz_seq TO postgres;

-- DROP SEQUENCE public.t_payment2024_qtranz_seq;

CREATE SEQUENCE public.t_payment2024_qtranz_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2499999999
	START 2400000000
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_payment2024_qtranz_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_payment2024_qtranz_seq TO postgres;

-- DROP SEQUENCE public.t_payview_idpayview_seq;

CREATE SEQUENCE public.t_payview_idpayview_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_payview_idpayview_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_payview_idpayview_seq TO postgres;

-- DROP SEQUENCE public.t_qiwi_qtranz_seq;

CREATE SEQUENCE public.t_qiwi_qtranz_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_qiwi_qtranz_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_qiwi_qtranz_seq TO postgres;

-- DROP SEQUENCE public.t_qiwiequar_id_qiwiequar_seq;

CREATE SEQUENCE public.t_qiwiequar_id_qiwiequar_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_qiwiequar_id_qiwiequar_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_qiwiequar_id_qiwiequar_seq TO postgres;

-- DROP SEQUENCE public.t_rsbank_id_rsbank_seq;

CREATE SEQUENCE public.t_rsbank_id_rsbank_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_rsbank_id_rsbank_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_rsbank_id_rsbank_seq TO postgres;

-- DROP SEQUENCE public.t_sberequar_id_sberequar_seq;

CREATE SEQUENCE public.t_sberequar_id_sberequar_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_sberequar_id_sberequar_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_sberequar_id_sberequar_seq TO postgres;

-- DROP SEQUENCE public.t_sbersms_qtranz_seq;

CREATE SEQUENCE public.t_sbersms_qtranz_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_sbersms_qtranz_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_sbersms_qtranz_seq TO postgres;

-- DROP SEQUENCE public.t_service_id_service_seq;

CREATE SEQUENCE public.t_service_id_service_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_service_id_service_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_service_id_service_seq TO postgres;

-- DROP SEQUENCE public.t_skysend_qtranz_seq;

CREATE SEQUENCE public.t_skysend_qtranz_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_skysend_qtranz_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_skysend_qtranz_seq TO postgres;

-- DROP SEQUENCE public.t_tarif_idtarif_seq;

CREATE SEQUENCE public.t_tarif_idtarif_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_tarif_idtarif_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_tarif_idtarif_seq TO postgres;

-- DROP SEQUENCE public.t_tranztarif_idtranz_seq;

CREATE SEQUENCE public.t_tranztarif_idtranz_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_tranztarif_idtranz_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_tranztarif_idtranz_seq TO postgres;

-- DROP SEQUENCE public.t_usergroup_id_usergroup_seq;

CREATE SEQUENCE public.t_usergroup_id_usergroup_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_usergroup_id_usergroup_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_usergroup_id_usergroup_seq TO postgres;

-- DROP SEQUENCE public.t_users_qtranz_seq;

CREATE SEQUENCE public.t_users_qtranz_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE public.t_users_qtranz_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE public.t_users_qtranz_seq TO postgres;
-- public.t_24alltime определение

-- Drop table

-- DROP TABLE public.t_24alltime;

CREATE TABLE public.t_24alltime (
	qtranz serial4 NOT NULL,
	fljson jsonb NULL,
	idpaymerch jsonb NOT NULL,
	verification int4 NULL,
	CONSTRAINT t_24alltime_pkey PRIMARY KEY (idpaymerch),
	CONSTRAINT t_24alltime_qtranz_key UNIQUE (qtranz)
);

-- Permissions

ALTER TABLE public.t_24alltime OWNER TO postgres;
GRANT ALL ON TABLE public.t_24alltime TO postgres;
GRANT SELECT ON TABLE public.t_24alltime TO "AlekzP";


-- public.t_breakesum определение

-- Drop table

-- DROP TABLE public.t_breakesum;

CREATE TABLE public.t_breakesum (
	idbreake smallserial NOT NULL,
	json_breakesum jsonb NULL,
	CONSTRAINT t_breakesum_pkey PRIMARY KEY (idbreake)
);

-- Permissions

ALTER TABLE public.t_breakesum OWNER TO postgres;
GRANT ALL ON TABLE public.t_breakesum TO postgres;
GRANT SELECT ON TABLE public.t_breakesum TO "AlekzP";


-- public.t_ckassa определение

-- Drop table

-- DROP TABLE public.t_ckassa;

CREATE TABLE public.t_ckassa (
	qtranz serial4 NOT NULL,
	fljson jsonb NULL,
	idpaymerch jsonb NOT NULL,
	verification int4 NULL,
	CONSTRAINT t_ckassa_pkey PRIMARY KEY (idpaymerch),
	CONSTRAINT t_ckassa_qtranz_key UNIQUE (qtranz)
);

-- Permissions

ALTER TABLE public.t_ckassa OWNER TO postgres;
GRANT ALL ON TABLE public.t_ckassa TO postgres;
GRANT SELECT ON TABLE public.t_ckassa TO "AlekzP";


-- public.t_commparam определение

-- Drop table

-- DROP TABLE public.t_commparam;

CREATE TABLE public.t_commparam (
	idcommparam serial4 NOT NULL,
	"enable" bool DEFAULT true NULL,
	json_commparam jsonb NOT NULL,
	CONSTRAINT " unique" UNIQUE (idcommparam),
	CONSTRAINT doc_commparam_pkey PRIMARY KEY (json_commparam)
);
CREATE UNIQUE INDEX " unique" ON public.t_commparam USING btree (idcommparam);
COMMENT ON TABLE public.t_commparam IS 'Журнал документов данных отправки запросов о платежах принципалам';

-- Permissions

ALTER TABLE public.t_commparam OWNER TO postgres;
GRANT ALL ON TABLE public.t_commparam TO postgres;
GRANT SELECT ON TABLE public.t_commparam TO "AlekzP";


-- public.t_commun определение

-- Drop table

-- DROP TABLE public.t_commun;

CREATE TABLE public.t_commun (
	idcommun serial4 NOT NULL,
	"NameComm" varchar(50) NOT NULL,
	"Comment" varchar(250) NULL,
	template_answer varchar(255) NULL,
	"enable" bool DEFAULT true NULL,
	CONSTRAINT t_commun_pkey PRIMARY KEY (idcommun)
);
COMMENT ON TABLE public.t_commun IS 'views of communications';

-- Permissions

ALTER TABLE public.t_commun OWNER TO postgres;
GRANT ALL ON TABLE public.t_commun TO postgres;
GRANT SELECT ON TABLE public.t_commun TO "AlekzP";


-- public.t_department определение

-- Drop table

-- DROP TABLE public.t_department;

CREATE TABLE public.t_department (
	id smallserial NOT NULL,
	"name" varchar(250) NULL,
	en_name varchar(250) NULL,
	color varchar(20) NULL,
	CONSTRAINT t_department_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE public.t_department OWNER TO postgres;
GRANT ALL ON TABLE public.t_department TO postgres;
GRANT SELECT ON TABLE public.t_department TO "AlekzP";


-- public.t_descriptions определение

-- Drop table

-- DROP TABLE public.t_descriptions;

CREATE TABLE public.t_descriptions (
	id serial4 NOT NULL,
	"Name" varchar NULL,
	description varchar NULL,
	CONSTRAINT t_descriptions_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE public.t_descriptions OWNER TO postgres;
GRANT ALL ON TABLE public.t_descriptions TO postgres;
GRANT SELECT ON TABLE public.t_descriptions TO "AlekzP";


-- public.t_firmservice определение

-- Drop table

-- DROP TABLE public.t_firmservice;

CREATE TABLE public.t_firmservice (
	idfirm bpchar(6) NOT NULL,
	"enable" bool DEFAULT true NULL,
	fljson_firm jsonb NULL,
	CONSTRAINT t_firmservice_pkey PRIMARY KEY (idfirm)
);

-- Permissions

ALTER TABLE public.t_firmservice OWNER TO postgres;
GRANT ALL ON TABLE public.t_firmservice TO postgres;
GRANT SELECT ON TABLE public.t_firmservice TO "AlekzP";


-- public.t_merchant определение

-- Drop table

-- DROP TABLE public.t_merchant;

CREATE TABLE public.t_merchant (
	idmerch serial4 NOT NULL,
	xjson jsonb NULL,
	accesuaries jsonb NULL,
	" enable" bool DEFAULT true NULL,
	CONSTRAINT "public.t_merchant" PRIMARY KEY (idmerch)
);

-- Permissions

ALTER TABLE public.t_merchant OWNER TO postgres;
GRANT ALL ON TABLE public.t_merchant TO postgres;
GRANT SELECT ON TABLE public.t_merchant TO "AlekzP";


-- public.t_onlinecassa определение

-- Drop table

-- DROP TABLE public.t_onlinecassa;

CREATE TABLE public.t_onlinecassa (
	id_cassa smallserial NOT NULL,
	accesuaries jsonb NULL,
	CONSTRAINT t_onlinecassa_pkey PRIMARY KEY (id_cassa)
);

-- Permissions

ALTER TABLE public.t_onlinecassa OWNER TO postgres;
GRANT ALL ON TABLE public.t_onlinecassa TO postgres;
GRANT SELECT ON TABLE public.t_onlinecassa TO "AlekzP";


-- public.t_payberry определение

-- Drop table

-- DROP TABLE public.t_payberry;

CREATE TABLE public.t_payberry (
	qtranz int4 DEFAULT nextval('t_paybarry_qtranz_seq'::regclass) NOT NULL,
	fljson jsonb NULL,
	idpaymerch jsonb NOT NULL,
	verification int4 NULL,
	CONSTRAINT qtranz UNIQUE (qtranz),
	CONSTRAINT t_payberry_pkey PRIMARY KEY (idpaymerch)
);

-- Permissions

ALTER TABLE public.t_payberry OWNER TO postgres;
GRANT ALL ON TABLE public.t_payberry TO postgres;
GRANT SELECT ON TABLE public.t_payberry TO "AlekzP";


-- public.t_payment определение

-- Drop table

-- DROP TABLE public.t_payment;

CREATE TABLE public.t_payment (
	qtranz int4 NULL,
	"DateTime" timestamp(6) NULL,
	data_json jsonb NULL,
	answer varchar(255) DEFAULT 0 NULL,
	comm_json jsonb NULL,
	firm_json jsonb NULL,
	privilege_json jsonb NULL,
	merch_json jsonb NULL,
	tarif_json jsonb NULL,
	idpaymerch jsonb NULL
)
PARTITION BY RANGE ("DateTime");

-- Permissions

ALTER TABLE public.t_payment OWNER TO postgres;
GRANT ALL ON TABLE public.t_payment TO postgres;
GRANT SELECT ON TABLE public.t_payment TO "AlekzP";


-- public.t_payview определение

-- Drop table

-- DROP TABLE public.t_payview;

CREATE TABLE public.t_payview (
	id_payview int2 DEFAULT nextval('t_payview_idpayview_seq'::regclass) NOT NULL,
	payview varchar(255) NULL,
	CONSTRAINT t_payview_pkey PRIMARY KEY (id_payview)
);

-- Permissions

ALTER TABLE public.t_payview OWNER TO postgres;
GRANT ALL ON TABLE public.t_payview TO postgres;
GRANT SELECT ON TABLE public.t_payview TO "AlekzP";


-- public.t_qiwi определение

-- Drop table

-- DROP TABLE public.t_qiwi;

CREATE TABLE public.t_qiwi (
	qtranz serial4 NOT NULL,
	fljson jsonb NULL,
	idpaymerch jsonb NOT NULL,
	verification int4 NULL,
	CONSTRAINT t_qiwi_pkey PRIMARY KEY (idpaymerch),
	CONSTRAINT t_qiwi_qtranz_key UNIQUE (qtranz)
);

-- Permissions

ALTER TABLE public.t_qiwi OWNER TO postgres;
GRANT ALL ON TABLE public.t_qiwi TO postgres;
GRANT SELECT ON TABLE public.t_qiwi TO "AlekzP";


-- public.t_qiwiequar определение

-- Drop table

-- DROP TABLE public.t_qiwiequar;

CREATE TABLE public.t_qiwiequar (
	id_qiwiequar serial4 NOT NULL,
	json_inside jsonb NULL,
	json_ansbank jsonb NULL,
	json_callback jsonb NULL,
	CONSTRAINT t_qiwiequar_pkey PRIMARY KEY (id_qiwiequar)
);

-- Permissions

ALTER TABLE public.t_qiwiequar OWNER TO postgres;
GRANT ALL ON TABLE public.t_qiwiequar TO postgres;
GRANT SELECT ON TABLE public.t_qiwiequar TO "AlekzP";


-- public.t_rsbank определение

-- Drop table

-- DROP TABLE public.t_rsbank;

CREATE TABLE public.t_rsbank (
	id_rsbank serial4 NOT NULL,
	json_inside jsonb NULL,
	json_ansbank jsonb NULL,
	json_callback jsonb NULL,
	CONSTRAINT t_rsbank_pkey PRIMARY KEY (id_rsbank)
);

-- Permissions

ALTER TABLE public.t_rsbank OWNER TO postgres;
GRANT ALL ON TABLE public.t_rsbank TO postgres;
GRANT SELECT ON TABLE public.t_rsbank TO "AlekzP";


-- public.t_sberequar определение

-- Drop table

-- DROP TABLE public.t_sberequar;

CREATE TABLE public.t_sberequar (
	id_sberequar serial4 NOT NULL,
	json_inside jsonb NULL,
	json_ansbank jsonb NULL,
	json_callback jsonb NULL,
	CONSTRAINT t_sberequar_pkey PRIMARY KEY (id_sberequar)
);

-- Permissions

ALTER TABLE public.t_sberequar OWNER TO postgres;
GRANT ALL ON TABLE public.t_sberequar TO postgres;
GRANT SELECT ON TABLE public.t_sberequar TO "AlekzP";


-- public.t_sbersms определение

-- Drop table

-- DROP TABLE public.t_sbersms;

CREATE TABLE public.t_sbersms (
	qtranz serial4 NOT NULL,
	fljson jsonb NULL,
	idpaymerch jsonb NOT NULL,
	verification int4 NULL,
	CONSTRAINT t_sbersms_pkey PRIMARY KEY (idpaymerch),
	CONSTRAINT t_sbersms_qtranz_key UNIQUE (qtranz)
);

-- Permissions

ALTER TABLE public.t_sbersms OWNER TO postgres;
GRANT ALL ON TABLE public.t_sbersms TO postgres;
GRANT SELECT ON TABLE public.t_sbersms TO "AlekzP";


-- public.t_service определение

-- Drop table

-- DROP TABLE public.t_service;

CREATE TABLE public.t_service (
	id_service smallserial NOT NULL,
	"enable" bool DEFAULT true NOT NULL,
	json_service jsonb NULL
);

-- Permissions

ALTER TABLE public.t_service OWNER TO postgres;
GRANT ALL ON TABLE public.t_service TO postgres;
GRANT SELECT ON TABLE public.t_service TO "AlekzP";


-- public.t_skysend определение

-- Drop table

-- DROP TABLE public.t_skysend;

CREATE TABLE public.t_skysend (
	qtranz serial4 NOT NULL,
	fljson jsonb NULL,
	idpaymerch jsonb NOT NULL,
	verification int4 NULL,
	CONSTRAINT t_skysend_pkey PRIMARY KEY (idpaymerch),
	CONSTRAINT t_skysend_qtranz_key UNIQUE (qtranz)
);

-- Permissions

ALTER TABLE public.t_skysend OWNER TO postgres;
GRANT ALL ON TABLE public.t_skysend TO postgres;
GRANT SELECT ON TABLE public.t_skysend TO "AlekzP";


-- public.t_tarif определение

-- Drop table

-- DROP TABLE public.t_tarif;

CREATE TABLE public.t_tarif (
	idtarif serial4 NOT NULL,
	json_tarif jsonb NULL,
	"enable" bool DEFAULT true NULL,
	CONSTRAINT t_tarif_pkey PRIMARY KEY (idtarif)
);

-- Permissions

ALTER TABLE public.t_tarif OWNER TO postgres;
GRANT ALL ON TABLE public.t_tarif TO postgres;
GRANT SELECT ON TABLE public.t_tarif TO "AlekzP";


-- public.t_tranztarif определение

-- Drop table

-- DROP TABLE public.t_tranztarif;

CREATE TABLE public.t_tranztarif (
	idtranz serial4 NOT NULL,
	"Firm" varchar(6) NOT NULL,
	"Tarif" int2 NOT NULL,
	"Syspay" int2 NOT NULL,
	"Breakesum" int2 DEFAULT 1 NOT NULL,
	login int4 NOT NULL,
	"Enable" bool DEFAULT true NOT NULL,
	delay int2 DEFAULT 0 NOT NULL,
	CONSTRAINT t_tranztarif_pkey PRIMARY KEY ("Firm", "Syspay", "Breakesum")
);
CREATE INDEX "IDtranz" ON public.t_tranztarif USING btree (idtranz);
COMMENT ON TABLE public.t_tranztarif IS 'список тарифов, используемых для пары: фирма-плат.система';

-- Permissions

ALTER TABLE public.t_tranztarif OWNER TO postgres;
GRANT ALL ON TABLE public.t_tranztarif TO postgres;
GRANT SELECT ON TABLE public.t_tranztarif TO "AlekzP";


-- public.t_usergroup определение

-- Drop table

-- DROP TABLE public.t_usergroup;

CREATE TABLE public.t_usergroup (
	id_usergroup serial4 NOT NULL,
	name_usergroup varchar(255) DEFAULT nextval('t_usergroup_id_usergroup_seq'::regclass) NULL,
	CONSTRAINT t_usergroup_pkey PRIMARY KEY (id_usergroup)
);

-- Permissions

ALTER TABLE public.t_usergroup OWNER TO postgres;
GRANT ALL ON TABLE public.t_usergroup TO postgres;
GRANT SELECT ON TABLE public.t_usergroup TO "AlekzP";


-- public.t_payment2022 определение

CREATE TABLE public.t_payment2022 PARTITION OF public.t_payment (
	CONSTRAINT t_payment2022_pkey PRIMARY KEY (idpaymerch)
) FOR VALUES FROM ('2022-01-01 00:00:00') TO ('2023-01-01 00:00:00');


-- public.t_payment2023 определение

CREATE TABLE public.t_payment2023 PARTITION OF public.t_payment (
	CONSTRAINT t_payment2023_pkey PRIMARY KEY (idpaymerch)
) FOR VALUES FROM ('2023-01-01 00:00:00') TO ('2024-01-01 00:00:00');


-- public.t_payment2024 определение

CREATE TABLE public.t_payment2024 PARTITION OF public.t_payment (
	CONSTRAINT t_payment2024_pkey PRIMARY KEY (idpaymerch)
) FOR VALUES FROM ('2024-01-01 00:00:00') TO ('2025-01-01 00:00:00');



-- DROP FUNCTION public."NewFunc"(anyelement);

CREATE OR REPLACE FUNCTION public."NewFunc"(anyelement)
 RETURNS void
 LANGUAGE plpgsql
AS $function$BEGIN
  --{"uuid": "@uuid","contacts":{"name": "@name","email": "@email", "phone": "phone"},"role":['driver','courier'],"core": [{"number": "@namber","service": "service","firm": "firm","region": "@region"},{"number": "@namber","service": "service","firm": "firm","region": "@region"}]}

END
$function$
;

-- Permissions

ALTER FUNCTION public."NewFunc"(anyelement) OWNER TO postgres;
GRANT ALL ON FUNCTION public."NewFunc"(anyelement) TO postgres;


-- Permissions

GRANT ALL ON SCHEMA public TO postgres14;
GRANT ALL ON SCHEMA public TO public;
GRANT ALL ON SCHEMA public TO andrey;
GRANT USAGE ON SCHEMA public TO "AlekzP";