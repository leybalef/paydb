-- DROP SCHEMA ekassa;

CREATE SCHEMA ekassa AUTHORIZATION postgres;

-- DROP SEQUENCE ekassa.ekassa_id_ekassa_seq;

CREATE SEQUENCE ekassa.ekassa_id_ekassa_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;-- ekassa.ekassa определение

-- Drop table

-- DROP TABLE ekassa.ekassa;

CREATE TABLE ekassa.ekassa (
	id_kass int4 DEFAULT nextval('ekassa.ekassa_id_ekassa_seq'::regclass) NOT NULL,
	json_settings jsonb NULL,
	org varchar(12) NULL,
	provider varchar(50) NULL,
	channel_notify varchar(20) NULL,
	CONSTRAINT spr_ekassa_pkey PRIMARY KEY (id_kass)
);


-- ekassa.ekassa_check определение

-- Drop table

-- DROP TABLE ekassa.ekassa_check;

CREATE TABLE ekassa.ekassa_check (
	id_ekassa int4 DEFAULT nextval('ekassa.ekassa_id_ekassa_seq'::regclass) NOT NULL,
	query_check jsonb NULL,
	ans_ekassa jsonb NULL,
	call_back jsonb NULL,
	"year" int2 NOT NULL,
	data_check jsonb NULL,
	qtranz_payment int8 NULL,
	query_check2 varchar NULL
)
PARTITION BY RANGE (year);


-- ekassa.ekassa_2023 определение

CREATE TABLE ekassa.ekassa_2023 PARTITION OF ekassa.ekassa_check (
	CONSTRAINT ekassa_2023_pkey PRIMARY KEY (id_ekassa),
	CONSTRAINT qtranz_pay2023 UNIQUE (qtranz_payment)
) FOR VALUES FROM ('2023') TO ('2024');


-- ekassa.ekassa_2024 определение

CREATE TABLE ekassa.ekassa_2024 PARTITION OF ekassa.ekassa_check (
	CONSTRAINT ekassa_2024_pkey PRIMARY KEY (id_ekassa),
	CONSTRAINT qtranz_pay2024 UNIQUE (qtranz_payment)
) FOR VALUES FROM ('2024') TO ('2025');


-- ekassa.ekassa_2025 определение

CREATE TABLE ekassa.ekassa_2025 PARTITION OF ekassa.ekassa_check (
	CONSTRAINT ekassa_2025_pkey PRIMARY KEY (id_ekassa),
	CONSTRAINT qtranz_pay2025 UNIQUE (qtranz_payment)
) FOR VALUES FROM ('2025') TO ('2026');


-- ekassa.ekassa_2026 определение

CREATE TABLE ekassa.ekassa_2026 PARTITION OF ekassa.ekassa_check (
	CONSTRAINT ekassa_2026_pkey PRIMARY KEY (id_ekassa),
	CONSTRAINT qtranz_pay2026 UNIQUE (qtranz_payment)
) FOR VALUES FROM ('2026') TO ('2027');


-- ekassa.ekassa_2027 определение

CREATE TABLE ekassa.ekassa_2027 PARTITION OF ekassa.ekassa_check (
	CONSTRAINT ekassa_2027_pkey PRIMARY KEY (id_ekassa),
	CONSTRAINT qtranz_pay2027 UNIQUE (qtranz_payment)
) FOR VALUES FROM ('2027') TO ('2028');


-- ekassa.ekassa_2028 определение

CREATE TABLE ekassa.ekassa_2028 PARTITION OF ekassa.ekassa_check (
	CONSTRAINT ekassa_2028_pkey PRIMARY KEY (id_ekassa),
	CONSTRAINT qtranz_pay2028 UNIQUE (qtranz_payment)
) FOR VALUES FROM ('2028') TO ('2029');


-- ekassa.ekassa_2029 определение

CREATE TABLE ekassa.ekassa_2029 PARTITION OF ekassa.ekassa_check (
	CONSTRAINT ekassa_2029_pkey PRIMARY KEY (id_ekassa),
	CONSTRAINT qtranz_pay2029 UNIQUE (qtranz_payment)
) FOR VALUES FROM ('2029') TO ('2030');



-- DROP FUNCTION ekassa.f_ansclient(json, bpchar);

CREATE OR REPLACE FUNCTION ekassa.f_ansclient(param json, ans_client character)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
	DECLARE xanswer JSON;
	DECLARE xyear INTEGER;
	DECLARE xqtranz INTEGER;
 BEGIN
 xyear := (param::jsonb ->> 'year')::integer;
 xqtranz := (param::jsonb ->> 'qtranz')::integer;
 SELECT answer INTO xanswer FROM reports.payment WHERE "year" = xyear AND qtranz = xqtranz;
 xanswer := xanswer::jsonb || jsonb_build_object('ekassa',ans_client);
 UPDATE reports.payment SET answer = xanswer WHERE "year" = xyear AND qtranz = xqtranz;
END
$function$
;

-- DROP FUNCTION ekassa.f_array(varchar);

CREATE OR REPLACE FUNCTION ekassa.f_array(xarray character varying)
 RETURNS character varying
 LANGUAGE plpython3u
AS $function$
import json
import hashlib
		
x_array = xarray[0]		
		
		
return x_array
  $function$
;

-- DROP FUNCTION ekassa.f_businessru_callback(json);

CREATE OR REPLACE FUNCTION ekassa.f_businessru_callback(x_json_clbk json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE xqtranz VARCHAR;
	DECLARE xid_order VARCHAR;
	DECLARE xcheck_url VARCHAR;
	DECLARE xyear INTEGER;
	DECLARE xurl_callback VARCHAR;
	DECLARE xid_callback VARCHAR DEFAULT 'fiskal_check';
	DECLARE xclient_clbk JSON;
BEGIN
	xqtranz := x_json_clbk::jsonb ->> 'c_num';
	xcheck_url := x_json_clbk::jsonb ->> 'receipt_url';
	xcheck_url := replace(xcheck_url,'\','');
	SELECT data_json ->> 'url_callback',"year" INTO xurl_callback,xyear FROM reports.payment WHERE qtranz::text = xqtranz;
	SELECT data_check ->> 'id_order' INTO xid_order FROM ekassa.ekassa_check WHERE qtranz_payment::text = xqtranz;
	UPDATE ekassa.ekassa_check SET call_back = x_json_clbk WHERE qtranz_payment = xqtranz::integer; 
	xclient_clbk := jsonb_build_object('url_callback',xurl_callback,'client',
	jsonb_build_object('id_callback',xid_callback,'id_order',xid_order,'fiskal_url',xcheck_url),
	'answer',jsonb_build_object('bill',true,'qtranz',xqtranz,'year',xyear));
	RETURN xclient_clbk;
END
$function$
;

-- DROP FUNCTION ekassa.f_check_businessru(int4);

CREATE OR REPLACE FUNCTION ekassa.f_check_businessru(xid integer)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
	DECLARE 
	xquery_check JSON;
	xdata_check JSON;
	xcommand JSON;
	xproducts JSON;
	xgoods JSON;
	xgoods_array JSON;
	xagent_data JSON;
	xresult_goods JSON DEFAULT '[]';
	xquery_kassa VARCHAR;
	xsecret VARCHAR;
  xidorder VARCHAR;
	xcheck_url VARCHAR;
	xanswer VARCHAR;
	xhash VARCHAR;
	xnonce VARCHAR;
	xprincipal VARCHAR;
	xphone_customer VARCHAR;
	xphone VARCHAR;
	xid_phone_agent VARCHAR;
	xprodtype VARCHAR;
	xinn VARCHAR;
	xemail VARCHAR;
	xname VARCHAR;
	xname_prod VARCHAR;
	xtoken VARCHAR;
	xparam VARCHAR;
	xcomission VARCHAR;
	xerr VARCHAR DEFAULT 'dublicate qtranz';
	xratio NUMERIC (3,2);
	xmerch INTEGER;
	xsupplier INTEGER;
	xlength_array INTEGER;
	xidpayment INTEGER;
	xcontragent INTEGER;
	xekassa INTEGER;
	xid_ekassa INTEGER;
	xcount_prod INTEGER;
	xcount_agent INTEGER;
	xyear INTEGER;
	i INTEGER;
	xamount float;
	xcomiss_amount float;
	xprice_prod float;
	xamount_prod float;
	xagent BOOLEAN;
	BEGIN
		SELECT MD5(RANDOM()::text) INTO xnonce;
		xidpayment = xid;
		xyear := (LEFT(common.f_timestamp(),4))::integer;
		SELECT LEFT(data_json ->> 'principal',6),
					 data_json ->> 'phone_customer',
					 data_json ->> 'email_customer',
					 (data_json ->> 'amount')::float,
					 data_json -> 'products',
					 data_json ->> 'id_order',
					 e_kassa #>> '{ecassa,0}'
		INTO xprincipal,xphone_customer,xemail,xamount,xproducts,xidorder,xekassa 
		FROM reports.payment WHERE qtranz = xidpayment;
		xlength_array := jsonb_array_length(xproducts::jsonb);
		xdata_check := jsonb_build_object('ecassa',xekassa,'id_order',xidorder);
		SELECT json_settings ->> 'sec',json_settings ->> 'token',json_settings ->> 'PutCheckUrl',json_settings -> 'PutCheck',json_settings -> 'PutCheck' -> 'command' -> 'goods' 
		INTO xsecret,xtoken,xcheck_url,xquery_check,xgoods_array FROM ekassa.ekassa WHERE id_kass = xekassa;
		SELECT contragent,ekassa ->> 'agent',ekassa ->> 'item_type',ekassa -> 'comiss_agent' ->> 'comission',merchant 
		INTO xcontragent,xagent,xprodtype,xcomission,xmerch FROM mytosb.contracts WHERE firmservice = xprincipal;
		SELECT fljson_firm ->> 'upcomission' INTO xcomiss_amount FROM common.firmservice WHERE idfirm = xprincipal;
		SELECT (accesuaries ->> 'format_amount')::numeric(3,2) INTO xratio FROM common.merchant WHERE idmerch = xmerch;
		xamount := (xamount::numeric(10,2) * xratio)::NUMERIC(10,2);
		FOR i IN 1..xlength_array LOOP
			xcount_prod := xproducts::jsonb -> i-1 ->> 'count';
			xprice_prod := xproducts::jsonb -> i-1 ->> 'price';
			xprice_prod := (xprice_prod * xratio::numeric(3,2))::float;
			xname_prod := xproducts::jsonb -> i-1 ->> 'name_prod';
			xamount_prod := xproducts::jsonb -> i-1 ->> 'amount_prod';
			xamount_prod := (xamount_prod::numeric(10,2) * xratio::numeric(3,2))::float;
			IF xagent = TRUE THEN
				xid_phone_agent := xproducts::jsonb -> i-1 ->> 'supplier_phone';
				SELECT COUNT(contragent) INTO xcount_agent FROM mytosb.contracts WHERE login_phone = xid_phone_agent and merchant = xmerch;
				IF xcount_agent = 0 THEN 
					SELECT contragent INTO xsupplier FROM mytosb.contracts WHERE firmservice = xprincipal;
				ELSE
					SELECT contragent INTO xsupplier FROM mytosb.contracts WHERE login_phone = xid_phone_agent;
				END IF;
				SELECT fljson_privilege ->> 'inn',
						   fljson_privilege ->> 'phone',
					     fljson_privilege ->> 'name'
		    INTO xinn,xphone,xname FROM "user".users WHERE idpriv = xsupplier;
				xagent_data := jsonb_build_object('type',32,'supplier_inn',xinn,'supplier_name',xname,'supplier_phone',xphone);
				xgoods := xgoods_array::jsonb -> 0; 
			  xgoods := xgoods::jsonb - 'sum' - 'name' - 'count' - 'price' - 'agent_info' - 'item_type';
				xgoods := xgoods::jsonb || 
				jsonb_build_object('sum',xamount_prod,'name',xname_prod,'count',xcount_prod,'price',xprice_prod,'item_type',xprodtype,'agent_info',xagent_data);  
		  ELSE
				xgoods := xgoods_array::jsonb -> 0;
				xgoods := xgoods::jsonb - 'sum' - 'name' - 'count' - 'price' - 'agent_info' - 'item_type';
				xgoods := xgoods::jsonb || 
				jsonb_build_object('sum',xamount_prod,'name',xname_prod,'count',xcount_prod,'price',xprice_prod,'item_type',xprodtype);
			END IF;
			xresult_goods := xresult_goods::jsonb || xgoods::jsonb;
		END LOOP; 
		xcomiss_amount := ((xamount - (xamount / (1 + xcomiss_amount)))::numeric(10,2))::float;
		xgoods_array := (xgoods_array::jsonb -> 0) - 'agent_info' - 'sum' - 'name' - 'count' - 'price' - 'item_type';
		xgoods_array := xgoods_array::jsonb || jsonb_build_object('sum',xcomiss_amount,'name',xcomission,'count',1,'price',xcomiss_amount,'item_type',4);
		xresult_goods := xresult_goods::jsonb || xgoods_array::jsonb;
		xcommand := ((xquery_check -> 'command')::jsonb - 'goods' - 'c_num' - 'payed_cashless') || 
		jsonb_build_object('goods',xresult_goods::jsonb,'c_num',xidpayment,'payed_cashless',xamount);
		IF xemail IS NOT NULL THEN
			xcommand := xcommand::jsonb - 'smsEmail54FZ' || jsonb_build_object('smsEmail54FZ',xemail); 
		END IF;
		xquery_check := xquery_check::jsonb - 'command' || jsonb_build_object('nonce',xnonce,'token',xtoken,'command',xcommand::jsonb);
		xanswer := ekassa.f_sort_json(xquery_check,xsecret);
		xparam := SPLIT_PART(xanswer, '~&~', 1);
		xhash := SPLIT_PART(xanswer, '~&~', 2);
		xquery_kassa := json_build_object('check_url',xcheck_url,'hash',xhash);
	  xquery_kassa := ekassa.f_pt_json(xquery_kassa,xparam);
		BEGIN	
            ---xquery_kassa := xquery_kassa::jsonb; 
			INSERT INTO ekassa.ekassa_check (query_check2,year,data_check,qtranz_payment) VALUES (xquery_kassa,xyear,xdata_check,xidpayment) RETURNING id_ekassa INTO xid_ekassa; 
			EXCEPTION WHEN unique_violation THEN
				xquery_kassa := jsonb_build_object('err',1,'ans',xerr);
			RETURN xcomiss_amount;
		END;
		UPDATE reports.payment SET ekassa_id = 1 WHERE qtranz = xidpayment; 
	RETURN xquery_kassa;
END
$function$
;

-- DROP FUNCTION ekassa.f_check_businessru_old(int4);

CREATE OR REPLACE FUNCTION ekassa.f_check_businessru_old(xid integer)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE xquery_check JSON;
	DECLARE xquery_kassa JSON;
	DECLARE xdata_check JSON;
	DECLARE xcommand JSON;
	DECLARE xproducts JSON;
	DECLARE xgoods JSON;
	DECLARE xgoods_array JSON;
	DECLARE xagent_data JSON;
	DECLARE xresult_goods JSON DEFAULT '[]';
	DECLARE xsecret VARCHAR;
	DECLARE xidorder VARCHAR;
	DECLARE xcheck_url VARCHAR;
	DECLARE xanswer VARCHAR;
	DECLARE xhash VARCHAR;
	DECLARE xnonce VARCHAR;
	DECLARE xprincipal VARCHAR;
	DECLARE xphone_customer VARCHAR;
	DECLARE xphone VARCHAR;
	DECLARE xid_phone_agent VARCHAR;
	DECLARE xprodtype VARCHAR;
	DECLARE xinn VARCHAR;
	DECLARE xemail VARCHAR;
	DECLARE xname VARCHAR;
	DECLARE xname_prod VARCHAR;
	DECLARE xtoken VARCHAR;
	DECLARE xparam VARCHAR;
	DECLARE xcomission VARCHAR;
	DECLARE xerr VARCHAR DEFAULT 'dublicate qtranz';
	DECLARE xratio NUMERIC (3,2);
	DECLARE xmerch INTEGER;
	DECLARE xsupplier INTEGER;
	DECLARE xlength_array INTEGER;
	DECLARE xidpayment INTEGER;
	DECLARE xcontragent INTEGER;
	DECLARE xekassa INTEGER;
	DECLARE xid_ekassa INTEGER;
	DECLARE xcount_prod INTEGER;
	DECLARE xcount_agent INTEGER;
	DECLARE xyear INTEGER;
	DECLARE i INTEGER;
	DECLARE xamount float;
	DECLARE xcomiss_amount float;
	DECLARE xprice_prod float;
	DECLARE xamount_prod float;
	DECLARE xagent BOOLEAN;
	BEGIN
		SELECT MD5(RANDOM()::text) INTO xnonce;
		xidpayment = xid;
		xyear := (LEFT(common.f_timestamp(),4))::integer;
		SELECT LEFT(data_json ->> 'principal',6),
					 data_json ->> 'phone_customer',
					 data_json ->> 'email_customer',
					 (data_json ->> 'amount')::float,
					 data_json -> 'products',
					 data_json ->> 'id_order',
					 e_kassa #>> '{ecassa,0}'
		INTO xprincipal,xphone_customer,xemail,xamount,xproducts,xidorder,xekassa 
		FROM reports.payment WHERE qtranz = xidpayment;
		xlength_array := jsonb_array_length(xproducts::jsonb);
		xdata_check := jsonb_build_object('ecassa',xekassa,'id_order',xidorder);
		SELECT json_settings ->> 'sec',json_settings ->> 'token',json_settings ->> 'PutCheckUrl',json_settings -> 'PutCheck',json_settings -> 'PutCheck' -> 'command' -> 'goods' 
		INTO xsecret,xtoken,xcheck_url,xquery_check,xgoods_array FROM ekassa.ekassa WHERE id_kass = xekassa;
		SELECT contragent,ekassa ->> 'agent',ekassa ->> 'item_type',ekassa -> 'comiss_agent' ->> 'comission',merchant 
		INTO xcontragent,xagent,xprodtype,xcomission,xmerch FROM mytosb.contracts WHERE firmservice = xprincipal;
		SELECT fljson_firm ->> 'upcomission' INTO xcomiss_amount FROM common.firmservice WHERE idfirm = xprincipal;
		SELECT (accesuaries ->> 'format_amount')::numeric(3,2) INTO xratio FROM common.merchant WHERE idmerch = xmerch;
		xamount := (xamount::numeric(10,2) * xratio)::NUMERIC(10,2);
		FOR i IN 1..xlength_array LOOP
			xcount_prod := xproducts::jsonb -> i-1 ->> 'count';
			xprice_prod := xproducts::jsonb -> i-1 ->> 'price';
			xprice_prod := (xprice_prod * xratio::numeric(3,2))::float;
			xname_prod := xproducts::jsonb -> i-1 ->> 'name_prod';
			xamount_prod := xproducts::jsonb -> i-1 ->> 'amount_prod';
			xamount_prod := (xamount_prod::numeric(10,2) * xratio::numeric(3,2))::float;
			IF xagent = TRUE THEN
				xid_phone_agent := xproducts::jsonb -> i-1 ->> 'supplier_phone';
				SELECT COUNT(contragent) INTO xcount_agent FROM mytosb.contracts WHERE login_phone = xid_phone_agent and merchant = xmerch;
				IF xcount_agent = 0 THEN 
					SELECT contragent INTO xsupplier FROM mytosb.contracts WHERE firmservice = xprincipal;
				ELSE
					SELECT contragent INTO xsupplier FROM mytosb.contracts WHERE login_phone = xid_phone_agent;
				END IF;
				SELECT fljson_privilege ->> 'inn',
						   fljson_privilege ->> 'phone',
					     fljson_privilege ->> 'name'
		    INTO xinn,xphone,xname FROM "user".users WHERE idpriv = xsupplier;
				xagent_data := jsonb_build_object('type',32,'supplier_inn',xinn,'supplier_name',xname,'supplier_phone',xphone);
				xgoods := xgoods_array::jsonb -> 0; 
			  xgoods := xgoods::jsonb - 'sum' - 'name' - 'count' - 'price' - 'agent_info' - 'item_type';
				xgoods := xgoods::jsonb || 
				jsonb_build_object('sum',xamount_prod,'name',xname_prod,'count',xcount_prod,'price',xprice_prod,'item_type',xprodtype,'agent_info',xagent_data);  
		  ELSE
				xgoods := xgoods_array::jsonb -> 0;
				xgoods := xgoods::jsonb - 'sum' - 'name' - 'count' - 'price' - 'agent_info' - 'item_type';
				xgoods := xgoods::jsonb || 
				jsonb_build_object('sum',xamount_prod,'name',xname_prod,'count',xcount_prod,'price',xprice_prod,'item_type',xprodtype);
			END IF;
			xresult_goods := xresult_goods::jsonb || xgoods::jsonb;
		END LOOP; 
		xcomiss_amount := ((xamount - (xamount / (1 + xcomiss_amount)))::numeric(10,2))::float;
		xgoods_array := (xgoods_array::jsonb -> 0) - 'agent_info' - 'sum' - 'name' - 'count' - 'price' - 'item_type';
		xgoods_array := xgoods_array::jsonb || jsonb_build_object('sum',xcomiss_amount,'name',xcomission,'count',1,'price',xcomiss_amount,'item_type',4);
		xresult_goods := xresult_goods::jsonb || xgoods_array::jsonb;
		xcommand := ((xquery_check -> 'command')::jsonb - 'goods' - 'c_num' - 'payed_cashless') || 
		jsonb_build_object('goods',xresult_goods::jsonb,'c_num',xidpayment,'payed_cashless',xamount);
		IF xemail IS NOT NULL THEN
			xcommand := xcommand::jsonb - 'smsEmail54FZ' || jsonb_build_object('smsEmail54FZ',xemail); 
		END IF;
		xquery_check := xquery_check::jsonb - 'command' || jsonb_build_object('nonce',xnonce,'token',xtoken,'command',xcommand::jsonb);
		xanswer := ekassa.f_sort_json(xquery_check,xsecret);
		xparam := SPLIT_PART(xanswer, '~&~', 1);
		xhash := SPLIT_PART(xanswer, '~&~', 2);
		xquery_kassa := json_build_object('check_url',xcheck_url,'hash',xhash);
		xquery_kassa := json_build_array(xquery_kassa,xparam);
		BEGIN	
			INSERT INTO ekassa.ekassa_check (query_check,year,data_check,qtranz_payment) VALUES (xquery_kassa,xyear,xdata_check,xidpayment) RETURNING id_ekassa INTO xid_ekassa; 
			EXCEPTION WHEN unique_violation THEN
				xquery_kassa := jsonb_build_object('err',1,'ans',xerr);
			RETURN xcomiss_amount;
		END;
		UPDATE reports.payment SET ekassa_id = 1 WHERE qtranz = xidpayment; 
	RETURN xquery_kassa;
END
$function$
;

-- DROP FUNCTION ekassa.f_check_businessru_test(int4);

CREATE OR REPLACE FUNCTION ekassa.f_check_businessru_test(xid integer)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
	DECLARE xquery_check JSON;
	--DECLARE xquery_kassa JSON;
    DECLARE xquery_kassa VARCHAR;
	DECLARE xdata_check JSON;
	DECLARE xcommand JSON;
	DECLARE xproducts JSON;
	DECLARE xgoods JSON;
	DECLARE xgoods_array JSON;
	DECLARE xagent_data JSON;
	DECLARE xresult_goods JSON DEFAULT '[]';
	DECLARE xsecret VARCHAR;
	DECLARE xidorder VARCHAR;
	DECLARE xcheck_url VARCHAR;
	DECLARE xanswer VARCHAR;
	DECLARE xhash VARCHAR;
	DECLARE xnonce VARCHAR;
	DECLARE xprincipal VARCHAR;
	DECLARE xphone_customer VARCHAR;
	DECLARE xphone VARCHAR;
	DECLARE xid_phone_agent VARCHAR;
	DECLARE xprodtype VARCHAR;
	DECLARE xinn VARCHAR;
	DECLARE xemail VARCHAR;
	DECLARE xname VARCHAR;
	DECLARE xname_prod VARCHAR;
	DECLARE xtoken VARCHAR;
	DECLARE xparam VARCHAR;
	DECLARE xcomission VARCHAR;
	DECLARE xerr VARCHAR DEFAULT 'dublicate qtranz';
	DECLARE xratio NUMERIC (3,2);
	DECLARE xmerch INTEGER;
	DECLARE xsupplier INTEGER;
	DECLARE xlength_array INTEGER;
	DECLARE xidpayment INTEGER;
	DECLARE xcontragent INTEGER;
	DECLARE xekassa INTEGER;
	DECLARE xid_ekassa INTEGER;
	DECLARE xcount_prod INTEGER;
	DECLARE xcount_agent INTEGER;
	DECLARE xyear INTEGER;
	DECLARE i INTEGER;
	DECLARE xamount float;
	DECLARE xcomiss_amount float;
	DECLARE xprice_prod float;
	DECLARE xamount_prod float;
	DECLARE xagent BOOLEAN;
	BEGIN
		SELECT MD5(RANDOM()::text) INTO xnonce;
		xidpayment = xid;
		xyear := (LEFT(common.f_timestamp(),4))::integer;
		SELECT LEFT(data_json ->> 'principal',6),
					 data_json ->> 'phone_customer',
					 data_json ->> 'email_customer',
					 (data_json ->> 'amount')::float,
					 data_json -> 'products',
					 data_json ->> 'id_order',
					 e_kassa #>> '{ecassa,0}'
		INTO xprincipal,xphone_customer,xemail,xamount,xproducts,xidorder,xekassa 
		FROM reports.payment WHERE qtranz = xidpayment;
		xlength_array := jsonb_array_length(xproducts::jsonb);
		xdata_check := jsonb_build_object('ecassa',xekassa,'id_order',xidorder);
		SELECT json_settings ->> 'sec',json_settings ->> 'token',json_settings ->> 'PutCheckUrl',json_settings -> 'PutCheck',json_settings -> 'PutCheck' -> 'command' -> 'goods' 
		INTO xsecret,xtoken,xcheck_url,xquery_check,xgoods_array FROM ekassa.ekassa WHERE id_kass = xekassa;
		--SELECT contragent,ekassa ->> 'agent',ekassa ->> 'item_type',ekassa -> 'comiss_agent' ->> 'comission',merchant 
		--INTO xcontragent,xagent,xprodtype,xcomission,xmerch FROM mytosb.contracts WHERE firmservice = xprincipal;
		--SELECT fljson_firm ->> 'upcomission' INTO xcomiss_amount FROM common.firmservice WHERE idfirm = xprincipal;
		--SELECT (accesuaries ->> 'format_amount')::numeric(3,2) INTO xratio FROM common.merchant WHERE idmerch = xmerch;
		--xamount := (xamount::numeric(10,2) * xratio)::NUMERIC(10,2);
		--FOR i IN 1..xlength_array LOOP
			--xcount_prod := xproducts::jsonb -> i-1 ->> 'count';
			--xprice_prod := xproducts::jsonb -> i-1 ->> 'price';
			--xprice_prod := (xprice_prod * xratio::numeric(3,2))::float;
			--xname_prod := xproducts::jsonb -> i-1 ->> 'name_prod';
			--xamount_prod := xproducts::jsonb -> i-1 ->> 'amount_prod';
			--xamount_prod := (xamount_prod::numeric(10,2) * xratio::numeric(3,2))::float;
			--IF xagent = TRUE THEN
				--xid_phone_agent := xproducts::jsonb -> i-1 ->> 'supplier_phone';
				--SELECT COUNT(contragent) INTO xcount_agent FROM mytosb.contracts WHERE login_phone = xid_phone_agent and merchant = xmerch;
				--IF xcount_agent = 0 THEN 
					--SELECT contragent INTO xsupplier FROM mytosb.contracts WHERE firmservice = xprincipal;
				--ELSE
					--SELECT contragent INTO xsupplier FROM mytosb.contracts WHERE login_phone = xid_phone_agent;
				--END IF;
				--SELECT fljson_privilege ->> 'inn',
						   --fljson_privilege ->> 'phone',
					     --fljson_privilege ->> 'name'
		    --INTO xinn,xphone,xname FROM "user".users WHERE idpriv = xsupplier;
				--xagent_data := jsonb_build_object('type',32,'supplier_inn',xinn,'supplier_name',xname,'supplier_phone',xphone);
				--xgoods := xgoods_array::jsonb -> 0; 
			  --xgoods := xgoods::jsonb - 'sum' - 'name' - 'count' - 'price' - 'agent_info' - 'item_type';
				--xgoods := xgoods::jsonb || 
				--jsonb_build_object('sum',xamount_prod,'name',xname_prod,'count',xcount_prod,'price',xprice_prod,'item_type',xprodtype,'agent_info',xagent_data);  
		  --ELSE
				--xgoods := xgoods_array::jsonb -> 0;
				--xgoods := xgoods::jsonb - 'sum' - 'name' - 'count' - 'price' - 'agent_info' - 'item_type';
				--xgoods := xgoods::jsonb || 
				--jsonb_build_object('sum',xamount_prod,'name',xname_prod,'count',xcount_prod,'price',xprice_prod,'item_type',xprodtype);
			--END IF;
			--xresult_goods := xresult_goods::jsonb || xgoods::jsonb;
		--END LOOP; 
		--xcomiss_amount := ((xamount - (xamount / (1 + xcomiss_amount)))::numeric(10,2))::float;
		--xgoods_array := (xgoods_array::jsonb -> 0) - 'agent_info' - 'sum' - 'name' - 'count' - 'price' - 'item_type';
		--xgoods_array := xgoods_array::jsonb || jsonb_build_object('sum',xcomiss_amount,'name',xcomission,'count',1,'price',xcomiss_amount,'item_type',4);
		--xresult_goods := xresult_goods::jsonb || xgoods_array::jsonb;
		--xcommand := ((xquery_check -> 'command')::jsonb - 'goods' - 'c_num' - 'payed_cashless') || 
		--jsonb_build_object('goods',xresult_goods::jsonb,'c_num',xidpayment,'payed_cashless',xamount);
		--IF xemail IS NOT NULL THEN
			--xcommand := xcommand::jsonb - 'smsEmail54FZ' || jsonb_build_object('smsEmail54FZ',xemail); 
		--END IF;
		--xquery_check := xquery_check::jsonb - 'command' || jsonb_build_object('nonce',xnonce,'token',xtoken,'command',xcommand::jsonb);
		--xanswer := ekassa.f_sort_json(xquery_check,xsecret);
		--xparam := SPLIT_PART(xanswer, '~&~', 1);
		--xhash := SPLIT_PART(xanswer, '~&~', 2);
		--xquery_kassa := json_build_object('check_url',xcheck_url,'hash',xhash);
	    --xquery_kassa := ekassa.f_pt_json(xquery_kassa,xparam);
        --xquery_kassa := xquery_kassa::jsonb || xparam::jsonb;
	    --xquery_kassa := jsonb_build_object('xcassa',json_build_object('check_url',xcheck_url,'hash',xhash), 'xparam', xparam::jsonb);
	    --xquery_kassa := json_build_array(xquery_kassa,xparam);
		--BEGIN	
		--	INSERT INTO ekassa.ekassa_check (query_check,year,data_check,qtranz_payment) VALUES (xquery_kassa,xyear,xdata_check,xidpayment) RETURNING id_ekassa INTO xid_ekassa; 
		--	EXCEPTION WHEN unique_violation THEN
		--		xquery_kassa := jsonb_build_object('err',1,'ans',xerr);
		--	RETURN xcomiss_amount;
		--END;
		--UPDATE reports.payment SET ekassa_id = 1 WHERE qtranz = xidpayment; 
	RETURN xgoods_array;
	--return xanswer;
END
$function$
;

-- DROP FUNCTION ekassa.f_ekassa_business_cron();

CREATE OR REPLACE FUNCTION ekassa.f_ekassa_business_cron()
 RETURNS SETOF integer
 LANGUAGE plpgsql
 ROWS 100
AS $function$
	BEGIN
	 RETURN QUERY SELECT qtranz FROM reports.payment WHERE ekassa_id = 0 AND (now() - interval '60 SECOND') >= "datetime";
	RETURN;
	END
$function$
;

-- DROP FUNCTION ekassa.f_ekassa_businessru_answer(json, int8);

CREATE OR REPLACE FUNCTION ekassa.f_ekassa_businessru_answer(xjson json, xid bigint)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
	DECLARE xqtranz INTEGER;
	BEGIN
  UPDATE ekassa.ekassa_check SET ans_ekassa = xjson::jsonb WHERE qtranz_payment = xid;
END
$function$
;

-- DROP FUNCTION ekassa.f_ekassa_businessru_count_err();

CREATE OR REPLACE FUNCTION ekassa.f_ekassa_businessru_count_err()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
	DECLARE xcount INTEGER;
	BEGIN
  SELECT COUNT(ekassa_id) INTO xcount FROM reports.payment WHERE ekassa_id = 0 AND (now() - interval '60 SECOND') >= "datetime";
	RETURN xcount;
END
$function$
;

-- DROP FUNCTION ekassa.f_ekassa_businessru_getcheck(out json);

CREATE OR REPLACE FUNCTION ekassa.f_ekassa_businessru_getcheck(OUT xdata json)
 RETURNS SETOF json
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY SELECT json_build_object('qtranz',doc_ekassa_businessru.id,'json_data',doc_ekassa_businessru.json_data)
     FROM doc_ekassa_businessru  WHERE doc_ekassa_businessru.status::text = 'new'::text;
    RETURN;
 END;
$function$
;

-- DROP FUNCTION ekassa.f_ekassa_businessru_jdata(json, int4, json);

CREATE OR REPLACE FUNCTION ekassa.f_ekassa_businessru_jdata(xjson json, xxid integer, xtoken json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
		DECLARE xappid VARCHAR;
		DECLARE xsec VARCHAR;
		DECLARE xemail VARCHAR DEFAULT '';
		DECLARE xphone VARCHAR DEFAULT '';
    DECLARE xekass INTEGER DEFAULT 2;
		DECLARE xamount VARCHAR;
		DECLARE x_token VARCHAR;
		DECLARE xnonce VARCHAR;
		DECLARE xorder VARCHAR;
    DECLARE xprice VARCHAR;
		DECLARE xcheck JSON;
		DECLARE xsecret JSON;
BEGIN
		SELECT json_settings ->> 'PutCheck',json_settings ->> 'appid',json_settings ->> 'sec'
		INTO xcheck,xappid,xsec FROM ekassa.ekassa WHERE id_kass = xekass;
    xemail := xjson::jsonb ->> 'email';
    xphone := xjson::jsonb ->> 'phone';
    xamount := xjson::jsonb ->> 'amount';
    x_token := xtoken::jsonb ->> 'token';
		xnonce := md5(random()::text);
    xorder := xxid;
    --xcheck := REPLACE(xcheck::json, '@mail', xemail);
    --xcheck := REPLACE(xcheck , '@appid', xappid);
		xcheck := jsonb_set(xcheck::jsonb,'{app_id}',xappid::jsonb,FALSE);
		--xcheck := jsonb_set(xcheck::jsonb,'{command,smsEmail54FZ}',xemail::jsonb,FALSE);
    xcheck := jsonb_set(xcheck::jsonb,'{command,c_num}',xorder::jsonb,FALSE);
    xcheck := jsonb_set(xcheck::jsonb,'{command,goods,0,sum}',xamount::jsonb,FALSE);
    xcheck := jsonb_set(xcheck::jsonb,'{command,goods,0,price}',xamount::jsonb,FALSE);
    xcheck := jsonb_set(xcheck::jsonb,'{command,payed_cashless}',xamount::jsonb,FALSE);
    xsecret := json_build_object('token', x_token, 'nonce', xnonce, 'xsec', xsec);
    --xcheck := xcheck::jsonb || x_token::jsonb;
    RETURN xcheck;
END;
$function$
;

-- DROP FUNCTION ekassa.f_ekassa_businessru_put_token(json);

CREATE OR REPLACE FUNCTION ekassa.f_ekassa_businessru_put_token(x_json json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE xekassa  INTEGER DEFAULT 2;
	DECLARE yjson JSON;
	DECLARE zjson JSON;
	DECLARE xtoken VARCHAR;
BEGIN
		xtoken := x_json::jsonb ->> 'token';
		SELECT json_settings - 'token' INTO zjson FROM ekassa.ekassa WHERE id_kass  = xekassa;
		yjson := jsonb_build_object('token',xtoken) || zjson::jsonb;
    UPDATE ekassa.ekassa SET json_settings = yjson WHERE id_kass  = xekassa;
		RETURN yjson;
END;
$function$
;

-- DROP FUNCTION ekassa.f_ekassa_businessru_sign_token();

CREATE OR REPLACE FUNCTION ekassa.f_ekassa_businessru_sign_token()
 RETURNS json
 LANGUAGE plpgsql
AS $function$
    DECLARE xekass INTEGER DEFAULT 2;
    DECLARE xnonce VARCHAR;
    DECLARE xappid VARCHAR;
    DECLARE xsec VARCHAR;
    DECLARE xmass VARCHAR;
    DECLARE xanswer JSON;
    DECLARE xmd5 VARCHAR;
    DECLARE xurl VARCHAR;
    DECLARE xputurl VARCHAR; 
BEGIN
		xnonce := MD5(random()::text);
    SELECT json_settings ->> 'appid',json_settings ->> 'sec',json_settings ->> 'GetTokenUrl',json_settings ->> 'PutCheckUrl' 
		INTO xappid,xsec,xurl,xputurl FROM ekassa.ekassa WHERE id_kass = xekass;
		xmass := json_build_object('app_id', xappid, 'nonce', xnonce);
		xmd5 := MD5(REPLACE(json_build_object('app_id', xappid, 'nonce', xnonce)::text,' ','') || xsec);
		xanswer := json_build_object('params',xmass::json,'headers',json_build_object('Accept','application/json','sign',xmd5),'url',xurl,'chekurl',xputurl);
	  --Записать в таблицу buisinessru_timestamp
		RETURN xanswer;
END;
$function$
;

-- DROP FUNCTION ekassa.f_pt_json(bpchar, bpchar);

CREATE OR REPLACE FUNCTION ekassa.f_pt_json(xjson character, xparam character)
 RETURNS character varying
 LANGUAGE plpython3u
AS $function$
		import json
		
		x_json = json.loads(xjson)
		x_json = dict(sorted(x_json.items()))
		x_json = str(xjson)
		x_json = x_json + "~&~" + xparam
		return x_json
  $function$
;

-- DROP FUNCTION ekassa.f_sort_json(json, bpchar);

CREATE OR REPLACE FUNCTION ekassa.f_sort_json(xjson json, xsecret character)
 RETURNS character varying
 LANGUAGE plpython3u
AS $function$
		import json
		import hashlib
		#import urllib.parse
		
		x_json = json.loads(xjson)
		x_json = dict(sorted(x_json.items()))
		x_json = str(x_json)
		x_json = x_json.replace('\'','\"')
		x_json = x_json.replace(': ',':')
		x_json = x_json.replace(', ',',')
		x_json = x_json.replace('True','true')
		#x_json = x_json.replace('://',':\/\/')
		y_json = x_json + xsecret
		sign_query = hashlib.md5(y_json.encode())
		sign_query = sign_query.hexdigest()
		#sign_query = urllib.parse.urlencode(y_json)
		x_json = x_json + "~&~" + sign_query
		return x_json
  $function$
;

-- DROP FUNCTION ekassa.f_sort_json_copy(json, bpchar);

CREATE OR REPLACE FUNCTION ekassa.f_sort_json_copy(xjson json, xsecret character)
 RETURNS character varying
 LANGUAGE plpython3u
AS $function$
		import json
		import hashlib
		#import urllib.parse
		
		x_json = json.loads(xjson)
		x_json = dict(sorted(x_json.items()))
		x_json = str(x_json)
		x_json = x_json.replace('\'','\"')
		x_json = x_json.replace(': ',':')
		x_json = x_json.replace(', ',',')
		x_json = x_json.replace('True','true')
		x_json = x_json.replace('://',':\/\/')
		y_json = x_json + xsecret
		sign_query = hashlib.md5(y_json.encode())
		sign_query = sign_query.hexdigest()
		#sign_query = urllib.parse.urlencode(y_json)
		x_json = x_json + "~&~" + sign_query
		return x_json
  $function$
;

-- DROP FUNCTION ekassa.f_test(int4);

CREATE OR REPLACE FUNCTION ekassa.f_test(xid integer)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
	DECLARE xquery_check JSON;
	DECLARE xquery_kassa JSON;
	DECLARE xdata_check JSON;
	DECLARE xcommand JSON;
	DECLARE xproducts JSON;
	DECLARE xgoods JSON;
	DECLARE xgoods_array JSON;
	DECLARE xagent_data JSON;
	DECLARE xresult_goods JSON DEFAULT '[]';
	DECLARE xsecret VARCHAR;
	DECLARE xidorder VARCHAR;
	DECLARE xcheck_url VARCHAR;
	DECLARE xanswer VARCHAR;
	DECLARE xhash VARCHAR;
	DECLARE xnonce VARCHAR;
	DECLARE xprincipal VARCHAR;
	DECLARE xphone_customer VARCHAR;
	DECLARE xphone VARCHAR;
	DECLARE xid_phone_agent VARCHAR;
	DECLARE xprodtype VARCHAR;
	DECLARE xinn VARCHAR;
	DECLARE xemail VARCHAR;
	DECLARE xname VARCHAR;
	DECLARE xname_prod VARCHAR;
	DECLARE xtoken VARCHAR;
	DECLARE xparam VARCHAR;
	DECLARE xcomission VARCHAR;
	DECLARE xerr VARCHAR DEFAULT 'dublicate qtranz';
	DECLARE xratio NUMERIC (3,2);
	DECLARE xmerch INTEGER;
	DECLARE xsupplier INTEGER;
	DECLARE xlength_array INTEGER;
	DECLARE xidpayment INTEGER;
	DECLARE xcontragent INTEGER;
	DECLARE xekassa INTEGER;
	DECLARE xid_ekassa INTEGER;
	DECLARE xcount_prod INTEGER;
	DECLARE xcount_agent INTEGER;
	DECLARE xyear INTEGER;
	DECLARE i INTEGER;
	DECLARE xamount float;
	DECLARE xcomiss_amount float;
	DECLARE xprice_prod float;
	DECLARE xamount_prod float;
	DECLARE xagent BOOLEAN;
	BEGIN
		SELECT MD5(RANDOM()::text) INTO xnonce;
		xidpayment = xid;
		xyear := (LEFT(common.f_timestamp(),4))::integer;
		SELECT LEFT(data_json ->> 'principal',6),
					 data_json ->> 'phone_customer',
					 data_json ->> 'email_customer',
					 (data_json ->> 'amount')::float,
					 data_json -> 'products',
					 data_json ->> 'id_order',
					 e_kassa #>> '{ecassa,0}'
		INTO xprincipal,xphone_customer,xemail,xamount,xproducts,xidorder,xekassa 
		FROM reports.payment WHERE qtranz = xidpayment;
		xlength_array := jsonb_array_length(xproducts::jsonb);
		xdata_check := jsonb_build_object('ecassa',xekassa,'id_order',xidorder);
		SELECT json_settings ->> 'sec',json_settings ->> 'token',json_settings ->> 'PutCheckUrl',json_settings -> 'PutCheck',
		json_settings -> 'PutCheck' -> 'command' -> 'goods' 
		INTO xsecret,xtoken,xcheck_url,xquery_check,xgoods_array FROM ekassa.ekassa WHERE id_kass = xekassa;
		SELECT contragent,ekassa ->> 'agent',ekassa ->> 'item_type',ekassa -> 'comiss_agent' ->> 'comission',merchant 
		INTO xcontragent,xagent,xprodtype,xcomission,xmerch FROM mytosb.contracts WHERE firmservice = xprincipal;
		SELECT fljson_firm ->> 'upcomission' INTO xcomiss_amount FROM common.firmservice WHERE idfirm = xprincipal;
		SELECT (accesuaries ->> 'format_amount')::numeric(3,2) INTO xratio FROM common.merchant WHERE idmerch = xmerch;
		xamount := (xamount::numeric(10,2) * xratio)::NUMERIC(10,2);
		FOR i IN 1..xlength_array LOOP
			xcount_prod := xproducts::jsonb -> i-1 ->> 'count';
			xprice_prod := xproducts::jsonb -> i-1 ->> 'price';
			xprice_prod := (xprice_prod * xratio::numeric(3,2))::float;
			xname_prod := xproducts::jsonb -> i-1 ->> 'name_prod';
			xamount_prod := xproducts::jsonb -> i-1 ->> 'amount_prod';
			xamount_prod := (xamount_prod::numeric(10,2) * xratio::numeric(3,2))::float;
			IF xagent = TRUE THEN
				xid_phone_agent := xproducts::jsonb -> i-1 ->> 'supplier_phone';
				SELECT COUNT(contragent) INTO xcount_agent FROM mytosb.contracts WHERE login_phone = xid_phone_agent and merchant = xmerch;
				IF xcount_agent = 0 THEN 
					SELECT contragent INTO xsupplier FROM mytosb.contracts WHERE firmservice = xprincipal;
				ELSE
					SELECT contragent INTO xsupplier FROM mytosb.contracts WHERE login_phone = xid_phone_agent;
				END IF;
				
				SELECT fljson_privilege ->> 'inn',
						   fljson_privilege ->> 'phone',
					     fljson_privilege ->> 'name'
		    INTO xinn,xphone,xname FROM "user".users WHERE idpriv = xsupplier;
				
				xagent_data := jsonb_build_object('type',32,'supplier_inn',xinn,'supplier_name',xname,'supplier_phone',xphone);
				xgoods := xgoods_array::jsonb -> 0; 
			  xgoods := xgoods::jsonb - 'sum' - 'name' - 'count' - 'price' - 'agent_info' - 'item_type';
				xgoods := xgoods::jsonb || 
				jsonb_build_object('sum',xamount_prod,'name',xname_prod,'count',xcount_prod,'price',xprice_prod,'item_type',xprodtype,'agent_info',xagent_data);  
		  ELSE
				xgoods := xgoods_array::jsonb -> 0;
				xgoods := xgoods::jsonb - 'sum' - 'name' - 'count' - 'price' - 'agent_info' - 'item_type';
				xgoods := xgoods::jsonb || 
				jsonb_build_object('sum',xamount_prod,'name',xname_prod,'count',xcount_prod,'price',xprice_prod,'item_type',xprodtype);
			END IF;
			xresult_goods := xresult_goods::jsonb || xgoods::jsonb;
		END LOOP; 
		xcomiss_amount := ((xamount - (xamount / (1 + xcomiss_amount)))::numeric(10,2))::float;
		xgoods_array := (xgoods_array::jsonb -> 0) - 'agent_info' - 'sum' - 'name' - 'count' - 'price' - 'item_type';
		xgoods_array := xgoods_array::jsonb || jsonb_build_object('sum',xcomiss_amount,'name',xcomission,'count',1,'price',xcomiss_amount,'item_type',4);
		xresult_goods := xresult_goods::jsonb || xgoods_array::jsonb;
		xcommand := ((xquery_check -> 'command')::jsonb - 'goods' - 'c_num' - 'payed_cashless') || 
		jsonb_build_object('goods',xresult_goods::jsonb,'c_num',xidpayment,'payed_cashless',xamount);
		IF xemail IS NOT NULL THEN
			xcommand := xcommand::jsonb - 'smsEmail54FZ' || jsonb_build_object('smsEmail54FZ',xemail); 
		END IF;
		xquery_check := xquery_check::jsonb - 'command' || jsonb_build_object('nonce',xnonce,'token',xtoken,'command',xcommand::jsonb);
		xanswer := ekassa.f_sort_json(xquery_check,xsecret);
		xparam := SPLIT_PART(xanswer, '~&~', 1);
		xhash := SPLIT_PART(xanswer, '~&~', 2);
		xquery_kassa := json_build_object('check_url',xcheck_url,'hash',xhash);
		xquery_kassa := json_build_array(xquery_kassa,xparam);
		BEGIN	
			INSERT INTO ekassa.ekassa_check (query_check,year,data_check,qtranz_payment) VALUES (xquery_kassa,xyear,xdata_check,xidpayment) RETURNING id_ekassa INTO xid_ekassa; 
			EXCEPTION WHEN unique_violation THEN
				xquery_kassa := jsonb_build_object('err',1,'ans',xerr);
			RETURN xresult_goods;
		END;
		UPDATE reports.payment SET ekassa_id = 1 WHERE qtranz = xidpayment; 
	RETURN xquery_kassa;
	END;
$function$
;