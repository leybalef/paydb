-- DROP SCHEMA "2can";

CREATE SCHEMA "2can" AUTHORIZATION andrey;

-- DROP SEQUENCE "2can".merch_idmerch_seq;

CREATE SEQUENCE "2can".merch_idmerch_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32000
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE "2can".syspay_id_paybank_seq;

CREATE SEQUENCE "2can".syspay_id_paybank_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;-- "2can".merchant_tap2go определение

-- Drop table

-- DROP TABLE "2can".merchant_tap2go;

CREATE TABLE "2can".merchant_tap2go (
	idmerch int2 DEFAULT nextval('"2can".merch_idmerch_seq'::regclass) NOT NULL,
	accesuaries jsonb NULL,
	mid varchar(50) NULL,
	syspay_merch int4 NULL,
	CONSTRAINT merchant_tap2go_pkey PRIMARY KEY (idmerch)
);


-- "2can".syspay определение

-- Drop table

-- DROP TABLE "2can".syspay;

CREATE TABLE "2can".syspay (
	id int4 DEFAULT nextval('"2can".syspay_id_paybank_seq'::regclass) NOT NULL,
	json_inside jsonb NULL,
	CONSTRAINT doc_syspay_pkey PRIMARY KEY (id)
);



-- DROP FUNCTION "2can".f_syspay(json);

CREATE OR REPLACE FUNCTION "2can".f_syspay(x_json json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	DECLARE xans JSON default '{"ans":"ok"}' ;
	--input data:
	--{
    --}
BEGIN
	INSERT INTO "2can".syspay (json_inside) VALUES (x_json) ;
    RETURN xans;
END;
--output data:
--{"ans": "ok"}
$function$
;

-- DROP FUNCTION "2can".f_tr_payment();

CREATE OR REPLACE FUNCTION "2can".f_tr_payment()
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
		xidmerch INTEGER;
		xsum NUMERIC(10,2);
		xratio NUMERIC(10,2);
		xidtarif INTEGER;
		xnewid INTEGER;
		xfirm CHAR(6);
		xidlogin CHAR(10);
		xprivilege VARCHAR;
		xamount VARCHAR;
		xdatetime VARCHAR;
		xemail VARCHAR;
		xphone VARCHAR;
		xchannel VARCHAR;
		xmid VARCHAR;
BEGIN  
		SELECT json_inside,json_inside ->> 'MID',(json_inside ->> 'Amount')::numeric,"id",json_inside ->> 'PaidAt',json_inside -> 'Description' 
		INTO xdata,xmid,xamount,xbillid,xdatetime,xproducts FROM "2can".syspay WHERE "id" = 767; 
		SELECT accesuaries ->> 'account' INTO xprivilege FROM "2can".merchant_tap2go WHERE mid = xmid;
		xyear := LEFT(xdatetime,4)::integer;
		xfirm := LEFT(xprivilege,6);
		xdata := xdata::jsonb || jsonb_build_object('id_paybank',xbillid);
		SELECT fljson_firm,fljson_firm ->> 'login',idcommparam INTO xjsonfirm,xidlogin,xcommparam
		FROM common.firmservice WHERE idfirm = xfirm;
		SELECT json_commparam INTO xjsoncomm FROM common.commparam WHERE idcommparam = xcommparam AND common.commparam."enable" = TRUE;
		SELECT attributies INTO xlogin FROM auth.users WHERE login_master = xidlogin;
		SELECT syspay_merch INTO xidmerch FROM "2can".merchant_tap2go WHERE mid = xmid;
		SELECT accesuaries,(accesuaries ->> 'format_amount')::numeric INTO xmerch,xratio FROM common.merchant WHERE idmerch = xidmerch;
		xsum := (xamount::numeric * xratio::numeric)::numeric(10,2);
		
		SELECT common.tranztarif."Tarif" INTO xidtarif 
		FROM common.tranztarif JOIN common.breakesum ON (common.tranztarif."Breakesum" = common.breakesum.idbreake) 
		WHERE common.tranztarif."Firm" = xfirm AND common.tranztarif."Syspay" = xidmerch AND common.tranztarif."Enable" = 1 
		AND (xsum < (common.breakesum.json_breakesum ->> 'Maxsum')::numeric AND xsum > (common.breakesum.json_breakesum ->> 'Minsum')::numeric);
		SELECT json_tarif INTO xtarif FROM common.tarif WHERE idtarif = xidtarif;
		xpaymerch := jsonb_build_object('id_order',xdata ->> 'id_order','merch',xidmerch);
		--SELECT ecassa::jsonb INTO xekassa FROM mytosb.info WHERE syspay = xidmerch;
		--SELECT channel_notify INTO xchannel FROM ekassa.ekassa WHERE id_kass = (xekassa -> 'ecassa' ->> 0)::integer;
		
		--INSERT INTO reports.payment(data_json,year,idpaymerch,comm_json,firm_json,merch_json,tarif_json,e_kassa)
		--VALUES (xdata,xyear,xpaymerch,xjsoncomm,(xjsonfirm::jsonb || xlogin::jsonb),xmerch,xtarif,xekassa) 
		--ON CONFLICT DO NOTHING RETURNING qtranz INTO xnewid;
		--PERFORM pg_notify(xchannel,xnewid::text);
		--RETURN NULL;
		RETURN xdata;
END
$function$
;