-- DROP SCHEMA drive_pay;

CREATE SCHEMA drive_pay AUTHORIZATION postgres;

-- DROP TYPE drive_pay."status_order";

CREATE TYPE drive_pay."status_order" AS ENUM (
	'new',
	'prepare',
	'expect',
	'close');

-- DROP SEQUENCE drive_pay.merch_sch_idmerch_seq;

CREATE SEQUENCE drive_pay.merch_sch_idmerch_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32000
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE drive_pay.order_id_paybank_seq;

CREATE SEQUENCE drive_pay.order_id_paybank_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE drive_pay.order_idorder_seq;

CREATE SEQUENCE drive_pay.order_idorder_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32000
	START 1
	CACHE 1
	NO CYCLE;-- drive_pay.merch_scheme определение

-- Drop table

-- DROP TABLE drive_pay.merch_scheme;

CREATE TABLE drive_pay.merch_scheme (
	idmerch int2 DEFAULT nextval('ataxi_transfer.merch_sch_idmerch_seq'::regclass) NOT NULL,
	accesuaries jsonb NULL,
	login varchar(50) NOT NULL,
	notification jsonb NULL,
	CONSTRAINT merch_scheme_pkey PRIMARY KEY (idmerch)
);


-- drive_pay."order" определение

-- Drop table

-- DROP TABLE drive_pay."order";

CREATE TABLE drive_pay."order" (
	id_order int8 DEFAULT nextval('ataxi_transfer.order_idorder_seq'::regclass) NOT NULL,
	param jsonb NULL,
	id_paybank int4 NULL,
	"enable" drive_pay."status_order" NULL,
	CONSTRAINT order_pkey PRIMARY KEY (id_order)
);


-- drive_pay.mv_service исходный текст

CREATE MATERIALIZED VIEW drive_pay.mv_service
TABLESPACE pg_default
AS SELECT service.id_service,
    service.service_name
   FROM common.service
WITH DATA;



-- DROP FUNCTION drive_pay.f_mvservice();

CREATE OR REPLACE FUNCTION drive_pay.f_mvservice()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
	BEGIN
		REFRESH MATERIALIZED VIEW drive_pay.mv_service;
		
		RETURN NULL;
  END
$function$
;

-- DROP FUNCTION drive_pay.f_order(json);

CREATE OR REPLACE FUNCTION drive_pay.f_order(x_json json)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
	DECLARE 
		xjs JSON;
		xid_pay JSON; 
		xjson JSON;
		xans JSON;
		xlogin VARCHAR;
		xurl_callback VARCHAR;
		xdatetime VARCHAR;
		xamount VARCHAR;
		xphone VARCHAR;
		xemail VARCHAR;
		xid INTEGER;
		xid_paybank INTEGER;
		xmerch INTEGER DEFAULT 1;
	--input_data:
	--	{
	--        "id_order": "5r6tfytgyu-ytfguyui-uytguyg-juhyuyh",
	--			  "uuid": "ytytfhgf",
	--        "amount": 240000
	--    }
	BEGIN
		xdatetime := common.f_timestamp();
		INSERT INTO drive_pay."order"(param)
		VALUES (x_json::jsonb || jsonb_build_object('timestamp',xdatetime)) RETURNING id_order INTO xid;
		SELECT login,accesuaries ->> 'url_callback',accesuaries ->> 'phone_customer',accesuaries ->> 'email_customer'
		INTO xlogin,xurl_callback,xphone,xemail 
		FROM drive_pay.merch_scheme WHERE idmerch = xmerch;
		xamount := x_json::jsonb ->> 'amount';
		
		--BEGIN
			
				--xid_pay := jsonb_build_object('id_order',xid::text,'login_dev',xlogin);
				--SELECT json_answer INTO xjs FROM mytosb.syspay WHERE idpay = xid_pay::jsonb;
				--xjs := xjs::jsonb || jsonb_build_object('err',1);
			--RETURN xjs;
		--END;
			--UPDATE drive_pay.calc_sec SET id_order = xid WHERE id_calc = xid_calc;
		x_json := x_json::jsonb || jsonb_build_object('id_order',xid,'datetime',xdatetime);
		SELECT accesuaries::jsonb || x_json::jsonb INTO xjson 
		FROM drive_pay.merch_scheme WHERE idmerch = 1;
		--xamount := (xamount::integer * 100)::text;
		--xamount := (xamount::integer / 1000)::text;
		xjson := jsonb_set(xjson::jsonb,'{amount}',xamount::jsonb,FALSE);
		xjson := jsonb_set(xjson::jsonb,'{products,0,amount_prod}',xamount::jsonb,FALSE);
		xjson := jsonb_set(xjson::jsonb,'{products,0,price}',xamount::jsonb,FALSE);
		--xans := mytosb.f_syspay(xjson);
		--xid_paybank := xans::jsonb ->> 'newid';		
		--UPDATE ataxi_transfer."order" SET id_paybank = xid_paybank WHERE id_order = xid;
		RETURN xdatetime;
	END;
	--output data:
	--{
  --"login_dev": "driver_pay",
	--"url_callback": "https:.......", 
  --"id_order": "11a5ce1b-336a-11ed-a8af-b4d5bd9a0as",
  --"amount": 2400,
	--"uuid": "",
	--"merch": 28,
  --"phone_ customer": "+79101234567",
  --"email_customer": "mail@mail.ru",
  --"datetime": "2023-02-17T12:13:30",
  --"principal": "200190",
  --"products": 
  --[
  --{
  --"name_prod": "услуги такси", "unit": "1","count": 1, "price": 2400,"amount_prod": 2400
  --}
  --]
  --}
$function$
;

-- DROP FUNCTION drive_pay.f_order_id(text);

CREATE OR REPLACE FUNCTION drive_pay.f_order_id(id text)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	declare x_param JSON DEFAULT '{}';
	declare xfiskal VARCHAR;
    declare xidorder INTEGER;
    declare xxidorder JSON;
    declare xfiskal_text VARCHAR DEFAULT 'Электронный чек об оплате вы можете скачать здесь:';
	begin
		SELECT id_order INTO xidorder FROM ataxi_transfer."order" where id_calc = id ;
 	    SELECT call_back ->> 'receipt_url' INTO xfiskal FROM ekassa.ekassa_check WHERE data_check ->> 'id_order' = xidorder::text ;
 	    if xfiskal != '' then
			SELECT jsonb_build_object('id_order', id_order, 'id_calc', id_calc, 'params', param, 'is_payed', t_syspay."enable", 'sbp', t_syspay.json_answer, 'fiscal', jsonb_build_object('fiskal_url', xfiskal,'description', xfiskal_text)) into x_param
			FROM ataxi_transfer."order" t_order
			LEFT JOIN mytosb.syspay t_syspay on t_order.id_paybank = t_syspay.id_paybank
			WHERE id_calc = id;
		else 
			SELECT jsonb_build_object('id_order', id_order, 'id_calc', id_calc, 'params', param, 'is_payed', t_syspay."enable", 'sbp', t_syspay.json_answer, 'fiscal', null) into x_param
			FROM ataxi_transfer."order" t_order
			LEFT JOIN mytosb.syspay t_syspay on t_order.id_paybank = t_syspay.id_paybank
			WHERE id_calc = id;
        end if;		
	
	RETURN x_param;
	END;
$function$
;

-- DROP FUNCTION drive_pay.f_order_status();

CREATE OR REPLACE FUNCTION drive_pay.f_order_status()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
	DECLARE
		xjs_idpay JSON;
		xlogin VARCHAR;
		xid_order INTEGER;
BEGIN
  SELECT NEW.idpay INTO xjs_idpay FROM mytosb.syspay; 
	xlogin := xjs_idpay::jsonb ->> 'login_dev';
	IF xlogin = 'web_ataxi' THEN
		xid_order := (xjs_idpay::jsonb ->> 'id_order')::integer;
		UPDATE ataxi_transfer."order" SET "enable" = TRUE WHERE id_order = xid_order;
	END IF;
	RETURN NEW;
END
$function$
;

-- DROP FUNCTION drive_pay.f_order_status_test();

CREATE OR REPLACE FUNCTION drive_pay.f_order_status_test()
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
	DECLARE
		xjs_idpay JSON;
		xlogin VARCHAR;
		xid_order INTEGER;
BEGIN
  SELECT idpay INTO xjs_idpay FROM mytosb.syspay WHERE id_paybank = 776; 
	xlogin := xjs_idpay::jsonb ->> 'login_dev';
	IF xlogin = 'web_ataxi' THEN
		xid_order := (xjs_idpay::jsonb ->> 'id_order')::integer;
		UPDATE ataxi_transfer."order" SET "enable" = TRUE WHERE id_order = xid_order;
	END IF;
	RETURN xjs_idpay;
END
$function$
;