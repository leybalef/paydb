-- DROP SCHEMA ataxi_transfer;

CREATE SCHEMA ataxi_transfer AUTHORIZATION postgres;

-- DROP SEQUENCE ataxi_transfer.calc_counter_seq;

CREATE SEQUENCE ataxi_transfer.calc_counter_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE ataxi_transfer.merch_sch_idmerch_seq;

CREATE SEQUENCE ataxi_transfer.merch_sch_idmerch_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32000
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE ataxi_transfer.order_id_paybank_seq;

CREATE SEQUENCE ataxi_transfer.order_id_paybank_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE ataxi_transfer.order_idorder_seq;

CREATE SEQUENCE ataxi_transfer.order_idorder_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32000
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE ataxi_transfer.price_idprice_seq;

CREATE SEQUENCE ataxi_transfer.price_idprice_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32000
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE ataxi_transfer.region_idregion_seq;

CREATE SEQUENCE ataxi_transfer.region_idregion_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32000
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE ataxi_transfer.tarif_idtarif_seq;

CREATE SEQUENCE ataxi_transfer.tarif_idtarif_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32000
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE ataxi_transfer.town_idtown_seq;

CREATE SEQUENCE ataxi_transfer.town_idtown_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32000
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE ataxi_transfer.view_idview_seq;

CREATE SEQUENCE ataxi_transfer.view_idview_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32000
	START 1
	CACHE 1
	NO CYCLE;-- ataxi_transfer."!location" определение

-- Drop table

-- DROP TABLE ataxi_transfer."!location";

CREATE TABLE ataxi_transfer."!location" (
	id int4 NOT NULL,
	region varchar(50) NULL,
	town _text NULL,
	"location" json NULL
);


-- ataxi_transfer.calc_sec определение

-- Drop table

-- DROP TABLE ataxi_transfer.calc_sec;

CREATE TABLE ataxi_transfer.calc_sec (
	id_calc varchar NOT NULL,
	"year" int2 NOT NULL,
	data_calc jsonb NULL,
	id_order int4 NULL,
	counter int4 DEFAULT nextval('ataxi_transfer.calc_counter_seq'::regclass) NOT NULL
)
PARTITION BY RANGE (year);


-- ataxi_transfer.merch_scheme определение

-- Drop table

-- DROP TABLE ataxi_transfer.merch_scheme;

CREATE TABLE ataxi_transfer.merch_scheme (
	idmerch int2 DEFAULT nextval('ataxi_transfer.merch_sch_idmerch_seq'::regclass) NOT NULL,
	accesuaries jsonb NULL,
	login varchar(50) NOT NULL,
	notification jsonb NULL,
	CONSTRAINT merch_scheme_pkey PRIMARY KEY (idmerch)
);


-- ataxi_transfer."order" определение

-- Drop table

-- DROP TABLE ataxi_transfer."order";

CREATE TABLE ataxi_transfer."order" (
	id_order int8 DEFAULT nextval('ataxi_transfer.order_idorder_seq'::regclass) NOT NULL,
	param jsonb NULL,
	id_calc varchar(50) NOT NULL,
	"enable" bool DEFAULT false NOT NULL,
	id_paybank int4 NULL,
	CONSTRAINT idcalc UNIQUE (id_calc),
	CONSTRAINT order_pkey PRIMARY KEY (id_order)
);


-- ataxi_transfer.price определение

-- Drop table

-- DROP TABLE ataxi_transfer.price;

CREATE TABLE ataxi_transfer.price (
	id_price int2 DEFAULT nextval('ataxi_transfer.price_idprice_seq'::regclass) NOT NULL,
	town int2 NOT NULL,
	view_trans int2 NOT NULL,
	tarif int2 NOT NULL,
	amount numeric(10, 2) NULL
);


-- ataxi_transfer.region определение

-- Drop table

-- DROP TABLE ataxi_transfer.region;

CREATE TABLE ataxi_transfer.region (
	id_region int2 DEFAULT nextval('ataxi_transfer.region_idregion_seq'::regclass) NOT NULL,
	name_region varchar(50) NULL,
	alias varchar(10) NULL
);


-- ataxi_transfer.tarif определение

-- Drop table

-- DROP TABLE ataxi_transfer.tarif;

CREATE TABLE ataxi_transfer.tarif (
	" id_tarif" int2 DEFAULT nextval('ataxi_transfer.tarif_idtarif_seq'::regclass) NOT NULL,
	name_tarif varchar(50) NULL,
	view_trans int2 NULL
);


-- ataxi_transfer.town определение

-- Drop table

-- DROP TABLE ataxi_transfer.town;

CREATE TABLE ataxi_transfer.town (
	id_town int2 DEFAULT nextval('ataxi_transfer.town_idtown_seq'::regclass) NOT NULL,
	name_town varchar(150) NULL,
	region int2 NULL,
	short_name varchar(10) NULL,
	fld_sort int4 NULL
);

-- Table Triggers

create trigger insert_town_trigger after
insert
    on
    ataxi_transfer.town for each row execute function ataxi_transfer.insert_town_trigger();
create trigger update_town_trigger after
update
    on
    ataxi_transfer.town for each row execute function ataxi_transfer.update_town_trigger();


-- ataxi_transfer.view_transfer определение

-- Drop table

-- DROP TABLE ataxi_transfer.view_transfer;

CREATE TABLE ataxi_transfer.view_transfer (
	id_view int2 DEFAULT nextval('ataxi_transfer.view_idview_seq'::regclass) NOT NULL,
	view_name varchar(25) NULL
);


-- ataxi_transfer.x_param определение

-- Drop table

-- DROP TABLE ataxi_transfer.x_param;

CREATE TABLE ataxi_transfer.x_param (
	jsonb_build_object jsonb NULL
);


-- ataxi_transfer.calc_2023 определение

CREATE TABLE ataxi_transfer.calc_2023 PARTITION OF ataxi_transfer.calc_sec (
	CONSTRAINT calc_2023_pkey PRIMARY KEY (id_calc)
) FOR VALUES FROM ('2023') TO ('2024');


-- ataxi_transfer.calc_2024 определение

CREATE TABLE ataxi_transfer.calc_2024 PARTITION OF ataxi_transfer.calc_sec (
	CONSTRAINT calc_2024_pkey PRIMARY KEY (id_calc)
) FOR VALUES FROM ('2024') TO ('2025');


-- ataxi_transfer.calc_2025 определение

CREATE TABLE ataxi_transfer.calc_2025 PARTITION OF ataxi_transfer.calc_sec (
	CONSTRAINT calc_2025_pkey PRIMARY KEY (id_calc)
) FOR VALUES FROM ('2025') TO ('2026');


-- ataxi_transfer.calc_2026 определение

CREATE TABLE ataxi_transfer.calc_2026 PARTITION OF ataxi_transfer.calc_sec (
	CONSTRAINT calc_2026_pkey PRIMARY KEY (id_calc)
) FOR VALUES FROM ('2026') TO ('2027');


-- ataxi_transfer.calc_2027 определение

CREATE TABLE ataxi_transfer.calc_2027 PARTITION OF ataxi_transfer.calc_sec (
	CONSTRAINT calc_2027_pkey PRIMARY KEY (id_calc)
) FOR VALUES FROM ('2027') TO ('2028');


-- ataxi_transfer.calc_2028 определение

CREATE TABLE ataxi_transfer.calc_2028 PARTITION OF ataxi_transfer.calc_sec (
	CONSTRAINT calc_2028_pkey PRIMARY KEY (id_calc)
) FOR VALUES FROM ('2028') TO ('2029');


-- ataxi_transfer.mv_tariffs исходный текст

CREATE MATERIALIZED VIEW ataxi_transfer.mv_tariffs
TABLESPACE pg_default
AS SELECT price.id_price,
    price.town AS id_town,
    town.name_town AS town,
    town.fld_sort,
    price.view_trans AS id_transfer_type,
    view_transfer.view_name AS transfer_type,
    price.tarif AS id_vehicle_size,
    tarif.name_tarif AS vehicle_size,
    price.amount
   FROM ataxi_transfer.price
     LEFT JOIN ataxi_transfer.town ON price.town = town.id_town
     LEFT JOIN ataxi_transfer.view_transfer ON price.view_trans = view_transfer.id_view
     LEFT JOIN ataxi_transfer.tarif tarif ON price.tarif = tarif." id_tarif"
  ORDER BY price.view_trans, price.tarif, town.fld_sort, town.name_town
WITH DATA;

-- View indexes:
CREATE INDEX tariffs_list_idx_id_price ON ataxi_transfer.mv_tariffs USING btree (id_price);



-- DROP FUNCTION ataxi_transfer."!f_order"(json);

CREATE OR REPLACE FUNCTION ataxi_transfer."!f_order"(x_json json)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
	DECLARE 
		xjs JSON;
		xid_pay JSON; 
		xjson JSON;
		xans JSON;
		xid_calc VARCHAR;
		xlogin VARCHAR;
		xdatetime VARCHAR;
		xamount VARCHAR;
		xid INTEGER;
		xid_paybank INTEGER;
	-- IN:
	--	{
	--        "login": "web_ataxi",
	--				"id_calc": "hgfhdhfh",
	--        "amount": 240000,
	--        "view_transfer": 2,
	--        "count_places": 4,
	--        "quote": {
	--            "adult": 1,
	--            "younger": 0,
	--            "baby": 0,
	--        },
	--        "name_customer": "",
	--        "email_customer": "",
	--        "phone_customer": "+79186222897",
	--        "transfer": [
	--            {"to": 4, "from": 1, "flight_train": "", "hotel": "", "datetime_transfer": "2023-04-03T14:30"},
	--            {"to": 2, "from": 6, "flight_train": "", "hotel": "", "datetime_transfer": "2023-04-03T14:30"}
	--        ],
	--        "timestamp": "2023-04-03T14:30"
	--    }
	BEGIN
		xid_calc := x_json::jsonb ->> 'id_calc';
		xdatetime := x_json::jsonb ->> 'timestamp';
		x_json := x_json::jsonb - 'id_calc' - 'timestamp';
		xlogin := x_json::jsonb ->> 'login';
		xamount := x_json::jsonb ->> 'amount';
		BEGIN
			INSERT INTO ataxi_transfer."order"(param,id_calc)
			VALUES (x_json,xid_calc) RETURNING id_order INTO xid;
			EXCEPTION WHEN unique_violation THEN
				SELECT id_order INTO xid FROM ataxi_transfer."order" WHERE id_calc = xid_calc;
				xid_pay := jsonb_build_object('id_order',xid::text,'login_dev',xlogin);
				SELECT json_answer INTO xjs FROM mytosb.syspay WHERE idpay = xid_pay::jsonb;
				xjs := xjs::jsonb || jsonb_build_object('err',1);
			RETURN xjs;
		END;
			x_json := x_json::jsonb || jsonb_build_object('id_order',xid,'datetime',xdatetime);
		SELECT accesuaries::jsonb || x_json::jsonb INTO xjson 
		FROM ataxi_transfer.merch_scheme WHERE idmerch = 1;
		xamount := (xamount::integer * 100)::text;
		xjson := jsonb_set(xjson::jsonb,'{amount}',xamount::jsonb,FALSE);
		xjson := jsonb_set(xjson::jsonb,'{products,0,amount_prod}',xamount::jsonb,FALSE);
		xjson := jsonb_set(xjson::jsonb,'{products,0,price}',xamount::jsonb,FALSE);
		xans := mytosb.f_syspay(xjson);
		xid_paybank := xans::jsonb ->> 'newid';		
		UPDATE ataxi_transfer."order" SET id_paybank = xid_paybank WHERE id_order = xid;
		RETURN xans;
	END;
$function$
;

-- DROP FUNCTION ataxi_transfer."!f_order2"(json);

CREATE OR REPLACE FUNCTION ataxi_transfer."!f_order2"(x_json json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE 
		xid INTEGER;
		xid_calc VARCHAR;
		xlogin VARCHAR;
		xdatetime VARCHAR;
		xjs JSON;
		xid_pay JSON; 
		xid_paybank INTEGER;
	-- IN:
	--	{
	--        "login": "web_ataxi",
	--				"id_calc": "hgfhdhfh",
	--        "amount": 240000,
	--        "view_transfer": 2,
	--        "count_places": 4,
	--        "quote": {
	--            "adult": 1,
	--            "younger": 0,
	--            "baby": 0,
	--        },
	--        "name_customer": "",
	--        "email_customer": "",
	--        "phone_customer": "+79186222897",
	--        "transfer": [
	--            {"to": 4, "from": 1, "flight_train": "", "hotel": "", "datetime_transfer": "2023-04-03T14:30"},
	--            {"to": 2, "from": 6, "flight_train": "", "hotel": "", "datetime_transfer": "2023-04-03T14:30"}
	--        ],
	--        "timestamp": "2023-04-03T14:30"
	--    }
	BEGIN
		xid_calc := x_json::jsonb ->> 'id_calc';
		xdatetime := x_json::jsonb ->> 'timestamp';
		x_json := x_json::jsonb - 'id_calc' - 'timestamp';
		xlogin := x_json::jsonb ->> 'login';
		BEGIN
			INSERT INTO ataxi_transfer."order"(param,id_calc)
			VALUES (x_json,xid_calc) RETURNING id_order INTO xid;
			EXCEPTION WHEN unique_violation THEN
				SELECT id_order INTO xid FROM ataxi_transfer."order" WHERE id_calc = xid_calc;
				xid_pay := jsonb_build_object('id_order',xid::text,'login_dev',xlogin);
				SELECT json_answer INTO xjs FROM mytosb.syspay WHERE idpay = xid_pay::jsonb;
				xjs := xjs::jsonb || jsonb_build_object('err',1);
			RETURN xjs;
		END;
		x_json := x_json::jsonb || jsonb_build_object('id_order',xid,'datetime',xdatetime);
		xjs := ataxi_transfer.f_syspay(x_json);
		xid_paybank := xjs::jsonb ->> 'newid';		
		UPDATE ataxi_transfer."order" SET id_paybank = xid_paybank where id_order = xid;
    RETURN xjs;
	END;
$function$
;

-- DROP FUNCTION ataxi_transfer."!f_syspay"(json);

CREATE OR REPLACE FUNCTION ataxi_transfer."!f_syspay"(xjson json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE 
		xans JSON;
	  x_json JSON;
	  xamount VARCHAR;
 BEGIN
	xamount := xjson::jsonb ->> 'amount';
	SELECT accesuaries::jsonb || xjson::jsonb INTO x_json 
	FROM ataxi_transfer.merch_scheme WHERE idmerch = 1;
	x_json := jsonb_set(x_json::jsonb,'{products,0,amount_prod}',xamount::jsonb,FALSE);
	x_json := jsonb_set(x_json::jsonb,'{products,0,price}',xamount::jsonb,FALSE);
    xans := mytosb.f_syspay(x_json);
	RETURN xans;
END
$function$
;

-- DROP FUNCTION ataxi_transfer.f_calc(json);

CREATE OR REPLACE FUNCTION ataxi_transfer.f_calc(xcalc json)
 RETURNS smallint
 LANGUAGE plpgsql
AS $function$
	DECLARE
		xans JSON;
		xidcalc VARCHAR;
		xerr VARCHAR DEFAULT 'dublicate id_order';
		xamount INTEGER;
		xtarif INTEGER;
		xview_trans INTEGER;
		xarray_length INTEGER;
		i INTEGER;
		xyear INTEGER;
		xsaldo INTEGER DEFAULT 0;
		x_from INTEGER;
		x_to INTEGER;
	--IN:
	--{
	--"login": "web_ataxi",
	--"id_calc": "fhgfhgf-hfhthg-jhgjhv",
	--"count_places": 3,
	--"transfer": [{"from": 9, "to": 4},{"from": 6, "to": 8}],
	--"view_transfer": 2
	--"timestamp": "2023-00-00T00:00"
	--}
	BEGIN
		xidcalc := xcalc::jsonb ->> 'id_calc';
		xyear := LEFT(xcalc::jsonb ->> 'timestamp',4)::integer;
		xarray_length := jsonb_array_length(xcalc::jsonb -> 'transfer');
		xtarif := (xcalc::jsonb ->> 'count_places')::integer;
		xview_trans := (xcalc::jsonb ->> 'view_transfer')::integer; 
		xcalc := xcalc::jsonb - 'id_calc';
		FOR i IN 1..xarray_length LOOP
			x_from := (xcalc::jsonb -> 'transfer' -> i - 1 ->> 'from')::integer;
			x_to := (xcalc::jsonb -> 'transfer' -> i - 1 ->> 'to')::integer;
			SELECT amount INTO xamount FROM ataxi_transfer.price 
			WHERE tarif = xtarif AND view_trans = xview_trans AND (town = x_from OR town = x_to);
			xsaldo := xsaldo + xamount;
		END LOOP;
		xcalc := xcalc::jsonb || jsonb_build_object('xsaldo',xsaldo);
		BEGIN
			INSERT INTO ataxi_transfer.calc_sec (id_calc,"year",data_calc) 
			VALUES (xidcalc,xyear,xcalc);
			EXCEPTION WHEN unique_violation THEN
			xans := jsonb_build_object('err',1,'ans',xerr);
			RETURN xans;
	END;
	RETURN xsaldo;
	END
	--out:
	--{
	--"login": "web_ataxi",
	--"order_id": "1111111111"
	--"principal": "200121",
	--"amount": 0,
	--"phone_customer": "+79000000000",
	--"email_customer": null,
	--"name_customer": null,
	--"flight_train": null,
	--"arrival_datetime": "2023-00-00T00:00",
	--"hotel ": null,
	--"quote": {"adult": 1, "younger": 0, "baby": 0}
	--}
	$function$
;

-- DROP FUNCTION ataxi_transfer.f_change_point();

CREATE OR REPLACE FUNCTION ataxi_transfer.f_change_point()
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE 
		xitems JSON DEFAULT '{}';
		xjson JSON;
		xid_region INTEGER;
		xkey VARCHAR;
	BEGIN
	FOR xid_region IN 
	SELECT id_region FROM ataxi_transfer.region
	LOOP
		SELECT "alias" INTO xkey FROM ataxi_transfer.region WHERE id_region = xid_region;
		SELECT jsonb_build_object(xkey,array_to_json(array_agg(jsonb_build_object('value',name_town,'text',name_town,'short_name',short_name)))) 
		INTO xjson FROM ataxi_transfer.town	WHERE ataxi_transfer.town.region = xid_region;
		xitems := xitems::jsonb || xjson::jsonb;
  END LOOP;
  RETURN xitems;
  END
  $function$
;

-- DROP FUNCTION ataxi_transfer.f_locat();

CREATE OR REPLACE FUNCTION ataxi_transfer.f_locat()
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE 
	xitems JSON;
	xjson JSON;
	BEGIN
		SELECT jsonb_build_object('adler',array_to_json(array_agg(jsonb_build_object('value',name_town,'text',name_town,'short_name',short_name)))) 
		INTO xitems FROM ataxi_transfer.town	WHERE ataxi_transfer.town.region = 1;
		SELECT jsonb_build_object('abkhazia',array_to_json(array_agg(jsonb_build_object('value',name_town,'text',name_town,'short_name',short_name)))) 
		INTO xjson FROM ataxi_transfer.town WHERE region = 2;
		xitems := xitems::jsonb || xjson::jsonb;
		
		--SELECT ataxi_transfer.town.name_town AS town,ataxi_transfer.town.short_name AS short_name,
		--ataxi_transfer.region.name_region AS region,ataxi_transfer.region."alias" AS "alias"
    --FROM ataxi_transfer.town JOIN ataxi_transfer.region 
		--ON ataxi_transfer.town.region = ataxi_transfer.region.id_region

  RETURN xitems;
  END
  $function$
;

-- DROP FUNCTION ataxi_transfer.f_locat1();

CREATE OR REPLACE FUNCTION ataxi_transfer.f_locat1()
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE 
		xitems JSON DEFAULT '{}';
		xjson JSON;
		xid_region INTEGER;
		xkey VARCHAR;
	BEGIN
	FOR xid_region IN 
	SELECT id_region FROM ataxi_transfer.region
	LOOP
		SELECT "alias" INTO xkey FROM ataxi_transfer.region WHERE id_region = xid_region;
		SELECT jsonb_build_object(xkey,array_to_json(array_agg(jsonb_build_object('value',id_town::text,'text',name_town,'short_name',short_name)))) 
		INTO xjson FROM ataxi_transfer.town	WHERE ataxi_transfer.town.region = xid_region;
		xitems := xitems::jsonb || xjson::jsonb;
  END LOOP;
  RETURN xitems;
  END
  $function$
;

-- DROP FUNCTION ataxi_transfer.f_location();

CREATE OR REPLACE FUNCTION ataxi_transfer.f_location()
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE 
	xitems JSON DEFAULT '{}';
	xjson JSON;
	xid_region INTEGER;
	BEGIN
	FOR xid_region IN 
	SELECT id_region FROM ataxi_transfer.region
	LOOP
		SELECT jsonb_build_object("alias",name_region) INTO xjson 
		FROM ataxi_transfer.region WHERE id_region = xid_region;
		xitems := xitems::jsonb || xjson::jsonb;
	END LOOP;
  RETURN xitems;
  END
  $function$
;

-- DROP FUNCTION ataxi_transfer.f_order(json);

CREATE OR REPLACE FUNCTION ataxi_transfer.f_order(x_json json)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
	DECLARE 
		xjs JSON;
		xid_pay JSON; 
		xjson JSON;
		xans JSON;
		xid_calc VARCHAR;
		xlogin VARCHAR;
		xdatetime VARCHAR;
		xamount VARCHAR;
		xid INTEGER;
		xid_paybank INTEGER;
	-- IN:
	--	{
	--        "login": "web_ataxi",
	--				"id_calc": "hgfhdhfh",
	--        "amount": 240000,
	--        "view_transfer": 2,
	--        "count_places": 4,
	--        "quote": {
	--            "adult": 1,
	--            "younger": 0,
	--            "baby": 0,
	--        },
	--        "name_customer": "",
	--        "email_customer": "",
	--        "phone_customer": "+79186222897",
	--        "transfer": [
	--            {"to": 4, "from": 1, "flight_train": "", "hotel": "", "datetime_transfer": "2023-04-03T14:30"},
	--            {"to": 2, "from": 6, "flight_train": "", "hotel": "", "datetime_transfer": "2023-04-03T14:30"}
	--        ],
	--        "timestamp": "2023-04-03T14:30"
	--    }
	BEGIN
		xid_calc := x_json::jsonb ->> 'id_calc';
		xdatetime := x_json::jsonb ->> 'timestamp';
		x_json := x_json::jsonb - 'id_calc' - 'timestamp';
		xlogin := x_json::jsonb ->> 'login';
		xamount := x_json::jsonb ->> 'amount';
		BEGIN
			INSERT INTO ataxi_transfer."order"(param,id_calc)
			VALUES (x_json,xid_calc) RETURNING id_order INTO xid;
			EXCEPTION WHEN unique_violation THEN
				SELECT id_order INTO xid FROM ataxi_transfer."order" WHERE id_calc = xid_calc;
				xid_pay := jsonb_build_object('id_order',xid::text,'login_dev',xlogin);
				SELECT json_answer INTO xjs FROM mytosb.syspay WHERE idpay = xid_pay::jsonb;
				xjs := xjs::jsonb || jsonb_build_object('err',1);
			RETURN xjs;
		END;
			UPDATE ataxi_transfer.calc_sec SET id_order = xid WHERE id_calc = xid_calc;
			x_json := x_json::jsonb || jsonb_build_object('id_order',xid,'datetime',xdatetime);
		SELECT accesuaries::jsonb || x_json::jsonb INTO xjson 
		FROM ataxi_transfer.merch_scheme WHERE idmerch = 1;
		xamount := (xamount::integer * 100)::text;
		--xamount := (xamount::integer / 100)::text;   -- меньшая оплата в реальности
		xjson := jsonb_set(xjson::jsonb,'{amount}',xamount::jsonb,FALSE);
		xjson := jsonb_set(xjson::jsonb,'{products,0,amount_prod}',xamount::jsonb,FALSE);
		xjson := jsonb_set(xjson::jsonb,'{products,0,price}',xamount::jsonb,FALSE);
		xans := mytosb.f_syspay(xjson);
		xid_paybank := xans::jsonb ->> 'newid';		
		UPDATE ataxi_transfer."order" SET id_paybank = xid_paybank WHERE id_order = xid;
		RETURN xans;
	END;
$function$
;

-- DROP FUNCTION ataxi_transfer.f_order_id(text);

CREATE OR REPLACE FUNCTION ataxi_transfer.f_order_id(id text)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE x_param JSON DEFAULT '{}';
	DECLARE xfiskal VARCHAR;
  DECLARE xidorder INTEGER;
  DECLARE xxidorder JSON;
  DECLARE xfiskal_text VARCHAR DEFAULT 'Электронный чек об оплате вы можете скачать здесь:';
	BEGIN
		SELECT id_order INTO xidorder FROM ataxi_transfer."order" WHERE id_calc = id ;
 	  SELECT call_back ->> 'receipt_url' INTO xfiskal FROM ekassa.ekassa_check WHERE data_check ->> 'id_order' = xidorder::text ;
 	  IF xfiskal != '' THEN
			SELECT jsonb_build_object('id_order', id_order, 'id_calc', id_calc, 'params', param, 'is_payed', t_syspay."enable", 
			'sbp', t_syspay.json_answer, 'fiscal', jsonb_build_object('fiskal_url', xfiskal,'description', xfiskal_text)) INTO x_param
			FROM ataxi_transfer."order" t_order
			LEFT JOIN mytosb.syspay t_syspay ON t_order.id_paybank = t_syspay.id_paybank WHERE id_calc = id;
		ELSE 
			SELECT jsonb_build_object('id_order', id_order, 'id_calc', id_calc, 'params', param, 'is_payed', t_syspay."enable", 
			'sbp', t_syspay.json_answer, 'fiscal', null) INTO x_param FROM ataxi_transfer."order" t_order
			LEFT JOIN mytosb.syspay t_syspay ON t_order.id_paybank = t_syspay.id_paybank WHERE id_calc = id;
    END IF;		
	RETURN x_param;
	END;
$function$
;

-- DROP FUNCTION ataxi_transfer.f_order_status();

CREATE OR REPLACE FUNCTION ataxi_transfer.f_order_status()
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

-- DROP FUNCTION ataxi_transfer.f_order_status1();

CREATE OR REPLACE FUNCTION ataxi_transfer.f_order_status1()
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
	DECLARE
		xjs_idpay JSON;
		xlogin VARCHAR;
		xid_order INTEGER;
BEGIN
	SELECT idpay INTO xjs_idpay FROM mytosb.syspay WHERE id_paybank = 516;
	xlogin := xjs_idpay::jsonb ->> 'login_dev';
	IF xlogin = 'web_ataxi' THEN
		xid_order := (xjs_idpay::jsonb ->> 'id_order')::integer;
		UPDATE ataxi_transfer."order" SET "enable" = TRUE WHERE id_order = xid_order;
	END IF;
	RETURN xid_order;
END
$function$
;

-- DROP FUNCTION ataxi_transfer.f_order_test(json);

CREATE OR REPLACE FUNCTION ataxi_transfer.f_order_test(x_json json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE 
		xid INTEGER;
		xid_calc VARCHAR;
		xlogin VARCHAR;
		xdatetime VARCHAR;
		xjs JSON;
		xid_pay JSON; 
		xid_paybank INTEGER;
	BEGIN
		xid_calc := x_json::jsonb ->> 'id_calc';
		xdatetime := x_json::jsonb ->> 'timestamp';
		x_json := x_json::jsonb - 'id_calc' - 'timestamp';
		xlogin := x_json::jsonb ->> 'login';
		x_json := x_json::jsonb || jsonb_build_object('id_order',xid,'datetime',xdatetime);
		xjs := ataxi_transfer.f_syspay(x_json);
		xid_paybank := xjs::jsonb ->> 'newid';		
    RETURN xjs;
	END;
$function$
;

-- DROP FUNCTION ataxi_transfer.f_send_check(json);

CREATE OR REPLACE FUNCTION ataxi_transfer.f_send_check(xjson json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
  DECLARE 
		xbillid JSONB;
	  xcallback JSON;
	  xans JSON;
	  xlogin VARCHAR;
	  xidcalc VARCHAR;
	  xxlogin VARCHAR DEFAULT 'web_ataxi';
    xurl VARCHAR ;
    xlink VARCHAR DEFAULT '<a href="@url" target="_blank"> ссылке </a>'; 
	  xidorder INTEGER;
	  xsubjcust VARCHAR DEFAULT 'mail from AtaxiTransfer';
	  xaddrcust VARCHAR;
	  xbodycust VARCHAR DEFAULT 'Спасибо за оплату заказа';
BEGIN
	  xidorder := xjson::jsonb ->> 'id_order';
    xurl := xjson::jsonb ->> 'fiskal_url';
    SELECT param ->> 'login', param ->> 'email_customer' INTO xlogin, xaddrcust FROM ataxi_transfer."order" where id_order = xidorder ;
   	IF xlogin = xxlogin THEN
       	SELECT notification ->> 'notify_customer' INTO  xbodycust from ataxi_transfer.merch_scheme  WHERE  login = xxlogin ;
 --       SELECT id_calc 	INTO xidcalc FROM ataxi_transfer."order" where id_order = xidorder ;
 --       xurl := xurl || xidcalc ;
 --       xlink := REPLACE(xlink,'@url', xurl::text);       
        xbodycust := REPLACE(xbodycust,'@order', xidorder::text);
       	xans := jsonb_build_object('customer',jsonb_build_object('Addr',xaddrcust, 'Subj',xsubjcust, 'Body',xbodycust));
        RETURN xans;
	END IF;
    xans := jsonb_build_object('login', xlogin );
RETURN xans;
END;
$function$
;

-- DROP FUNCTION ataxi_transfer.f_send_email(json);

CREATE OR REPLACE FUNCTION ataxi_transfer.f_send_email(xjson json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
  DECLARE xbillid JSONB;
	DECLARE xcallback JSON;
	DECLARE xans JSON;
	DECLARE xlogin VARCHAR;
	DECLARE xidcalc VARCHAR;
	DECLARE xxlogin VARCHAR DEFAULT 'web_ataxi';
  DECLARE xurl VARCHAR DEFAULT 'https://ataxi.atotx.ru/transfer/order/';
  DECLARE xlink VARCHAR DEFAULT '<a href="@url" target="_blank"> ссылке </a>'; 
	DECLARE xidorder INTEGER;
	DECLARE xsubj VARCHAR DEFAULT 'А-Такси: Заказ оформлен';
	DECLARE xaddr VARCHAR;
	DECLARE xbody VARCHAR;
BEGIN
	xbillid := xjson::jsonb -> 'qrcId';
	SELECT json_inside ->> 'id_order', json_inside ->> 'login' 	INTO xidorder,xlogin FROM mytosb.syspay WHERE json_callback -> 'qrcId' = xbillid;
   	IF xlogin = xxlogin THEN
       	SELECT notification ->> 'email_ataxi', notification ->> 'notify_carrier' INTO xaddr,xbody from ataxi_transfer.merch_scheme  WHERE  login = xxlogin ;
        SELECT id_calc 	INTO xidcalc FROM ataxi_transfer."order" where id_order = xidorder ;
        xurl := xurl || xidcalc ;
        xlink := REPLACE(xlink,'@url', xurl::text);       
        xbody := REPLACE(xbody,'@links', xlink::text);
       	xans := jsonb_build_object('carrier',jsonb_build_object('Addr',xaddr, 'Subj',xsubj, 'Body',xbody));
        RETURN xans;
	END IF;
    xans := jsonb_build_object('login', xlogin );
RETURN xans;
end;
$function$
;

-- DROP FUNCTION ataxi_transfer.f_send_email_before_pay(json);

CREATE OR REPLACE FUNCTION ataxi_transfer.f_send_email_before_pay(xjson json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
  DECLARE xbillid JSONB;
	DECLARE xcallback JSON;
	DECLARE xans JSON;
	DECLARE xlogin VARCHAR;
	DECLARE xidcalc VARCHAR;
	DECLARE xxlogin VARCHAR DEFAULT 'web_ataxi';
  DECLARE xurl VARCHAR DEFAULT 'https://ataxi.atotx.ru/transfer/order/';
  DECLARE xlink VARCHAR DEFAULT '<a href="@url" target="_blank"> ссылке </a>'; 
	DECLARE xidorder INTEGER;
	DECLARE xsubj VARCHAR DEFAULT 'А-Такси: Заказ создан но не оплачен';
	DECLARE xaddr VARCHAR;
	DECLARE xbody VARCHAR;
BEGIN
    xlogin := xjson::jsonb -> 'login';
	xidcalc := xjson::jsonb -> 'id_calc';
    xidcalc := trim(both '"' from xidcalc );
    xlogin := trim(both '"' from xlogin );
	IF xlogin = xxlogin THEN
       	SELECT notification ->> 'email_ataxi', notification ->> 'notify_carrier_before_pay' INTO xaddr,xbody from ataxi_transfer.merch_scheme  WHERE  login = xxlogin ;
        xurl := xurl || xidcalc ;
        xlink := REPLACE(xlink,'@url', xurl::text);       
        xbody := REPLACE(xbody,'@links', xlink::text);
        xans := jsonb_build_object('carrier',jsonb_build_object('Addr',xaddr, 'Subj',xsubj, 'Body',xbody));
        RETURN xans;
	END IF;
    xans := jsonb_build_object('login', xlogin );
RETURN xans;
end;
$function$
;

-- DROP FUNCTION ataxi_transfer.insert_town_trigger();

CREATE OR REPLACE FUNCTION ataxi_transfer.insert_town_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  PERFORM (
    WITH payload("id_town", "name_town", "region", "short_name", "fld_sort") AS (
    SELECT NEW.id_town, NEW.name_town, NEW.region, NEW.short_name, NEW.fld_sort
    )
  SELECT pg_notify('cashe_town', row_to_json(payload) :: TEXT)
    FROM payload
  );
  RETURN NULL;
END
$function$
;

-- DROP FUNCTION ataxi_transfer.update_town_trigger();

CREATE OR REPLACE FUNCTION ataxi_transfer.update_town_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  PERFORM (
    WITH payload("id_town", "name_town", "region", "short_name", "fld_sort") AS (
    SELECT OLD.id_town, OLD.name_town, OLD.region, OLD.short_name, OLD.fld_sort
    )
  SELECT pg_notify('cashe_town', row_to_json(payload) :: TEXT)
    FROM payload
  );
  RETURN NULL;
END
$function$
;
-- DROP SCHEMA ataxi_transfer1;

CREATE SCHEMA ataxi_transfer1 AUTHORIZATION postgres;

-- DROP SEQUENCE ataxi_transfer1.calc_counter_seq;

CREATE SEQUENCE ataxi_transfer1.calc_counter_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE ataxi_transfer1.merch_sch_idmerch_seq;

CREATE SEQUENCE ataxi_transfer1.merch_sch_idmerch_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32000
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE ataxi_transfer1.order_id_paybank_seq;

CREATE SEQUENCE ataxi_transfer1.order_id_paybank_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE ataxi_transfer1.order_idorder_seq;

CREATE SEQUENCE ataxi_transfer1.order_idorder_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32000
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE ataxi_transfer1.price_idprice_seq;

CREATE SEQUENCE ataxi_transfer1.price_idprice_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32000
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE ataxi_transfer1.region_idregion_seq;

CREATE SEQUENCE ataxi_transfer1.region_idregion_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32000
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE ataxi_transfer1.tarif_idtarif_seq;

CREATE SEQUENCE ataxi_transfer1.tarif_idtarif_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32000
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE ataxi_transfer1.town_idtown_seq;

CREATE SEQUENCE ataxi_transfer1.town_idtown_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32000
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE ataxi_transfer1.view_idview_seq;

CREATE SEQUENCE ataxi_transfer1.view_idview_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32000
	START 1
	CACHE 1
	NO CYCLE;-- ataxi_transfer1."!location" определение

-- Drop table

-- DROP TABLE ataxi_transfer1."!location";

CREATE TABLE ataxi_transfer1."!location" (
	id int4 NOT NULL,
	region varchar(50) NULL,
	town _text NULL,
	"location" json NULL
);


-- ataxi_transfer1.calc_sec определение

-- Drop table

-- DROP TABLE ataxi_transfer1.calc_sec;

CREATE TABLE ataxi_transfer1.calc_sec (
	id_calc varchar NOT NULL,
	"year" int2 NOT NULL,
	data_calc jsonb NULL,
	id_order int4 NULL,
	counter int4 DEFAULT nextval('ataxi_transfer.calc_counter_seq'::regclass) NOT NULL
)
PARTITION BY RANGE (year);


-- ataxi_transfer1.merch_scheme определение

-- Drop table

-- DROP TABLE ataxi_transfer1.merch_scheme;

CREATE TABLE ataxi_transfer1.merch_scheme (
	idmerch int2 DEFAULT nextval('ataxi_transfer.merch_sch_idmerch_seq'::regclass) NOT NULL,
	accesuaries jsonb NULL,
	login varchar(50) NOT NULL,
	notification jsonb NULL,
	CONSTRAINT merch_scheme_pkey PRIMARY KEY (idmerch)
);


-- ataxi_transfer1."order" определение

-- Drop table

-- DROP TABLE ataxi_transfer1."order";

CREATE TABLE ataxi_transfer1."order" (
	id_order int8 DEFAULT nextval('ataxi_transfer.order_idorder_seq'::regclass) NOT NULL,
	param jsonb NULL,
	id_calc varchar(50) NOT NULL,
	"enable" bool DEFAULT false NOT NULL,
	id_paybank int4 NULL,
	CONSTRAINT idcalc UNIQUE (id_calc),
	CONSTRAINT order_pkey PRIMARY KEY (id_order)
);


-- ataxi_transfer1.price определение

-- Drop table

-- DROP TABLE ataxi_transfer1.price;

CREATE TABLE ataxi_transfer1.price (
	id_price int2 DEFAULT nextval('ataxi_transfer.price_idprice_seq'::regclass) NOT NULL,
	town int2 NOT NULL,
	view_trans int2 NOT NULL,
	tarif int2 NOT NULL,
	amount numeric(10, 2) NULL
);


-- ataxi_transfer1.region определение

-- Drop table

-- DROP TABLE ataxi_transfer1.region;

CREATE TABLE ataxi_transfer1.region (
	id_region int2 DEFAULT nextval('ataxi_transfer.region_idregion_seq'::regclass) NOT NULL,
	name_region varchar(50) NULL,
	alias varchar(10) NULL
);


-- ataxi_transfer1.tarif определение

-- Drop table

-- DROP TABLE ataxi_transfer1.tarif;

CREATE TABLE ataxi_transfer1.tarif (
	" id_tarif" int2 DEFAULT nextval('ataxi_transfer.tarif_idtarif_seq'::regclass) NOT NULL,
	name_tarif varchar(50) NULL,
	view_trans int2 NULL
);


-- ataxi_transfer1.town определение

-- Drop table

-- DROP TABLE ataxi_transfer1.town;

CREATE TABLE ataxi_transfer1.town (
	id_town int2 DEFAULT nextval('ataxi_transfer.town_idtown_seq'::regclass) NOT NULL,
	name_town varchar(150) NULL,
	region int2 NULL,
	short_name varchar(10) NULL,
	fld_sort int4 NULL
);

-- Table Triggers

create trigger insert_town_trigger after
insert
    on
    ataxi_transfer1.town for each row execute function ataxi_transfer.insert_town_trigger();
create trigger update_town_trigger after
update
    on
    ataxi_transfer1.town for each row execute function ataxi_transfer.update_town_trigger();


-- ataxi_transfer1.view_transfer определение

-- Drop table

-- DROP TABLE ataxi_transfer1.view_transfer;

CREATE TABLE ataxi_transfer1.view_transfer (
	id_view int2 DEFAULT nextval('ataxi_transfer.view_idview_seq'::regclass) NOT NULL,
	view_name varchar(25) NULL
);


-- ataxi_transfer1.calc_2023 определение

CREATE TABLE ataxi_transfer1.calc_2023 PARTITION OF ataxi_transfer1.calc_sec (
	CONSTRAINT calc_2023_pkey PRIMARY KEY (id_calc)
) FOR VALUES FROM ('2023') TO ('2024');


-- ataxi_transfer1.calc_2024 определение

CREATE TABLE ataxi_transfer1.calc_2024 PARTITION OF ataxi_transfer1.calc_sec (
	CONSTRAINT calc_2024_pkey PRIMARY KEY (id_calc)
) FOR VALUES FROM ('2024') TO ('2025');


-- ataxi_transfer1.calc_2025 определение

CREATE TABLE ataxi_transfer1.calc_2025 PARTITION OF ataxi_transfer1.calc_sec (
	CONSTRAINT calc_2025_pkey PRIMARY KEY (id_calc)
) FOR VALUES FROM ('2025') TO ('2026');


-- ataxi_transfer1.calc_2026 определение

CREATE TABLE ataxi_transfer1.calc_2026 PARTITION OF ataxi_transfer1.calc_sec (
	CONSTRAINT calc_2026_pkey PRIMARY KEY (id_calc)
) FOR VALUES FROM ('2026') TO ('2027');


-- ataxi_transfer1.calc_2027 определение

CREATE TABLE ataxi_transfer1.calc_2027 PARTITION OF ataxi_transfer1.calc_sec (
	CONSTRAINT calc_2027_pkey PRIMARY KEY (id_calc)
) FOR VALUES FROM ('2027') TO ('2028');


-- ataxi_transfer1.calc_2028 определение

CREATE TABLE ataxi_transfer1.calc_2028 PARTITION OF ataxi_transfer1.calc_sec (
	CONSTRAINT calc_2028_pkey PRIMARY KEY (id_calc)
) FOR VALUES FROM ('2028') TO ('2029');


-- ataxi_transfer1.mv_tariffs1 исходный текст

CREATE MATERIALIZED VIEW ataxi_transfer1.mv_tariffs1
TABLESPACE pg_default
AS SELECT price.id_price,
    price.town AS id_town,
    town.name_town AS town,
    town.fld_sort,
    price.view_trans AS id_transfer_type,
    view_transfer.view_name AS transfer_type,
    price.tarif AS id_vehicle_size,
    tarif.name_tarif AS vehicle_size,
    price.amount
   FROM ataxi_transfer1.price
     LEFT JOIN ataxi_transfer1.town ON price.town = town.id_town
     LEFT JOIN ataxi_transfer1.view_transfer ON price.view_trans = view_transfer.id_view
     LEFT JOIN ataxi_transfer1.tarif tarif ON price.tarif = tarif." id_tarif"
  ORDER BY price.view_trans, price.tarif, town.fld_sort, town.name_town
WITH DATA;



-- DROP FUNCTION ataxi_transfer1.f_calc(json);

CREATE OR REPLACE FUNCTION ataxi_transfer1.f_calc(xcalc json)
 RETURNS smallint
 LANGUAGE plpgsql
AS $function$
	DECLARE
		xans JSON;
		xidcalc VARCHAR;
		xerr VARCHAR DEFAULT 'dublicate id_order';
		xamount INTEGER;
		xtarif INTEGER;
		xview_trans INTEGER;
		xarray_length INTEGER;
		i INTEGER;
		xyear INTEGER;
		xsaldo INTEGER DEFAULT 0;
		x_from INTEGER;
		x_to INTEGER;
	--IN:
	--{
	--"login": "web_ataxi",
	--"id_calc": "fhgfhgf-hfhthg-jhgjhv",
	--"count_places": 3,
	--"transfer": [{"from": 9, "to": 4},{"from": 6, "to": 8}],
	--"view_transfer": 2
	--"timestamp": "2023-00-00T00:00"
	--}
	BEGIN
		xidcalc := xcalc::jsonb ->> 'id_calc';
		xyear := LEFT(xcalc::jsonb ->> 'timestamp',4)::integer;
		xarray_length := jsonb_array_length(xcalc::jsonb -> 'transfer');
		xtarif := (xcalc::jsonb ->> 'count_places')::integer;
		xview_trans := (xcalc::jsonb ->> 'view_transfer')::integer; 
		xcalc := xcalc::jsonb - 'id_calc';
		FOR i IN 1..xarray_length LOOP
			x_from := (xcalc::jsonb -> 'transfer' -> i - 1 ->> 'from')::integer;
			x_to := (xcalc::jsonb -> 'transfer' -> i - 1 ->> 'to')::integer;
			SELECT amount INTO xamount FROM ataxi_transfer.price 
			WHERE tarif = xtarif AND view_trans = xview_trans AND (town = x_from OR town = x_to);
			xsaldo := xsaldo + xamount;
		END LOOP;
		xcalc := xcalc::jsonb || jsonb_build_object('xsaldo',xsaldo);
		BEGIN
			INSERT INTO ataxi_transfer.calc_sec (id_calc,"year",data_calc) 
			VALUES (xidcalc,xyear,xcalc);
			EXCEPTION WHEN unique_violation THEN
			xans := jsonb_build_object('err',1,'ans',xerr);
			RETURN xans;
	END;
	RETURN xsaldo;
	END
	--out:
	--{
	--"login": "web_ataxi",
	--"order_id": "1111111111"
	--"principal": "200121",
	--"amount": 0,
	--"phone_customer": "+79000000000",
	--"email_customer": null,
	--"name_customer": null,
	--"flight_train": null,
	--"arrival_datetime": "2023-00-00T00:00",
	--"hotel ": null,
	--"quote": {"adult": 1, "younger": 0, "baby": 0}
	--}
	$function$
;

-- DROP FUNCTION ataxi_transfer1.f_change_point();

CREATE OR REPLACE FUNCTION ataxi_transfer1.f_change_point()
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE 
		xitems JSON DEFAULT '{}';
		xjson JSON;
		xid_region INTEGER;
		xkey VARCHAR;
	BEGIN
	FOR xid_region IN 
	SELECT id_region FROM ataxi_transfer.region
	LOOP
		SELECT "alias" INTO xkey FROM ataxi_transfer.region WHERE id_region = xid_region;
		SELECT jsonb_build_object(xkey,array_to_json(array_agg(jsonb_build_object('value',name_town,'text',name_town,'short_name',short_name)))) 
		INTO xjson FROM ataxi_transfer.town	WHERE ataxi_transfer.town.region = xid_region;
		xitems := xitems::jsonb || xjson::jsonb;
  END LOOP;
  RETURN xitems;
  END
  $function$
;

-- DROP FUNCTION ataxi_transfer1.f_locat();

CREATE OR REPLACE FUNCTION ataxi_transfer1.f_locat()
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE 
	xitems JSON;
	xjson JSON;
	BEGIN
		SELECT jsonb_build_object('adler',array_to_json(array_agg(jsonb_build_object('value',name_town,'text',name_town,'short_name',short_name)))) 
		INTO xitems FROM ataxi_transfer.town	WHERE ataxi_transfer.town.region = 1;
		SELECT jsonb_build_object('abkhazia',array_to_json(array_agg(jsonb_build_object('value',name_town,'text',name_town,'short_name',short_name)))) 
		INTO xjson FROM ataxi_transfer.town WHERE region = 2;
		xitems := xitems::jsonb || xjson::jsonb;
		
		--SELECT ataxi_transfer.town.name_town AS town,ataxi_transfer.town.short_name AS short_name,
		--ataxi_transfer.region.name_region AS region,ataxi_transfer.region."alias" AS "alias"
    --FROM ataxi_transfer.town JOIN ataxi_transfer.region 
		--ON ataxi_transfer.town.region = ataxi_transfer.region.id_region

  RETURN xitems;
  END
  $function$
;

-- DROP FUNCTION ataxi_transfer1.f_locat1();

CREATE OR REPLACE FUNCTION ataxi_transfer1.f_locat1()
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE 
		xitems JSON DEFAULT '{}';
		xjson JSON;
		xid_region INTEGER;
		xkey VARCHAR;
	BEGIN
	FOR xid_region IN 
	SELECT id_region FROM ataxi_transfer.region
	LOOP
		SELECT "alias" INTO xkey FROM ataxi_transfer.region WHERE id_region = xid_region;
		SELECT jsonb_build_object(xkey,array_to_json(array_agg(jsonb_build_object('value',id_town::text,'text',name_town,'short_name',short_name)))) 
		INTO xjson FROM ataxi_transfer.town	WHERE ataxi_transfer.town.region = xid_region;
		xitems := xitems::jsonb || xjson::jsonb;
  END LOOP;
  RETURN xitems;
  END
  $function$
;

-- DROP FUNCTION ataxi_transfer1.f_location();

CREATE OR REPLACE FUNCTION ataxi_transfer1.f_location()
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE 
	xitems JSON DEFAULT '{}';
	xjson JSON;
	xid_region INTEGER;
	BEGIN
	FOR xid_region IN 
	SELECT id_region FROM ataxi_transfer.region
	LOOP
		SELECT jsonb_build_object("alias",name_region) INTO xjson 
		FROM ataxi_transfer.region WHERE id_region = xid_region;
		xitems := xitems::jsonb || xjson::jsonb;
	END LOOP;
  RETURN xitems;
  END
  $function$
;

-- DROP FUNCTION ataxi_transfer1.f_order(json);

CREATE OR REPLACE FUNCTION ataxi_transfer1.f_order(x_json json)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
	DECLARE 
		xjs JSON;
		xid_pay JSON; 
		xjson JSON;
		xans JSON;
		xid_calc VARCHAR;
		xlogin VARCHAR;
		xdatetime VARCHAR;
		xamount VARCHAR;
		xid INTEGER;
		xid_paybank INTEGER;
	-- IN:
	--	{
	--        "login": "web_ataxi",
	--				"id_calc": "hgfhdhfh",
	--        "amount": 240000,
	--        "view_transfer": 2,
	--        "count_places": 4,
	--        "quote": {
	--            "adult": 1,
	--            "younger": 0,
	--            "baby": 0,
	--        },
	--        "name_customer": "",
	--        "email_customer": "",
	--        "phone_customer": "+79186222897",
	--        "transfer": [
	--            {"to": 4, "from": 1, "flight_train": "", "hotel": "", "datetime_transfer": "2023-04-03T14:30"},
	--            {"to": 2, "from": 6, "flight_train": "", "hotel": "", "datetime_transfer": "2023-04-03T14:30"}
	--        ],
	--        "timestamp": "2023-04-03T14:30"
	--    }
	BEGIN
		xid_calc := x_json::jsonb ->> 'id_calc';
		xdatetime := x_json::jsonb ->> 'timestamp';
		x_json := x_json::jsonb - 'id_calc' - 'timestamp';
		xlogin := x_json::jsonb ->> 'login';
		xamount := x_json::jsonb ->> 'amount';
		BEGIN
			INSERT INTO ataxi_transfer."order"(param,id_calc)
			VALUES (x_json,xid_calc) RETURNING id_order INTO xid;
			EXCEPTION WHEN unique_violation THEN
				SELECT id_order INTO xid FROM ataxi_transfer."order" WHERE id_calc = xid_calc;
				xid_pay := jsonb_build_object('id_order',xid::text,'login_dev',xlogin);
				SELECT json_answer INTO xjs FROM mytosb.syspay WHERE idpay = xid_pay::jsonb;
				xjs := xjs::jsonb || jsonb_build_object('err',1);
			RETURN xjs;
		END;
			UPDATE ataxi_transfer.calc_sec SET id_order = xid WHERE id_calc = xid_calc;
			x_json := x_json::jsonb || jsonb_build_object('id_order',xid,'datetime',xdatetime);
		SELECT accesuaries::jsonb || x_json::jsonb INTO xjson 
		FROM ataxi_transfer.merch_scheme WHERE idmerch = 1;
		xamount := (xamount::integer * 100)::text;
		xamount := (xamount::integer / 1000)::text;
		xjson := jsonb_set(xjson::jsonb,'{amount}',xamount::jsonb,FALSE);
		xjson := jsonb_set(xjson::jsonb,'{products,0,amount_prod}',xamount::jsonb,FALSE);
		xjson := jsonb_set(xjson::jsonb,'{products,0,price}',xamount::jsonb,FALSE);
		xans := mytosb.f_syspay(xjson);
		xid_paybank := xans::jsonb ->> 'newid';		
		UPDATE ataxi_transfer."order" SET id_paybank = xid_paybank WHERE id_order = xid;
		RETURN xans;
	END;
$function$
;

-- DROP FUNCTION ataxi_transfer1.f_order_id(text);

CREATE OR REPLACE FUNCTION ataxi_transfer1.f_order_id(id text)
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

-- DROP FUNCTION ataxi_transfer1.f_order_status();

CREATE OR REPLACE FUNCTION ataxi_transfer1.f_order_status()
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

-- DROP FUNCTION ataxi_transfer1.f_order_status1();

CREATE OR REPLACE FUNCTION ataxi_transfer1.f_order_status1()
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
	DECLARE
		xjs_idpay JSON;
		xlogin VARCHAR;
		xid_order INTEGER;
BEGIN
	SELECT idpay INTO xjs_idpay FROM mytosb.syspay WHERE id_paybank = 516;
	xlogin := xjs_idpay::jsonb ->> 'login_dev';
	IF xlogin = 'web_ataxi' THEN
		xid_order := (xjs_idpay::jsonb ->> 'id_order')::integer;
		UPDATE ataxi_transfer."order" SET "enable" = TRUE WHERE id_order = xid_order;
	END IF;
	RETURN xid_order;
END
$function$
;

-- DROP FUNCTION ataxi_transfer1.f_order_test(json);

CREATE OR REPLACE FUNCTION ataxi_transfer1.f_order_test(x_json json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE 
		xid INTEGER;
		xid_calc VARCHAR;
		xlogin VARCHAR;
		xdatetime VARCHAR;
		xjs JSON;
		xid_pay JSON; 
		xid_paybank INTEGER;
	BEGIN
		xid_calc := x_json::jsonb ->> 'id_calc';
		xdatetime := x_json::jsonb ->> 'timestamp';
		x_json := x_json::jsonb - 'id_calc' - 'timestamp';
		xlogin := x_json::jsonb ->> 'login';
		x_json := x_json::jsonb || jsonb_build_object('id_order',xid,'datetime',xdatetime);
		xjs := ataxi_transfer.f_syspay(x_json);
		xid_paybank := xjs::jsonb ->> 'newid';		
    RETURN xjs;
	END;
$function$
;

-- DROP FUNCTION ataxi_transfer1.f_send_check(json);

CREATE OR REPLACE FUNCTION ataxi_transfer1.f_send_check(xjson json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
    DECLARE xbillid JSONB;
	DECLARE xcallback JSON;
	DECLARE xans JSON;
	DECLARE xlogin VARCHAR;
	DECLARE xidcalc VARCHAR;
	DECLARE xxlogin VARCHAR DEFAULT 'web_ataxi';
    DECLARE xurl VARCHAR ;
    DECLARE xlink VARCHAR DEFAULT '<a href="@url" target="_blank"> ссылке </a>'; 
	DECLARE xidorder INTEGER;
	DECLARE xsubjcust VARCHAR DEFAULT 'mail from AtaxiTransfer';
	DECLARE xaddrcust VARCHAR;
	DECLARE xbodycust VARCHAR DEFAULT 'Спасибо за оплату заказа';
begin

	--xidorder := xjson::jsonb -> 'client' ->> 'id_order';
	xidorder := xjson::jsonb ->> 'id_order';
    xurl := xjson::jsonb ->> 'fiskal_url';
    SELECT param ->> 'login', param ->> 'email_customer' INTO xlogin, xaddrcust FROM ataxi_transfer."order" where id_order = xidorder ;
   	IF xlogin = xxlogin THEN
       	SELECT notification ->> 'notify_customer' INTO  xbodycust from ataxi_transfer.merch_scheme  WHERE  login = xxlogin ;
--        SELECT id_calc 	INTO xidcalc FROM ataxi_transfer."order" where id_order = xidorder ;
--        xurl := xurl || xidcalc ;
        xlink := REPLACE(xlink,'@url', xurl::text);       
        xbodycust := REPLACE(xbodycust,'@link', xlink::text);
       	xans := jsonb_build_object('customer',jsonb_build_object('Addr',xaddrcust, 'Subj',xsubjcust, 'Body',xbodycust));
        RETURN xans;
	END IF;
    xans := jsonb_build_object('login', xlogin );
RETURN xans;
end;
$function$
;

-- DROP FUNCTION ataxi_transfer1.f_send_email(json);

CREATE OR REPLACE FUNCTION ataxi_transfer1.f_send_email(xjson json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
    DECLARE xbillid JSONB;
	DECLARE xcallback JSON;
	DECLARE xans JSON;
	DECLARE xlogin VARCHAR;
	DECLARE xidcalc VARCHAR;
	DECLARE xxlogin VARCHAR DEFAULT 'web_ataxi';
    DECLARE xurl VARCHAR DEFAULT 'https://ataxi.atotx.ru/transfer/order/';
    DECLARE xlink VARCHAR DEFAULT '<a href="@url" target="_blank"> ссылке </a>'; 
	DECLARE xidorder INTEGER;
	DECLARE xsubj VARCHAR DEFAULT 'А-Такси: Заказ оформлен';
	DECLARE xaddr VARCHAR;
	DECLARE xbody VARCHAR;
BEGIN
	xbillid := xjson::jsonb -> 'qrcId';
	SELECT json_inside ->> 'id_order', json_inside ->> 'login' 	INTO xidorder,xlogin FROM mytosb.syspay WHERE json_callback -> 'qrcId' = xbillid;
   	IF xlogin = xxlogin THEN
       	SELECT notification ->> 'email_ataxi', notification ->> 'notify_carrier' INTO xaddr,xbody from ataxi_transfer.merch_scheme  WHERE  login = xxlogin ;
        SELECT id_calc 	INTO xidcalc FROM ataxi_transfer."order" where id_order = xidorder ;
        xurl := xurl || xidcalc ;
        xlink := REPLACE(xlink,'@url', xurl::text);       
        xbody := REPLACE(xbody,'@links', xlink::text);
       	xans := jsonb_build_object('carrier',jsonb_build_object('Addr',xaddr, 'Subj',xsubj, 'Body',xbody));
        RETURN xans;
	END IF;
    xans := jsonb_build_object('login', xlogin );
RETURN xans;
end;
$function$
;

-- DROP FUNCTION ataxi_transfer1.insert_town_trigger();

CREATE OR REPLACE FUNCTION ataxi_transfer1.insert_town_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  PERFORM (
    WITH payload("id_town", "name_town", "region", "short_name", "fld_sort") AS (
    SELECT NEW.id_town, NEW.name_town, NEW.region, NEW.short_name, NEW.fld_sort
    )
  SELECT pg_notify('cashe_town', row_to_json(payload) :: TEXT)
    FROM payload
  );
  RETURN NULL;
END
$function$
;

-- DROP FUNCTION ataxi_transfer1.update_town_trigger();

CREATE OR REPLACE FUNCTION ataxi_transfer1.update_town_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  PERFORM (
    WITH payload("id_town", "name_town", "region", "short_name", "fld_sort") AS (
    SELECT OLD.id_town, OLD.name_town, OLD.region, OLD.short_name, OLD.fld_sort
    )
  SELECT pg_notify('cashe_town', row_to_json(payload) :: TEXT)
    FROM payload
  );
  RETURN NULL;
END
$function$
;