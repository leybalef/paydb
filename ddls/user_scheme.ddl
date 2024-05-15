-- DROP SCHEMA "user";

CREATE SCHEMA "user" AUTHORIZATION postgres;

-- DROP TYPE "user"."settings_enum";

CREATE TYPE "user"."settings_enum" AS ENUM (
	'cont',
	'core',
	'role',
	'firm');

-- DROP TYPE "user"."usergroup_enum";

CREATE TYPE "user"."usergroup_enum" AS ENUM (
	'auto',
	'hand');

-- DROP SEQUENCE "user".contact_id_list_seq;

CREATE SEQUENCE "user".contact_id_list_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32767
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE "user".contact_id_list_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE "user".contact_id_list_seq TO postgres;
GRANT SELECT, UPDATE ON SEQUENCE "user".contact_id_list_seq TO "Alef" WITH GRANT OPTION;
GRANT SELECT, UPDATE ON SEQUENCE "user".contact_id_list_seq TO apiw WITH GRANT OPTION;

-- DROP SEQUENCE "user".contact_id_list_seq1;

CREATE SEQUENCE "user".contact_id_list_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32767
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE "user".contact_id_list_seq1 OWNER TO postgres;
GRANT ALL ON SEQUENCE "user".contact_id_list_seq1 TO postgres;
GRANT ALL ON SEQUENCE "user".contact_id_list_seq1 TO "Alef";

-- DROP SEQUENCE "user".user_contact_id_contact_seq;

CREATE SEQUENCE "user".user_contact_id_contact_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE "user".user_contact_id_contact_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE "user".user_contact_id_contact_seq TO postgres;
GRANT ALL ON SEQUENCE "user".user_contact_id_contact_seq TO "Alef";

-- DROP SEQUENCE "user".usergroup_id_usergroup_seq;

CREATE SEQUENCE "user".usergroup_id_usergroup_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32767
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE "user".usergroup_id_usergroup_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE "user".usergroup_id_usergroup_seq TO postgres;
GRANT ALL ON SEQUENCE "user".usergroup_id_usergroup_seq TO "Alef";

-- DROP SEQUENCE "user".users_idpriv_seq;

CREATE SEQUENCE "user".users_idpriv_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE "user".users_idpriv_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE "user".users_idpriv_seq TO postgres;
GRANT SELECT, USAGE ON SEQUENCE "user".users_idpriv_seq TO "Alef";
-- "user".settings определение

-- Drop table

-- DROP TABLE "user".settings;

CREATE TABLE "user".settings (
	id_list int2 DEFAULT nextval('"user".contact_id_list_seq1'::regclass) NOT NULL,
	list_contact varchar(50) NULL,
	CONSTRAINT contact_pkey PRIMARY KEY (id_list)
);

-- Permissions

ALTER TABLE "user".settings OWNER TO postgres;
GRANT ALL ON TABLE "user".settings TO postgres;
GRANT INSERT, SELECT, REFERENCES, TRIGGER, UPDATE ON TABLE "user".settings TO "Alef" WITH GRANT OPTION;
GRANT INSERT, SELECT, REFERENCES, TRIGGER, UPDATE ON TABLE "user".settings TO apiw WITH GRANT OPTION;
GRANT INSERT, SELECT, REFERENCES, TRIGGER, UPDATE ON TABLE "user".settings TO "AlekzP" WITH GRANT OPTION;


-- "user".user_settings определение

-- Drop table

-- DROP TABLE "user".user_settings;

CREATE TABLE "user".user_settings (
	id_contact int8 DEFAULT nextval('"user".user_contact_id_contact_seq'::regclass) NOT NULL,
	contact varchar(50) NULL,
	type_contact int2 NULL,
	uuid_drive varchar(50) NULL,
	"enable" bool DEFAULT true NULL,
	required bool DEFAULT false NULL,
	type_settings "user"."settings_enum" NULL,
	CONSTRAINT user_contact_pkey PRIMARY KEY (id_contact)
);

-- Table Triggers

create trigger f_tr_user_contact after
insert
    or
update
    of enable on
    "user".user_settings for each row execute function "user".f_tr_user_contact();

-- Permissions

ALTER TABLE "user".user_settings OWNER TO postgres;
GRANT ALL ON TABLE "user".user_settings TO postgres;
GRANT INSERT, SELECT, REFERENCES, TRIGGER, UPDATE ON TABLE "user".user_settings TO "Alef" WITH GRANT OPTION;
GRANT INSERT, SELECT, REFERENCES, TRIGGER, UPDATE ON TABLE "user".user_settings TO apiw WITH GRANT OPTION;
GRANT INSERT, SELECT, REFERENCES, TRIGGER, UPDATE ON TABLE "user".user_settings TO "AlekzP" WITH GRANT OPTION;


-- "user".usergroup определение

-- Drop table

-- DROP TABLE "user".usergroup;

CREATE TABLE "user".usergroup (
	id_usergroup smallserial NOT NULL,
	name_usergroup varchar(255) NULL,
	change_role "user"."usergroup_enum" NULL,
	CONSTRAINT usergroup_pkey PRIMARY KEY (id_usergroup)
);

-- Permissions

ALTER TABLE "user".usergroup OWNER TO postgres;
GRANT ALL ON TABLE "user".usergroup TO postgres;
GRANT INSERT, SELECT, REFERENCES, TRIGGER, UPDATE ON TABLE "user".usergroup TO apiw WITH GRANT OPTION;
GRANT INSERT, SELECT, REFERENCES, TRIGGER, UPDATE ON TABLE "user".usergroup TO "Alef" WITH GRANT OPTION;
GRANT INSERT, SELECT, REFERENCES, TRIGGER, UPDATE ON TABLE "user".usergroup TO "AlekzP" WITH GRANT OPTION;


-- "user".users определение

-- Drop table

-- DROP TABLE "user".users;

CREATE TABLE "user".users (
	idpriv serial4 NOT NULL,
	fljson_privilege jsonb NULL,
	uuid_key uuid DEFAULT common.uuid_v7_gen() NOT NULL,
	login varchar(50) NULL,
	pass_hash varchar(50) NULL,
	datetime timestamp(6) DEFAULT now() NOT NULL,
	"enable" bool DEFAULT true NOT NULL,
	CONSTRAINT autoinc UNIQUE (idpriv),
	CONSTRAINT spr_privilege_pkey PRIMARY KEY (uuid_key)
);

-- Permissions

ALTER TABLE "user".users OWNER TO postgres;
GRANT ALL ON TABLE "user".users TO postgres;
GRANT INSERT, SELECT, REFERENCES, TRIGGER, UPDATE ON TABLE "user".users TO apiw WITH GRANT OPTION;
GRANT INSERT, SELECT, REFERENCES, TRIGGER, UPDATE ON TABLE "user".users TO "Alef" WITH GRANT OPTION;
GRANT INSERT, SELECT, REFERENCES, TRIGGER, UPDATE ON TABLE "user".users TO "AlekzP" WITH GRANT OPTION;


-- "user".mv_phone исходный текст

CREATE MATERIALIZED VIEW "user".mv_phone
TABLESPACE pg_default
AS SELECT user_settings.uuid_drive,
    user_settings.contact
   FROM "user".user_settings
  WHERE user_settings.type_contact = 1 AND user_settings.enable = true
WITH DATA;

-- Permissions

ALTER TABLE "user".mv_phone OWNER TO postgres;
GRANT ALL ON TABLE "user".mv_phone TO postgres;
GRANT ALL ON TABLE "user".mv_phone TO "Alef";
GRANT INSERT, SELECT, REFERENCES, TRIGGER, UPDATE ON TABLE "user".mv_phone TO apiw WITH GRANT OPTION;
GRANT INSERT, SELECT, REFERENCES, TRIGGER, UPDATE ON TABLE "user".mv_phone TO "AlekzP" WITH GRANT OPTION;



-- DROP FUNCTION "user".f_phone(bpchar);

CREATE OR REPLACE FUNCTION "user".f_phone(xphone character)
 RETURNS character varying
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
	DECLARE
		xcount INTEGER;
		xbalance VARCHAR;
		xuuid VARCHAR;
		xsaldo VARCHAR;
		xcore VARCHAR;
BEGIN
		SELECT COUNT(contact),MAX(uuid_drive) INTO xcount,xuuid 
		FROM "user".mv_phone 
		WHERE RIGHT(contact,10) = RIGHT(xphone,10);
		IF xcount = 0 THEN
			INSERT INTO "user"."users" ("login") VALUES ('')
			RETURNING uuid_key INTO xuuid;
			INSERT INTO "user".user_settings (contact,type_contact,uuid_drive)
			VALUES (xphone,1,xuuid);
			INSERT INTO reports.daybalance (saldo_yesterday,core,uuid,"date")
			VALUES (0,'000000',xuuid,CURRENT_DATE - 1);
			--INSERT INTO reports.balance (amount,datetime,descript,service,firm,region,core,"operation",id_parent,tbl_parent)
			--VALUES (0,CURRENT_DATE-1,'остаток','00','00','00','000000','saldo',0,0);
		END IF;
		xbalance := reports.f_count_balance(xuuid);
RETURN xbalance;
END
$function$
;

-- Permissions

ALTER FUNCTION "user".f_phone(bpchar) OWNER TO postgres;
GRANT ALL ON FUNCTION "user".f_phone(bpchar) TO postgres;
GRANT ALL ON FUNCTION "user".f_phone(bpchar) TO "AlekzP";
GRANT ALL ON FUNCTION "user".f_phone(bpchar) TO "Alef";
GRANT ALL ON FUNCTION "user".f_phone(bpchar) TO apiw;

-- DROP FUNCTION "user".f_role();

CREATE OR REPLACE FUNCTION "user".f_role()
 RETURNS SETOF text
 LANGUAGE sql
AS $function$
  SELECT jsonb_build_object('id',id_usergroup,'name',name_usergroup) FROM "user".usergroup 
	WHERE change_role = 'auto'
$function$
;

-- Permissions

ALTER FUNCTION "user".f_role() OWNER TO postgres;
GRANT ALL ON FUNCTION "user".f_role() TO postgres;

-- DROP FUNCTION "user".f_tr_user_contact();

CREATE OR REPLACE FUNCTION "user".f_tr_user_contact()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
	BEGIN
		REFRESH MATERIALIZED VIEW "user".mv_phone;
	RETURN NULL;
END
$function$
;

-- Permissions

ALTER FUNCTION "user".f_tr_user_contact() OWNER TO postgres;
GRANT ALL ON FUNCTION "user".f_tr_user_contact() TO postgres;
GRANT ALL ON FUNCTION "user".f_tr_user_contact() TO "Alef";
GRANT ALL ON FUNCTION "user".f_tr_user_contact() TO apiw;
GRANT ALL ON FUNCTION "user".f_tr_user_contact() TO "AlekzP";


-- Permissions

GRANT ALL ON SCHEMA "user" TO postgres;
GRANT USAGE ON SCHEMA "user" TO alexr;
GRANT USAGE ON SCHEMA "user" TO "AlekzP";
GRANT ALL ON SCHEMA "user" TO "Alef";