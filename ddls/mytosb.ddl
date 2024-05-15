-- DROP SCHEMA mytosb;

CREATE SCHEMA mytosb AUTHORIZATION postgres;

-- DROP SEQUENCE mytosb.syspay_id_paybank_seq;

CREATE SEQUENCE mytosb.syspay_id_paybank_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mytosb.syspay_id_paybank_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE mytosb.syspay_id_paybank_seq TO postgres;
GRANT ALL ON SEQUENCE mytosb.syspay_id_paybank_seq TO apis;
GRANT ALL ON SEQUENCE mytosb.syspay_id_paybank_seq TO apiataxi;
GRANT SELECT ON SEQUENCE mytosb.syspay_id_paybank_seq TO alexr;
GRANT SELECT, USAGE ON SEQUENCE mytosb.syspay_id_paybank_seq TO "Alef";

-- DROP SEQUENCE mytosb.tranzserv_id_tranz_service_seq;

CREATE SEQUENCE mytosb.tranzserv_id_tranz_service_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mytosb.tranzserv_id_tranz_service_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE mytosb.tranzserv_id_tranz_service_seq TO postgres;
GRANT ALL ON SEQUENCE mytosb.tranzserv_id_tranz_service_seq TO apiataxi;
GRANT SELECT ON SEQUENCE mytosb.tranzserv_id_tranz_service_seq TO alexr;
GRANT SELECT, USAGE ON SEQUENCE mytosb.tranzserv_id_tranz_service_seq TO "Alef";
-- mytosb.contracts определение

-- Drop table

-- DROP TABLE mytosb.contracts;

CREATE TABLE mytosb.contracts (
	id_tranzservice int4 DEFAULT nextval('mytosb.tranzserv_id_tranz_service_seq'::regclass) NOT NULL,
	inn_firm bpchar(12) NULL,
	bank bpchar(9) NULL,
	merchant int2 NULL,
	service int2 NULL,
	ekassa jsonb NULL,
	type_sys varchar(10) NULL,
	"enable" bool DEFAULT true NULL,
	firmservice varchar(10) NULL,
	contragent int4 NULL,
	bank_core bpchar(20) NULL,
	login_phone bpchar(12) NULL,
	CONSTRAINT tranz_service_pkey PRIMARY KEY (id_tranzservice)
);

-- Permissions

ALTER TABLE mytosb.contracts OWNER TO postgres;
GRANT ALL ON TABLE mytosb.contracts TO postgres;
GRANT SELECT ON TABLE mytosb.contracts TO apiw;
GRANT UPDATE, INSERT, SELECT, DELETE ON TABLE mytosb.contracts TO apiataxi;
GRANT UPDATE, SELECT ON TABLE mytosb.contracts TO apis;
GRANT SELECT ON TABLE mytosb.contracts TO alexr;
GRANT SELECT ON TABLE mytosb.contracts TO "AlekzP";
GRANT UPDATE, INSERT, SELECT ON TABLE mytosb.contracts TO "Alef";


-- mytosb.info определение

-- Drop table

-- DROP TABLE mytosb.info;

CREATE TABLE mytosb.info (
	firm varchar(50) NULL,
	inn varchar(12) NULL,
	bank varchar(50) NULL,
	syspay int2 NULL,
	"type syspay" varchar(50) NULL,
	ecassa jsonb NULL,
	service int2 NULL
);

-- Permissions

ALTER TABLE mytosb.info OWNER TO postgres;
GRANT ALL ON TABLE mytosb.info TO postgres;
GRANT SELECT ON TABLE mytosb.info TO apiw;
GRANT UPDATE, INSERT, REFERENCES, SELECT ON TABLE mytosb.info TO apis;
GRANT UPDATE, INSERT, SELECT, DELETE ON TABLE mytosb.info TO apiataxi;
GRANT SELECT ON TABLE mytosb.info TO alexr;
GRANT SELECT ON TABLE mytosb.info TO "AlekzP";
GRANT UPDATE, INSERT, SELECT ON TABLE mytosb.info TO "Alef";


-- mytosb.syspay определение

-- Drop table

-- DROP TABLE mytosb.syspay;

CREATE TABLE mytosb.syspay (
	id_paybank serial4 NOT NULL,
	json_inside jsonb NULL,
	json_tobank jsonb NULL,
	json_answer jsonb NULL,
	json_callback jsonb NULL,
	idpay jsonb NOT NULL,
	"enable" bool DEFAULT false NOT NULL,
	CONSTRAINT doc_syspay_pkey PRIMARY KEY (id_paybank),
	CONSTRAINT idpay UNIQUE (idpay)
);

-- Constraint comments

COMMENT ON CONSTRAINT idpay ON mytosb.syspay IS 'Уникальные значения';

-- Table Triggers

create trigger tr_order_status before
update
    of json_callback on
    mytosb.syspay for each row execute function ataxi_transfer.f_order_status();
create trigger tr_payment after
update
    of json_callback on
    mytosb.syspay for each row execute function mytosb.f_tr_payment();

-- Permissions

ALTER TABLE mytosb.syspay OWNER TO postgres;
GRANT ALL ON TABLE mytosb.syspay TO postgres;
GRANT UPDATE, INSERT, SELECT ON TABLE mytosb.syspay TO apiw;
GRANT ALL ON TABLE mytosb.syspay TO apis;
GRANT UPDATE, INSERT, SELECT ON TABLE mytosb.syspay TO apif;
GRANT UPDATE, INSERT, SELECT, DELETE ON TABLE mytosb.syspay TO apiataxi;
GRANT SELECT ON TABLE mytosb.syspay TO alexr;
GRANT SELECT ON TABLE mytosb.syspay TO "AlekzP";
GRANT UPDATE, INSERT, SELECT ON TABLE mytosb.syspay TO "Alef";


-- mytosb.users определение

-- Drop table

-- DROP TABLE mytosb.users;

CREATE TABLE mytosb.users (
	id_users varchar(255) NOT NULL,
	pass varchar(255) NULL,
	descriptions varchar(255) NULL,
	CONSTRAINT users_pkey PRIMARY KEY (id_users)
);

-- Permissions

ALTER TABLE mytosb.users OWNER TO postgres;
GRANT ALL ON TABLE mytosb.users TO postgres;
GRANT SELECT ON TABLE mytosb.users TO apiw;
GRANT UPDATE, INSERT, SELECT, TRIGGER ON TABLE mytosb.users TO apis;
GRANT UPDATE, INSERT, SELECT, DELETE ON TABLE mytosb.users TO apiataxi;
GRANT SELECT ON TABLE mytosb.users TO alexr;
GRANT SELECT ON TABLE mytosb.users TO "AlekzP";
GRANT UPDATE, INSERT, SELECT ON TABLE mytosb.users TO "Alef";


-- mytosb.xcount_agent определение

-- Drop table

-- DROP TABLE mytosb.xcount_agent;

CREATE TABLE mytosb.xcount_agent (
	count int8 NULL
);

-- Permissions

ALTER TABLE mytosb.xcount_agent OWNER TO postgres;
GRANT ALL ON TABLE mytosb.xcount_agent TO postgres;
GRANT UPDATE, INSERT, SELECT, DELETE ON TABLE mytosb.xcount_agent TO apiataxi;
GRANT SELECT ON TABLE mytosb.xcount_agent TO alexr;
GRANT SELECT ON TABLE mytosb.xcount_agent TO "AlekzP";
GRANT UPDATE, INSERT, SELECT ON TABLE mytosb.xcount_agent TO "Alef";



-- DROP FUNCTION mytosb.f_ansbank(json, int4);

CREATE OR REPLACE FUNCTION mytosb.f_ansbank(xjson json, newid integer)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
	DECLARE 
		xidpay INTEGER;
		xamount INTEGER;
		xamount_comiss INTEGER;
		xamount_inside INTEGER;
	  xclient JSON;
	  xtimestamp JSON;
	  xpay_code JSON;
	  xcomiss VARCHAR;
	  xprincipal VARCHAR;
		xdesc_sum_tarif VARCHAR DEFAULT 'Стоимость поездки по тарифу ~ руб.';
		xdesc_sum_comiss VARCHAR DEFAULT 'Комиссия за перевод составит &% от стоимости поездки и равна @ руб.';
		xdesc_sum_pay VARCHAR DEFAULT 'Итоговая сумма к списанию # руб.';
	  xdescription VARCHAR DEFAULT 'Оплачивая, Вы соглашаетесь с положениями оферты, предусматривающими взимание комиссии.';
	--{
	--"Data": {
		--"image": {
			--"width": 200, 
			--"height": 200, 
			--"content": "qrcode_base64", 
			--"mediaType": "image/png"
			--}, 
		--"qrcId":"AD10004NBI1TU7R69Q6R9EC0E8OIU4QT", 
		--"payload": "https://qr.nspk.ru/AD10004NBI1TU7R69Q6R9EC0E8OIU4QT?type=02&bank=100000000065&sum=1200&cur=RUB&crc=3C45"
		--}, 
--"Meta": {
	--"totalPages": 1
--}, 
--"Links": {
	--"self": "http://enter.tochka.com/sbp/v1.0/qr-code/merchant/MA0000455002/40702810909500013862/044525999"
	--}
--}
	BEGIN
		SELECT json_build_object('client',jsonb_build_object('id_order',json_inside ->> 'id_order','client_id',json_inside ->> 'client_id')),
		LEFT(json_inside ->> 'principal',6),(json_inside ->> 'upcomiss')::integer,(json_inside ->> 'amount_inside')::integer,(json_inside ->> 'amount')::integer
		INTO xclient,xprincipal,xamount_comiss,xamount_inside,xamount FROM mytosb.syspay WHERE id_paybank = newid;
		SELECT (((fljson_firm ->> 'upcomission')::numeric(3,2) * 100)::float)::text INTO xcomiss 
		FROM common.firmservice WHERE idfirm = xprincipal;
		--||--xamount_comiss := ((xamount_comiss::integer / 100)::numeric(7,2))::text; 
		xdesc_sum_tarif := REPLACE(xdesc_sum_tarif,'~',((xamount_inside / 100)::numeric(7,2))::text);
		xdesc_sum_comiss := REPLACE(xdesc_sum_comiss,'&',xcomiss);
		xdesc_sum_comiss := REPLACE(xdesc_sum_comiss,'@',((xamount_comiss::numeric(7,2) / 100)::numeric(7,2))::text);
		xdesc_sum_pay := REPLACE(xdesc_sum_pay,'#',((xamount / 100)::numeric(7,2))::text);
		xpay_code := xjson::jsonb -> 'Data' || xclient::jsonb
		|| jsonb_build_object('sum_tarif',xdesc_sum_tarif,'sum_comiss',xdesc_sum_comiss,'sum_pay',xdesc_sum_pay,'description',xdescription); 
		xtimestamp := jsonb_build_object('timestamp',common.f_timestamp());
		UPDATE mytosb.syspay SET json_answer = xpay_code::jsonb || xtimestamp::jsonb WHERE id_paybank = newid; 
		xpay_code := xpay_code::jsonb - 'qrcId';
	RETURN xpay_code;
END
$function$
;

-- Permissions

ALTER FUNCTION mytosb.f_ansbank(json, int4) OWNER TO postgres;
GRANT ALL ON FUNCTION mytosb.f_ansbank(json, int4) TO postgres;

-- DROP FUNCTION mytosb.f_ansclient(json, bpchar);

CREATE OR REPLACE FUNCTION mytosb.f_ansclient(param json, ans_client character)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
	DECLARE xyear INTEGER;
	DECLARE xidpay INTEGER;
 BEGIN
 xyear := (param::jsonb ->> 'year')::integer;
 xidpay := (param::jsonb ->> 'id_paybank')::integer;
 UPDATE reports.payment SET answer = jsonb_build_object('bank',ans_client) 
 WHERE "year" = xyear AND (data_json ->> 'id_paybank')::integer = xidpay;
END
$function$
;

-- Permissions

ALTER FUNCTION mytosb.f_ansclient(json, bpchar) OWNER TO postgres;
GRANT ALL ON FUNCTION mytosb.f_ansclient(json, bpchar) TO public;
GRANT ALL ON FUNCTION mytosb.f_ansclient(json, bpchar) TO postgres;
GRANT ALL ON FUNCTION mytosb.f_ansclient(json, bpchar) TO apiataxi;
GRANT ALL ON FUNCTION mytosb.f_ansclient(json, bpchar) TO apis;
GRANT ALL ON FUNCTION mytosb.f_ansclient(json, bpchar) TO alexr;
GRANT ALL ON FUNCTION mytosb.f_ansclient(json, bpchar) TO "AlekzP";
GRANT ALL ON FUNCTION mytosb.f_ansclient(json, bpchar) TO "Alef";

-- DROP FUNCTION mytosb.f_api_users(bpchar);

CREATE OR REPLACE FUNCTION mytosb.f_api_users(xlogin character)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
    DECLARE xvalue json;
	BEGIN
	SELECT json_build_object('key',"id_users",'password',"pass") INTO xvalue FROM mytosb.users WHERE id_users = xlogin;
	RETURN xvalue;
	END;
$function$
;

-- Permissions

ALTER FUNCTION mytosb.f_api_users(bpchar) OWNER TO postgres;
GRANT ALL ON FUNCTION mytosb.f_api_users(bpchar) TO postgres;
GRANT ALL ON FUNCTION mytosb.f_api_users(bpchar) TO apis;
GRANT ALL ON FUNCTION mytosb.f_api_users(bpchar) TO apiataxi;
GRANT ALL ON FUNCTION mytosb.f_api_users(bpchar) TO alexr;
GRANT ALL ON FUNCTION mytosb.f_api_users(bpchar) TO "AlekzP";
GRANT ALL ON FUNCTION mytosb.f_api_users(bpchar) TO "Alef";

-- DROP FUNCTION mytosb.f_api_users_d(bpchar);

CREATE OR REPLACE FUNCTION mytosb.f_api_users_d(xlogin character)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
    DECLARE xvalue text;
	BEGIN
	SELECT descriptions::text INTO xvalue FROM mytosb.users WHERE id_users = xlogin;
	RETURN xvalue;
	END;
$function$
;

-- Permissions

ALTER FUNCTION mytosb.f_api_users_d(bpchar) OWNER TO vdskkp;
GRANT ALL ON FUNCTION mytosb.f_api_users_d(bpchar) TO public;
GRANT ALL ON FUNCTION mytosb.f_api_users_d(bpchar) TO vdskkp;
GRANT ALL ON FUNCTION mytosb.f_api_users_d(bpchar) TO apiataxi;
GRANT ALL ON FUNCTION mytosb.f_api_users_d(bpchar) TO alexr;
GRANT ALL ON FUNCTION mytosb.f_api_users_d(bpchar) TO "AlekzP";
GRANT ALL ON FUNCTION mytosb.f_api_users_d(bpchar) TO "Alef";

-- DROP FUNCTION mytosb.f_callback_bank(json);

CREATE OR REPLACE FUNCTION mytosb.f_callback_bank(xjson json)
 RETURNS json
 LANGUAGE plpgsql
 COST 10
AS $function$
	DECLARE xbillid JSONB;
	DECLARE xcallback JSON;
	DECLARE xans JSON;
	DECLARE xidpay INTEGER;
	DECLARE xidcallback VARCHAR DEFAULT 'pay_result';
	DECLARE xyear VARCHAR;
	DECLARE xurl_callback VARCHAR;
	DECLARE xidorder VARCHAR;
	DECLARE xdescript VARCHAR;
	DECLARE xresult VARCHAR DEFAULT ' перевел(а) Вам ';
	BEGIN
	xbillid := xjson::jsonb -> 'qrcId';
	SELECT id_paybank,json_inside ->> 'id_order',json_inside ->> 'url_callback',LEFT(json_inside ->> 'datetime',4) 
	INTO xidpay,xidorder,xurl_callback,xyear FROM mytosb.syspay WHERE json_answer -> 'qrcId' = xbillid;
	UPDATE mytosb.syspay SET json_callback = xjson WHERE id_paybank = xidpay; 
	UPDATE mytosb.syspay SET "enable" = true WHERE id_paybank = xidpay;
	xdescript := (xjson::jsonb ->> 'payerName')::text || xresult || (xjson::jsonb ->> 'amount')::text || ' руб.';
	xans := jsonb_build_object('client',jsonb_build_object('id_callback',xidcallback,'id_order',xidorder,'descript',xdescript),
	'url_callback',xurl_callback,'answer',jsonb_build_object('id_paybank',xidpay,'year',xyear));
	RETURN xans;
END
$function$
;

-- Permissions

ALTER FUNCTION mytosb.f_callback_bank(json) OWNER TO postgres;
GRANT ALL ON FUNCTION mytosb.f_callback_bank(json) TO postgres;
GRANT ALL ON FUNCTION mytosb.f_callback_bank(json) TO apis;
GRANT ALL ON FUNCTION mytosb.f_callback_bank(json) TO apiataxi;
GRANT ALL ON FUNCTION mytosb.f_callback_bank(json) TO alexr;
GRANT ALL ON FUNCTION mytosb.f_callback_bank(json) TO "AlekzP";
GRANT ALL ON FUNCTION mytosb.f_callback_bank(json) TO "Alef";

-- DROP FUNCTION mytosb.f_heads();

CREATE OR REPLACE FUNCTION mytosb.f_heads()
 RETURNS json
 LANGUAGE plpgsql
AS $function$
  DECLARE xmerch INTEGER DEFAULT 26;
  DECLARE xurl VARCHAR;
	DECLARE xaccess VARCHAR;
	DECLARE xauto VARCHAR;
  DECLARE xurlj JSON;
BEGIN
    SELECT common.merchant.xjson ->> 'GetQrCode' INTO xurl FROM common.merchant WHERE idmerch = xmerch;
    SELECT common.merchant.xjson -> 'token' ->> 'access_token' INTO xaccess FROM common.merchant WHERE idmerch = xmerch;
    xurlj := json_build_object('Url', xurl, 'Authorization', xaccess );
    RETURN xurlj;
END;
$function$
;

-- Permissions

ALTER FUNCTION mytosb.f_heads() OWNER TO postgres;
GRANT ALL ON FUNCTION mytosb.f_heads() TO postgres;
GRANT ALL ON FUNCTION mytosb.f_heads() TO apis;
GRANT ALL ON FUNCTION mytosb.f_heads() TO apiataxi;
GRANT ALL ON FUNCTION mytosb.f_heads() TO alexr;
GRANT ALL ON FUNCTION mytosb.f_heads() TO "AlekzP";
GRANT ALL ON FUNCTION mytosb.f_heads() TO "Alef";

-- DROP FUNCTION mytosb.f_syspay(json);

CREATE OR REPLACE FUNCTION mytosb.f_syspay(x_json json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE 
		xans JSON;
		xidpay JSON;
		xmerch INTEGER;
		xnewid INTEGER;
		xservice INTEGER;
		xcomiss NUMERIC(3,2);
		xamount_inside INTEGER;
		xamount INTEGER;
		xamount_comiss INTEGER;
		xname_prod VARCHAR;
		xaccount VARCHAR;
		xerr VARCHAR DEFAULT 'dublicate id_order';
		xtimestamp VARCHAR;
	--input data:
	--{
  --"login_dev": "uptaxi",
	--"url_callback": "https:.......", 
  --"id_order": "11a5ce1b-336a-11ed-a8af-b4d5bd9a0as",
  --"amount": 100,
  --"phone_ customer": "+79101234567",
  --"email_customer": "mail@mail.ru",
  --"datetime": "2023-02-17T12:13:30",
  --"principal": "200190",
  --"products": 
  --[
  --{
  --"name_prod": "pizza", "unit": "1","count": 1, "price": 100,"amount_prod": 10000
  --},
	--{
  --"name_prod": "pizza", "unit": "1","count": 1, "price": 100,"amount_prod": 10000
  --}
  --]
  --}
BEGIN
	xtimestamp := jsonb_build_object('timestamp',common.f_timestamp());
	xidpay := jsonb_build_object('login_dev',x_json::jsonb ->> 'login_dev','id_order',x_json::jsonb ->> 'id_order');
	xaccount := x_json::jsonb ->> 'principal';
	xname_prod := (x_json::jsonb -> 'products' -> 0 -> 'name_prod');
	SELECT fljson_firm ->> 'service',(fljson_firm ->> 'upcomission')::numeric(3,2) 
	INTO xservice,xcomiss FROM common.firmservice WHERE idfirm = LEFT(xaccount,6);
	SELECT syspay INTO xmerch FROM mytosb.info WHERE service = xservice;
	SELECT xjson -> 'DataQrCode' INTO xans FROM common.merchant WHERE idmerch = xmerch;
	xamount_inside := (x_json::jsonb ->> 'amount')::integer;
	xamount_comiss := ((x_json::jsonb ->> 'amount')::integer * xcomiss::numeric(3,2))::integer;
	xamount := (x_json::jsonb ->> 'amount')::integer + xamount_comiss::integer;
	x_json := jsonb_set(x_json::jsonb,'{amount}',(xamount::text)::jsonb,FALSE);
	x_json := x_json::jsonb || xtimestamp::jsonb || jsonb_build_object('merch',xmerch,'upcomiss',xamount_comiss,'amount_inside',xamount_inside);
	BEGIN
		INSERT INTO mytosb.syspay (json_inside,idpay) VALUES (x_json,xidpay) RETURNING id_paybank INTO xnewid;
		EXCEPTION WHEN unique_violation THEN
			xans := jsonb_build_object('err',1,'ans',xerr);
		RETURN xans;
	END;
	xans := jsonb_set(xans::jsonb,'{Data,amount}',(xamount::text)::jsonb,FALSE);
	xans := jsonb_set(xans::jsonb,'{Data,paymentPurpose}',xname_prod::jsonb,FALSE);
	xans := jsonb_build_object('err',0,'newid',xnewid,'ans',xans) || xtimestamp::jsonb;
	UPDATE mytosb.syspay SET json_tobank = xans WHERE id_paybank = xnewid;	
  RETURN xans;
END;
--output data:
--{
--"Data": {
		--"ttl": 25,  
		--"amount": "0", 
		--"qrcType": "02", 
		--"currency": "RUB", 
		--"sourceName": "atotx", 
		--"imageParams": {
				--"width": 200, 
				--"height": 200, 
				--"mediaType": "image/png"
				--}, 
		--"paymentPurpose": "услуги такси"
		--}
--}
$function$
;

-- Permissions

ALTER FUNCTION mytosb.f_syspay(json) OWNER TO postgres;
GRANT ALL ON FUNCTION mytosb.f_syspay(json) TO postgres;
GRANT ALL ON FUNCTION mytosb.f_syspay(json) TO apis;
GRANT ALL ON FUNCTION mytosb.f_syspay(json) TO apiataxi;
GRANT ALL ON FUNCTION mytosb.f_syspay(json) TO alexr;
GRANT ALL ON FUNCTION mytosb.f_syspay(json) TO "AlekzP";
GRANT ALL ON FUNCTION mytosb.f_syspay(json) TO "Alef";

-- DROP FUNCTION mytosb.f_syspay_transfer(json);

CREATE OR REPLACE FUNCTION mytosb.f_syspay_transfer(x_json json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE xans JSON;
	DECLARE xidpay JSON;
	DECLARE xmerch INTEGER;
  DECLARE xnewid INTEGER;
	DECLARE xservice INTEGER;
	DECLARE xcomiss NUMERIC(3,2);
	DECLARE xlogin_dev JSON DEFAULT '{"login_dev": "transfer"}';
	DECLARE xurl_callback VARCHAR DEFAULT NULL;
	DECLARE xprincipal JSON DEFAULT '{"principal": "200220"}';
	DECLARE xproducts JSON DEFAULT '{"products": [{"unit": "шт", "count": 1, "price": 0, "name_prod": "услуги трансфера", "amount_prod": 0, "supplier_phone": "+79409912255"}]}';
  DECLARE xamount VARCHAR;
  DECLARE xaccount VARCHAR;
	DECLARE xerr VARCHAR DEFAULT 'dublicate id_order';
	DECLARE xtimestamp VARCHAR;
	--input data:
	--{
  --"login_dev": "uptaxi",
	--"client_id": "111",
	--"url_callback": "https:.......", 
  --"id_order": "11a5ce1b-336a-11ed-a8af-b4d5bd9a0as",
  --"amount": 100,
  --"phone_ customer": "+79101234567",
  --"email_customer": "mail@mail.ru",
  --"datetime": "2023-02-17T12:13:30",
  --"principal": "200190",
  --"products": 
  --[
  --{
  --"name_prod": "pizza", "unit": "1","count": 1, "price": 100,"amount_prod": 10000
  --},
	--{
  --"name_prod": "pizza", "unit": "1","count": 1, "price": 100,"amount_prod": 10000
  --}
  --]
  --}
BEGIN
	xtimestamp := jsonb_build_object('timestamp',common.f_timestamp());
	xidpay := xlogin_dev::jsonb || jsonb_build_object('id_order',x_json::jsonb ->> 'id_order');
	xaccount := xprincipal::jsonb ->> 'principal';
	SELECT fljson_firm ->> 'service',fljson_firm ->> 'upcomission' 
	INTO xservice,xcomiss FROM common.firmservice WHERE idfirm = xaccount;
	SELECT syspay INTO xmerch FROM mytosb.info WHERE service = xservice;
	SELECT xjson -> 'DataQrCode' INTO xans FROM common.merchant WHERE idmerch = xmerch;
	xamount := ((x_json::jsonb ->> 'amount')::integer + ((x_json::jsonb ->> 'amount')::integer * xcomiss::numeric(3,2))::integer)::text;
	x_json := jsonb_set(x_json::jsonb,'{amount}',xamount::jsonb,FALSE);
	x_json := x_json::jsonb || xtimestamp::jsonb || jsonb_build_object('datetime',common.f_timestamp(),'merch',xmerch) || 
	xidpay::jsonb || xprincipal::jsonb || xproducts::jsonb;
	x_json := jsonb_set(x_json::jsonb,'{products,0,price}',xamount::jsonb,FALSE);
	x_json := jsonb_set(x_json::jsonb,'{products,0,amount_prod}',xamount::jsonb,FALSE);
	BEGIN
		INSERT INTO mytosb.syspay (json_inside,idpay) VALUES (x_json,xidpay) RETURNING id_paybank INTO xnewid;
		EXCEPTION WHEN unique_violation THEN
			xans := jsonb_build_object('err',1,'ans',xerr);
		RETURN xans;
	END;
	xans := jsonb_set(xans::jsonb,'{Data,amount}',xamount::jsonb,FALSE);
	xans := jsonb_build_object('err',0,'newid',xnewid,'ans',xans) || xtimestamp::jsonb;
	UPDATE mytosb.syspay SET json_tobank = xans WHERE id_paybank = xnewid;	
  RETURN xans;
END;
--output data:
--{
--"Data": {
		--"ttl": 25,  
		--"amount": "0", 
		--"qrcType": "02", 
		--"currency": "RUB",  
		--"sourceName": "atotx", 
		--"imageParams": {
				--"width": 200, 
				--"height": 200, 
				--"mediaType": "image/png"
				--}, 
		--"paymentPurpose": "услуги такси"
		--}
--}
$function$
;

-- Permissions

ALTER FUNCTION mytosb.f_syspay_transfer(json) OWNER TO postgres;
GRANT ALL ON FUNCTION mytosb.f_syspay_transfer(json) TO public;
GRANT ALL ON FUNCTION mytosb.f_syspay_transfer(json) TO postgres;
GRANT ALL ON FUNCTION mytosb.f_syspay_transfer(json) TO apiataxi;
GRANT ALL ON FUNCTION mytosb.f_syspay_transfer(json) TO apis;
GRANT ALL ON FUNCTION mytosb.f_syspay_transfer(json) TO alexr;
GRANT ALL ON FUNCTION mytosb.f_syspay_transfer(json) TO "AlekzP";
GRANT ALL ON FUNCTION mytosb.f_syspay_transfer(json) TO "Alef";

-- DROP FUNCTION mytosb.f_token_access(json);

CREATE OR REPLACE FUNCTION mytosb.f_token_access(x_json json)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
	DECLARE xmerch INTEGER DEFAULT 26;
	DECLARE yjson json;
	DECLARE zjson json;
BEGIN
		SELECT xjson - 'token' INTO zjson FROM common.merchant WHERE idmerch = xmerch;
		yjson := jsonb_build_object('token',x_json) || zjson::jsonb;
    UPDATE common.merchant SET xjson = yjson WHERE idmerch = xmerch;
END;
$function$
;

-- Permissions

ALTER FUNCTION mytosb.f_token_access(json) OWNER TO postgres;
GRANT ALL ON FUNCTION mytosb.f_token_access(json) TO postgres;
GRANT ALL ON FUNCTION mytosb.f_token_access(json) TO apis;
GRANT ALL ON FUNCTION mytosb.f_token_access(json) TO apit;
GRANT ALL ON FUNCTION mytosb.f_token_access(json) TO apiataxi;
GRANT ALL ON FUNCTION mytosb.f_token_access(json) TO alexr;
GRANT ALL ON FUNCTION mytosb.f_token_access(json) TO "AlekzP";
GRANT ALL ON FUNCTION mytosb.f_token_access(json) TO "Alef";

-- DROP FUNCTION mytosb.f_token_refresh();

CREATE OR REPLACE FUNCTION mytosb.f_token_refresh()
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE xmerch INTEGER DEFAULT 26;
	DECLARE xanswer JSON;
	DECLARE xid VARCHAR;
	DECLARE xsecret json;
	DECLARE xrefresh json;
	DECLARE xref_url json;
BEGIN
    SELECT xjson ->> 'client_id',xjson -> 'client_secret',xjson -> 'refresh_url',xjson -> 'token' -> 'refresh_token'
		INTO xid,xsecret,xref_url,xrefresh
		FROM common.merchant 
		WHERE idmerch = xmerch;
    xanswer := jsonb_build_object('ref_url',xref_url) || 
		jsonb_build_object('json_data',jsonb_build_object('client_id',xid,'client_secret',xsecret,'refresh_token',xrefresh,'grant_type','refresh_token'));
    RETURN xanswer;
END;
$function$
;

-- Permissions

ALTER FUNCTION mytosb.f_token_refresh() OWNER TO postgres;
GRANT ALL ON FUNCTION mytosb.f_token_refresh() TO postgres;
GRANT ALL ON FUNCTION mytosb.f_token_refresh() TO apis;
GRANT ALL ON FUNCTION mytosb.f_token_refresh() TO apit;
GRANT ALL ON FUNCTION mytosb.f_token_refresh() TO apiataxi;
GRANT ALL ON FUNCTION mytosb.f_token_refresh() TO alexr;
GRANT ALL ON FUNCTION mytosb.f_token_refresh() TO "AlekzP";
GRANT ALL ON FUNCTION mytosb.f_token_refresh() TO "Alef";

-- DROP FUNCTION mytosb.f_tr_payment();

CREATE OR REPLACE FUNCTION mytosb.f_tr_payment()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
	DECLARE 
		xdata JSON; 
	  xpaymerch JSON; 
	  xjsonfirm JSON;
	  xjsoncomm JSON;
	  xlogin JSON;
	  xmerch JSON;
	  xtarif JSON; 
	  xekassa JSON;
	  xproducts JSON;
		xsuplier_org JSON;
	  xbillid INTEGER;
	  xcommparam INTEGER;
	  xyear INTEGER;
	  xamount INTEGER;
	  xidmerch INTEGER;
	  xsum NUMERIC(10,2);
	  xratio NUMERIC(10,2);
	  xidtarif INTEGER;
	  xnewid INTEGER;
	  xfirm CHAR(6);
	  xorg CHAR(2);
	  xidlogin CHAR(10);
    xdatetime VARCHAR;
    xemail VARCHAR;
    xphone VARCHAR;
	  xchannel VARCHAR;
BEGIN 
		SELECT NEW.json_inside,LEFT(NEW.json_inside ->> 'principal',6),(NEW.json_inside ->> 'amount')::integer,NEW.id_paybank,NEW.json_inside ->> 'datetime',
		NEW.json_inside ->> 'phone_customer',NEW.json_inside ->> 'email_customer',NEW.json_inside -> 'products',NEW.json_inside -> 'merch' 
		INTO xdata,xfirm,xamount,xbillid,xdatetime,xphone,xemail,xproducts,xidmerch FROM mytosb.syspay; 
		xyear := LEFT(xdatetime,4)::integer;
		xdata := xdata::jsonb || jsonb_build_object('id_paybank',xbillid);
		SELECT fljson_firm,fljson_firm ->> 'login',idcommparam,firm INTO xjsonfirm,xidlogin,xcommparam,xorg
		FROM common.firmservice WHERE idfirm = xfirm;
		SELECT json_commparam INTO xjsoncomm FROM common.commparam WHERE idcommparam = xcommparam AND common.commparam."enable" = true;
		SELECT attributies INTO xlogin FROM auth.users WHERE login_master = xidlogin;
		SELECT jsonb_build_object('org',(form_org || ' ' || name_org),'inn',inn_org) 
		INTO xsuplier_org FROM common.organisations WHERE id_firm = xorg;
		SELECT accesuaries,(accesuaries ->> 'format_amount')::numeric INTO xmerch,xratio FROM common.merchant WHERE idmerch = xidmerch;
		xsum := (xamount * xratio)::numeric(10,2);
		SELECT common.tranztarif."Tarif" INTO xidtarif 
		FROM common.tranztarif JOIN common.breakesum ON (common.tranztarif."Breakesum" = common.breakesum.idbreake) 
		WHERE common.tranztarif."Firm" = xfirm AND common.tranztarif."Syspay" = xidmerch AND common.tranztarif."Enable" = 1 
		AND (xsum < (common.breakesum.json_breakesum ->> 'Maxsum')::numeric AND xsum > (common.breakesum.json_breakesum ->> 'Minsum')::numeric);
		SELECT json_tarif INTO xtarif FROM common.tarif WHERE idtarif = xidtarif;
		xpaymerch := jsonb_build_object('id_order',xdata ->> 'id_order','merch',xidmerch);
		SELECT ecassa::jsonb INTO xekassa FROM mytosb.info WHERE syspay = xidmerch;
		SELECT channel_notify INTO xchannel FROM ekassa.ekassa WHERE id_kass = (xekassa -> 'ecassa' ->> 0)::integer;
		BEGIN
			INSERT INTO reports.payment(data_json,year,idpaymerch,comm_json,firm_json,merch_json,tarif_json,e_kassa)
			VALUES (xdata,xyear,xpaymerch,xjsoncomm,(xjsonfirm::jsonb || xlogin::jsonb || xsuplier_org::jsonb),xmerch,xtarif,xekassa) 
			ON CONFLICT DO NOTHING RETURNING qtranz INTO xnewid;
		END;
		PERFORM pg_notify(xchannel,xnewid::text);
		RETURN NULL;
END
$function$
;

-- Permissions

ALTER FUNCTION mytosb.f_tr_payment() OWNER TO postgres;
GRANT ALL ON FUNCTION mytosb.f_tr_payment() TO public;
GRANT ALL ON FUNCTION mytosb.f_tr_payment() TO postgres;
GRANT ALL ON FUNCTION mytosb.f_tr_payment() TO apiataxi;
GRANT ALL ON FUNCTION mytosb.f_tr_payment() TO apis;
GRANT ALL ON FUNCTION mytosb.f_tr_payment() TO alexr;
GRANT ALL ON FUNCTION mytosb.f_tr_payment() TO "AlekzP";
GRANT ALL ON FUNCTION mytosb.f_tr_payment() TO "Alef";

-- DROP FUNCTION mytosb.f_tr_payment_test();

CREATE OR REPLACE FUNCTION mytosb.f_tr_payment_test()
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
	DECLARE 
		xdata JSON; 
	  xpaymerch JSON; 
	  xjsonfirm JSON;
	  xjsoncomm JSON;
	  xlogin JSON;
	  xmerch JSON;
	  xtarif JSON; 
	  xekassa JSON;
	  xproducts JSON;
	  xbillid INTEGER;
	  xcommparam INTEGER;
	  xyear INTEGER;
	  xamount INTEGER;
	  xidmerch INTEGER;
	  xsum NUMERIC(10,2);
	  xratio NUMERIC(10,2);
	  xidtarif INTEGER;
	  xnewid INTEGER;
	  xfirm CHAR(6);
	  xorg CHAR(2);
	  xsuplier_org JSON;
	  xidlogin CHAR(10);
    xdatetime VARCHAR;
    xemail VARCHAR;
    xphone VARCHAR;
	  xchannel VARCHAR;
BEGIN 
		SELECT json_inside,LEFT(json_inside ->> 'principal',6),(json_inside ->> 'amount')::integer,id_paybank,json_inside ->> 'datetime',
		json_inside ->> 'phone_customer',json_inside ->> 'email_customer',json_inside -> 'products',json_inside -> 'merch' 
		INTO xdata,xfirm,xamount,xbillid,xdatetime,xphone,xemail,xproducts,xidmerch FROM mytosb.syspay WHERE id_paybank = 776; 
		xyear := LEFT(xdatetime,4)::integer;
		xdata := xdata::jsonb || jsonb_build_object('id_paybank',xbillid);
		SELECT fljson_firm,fljson_firm ->> 'login',idcommparam,firm INTO xjsonfirm,xidlogin,xcommparam,xorg
		FROM common.firmservice WHERE idfirm = xfirm;
		SELECT json_commparam INTO xjsoncomm FROM common.commparam WHERE idcommparam = xcommparam AND common.commparam."enable" = true;
		SELECT attributies INTO xlogin FROM auth.users WHERE login_master = xidlogin;
		SELECT jsonb_build_object('org',(form_org || ' ' || name_org),'inn',inn_org) 
		INTO xsuplier_org FROM common.organisations WHERE id_firm = xorg;
		SELECT accesuaries,(accesuaries ->> 'format_amount')::numeric INTO xmerch,xratio FROM common.merchant WHERE idmerch = xidmerch;
		xsum := (xamount * xratio)::numeric(10,2);
		SELECT common.tranztarif."Tarif" INTO xidtarif 
		FROM common.tranztarif JOIN common.breakesum ON (common.tranztarif."Breakesum" = common.breakesum.idbreake) 
		WHERE common.tranztarif."Firm" = xfirm AND common.tranztarif."Syspay" = xidmerch AND common.tranztarif."Enable" = 1 
		AND (xsum < (common.breakesum.json_breakesum ->> 'Maxsum')::numeric AND xsum > (common.breakesum.json_breakesum ->> 'Minsum')::numeric);
		SELECT json_tarif INTO xtarif FROM common.tarif WHERE idtarif = xidtarif;
		xpaymerch := jsonb_build_object('id_order',xdata ->> 'id_order','merch',xidmerch);
		SELECT ecassa::jsonb INTO xekassa FROM mytosb.info WHERE syspay = xidmerch;
		SELECT channel_notify INTO xchannel FROM ekassa.ekassa WHERE id_kass = (xekassa -> 'ecassa' ->> 0)::integer;
		BEGIN
			INSERT INTO reports.payment(data_json,year,idpaymerch,comm_json,firm_json,merch_json,tarif_json,e_kassa)
			VALUES (xdata,xyear,xpaymerch,xjsoncomm,(xjsonfirm::jsonb || xlogin::jsonb || xsuplier_org::jsonb),xmerch,xtarif,xekassa) 
			ON CONFLICT DO NOTHING RETURNING qtranz INTO xnewid;
		END;
		PERFORM pg_notify(xchannel,xnewid::text);
		--RETURN xekassa;
		RETURN xsuplier_org;
END
$function$
;

-- Permissions

ALTER FUNCTION mytosb.f_tr_payment_test() OWNER TO postgres;
GRANT ALL ON FUNCTION mytosb.f_tr_payment_test() TO public;
GRANT ALL ON FUNCTION mytosb.f_tr_payment_test() TO postgres;
GRANT ALL ON FUNCTION mytosb.f_tr_payment_test() TO apiataxi;
GRANT ALL ON FUNCTION mytosb.f_tr_payment_test() TO "AlekzP";
GRANT ALL ON FUNCTION mytosb.f_tr_payment_test() TO "Alef";


-- Permissions

GRANT ALL ON SCHEMA mytosb TO postgres;
GRANT USAGE ON SCHEMA mytosb TO apiw;
GRANT USAGE ON SCHEMA mytosb TO apis;
GRANT USAGE ON SCHEMA mytosb TO apit;
GRANT USAGE ON SCHEMA mytosb TO apiataxi;
GRANT USAGE ON SCHEMA mytosb TO ataxi;
GRANT USAGE ON SCHEMA mytosb TO alexr;
GRANT USAGE ON SCHEMA mytosb TO "AlekzP";
GRANT USAGE ON SCHEMA mytosb TO "Alef";