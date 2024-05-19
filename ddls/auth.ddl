-- DROP SCHEMA auth;

CREATE SCHEMA auth AUTHORIZATION andrey;

-- DROP SEQUENCE auth.usergroup_id_usergroup_seq;

CREATE SEQUENCE auth.usergroup_id_usergroup_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE auth.users_idpriv_seq;

CREATE SEQUENCE auth.users_idpriv_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;-- auth.usergroup определение

-- Drop table

-- DROP TABLE auth.usergroup;

CREATE TABLE auth.usergroup (
	id_usergroup serial4 NOT NULL,
	name_usergroup varchar(255) DEFAULT nextval('auth.usergroup_id_usergroup_seq'::regclass) NULL,
	CONSTRAINT usergroup_pkey PRIMARY KEY (id_usergroup)
);


-- auth.users определение

-- Drop table

-- DROP TABLE auth.users;

CREATE TABLE auth.users (
	login_master bpchar(10) NOT NULL,
	login_slave varchar(50) NULL,
	"password" varchar(255) NULL,
	"enable" bool DEFAULT true NOT NULL,
	attributies jsonb NULL,
	user_group int2 NULL,
	fld_uuid uuid DEFAULT gen_random_uuid() NULL
)
PARTITION BY RANGE (login_master);


-- auth.users1 определение

-- Drop table

-- DROP TABLE auth.users1;

CREATE TABLE auth.users1 (
	idpriv int4 DEFAULT nextval('auth.users_idpriv_seq'::regclass) NOT NULL,
	fljson_privilege jsonb NULL
);


-- auth.users_900 определение

CREATE TABLE auth.users_900 PARTITION OF auth.users (
	CONSTRAINT users_900_pkey PRIMARY KEY (login_master)
) FOR VALUES FROM ('9000000000') TO ('9250000000');


-- auth.users_925 определение

CREATE TABLE auth.users_925 PARTITION OF auth.users (
	CONSTRAINT users_925_pkey PRIMARY KEY (login_master)
) FOR VALUES FROM ('9250000000') TO ('9500000000');


-- auth.users_950 определение

CREATE TABLE auth.users_950 PARTITION OF auth.users (
	CONSTRAINT users_950_pkey PRIMARY KEY (login_master)
) FOR VALUES FROM ('9500000000') TO ('9750000000');


-- auth.users_975 определение

CREATE TABLE auth.users_975 PARTITION OF auth.users (
	CONSTRAINT users_975_pkey PRIMARY KEY (login_master)
) FOR VALUES FROM ('9750000000') TO ('9999999999');



-- DROP FUNCTION auth.f_api_users(bpchar);

CREATE OR REPLACE FUNCTION auth.f_api_users(xlogin character)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
    DECLARE xvalue json;
    DECLARE xphone VARCHAR;
    DECLARE xvalue2 json;
    declare xabsent VARCHAR DEFAULT 'Not found';
	BEGIN
	xlogin := xlogin::json ->> 'user_phone';	
	SELECT login_master INTO xphone FROM auth.users WHERE login_master = xlogin and "enable" = true;
    IF xphone is null THEN 
	   SELECT json_build_object('user', xabsent) INTO xvalue2 ;
       RETURN xvalue2;
    ELSE    
       SELECT attributies INTO xvalue FROM auth.users WHERE login_master = xlogin and "enable" = true;
       SELECT json_build_object('key',"login_master") INTO xvalue2 FROM auth.users WHERE login_master = xlogin and "enable" = true;
       xvalue := xvalue::jsonb || xvalue2::jsonb;
	   RETURN xvalue;
	END IF;
	END;
$function$
;