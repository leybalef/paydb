-- DROP SCHEMA top_up;

CREATE SCHEMA top_up AUTHORIZATION postgres;

-- DROP TYPE top_up."status_order";

CREATE TYPE top_up."status_order" AS ENUM (
	'new',
	'paid');

-- DROP SEQUENCE top_up.merch_sch_idmerch_seq;

CREATE SEQUENCE top_up.merch_sch_idmerch_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32000
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE top_up.merch_sch_idmerch_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE top_up.merch_sch_idmerch_seq TO postgres;
GRANT ALL ON SEQUENCE top_up.merch_sch_idmerch_seq TO "Alef";
-- top_up.merch_scheme определение

-- Drop table

-- DROP TABLE top_up.merch_scheme;

CREATE TABLE top_up.merch_scheme (
	idmerch int2 DEFAULT nextval('top_up.merch_sch_idmerch_seq'::regclass) NOT NULL,
	accesuaries jsonb NULL,
	login varchar(50) NOT NULL,
	notification jsonb NULL,
	"enable" bool DEFAULT true NOT NULL,
	CONSTRAINT merch_scheme_pkey PRIMARY KEY (idmerch)
);


-- top_up."order" определение

-- Drop table

-- DROP TABLE top_up."order";

CREATE TABLE top_up."order" (
	param jsonb NULL,
	id_paybank int4 NULL,
	"enable" top_up."status_order" NULL,
	datetime timestamp(6) DEFAULT now() NULL,
	id_order varchar(50) DEFAULT common.uuid_v7_gen() NOT NULL,
	CONSTRAINT order_pkey PRIMARY KEY (id_order)
);


-- top_up.merch_scheme внешние включи

-- top_up."order" внешние включи


-- DROP FUNCTION top_up.f_notify_paysys();

CREATE OR REPLACE FUNCTION top_up.f_notify_paysys()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN 
	PERFORM pg_notify('ch_paysys', 'change');
	RETURN NULL;
END
$function$
;

-- Permissions

ALTER FUNCTION top_up.f_notify_paysys() OWNER TO postgres;
GRANT ALL ON FUNCTION top_up.f_notify_paysys() TO postgres;
GRANT ALL ON FUNCTION top_up.f_notify_paysys() TO "Alef";
GRANT ALL ON FUNCTION top_up.f_notify_paysys() TO apiw;

-- DROP FUNCTION top_up.f_order(json);

CREATE OR REPLACE FUNCTION top_up.f_order(xjson json)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
	DECLARE
		xproducts JSON;
		x_json JSON;
		xquery_bank VARCHAR;
		xparam JSON;
		xid VARCHAR(50);
		xlogin VARCHAR(50);
		xmerch VARCHAR;
		xaccount VARCHAR(12);
		xurl_callback VARCHAR;
		xdatetime VARCHAR(30);
		xphone VARCHAR(12);
		xemail VARCHAR;
		xservice VARCHAR(10);
		xname_prod VARCHAR;
		xsuplier_phone VARCHAR;
		xfirm VARCHAR(6);
		xname_firm VARCHAR;
		xloc VARCHAR;
		xserv_name VARCHAR;
		xamount INTEGER;
		xprice INTEGER;
		xid_paybank INTEGER;
	--inside:
	--{	
    --"accountNumber": "3333333333",
    --"amount": "1000",
    --"email": null,
    --"phone": null,
    --"receipt": false,
		--"merch": 28
--}	
BEGIN
	xmerch := (xjson::jsonb ->> 'merch');
	xamount := (xjson::jsonb ->> 'amount');
	xprice := xamount;
	--xamount := xamount::integer * 100;
	xphone := (xjson::jsonb ->> 'phone');
	xaccount := (xjson::jsonb ->> 'accountNumber');
	xfirm := LEFT(xaccount,6);
	SELECT 'Локация: '||(fljson_firm ->> 'city'),fljson_firm ->> 'service','"'||(fljson_firm ->> 'login')||'"','Кому: '||(fljson_firm ->> 'namefirm') 
	INTO xloc,xservice,xsuplier_phone,xname_firm FROM common.firmservice WHERE idfirm = xfirm;
	SELECT 'За: '||service_name INTO xserv_name FROM common.service WHERE id_service = xservice;
	IF xservice <> '9' THEN
		SELECT '"'||service_name||'"' INTO xname_prod FROM common.service WHERE id_service = xservice;
		SELECT accesuaries -> 'products' INTO xproducts FROM top_up.merch_scheme WHERE idmerch = 1;
		xproducts := jsonb_set(xproducts::jsonb,'{0,name_prod}',xname_prod::jsonb,FALSE);
		xproducts := jsonb_set(xproducts::jsonb,'{0,price}',(xprice::text)::jsonb,FALSE); 
		xproducts := jsonb_set(xproducts::jsonb,'{0,amount_prod}',(xprice::text)::jsonb,FALSE);
		xproducts := jsonb_set(xproducts::jsonb,'{0,supplier_phone}',xsuplier_phone::jsonb,FALSE);
	END IF;
	IF (xjson::jsonb ->> 'receipt')::boolean = true THEN
		SELECT accesuaries ->> 'default_email' INTO xemail FROM top_up."merch_scheme" WHERE accesuaries ->> 'merch' = xmerch;
		xjson := xjson::jsonb - 'email' || jsonb_build_object('email',xemail);
	END IF;
	x_json := jsonb_build_object('loc',xloc,'service',xserv_name,'firm',xname_firm);
	xjson := xjson::jsonb || x_json::jsonb;
	INSERT INTO top_up."order" (param,"enable") VALUES (xjson,'new') 
	ON CONFLICT DO NOTHING RETURNING id_order,datetime INTO xid,xdatetime;
	SELECT "login",accesuaries ->> 'url_callback' 
	INTO xlogin,xurl_callback FROM top_up.merch_scheme WHERE accesuaries ->> 'merch' = xmerch;
	xparam := jsonb_build_object('login_dev',xlogin,'url_callback',xurl_callback,'id_order',xid,'amount',xamount,
	'phone_customer',xphone,'email_customer',xemail,'datetime',xdatetime,'principal',xaccount, 'products',xproducts) || x_json::jsonb;
	xquery_bank := mytosb.f_syspay(xparam);
	xid_paybank := xquery_bank::jsonb ->> 'newid';	
	UPDATE top_up."order" SET id_paybank = xid_paybank WHERE id_order = xid;
	xquery_bank := xquery_bank::jsonb || jsonb_build_object('id_order',xid,'account',xaccount,'status','new'); 
	xquery_bank := xquery_bank::jsonb || x_json::jsonb;
	RETURN xquery_bank;
END
$function$
;

-- Permissions

ALTER FUNCTION top_up.f_order(json) OWNER TO postgres;
GRANT ALL ON FUNCTION top_up.f_order(json) TO postgres;

-- DROP FUNCTION top_up.f_order_id(bpchar);

CREATE OR REPLACE FUNCTION top_up.f_order_id(xid_order character)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
	DECLARE 
		xans VARCHAR DEFAULT '{"ans": "new"}';
		xfirm VARCHAR(6);
		xloc VARCHAR;
		xaccount VARCHAR(10);
		xname_firm VARCHAR;
		xserv_name VARCHAR;
		xdescript JSON;
	  xid_idpaybank INTEGER;
		xservice VARCHAR(5);
		xenable BOOLEAN;
	BEGIN
	SELECT id_paybank,(param::jsonb - '{email,merch,phone,amount,receipt}'::text[]) 
	INTO xid_idpaybank,xdescript::jsonb||jsonb_build_object('id_order',xid_order)  
	FROM top_up."order" WHERE id_order = xid_order;
	xaccount := xdescript ->> 'accountNumber';
	SELECT "enable" INTO xenable FROM mytosb.syspay WHERE id_paybank = xid_idpaybank;
	IF xenable = TRUE THEN
		xans := jsonb_build_object('ans','paid')||xdescript::jsonb;
		UPDATE top_up."order" SET "enable" = 'paid' WHERE id_order = xid_order; 
	ELSE
		xans := xans::jsonb||jsonb_build_object('id_order',xid_order,'accountNumber',xaccount);
  END IF;
	RETURN xans;
END
$function$
;

-- Permissions

ALTER FUNCTION top_up.f_order_id(bpchar) OWNER TO postgres;
GRANT ALL ON FUNCTION top_up.f_order_id(bpchar) TO postgres;

-- DROP FUNCTION top_up.f_order_status(bpchar);

CREATE OR REPLACE FUNCTION top_up.f_order_status(xid_order character)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
	DECLARE 
		xans VARCHAR DEFAULT '{"ans": "new"}';
		xfirm VARCHAR;
		xloc VARCHAR;
		xname_firm VARCHAR;
		xserv_name VARCHAR;
		xdescript JSON;
	  xid_idpaybank INTEGER;
		xservice VARCHAR;
		xenable BOOLEAN;
	BEGIN
	SELECT id_paybank,(param::jsonb - '{email,merch,phone,amount,receipt}'::text[]) 
	INTO xid_idpaybank,xdescript FROM top_up."order" WHERE id_order = xid_order;
	SELECT "enable" INTO xenable FROM mytosb.syspay WHERE id_paybank = xid_idpaybank;
	IF xenable = TRUE THEN
		xans := jsonb_build_object('ans','paid')||xdescript::jsonb;
		UPDATE top_up."order" SET "enable" = 'paid' WHERE id_order = xid_order; 
  END IF;
	RETURN xans;
END
$function$
;

-- Permissions

ALTER FUNCTION top_up.f_order_status(bpchar) OWNER TO "Alef";
GRANT ALL ON FUNCTION top_up.f_order_status(bpchar) TO "Alef";

-- DROP FUNCTION top_up.f_topup();

CREATE OR REPLACE FUNCTION top_up.f_topup()
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
	DECLARE
		xmerch VARCHAR;
BEGIN
	SELECT array_to_json(array_agg(jsonb_build_object('id',accesuaries ->> 'merch', 'descript', accesuaries ->> 'descript')))
	INTO xmerch FROM top_up.merch_scheme WHERE "enable" = TRUE;
	RETURN xmerch;
END
--[{"id": "28", "descript": "система быстрых платежей"},{"id": "21", "descript": "оплата картой"}]
$function$
;

-- Permissions

ALTER FUNCTION top_up.f_topup() OWNER TO postgres;
GRANT ALL ON FUNCTION top_up.f_topup() TO postgres;
GRANT ALL ON FUNCTION top_up.f_topup() TO "Alef";
GRANT ALL ON FUNCTION top_up.f_topup() TO apiw;


-- Permissions

GRANT ALL ON SCHEMA top_up TO postgres;
GRANT ALL ON SCHEMA top_up TO "Alef";