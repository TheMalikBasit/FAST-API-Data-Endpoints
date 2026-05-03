--
-- PostgreSQL database dump
--

\restrict J9arZXTiYUakmnuF07HLnqXwkhRgVEmg6O0rlg9scA8kahnD7k1240Mxvz0p650

-- Dumped from database version 15.15
-- Dumped by pg_dump version 15.15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activity_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activity_logs (
    organization_id uuid NOT NULL,
    user_id uuid,
    action character varying(50) NOT NULL,
    details jsonb,
    id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.activity_logs OWNER TO postgres;

--
-- Name: camera_rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.camera_rules (
    camera_id uuid NOT NULL,
    is_active boolean NOT NULL,
    active_rules jsonb NOT NULL,
    detection_zones jsonb,
    violation_cooldown_sec integer NOT NULL,
    id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.camera_rules OWNER TO postgres;

--
-- Name: cameras; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cameras (
    organization_id uuid NOT NULL,
    device_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    rtsp_url character varying NOT NULL,
    local_timezone character varying(50) NOT NULL,
    status character varying(50),
    location character varying(255),
    id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.cameras OWNER TO postgres;

--
-- Name: devices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.devices (
    organization_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    status character varying(50) NOT NULL,
    device_token_secret character varying(255) NOT NULL,
    last_heartbeat timestamp with time zone,
    id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    subscription_active boolean DEFAULT false NOT NULL
);


ALTER TABLE public.devices OWNER TO postgres;

--
-- Name: organization_capabilities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_capabilities (
    organization_id uuid NOT NULL,
    object_code character varying(100) NOT NULL,
    display_name character varying(100) NOT NULL,
    is_ppe boolean,
    id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.organization_capabilities OWNER TO postgres;

--
-- Name: organizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organizations (
    name character varying(255) NOT NULL,
    status character varying(50) NOT NULL,
    api_key_public character varying(255),
    id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.organizations OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    organization_id uuid NOT NULL,
    username character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role character varying(50) NOT NULL,
    is_active boolean NOT NULL,
    phone_number character varying,
    is_2fa_enabled boolean NOT NULL,
    otp_hash character varying,
    otp_expires_at timestamp without time zone,
    id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: violations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.violations (
    organization_id uuid NOT NULL,
    camera_id uuid NOT NULL,
    timestamp_utc timestamp with time zone DEFAULT now() NOT NULL,
    violation_type character varying(100) NOT NULL,
    severity character varying(20) NOT NULL,
    is_false_positive boolean NOT NULL,
    snapshot_url character varying,
    person_track_id character varying(255),
    duration_seconds double precision,
    is_resolved boolean NOT NULL,
    id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.violations OWNER TO postgres;

--
-- Data for Name: activity_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activity_logs (organization_id, user_id, action, details, id, created_at, updated_at) FROM stdin;
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	a72f37d3-e6e5-4cac-af02-62eab8ecbc1e	2026-03-10 19:08:56.649652+00	2026-03-10 19:08:56.649652+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	78424086-1122-43ce-bda0-6b8476604909	2026-03-10 19:14:18.543406+00	2026-03-10 19:14:18.543406+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_FALSE_POSITIVE_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	7e4168a7-716b-4d3b-81f5-4dc2f85822ce	2026-03-10 19:14:49.478331+00	2026-03-10 19:14:49.478331+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_FALSE_POSITIVE_TOGGLED	{"new_value": false, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	82edabb6-793d-4c74-9ff7-1e43e904682b	2026-03-10 19:15:12.016387+00	2026-03-10 19:15:12.016387+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	c3c9836c-5449-4566-8444-75e877ba1dee	2026-03-10 19:15:37.630843+00	2026-03-10 19:15:37.630843+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": false, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	8b4f553e-b788-423a-8bae-42634d919b5d	2026-03-10 19:15:53.56+00	2026-03-10 19:15:53.56+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	3dacb5c9-0a39-461a-a86b-919d17973fe4	2026-03-10 19:16:00.080124+00	2026-03-10 19:16:00.080124+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	CAMERA_CONFIGURED	{"changes": {"name": {"new": "Admin Cam 01", "old": "ICU-Cam-001"}, "location": {"new": "Admin Room", "old": "ICU Entrance"}}, "camera_id": "6aa9be75-a251-446f-8503-45fac97be873", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "camera_name": "Admin Cam 01"}	2c771ddf-c8d8-4224-b8c2-72dfc097c565	2026-03-10 19:17:11.486391+00	2026-03-10 19:17:11.486391+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	CAMERA_CONFIGURED	{"changes": {"name": {"new": "Admin Cam 02", "old": "ICU-Cam-02"}, "location": {"new": "Admin Room", "old": "ICU Entrance"}}, "camera_id": "67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "camera_name": "Admin Cam 02"}	d460aed5-20ee-4780-8fa5-f7dc8176c37e	2026-03-10 19:17:28.738027+00	2026-03-10 19:17:28.738027+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	CAMERA_CONFIGURED	{"changes": {"active_rules": {"new": {"no_cap": {"required": true, "severity": "Low"}, "no_mask": {"required": true, "severity": "Low"}}, "old": {"no_cap": {"required": true, "severity": "High"}, "no_mask": {"required": true, "severity": "High"}, "smoking": {"required": true, "severity": "Low"}, "no_gloves": {"required": true, "severity": "Medium"}, "no_medical_coat": {"required": true, "severity": "Low"}}}}, "camera_id": "67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "camera_name": "Admin Cam 02"}	0160913f-d567-4377-a748-eb8e2f11aca7	2026-03-10 19:18:34.585421+00	2026-03-10 19:18:34.585421+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_ADDED	{"actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "target_user_name": "Fatima Obaid", "target_user_role": "Supervisor", "target_user_email": "probasit03@gmail.com"}	9ade33f2-0de2-4822-8aa6-7a2137427a6c	2026-03-10 19:21:04.600614+00	2026-03-10 19:21:04.600614+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	05f78068-8060-47b5-92c6-d8dcc672e3cb	2026-03-11 18:08:05.296698+00	2026-03-11 18:08:05.296698+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	548f3acb-46bb-4c92-a7ff-5fe317114254	2026-03-11 18:15:29.660175+00	2026-03-11 18:15:29.660175+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	efd7d5cc-d3ba-4f5d-9bba-7244ad6ed3ca	2026-03-11 18:38:20.969389+00	2026-03-11 18:38:20.969389+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	CAMERA_CONFIGURED	{"changes": {"active_rules": {"new": {"no_cap": {"required": true, "severity": "High"}, "no_mask": {"required": true, "severity": "High"}, "smoking": {"required": true, "severity": "High"}, "no_gloves": {"required": true, "severity": "High"}}, "old": {"no_cap": {"required": true, "severity": "High"}, "no_mask": {"required": true, "severity": "High"}, "smoking": {"required": true, "severity": "High"}, "no_gloves": {"required": true, "severity": "High"}, "no_medical_coat": {"required": true, "severity": "High"}}}}, "camera_id": "f94b3d22-74e9-4c0f-9d66-15816ba4bf28", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "camera_name": "Surgical-Cam-01"}	8011d527-5248-4df4-ab2c-f5162368a225	2026-03-11 18:46:13.943705+00	2026-03-11 18:46:13.943705+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	CAMERA_CONFIGURED	{"changes": {"active_rules": {"new": {"no_cap": {"required": true, "severity": "High"}, "no_mask": {"required": true, "severity": "High"}, "smoking": {"required": true, "severity": "High"}}, "old": {"no_cap": {"required": true, "severity": "High"}, "no_mask": {"required": true, "severity": "High"}, "smoking": {"required": true, "severity": "High"}, "no_gloves": {"required": true, "severity": "High"}, "no_medical_coat": {"required": true, "severity": "High"}}}}, "camera_id": "19f09d60-c541-480a-87ce-64758b2ccb88", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "camera_name": "Surgical-Cam-02"}	ac0c79a0-27fc-4c15-9de3-181e70b2f9ba	2026-03-11 18:46:21.183341+00	2026-03-11 18:46:21.183341+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	CAMERA_CONFIGURED	{"changes": {"active_rules": {"new": {"no_cap": {"required": true, "severity": "High"}, "no_gloves": {"required": true, "severity": "High"}, "no_medical_coat": {"required": true, "severity": "High"}}, "old": {"no_cap": {"required": true, "severity": "High"}, "no_mask": {"required": true, "severity": "High"}, "smoking": {"required": true, "severity": "High"}, "no_gloves": {"required": true, "severity": "High"}, "no_medical_coat": {"required": true, "severity": "High"}}}}, "camera_id": "5f3f0032-5b28-4b50-8e1f-e72d0b41f641", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "camera_name": "Lobby-Cam-01"}	52ecd38c-e565-4ee5-b58f-cceefe4cb0c5	2026-03-11 18:46:26.581146+00	2026-03-11 18:46:26.581146+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	CAMERA_CONFIGURED	{"changes": {"active_rules": {"new": {"smoking": {"required": true, "severity": "High"}, "no_gloves": {"required": true, "severity": "High"}, "no_medical_coat": {"required": true, "severity": "High"}}, "old": {"no_cap": {"required": true, "severity": "High"}, "no_mask": {"required": true, "severity": "High"}, "smoking": {"required": true, "severity": "High"}, "no_gloves": {"required": true, "severity": "High"}, "no_medical_coat": {"required": true, "severity": "High"}}}}, "camera_id": "7641b663-6d92-48a1-89d9-1e922e5ad73a", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "camera_name": "Lobby-Cam-02"}	d1d8b613-fd44-479f-9419-dc3a884e711a	2026-03-11 18:46:31.711693+00	2026-03-11 18:46:31.711693+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	\N	USER_LOGIN	{"method": "standard", "actor_name": "Fatima Obaid", "actor_email": "probasit03@gmail.com"}	bae147d5-7a08-40b2-a8e3-66a538ebdc96	2026-03-11 18:13:24.836545+00	2026-03-11 18:13:24.836545+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	CAMERA_CONFIGURED	{"changes": {"active_rules": {"new": {"smoking": {"required": true, "severity": "High"}, "no_gloves": {"required": true, "severity": "High"}, "no_medical_coat": {"required": true, "severity": "High"}}, "old": {"no_cap": {"required": true, "severity": "High"}, "no_mask": {"required": true, "severity": "High"}, "smoking": {"required": true, "severity": "High"}, "no_gloves": {"required": true, "severity": "High"}, "no_medical_coat": {"required": true, "severity": "High"}}}}, "camera_id": "c1d7603c-4498-46d7-9fd2-071f48578e17", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "camera_name": "Staff-Cam-02"}	0c27a83d-4520-4b42-badd-4fd189a7e104	2026-03-11 18:46:36.845594+00	2026-03-11 18:46:36.845594+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	CAMERA_CONFIGURED	{"changes": {"active_rules": {"new": {"no_medical_coat": {"required": true, "severity": "High"}}, "old": {"no_cap": {"required": true, "severity": "High"}, "no_mask": {"required": true, "severity": "High"}, "smoking": {"required": true, "severity": "High"}, "no_gloves": {"required": true, "severity": "High"}, "no_medical_coat": {"required": true, "severity": "High"}}}}, "camera_id": "c9d0dff8-33e5-436c-9f8c-c9986fb49be0", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "camera_name": "Medicine-Cam-01"}	36304dd5-0a37-4a0c-b368-1e7878a899f3	2026-03-11 18:46:49.201988+00	2026-03-11 18:46:49.201988+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	CAMERA_CONFIGURED	{"changes": {"name": {"new": "Parking Cam 02", "old": "Lobby-Cam-02"}, "location": {"new": "Parking", "old": "Lobby"}}, "camera_id": "7641b663-6d92-48a1-89d9-1e922e5ad73a", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "camera_name": "Parking Cam 02"}	5ec760cb-5a10-4f03-8d1f-e620cfbba6cc	2026-03-11 18:47:27.072564+00	2026-03-11 18:47:27.072564+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "305fb234-014a-4b76-96c3-8ba3d82e011d"}	a639c617-1c67-4084-bc36-a1d410f79c56	2026-03-11 19:52:21.958772+00	2026-03-11 19:52:21.958772+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	REPORT_DOWNLOADED	{"filters": {"date": "2026-03-10 08:31 PM"}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "report_type": "eca86f94-fa6b-4bd3-8924-06dca09353c9"}	9797cf40-722f-4544-a54b-5baa5d1c2b38	2026-03-11 19:52:32.13066+00	2026-03-11 19:52:32.13066+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	REPORT_DOWNLOADED	{"filters": {"date": "2026-03-10 06:18 PM"}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "report_type": "c039416d-0425-4555-b72e-b8e7656d04f9"}	f7c4d8e5-82f0-4611-98db-ba00552db8ad	2026-03-11 19:52:48.078363+00	2026-03-11 19:52:48.078363+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "305fb234-014a-4b76-96c3-8ba3d82e011d"}	5b7ffafd-da56-41d5-aa3d-0e2fe106a310	2026-03-11 19:53:06.966357+00	2026-03-11 19:53:06.966357+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_FALSE_POSITIVE_TOGGLED	{"new_value": false, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "8afce279-a753-468c-8eb9-72820082565d"}	de3eab9b-566c-4e78-a124-68d704c9b088	2026-03-11 19:54:22.273589+00	2026-03-11 19:54:22.273589+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	REPORT_DOWNLOADED	{"filters": {"date": "2026-03-10 09:50 PM"}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "report_type": "8afce279-a753-468c-8eb9-72820082565d"}	ada6abc0-b98e-4cf6-903b-3ceb1b4a54ac	2026-03-11 19:55:45.724803+00	2026-03-11 19:55:45.724803+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	CAMERA_CONFIGURED	{"changes": {"active_rules": {"new": {"smoking": {"required": true, "severity": "High"}, "no_gloves": {"required": true, "severity": "High"}, "no_medical_coat": {"required": true, "severity": "High"}}, "old": {"no_cap": {"required": true, "severity": "High"}, "no_mask": {"required": true, "severity": "High"}, "smoking": {"required": true, "severity": "High"}, "no_gloves": {"required": true, "severity": "High"}, "no_medical_coat": {"required": true, "severity": "High"}}}}, "camera_id": "550d705a-de12-4566-afcd-b6290bdd6efd", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "camera_name": "Staff-Cam-01"}	7c6f8662-91cc-4e7f-a338-32517853d8c7	2026-03-11 18:46:42.058989+00	2026-03-11 18:46:42.058989+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	CAMERA_CONFIGURED	{"changes": {"active_rules": {"new": {"no_gloves": {"required": true, "severity": "High"}, "no_medical_coat": {"required": true, "severity": "High"}}, "old": {"no_cap": {"required": true, "severity": "High"}, "no_mask": {"required": true, "severity": "High"}, "smoking": {"required": true, "severity": "High"}, "no_gloves": {"required": true, "severity": "High"}, "no_medical_coat": {"required": true, "severity": "High"}}}}, "camera_id": "f9ab3e9d-be5d-4f67-b012-cdbaaa74827d", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "camera_name": "Medicine-Cam-02"}	943173e3-87b1-4be3-881e-56f573d5daff	2026-03-11 18:46:54.370131+00	2026-03-11 18:46:54.370131+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	CAMERA_CONFIGURED	{"changes": {"name": {"new": "Parking Cam 01", "old": "Lobby-Cam-01"}, "location": {"new": "Parking", "old": "Lobby"}}, "camera_id": "5f3f0032-5b28-4b50-8e1f-e72d0b41f641", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "camera_name": "Parking Cam 01"}	94bd9b23-98c0-4fb6-88c3-3b0bedef81a7	2026-03-11 18:47:49.438879+00	2026-03-11 18:47:49.438879+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	8cdeaf09-a641-4fb0-a9ad-d9d9f06cba92	2026-03-11 18:59:30.013113+00	2026-03-11 18:59:30.013113+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_FALSE_POSITIVE_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "8afce279-a753-468c-8eb9-72820082565d"}	1e26dad9-db49-4d96-84b0-25641f4c7570	2026-03-11 19:52:11.846073+00	2026-03-11 19:52:11.846073+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	REPORT_DOWNLOADED	{"filters": {"date": "2026-03-10 08:38 PM"}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "report_type": "305fb234-014a-4b76-96c3-8ba3d82e011d"}	e79543de-d3a0-4617-b9b8-4fdb03e51cf0	2026-03-11 19:52:25.774419+00	2026-03-11 19:52:25.774419+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	REPORT_DOWNLOADED	{"filters": {"date": "2026-03-10 08:38 PM"}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "report_type": "305fb234-014a-4b76-96c3-8ba3d82e011d"}	3d70db6d-a157-4bca-b60a-9a13fbbc93d1	2026-03-11 19:53:08.137369+00	2026-03-11 19:53:08.137369+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "8afce279-a753-468c-8eb9-72820082565d"}	15e1c0b3-a04b-4a7d-ac74-7aa78e056c69	2026-03-11 19:54:21.699809+00	2026-03-11 19:54:21.699809+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "8afce279-a753-468c-8eb9-72820082565d"}	30e5d399-3fbc-46c4-ab9e-0f6ae45e7163	2026-03-11 19:55:51.956205+00	2026-03-11 19:55:51.956205+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "8afce279-a753-468c-8eb9-72820082565d"}	a0ad8776-1a77-4ed2-a4de-b0eb4497206b	2026-03-11 20:09:31.389203+00	2026-03-11 20:09:31.389203+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": false, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "8afce279-a753-468c-8eb9-72820082565d"}	6d3466cb-a372-444e-a2c8-879d1153a55e	2026-03-11 20:10:44.870442+00	2026-03-11 20:10:44.870442+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "8afce279-a753-468c-8eb9-72820082565d"}	69b7e370-a9e3-4d72-b7f0-276c69cd937f	2026-03-11 20:10:54.662966+00	2026-03-11 20:10:54.662966+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": false, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "8afce279-a753-468c-8eb9-72820082565d"}	24165836-d79a-492b-a3fd-c7e3919383f2	2026-03-11 20:11:12.216695+00	2026-03-11 20:11:12.216695+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	18a55f90-0612-4e38-b412-07d37328aec8	2026-03-11 19:09:39.083873+00	2026-03-11 19:09:39.083873+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	102fe1e5-f760-482d-a870-6b3ab4a0ef24	2026-03-11 19:41:51.827076+00	2026-03-11 19:41:51.827076+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	REPORT_DOWNLOADED	{"filters": {"date": "2026-03-11 12:13 AM"}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "report_type": "f37b379f-1db3-4251-bc87-6084b8d43693"}	ab061797-fa07-4c86-bc70-d791d2e9b0fa	2026-03-11 19:42:53.723533+00	2026-03-11 19:42:53.723533+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "8afce279-a753-468c-8eb9-72820082565d"}	9bdbbc6f-da98-43f9-9ea6-39ff570e9c25	2026-03-11 19:52:13.859097+00	2026-03-11 19:52:13.859097+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	REPORT_DOWNLOADED	{"filters": {"date": "2026-03-10 09:50 PM"}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "report_type": "8afce279-a753-468c-8eb9-72820082565d"}	b3c9876b-349f-40d3-b7d6-077112bd45f4	2026-03-11 19:52:16.688881+00	2026-03-11 19:52:16.688881+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_FALSE_POSITIVE_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "eca86f94-fa6b-4bd3-8924-06dca09353c9"}	36396b55-9420-4576-bd41-8057b6d82035	2026-03-11 19:52:30.514268+00	2026-03-11 19:52:30.514268+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "eca86f94-fa6b-4bd3-8924-06dca09353c9"}	a571f787-e469-48e3-98b3-0e1438d1a8c8	2026-03-11 19:52:30.818918+00	2026-03-11 19:52:30.818918+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "07a5b57f-9781-4d4a-9a53-c1ccc7437624"}	ca44579b-c51d-4f95-90e9-7a285b5eb551	2026-03-11 19:52:37.786587+00	2026-03-11 19:52:37.786587+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	REPORT_DOWNLOADED	{"filters": {"date": "2026-03-10 07:32 PM"}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "report_type": "07a5b57f-9781-4d4a-9a53-c1ccc7437624"}	3bb6e151-29d6-443c-8243-e6e569713356	2026-03-11 19:52:39.360107+00	2026-03-11 19:52:39.360107+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "c039416d-0425-4555-b72e-b8e7656d04f9"}	5181ca92-a1af-480e-be1b-801bd997a508	2026-03-11 19:52:46.66941+00	2026-03-11 19:52:46.66941+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "8afce279-a753-468c-8eb9-72820082565d"}	4d3fa451-dbfc-4350-b0e6-15001845653d	2026-03-11 19:52:59.82936+00	2026-03-11 19:52:59.82936+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	REPORT_DOWNLOADED	{"filters": {"date": "2026-03-10 09:50 PM"}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "report_type": "8afce279-a753-468c-8eb9-72820082565d"}	14e042b2-c96b-4e46-98e7-0eb4553f6c0a	2026-03-11 19:53:02.441901+00	2026-03-11 19:53:02.441901+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "8afce279-a753-468c-8eb9-72820082565d"}	29ccc51e-7701-4887-9c69-f885bafa92ef	2026-03-11 19:53:25.869702+00	2026-03-11 19:53:25.869702+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	REPORT_DOWNLOADED	{"filters": {"date": "2026-03-10 09:50 PM"}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "report_type": "8afce279-a753-468c-8eb9-72820082565d"}	306e269b-222c-4d87-9114-58583d41e637	2026-03-11 19:53:27.934365+00	2026-03-11 19:53:27.934365+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	06623d7c-009c-4e6b-86f3-7ec37f1cc5c5	2026-03-11 19:54:06.392714+00	2026-03-11 19:54:06.392714+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	REPORT_DOWNLOADED	{"filters": {"date": "2026-03-10 09:50 PM"}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "report_type": "8afce279-a753-468c-8eb9-72820082565d"}	0b46f6ab-c160-4e6a-a264-973eaa27dc2b	2026-03-11 19:54:24.043656+00	2026-03-11 19:54:24.043656+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	REPORT_DOWNLOADED	{"filters": {"date": "2026-03-10 09:50 PM"}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "report_type": "8afce279-a753-468c-8eb9-72820082565d"}	cf3d07e3-aab4-4f6f-9c0c-dd52f3e7695d	2026-03-11 19:55:53.383345+00	2026-03-11 19:55:53.383345+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "8afce279-a753-468c-8eb9-72820082565d"}	b2bd0566-7ae2-410d-907f-1a88103afe7a	2026-03-11 20:08:46.269788+00	2026-03-11 20:08:46.269788+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_FALSE_POSITIVE_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "8afce279-a753-468c-8eb9-72820082565d"}	58ea86f5-ba97-4de8-9600-d045429616bd	2026-03-11 20:09:07.519617+00	2026-03-11 20:09:07.519617+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "8afce279-a753-468c-8eb9-72820082565d"}	86bf12b5-2012-431c-8a2c-462598857d48	2026-03-11 20:10:42.244541+00	2026-03-11 20:10:42.244541+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "8afce279-a753-468c-8eb9-72820082565d"}	a428953e-e2f6-4eaa-aa8f-92f8eb7d1bbc	2026-03-11 20:10:46.086838+00	2026-03-11 20:10:46.086838+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": false, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "8afce279-a753-468c-8eb9-72820082565d"}	bdde1e33-867e-4247-b3dc-c59fd4316e59	2026-03-11 20:10:51.239858+00	2026-03-11 20:10:51.239858+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "8afce279-a753-468c-8eb9-72820082565d"}	d8aa5ba7-a1d9-489d-a279-d01369fed67d	2026-03-11 20:11:09.506166+00	2026-03-11 20:11:09.506166+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "8afce279-a753-468c-8eb9-72820082565d"}	8291b376-1908-41b6-ae2e-fa5088be8393	2026-03-11 20:11:17.071557+00	2026-03-11 20:11:17.071557+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	REPORT_DOWNLOADED	{"filters": {"date": "2026-03-10 09:50 PM"}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "report_type": "8afce279-a753-468c-8eb9-72820082565d"}	64651ba5-ae72-4b60-b7cf-1c045728c105	2026-03-11 20:13:02.640577+00	2026-03-11 20:13:02.640577+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	b56a9ab9-57db-4290-93ad-755cfdab95b3	2026-03-11 20:13:43.442562+00	2026-03-11 20:13:43.442562+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	REPORT_DOWNLOADED	{"filters": {"date": "2026-03-11 12:13 AM"}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "report_type": "f37b379f-1db3-4251-bc87-6084b8d43693"}	c2586766-3169-4bbf-be07-3fe3ab8d1455	2026-03-11 20:13:46.85601+00	2026-03-11 20:13:46.85601+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	8ac2b3a5-9121-4bf1-894e-5681688bb82d	2026-03-11 20:16:22.590321+00	2026-03-11 20:16:22.590321+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": false, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	6ebe2392-39ca-424c-8d43-a271ed8abd7d	2026-03-11 20:16:24.160921+00	2026-03-11 20:16:24.160921+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	13cd0489-4ef4-49b2-9957-02b9244354d6	2026-03-11 20:16:28.825186+00	2026-03-11 20:16:28.825186+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	fc2bfb09-05c8-495e-8fd1-cbe51653acc6	2026-03-11 20:16:25.795533+00	2026-03-11 20:16:25.795533+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": false, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	3ecb655a-f0e6-47ba-a7e6-43be1c369b55	2026-03-11 20:16:29.892646+00	2026-03-11 20:16:29.892646+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	e2734838-0dc2-4317-b92f-3f613a4ad582	2026-03-11 20:16:40.332961+00	2026-03-11 20:16:40.332961+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_FALSE_POSITIVE_TOGGLED	{"new_value": false, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	2e950783-4e5a-4dee-88ee-54f1e08efb6f	2026-03-11 20:16:44.320581+00	2026-03-11 20:16:44.320581+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	22a5e11a-fa32-4ab2-919e-b7a0eb831a26	2026-03-11 20:25:45.996947+00	2026-03-11 20:25:45.996947+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": false, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	00e3ee4b-edd9-405f-a112-a9940cb7c72b	2026-03-11 20:16:26.998469+00	2026-03-11 20:16:26.998469+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	3bc04044-e148-4ae8-b9d9-a21b09e094fa	2026-03-11 20:16:32.979119+00	2026-03-11 20:16:32.979119+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_FALSE_POSITIVE_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	0ba32ec7-5573-45fa-a399-8f5115c1f4af	2026-03-11 20:16:42.066085+00	2026-03-11 20:16:42.066085+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	c64e92f7-6c4f-4ff3-9a77-f6db7d866d3f	2026-03-11 20:16:45.459197+00	2026-03-11 20:16:45.459197+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": false, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	08bea896-cd62-46bf-beb8-fa99137a4d8e	2026-03-11 20:16:43.149272+00	2026-03-11 20:16:43.149272+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": false, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	92102d7d-97d4-4e94-9353-e1901b7fe058	2026-03-11 20:16:49.391472+00	2026-03-11 20:16:49.391472+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	a07b556b-f11b-46b2-8c95-0ad01733e759	2026-03-11 20:24:59.839462+00	2026-03-11 20:24:59.839462+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	16237875-caf5-4307-82b9-fbf969106953	2026-03-11 20:25:11.46891+00	2026-03-11 20:25:11.46891+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": false, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	9c437a31-ecc9-45f0-bb21-06506c3fb7aa	2026-03-11 20:25:36.666682+00	2026-03-11 20:25:36.666682+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "f37b379f-1db3-4251-bc87-6084b8d43693"}	34ec3586-75ad-42f6-b004-651310c50109	2026-03-11 20:28:04.521704+00	2026-03-11 20:28:04.521704+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "33cc3464-58ff-4136-8b08-cd3f96e86a94"}	981f0527-c0fd-4ecb-86a3-e41947558e3e	2026-03-11 20:41:19.942533+00	2026-03-11 20:41:19.942533+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "62b7d665-1c27-4414-be98-cb83245a16a7"}	c2821566-98a0-4908-9bf2-cd66c21872d2	2026-03-11 20:41:31.634787+00	2026-03-11 20:41:31.634787+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "97b0b8b0-ca98-4c99-93c6-4641bfac4cc4"}	94ccc8ed-2d54-49d5-a1b0-99a2a5271f54	2026-03-11 20:41:35.655701+00	2026-03-11 20:41:35.655701+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	REPORT_DOWNLOADED	{"filters": {"date": "2026-03-10 01:14 PM"}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "report_type": "87f10f58-3dc6-4fa2-8b31-495e87070d14"}	9e7c2dee-8c70-4a05-9d57-713352cc38df	2026-03-11 20:41:41.669991+00	2026-03-11 20:41:41.669991+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "87f10f58-3dc6-4fa2-8b31-495e87070d14"}	ff213097-9c73-4688-b674-c47fc57647f7	2026-03-11 20:41:43.572058+00	2026-03-11 20:41:43.572058+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "d99a26c5-a09d-48af-94f1-757ddf5afc21"}	d6e1bda5-9874-4a8e-a974-7c3f9e202d6f	2026-03-11 20:41:50.514697+00	2026-03-11 20:41:50.514697+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "dde8271e-d4fd-4a8c-bd2d-b428747e3e35"}	f281c1a9-351f-40eb-a6fb-1193d5d1ef3f	2026-03-11 20:42:17.714226+00	2026-03-11 20:42:17.714226+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": false, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "07a5b57f-9781-4d4a-9a53-c1ccc7437624"}	ad2f4bc8-197e-465f-9cdf-0e25150f1db2	2026-03-11 20:52:44.640478+00	2026-03-11 20:52:44.640478+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_FALSE_POSITIVE_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "07a5b57f-9781-4d4a-9a53-c1ccc7437624"}	7781f7fe-5ca6-4191-ba2a-560ece9e6be0	2026-03-11 20:52:51.548417+00	2026-03-11 20:52:51.548417+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_FALSE_POSITIVE_TOGGLED	{"new_value": false, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "07a5b57f-9781-4d4a-9a53-c1ccc7437624"}	6bdd18d3-bb44-4f47-ba48-c14000f0d243	2026-03-11 20:52:56.284152+00	2026-03-11 20:52:56.284152+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "07a5b57f-9781-4d4a-9a53-c1ccc7437624"}	8636f849-b4a8-409c-9fae-40d237bd3b5d	2026-03-11 20:52:56.78618+00	2026-03-11 20:52:56.78618+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	c976b78d-9d3e-48f1-9bb7-ed8588e3b8b1	2026-03-11 20:55:41.979275+00	2026-03-11 20:55:41.979275+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	REPORT_DOWNLOADED	{"filters": {"date": "2026-03-10 09:50 PM"}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "report_type": "8afce279-a753-468c-8eb9-72820082565d"}	7483cae9-c809-43c5-b4db-8ef9d2e5a6a7	2026-03-11 21:02:02.798222+00	2026-03-11 21:02:02.798222+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	5bbdf029-165e-4d21-b5b3-2ad267c5d967	2026-03-11 21:29:59.076964+00	2026-03-11 21:29:59.076964+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	b44315d6-8255-43ec-9381-2b4ef43c159d	2026-03-11 22:17:42.832236+00	2026-03-11 22:17:42.832236+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	67a15838-9d61-4756-8bd6-a0d10551830d	2026-03-11 22:30:44.551506+00	2026-03-11 22:30:44.551506+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_DETAILS_UPDATED	{"changes": {"phone_number": {"new": "03001234567", "old": null}}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "target_user_id": "6a539e99-e9e3-4018-990d-afe74d9bf87c", "target_user_name": "Fatima Obaid", "target_user_email": "probasit03@gmail.com"}	2eb3a390-dc6d-4ce0-ad58-975705765399	2026-03-11 22:31:19.555093+00	2026-03-11 22:31:19.555093+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_DETAILS_UPDATED	{"changes": {"username": {"new": "Basit Rizzler", "old": "Fatima Obaid"}}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "target_user_id": "6a539e99-e9e3-4018-990d-afe74d9bf87c", "target_user_name": "Basit Rizzler", "target_user_email": "probasit03@gmail.com"}	e0f41bf2-8370-486d-b6d4-320129fb3f76	2026-03-11 22:41:02.351189+00	2026-03-11 22:41:02.351189+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_REMOVED	{"actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "target_user_name": "Basit Rizzler", "target_user_role": "Supervisor", "target_user_email": "probasit03@gmail.com"}	63f5a0c0-88ae-4433-894b-7f353b0000df	2026-03-11 22:41:15.678801+00	2026-03-11 22:41:15.678801+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_ADDED	{"actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "target_user_name": "Shahzeb Khalid", "target_user_role": "Supervisor", "target_user_email": "shahzebkhalid97@gmail.com"}	cb147c65-dad8-4fe3-84e7-a4f29d08455d	2026-03-11 22:47:14.711877+00	2026-03-11 22:47:14.711877+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_DETAILS_UPDATED	{"changes": {"username": {"new": "Shahzeb Khalid Nigga", "old": "Shahzeb Khalid"}}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "target_user_id": "f27f88ef-3fe5-4ec7-821e-16a2a39684aa", "target_user_name": "Shahzeb Khalid Nigga", "target_user_email": "shahzebkhalid97@gmail.com"}	ee5e0a77-edda-4f5f-b145-c11a74507cc9	2026-03-11 22:47:38.712849+00	2026-03-11 22:47:38.712849+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	f9a361d9-3a9b-471b-9e1a-7c86cb119c58	2026-03-11 22:51:45.53658+00	2026-03-11 22:51:45.53658+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_DETAILS_UPDATED	{"changes": {"username": {"new": "Shahzeb Khalid Gujjar", "old": "Shahzeb Khalid Nigga"}}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "target_user_id": "f27f88ef-3fe5-4ec7-821e-16a2a39684aa", "target_user_name": "Shahzeb Khalid Gujjar", "target_user_email": "shahzebkhalid97@gmail.com"}	712c3117-a0d2-419d-a004-1a33e2ca5679	2026-03-11 23:10:16.677023+00	2026-03-11 23:10:16.677023+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	df1b696c-cc40-4eae-9fc4-63fcb97eb78c	2026-03-11 23:22:12.577405+00	2026-03-11 23:22:12.577405+00
7875e357-338b-4df7-b49c-1b61f4146130	19dccfa7-9d6b-4a1e-ad11-45638d792237	USER_LOGIN	{"method": "standard", "actor_name": "taha", "actor_email": "fa22-bse-148@cuilahore.edu.pk"}	f5f7f05e-c71a-4e18-ae7d-b1191158243e	2026-03-12 12:37:25.929219+00	2026-03-12 12:37:25.929219+00
7875e357-338b-4df7-b49c-1b61f4146130	19dccfa7-9d6b-4a1e-ad11-45638d792237	USER_LOGIN	{"method": "standard", "actor_name": "taha", "actor_email": "fa22-bse-148@cuilahore.edu.pk"}	0423ea45-be06-4f01-8a20-813c69ddb6a2	2026-03-12 19:02:28.509515+00	2026-03-12 19:02:28.509515+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	e90b06ec-62e4-407d-9e06-e40f53ea9ee6	2026-03-12 19:02:45.632945+00	2026-03-12 19:02:45.632945+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	\N	USER_LOGIN	{"method": "standard", "actor_name": "Shahzeb Khalid Gujjar", "actor_email": "shahzebkhalid97@gmail.com"}	f8367e41-d625-41e0-a17a-ee235231de31	2026-03-11 23:22:47.338638+00	2026-03-11 23:22:47.338638+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_REMOVED	{"actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "target_user_name": "Shahzeb Khalid Gujjar", "target_user_role": "Supervisor", "target_user_email": "shahzebkhalid97@gmail.com"}	3ae92398-4aac-4391-a0e4-248d20f4070b	2026-03-12 19:02:53.235988+00	2026-03-12 19:02:53.235988+00
2d295439-b7ee-404c-a771-b2920291e907	b1ac6bc9-6e98-4a86-8a10-62def124a85a	USER_LOGIN	{"method": "standard", "actor_name": "Shahzeb Khalid", "actor_email": "shahzebkhalid97@gmail.com"}	33456412-fcbc-4f8f-a1b6-fc8f01992bf5	2026-03-12 19:03:38.385506+00	2026-03-12 19:03:38.385506+00
7875e357-338b-4df7-b49c-1b61f4146130	19dccfa7-9d6b-4a1e-ad11-45638d792237	USER_LOGIN	{"method": "standard", "actor_name": "taha", "actor_email": "fa22-bse-148@cuilahore.edu.pk"}	d49bf5aa-138d-402d-8f42-7eb88b635969	2026-03-13 12:54:29.096686+00	2026-03-13 12:54:29.096686+00
7875e357-338b-4df7-b49c-1b61f4146130	19dccfa7-9d6b-4a1e-ad11-45638d792237	CAMERA_CONFIGURED	{"changes": {"active_rules": {"new": {"person": {"required": true, "severity": "Critical"}}, "old": {}}}, "camera_id": "efb394b2-b2c9-4f9f-8d5a-451fcb176416", "actor_name": "taha", "actor_email": "fa22-bse-148@cuilahore.edu.pk", "camera_name": "My Webcam"}	b9bce854-7f59-4a51-b081-8d80d8a6edc4	2026-03-13 12:56:37.849537+00	2026-03-13 12:56:37.849537+00
7875e357-338b-4df7-b49c-1b61f4146130	19dccfa7-9d6b-4a1e-ad11-45638d792237	USER_LOGIN	{"method": "standard", "actor_name": "taha", "actor_email": "fa22-bse-148@cuilahore.edu.pk"}	9984bf26-7bcf-4a96-83ed-0097aae42a05	2026-03-13 14:04:29.903025+00	2026-03-13 14:04:29.903025+00
7875e357-338b-4df7-b49c-1b61f4146130	19dccfa7-9d6b-4a1e-ad11-45638d792237	USER_LOGIN	{"method": "standard", "actor_name": "taha", "actor_email": "fa22-bse-148@cuilahore.edu.pk"}	b7635d94-eae5-400a-a6ae-156dbba46f30	2026-03-13 14:05:01.212653+00	2026-03-13 14:05:01.212653+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	961c7876-4dfc-44d6-8e72-06588867c113	2026-03-13 14:05:09.245093+00	2026-03-13 14:05:09.245093+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	35e9ed21-44e5-42a6-a762-fa4acf03bc28	2026-03-15 16:34:59.29536+00	2026-03-15 16:34:59.29536+00
7875e357-338b-4df7-b49c-1b61f4146130	19dccfa7-9d6b-4a1e-ad11-45638d792237	USER_LOGIN	{"method": "standard", "actor_name": "taha", "actor_email": "fa22-bse-148@cuilahore.edu.pk"}	f1faaefe-2cbc-4fef-b5d3-785daf56deb5	2026-03-15 16:35:26.357208+00	2026-03-15 16:35:26.357208+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	97230daf-fb49-41e5-b248-bb821abff039	2026-03-15 16:35:47.420758+00	2026-03-15 16:35:47.420758+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	af661357-f9a9-4af8-9c71-ca7f9fa594b7	2026-03-15 20:30:30.207957+00	2026-03-15 20:30:30.207957+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	d1e64ec9-2b75-42aa-9d29-7d19429c4003	2026-03-16 14:44:58.024032+00	2026-03-16 14:44:58.024032+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	7515a5c5-ce7b-44c6-83b4-f0cf244f992f	2026-03-16 18:32:56.038888+00	2026-03-16 18:32:56.038888+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	ff53ad50-ab49-4ffb-8b44-5d6b12932318	2026-03-16 19:53:50.975372+00	2026-03-16 19:53:50.975372+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	453cf9b7-ce7e-4476-b095-c04ebf117e2b	2026-03-16 20:26:33.09926+00	2026-03-16 20:26:33.09926+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	fe67966f-6a4c-405a-a0f4-30bf00ce51d0	2026-03-16 21:18:53.472562+00	2026-03-16 21:18:53.472562+00
7875e357-338b-4df7-b49c-1b61f4146130	19dccfa7-9d6b-4a1e-ad11-45638d792237	USER_LOGIN	{"method": "standard", "actor_name": "taha", "actor_email": "fa22-bse-148@cuilahore.edu.pk"}	d6c11c09-0e1d-4305-b694-261a92a524e2	2026-03-16 21:19:12.57838+00	2026-03-16 21:19:12.57838+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	8fc52bb7-4718-47fe-bf3f-223502227241	2026-03-16 21:26:20.27623+00	2026-03-16 21:26:20.27623+00
7875e357-338b-4df7-b49c-1b61f4146130	19dccfa7-9d6b-4a1e-ad11-45638d792237	USER_LOGIN	{"method": "standard", "actor_name": "taha", "actor_email": "fa22-bse-148@cuilahore.edu.pk"}	038b2c2e-20fb-41f9-b3b9-589c2e34cc5f	2026-03-16 21:27:21.822337+00	2026-03-16 21:27:21.822337+00
7875e357-338b-4df7-b49c-1b61f4146130	19dccfa7-9d6b-4a1e-ad11-45638d792237	USER_LOGIN	{"method": "standard", "actor_name": "taha", "actor_email": "fa22-bse-148@cuilahore.edu.pk"}	c49474ab-e9a0-4a78-8ef0-38c70e7dedf8	2026-03-16 21:30:51.401732+00	2026-03-16 21:30:51.401732+00
7875e357-338b-4df7-b49c-1b61f4146130	19dccfa7-9d6b-4a1e-ad11-45638d792237	USER_LOGIN	{"method": "standard", "actor_name": "taha", "actor_email": "fa22-bse-148@cuilahore.edu.pk"}	340c338c-9118-44c2-8971-3cdf8689ce68	2026-04-30 11:43:12.210215+00	2026-04-30 11:43:12.210215+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	884f4a59-4d13-45cc-a52d-e0b2b588d17a	2026-04-30 11:43:32.295444+00	2026-04-30 11:43:32.295444+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_RESOLVED_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "ed416b52-45d6-403b-9f61-285391821d6e"}	d04fd441-6ad7-45d2-b35a-70ef11465b81	2026-04-30 11:55:04.481555+00	2026-04-30 11:55:04.481555+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_FALSE_POSITIVE_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "ed416b52-45d6-403b-9f61-285391821d6e"}	3395354a-0eb5-4c1a-84ca-67cf0cd0b649	2026-04-30 11:55:42.7315+00	2026-04-30 11:55:42.7315+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	REPORT_DOWNLOADED	{"filters": {"date": "2026-04-25 11:01 PM"}, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "report_type": "ed416b52-45d6-403b-9f61-285391821d6e"}	131584f4-c057-43bb-b4f2-98710e72fbfb	2026-04-30 11:56:22.654784+00	2026-04-30 11:56:22.654784+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "2fa", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	6bd46f7d-532c-46ee-9e4c-0936c267bef2	2026-04-30 12:11:23.295915+00	2026-04-30 12:11:23.295915+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	a70d36d0-5b73-4c11-aee9-4ef259cc6e8b	2026-05-01 11:45:12.220106+00	2026-05-01 11:45:12.220106+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	VIOLATION_FALSE_POSITIVE_TOGGLED	{"new_value": true, "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com", "violation_id": "027e2c5d-0582-469c-9ad0-74f74a7e1d68"}	ed6634ad-05f4-445c-b470-bcd5f4f35445	2026-05-01 11:49:30.718068+00	2026-05-01 11:49:30.718068+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	33f489fe-39b8-47f5-8203-5e411425a3f8	2026-05-02 13:25:49.595769+00	2026-05-02 13:25:49.595769+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bca947c9-cf84-45db-ab9b-28937ad70dd8	USER_LOGIN	{"method": "standard", "actor_name": "Malik Abdul Basit", "actor_email": "malikabdulbasit03@gmail.com"}	182d021a-1cb4-4206-9522-c4838c201171	2026-05-02 14:05:21.259519+00	2026-05-02 14:05:21.259519+00
\.


--
-- Data for Name: camera_rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.camera_rules (camera_id, is_active, active_rules, detection_zones, violation_cooldown_sec, id, created_at, updated_at) FROM stdin;
c1d7603c-4498-46d7-9fd2-071f48578e17	t	{"smoking": {"required": true, "severity": "High"}, "no_gloves": {"required": true, "severity": "High"}, "no_medical_coat": {"required": true, "severity": "High"}}	\N	60	826c0207-511c-4d90-8f72-b02485bdf36d	2026-01-30 17:46:53.343632+00	2026-03-11 18:46:36.799964+00
550d705a-de12-4566-afcd-b6290bdd6efd	t	{"smoking": {"required": true, "severity": "High"}, "no_gloves": {"required": true, "severity": "High"}, "no_medical_coat": {"required": true, "severity": "High"}}	\N	60	0223e251-8567-436f-846c-ec13c7da261e	2026-01-30 17:46:53.343632+00	2026-03-11 18:46:42.022365+00
c9d0dff8-33e5-436c-9f8c-c9986fb49be0	t	{"no_medical_coat": {"required": true, "severity": "High"}}	\N	60	d2610b27-3911-4316-bfd4-55c8f41521a0	2026-01-30 17:46:53.343632+00	2026-03-11 18:46:49.167917+00
f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	t	{"no_gloves": {"required": true, "severity": "High"}, "no_medical_coat": {"required": true, "severity": "High"}}	\N	60	c8a50cd4-586b-4862-8aa9-709bcd1bc7a3	2026-01-30 17:46:53.343632+00	2026-03-11 18:46:54.321383+00
6aa9be75-a251-446f-8503-45fac97be873	t	{"no_mask": {"required": true, "severity": "High"}, "no_gloves": {"required": true, "severity": "Critical"}}	\N	60	b075e675-470c-4135-9197-635d3c5b8d02	2026-01-30 17:46:53.343632+00	2026-02-24 19:33:12.993017+00
efb394b2-b2c9-4f9f-8d5a-451fcb176416	t	{"person": {"required": true, "severity": "Critical"}}	\N	60	d0a2b40f-d304-44e7-ad9d-4aa02d5c78e9	2026-03-13 12:56:00.84971+00	2026-03-13 12:56:37.780573+00
2bac1b7d-b5c2-438e-94ff-94f36b84ed22	t	{}	\N	60	b4e40a04-88be-453e-adfe-339b9d89265b	2026-03-15 17:41:02.785154+00	2026-03-15 17:41:02.785154+00
d4d0ce1c-28e7-4e35-a8d2-334d6fe841f3	t	{}	\N	60	90bf5c74-ffe7-46f2-8f60-e52c30a6c67f	2026-03-15 18:25:20.357038+00	2026-03-15 18:25:20.357038+00
5af0abd4-ee8d-44f4-aca1-3a4846ff74e4	t	{"person": {"required": true, "severity": "High"}}	\N	60	0f4328f5-d969-4b2a-a8e6-302c76d884a6	2026-02-24 21:17:52.564641+00	2026-03-07 09:13:16.740081+00
67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	t	{"no_cap": {"required": true, "severity": "Low"}, "no_mask": {"required": true, "severity": "Low"}}	\N	60	d5cfbd49-910c-4921-ae0a-2dc777dd4756	2026-01-30 17:46:53.343632+00	2026-03-10 19:18:34.541605+00
f94b3d22-74e9-4c0f-9d66-15816ba4bf28	t	{"no_cap": {"required": true, "severity": "High"}, "no_mask": {"required": true, "severity": "High"}, "smoking": {"required": true, "severity": "High"}, "no_gloves": {"required": true, "severity": "High"}}	\N	60	ab0882ae-e3c0-4441-b761-85431d69b618	2026-01-30 17:46:53.343632+00	2026-03-11 18:46:13.877784+00
19f09d60-c541-480a-87ce-64758b2ccb88	t	{"no_cap": {"required": true, "severity": "High"}, "no_mask": {"required": true, "severity": "High"}, "smoking": {"required": true, "severity": "High"}}	\N	60	84452bdb-cc6f-4785-9b07-312fc57f7b47	2026-01-30 17:46:53.343632+00	2026-03-11 18:46:21.146625+00
5f3f0032-5b28-4b50-8e1f-e72d0b41f641	t	{"no_cap": {"required": true, "severity": "High"}, "no_gloves": {"required": true, "severity": "High"}, "no_medical_coat": {"required": true, "severity": "High"}}	\N	60	465b2d10-37ee-479f-ab76-7958168b0467	2026-01-30 17:46:53.343632+00	2026-03-11 18:46:26.558057+00
7641b663-6d92-48a1-89d9-1e922e5ad73a	t	{"smoking": {"required": true, "severity": "High"}, "no_gloves": {"required": true, "severity": "High"}, "no_medical_coat": {"required": true, "severity": "High"}}	\N	60	14a7d0e0-7f03-443f-b054-92482ea1bd71	2026-01-30 17:46:53.343632+00	2026-03-11 18:46:31.665275+00
\.


--
-- Data for Name: cameras; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cameras (organization_id, device_id, name, rtsp_url, local_timezone, status, location, id, created_at, updated_at) FROM stdin;
16f28877-4fc0-467e-98f9-d4dfb7acafc2	a97f0233-f49c-4390-b460-e6b1e66967dd	Surgical-Cam-01	rtsp://192.168.1.64/stream	UTC	Online	Surgical Ward	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	a97f0233-f49c-4390-b460-e6b1e66967dd	Surgical-Cam-02	rtsp://192.168.1.79/stream	UTC	Online	Surgical Ward	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	a97f0233-f49c-4390-b460-e6b1e66967dd	Medicine-Cam-01	rtsp://192.168.1.98/stream	UTC	Online	Medicine Storage	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	a97f0233-f49c-4390-b460-e6b1e66967dd	Medicine-Cam-02	rtsp://192.168.1.61/stream	UTC	Online	Medicine Storage	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	a97f0233-f49c-4390-b460-e6b1e66967dd	Staff-Cam-01	rtsp://192.168.1.50/stream	UTC	Online	Staff Cafeteria	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	a97f0233-f49c-4390-b460-e6b1e66967dd	Staff-Cam-02	rtsp://192.168.1.20/stream	UTC	Online	Staff Cafeteria	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
2622624a-ee97-4b4f-be18-48653e70aca4	091b09da-d72a-42a8-ac89-a0ea5782aaed	Testing Webcam	http://local.webcam/0	UTC	Online	Testing Webcam	5af0abd4-ee8d-44f4-aca1-3a4846ff74e4	2026-02-24 21:17:52.564641+00	2026-02-24 21:17:52.564641+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	a97f0233-f49c-4390-b460-e6b1e66967dd	Admin Cam 01	rtsp://192.168.1.69/stream	UTC	Online	Admin Room	6aa9be75-a251-446f-8503-45fac97be873	2026-01-30 17:46:53.343632+00	2026-03-10 19:17:11.438665+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	a97f0233-f49c-4390-b460-e6b1e66967dd	Admin Cam 02	rtsp://192.168.1.17/stream	UTC	Online	Admin Room	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-30 17:46:53.343632+00	2026-03-10 19:17:28.700355+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	a97f0233-f49c-4390-b460-e6b1e66967dd	Parking Cam 02	rtsp://192.168.1.55/stream	UTC	Online	Parking	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-30 17:46:53.343632+00	2026-03-11 18:47:27.035032+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	a97f0233-f49c-4390-b460-e6b1e66967dd	Parking Cam 01	rtsp://192.168.1.70/stream	UTC	Online	Parking	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-30 17:46:53.343632+00	2026-03-11 18:47:49.400069+00
7875e357-338b-4df7-b49c-1b61f4146130	27926433-1418-448b-b584-4093a3365582	My Webcam	0	UTC	Online	My Webcam	efb394b2-b2c9-4f9f-8d5a-451fcb176416	2026-03-13 12:56:00.84971+00	2026-03-13 12:56:00.84971+00
2622624a-ee97-4b4f-be18-48653e70aca4	091b09da-d72a-42a8-ac89-a0ea5782aaed	My Webcam	0	UTC	Online	My Webcam	2bac1b7d-b5c2-438e-94ff-94f36b84ed22	2026-03-15 17:41:02.785154+00	2026-03-15 17:41:02.785154+00
2622624a-ee97-4b4f-be18-48653e70aca4	091b09da-d72a-42a8-ac89-a0ea5782aaed	Iriun Webcam	usb://ROOT\\CAMERA\\0000	UTC	Online	Iriun Webcam	d4d0ce1c-28e7-4e35-a8d2-334d6fe841f3	2026-03-15 18:25:20.357038+00	2026-03-15 18:25:20.357038+00
\.


--
-- Data for Name: devices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.devices (organization_id, name, status, device_token_secret, last_heartbeat, id, created_at, updated_at, subscription_active) FROM stdin;
16f28877-4fc0-467e-98f9-d4dfb7acafc2	Main-Hospital-Server	Online	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjIwODg3MDIxOTMsInN1YiI6ImU2ZjQ3N2IwLWU1ODAtNDcwYS1iMDY2LWQ5OWM2ZGEyOTc5NiIsInR5cGUiOiJkZXZpY2UifQ.OGOsb4VUgTJNUp6qF9IeTfvYLIPZLmNe2-viXwzjBa9	2026-05-03 14:54:25.762185+00	a97f0233-f49c-4390-b460-e6b1e66967dd	2026-01-30 17:46:53.343632+00	2026-05-03 14:54:25.762185+00	t
2622624a-ee97-4b4f-be18-48653e70aca4	DESKTOP-BUVI5UD	Offline	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjIwODcwNjYzNDksInN1YiI6IjA5MWIwOWRhLWQ3MmEtNDJhOC1hYzg5LWEwZWE1NzgyYWFlZCIsInR5cGUiOiJkZXZpY2UifQ.I2RNZGpJxe7Bqx-RpaYmKqiRRwBUyYXe39a2_jMXF7w	2026-03-20 11:59:47.431556+00	091b09da-d72a-42a8-ac89-a0ea5782aaed	2026-02-21 20:39:08.598509+00	2026-03-20 11:59:47.431556+00	t
7875e357-338b-4df7-b49c-1b61f4146130	DESKTOP-BUVI5UD	Offline	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjIwODg2NzcwNzgsInN1YiI6IjI3OTI2NDMzLTE0MTgtNDQ4Yi1iNTg0LTQwOTNhMzM2NTU4MiIsInR5cGUiOiJkZXZpY2UifQ._0yag2WAz62FePaDlBVR97UOXa-MT5YnJsmGtBVXixA	2026-03-13 15:15:08.146996+00	27926433-1418-448b-b584-4093a3365582	2026-03-12 12:04:38.541993+00	2026-03-13 15:15:08.146996+00	t
2d295439-b7ee-404c-a771-b2920291e907	Edge Server 1	Offline	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjIwODg3MDIxOTMsInN1YiI6ImU2ZjQ3N2IwLWU1ODAtNDcwYS1iMDY2LWQ5OWM2ZGEyOTc5NiIsInR5cGUiOiJkZXZpY2UifQ.OGOsb4VUgTJNUp6qF9IeTfvYLIPZLmNe2-viXwzjBa8	2026-03-16 11:38:41.236278+00	e6f477b0-e580-470a-b066-d99c6da29796	2026-03-12 19:03:13.601857+00	2026-03-16 11:38:41.236278+00	t
\.


--
-- Data for Name: organization_capabilities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_capabilities (organization_id, object_code, display_name, is_ppe, id, created_at, updated_at) FROM stdin;
2622624a-ee97-4b4f-be18-48653e70aca4	airplane	Airplane	f	75825ce4-7a91-4057-96bc-b55f7f1a4b8a	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	bus	Bus	f	8455dc84-13e5-4c44-aa56-ade27023742e	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	train	Train	f	69b6733b-7490-4227-9d00-788c82a07ffc	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	truck	Truck	f	865cae67-4736-44c8-89f6-a23a10efc6c4	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	boat	Boat	f	b9777980-7c6b-406c-8f7e-3692258679da	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	traffic_light	Traffic Light	f	64234788-58d4-4a04-a9f3-098c3717e2bf	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	fire_hydrant	Fire Hydrant	f	f36d6432-3750-44b2-8dd0-8910d3c62cf7	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	stop_sign	Stop Sign	f	57a9582f-11ed-4b8e-aa31-abd56db69f3d	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	parking_meter	Parking Meter	f	f4784ad5-fca6-4f4f-b0e4-988353fc5eb3	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	bench	Bench	f	2dd91d46-041b-4e68-97b5-4bb833780f6b	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	bird	Bird	f	34d31065-4fa7-46f0-92e0-d48bc629574a	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	cat	Cat	f	6a58b8e0-05b0-4b5a-ad17-a265763278ef	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	dog	Dog	f	75557f4b-0dbc-46b6-a64c-de4da09847f3	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	horse	Horse	f	6e36055d-d72b-42b0-b4cf-95ddfb863e7f	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	sheep	Sheep	f	a0a64402-8d6a-4c10-96e4-31efcfdf483b	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	cow	Cow	f	2bcd9c63-5dc0-4208-a1a8-3786a11344c7	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	elephant	Elephant	f	cbdea513-10a1-48d1-969d-6ebea61ac543	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	bear	Bear	f	73678ba3-b213-4beb-82f0-c0488d0a10d2	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	zebra	Zebra	f	d29efbac-de88-417b-8f81-d4ab07fba3a8	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	giraffe	Giraffe	f	2ecf6d00-9893-4d11-aa38-0e4a493ec676	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	backpack	Backpack	f	faa438cd-ce39-480e-b531-d8d95518ee8b	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	umbrella	Umbrella	f	5c5acd48-6288-47b7-a852-f4c6d9419a62	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	handbag	Handbag	f	429bcc55-6eb6-4765-b311-8e2ceaf43ddc	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	tie	Tie	f	f40b6a1a-0654-42c4-97e4-26108cd466aa	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	suitcase	Suitcase	f	fd6eeb4f-2d31-4319-87f8-b14782e724cb	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	frisbee	Frisbee	f	0ee3355b-d7f2-45e3-a0df-e1b1a8273d33	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	skis	Skis	f	dd37a28f-bbb5-477c-a998-6d74ecaebef0	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	snowboard	Snowboard	f	7c20cee6-57fc-4583-bef7-309d6e610b9d	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	sports_ball	Sports Ball	f	e26c48c1-939d-4a98-bd00-faa008c118a6	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	kite	Kite	f	0bcc4ad2-f45b-4b5e-a368-54ff43715ff2	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	baseball_bat	Baseball Bat	f	fac84fbc-324a-4514-ab76-74a6280c7cf7	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	baseball_glove	Baseball Glove	t	e49c51fb-334e-4d9e-bdf0-1e551bee5cc8	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	skateboard	Skateboard	f	21e537e8-dd78-4fe8-9bd6-a13cefc2cd4b	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	surfboard	Surfboard	f	62779011-f8ff-4fa0-814d-90d589eef0e2	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	tennis_racket	Tennis Racket	f	26008ad9-12da-4032-866a-0b3110d3672e	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	bottle	Bottle	f	1b687556-d642-488d-a6a7-c9ea1aeec4ca	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	wine_glass	Wine Glass	f	641f7c27-c4b4-4fa3-b750-df133d1c8591	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	cup	Cup	f	4330a028-6fdb-490f-a4e2-e06e52ca84be	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	fork	Fork	f	b9b5df7b-bfa1-410a-bbc3-3f95ea2b3960	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	knife	Knife	f	3362be5f-0958-4c73-a8bc-00029ae10c32	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	spoon	Spoon	f	5de2b2d8-98ab-4298-8858-c8ca21677b6a	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	bowl	Bowl	f	c8383042-328e-41fb-b80e-9847bb78d830	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	banana	Banana	f	f400a84a-91ef-4056-807d-141c95bb5c7d	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	apple	Apple	f	07b61a9d-1190-40ce-bfbd-97981f94863c	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	sandwich	Sandwich	f	0a95b323-6b86-45d8-b422-1b17f91adb05	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	orange	Orange	f	c1dedec8-e7e7-444a-9c4e-434531ec34be	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	broccoli	Broccoli	f	d60f3a29-db6b-4596-b23d-16506af5e869	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	carrot	Carrot	f	562895f6-1c89-468e-bd3a-9243707e14ed	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	hot_dog	Hot Dog	f	4a55818d-8ba4-40cf-90f8-9d3d89a1c939	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	pizza	Pizza	f	de288dbd-ce9d-4c46-9c6d-ba5c25f8ecdd	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	donut	Donut	f	dda8bd45-6f19-441f-ac58-e84d04ed7601	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	cake	Cake	f	7e353124-b935-4120-ab17-fb63e4d344b1	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	chair	Chair	f	adc0789d-073b-4a3e-a6f6-c4721e3120db	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	couch	Couch	f	de6db6c5-5b72-422c-a5d9-157ec11fe48c	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	potted_plant	Potted Plant	f	9f316013-6d34-4f88-a17c-c944d00db14a	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	bed	Bed	f	9dd38844-df47-4364-a7b1-f1ccc6b1ac87	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	dining_table	Dining Table	f	41790f70-db3f-4b6a-b89b-5b8e1dd0a1a0	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	toilet	Toilet	f	8d3188fe-a6ec-45ab-894b-642b3c536003	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	tv	Tv	f	5fe3c632-f473-4d52-bd97-fa749e5f9117	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	laptop	Laptop	f	0f4eac08-367b-4554-9826-1147ac8052c1	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	mouse	Mouse	f	3a8c2436-ff35-4f89-b056-fe48eb61bbb5	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	remote	Remote	f	ad5839a8-8511-47e3-8aea-e3a2ba0b3e6f	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	keyboard	Keyboard	f	859c0f7e-a59e-496b-b056-f6aff823a166	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	cell_phone	Cell Phone	f	ec4eb760-96b6-4ad0-a75d-bd01ca92f9e9	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	microwave	Microwave	f	bc51c87e-dfa3-4228-83cc-c77d604ece0a	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	oven	Oven	f	114954e6-ed3d-4122-b699-9263637877cb	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	toaster	Toaster	f	6bcc7e64-fb89-44a0-a8fe-111ae7dbc194	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	sink	Sink	f	32983cc1-7eb3-44f3-8d53-dba657ea7312	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	refrigerator	Refrigerator	f	62eab018-8294-4891-b6e7-594ec92d4c21	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	book	Book	f	04aa1dd5-1f02-4822-a01e-b677bb6a7f1e	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	clock	Clock	f	87c46a26-dfe0-4b3e-817e-511f83c69419	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	vase	Vase	f	71566fbb-b783-4e97-81fe-f382e0d0e2e2	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	scissors	Scissors	f	c699db3b-358d-4079-afdf-ffe574c8b218	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	teddy_bear	Teddy Bear	f	731d025b-6a1a-4bcd-a08c-dd64d27ed5dc	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	hair_drier	Hair Drier	f	93d32a2c-c5d8-4152-818d-ec98ab0c29be	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	toothbrush	Toothbrush	f	aa46822f-1720-4a66-8337-a34a2d8548e3	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
7875e357-338b-4df7-b49c-1b61f4146130	person	Person	f	e7d74062-8ffa-41a8-95af-a6bb964ad6b3	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	bicycle	Bicycle	f	be9c9c79-dde5-4b9e-93c8-58e412c64389	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	car	Car	f	0ec3fc86-2b6d-4ea8-a3e5-b2385f063277	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
2622624a-ee97-4b4f-be18-48653e70aca4	person	Person	f	1b7371c5-791f-4ebc-8944-1d78eb1e9cfa	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
7875e357-338b-4df7-b49c-1b61f4146130	motorcycle	Motorcycle	f	b09394a9-1229-46f6-906b-e0a1a28747d9	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	airplane	Airplane	f	c1ea73c8-dcae-419c-9df5-bf2a4a4765ac	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	bus	Bus	f	954a0ae2-57f9-45ea-8881-7b5414216f28	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	train	Train	f	e481c222-38ed-4de3-8417-f61be6911b9c	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	truck	Truck	f	9dd41e73-349c-4650-9473-dec8718a48a8	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	boat	Boat	f	4ec4c599-4edc-4897-98bf-320d44cb338c	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	traffic_light	Traffic Light	f	29d556cc-2ef7-4f1c-be9a-2823c714006a	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	fire_hydrant	Fire Hydrant	f	eaa09280-17f5-47bc-86d6-be1dd57223a9	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	stop_sign	Stop Sign	f	f85cec16-959f-4114-8bf9-9b180f083031	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	parking_meter	Parking Meter	f	4a086a5e-b6d3-40c5-8775-0329ffdc74f1	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	bench	Bench	f	cb76f0b7-7e96-407b-bb99-c79da035b6b6	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	bird	Bird	f	d0e5e31a-e4c4-4fba-9d03-8fd898b41f01	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	cat	Cat	f	bc493fbe-ec86-4c2f-b5c8-d4d2ece59bb2	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	dog	Dog	f	034a40bf-7a29-42c5-8a89-66548142a20e	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	horse	Horse	f	6be2886b-49ed-41bd-b3fa-f88f2c0ee3e8	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	sheep	Sheep	f	02d19402-59b1-4da4-a69c-f4b974cf9923	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	cow	Cow	f	8f34f894-c496-40d8-abb7-4b0e8cadd2e7	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	elephant	Elephant	f	354b011d-8108-493d-bc4f-17884e15fc6f	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	bear	Bear	f	c5fd88dc-9e05-42c7-b169-ff0caa63db50	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	zebra	Zebra	f	220dd987-e1f1-46b9-9a0d-c948f9b12ffa	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	giraffe	Giraffe	f	a0809f28-74f8-4431-82bc-1b59b00ef5f4	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	backpack	Backpack	f	f3cc09cc-c5f8-4baa-a394-a7dcad04f187	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	umbrella	Umbrella	f	bc843865-86c2-4cdd-afbf-72f92d43ea2e	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	handbag	Handbag	f	6f74bb3d-d32d-4b48-9b68-c1bd50a72130	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	tie	Tie	f	594b027b-c601-440a-ba64-7fafc5405f43	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	suitcase	Suitcase	f	70894fa5-3eb8-446a-baf2-e5fd9b8d8513	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	frisbee	Frisbee	f	ecaa7597-907b-416e-b468-80a7e4b84f58	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	skis	Skis	f	28c3d462-3d39-4488-a81d-a89edde82d0f	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	snowboard	Snowboard	f	f10c8a00-29b0-48ad-9863-916c3d2aef7f	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	sports_ball	Sports Ball	f	74dc6616-79bc-4c23-8695-ad61c068bcda	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	kite	Kite	f	73c5ee2f-3983-4014-ba96-dc6123fbc677	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	baseball_bat	Baseball Bat	f	a8ccdad5-35fa-449d-ad34-4b5f35d5285a	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	baseball_glove	Baseball Glove	t	e57f15d2-736f-4159-866e-20227c93f6f4	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	skateboard	Skateboard	f	ede4ad9c-a0ac-4e8f-bbc3-8deb42dbfa62	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	surfboard	Surfboard	f	fd0359b2-4f02-450b-857f-d82aba1c679c	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	tennis_racket	Tennis Racket	f	70b4807a-37ba-4788-8b89-6afc0f7dff5e	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	bottle	Bottle	f	943f131f-69f4-4ddf-bd4a-490934febfaf	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	wine_glass	Wine Glass	f	dfe46601-2961-4969-8204-3ce703bc9f28	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	cup	Cup	f	5a848e05-cc42-497a-8bba-b200f89ed14c	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	fork	Fork	f	23a68d3e-dda0-4433-860f-c6f43c29f197	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	knife	Knife	f	33d33a51-2b71-4094-8d8e-e214a1230bcf	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	spoon	Spoon	f	731349a5-03b4-46f8-bfce-0d58f5dd60aa	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	bowl	Bowl	f	b5c83b86-c4a6-4eee-9e9d-c084a7d21f72	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	banana	Banana	f	0259df20-54f2-4077-b579-88747f81185d	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	apple	Apple	f	f48e911d-9399-4f35-932b-1c4783f10cf0	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	sandwich	Sandwich	f	e7ed78d3-846d-4c15-bf01-0defee3db978	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	orange	Orange	f	75785fd9-bc95-4988-81e3-3760292f82d1	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	broccoli	Broccoli	f	62a5b256-e4df-46a7-88d4-1b5093615ffc	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	carrot	Carrot	f	a2206da1-f72d-41aa-9b35-17ebc164072e	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	hot_dog	Hot Dog	f	44801769-5a8d-458b-8a36-f8d0bc7429dd	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	pizza	Pizza	f	ae9539dd-0400-4d0c-bbd9-391db8d77dc2	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	donut	Donut	f	a178e977-104a-4200-9910-9045cdd5bffc	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	cake	Cake	f	728d5128-90ac-4751-921f-50393c1a653c	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	chair	Chair	f	3f338d9e-b283-4e9e-b797-45e9b3dabce4	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	couch	Couch	f	f5b645f0-2464-45df-8e4b-71e3cc2ada47	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	potted_plant	Potted Plant	f	13b62eed-9279-4d96-8095-598abcb7b04b	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	bed	Bed	f	ffc3c890-7ec9-457e-902c-c489ed2cfccc	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	dining_table	Dining Table	f	38ee8faa-ec39-463e-87a3-8d9306c31613	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	toilet	Toilet	f	56ac71f3-87a5-43c2-bcd1-fd875b3b4934	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	tv	Tv	f	434de267-6e13-4052-b925-acdf87619e74	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	laptop	Laptop	f	f20f79ea-c484-42be-a10a-eedb95b32c18	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	mouse	Mouse	f	998b2fb7-4e24-42d0-8a5b-0d68cd172bc6	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	remote	Remote	f	4b96a752-d9d6-46d4-9232-3c446377d37f	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	keyboard	Keyboard	f	4aa24848-24e1-4cf6-b86c-208ccad75c80	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	cell_phone	Cell Phone	f	c90d77b0-46f0-45f7-b4db-e5da479abf4b	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	microwave	Microwave	f	1a88ab9e-6b3e-433e-a210-755b7400f472	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	oven	Oven	f	54a0f1fc-7c04-40a9-a5d5-def2316d9f47	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	toaster	Toaster	f	b22b5707-2c71-4ecd-89bf-cff91e0e36bd	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	sink	Sink	f	6e76be23-541a-4187-95c1-8ecf5c83fd46	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	refrigerator	Refrigerator	f	b266c0b4-2230-4e3a-9486-2b8050ec8b58	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	book	Book	f	a52db1c9-9eed-4efa-a0dc-059b39d7126d	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	clock	Clock	f	875a9128-df3a-44bb-855a-52190227c5ac	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	vase	Vase	f	23ed6854-38fe-45ef-b138-4a7db782c01e	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	scissors	Scissors	f	2ddb1c33-8d1c-47a5-bd76-89476e4594ad	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	teddy_bear	Teddy Bear	f	4bcb1467-5150-4be2-b192-3f25e241f5e1	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	hair_drier	Hair Drier	f	301700a5-7409-4c27-a1c8-97166d41a996	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
7875e357-338b-4df7-b49c-1b61f4146130	toothbrush	Toothbrush	f	6e02cd7e-fa83-43ec-8ba3-380eb4f829bc	2026-03-13 12:49:15.107999+00	2026-03-13 12:49:15.107999+00
2622624a-ee97-4b4f-be18-48653e70aca4	bicycle	Bicycle	f	e5a0e559-eab7-41ee-bc5c-474fd5d7a68e	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	car	Car	f	ecff77e6-a4df-475c-9348-3a79913c53ed	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
2622624a-ee97-4b4f-be18-48653e70aca4	motorcycle	Motorcycle	f	b6151992-8d6e-45a0-9d83-49e9a7a4c7e0	2026-03-12 19:31:04.123923+00	2026-03-12 19:31:04.123923+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bicycle	Bicycle	f	9760396d-a844-43e7-9a1e-f27ce96921b7	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	car	Car	f	08e73705-db62-4688-b748-3b0e6e3d8ea8	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	motorcycle	Motorcycle	f	cd4b0fac-a97f-408d-a280-39f3aabb467f	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bus	Bus	f	96e9fc1e-6f33-4a55-8d8a-cc9f5155e434	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	person	Person	t	69281476-70ec-4b45-a24f-125fff69a1b2	2026-03-19 17:50:18.325404+00	2026-03-20 12:20:48.004265+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	airplane	Airplane	t	04582755-946b-44dc-a232-82f611fb0f91	2026-03-19 17:50:18.325404+00	2026-03-20 13:08:50.534856+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	train	Train	f	83bcadee-0db7-4ee2-81db-1cf3d5a666ae	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	truck	Truck	f	3d9f7cf7-508b-4094-a5ff-235457fbc28b	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	boat	Boat	f	3bf99304-ee7b-4330-9cc7-2c1b3cc5dd3c	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	traffic_light	Traffic Light	f	b1414d02-a524-4a74-9a85-3bc49152b7ad	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	fire_hydrant	Fire Hydrant	f	4723c7bc-2971-4910-8b9e-df73f3df3956	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	stop_sign	Stop Sign	f	2043e3f7-5d3b-4f7d-92d3-c8545389ab5b	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	parking_meter	Parking Meter	f	b3b116d7-7d64-457f-bb8c-486d53b2018c	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bench	Bench	f	630f811b-7489-4060-8f38-a36a4e662433	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bird	Bird	f	f0986b9c-2e35-4732-a2ce-f9dbc995f1a1	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	cat	Cat	f	69b6e883-e76d-4eb8-ba14-949e69cbe281	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	sheep	Sheep	f	207a0cae-5d89-4f06-be93-646fc5c3a90a	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	cow	Cow	f	b88e6b8b-18cb-4bde-a9df-9b18ca208bcb	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	elephant	Elephant	f	f3d45d96-a95d-4654-b1c9-d833cdef8465	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bear	Bear	f	46f20616-ef18-4a38-82ca-3b1de4fe1b19	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	zebra	Zebra	f	4012de73-d49b-4caa-a19c-d56dacde5d2c	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	giraffe	Giraffe	f	2576fcf4-ac07-4598-a5af-80e9cfbd449a	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	backpack	Backpack	f	b7d156b0-ab97-4454-b06f-f04588882759	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	handbag	Handbag	f	d5d105f9-4472-4d0d-b517-8b6732a17e57	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	tie	Tie	f	5197384b-d845-47f0-97e9-7c25e2b5864d	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	suitcase	Suitcase	f	3d80d5d6-c3fe-49a4-92d5-e93903392c74	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	frisbee	Frisbee	f	8d21941a-07fe-4f6f-92c6-13b4e07a55bd	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	skis	Skis	f	8042162f-c398-4dde-a596-d410e0029b2a	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	snowboard	Snowboard	f	6e8d2261-30e8-4b2b-8719-7b75a0f0e7a1	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	sports_ball	Sports Ball	f	cb8eb2e8-8a88-4d25-827f-e8248a449ff5	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	kite	Kite	f	31245fff-c003-4ae8-be16-d5176a41842b	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	baseball_bat	Baseball Bat	f	816887b0-98b7-4f7b-8f5f-b430b460f538	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	skateboard	Skateboard	f	6805bd14-3766-43fd-9f2e-9d9249e5a811	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	surfboard	Surfboard	f	b0ad80e6-7374-4896-9173-e01cb5259153	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	tennis_racket	Tennis Racket	f	b0e168f8-00c9-4959-8bd2-1defe2f8661a	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bottle	Bottle	f	12d3871b-2af1-4ad5-9b7a-1824f5e81753	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	wine_glass	Wine Glass	f	ab0bc504-a4be-45fa-a787-be6c2875ba95	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	cup	Cup	f	766f89e6-77d3-4900-ad78-e623dd909121	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	fork	Fork	f	79182ba1-e0fc-4799-91c2-ba22506a6c07	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	spoon	Spoon	f	bd697eb7-8d4d-4fd1-ab14-43755da3dc41	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bowl	Bowl	f	38f7f700-fdeb-4fa4-80ef-cf837b629466	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	banana	Banana	f	450980ad-cf06-4303-8d2d-97d3ab8b0e70	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	apple	Apple	f	ee360e8c-c82a-4c8b-a46d-cbc387e73d3a	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	sandwich	Sandwich	f	b98c1396-3821-4399-b044-d39d0bdd7012	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	orange	Orange	f	3910ed69-5abb-4fc7-9afc-e5a74152b258	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	broccoli	Broccoli	f	c6c9cf78-6990-492c-bc3a-33249b879b05	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	carrot	Carrot	f	f5b64815-62f6-4bbf-bbe0-67b6abf0fbca	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	hot_dog	Hot Dog	f	4f579886-9667-4346-b067-1ae1e6d8b8e1	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	pizza	Pizza	f	4fadbebd-4159-4af1-adc1-b6d4f35863b8	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	donut	Donut	f	cd1969b2-b294-4062-980f-3828a2f5f539	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	cake	Cake	f	5997b1f4-1726-4266-9b6f-e55d858487fb	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	chair	Chair	f	2be0b400-1f1d-47f5-8a5d-dd828701c29b	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	couch	Couch	f	02a64ef5-a4ed-4937-94a2-26e3b8b10cd5	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	potted_plant	Potted Plant	f	78219ee1-83ee-4ff0-9094-aa104f6e04d0	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	bed	Bed	f	6b2ab6a6-c94d-41ef-90bf-1419a1810a8d	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	dining_table	Dining Table	f	c6bdd689-904d-4b4b-952e-2fdac55e94fa	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	toilet	Toilet	f	e2e6aafe-9858-4537-9d3e-ab28c2f1e68f	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	tv	Tv	f	255d17e1-e02d-4ccc-b244-14bfa6ff2674	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	laptop	Laptop	f	2afbc628-e85d-44da-a4cb-2d00dd8bcd58	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	mouse	Mouse	f	233fd911-f7a6-474b-bf39-166dc7011ff4	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	remote	Remote	f	48c3dcc1-a11a-470b-869f-a04516ea2770	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	keyboard	Keyboard	f	3a424a2d-356a-4c4e-8406-a882672dd906	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	cell_phone	Cell Phone	f	7eca37ed-1045-4e11-bdf5-00063794daf4	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	microwave	Microwave	f	485b4498-8d4d-4471-a8f3-fd65f3998677	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	oven	Oven	f	4507cd8f-da38-4fbb-8604-c19e85a0eecd	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	toaster	Toaster	f	c40e6b2d-cabb-4dca-a404-b1065f9541a7	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	sink	Sink	f	0f1eb712-ba04-411e-a714-9e03ab307d05	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	refrigerator	Refrigerator	f	c02a2424-58bc-4019-8401-f9d82f45334e	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	book	Book	f	547de62c-c4e1-447e-9f3b-d92965d95c75	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	clock	Clock	f	96e03396-8dcf-4eac-b540-d835904365e5	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	vase	Vase	f	7700445d-cf8c-4a99-b8b0-761ac10401f1	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	scissors	Scissors	f	582646a1-bace-480b-8c24-aa952bbf47ff	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	teddy_bear	Teddy Bear	f	917232fc-2ea9-4ad7-a3c8-cdd13df11f49	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	hair_drier	Hair Drier	f	f1d2b292-3748-4222-912f-5f9faeec24de	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	toothbrush	Toothbrush	f	8535189f-68e3-4efc-ab60-b537b323852e	2026-03-19 17:50:18.325404+00	2026-03-19 17:50:18.325404+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	dog	Dog	t	4a6b5bab-006a-4f2e-a0b5-91090a6a52dd	2026-03-19 17:50:18.325404+00	2026-03-20 12:19:47.078128+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	horse	Horse	t	def06c34-a02e-45d4-b23f-f43cb2f8d1d2	2026-03-19 17:50:18.325404+00	2026-03-20 12:19:53.285725+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	umbrella	Umbrella	t	f007861d-d682-4ee3-af67-708d36c80f25	2026-03-19 17:50:18.325404+00	2026-03-20 12:19:59.639757+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	knife	Knife	t	8ac22426-c82e-414d-abae-975847ce7b98	2026-03-19 17:50:18.325404+00	2026-03-20 12:20:13.803334+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	baseball_glove	Baseball Glove	t	d2534278-3223-4ecd-abe4-dfa7865b7a01	2026-03-19 17:50:18.325404+00	2026-03-20 12:20:58.009767+00
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organizations (name, status, api_key_public, id, created_at, updated_at) FROM stdin;
MediSafe Hospital	Active	\N	16f28877-4fc0-467e-98f9-d4dfb7acafc2	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
Nestle	Active	\N	2622624a-ee97-4b4f-be18-48653e70aca4	2026-02-21 20:39:08.598509+00	2026-02-21 20:39:08.598509+00
OBS PHarma	Active	\N	7875e357-338b-4df7-b49c-1b61f4146130	2026-03-12 12:04:38.541993+00	2026-03-12 12:04:38.541993+00
Bread and Beyond	Active	\N	2d295439-b7ee-404c-a771-b2920291e907	2026-03-12 19:03:13.601857+00	2026-03-12 19:03:13.601857+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (organization_id, username, email, password_hash, role, is_active, phone_number, is_2fa_enabled, otp_hash, otp_expires_at, id, created_at, updated_at) FROM stdin;
2622624a-ee97-4b4f-be18-48653e70aca4	Obaid Ullah Malik	mtahamalik06@gmail.com	$2b$12$ekBVkV32TA7KaS.lYroqhuyVlw0n.j63uafCGuRva0Oj/1KhXlVbe	GlobalAdmin	t		f	\N	\N	89e98f0a-ee0c-4f95-b03a-bf5072e0f509	2026-02-21 20:39:08.598509+00	2026-03-03 18:31:28.580542+00
7875e357-338b-4df7-b49c-1b61f4146130	taha	fa22-bse-148@cuilahore.edu.pk	$2b$12$C9tXiivcDyfMbdrIuUG1L.0pWE7tdxLTBlADH3wRcTEJPBtQiFGBC	GlobalAdmin	t	\N	f	\N	\N	19dccfa7-9d6b-4a1e-ad11-45638d792237	2026-03-12 12:04:38.541993+00	2026-03-12 12:04:38.541993+00
2d295439-b7ee-404c-a771-b2920291e907	Shahzeb Khalid	shahzebkhalid97@gmail.com	$2b$12$26clXu4QVuZAid9CJdYQHuRL.xI3oHvWJtEdJEH0jIVWLva7/cj9i	GlobalAdmin	t	\N	f	\N	\N	b1ac6bc9-6e98-4a86-8a10-62def124a85a	2026-03-12 19:03:13.601857+00	2026-03-12 19:03:13.601857+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	Malik Abdul Basit	malikabdulbasit03@gmail.com	$2b$12$OjIrAf7OqElOJn1lclV6T.CIzW6cSwXVUgJTtLJD/xe1wr7I/VkiW	GlobalAdmin	t	03207780101	f	\N	\N	bca947c9-cf84-45db-ab9b-28937ad70dd8	2026-01-30 17:46:53.343632+00	2026-04-30 12:11:32.444185+00
\.


--
-- Data for Name: violations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.violations (organization_id, camera_id, timestamp_utc, violation_type, severity, is_false_positive, snapshot_url, person_track_id, duration_seconds, is_resolved, id, created_at, updated_at) FROM stdin;
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-30 18:01:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	36.149240594674154	t	319f98b8-fd99-4628-be65-92f77844f7b2	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-30 16:42:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	26.813492787972525	f	00de4399-9ab0-4ce2-bcfe-2eb53252465e	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-30 16:06:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	28.772381980886134	f	7a837d9a-651b-4bef-9e25-f0f250be29b5	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-30 08:49:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	27.64658612667158	f	4b55dd0d-143c-4954-a5ce-b5aaa6b08665	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-30 14:33:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	33.293032035284156	t	a38bf8a6-1ab3-4225-8a71-b79723cfea89	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-30 11:49:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	32.95900126071746	f	d2d76562-c9f5-4e34-a1f2-49343ba1b653	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-30 17:46:55.926889+00	smoking	Critical	t	placeholder.jpg	\N	51.05772308192736	t	c92accb2-4f84-4d78-be59-4d0733b1e03c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-30 16:16:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	42.58198294065156	t	ad7eb731-fd13-40bc-8ec4-f8bc54edf01b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-30 07:10:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	12.525938563598064	f	0472a7cd-a7cd-4943-96a7-6828212348a8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-30 15:28:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	51.21233832572344	t	88aaa6f6-f111-4561-86a4-8cea84be6a18	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-30 14:42:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	55.688457322469404	f	20134520-1f10-4acb-a785-6fc3edc5e3a1	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-30 13:22:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	20.574844081693655	f	5b4adabc-860e-4000-872c-27e296d5885f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-29 20:02:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	24.617508830156037	f	1986ce69-3cfe-4e32-bd7b-fa4ad0ee699f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-29 10:20:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	53.003487855139994	f	822d23f7-b89d-4c0f-9970-8c49bb1951d5	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-29 20:42:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	11.067267926946023	t	62fffc07-bbcc-4c57-8bb6-abed351f6beb	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-29 15:09:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	55.31182551819449	f	424f079f-8c0c-4bf1-a3c7-4afae86c97fc	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-29 17:16:55.926889+00	no_gloves	Critical	t	placeholder.jpg	\N	54.16052105146223	t	eef4d2d3-7fce-4ce5-94d9-4962c1c1d1f0	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-29 10:23:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	13.730925528419066	t	cfa22ad5-d35c-4af6-a038-836e56b04997	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-29 10:42:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	26.52417988072693	t	fc0134f1-40dc-4066-a763-542a9864c338	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-29 11:57:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	33.55848379804456	t	0fd9559a-caa1-4603-a092-6a096e82747c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-29 17:49:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	42.495414080104034	t	92269c94-9ea5-4cf9-9079-338044e0044f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-29 08:44:55.926889+00	no_gloves	Critical	t	placeholder.jpg	\N	47.198429770780876	f	f37c2d43-4392-4065-a9fb-76597a26f056	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-29 14:19:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	44.958383363470915	f	b60176bc-8f5e-4ab0-a74a-b92fe982b861	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-29 08:17:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	33.01124225830226	f	6ee6fa87-64d3-4d56-b789-2d3b76d416bf	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-29 14:13:55.926889+00	no_gloves	Critical	t	placeholder.jpg	\N	27.193167629310082	f	3ebdcc73-0f61-4252-952c-2182a362b61b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-29 17:13:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	49.17388681714591	f	0db784d2-cde2-4762-bc8d-728f3f78755a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-29 20:49:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	52.947151840659146	f	7a02b7ad-a94c-4020-b855-5b9a54c46b52	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-29 16:35:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	52.10937729155554	f	e0449c62-4d3d-4ad4-8d75-5e0a647ca2f6	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-29 17:34:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	14.616907133367718	f	5e5edce7-2ab0-4bc6-8f54-7241d169b952	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-29 16:16:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	31.842772149979734	f	bbc47418-0bdd-4ebb-a1c5-9a610e5a071e	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-29 12:32:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	38.13866017966342	t	b61c1f3e-a3de-4553-8859-5548d1a9c2da	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-29 20:52:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	20.688783735208812	t	350b0d06-b787-4d2c-8105-82a7705d6480	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-29 16:14:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	26.78298348618036	f	665d5d5e-95ae-481a-adb9-1f2811dbdba3	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-29 15:29:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	29.238705409584202	f	d7bc8949-ca77-47f1-ae06-da06a740821d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-29 12:42:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	10.430606522449539	t	d3c86538-8827-410b-af0d-0bf04b4f00bd	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-29 14:02:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	46.869077968374455	f	0c5719e1-aef0-492e-9208-f3a9b765842a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-29 10:26:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	38.43784456585122	f	774589a0-7ad7-4cd8-8e31-ba0814eb2d6a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-29 10:07:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	22.11336291149493	t	6e9ad36a-fed5-4f13-a900-95d4c00d0249	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-29 13:44:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	57.16312828113688	t	6ca660b9-c7ce-4ef4-be80-96deaca7a487	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-29 17:18:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	24.752681748466195	f	89066a15-02af-4c26-b791-0e7ecbcb2b4c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-28 15:29:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	25.56181880454461	t	9b9797f5-b55b-4763-874e-1a6c4dfad93f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-28 12:42:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	9.65459923596366	t	921c7e73-7bd8-4321-9a67-34ef29495a91	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-28 19:54:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	35.236439115706986	t	abba58f9-1ab0-40a7-baa2-4523c09078ad	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-28 16:47:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	28.074412540967856	t	a4c6dfca-e52b-4ab5-b6f7-f07e48b50bee	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-28 09:27:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	46.869561312206365	t	9bd6a77b-78bc-42a0-a664-deaa52662272	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-28 17:59:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	15.679833998150746	t	1bf749a0-9d90-46c6-b96b-b02d34802697	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-28 18:52:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	21.04570274982996	t	14aae469-7b65-4261-b1d6-cb1ef7f7f959	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-28 16:24:55.926889+00	no_cap	Medium	t	placeholder.jpg	\N	25.198231851507288	t	de2e5223-5d59-4822-bc83-a381ebd41361	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-28 15:21:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	48.85100895409823	t	d01cad1b-3a06-4ba1-aef2-f5c1d3d74e45	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-28 14:40:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	39.58365869838115	f	0c0cf364-138b-4077-9547-9cd770a3a850	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-28 10:49:55.926889+00	no_cap	Medium	t	placeholder.jpg	\N	49.3902536304534	t	4cda2f77-4264-44c1-bb42-7d14548f9aa0	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-28 08:43:55.926889+00	no_mask	Critical	t	placeholder.jpg	\N	56.19424453398765	t	d8be873e-fab7-4fdf-9bc8-63de4d9d7ec1	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-28 07:48:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	13.876509789405455	f	2ef29d21-09cf-4754-b078-c9677f32823a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-28 11:15:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	24.544096766580296	f	e8ef5245-0122-4159-bd8c-37ec04efcfdb	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-28 10:50:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	33.30124533367692	t	0bffb9a1-21f6-4f88-9e2f-d5d91a5dc819	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-28 11:51:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	43.18349866876895	t	9e2b6763-13f0-4e9c-a97a-53862fca5c97	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-28 20:53:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	32.76723326173875	f	48209481-84b1-4c87-921f-55a7c89f9db1	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-28 07:36:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	15.7381276882403	f	07e2a900-08d9-49b5-b7f4-6640f95e2571	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-28 18:10:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	7.4803423393804565	f	94f4a80e-626a-44c7-bdfd-a47260592c10	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-28 20:52:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	33.8927741837803	t	7926e82e-323f-41cc-bdf1-301420c9ac4c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-27 17:14:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	29.103860749994702	f	c57ea1bf-fc6b-4654-a7b4-f63dbab166f3	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-27 13:11:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	35.1822005540176	t	07641ea7-5bad-44a8-ac77-d3a10128af7d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-27 13:21:55.926889+00	no_mask	Critical	t	placeholder.jpg	\N	12.771620200476901	t	3e08468c-0657-4fde-be53-fbc334bc9f12	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-27 10:22:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	11.485367115804323	t	c5a9a48f-d595-45d5-bc2f-a438cc89e614	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-27 13:36:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	36.85299866059545	t	f7f46576-525c-445c-90ab-94fc4983baf2	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-27 08:07:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	9.11970020634524	t	369eba04-5234-4859-817d-39ec0b952af9	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-27 10:13:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	26.36287837749294	f	f20d95e8-6c59-47d0-834c-550be2259946	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-27 15:37:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	51.20770090613404	t	e17a6fdc-c4fa-4e9a-9df9-680c80dede78	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-27 09:32:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	33.01012712125751	t	b9cb80bd-186c-4df9-84d1-ec3fde5a9fd4	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-27 14:47:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	27.877915310332163	f	92e3e5af-9955-4ffc-b697-95f1dbac5df5	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-27 20:39:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	19.9508855457777	t	9696357d-2c91-4bbc-8e2b-248e9e9a1af4	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-27 17:58:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	49.49186287505156	t	9274d2e1-0182-4fd6-8ff2-add2926076fc	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-27 19:19:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	29.784913079806984	f	ed032bd0-ec44-4886-b0bc-7999af0262f8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-27 20:56:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	23.44394591548996	f	90dc3511-316a-4b7a-8c22-412fdfef2276	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-27 17:55:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	33.18119125808201	f	fdb2d6d1-234e-4268-863b-af2b54ebc174	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-27 10:11:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	32.58661940456578	f	95be52ca-a25e-48aa-bdbc-87a87821fc65	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-26 11:31:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	46.068536060439534	t	de51cd27-315e-4a55-a2f6-90b28c3e103c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-26 13:12:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	56.53623500747893	f	ac230390-6810-454a-81f7-de14cfe02fd0	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-26 12:45:55.926889+00	smoking	Critical	t	placeholder.jpg	\N	14.623282880427286	f	2c3514c6-3b76-4898-85e0-5a0a12a5c80b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-26 10:01:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	14.907819563346314	f	a2be47df-0beb-4051-8ac4-beff7b2e1ec1	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-26 17:18:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	56.35826305418768	f	67d3b027-d88a-4a87-9298-0d6a98db8919	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-26 10:57:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	34.51529306934893	t	c4969deb-dc29-4e16-993d-ec3ecc67b124	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-26 17:59:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	6.5000781829270995	t	7e091d1a-86ca-4ff1-85fe-b568bfbcb94c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-26 20:23:55.926889+00	no_mask	Critical	t	placeholder.jpg	\N	27.795757069090364	f	645fc48c-8d92-4bae-93f7-d671e1e03d36	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-26 20:07:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	9.44415303831695	f	a929c961-fbbb-4918-a456-b05a3cbbebc3	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-26 13:52:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	5.1780417741796985	t	c4559a77-e97d-4a69-99f5-5f3c2854c0a8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-26 12:40:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	56.74136394933108	t	2650572b-6e21-4a22-a36b-a619217e9b35	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-26 12:51:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	52.1352648299273	t	bf1f736e-72fe-4783-9a03-76446e4990ac	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-26 16:03:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	11.437505921909537	f	773b7a70-2427-46b5-8310-cf3f705a59c9	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-26 10:16:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	45.28475879863907	t	05bd518e-e5ba-42dc-a6dd-5cf903794bb4	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-26 08:41:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	10.92292237857002	t	ac87afc0-ecb2-4316-8b52-33a696eb827d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-26 18:00:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	15.649216241943028	f	1c2cad01-2514-4ccd-8ca4-937cc862f5c3	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-25 11:59:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	51.035523358665145	t	8af073d9-2893-4aaa-afef-b1463cb911fe	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-25 14:41:55.926889+00	no_medical_coat	High	t	placeholder.jpg	\N	8.3109974845549	t	0d4be40e-aac4-40eb-a384-5ad382595e15	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-25 13:24:55.926889+00	no_cap	Medium	t	placeholder.jpg	\N	41.65699941653443	f	0557fc4c-171e-4707-9295-a1599fe55718	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-25 16:49:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	11.247659253120123	t	7f91874a-1b10-45b7-99da-335d69d2b219	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-25 10:24:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	58.94651349922017	t	8b50d579-5bdb-4b37-bbcb-3f51bfbf93b8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-25 20:26:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	35.41628640247892	f	fd51b20b-e4fc-4be6-a516-55768204c992	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-25 08:39:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	26.04787764000213	t	353d09e8-8d73-4fe9-abaf-3f0984d44eeb	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-25 13:07:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	50.69407417423314	f	f0d6eb06-6927-4c41-ad60-6c24af78affe	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-25 17:41:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	42.54561151596733	t	8e0d328f-0cab-4441-af40-d9caf8332afe	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-25 08:44:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	53.61642275113508	t	94cc11b5-9366-479b-9a8f-3f63ff0a8592	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-25 19:36:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	7.525592794143779	f	48231b45-c245-476e-93ea-6a7c92fa760a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-25 08:07:55.926889+00	smoking	Critical	t	placeholder.jpg	\N	11.086883702787768	t	a89b69e1-d6eb-4234-a1e7-441dce7762a1	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-25 07:08:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	12.282582823713069	f	9a1fea0f-fd1d-4f68-adab-b0065f273002	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-25 09:14:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	5.515394997737001	t	95fcfa8b-c741-4caf-a6a8-5fcda6c71bfa	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-25 20:58:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	45.74961849766243	f	ecb1dfc5-5be5-428b-af24-8759b6d309a8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-25 20:22:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	21.4020543254463	t	9ff39e3c-d4f3-41bd-bd1c-379bf5e3f9ae	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-25 18:54:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	43.81201849132246	t	158e50b8-65d0-42d2-8eb5-b5e995193a7a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-25 08:25:55.926889+00	no_mask	Critical	t	placeholder.jpg	\N	27.722858278165756	f	f2782ad9-01c4-4579-87ef-95bac589b8d3	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-25 15:11:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	41.917943660865	t	842e9099-330a-4154-86d9-4ebd8163c7e1	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-25 07:53:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	14.730270506576538	t	5692c17e-ce08-4b3c-838e-975a731876a1	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-25 12:49:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	58.83699584597433	f	efae9384-869d-4410-b32b-186c69877372	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-25 18:33:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	12.377048957944364	t	46938c0f-a6fe-4d91-a553-614ee3241372	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-25 17:47:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	8.798991007652127	f	a288f375-5fd8-4491-9a23-6128837ce4de	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-25 08:11:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	16.815874232061514	f	3bfb6074-08ac-425f-b554-125a4dee4a7a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-25 19:09:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	27.549322278294323	t	f704e1a8-c16d-401a-8af2-b295978a3f68	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-25 07:29:55.926889+00	no_mask	Critical	t	placeholder.jpg	\N	16.41161742533915	t	ccdfa2ba-b7bb-42bf-82d6-4dcb7e0ef40e	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-25 08:18:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	16.76525130125374	f	8dbd1927-04da-4709-848d-e6048606b61a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-25 19:29:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	10.654395438083078	t	a84bdf81-5c47-4512-8bcf-bdefefe9ae48	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-25 18:29:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	5.060566793929964	t	5e594c8e-e363-4245-a70e-82bf05fc4cbf	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-24 08:04:55.926889+00	no_cap	Medium	t	placeholder.jpg	\N	32.272824675607545	f	7a85b391-43f6-4144-b7b3-389bf5037a1d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-24 19:10:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	59.68709172158483	f	1711befb-3a4e-476a-a353-17572747026f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-24 19:31:55.926889+00	no_mask	Critical	t	placeholder.jpg	\N	32.139902001744915	t	edf6e795-4dea-4005-b68b-9f2b312136f7	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-24 10:47:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	51.13314148871029	t	8a2a7ea8-52a4-41b2-ac2e-c077bc97edbc	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-24 20:36:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	40.866969185208355	f	aebd134c-a99a-4caa-9110-578ad5bf73a1	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-24 10:09:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	49.17573363630322	t	abd45e8e-5fc2-4b60-a6cd-aeab893e0e54	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-24 19:39:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	18.442062832127057	t	7cadf602-1af2-416b-ae72-c100b008970f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-24 09:24:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	51.790129894300435	f	8d1e6b09-aaad-4f19-b656-7f214ac135df	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-24 12:09:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	16.44477215864539	f	c3b8443c-4120-4214-9eeb-96fc56c02fde	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-24 12:04:55.926889+00	no_medical_coat	High	t	placeholder.jpg	\N	58.74932895899745	f	e6081eb6-9130-487c-90e2-eb29e39757a9	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-24 14:09:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	35.37658395145405	t	0ee02832-d60e-4000-8555-b621d9b1cce5	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-24 15:11:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	31.97882553413859	t	5bbc74e9-da58-433f-b861-43b0b3fa20a8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-24 10:31:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	41.588610680179606	f	55e940da-db66-4d50-ba76-d0ddfc464373	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-24 10:53:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	57.16258748867896	f	132094ab-eff2-452d-a20a-f9bb324484d0	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-24 16:48:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	13.222013401848423	f	53bb21f0-5d62-4bae-b106-00dd3740733d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-24 09:39:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	21.076859417455452	t	99598e44-74e2-4132-8442-90a6c1c44a03	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-24 07:11:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	30.34788334191874	t	e4ee13f9-c68d-4a75-8ee1-158051c4a732	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-24 13:24:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	9.847992325233362	f	ed5e4f32-fc94-4130-9158-356597e960e5	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-24 12:30:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	44.7396526814605	t	3419333e-8f73-4881-88ef-ae609d7c2d9b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-24 13:30:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	50.10851070170492	t	7b5fdf8d-1396-4358-bb77-e6ab12d27730	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-23 14:32:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	27.53093726803917	t	133f997e-4925-42ac-9a2f-ddceed1d28e4	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-23 16:49:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	54.9680495542595	f	193dc075-dfbf-4857-92fb-1f229c551639	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-23 15:37:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	27.417502435011347	f	97a05803-736f-40a1-be54-acf9bb65afb7	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-23 13:59:55.926889+00	no_cap	Medium	t	placeholder.jpg	\N	44.12186268117865	t	bb8a2cd1-260c-4ef9-9925-ff571851d623	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-23 11:28:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	13.776203989940088	f	ecfd88e5-abb6-43e6-b7a3-56c438b4da9d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-23 19:38:55.926889+00	smoking	Critical	t	placeholder.jpg	\N	59.0167429852234	t	95e858a2-cd06-46cf-bdcc-f14ef14eba0c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-23 17:49:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	53.88051667298861	f	d100463f-f546-48d2-ad14-edea884c64d6	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-23 14:33:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	16.586907043489198	t	c1abd952-2446-47cc-a17f-fde8ae3efef8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-23 09:51:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	38.969376056254305	t	a634ee9b-c85a-4cd5-bd6b-cd278140c5b1	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-23 13:16:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	7.27799252544432	t	4b8c90b3-5861-436e-a1f7-aa199c63a2e8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-23 12:41:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	18.668346702549393	f	80675039-68f9-493d-b100-bf60a15d279f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-23 13:55:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	33.969574270599495	t	16d28afb-dce4-4535-b752-47c6438589bb	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-23 16:50:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	31.59618380027319	t	ca746653-b359-4d7d-9b8f-ef214d7e8251	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-23 18:43:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	59.10452473189254	f	303465c5-7b08-458d-8fc9-6495bc00f1fa	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-23 12:58:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	42.77053656563444	f	9b26171d-f48f-4515-8889-06c56ffbf565	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-23 19:12:55.926889+00	no_mask	Critical	t	placeholder.jpg	\N	21.201825055891508	f	adf1f180-d012-4f77-ad5e-760886bb9262	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-22 18:48:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	46.35829074728086	f	45ab4f67-5195-4a2c-aa03-47d6981ffc76	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-22 15:20:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	8.187564034394665	t	9b72bb0e-29d9-4dee-ab99-8c84e01513da	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-22 13:34:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	53.428131979592635	f	68a846e0-6fd2-4d74-9c6b-1d92c7ef3f07	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-22 11:33:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	48.44504965508985	t	19e23a63-5f3c-4e00-95aa-2dc6758e1bdc	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-22 17:51:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	20.945805848997065	t	f0fe4eb5-0f33-4bc4-845a-c41eb873b824	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-22 11:03:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	44.166220434226986	f	d181e646-07cf-4f16-b422-609a6f226def	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-22 14:57:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	37.7247198326396	t	ce31f9c1-d223-4a9c-8168-75bc51c71259	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-22 13:35:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	18.485090823534215	f	1f9ded65-3510-4e36-a218-7d18614adb15	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-22 13:21:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	5.873721832579618	f	f3827924-3c55-4035-82be-fbe143cfae7e	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-22 15:52:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	54.620281956519506	f	fa28e323-dd58-422a-a7ff-76b7a734dfae	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-22 20:30:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	35.420622357367634	t	c23a7e84-a51c-4558-989b-2b572dc12809	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-22 17:59:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	36.3480943644051	t	06cd51b0-f86b-4247-b1e2-4acbb0c09b2f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-22 13:15:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	21.96753719821312	f	8166344e-cfd9-4b38-88ad-0d584cbc07b7	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-22 11:27:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	45.890091700049965	f	ebab5aa1-8ae1-4137-8a97-71af07f6cdcb	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-22 07:44:55.926889+00	no_gloves	Critical	t	placeholder.jpg	\N	39.1861390226885	t	46703714-0472-4ca2-9a97-80fba4941329	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-22 15:30:55.926889+00	smoking	Critical	t	placeholder.jpg	\N	42.06234293915374	t	7bebefa3-0fc8-4a43-b8f7-a9c16400b76f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-22 15:49:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	13.788753976471519	t	385ecb54-a4d2-4ee1-af0e-546c535f7e12	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-22 07:14:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	40.134634987517764	f	1a1ff4d8-e678-40be-b697-bd5964fb84d3	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-22 13:36:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	28.042858772071625	t	0b8f89f5-6c84-4c24-b7ea-2cd41693397c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-22 07:06:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	5.861643878829505	t	79122d6b-7b3f-45ba-a458-aff223006f91	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-22 17:38:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	5.339173404717822	t	c868ecd0-271d-4ebc-ba1f-bd6bc41324f5	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-22 15:15:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	29.48662216350633	t	3b9d2458-0426-4eb0-ab95-39d9dbd55371	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-21 12:14:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	34.377334811733476	t	10b28a7b-47e7-4641-9eb2-f97228a8e748	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-21 15:25:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	39.42195008277862	t	fada6aca-8456-4519-9497-a704c052813a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-21 08:23:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	56.9309383037789	t	f1a362d5-ec01-4fde-ae9b-911673af1b18	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-21 12:24:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	34.23445205504821	f	359d23f9-d16c-47e3-be23-64e5421ce4b5	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-21 10:20:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	39.07891720071431	f	de0ac83c-8f5f-4660-8967-42b77fedb20f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-21 20:19:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	20.695286040346332	t	205739a5-e0f9-48a3-9e4a-b11df1802d35	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-21 14:34:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	15.708869407421336	t	85081260-948a-49d8-b980-9387b8f7a8c1	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-21 09:32:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	22.698165152687647	f	82a1b1b7-14df-4516-a809-2222b5c87973	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-21 07:31:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	45.6239052679942	f	9fbcb22d-9ae0-4818-bf3e-b0c4cd5f8376	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-21 11:40:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	39.4548755112376	t	e722c9f1-0428-4b40-af84-ddb3c8da37ed	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-21 09:59:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	19.532737213276604	f	6ca40639-bdbc-4148-8551-d861eba1098a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-21 16:08:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	32.27339089415093	t	b250a10b-6c74-447f-bbe7-7a2482738bca	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-21 08:06:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	12.624640899397466	t	fe70ad10-c1c7-4f02-8b0c-7244a726c71a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-21 12:19:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	28.056139998347994	f	003ebbb2-7064-45cf-a2e1-4df052e5fa1c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-21 08:43:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	39.651533384110486	t	a0ff1506-3fee-4173-a925-bffcf2f28d22	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-21 07:41:55.926889+00	no_gloves	Critical	t	placeholder.jpg	\N	17.89920960440213	f	e19d6e1f-36f2-4ef5-afb1-846dcc42ba7c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-21 20:12:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	48.91403657273102	t	a5dedb05-51c3-41fb-806d-688c67204708	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-21 14:48:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	43.920743341542206	t	bf919962-3567-4714-93bd-2810d67136b8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-21 07:15:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	37.99779439130735	t	a68294cb-9f3e-4bc1-ab94-10663a8f9914	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-21 12:29:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	55.110959942942756	t	66bacf1b-da7e-4a13-99ac-4f08150ea68a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-21 09:38:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	50.40118973730898	f	433c0bca-7987-45c0-9471-8d981d9c02cc	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-21 14:06:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	37.09624523901063	t	e5d296ff-7e41-464e-8674-8822cabc0f5f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-21 18:34:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	50.39166468054129	t	c14bec14-5107-4343-9778-ba3daaf01868	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-21 18:29:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	28.641060786016006	f	7082f3e8-d7e8-4196-8499-4080d3b1b77f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-21 18:55:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	49.55155892357563	f	513ea311-a43b-4825-9c21-178438c34ae9	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-21 18:34:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	20.457857180599724	t	ac556047-75a3-496d-8916-5b51460da7b4	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-21 10:42:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	21.510248157692658	t	15699b9b-3246-4152-af4f-4371af6a72ec	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-21 07:40:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	29.205077688201573	t	8943287e-c494-4fdb-8fbb-ac90fed9ba75	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-20 15:45:55.926889+00	no_gloves	Critical	t	placeholder.jpg	\N	24.831440603310686	f	fb08cf2e-f875-47ac-bf20-d171a95edf4d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-20 11:16:55.926889+00	no_mask	Critical	t	placeholder.jpg	\N	23.552773296892585	f	5da227e9-c7cd-4f6f-a47b-bd6f818adcd1	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-20 08:10:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	15.20144376307594	f	7068fb48-6da2-41e5-8ff5-eb96ff33a19e	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-20 08:42:55.926889+00	no_gloves	Critical	t	placeholder.jpg	\N	24.114490177743317	t	db5a0f9d-79b2-4d3b-b3bc-637bcff11636	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-20 09:49:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	32.02176341656201	t	fddd217c-0529-4feb-ad5b-a61a2138a86e	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-20 17:35:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	30.983788244421003	f	4d11ce88-508f-4d5d-b313-dd98dc4f74dc	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-20 16:50:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	24.737245628856925	t	8d0778bc-a837-41b3-9cc2-d42a9a28f063	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-20 13:34:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	5.245475774663372	f	301679d1-0944-4852-8f4d-aba1972a5233	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-20 10:36:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	45.0575380775214	f	58c26bff-e7a8-4f5d-8803-f4c0278366b5	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-20 10:09:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	55.259042452135176	t	d563276f-2f4b-43ec-bb25-f47cee05a15d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-20 12:32:55.926889+00	smoking	Critical	t	placeholder.jpg	\N	42.310844942184914	f	b69560c1-1c3b-4441-99a1-89ee64d53e36	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-20 20:07:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	23.997492028380673	f	9fadc65d-b049-45a3-8424-2eed51542b31	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-20 07:20:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	26.383709157750353	t	27e7663c-08e4-4ddc-996d-d8c1dc98d8dc	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-20 12:42:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	15.134444474670136	f	0a07e3ae-1b6c-4ab2-8bfc-142b25829bd8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-20 08:37:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	46.4015240556095	t	ede4de0d-a02f-447e-b806-ea46db1e42c0	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-20 18:07:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	34.476497035030334	t	4855af07-fb3e-4d65-878b-efe4a42bb494	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-20 08:51:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	23.863355179360266	f	c87f4ba1-470d-4ed3-abdf-50598132d0d8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-20 13:40:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	19.723095140297062	f	0c1cefe6-6f9b-4bc9-a837-3c6597db03f2	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-20 11:20:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	56.77113154610229	t	b98247a7-8f7d-4554-8fcd-0cc7b90abb68	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-20 10:32:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	37.33332771063036	f	ff4ba8c9-6209-49bf-be9b-103b6f0a5b0d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-20 14:13:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	32.71549233361547	t	ed0c596e-080d-4a80-835a-8583d5163522	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-20 08:36:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	45.45038210419417	t	7cbadf7a-88e5-4fee-ba6d-169e1d5832f8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-20 14:28:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	42.545790205150446	t	a98c1b59-9866-4039-91ec-7dbd63877045	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-20 13:33:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	42.61799599862059	t	29d07e3a-bcff-48f7-bf79-f2f00d878336	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-20 17:59:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	15.818500930234503	f	f0a175fb-5e5a-4b34-aa1f-895d7fd278e7	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-20 12:14:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	52.87026768052489	f	7fc31ee8-cef5-40e7-8c75-3c639dccc26c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-20 08:54:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	40.32024922812849	t	6166e5a6-7849-4018-bf0c-f64eb632f695	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-20 08:20:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	6.4790303853052365	f	3a205c20-28fd-4a12-9008-fa5dca0cb581	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-20 09:53:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	29.424343568180074	t	9d6251b2-17b6-49cd-83d8-bae4edd519ff	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-19 16:36:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	34.01190695168609	f	95465996-a2cb-4590-8f35-8b14ed342156	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-19 20:58:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	5.163854754477547	t	7114e4a9-0a97-41a3-9ea3-dbb3870c119d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-19 07:19:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	58.7784229522442	f	226ec490-2091-47ff-b372-cdd95f1d26f9	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-19 13:01:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	20.348067847413894	t	3b99de85-b76b-40db-8d66-68ad15935abd	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-19 09:21:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	55.6415149259239	f	7365d1ba-b5ef-4476-b0af-a914b060769a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-19 14:19:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	47.294901930209235	f	7a1bb25f-dab4-48d8-887f-9624824624c5	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-19 12:15:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	43.82886281673612	t	6b285595-e918-4e18-8851-a78d60b0c1f3	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-19 07:15:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	19.12961883991175	f	c8014d2c-e2b9-48e3-a54c-955435d37ac3	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-19 14:54:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	59.41508305671779	f	368cf57f-8857-41bb-9ce3-35fd54ef1b68	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-19 20:17:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	52.81610679804016	t	39ae4dde-6455-4e9f-b979-d1e39cd4b059	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-19 11:38:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	34.988799319948114	t	6b412a24-154e-4c88-b822-69c4af42e2e8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-19 09:57:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	37.662903280007676	f	c25cb601-62da-4a6e-b73c-5bdf69f04402	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-19 08:56:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	20.384874157588296	t	c6749da0-2213-4e8e-811c-535f8f59be49	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-19 16:53:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	52.59277859958713	t	097169d4-614a-4487-ab2e-0bc62befc522	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-19 12:50:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	13.652305315044122	f	98539931-a67a-4ea8-8834-927ff37e3178	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-19 08:01:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	8.855677982620659	t	d166a5b5-a839-4a87-b5bc-3966561ace84	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-19 13:28:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	28.011062450056308	t	1b917164-b7e6-4c28-8058-b8d3631a2a2b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-19 20:13:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	53.22994406533933	f	e1dcb48d-f5fb-4a08-b3bc-ace489221c8b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-18 17:23:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	22.321516341603967	f	a570839d-e8c5-4937-9987-a6d13d0130bc	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-18 20:28:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	19.69432199606357	t	8cebae3b-33f5-4ce8-aee3-e0c8bdfdf141	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-18 07:25:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	56.2730435501402	f	35f87e56-5ad4-4879-817d-826ad30870d9	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-18 07:03:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	25.395156799291154	t	f4f2551b-901c-406b-8d27-445fa5b1a50f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-18 08:56:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	57.5362301613623	f	219ce6c4-4c0f-4ab6-884e-6d572312ed3d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-18 11:57:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	46.26238272000138	t	50a32247-0d52-4fbf-8a7b-77324a4048c8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-18 10:10:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	35.371006682904195	f	b915d529-da95-4299-b595-685a5d2954de	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-18 15:59:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	59.79920873777987	t	21306fac-e803-41f9-9346-e6b74ca5d45c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-18 09:16:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	11.784488062568066	t	dec932e1-1f8e-4412-bc34-a154c2d5d738	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-18 15:57:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	57.730398568474286	t	e64a92d1-f336-4a37-badd-380f99a2087b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-18 11:31:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	25.029848467266454	t	c86c86c0-1c6f-449e-8a35-40777225867b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-18 08:57:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	59.78529816955211	t	e3854e03-01c0-49ba-81e4-5728acf2e2aa	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-18 17:25:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	23.042484258127	f	a3a5dc1a-3c23-4c37-bba7-f761085daabf	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-18 18:58:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	22.523226643850887	t	8d3ce993-6ec2-4aa3-af77-62eeec9f549a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-18 09:31:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	16.877066636450678	f	03633498-cb57-4e98-bd6b-6b42f7add75f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-18 08:08:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	54.25338091278268	f	ed9a3e0c-c28c-46ef-a73a-9200efce5ab9	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-18 07:29:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	8.928106559033404	f	b94c1860-cddb-4b71-b4c7-56528dcc86d0	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-17 15:11:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	47.44749675179206	t	972a1a36-fd6a-48d8-b399-524581dbdde5	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-17 08:52:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	11.323397991346766	t	e22a8bf1-a162-4383-bfc0-24c765cada3a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-17 10:52:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	41.488772824888976	t	b3cb614a-b088-40de-94d5-7dbdbe31dd77	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-17 20:43:55.926889+00	smoking	Critical	t	placeholder.jpg	\N	5.235093557552886	t	cf639619-4faa-4b4a-ba0d-a0a9a77dd35f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-17 15:24:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	41.12509365931475	f	b70cbc73-b38b-4cee-b482-bdbefcfe6579	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-17 13:53:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	50.36119311255248	t	91513b75-f62a-49a0-a00e-dbf514d2142a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-17 10:57:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	11.549434670503366	t	0c130d04-2b99-4721-b5c6-84779ce6440a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-17 20:34:55.926889+00	no_medical_coat	High	t	placeholder.jpg	\N	28.606055125965366	t	815c0e54-48b7-4e91-bc5f-c6a7e6facfb0	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-17 11:15:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	33.03950771260152	f	62fab83b-0b39-4053-80c1-c3db855d0248	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-17 13:01:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	51.255882881001	f	71f7d21c-8f3f-4805-b8a1-32341d6bb98b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-17 16:28:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	27.018296285775886	t	f1b6bfee-539b-4cd5-bf43-01a1bee3d9ce	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-17 20:51:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	19.093510754044296	t	a90d225d-28de-4ba0-b54d-cfa9c143bf7d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-17 18:01:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	40.354223516228394	f	c77007af-4a9e-40fd-bd4f-a4c62cfc02ac	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-17 07:47:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	59.68159418856306	f	fce57388-e170-468b-b45e-64bf12d83d45	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-17 20:08:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	16.75291031545395	t	8e5215e1-11c0-47d6-b834-7453b0026448	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-17 14:27:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	18.387487840644646	f	6d04b091-4998-45b1-bdd5-c5b732d3932b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-17 08:16:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	23.206619253696978	f	4b510a79-cc63-4be6-85d5-c3cc3f74e40a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-17 16:21:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	32.46981738768967	t	8c1dff40-92ce-42ec-8fa2-55eec27cacca	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-17 11:30:55.926889+00	no_cap	Medium	t	placeholder.jpg	\N	58.303557750870425	f	f4aaf380-2d8e-4885-a200-bc2d60254569	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-17 16:48:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	29.09892113900502	f	27fe97e5-842f-4c39-8099-1cd63c164365	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-17 14:46:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	25.074604753937287	t	1b4b173c-d98b-4a56-b99c-ab4d4d7e8a1c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-17 09:38:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	35.820123011091496	t	dfad9452-f4ee-478b-bed3-a927e61b2ab8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-17 13:16:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	36.08851259127512	f	fe6437ff-50f9-4727-b020-43ed45686291	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-17 10:58:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	11.64871955970112	t	ad809b0f-9af9-41e0-aee3-862c228420bb	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-17 19:59:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	39.65631041051701	t	90394a7a-8706-41da-95e0-0d57c9ce5f03	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-16 08:40:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	13.227213979797627	t	e98c5ac2-29e4-451f-8b42-a284f57e24e7	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-16 16:17:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	39.98648960618953	t	82b98504-a2a9-4d69-ba71-5db981f74fc9	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-16 15:36:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	25.49749388718582	t	b100a484-4e7f-4ac7-a38b-6bba9ce1c095	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-16 16:57:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	21.82234372514973	f	45fe4515-b3dd-45ee-8415-91d657783e63	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-16 07:43:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	49.1602991046727	t	1bf0af82-e62f-4b68-98a6-18228af4608c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-16 18:01:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	57.6130333634956	t	16df4288-10f4-4b6a-a48f-2d13a5d19eff	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-16 15:52:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	38.00406982801573	f	0ccf1175-28f1-4f01-b02a-26c5ab356946	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-16 20:00:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	58.76530369468922	t	c84ee781-79a6-4644-838d-810df7f124db	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-16 12:37:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	58.7082540232202	t	83c10f23-ad9d-4783-a762-5991b313f1e8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-16 19:50:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	54.0951003460088	t	201239b7-d97d-4c2d-acdd-fca235615771	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-16 09:42:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	39.952033668447115	t	5b898236-fc71-43d4-b62b-23228bad483d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-16 11:13:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	21.848885601382335	f	e15c8227-54e4-4f84-8f58-ce35b7211da5	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-16 15:24:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	29.283497231532014	t	d4f1d789-4f49-411a-a7d5-ccf7009446db	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-16 08:46:55.926889+00	no_mask	Critical	t	placeholder.jpg	\N	12.389990648398179	f	c3f44d2c-bd7f-446e-b3af-07ad6a0d9c50	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-16 13:47:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	39.11713508415182	t	f259f1d0-f5b3-46da-a7bc-dbb4bf899656	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-16 15:44:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	53.01635315863677	t	1f050c1c-2478-4ac0-81ba-f9d8aad83c50	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-16 08:26:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	41.30140727822179	t	3db90aa8-8bb3-42d1-bb91-b639fd2b4830	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-15 09:39:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	14.173596409617707	t	4fa65a40-78ce-4194-b540-4d93e0a78af1	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-15 10:14:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	6.832776401747079	t	bb7a6513-4d49-42b1-931e-c8081a7bc90f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-15 07:22:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	27.433008595489934	f	b625d748-0850-4435-b6c9-a50bfbc0ee1d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-15 18:28:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	35.70724656084445	f	6041d894-8511-4af2-9258-55a2a4b70465	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-15 09:15:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	18.79192116615361	f	47c24334-cbfa-4287-9b31-015d68d30bba	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-15 17:10:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	33.12495632513525	t	a1069785-d775-4f09-90e2-f2594bd3b8bb	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-15 13:13:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	59.759290213901224	f	ca0cc3ce-2b6c-4ed7-aca8-ad4843dfed70	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-15 16:31:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	59.829401590522835	t	d4350295-9316-475b-8558-5dca3667d61f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-15 07:02:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	25.224688435356605	f	c476ae84-27a1-4986-8993-778efa95948e	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-15 10:42:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	30.85512550682185	t	2cb740aa-2d8e-4b4b-b08a-f7827bc7d00e	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-15 13:57:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	6.431157522634925	f	482437a1-e415-4a1b-be5d-64850480e2c9	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-15 16:08:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	15.406361408462502	f	af54f53a-ebd5-47f5-af1b-23c8d13a394d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-15 18:22:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	23.530712389295765	t	08d929b8-d6d5-4cf9-940d-31b164287060	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-15 19:40:55.926889+00	no_mask	Critical	t	placeholder.jpg	\N	38.63235741508268	f	6efaf03d-4a46-4fe5-a3df-38e0dfc1ebda	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-15 12:33:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	54.14044155934228	f	ad2f4c4a-13e2-4ac1-8951-2af33c1b5f35	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-15 10:02:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	56.707999619600635	f	29946206-29f0-4141-bdd5-2b7b5fdbc861	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-15 11:53:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	27.22331340613804	t	23d644fd-d0c5-41a8-b5d2-f94939e5699b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-15 13:13:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	57.31775021882253	f	a2dcbd8e-e8af-488c-8ac0-5e842009e0d1	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-15 15:04:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	40.139348280432756	t	948286a4-737e-4901-b075-4919fcec777d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-15 11:22:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	29.710139702982115	f	8d4948f6-3cab-46d7-818c-74cba25057a2	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-15 17:11:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	14.951558228857156	f	f22fd3dd-76c1-424b-b27d-a45e22512a2c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-15 17:35:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	32.309206434020254	f	a1e496ca-4b2c-413b-b964-d298967f5dda	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-15 19:46:55.926889+00	no_mask	Critical	t	placeholder.jpg	\N	29.890267046147923	t	f57d2765-573f-4aba-8972-477aed594d20	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-15 20:11:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	25.96069970406633	t	06496f96-bcd5-4d59-a710-e42e15ae7feb	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-15 11:12:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	41.6833311241206	t	8f459128-919d-44a8-bd0b-4309adc46044	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-14 19:33:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	11.211696077560529	f	bd82fec2-08c9-442a-981c-1b1423bf78f7	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-14 19:58:55.926889+00	no_medical_coat	High	t	placeholder.jpg	\N	8.079224208349991	f	9b169b5d-d98a-46e8-a5e6-b5fa07aef22c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-14 09:18:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	24.627266290329118	t	da1c0060-d657-44ce-9296-c19aad666b0d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-14 07:35:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	21.74780834692947	t	bd6a51d3-455f-457e-b0ae-a354c15b3371	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-14 18:05:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	45.67530820039382	f	295e1c2b-f75a-4123-9b61-466bc9abca13	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-14 13:17:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	44.80028833295391	f	e957e987-dc5d-4d6e-86be-124155e15306	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-14 17:27:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	58.543822202340564	t	83b35f5a-0682-46e0-9d59-fb9e5465efe3	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-14 07:20:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	16.6412673626294	t	2a8d3f5e-a306-40bd-a244-4ed66b98db26	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-14 11:43:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	30.254273101759928	f	90a3b51c-f902-4695-8166-867604fd38da	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-14 13:13:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	42.587290994499455	t	a6583290-f82b-47d8-978e-7a078d6ecac5	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-14 08:49:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	47.74290077903776	t	376f4121-ec59-4796-b775-65b899de31a6	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-14 14:05:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	42.96823095572214	t	95c4296a-4315-41f2-8030-b7024ba444a4	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-14 10:33:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	15.006268160617125	t	b311221e-2426-4b93-bc2a-6eda0b86c4f6	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-14 09:28:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	22.648921148854704	f	fc2f8261-bbd0-49b6-ab70-d2141acecc65	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-14 14:35:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	10.642959481198428	t	724d8975-fa31-44ef-a06a-3106b7be44be	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-14 11:38:55.926889+00	smoking	Critical	t	placeholder.jpg	\N	17.973822541700883	f	0dbe741c-1ef5-430d-8ade-99843482e531	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-14 15:58:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	27.299271428666565	f	95a40d05-d633-4d1e-b913-9a9ad4e9f33c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-14 13:35:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	37.85084451093326	t	917c47bc-814e-461e-8459-1175f42d2f31	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-14 11:50:55.926889+00	no_cap	Medium	t	placeholder.jpg	\N	22.007737315744166	f	842bead2-603f-43df-a885-f977529df183	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-14 16:39:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	28.82892979218233	t	c17223c1-a212-4d36-84b5-0682e3a75cf9	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-14 20:59:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	39.16200417126566	f	54228dae-f049-4075-aadc-fe26c557679a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-14 16:46:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	36.57510071525152	f	8433bb60-8d4e-454a-9be5-2c5710e219e5	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-14 20:32:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	48.97567158402344	t	3ea7fb54-757b-497b-a32a-e3b81bddc6c7	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-14 09:21:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	49.85836249575074	f	cf9f784e-2b02-472a-9984-92ce9038ceca	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-14 18:06:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	37.01830332746403	t	295b7e1f-5580-458a-9d6e-06d02ecde8f0	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-14 10:00:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	33.196174583465336	f	4f1d19d3-e1ab-401c-9e81-7460bff79c46	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-13 14:30:55.926889+00	no_medical_coat	High	t	placeholder.jpg	\N	11.460301817899229	t	04b33a00-febd-48f5-880c-59d6d12621c9	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-13 20:09:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	6.571716844509884	t	87122ccc-ffdb-41ab-883f-93dd07e31436	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-13 19:49:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	50.36951371637257	f	9787fe9f-6b66-4ce5-beb3-98f036fc655b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-13 11:35:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	23.967907716615596	f	6007cf6e-dfa2-49c8-97a4-34bbeb30557c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-13 12:55:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	41.53911089527151	f	f1c4bfbd-0a8c-4992-bfe0-796e7011767d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-13 08:06:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	20.702421465917475	f	00dbeace-a0bd-479b-bd09-037845064141	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-13 11:02:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	5.804720885209813	f	c3cc793c-3ff9-4283-b972-b30dadb46850	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-13 12:09:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	7.541766834438863	f	b72d460e-4344-45d9-838f-43cd4c08f216	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-13 07:34:55.926889+00	no_cap	Medium	t	placeholder.jpg	\N	22.286324560952334	t	20c61774-2adb-49e0-bd6a-bc2604fa5be3	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-13 20:25:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	7.645161980552457	t	1f2f4229-91c3-4af2-91f3-54ed121dc6cf	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-13 10:28:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	25.552961088408537	f	da4d4627-7a02-4171-9b93-5ffd68d1d321	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-13 19:53:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	52.18774486628482	f	e31aba27-5cf7-4353-af95-31a0a366af43	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-13 19:57:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	18.889732923114842	f	6613c8a3-6387-40e0-b5b5-a34875a98ee7	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-13 09:20:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	53.15366567738241	f	be0f4f7a-b047-46d7-921a-e0982ab414bf	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-13 17:08:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	20.34706762754385	f	0fe74b22-f407-4187-a9d9-f244e32eb1b9	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-13 11:15:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	58.94176453260549	f	fdbfc37b-f439-4543-ac99-7b913cabca34	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-13 16:02:55.926889+00	no_cap	Medium	t	placeholder.jpg	\N	39.651445676067496	t	87dce406-46f0-4f0e-8783-0e98616fc9b4	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-13 19:25:55.926889+00	no_medical_coat	High	t	placeholder.jpg	\N	27.915949561078264	f	1c711a23-1710-44c9-8739-07ab9fa5567c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-13 10:22:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	54.2955248774577	f	4c50ca25-db18-47b4-b5df-a06265c96baf	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-13 18:12:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	42.94111170493434	t	259e9827-55ec-4e1e-b12d-094f71290b09	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-13 14:20:55.926889+00	no_cap	Medium	t	placeholder.jpg	\N	50.92412470762031	t	ec660c2d-ae8f-49d7-830d-f9ba36cca9f1	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-13 16:08:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	17.42056596976384	f	95318e12-6373-493b-aacd-ec85aad99d17	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-13 13:27:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	26.408611409198816	f	4581a932-806c-4e8f-9291-6528a8f00aaa	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-13 07:19:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	41.02219509817861	f	6ed2d087-100a-49f6-9b2b-eab966f87e00	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-13 11:53:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	31.65294539847969	t	89b59af0-c5c7-41a1-931d-551ffb3324bb	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-13 19:43:55.926889+00	no_gloves	Critical	t	placeholder.jpg	\N	59.64685209030066	f	c2cccdd6-7c75-4849-b3bb-bb5eb6a14c92	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-13 10:55:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	33.86064149733764	f	7d33ddf8-4020-4fb2-80ab-d58d21f528bf	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-13 18:08:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	50.9499458743214	t	7a8c1bed-4897-4688-9b76-e5e35d9d31f0	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-13 19:10:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	35.87268916293189	t	7c2aa9e1-6803-4fe3-87f5-a8582f4416ba	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-12 19:46:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	50.50354424434537	t	31777b26-022b-4d0f-b91c-585ae53ce8ba	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-12 20:43:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	27.842064238635167	f	4601b296-834f-4262-a494-8822a0efbf7e	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-12 07:38:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	7.11897811471928	f	58963585-d6a7-426d-8d0e-734933903481	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-12 12:29:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	36.16536656256129	t	d924d04b-7a7b-4ba4-84e3-c1e8d793bb33	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-12 09:14:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	14.811573878914604	t	c78f0a2a-1a7e-4064-9256-af986db3a026	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-12 20:27:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	45.62237761419257	t	da082305-0eda-48e9-8fdf-f0a413ad2ff2	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-12 17:50:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	7.731404815066599	t	a8a0442f-24a5-4e3d-8e1e-14c7be3c079b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-12 18:34:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	47.210526021438156	f	395a6c1e-355c-43f2-80dd-c92940c6594c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-12 17:49:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	34.46199034193346	t	8373f6c4-969c-4ed5-b489-5e2074138dcb	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-12 08:03:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	9.476386631939892	f	8a89356f-7538-4f1f-a3b5-5088a124ac41	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-12 13:44:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	38.435857522412114	t	29b38ab3-084a-4565-a705-2e8eaa626771	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-12 08:00:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	52.587364338877734	f	1b7e0a85-93fe-438e-bca7-9af2e9b31742	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-12 08:47:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	15.522728270937383	f	3e068533-7a4d-47fa-90bb-ccb567554d20	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-12 20:06:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	26.68483146089319	t	3430e621-52be-4880-9d53-730cb8fe806b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-12 17:18:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	14.228293900332146	f	d8efac63-1004-4f9c-9e14-d32538233bd2	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-12 15:13:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	17.65245001114637	t	05dbe8a6-31ca-4752-aaeb-fe9953f15494	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-12 13:14:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	49.88028888088063	t	e5b22f0b-1c5b-4750-974c-da706445c702	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-12 13:01:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	34.76568010658673	t	449464f5-f5f7-4635-8e42-818e376b08d2	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-12 11:03:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	16.71890149914004	f	85f18ea9-c3dd-42df-81dd-daf05c603daf	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-12 14:52:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	21.76864766010877	t	7b5c8677-32de-4c70-8558-9c208ae77657	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-12 18:20:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	30.9425795954993	t	297a2479-33b2-499f-8380-1cbd1521d6da	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-12 11:54:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	45.38208789860067	t	86a21682-4d8d-40ca-8591-8334d6b254b0	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-12 11:56:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	46.06748777398683	f	26bb9e00-648a-41ad-82fb-4b0d9ddc3f87	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-12 09:29:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	29.107351764086765	t	ec17a23e-6b3f-4598-ba48-4be543b22a75	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-12 13:15:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	56.75298259570897	t	92c9afe3-1309-4f82-86aa-778b4025d9f1	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-12 19:02:55.926889+00	smoking	Critical	t	placeholder.jpg	\N	37.338136265483705	t	14549e27-4000-464b-adda-5950b4c01695	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-12 20:46:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	39.651434085958186	t	e7afbc38-5e31-4d4b-a05b-153f628acd19	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-12 20:13:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	34.59603711934248	f	628bba41-ffc0-4382-8121-754709cb8f6a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-11 08:42:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	7.918684562462835	f	87cbed25-d3cd-482c-809e-b4aaf60e7d53	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-11 14:28:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	53.6163189890625	f	a2e1a7fe-4318-4fd9-9920-a888f1d8fbae	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-11 08:06:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	7.972144818777052	f	00887cb0-b32e-4dd5-b243-ce25d187a988	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-11 18:09:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	24.10214227807011	t	016edf8b-fa5a-45b5-b38f-104261a7a51f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-11 18:25:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	22.670375078673885	t	a7b66eb8-19a1-4bf3-bea1-b5d6547dbb55	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-11 07:29:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	40.64956273825377	f	2f284ff2-4d58-4194-8a94-a57c54e23751	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-11 18:45:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	15.03901111780195	t	0bc1be79-f229-41d7-8d13-85bd9283743f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-11 08:55:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	40.72429128189837	t	fd6ca499-d430-495d-bba5-4aa4160f5dc6	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-11 19:12:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	39.64671645725286	t	1681e80c-d3e6-474e-a09a-0e728b5cc17b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-11 20:17:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	7.390482025460317	t	47bd4360-848c-4bad-9f33-9519f9e5c239	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-11 19:47:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	50.602161284637084	t	e7c21df4-13bd-4602-a71c-b435430e3119	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-11 20:51:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	48.95506317480783	t	6ac50c4d-7730-4999-ab20-7fe1628ef4db	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-11 14:55:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	29.050354111505715	t	0597fb2d-7af1-485a-9015-e1574390e171	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-11 07:49:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	49.70792652965704	t	2ac20520-8435-4ece-8802-e1204a64b617	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-11 20:18:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	27.85047963221971	f	1f76d97e-8218-485d-8657-ac7471f38cf2	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-11 13:24:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	49.594005599567986	t	44847e65-5a93-4d1a-9589-a2d2523e1846	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-11 15:40:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	57.33396344463826	f	ca40d893-f9d7-499e-8e8a-61a45c325e97	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-11 19:16:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	28.194625357021817	t	bf88e540-29af-4ca0-bcde-83433305a8b4	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-11 13:23:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	34.159781420264686	f	5e25e0a6-178f-41ec-90ad-75172bee1a45	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-11 10:47:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	55.19288332957403	t	4dc08df3-eb2b-403b-9f4c-1e148fab1a19	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-11 15:20:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	27.737477724231173	t	cdfdfe3a-c6a0-4cf1-b8b6-960b472269b5	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-11 17:27:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	6.615871211434037	t	c5b61b94-8f90-40f1-82f1-b221856113ca	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-11 11:36:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	46.86814570170156	t	3274523f-f5aa-4b0d-8fb2-4107d8ac2cff	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-11 09:37:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	38.188028903103316	t	5654b6fd-09c3-4ee7-9a5e-2fe3dd4be0ad	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-11 14:55:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	29.74533885798408	f	18f5017f-49c8-482a-ad67-33ece75afc78	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-11 10:00:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	44.91985317679937	t	0667977d-3036-4ab9-88db-32a784eeb647	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-10 19:52:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	18.8370828956737	f	128bcbc6-bc4b-495a-9b46-c02f4afbe271	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-10 20:54:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	12.383005600413533	t	bfced039-7ee0-49d1-b4e1-61e52d96c1be	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-10 18:36:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	58.81832324397842	f	9d408f24-52c1-4eae-a99c-c8b5e2e7284b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-10 16:48:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	51.03050855623755	f	a2536069-806c-4191-a46c-4c078af5d9e8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-10 14:30:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	20.268390605732318	f	6df36912-325c-4450-8db4-966cee8bb57c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-10 12:38:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	51.78425006239787	t	ed17000f-03c6-4bbb-bbd4-454fadf4c70d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-10 20:42:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	24.516323287663877	f	5f6659cc-0a50-4b2f-bdde-7d5903da78b0	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-10 10:34:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	39.573611646137294	t	3c52e03d-e558-4f98-b645-c22abda2cc57	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-10 09:56:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	58.670504483511785	f	a3859e71-804e-4c8f-ac06-6549fcd6f812	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-10 18:42:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	49.718993758848114	f	3123fda9-8970-4389-b13f-3a65650ecfbe	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-10 11:49:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	26.11680878111829	t	3ef2845f-9b66-446a-a03b-6c290742045b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-10 14:05:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	56.61117254889104	t	5620b3f1-a35c-4d90-a61f-de80ab8f97fd	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-10 07:06:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	29.59796194890261	f	02eec216-10b2-46cb-bfe6-ba734e860ffe	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-10 10:27:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	35.37663067780612	t	2b2b28ad-427a-4925-be16-26454f763701	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-10 16:24:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	43.109046182356266	t	0f78ff36-b7d5-4b6b-a60e-8b40351002bb	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-09 12:08:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	25.617155561841987	t	587a6e43-a680-43e0-9a53-11a39e9ee8aa	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-09 07:48:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	8.2734932059474	f	e1d5961f-ff78-4aef-87c0-683319e54734	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-09 12:30:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	52.57689220128924	t	d82dcd5c-8de9-49c8-96fc-1bd770047bbd	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-09 18:17:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	55.80269907500276	f	9c7543bb-274a-4d75-95ab-8566577172aa	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-09 08:16:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	19.75533019732758	t	ef6f32d1-9e94-4eb9-acc9-0d3eed389b08	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-09 19:55:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	14.910301676789736	t	e3b0c0e9-be1d-4d20-be6d-9eb316c1c3cb	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-09 13:44:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	55.825134368769014	t	4fa74267-7854-489b-8232-55486f2ecb10	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-09 13:18:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	37.80452239339184	t	a50027d1-dfe4-40df-984a-92e2a290e282	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-09 20:10:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	39.59668176729533	f	72915a20-3a01-4b1a-a511-5bffda1797c9	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-09 16:00:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	9.610992471697404	t	ef579c5e-0104-49c7-a2be-d3452db0ea7b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-09 08:54:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	46.36212639032644	t	0cf02c4c-707b-4077-8849-997cd2d7855b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-09 14:57:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	36.16705022481746	t	6f9dd137-5ece-448d-a778-57e874bb4432	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-09 10:18:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	51.739353091795785	f	731d51d7-1aa8-46e4-9212-f4c6a14f93a2	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-09 10:43:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	11.969814874701472	t	e563efa9-1e01-44e0-8cad-90861dfcda45	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-09 15:27:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	50.19103516171688	t	9b3df8ff-15fc-467d-a818-f0244adfdd97	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-09 13:15:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	57.91449030837087	t	353b2dbb-57e7-47d6-81cf-dcc74180dd91	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-09 14:38:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	29.70640567833189	t	b4297ed5-341f-4325-8dfd-0839019ee849	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-09 14:25:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	26.113197677673643	t	bc034dbe-7a31-4bad-b70e-26c990a8d7ff	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-09 14:44:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	10.142943578427912	f	f87c36e4-cfc3-4a00-996f-d40338f714e0	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-09 08:10:55.926889+00	smoking	Critical	t	placeholder.jpg	\N	40.68961546049635	f	cf94806d-3e75-4df9-9661-33e1c1a18e99	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-09 17:59:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	5.949513843127713	f	8ba2ef72-f86f-4646-97b1-1c2b5b7063dc	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-09 18:43:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	27.714953979437304	t	b6388e19-344d-460e-88bc-71824fe3275a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-09 08:36:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	55.356726958691084	f	e217d352-395f-40e3-a80d-c8dee4e2ee78	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-09 16:04:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	22.858416357210515	t	baf191b2-5f2f-4bdd-8af5-248ebac7fde9	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-09 17:05:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	11.219079508990855	f	e7be257b-4f3d-4efb-a4b1-0b3c703c49e6	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-09 19:39:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	57.24067689372663	t	ff449215-2aaa-4f1b-96fc-1aee80d3c222	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-09 10:07:55.926889+00	no_cap	Medium	t	placeholder.jpg	\N	26.861831463541417	f	5dd400b9-9923-4643-9b79-b1576012eb53	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-09 20:38:55.926889+00	no_cap	Medium	t	placeholder.jpg	\N	28.599941194895266	t	7565aa20-fbe1-4480-a19f-47ed2c36b7f6	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-09 11:04:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	23.2073736090193	f	9c72210e-d47d-4f88-93a4-1acb596dbcb2	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-08 19:52:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	31.653852551027242	f	64dbd4a6-2365-4222-aa0a-9490a70a3a9c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-08 11:43:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	35.4557103095914	f	34f43a2a-4542-45ed-84d3-d8d6b3f28cb4	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-08 10:52:55.926889+00	no_mask	Critical	t	placeholder.jpg	\N	29.39388751649359	f	da1c0214-293c-4e2e-be8f-aad6458bb9ba	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-08 09:44:55.926889+00	smoking	Critical	t	placeholder.jpg	\N	53.568321012458355	t	ffc648be-ea8a-4f60-9640-c525f21c875d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-08 09:19:55.926889+00	no_gloves	Critical	t	placeholder.jpg	\N	10.818678946544248	t	2661adea-3451-4ac7-bb14-a55bdb8a839e	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-08 09:04:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	44.58969662262131	t	e1b015ad-0247-4959-afc5-8a9c38992740	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-08 12:10:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	9.567765285999034	f	be84d224-bbc4-44a7-82f4-dd173bedb89f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-08 08:32:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	51.48486536650223	f	c84a9111-a161-48af-8208-707a3db9b680	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-08 07:07:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	34.51125676579717	f	9aff1b4b-f9ef-40e5-bc38-e46c00f95642	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-08 15:55:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	50.663937684877816	t	8991e729-e325-45c9-b1fc-f36265afeb68	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-08 13:02:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	42.24723493371969	f	52661130-11e5-4cd2-b98f-4f0061482095	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-08 20:57:55.926889+00	smoking	Critical	t	placeholder.jpg	\N	44.9242939828513	t	dc025bfb-f38d-49d2-80fc-b13539786787	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-08 17:53:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	16.830470064497195	t	727be2ba-a586-4c0e-b70e-6b0315e090aa	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-08 19:41:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	50.482840885963334	t	b09449a7-5023-42f6-b150-76394e0aec6e	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-08 14:54:55.926889+00	no_mask	Critical	t	placeholder.jpg	\N	31.06450358700634	f	2cf76503-30be-46ef-97d6-72141b7f2026	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-08 11:13:55.926889+00	no_gloves	Critical	t	placeholder.jpg	\N	21.58544410331768	f	9c72b678-05ff-4cc8-8148-b84ef1b47460	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-08 15:35:55.926889+00	no_mask	Critical	t	placeholder.jpg	\N	41.91384771249809	t	0ec8046e-a382-49fb-adf7-c1d1a2ca7f68	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-08 10:37:55.926889+00	smoking	Critical	t	placeholder.jpg	\N	28.597414291870294	t	8c969d84-552a-4c01-8de7-2a7bb7a638af	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-08 14:23:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	16.338168860001367	t	1a64096a-dee3-47e9-9a8c-c0d0cc793fb4	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-08 08:54:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	45.46351070231245	f	58051aa9-3fc9-483f-a50a-6b6e2857146b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-08 10:34:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	11.762663203321683	f	0052c9c5-a0f7-4b44-a957-1c3bf9642d2d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-08 14:07:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	22.283792332133896	t	e7c4e8e6-7cda-4187-88fc-648369fb81ab	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-08 09:54:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	44.799975829054205	t	cb7d4654-ac5b-4ec1-88af-d156af493fc1	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-07 10:31:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	33.97929544895982	f	e79fe6ea-8f91-4522-a17c-34a9bb61c4e3	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-07 10:57:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	45.664155911038705	f	fa67122e-6c8c-483a-a2c5-308644dddf61	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-07 07:14:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	7.622866323213249	f	3bac49c3-a654-4782-8f10-ceb18caa077b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-07 12:02:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	9.933684636144257	f	bb49a469-cf5e-4698-9a9d-3f62da57d1b7	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-07 19:15:55.926889+00	no_mask	Critical	t	placeholder.jpg	\N	43.16894288354129	f	02e4381e-1a2f-43c2-9e95-c180e5f0cf0f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-07 20:18:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	24.67720628685065	t	7c1128f3-b739-4c19-8f76-931503d56cd3	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-07 12:12:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	28.684633217252795	f	e9ba8f69-efb0-4972-ba0c-559073a22e24	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-07 15:50:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	35.56688796269681	f	b8008d80-2587-49c5-9aac-4a2012380ffe	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-07 09:06:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	24.490731795490227	f	e6372658-796f-4ea3-95c7-c84b29cb5542	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-07 14:48:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	54.46380400557469	t	b3000991-59fe-4b03-8511-afeb330d4cbd	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-07 14:42:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	6.387170564179172	f	f1ca1263-3530-4a40-a51b-d8b46114c10b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-07 09:45:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	48.29683430136476	f	3ea48233-e498-4c4f-9df1-ee41e2b895d0	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-07 11:52:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	6.613731943433001	t	59f6487e-05d2-4296-a4e7-d49f681c2383	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-07 07:13:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	44.53660011599199	f	b4392f16-b6b3-47a7-987f-d3cdae5d3523	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-07 19:57:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	40.839991308550815	t	07fefccb-35db-4f80-9a89-453ed09f4921	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-07 18:48:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	48.47318501544166	t	da41fd2f-920d-4749-839e-1325cfa84812	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-06 07:13:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	21.72802573837409	t	38d20b9e-c02e-4fa3-ac64-80dfe391bbb6	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-06 19:43:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	24.803255614477074	f	f8ff5c4c-f9d5-41e7-b69c-c5b90150fc9a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-06 16:19:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	20.659078019308907	t	f805f708-2ed4-4939-89f8-6d7f33821a17	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-06 19:31:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	49.52040182488367	t	d1facec9-48a6-42bc-a744-2efdfaa09b07	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-06 17:01:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	21.634139777637714	f	2beca01d-c191-4108-8dde-c5acfb456868	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-06 18:00:55.926889+00	smoking	Critical	t	placeholder.jpg	\N	19.47654492495957	t	80e263d0-4bc2-4fd5-8aaa-3648124280ab	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-06 20:46:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	26.76122395380944	t	c05db567-d0d0-4f04-94a3-ecb0321f0b1d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-06 09:36:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	51.07588113302584	f	5009d61e-fb27-4128-9352-2050f41ecaa9	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-06 10:23:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	14.115805185574569	f	369c2b03-4235-4a46-9711-22fe2d513054	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-06 19:33:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	45.888197789338285	f	8d094252-1e05-45a8-97fa-7ad6e4e3d480	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-06 20:57:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	31.97949293814447	t	7a2f606f-aa2c-455d-bfda-b650e415cad8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-06 12:29:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	11.7983485105719	f	c5dc02fe-afed-4900-a9a8-545eae81ebe0	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-06 19:08:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	40.79591731710077	f	caecc3eb-d0ce-4714-b4f9-4d570b3676a1	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-06 08:07:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	48.276701200387414	f	7ec48435-2971-4ace-8585-6e2a6078ed0b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-06 08:57:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	20.868576840451265	f	5d57ad91-15d7-4053-b1fa-381c59ba76e0	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-06 10:51:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	25.480403775774796	t	574fe50d-edd4-4c97-b98c-d01f2affdf1b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-06 15:43:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	47.28508849754714	t	ed58d4f8-3d4b-4ac3-a1e6-d3d58e2226f8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-06 07:40:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	45.161421681466074	t	986b8d7c-002b-4036-b70f-e2fc1d2fc804	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-06 15:28:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	56.05547758260027	t	9d3c6c10-9097-4e02-8e8a-2690e0399f5f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-06 07:22:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	45.8803404553774	f	550a5a6b-85f6-412d-94de-1b0ee253b80c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-06 12:53:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	16.07030999777441	f	54b525f9-d39d-4297-9023-5beed8a96473	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-06 16:35:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	50.86888135237331	f	a6b12509-d734-45a5-b5b0-e235ea3f8f28	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-06 11:43:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	36.77310844544081	f	9dab4052-3ede-41d4-bfd8-60a3db2fc248	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-06 08:22:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	58.084920968950954	f	e91f9ef6-f287-4162-b760-64873d94441c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-06 08:47:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	24.598732141284298	f	161ae1cb-78e9-4f51-bf03-50b2f69f36f9	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-06 17:10:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	42.36277702589733	f	cf54691f-852f-406a-b7e4-228122259e15	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-06 14:38:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	37.24237698588117	f	65a57de5-013d-4fc4-8428-5f065eb72c60	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-06 10:06:55.926889+00	no_mask	Critical	t	placeholder.jpg	\N	59.6452924362547	f	c6414855-38e6-475f-ad17-867d90c3aa7a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-06 10:19:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	21.304525380026007	t	ed0f22e2-fab2-4506-a0fb-574e26fbfc58	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-05 16:05:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	43.37130144273344	f	0b5fc1c0-5785-49db-94d3-81dc4a00ba71	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-05 07:33:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	37.48564990377491	t	4bd587bc-29fa-4d5d-83f7-4b233befb3bc	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-05 09:48:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	10.557891656154267	f	68e0dd79-f6c9-4586-87ef-75175f961256	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-05 08:46:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	57.299468220119074	t	86712e83-378a-4304-85eb-81dfe2296b75	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-05 19:31:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	40.34672521097311	t	b2d1351a-15da-4e48-94e6-bc8cdd11ddf2	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-05 09:11:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	13.71765800057473	t	2a5f3dd1-7f8a-4a75-8674-ad29ebfa983a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-05 09:57:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	5.521949265722089	f	549411d2-7343-4a7d-869e-dc3316f2f8b3	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-05 14:51:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	48.62846489198653	f	c92fd058-a272-4b4d-8c0e-7434e7bb12fc	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-05 07:01:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	26.076277685811444	t	27e89274-16e1-44ca-961d-25b959aff4a8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-05 12:17:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	53.34857661592723	f	db35bed3-680f-432b-8341-956c34c75626	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-05 19:25:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	45.450132089320476	f	6f00af48-7e18-42e2-a17f-5c5035e33a73	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-05 17:54:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	47.21413225639002	t	c9b93955-4410-4aba-ba66-c94c9d32c1fd	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-05 14:46:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	47.618978480197676	f	df0b3d20-d662-460a-98bf-ba09fc425ae3	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-05 14:26:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	24.342327791123687	f	e18ce568-6b3f-48d2-ae36-1c7abdd768dc	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-05 18:24:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	20.44388777081936	f	4179fa3c-6a80-47a4-8fb1-c8c31050b002	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-05 07:28:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	29.350290301274345	f	3507cd5d-f072-4280-a8d5-25fd4fc316f4	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-04 12:26:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	25.90859881677858	t	b37177d2-345e-4ddb-a425-2d35c90e9438	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-04 18:23:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	38.39647887124706	t	9094df95-31d4-40c6-9754-eee49044ec50	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-04 19:55:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	41.789773059590814	f	297bc7eb-b8fa-48d8-b400-c277a0e7ca5a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-04 08:51:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	23.264768099496234	t	07bffd3c-8ee0-422e-aa8d-b601e26e26ec	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-04 15:09:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	53.51753371959718	f	f6f3de54-9437-4687-bb9f-8843b71199ea	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-04 09:20:55.926889+00	no_gloves	Critical	t	placeholder.jpg	\N	32.3490484749247	f	6dd4ad7e-19cd-453a-89fa-99de882ed94c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-04 15:36:55.926889+00	no_mask	Critical	t	placeholder.jpg	\N	41.79983680440747	t	06f0f1f3-0ef3-4988-bb8b-1657becd326f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-04 10:34:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	10.640113441045944	f	2a20ec40-c267-4a97-89d9-45c7c85ac29a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-04 19:55:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	47.93696849579686	t	1d18825d-b4e0-4806-89ff-b6f1660e5816	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-04 09:18:55.926889+00	no_mask	Critical	t	placeholder.jpg	\N	52.116657609928545	f	b8ebf93b-9685-44bc-87b2-fc13587464aa	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-04 18:02:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	40.74701992372071	t	21e37e71-b4d4-4dcb-a312-5bc3c7daec10	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-04 15:31:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	57.65274459497999	t	d90b0069-f5d2-45cb-bb16-fe9815ae179b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-04 20:33:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	31.892471175781044	t	e82920bb-96bc-4207-98c4-a09d8266b8f7	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-04 18:51:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	37.6633197310348	t	d42a8b11-5370-4162-b45c-44a0c8438728	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-04 19:20:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	12.767582355669418	f	05246a5a-d903-4dee-8bca-6b7af2f7caae	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-04 14:12:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	39.622538771904594	f	a4d81efc-8584-438a-ba2b-c0c5b89cb95f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-04 11:17:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	5.680796558603481	f	e49de4ac-37f3-4c63-b45b-fbe30983948f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-04 10:26:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	24.775448517776855	t	38d91fb8-75c8-4b26-9ec0-2baf3515c54f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-04 12:43:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	57.97141994838282	t	737158eb-7ab4-49fa-8ef4-0a7f8442db02	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-04 14:29:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	34.362432625609145	t	68e328c3-678e-49b4-95f1-68de340fe20e	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-04 17:07:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	56.84982050329755	f	4d0c759a-01b0-4904-80c9-d278dad24a96	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-04 09:33:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	50.75791687210579	f	db5f90e9-fde6-4f32-80ec-12dd7f87aa4e	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-04 16:32:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	52.95006343278722	f	fb02685a-8e05-4e5d-bb09-a4c375ffb9eb	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-04 14:29:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	38.89662979784382	t	57d26bf5-1b32-42c2-a091-a3a80e68f889	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-04 15:28:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	42.021438234458316	t	067957d9-1d1b-4690-a135-97d63f6bf46c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-04 15:50:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	26.18728381766694	t	d75201e9-4ae7-4b96-9e81-90452d0e5bf0	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-03 19:47:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	6.745648758955634	t	71ae108c-3293-4f8b-b3c0-d5776efd01ff	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-03 14:22:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	37.669882130603725	f	9b0c6637-757a-4d7e-ad8e-ee1d505a7d59	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-03 15:01:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	54.04148997894561	t	d71b07d3-e35d-4207-bba3-9dc05201dd2e	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-03 11:59:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	32.86892476574368	f	14ab64cb-3457-4057-85cc-f29e9e3e61fe	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-03 17:44:55.926889+00	no_medical_coat	High	t	placeholder.jpg	\N	20.63080664248728	t	3a4f704a-6a2a-4403-8d2b-c683fc30ab10	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-03 17:18:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	13.805949187008599	f	1aa54eee-8aa5-487e-a7cc-7066b582cad4	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-03 17:59:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	49.01436988035669	f	90e600ad-f237-43b7-b30a-df5bca7ec27a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-03 20:17:55.926889+00	no_gloves	Critical	t	placeholder.jpg	\N	14.379869754883472	t	2cc0e9e0-d77f-47b3-9546-9abd4e5aeeb5	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-03 11:28:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	53.39980621213249	t	a939587d-9468-4f65-a165-702cde634e94	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-03 11:59:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	32.45615009702756	f	c0adfe55-b734-48ea-b853-a5193b86c4a1	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-03 07:13:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	46.31384748347739	f	d0e4e50c-a43f-405c-9df3-70d870e6454f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-03 15:31:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	46.240173317884555	f	e9f5ecc7-1afa-4e1f-9a27-e00a5a86b4e5	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-03 20:14:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	33.9310421528823	f	fb48bd34-ff8b-4c76-9202-2cd194daba9b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-03 16:25:55.926889+00	no_gloves	Critical	t	placeholder.jpg	\N	30.590202582396802	f	c8a691fd-f7b8-484f-925c-6ce8cd0fd098	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-03 08:02:55.926889+00	no_medical_coat	High	t	placeholder.jpg	\N	14.425260150600726	t	3d8aa287-82d2-4589-9770-1224181921cd	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-03 14:37:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	33.024181556064114	t	2f73ae0a-4d19-4f35-b501-c0a9ff12b36b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-03 18:40:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	38.57135355310219	t	ab25e5fa-698c-479a-b015-25c8697fd6c2	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-03 14:22:55.926889+00	no_cap	Medium	t	placeholder.jpg	\N	46.23795095430685	f	e081c917-c2f4-446b-8272-88e6e8043c83	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-03 15:41:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	40.059551010262545	f	f69dece0-8812-40d2-8795-02528c51018f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-03 13:50:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	46.861850056181225	t	c733ef24-176c-44af-96b1-af4301d948ae	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-03 20:18:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	28.239638226405543	t	35c9540c-87ef-479c-a988-18b9a8ae60c0	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-02 15:08:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	35.88383594257975	t	f08ca540-8f56-4ab6-951d-428e6784124c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-02 11:06:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	9.113234267223362	t	9001380b-76ec-43bf-a9b8-dea15932f826	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-02 17:20:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	18.505157573299414	f	f4d39562-442e-433a-a748-2bb802d9b03d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-02 17:28:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	15.580589777661498	t	50742fbc-0d4d-40ef-8cf1-6999873ea039	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-02 18:54:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	46.63153649760935	f	dc2f446c-5937-41e9-a150-a881f519b1b4	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-02 10:44:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	27.232299846449923	f	f48655cb-4ceb-46e1-bf5f-b80e5849a755	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-02 17:12:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	50.76397916769271	t	ce8644a7-c4b9-4563-a06a-d67ad418a88d	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-02 14:31:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	10.494670732454926	t	58dec5bd-ecd9-47bd-a1c3-8eea3da355b0	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-02 18:36:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	30.74480251776101	f	f17c2e35-f534-4bc7-b2ca-7f458475c834	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-02 07:10:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	50.68502792757185	f	c67645ec-cf65-4406-a51a-6f44872ce2e0	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-02 16:02:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	18.6850524660289	f	149a6ab7-5a16-4aff-88f4-72dbabf863f3	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-02 14:29:55.926889+00	no_mask	Critical	t	placeholder.jpg	\N	18.02473221563715	t	57cc38f8-66d1-4900-9b2e-c80917307e58	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-02 20:27:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	22.512295518826846	t	5c6db1cd-eadb-4568-9adf-08f39059cdd7	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-02 14:16:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	5.174132126666592	f	44609b35-44c4-4267-8f5c-1803df90f133	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-02 15:20:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	37.75625959035287	f	9424d477-a8bc-4ec8-a5b8-37ec981506d7	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-02 12:16:55.926889+00	no_cap	Medium	t	placeholder.jpg	\N	26.683945016621784	f	a9ad8fe0-47a3-4a47-a5b3-fd8f7ce573f5	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-02 16:14:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	12.136210675966856	t	e8aa1b90-3b95-4578-b7be-5e4eb19ae3e2	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-02 14:21:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	11.62126890637639	f	58a3e722-ac6b-4aef-aacc-9ad80cd667da	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-02 08:25:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	29.379229333453463	f	d92e920a-bac1-47b2-86e8-2861eda7db43	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-02 17:32:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	40.44984099753647	t	c6315563-2a5d-4961-994d-87cf591d0a0a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-02 16:58:55.926889+00	no_gloves	Critical	t	placeholder.jpg	\N	14.579532931516958	t	6f40bfd0-78cc-4945-a6a0-136901b90ea4	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-02 15:37:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	17.239181324047294	t	aca5eca6-4e35-48e7-8c9d-e1e49af44403	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-02 10:53:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	32.88216883571141	t	164915d0-b488-4f5c-ab8e-bfea1fc1035f	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-02 13:08:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	30.677355944959807	f	6bac69b7-001e-4f85-b699-ce49794ec621	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-02 08:58:55.926889+00	smoking	Critical	t	placeholder.jpg	\N	59.02042595789667	t	a99fef80-e442-4ad8-8640-5450a53e68cd	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-02 07:32:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	38.66579641901575	f	fc20eef2-d930-4e8e-921a-e798bb9f8645	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-02 18:46:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	27.099781679285478	f	3f1f5813-18a3-4e13-8461-3f04d9a5b9f8	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-02 08:23:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	15.093089968624849	f	35ab420d-3685-431c-ad7c-f0771bd3f386	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-01 16:53:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	38.33397487622236	f	0874a670-a3ac-4d0f-8974-38108aa3c207	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-01 20:39:55.926889+00	no_gloves	Critical	t	placeholder.jpg	\N	30.654600505288006	t	5e4d276c-b1c4-409a-bf9c-20e89e4124db	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-01 10:38:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	28.812101898094593	t	8d881823-f877-4ed8-8510-278347d8ebbe	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-01-01 12:27:55.926889+00	no_cap	Medium	f	placeholder.jpg	\N	5.783520416033076	f	ada675f2-c31c-429d-b2a9-8eea151af4d7	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-01 12:35:55.926889+00	no_mask	Critical	t	placeholder.jpg	\N	37.43577548946485	t	af83c9fe-f1f6-4887-9c59-37c63c536ace	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-01 10:19:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	51.62443387246372	f	399af8aa-1f12-47c1-b959-34d13238bf7e	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-01 14:41:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	43.749068857221914	t	23881f1a-3738-4383-9362-19eabcbbc0af	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-01 08:29:55.926889+00	no_mask	Critical	f	placeholder.jpg	\N	37.561666398329315	f	baf885c2-3f75-4a39-8a48-49e99fb764a4	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-01-01 11:19:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	49.153639862867465	t	19901176-fc39-466b-9f50-85259c3d7707	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-01 14:35:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	18.02553190481573	t	76c26a96-381d-42e9-b6d6-3586056069e1	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-01 16:25:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	20.983694421197292	t	d11e5e83-ebed-44c3-bdf3-ee5955df408a	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-01 10:03:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	36.27373478758473	t	671f108d-56e7-4575-8711-52895a5b7ddf	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-01 17:31:55.926889+00	smoking	Critical	f	placeholder.jpg	\N	43.237998832807676	f	7af85d96-4a5d-4efb-b4d8-78d460aa3a85	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-01-01 09:38:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	51.655468196340884	t	35bc678f-a437-48d5-8b07-ece286f3f779	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-01 14:59:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	55.08826885594214	t	2ecc4662-01be-444d-8900-66b84f11649b	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-01-01 13:18:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	17.81176678482727	t	87e85d4e-096b-4872-9e1f-d75027421c7c	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-01 07:58:55.926889+00	no_medical_coat	High	f	placeholder.jpg	\N	11.130405728014525	f	cca2a1ba-3db2-4b6a-bf07-cd66c644cde5	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-01 13:40:55.926889+00	no_medical_coat	High	t	placeholder.jpg	\N	16.9131494161116	f	71592860-6435-47a8-8753-bcf044a93832	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-01 16:34:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	46.2130176597869	f	d4a373ca-fb6f-4d72-b4bf-22c3d56cb4ca	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-01-01 10:23:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	47.537400164825385	t	ec06f056-d6f9-4ad6-acbe-530ad06eddce	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-01-01 16:32:55.926889+00	smoking	Critical	t	placeholder.jpg	\N	24.430270931876464	f	35d7757a-e1ce-4dab-a14f-5b0978f45458	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-01-01 12:31:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	17.739958759559915	f	6d697bdc-06de-4630-a9c8-5aeb291a7924	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-01-01 08:29:55.926889+00	no_gloves	Critical	f	placeholder.jpg	\N	32.19593849534577	f	c5a79dcc-77f4-458d-b07f-4b6c70457cb5	2026-01-30 17:46:53.343632+00	2026-01-30 17:46:53.343632+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-31 18:01:20.921867+00	phone_usage	Medium	f	violation_13f24359-d31b-41ce-8682-a6cce71a9449.jpg	\N	0	f	9cc649e6-336f-49ae-8fbc-5c38df9777aa	2026-01-31 18:01:20.907509+00	2026-01-31 18:01:20.907509+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-01-31 18:01:26.045018+00	phone_usage	Medium	f	violation_bbb98ddc-9f13-4942-81b5-2d41abd8eb25.jpg	\N	0	f	e3e70dd4-766a-46ae-8e02-0a9ec39d6305	2026-01-31 18:01:25.994571+00	2026-01-31 18:01:25.994571+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-02-21 18:19:37.394213+00	phone_usage	Medium	f	violation_5f0aa002-4ff9-4625-9d8c-03aeecdac4da.jpg	\N	0	f	7038ed6e-626f-432f-ab2e-68d4244a17a6	2026-02-21 18:19:37.36519+00	2026-02-21 18:19:37.36519+00
2622624a-ee97-4b4f-be18-48653e70aca4	5af0abd4-ee8d-44f4-aca1-3a4846ff74e4	2026-02-24 21:39:43.105566+00	missing_person	Medium	f	violation_83b145ee-3456-49a2-8464-98d7fabfde05.jpg	\N	0	f	c4d24990-ee92-4b29-9098-0ce27b8efa1a	2026-02-24 21:39:43.092467+00	2026-02-24 21:39:43.092467+00
2622624a-ee97-4b4f-be18-48653e70aca4	5af0abd4-ee8d-44f4-aca1-3a4846ff74e4	2026-02-24 21:39:48.252118+00	missing_person	Medium	f	violation_169f6da0-d844-40e8-8509-ea0fffdc543c.jpg	\N	0	f	a24ca95b-1210-488e-9bf4-e572a07fa868	2026-02-24 21:39:48.244919+00	2026-02-24 21:39:48.244919+00
2622624a-ee97-4b4f-be18-48653e70aca4	5af0abd4-ee8d-44f4-aca1-3a4846ff74e4	2026-02-24 21:44:19.101217+00	missing_person	Medium	f	violation_2cf44522-5489-4fdd-a838-6d6e8b0494e7.jpg	\N	0	f	9f6a18d5-9c6e-4008-8df4-a6f77722bb77	2026-02-24 21:44:19.077994+00	2026-02-24 21:44:19.077994+00
2622624a-ee97-4b4f-be18-48653e70aca4	5af0abd4-ee8d-44f4-aca1-3a4846ff74e4	2026-02-24 21:45:49.778494+00	person	Medium	f	violation_041bed72-3677-4506-ae44-aebcfdef451a.jpg	\N	0	f	1d1493d9-3d25-4e2c-b648-b81b001888f1	2026-02-24 21:45:49.765885+00	2026-02-24 21:45:49.765885+00
2622624a-ee97-4b4f-be18-48653e70aca4	5af0abd4-ee8d-44f4-aca1-3a4846ff74e4	2026-02-24 22:44:32.079356+00	missing_person	Medium	f	violation_deef425a-f0a5-454c-9baf-16b71093e09f.jpg	\N	0	f	b78dcdad-ee3b-42c8-ba69-c5e543fe7a8c	2026-02-24 22:44:32.065199+00	2026-02-24 22:44:32.065199+00
2622624a-ee97-4b4f-be18-48653e70aca4	5af0abd4-ee8d-44f4-aca1-3a4846ff74e4	2026-02-24 22:45:46.214101+00	person	Medium	f	violation_77c19f67-9ed1-4f48-a827-28cd7fad71f0.jpg	\N	0	f	faca0270-e013-4e4e-a960-67c19054a74b	2026-02-24 22:45:46.179467+00	2026-02-24 22:45:46.179467+00
2622624a-ee97-4b4f-be18-48653e70aca4	5af0abd4-ee8d-44f4-aca1-3a4846ff74e4	2026-03-07 09:13:32.273176+00	person	Medium	f	violation_f5e38ee7-ec0c-41c4-8b0a-5ed697cf90db.jpg	\N	0	f	c20f4e81-00b6-404f-93df-0abfa83efeea	2026-03-07 09:13:32.25333+00	2026-03-07 09:13:32.25333+00
2622624a-ee97-4b4f-be18-48653e70aca4	5af0abd4-ee8d-44f4-aca1-3a4846ff74e4	2026-03-07 09:17:26.944798+00	missing_person	Medium	f	violation_17edd081-8c92-4b1e-8d34-5be4855e3a56.jpg	\N	0	f	00f3c78b-6939-4101-b87a-8069a5f4d1fd	2026-03-07 09:17:26.920053+00	2026-03-07 09:17:26.920053+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-03-08 06:07:15.456191+00	no_gloves	Critical	f	placeholder.jpg	track_today_3796	38.484463544658254	f	4ccd19cd-5ece-4077-82ff-809328182f6c	2026-03-08 17:52:14.45+00	2026-03-08 17:52:14.45+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-03-08 04:06:48.456191+00	smoking	High	f	placeholder.jpg	track_today_7152	18.1490278736715	f	80886156-76e6-43ea-b574-99b12a394e16	2026-03-08 17:52:14.45+00	2026-03-08 17:52:14.45+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-03-08 08:08:52.456191+00	smoking	Low	f	placeholder.jpg	track_today_2049	40.12802922248107	t	fea95037-f9ba-47e9-bf65-5262ad8a1abd	2026-03-08 17:52:14.45+00	2026-03-08 17:52:14.45+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-03-08 09:51:04.456191+00	no_mask	Low	f	placeholder.jpg	track_today_3750	44.78823113925093	f	65e5e1ed-a4fc-43aa-86cf-8797eff29f2f	2026-03-08 17:52:14.45+00	2026-03-08 17:52:14.45+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-03-08 11:37:24.456191+00	smoking	Critical	f	placeholder.jpg	track_today_9700	36.82593216141127	t	45ec8593-6c55-4c80-bd8a-f1e4d91838c0	2026-03-08 17:52:14.45+00	2026-03-08 17:52:14.45+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-03-08 05:35:24.456191+00	no_mask	Critical	f	placeholder.jpg	track_today_2471	6.986174342873041	t	8ac039aa-edfe-48d5-a35e-c068fb133bf4	2026-03-08 17:52:14.45+00	2026-03-08 17:52:14.45+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-03-08 08:21:07.456191+00	no_medical_coat	Critical	f	placeholder.jpg	track_today_7012	25.594389841074804	f	328bc829-0d38-4910-97e4-018f7608d94d	2026-03-08 17:52:14.45+00	2026-03-08 17:52:14.45+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-03-08 08:25:44.456191+00	no_cap	Low	f	placeholder.jpg	track_today_6065	6.073017764316584	t	fde0d093-4814-43f6-9063-2cf0872b9ec6	2026-03-08 17:52:14.45+00	2026-03-08 17:52:14.45+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-03-08 17:50:34.456191+00	no_medical_coat	Medium	f	placeholder.jpg	track_today_8095	23.666736766759456	t	5c14edc0-51af-44a5-b30a-5540828d7d43	2026-03-08 17:52:14.45+00	2026-03-08 17:52:14.45+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-03-08 09:21:07.456191+00	no_mask	Critical	f	placeholder.jpg	track_today_3842	25.287561296220815	t	b671d31b-ead0-422f-8485-55e33d88feda	2026-03-08 17:52:14.45+00	2026-03-08 17:52:14.45+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-03-08 05:43:36.456191+00	no_medical_coat	Medium	f	placeholder.jpg	track_today_8815	25.076754335587687	t	75750e84-e47e-4369-9e3a-22b7a2b8642d	2026-03-08 17:52:14.45+00	2026-03-08 17:52:14.45+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-03-08 17:37:24.456191+00	smoking	Low	f	placeholder.jpg	track_today_6993	16.714270318045543	t	c77a8715-e7e9-4720-9edc-6102d473eea9	2026-03-08 17:52:14.45+00	2026-03-08 17:52:14.45+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-03-08 00:02:28.456191+00	no_gloves	Medium	t	placeholder.jpg	track_today_2212	38.60098287457164	t	50d8168f-e5ee-403b-845c-cd489606660c	2026-03-08 17:52:14.45+00	2026-03-08 17:52:14.45+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-03-08 03:37:04.456191+00	no_gloves	High	f	placeholder.jpg	track_today_7093	30.10668514764315	t	ff224b89-b1c5-422e-80db-4fb0e7b82c91	2026-03-08 17:52:14.45+00	2026-03-08 17:52:14.45+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-08 15:24:39.456191+00	smoking	Medium	f	placeholder.jpg	track_today_5837	10.832585667776343	t	10af81e4-a36a-4bea-8a75-7f8d4cd6bd10	2026-03-08 17:52:14.45+00	2026-03-08 17:52:14.45+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-03-08 00:29:10.456191+00	no_gloves	Low	f	placeholder.jpg	track_today_1912	18.69620761398012	t	ce365a41-e477-4e6e-bcde-986ee649e0ae	2026-03-08 17:52:14.45+00	2026-03-08 17:52:14.45+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-03-08 07:22:34.456191+00	no_medical_coat	High	f	placeholder.jpg	track_today_5684	11.318009892928568	t	89be0f1c-e939-4666-b150-8286edbed89c	2026-03-08 17:52:14.45+00	2026-03-08 17:52:14.45+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-03-08 01:49:07.456191+00	smoking	Medium	f	placeholder.jpg	track_today_1627	12.77746351890884	t	32525847-1257-473f-8b7d-e59fdae7562e	2026-03-08 17:52:14.45+00	2026-03-08 17:52:14.45+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-03-08 09:42:23.456191+00	no_cap	Low	f	placeholder.jpg	track_today_5569	31.657497667164897	t	11fc41bc-fa41-4ab7-a48e-5633d22f75e9	2026-03-08 17:52:14.45+00	2026-03-08 17:52:14.45+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-03-08 03:21:02.456191+00	no_cap	High	f	placeholder.jpg	track_today_9770	9.935167246958647	f	2f6efd27-736a-4594-9699-bff2c90a4b7e	2026-03-08 17:52:14.45+00	2026-03-08 17:52:14.45+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-03-08 12:04:18.425687+00	no_mask	High	f	placeholder.jpg	track_today_8516	16.63409256231082	f	3d54a026-1577-4ddf-8496-e1a059189270	2026-03-08 20:23:08.417521+00	2026-03-08 20:23:08.417521+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-03-08 12:46:46.425687+00	no_cap	Low	f	placeholder.jpg	track_today_2911	18.354250153023116	t	7de1ee01-5017-48d6-aeb8-5a627b46412c	2026-03-08 20:23:08.417521+00	2026-03-08 20:23:08.417521+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-03-08 13:13:39.425687+00	no_medical_coat	Low	f	placeholder.jpg	track_today_7383	39.98649955966121	f	f6b47677-9456-40a1-9ffc-b104b611612e	2026-03-08 20:23:08.417521+00	2026-03-08 20:23:08.417521+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-08 00:31:52.425687+00	no_gloves	Low	f	placeholder.jpg	track_today_3306	22.445639579745762	f	72e43299-aca2-499f-9227-626014f21837	2026-03-08 20:23:08.417521+00	2026-03-08 20:23:08.417521+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-08 17:31:22.425687+00	no_medical_coat	Critical	t	placeholder.jpg	track_today_5541	18.429888886369223	f	fd2493e9-27ad-40f5-9a4c-79ab08422c78	2026-03-08 20:23:08.417521+00	2026-03-08 20:23:08.417521+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-08 07:38:29.425687+00	no_mask	High	f	placeholder.jpg	track_today_8942	25.027346134568607	t	b4ac7bf2-e730-4062-801b-ec675d1024e1	2026-03-08 20:23:08.417521+00	2026-03-08 20:23:08.417521+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-08 18:16:57.425687+00	no_medical_coat	Critical	f	placeholder.jpg	track_today_5317	20.23078400380362	t	a9ad084a-c32c-40b9-bb88-417f788a134a	2026-03-08 20:23:08.417521+00	2026-03-08 20:23:08.417521+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-03-08 04:11:08.425687+00	no_medical_coat	Low	f	placeholder.jpg	track_today_8940	40.45174567750865	f	9818cc12-b054-43df-a14d-1bfd543e9687	2026-03-08 20:23:08.417521+00	2026-03-08 20:23:08.417521+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-08 18:09:14.425687+00	no_mask	Critical	f	placeholder.jpg	track_today_8522	2.6879801024572347	t	3cd82431-113c-4b12-afab-aca4c070776b	2026-03-08 20:23:08.417521+00	2026-03-08 20:23:08.417521+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-03-08 14:15:28.425687+00	no_medical_coat	High	f	placeholder.jpg	track_today_8162	4.4986457650095595	t	5d28ff98-e048-457a-aece-3b4e5cc9d130	2026-03-08 20:23:08.417521+00	2026-03-08 20:23:08.417521+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-08 13:50:27.425687+00	no_medical_coat	Medium	f	placeholder.jpg	track_today_4029	17.12819931841891	f	37b6f517-9be0-4b38-9f9f-0d1af843d122	2026-03-08 20:23:08.417521+00	2026-03-08 20:23:08.417521+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-03-08 05:24:24.425687+00	no_cap	Low	t	placeholder.jpg	track_today_9145	17.601126527724993	t	3fafb41d-58eb-4e10-9c37-ec2ccc37bacf	2026-03-08 20:23:08.417521+00	2026-03-08 20:23:08.417521+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-03-08 13:26:29.425687+00	smoking	Medium	f	placeholder.jpg	track_today_6848	36.18685429161419	f	871fbe65-9eff-4154-bcd4-26370d611445	2026-03-08 20:23:08.417521+00	2026-03-08 20:23:08.417521+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-03-08 12:11:51.425687+00	no_gloves	Low	f	placeholder.jpg	track_today_2434	24.398570830355336	f	9f931328-074e-4fae-aa81-c10f6999671c	2026-03-08 20:23:08.417521+00	2026-03-08 20:23:08.417521+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-03-08 18:53:46.425687+00	no_gloves	Critical	f	placeholder.jpg	track_today_3931	35.8601527304639	t	32dbc4b1-faa5-4f8b-bea0-8177d0322749	2026-03-08 20:23:08.417521+00	2026-03-08 20:23:08.417521+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-08 07:50:59.425687+00	no_gloves	Medium	f	placeholder.jpg	track_today_2309	23.946473473283305	f	5b5e2dc9-4372-473a-a3e2-a31176f8b1db	2026-03-08 20:23:08.417521+00	2026-03-08 20:23:08.417521+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-03-08 05:01:17.425687+00	no_cap	Medium	f	placeholder.jpg	track_today_1375	30.81531298669877	t	f50a4932-cdba-4224-b19c-d3fb6d4a6823	2026-03-08 20:23:08.417521+00	2026-03-08 20:23:08.417521+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-03-08 13:43:02.425687+00	no_medical_coat	High	f	placeholder.jpg	track_today_6523	9.279572485423685	f	4aa7d374-66d1-4dcd-91e2-65c83b3aa99d	2026-03-08 20:23:08.417521+00	2026-03-08 20:23:08.417521+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-03-08 14:50:06.425687+00	no_gloves	Medium	f	placeholder.jpg	track_today_9413	20.449404871822946	t	18b862ac-0b47-4d36-8635-10b710cd4b2b	2026-03-08 20:23:08.417521+00	2026-03-08 20:23:08.417521+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-09 04:42:16.857964+00	smoking	Low	f	placeholder.jpg	track_today_1932	17.22895429361771	t	6f762834-044d-456b-bc93-94e73a4a3c64	2026-03-09 17:45:02.796578+00	2026-03-09 17:45:02.796578+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-03-09 00:09:33.857964+00	no_gloves	Critical	f	placeholder.jpg	track_today_3646	12.262718130640838	f	849f7545-d9d7-43fa-92fc-98f1bb20868b	2026-03-09 17:45:02.796578+00	2026-03-09 17:45:02.796578+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-03-09 10:07:38.857964+00	smoking	Medium	f	placeholder.jpg	track_today_4754	23.796087216338634	f	bb8c8e95-246e-4f30-aeb2-017e55e491b3	2026-03-09 17:45:02.796578+00	2026-03-09 17:45:02.796578+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-03-09 08:24:06.857964+00	no_medical_coat	Critical	f	placeholder.jpg	track_today_7919	11.334082719745476	f	82ec329b-2b6a-4344-9e0e-4f137e940a53	2026-03-09 17:45:02.796578+00	2026-03-09 17:45:02.796578+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-03-09 03:03:48.857964+00	smoking	Low	f	placeholder.jpg	track_today_2850	11.48458053956828	f	b6cc1ab6-9d64-4edd-90a3-480c7bc97d5e	2026-03-09 17:45:02.796578+00	2026-03-09 17:45:02.796578+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-09 14:24:44.857964+00	no_gloves	Critical	f	placeholder.jpg	track_today_3782	27.497322406756215	f	588e1fff-fa7c-4f6d-8328-ab23c1f814d7	2026-03-09 17:45:02.796578+00	2026-03-09 17:45:02.796578+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-03-09 00:30:33.857964+00	no_gloves	Low	f	placeholder.jpg	track_today_1213	38.756716198760955	t	5b0634d5-7e50-42b3-a4b0-f63fcfea4d3d	2026-03-09 17:45:02.796578+00	2026-03-09 17:45:02.796578+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-03-09 12:48:44.857964+00	no_cap	Critical	f	placeholder.jpg	track_today_3969	16.445208285918074	t	f8759a1c-63dc-483b-9a77-d39a76096876	2026-03-09 17:45:02.796578+00	2026-03-09 19:25:57.4883+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-09 12:25:17.857964+00	no_cap	Low	t	placeholder.jpg	track_today_6734	20.66088463054002	t	e9bd97f2-964d-42b3-a579-63cfe48463c8	2026-03-09 17:45:02.796578+00	2026-03-10 07:31:02.308996+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-09 14:12:16.857964+00	no_medical_coat	Critical	t	placeholder.jpg	track_today_6293	21.647954998227807	t	8a650908-be60-4703-aedc-a758b9fbea46	2026-03-09 17:45:02.796578+00	2026-03-10 07:29:34.744819+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-03-09 16:05:26.857964+00	no_gloves	High	t	placeholder.jpg	track_today_3085	41.7158299852551	t	39487887-3dac-4c44-accb-35d1835d83dd	2026-03-09 17:45:02.796578+00	2026-03-10 07:30:55.314247+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-03-09 10:01:19.857964+00	no_cap	Medium	t	placeholder.jpg	track_today_3706	16.434527362060475	f	e470e795-2e5f-4a74-9610-1520df0a4ecf	2026-03-09 17:45:02.796578+00	2026-03-10 07:31:10.595208+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-03-09 08:37:52.857964+00	smoking	Medium	t	placeholder.jpg	track_today_9289	10.2642300213085	f	069b2a72-1516-4b77-a83c-fc308d3ef997	2026-03-09 17:45:02.796578+00	2026-03-10 07:31:17.498082+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-09 07:33:58.857964+00	no_gloves	Critical	t	placeholder.jpg	track_today_1047	23.939800845428657	t	e162ee38-c8b7-40c5-a8a3-6bec9c823b98	2026-03-09 17:45:02.796578+00	2026-03-10 07:31:21.025778+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-09 02:51:17.857964+00	no_mask	High	f	placeholder.jpg	track_today_1102	42.42824570775029	t	88203145-6a7a-4930-bfc7-e256210ae89f	2026-03-09 17:45:02.796578+00	2026-03-09 17:45:02.796578+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-03-10 19:13:46.045828+00	no_cap	Low	f	placeholder.jpg	track_today_4335	11.663529346896091	t	f37b379f-1db3-4251-bc87-6084b8d43693	2026-03-10 19:08:02.038666+00	2026-03-11 20:25:45.958413+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-03-10 15:31:50.045828+00	no_medical_coat	Low	t	placeholder.jpg	track_today_2647	11.737792522874484	t	eca86f94-fa6b-4bd3-8924-06dca09353c9	2026-03-10 19:08:02.038666+00	2026-03-11 19:52:30.476825+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-03-10 08:52:31.452949+00	smoking	Critical	f	placeholder.jpg	track_today_5871	3.6193490947483236	t	8cb97a1a-bfd2-4cf2-918d-85a701540df5	2026-03-10 08:51:34.44482+00	2026-03-10 10:09:28.603506+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-03-10 15:38:04.045828+00	no_cap	Low	f	placeholder.jpg	track_today_7024	19.124975803001078	t	305fb234-014a-4b76-96c3-8ba3d82e011d	2026-03-10 19:08:02.038666+00	2026-03-10 19:08:02.038666+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-10 04:11:36.045828+00	no_mask	Medium	f	placeholder.jpg	track_today_7912	24.43248528670282	f	b61ccaed-0580-4dec-82aa-1ecea0b8af82	2026-03-10 19:08:02.038666+00	2026-03-10 19:08:02.038666+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-03-08 19:00:14.425687+00	no_cap	Critical	f	placeholder.jpg	track_today_9921	44.39096034105641	f	7eb010c9-c94d-4a70-a362-879cb017d860	2026-03-08 20:23:08.417521+00	2026-03-09 19:25:25.415638+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-03-09 16:35:44.857964+00	smoking	Medium	t	placeholder.jpg	track_today_1575	20.533378916884026	f	a4f41a8a-a4df-491e-a61a-84cefa5d5330	2026-03-09 17:45:02.796578+00	2026-03-09 19:28:08.69875+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-03-09 16:26:02.857964+00	no_mask	High	t	placeholder.jpg	track_today_8506	36.875722175773305	t	baab3a2c-5800-40b5-a9e4-f966594bc139	2026-03-09 17:45:02.796578+00	2026-03-10 07:30:51.724857+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-03-09 12:18:21.857964+00	no_gloves	Critical	t	placeholder.jpg	track_today_6814	32.72277322380479	t	f1fc3d8b-9704-45d5-a40f-2185acc69021	2026-03-09 17:45:02.796578+00	2026-03-10 07:31:06.5741+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-03-09 09:22:07.857964+00	no_gloves	Low	t	placeholder.jpg	track_today_7066	17.18425712022547	f	4cb809b1-6bcc-435b-ad38-082d10e45697	2026-03-09 17:45:02.796578+00	2026-03-10 07:31:14.066493+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-03-09 06:03:57.857964+00	no_mask	Low	t	placeholder.jpg	track_today_8795	43.448666052197126	f	fe8ee373-d761-4bf3-8726-27fbdd4259a9	2026-03-09 17:45:02.796578+00	2026-03-10 07:31:24.393162+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-03-10 07:24:32.452949+00	no_cap	Critical	f	placeholder.jpg	track_today_2927	16.01867267107749	t	cab431ea-d3c8-4589-bb4a-814f579fc033	2026-03-10 08:51:34.44482+00	2026-03-10 08:51:34.44482+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-03-10 05:34:21.452949+00	smoking	Low	f	placeholder.jpg	track_today_7649	4.877125071035406	t	99689179-a5a7-418d-86d0-2f755db2845f	2026-03-10 08:51:34.44482+00	2026-03-10 08:51:34.44482+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-03-10 00:14:43.452949+00	no_gloves	Medium	f	placeholder.jpg	track_today_3214	13.187512610575	t	8bd2f60a-d72c-47a4-b31f-feb21777c863	2026-03-10 08:51:34.44482+00	2026-03-10 08:51:34.44482+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-03-10 07:39:08.452949+00	no_gloves	Critical	f	placeholder.jpg	track_today_7860	43.35732022692753	t	379f9d1a-8a2b-49e3-8185-64f45d4ad175	2026-03-10 08:51:34.44482+00	2026-03-10 08:51:34.44482+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-03-10 06:14:43.452949+00	no_cap	Low	f	placeholder.jpg	track_today_3895	38.854967459132645	t	b52f8fb2-c7f1-42fb-8d63-448008f92b2b	2026-03-10 08:51:34.44482+00	2026-03-10 08:51:34.44482+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-03-10 07:32:47.452949+00	no_medical_coat	Low	f	placeholder.jpg	track_today_8118	2.2512991081966196	t	bd4e7351-32f5-42d0-9fde-9875794515ea	2026-03-10 08:51:34.44482+00	2026-03-10 08:51:34.44482+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-03-10 01:32:22.452949+00	no_medical_coat	Low	f	placeholder.jpg	track_today_7009	27.134391495072535	f	b5941769-0aad-4eba-adf3-8e2c8ac2d441	2026-03-10 08:51:34.44482+00	2026-03-10 08:51:34.44482+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-03-10 00:41:59.452949+00	no_mask	Critical	f	placeholder.jpg	track_today_6592	41.65661298189764	f	61c66c2f-1608-4092-8537-f771d3653b2d	2026-03-10 08:51:34.44482+00	2026-03-10 08:51:34.44482+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-03-10 06:23:08.452949+00	no_cap	High	f	placeholder.jpg	track_today_1929	4.159388448661883	t	ba00e1c0-8a41-4c9e-94d8-24bd9fae0acb	2026-03-10 08:51:34.44482+00	2026-03-10 08:51:34.44482+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-10 04:26:47.452949+00	no_medical_coat	Low	f	placeholder.jpg	track_today_1236	6.934297277445602	t	2cb7c184-cb77-4833-80aa-40cc287f9e4f	2026-03-10 08:51:34.44482+00	2026-03-10 08:51:34.44482+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-03-10 06:59:50.452949+00	no_cap	Critical	f	placeholder.jpg	track_today_7830	43.42294323305589	t	635ae988-758c-41e2-abb5-5c13a5904f53	2026-03-10 08:51:34.44482+00	2026-03-10 08:51:34.44482+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-10 05:02:04.452949+00	no_medical_coat	Critical	f	placeholder.jpg	track_today_3985	23.369883508302898	t	eb695c1d-0512-4f3d-af70-daaf8479fdc0	2026-03-10 08:51:34.44482+00	2026-03-10 08:51:34.44482+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-03-10 04:06:34.452949+00	smoking	Critical	f	placeholder.jpg	track_today_6326	34.38567460209118	f	20980fdb-e9d2-4398-80ae-f5fc814126d7	2026-03-10 08:51:34.44482+00	2026-03-10 08:51:34.44482+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-03-10 00:24:33.452949+00	no_gloves	Low	f	placeholder.jpg	track_today_4685	27.634381007600815	f	5c7de1c9-44e0-427d-9082-9eb95faf9b00	2026-03-10 08:51:34.44482+00	2026-03-10 08:51:34.44482+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-10 02:37:21.452949+00	no_medical_coat	High	f	placeholder.jpg	track_today_5776	9.318752015303586	t	8c29d81d-436e-4a77-ad1f-1a37c6e7f097	2026-03-10 08:51:34.44482+00	2026-03-10 08:51:34.44482+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-10 08:31:36.452949+00	no_medical_coat	Medium	f	placeholder.jpg	track_today_9780	44.23757689370247	t	4b1d1cf6-1c65-45c7-ba89-c5090cbb096b	2026-03-10 08:51:34.44482+00	2026-03-10 08:51:34.44482+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-03-10 03:42:39.452949+00	no_gloves	Critical	f	placeholder.jpg	track_today_6717	10.692478915863896	f	cf174b76-d105-4492-84e3-47583c960159	2026-03-10 08:51:34.44482+00	2026-03-10 08:51:34.44482+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-03-10 03:27:16.045828+00	no_mask	Medium	f	placeholder.jpg	track_today_7674	16.261398646389424	t	d9993bc5-a3b2-4b2c-bca1-b890f87c3fa1	2026-03-10 19:08:02.038666+00	2026-03-10 19:08:02.038666+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-03-10 11:04:59.045828+00	no_cap	High	f	placeholder.jpg	track_today_5448	30.60771817238829	t	41e8dd48-b388-4276-bfa4-80b3a249912e	2026-03-10 19:08:02.038666+00	2026-03-10 19:08:02.038666+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-03-10 00:25:21.045828+00	no_medical_coat	Critical	f	placeholder.jpg	track_today_2953	15.068884922053547	t	bb8a0363-e02a-4b19-8654-ee1c2cf5a178	2026-03-10 19:08:02.038666+00	2026-03-10 19:08:02.038666+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-10 11:41:17.045828+00	no_cap	High	f	placeholder.jpg	track_today_3953	39.87007364810413	t	f0595220-96d9-497f-ae52-81178d0e8647	2026-03-10 19:08:02.038666+00	2026-03-10 19:08:02.038666+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-03-10 05:03:25.045828+00	no_mask	Low	f	placeholder.jpg	track_today_2586	16.077797692472814	t	207d4839-b3cc-426c-9809-e1b6644fb175	2026-03-10 19:08:02.038666+00	2026-03-10 19:08:02.038666+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-03-10 16:50:53.045828+00	no_medical_coat	Low	t	placeholder.jpg	track_today_2688	10.577088908556703	t	8afce279-a753-468c-8eb9-72820082565d	2026-03-10 19:08:02.038666+00	2026-03-11 20:11:17.032423+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-10 13:18:34.045828+00	no_medical_coat	Critical	f	placeholder.jpg	track_today_9506	21.321604768655376	t	c039416d-0425-4555-b72e-b8e7656d04f9	2026-03-10 19:08:02.038666+00	2026-03-10 19:08:02.038666+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-10 01:24:34.045828+00	no_medical_coat	Medium	f	placeholder.jpg	track_today_7722	22.70103948305444	t	001b9b35-79da-468c-8446-7a7cbd5b418f	2026-03-10 19:08:02.038666+00	2026-03-10 19:08:02.038666+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-03-10 07:54:11.045828+00	no_gloves	High	f	placeholder.jpg	track_today_3792	41.3269792159407	t	8c2e6a57-5777-4d29-b3aa-7749600d5d61	2026-03-10 19:08:02.038666+00	2026-03-10 19:08:02.038666+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-03-10 15:08:00.045828+00	no_medical_coat	Low	f	placeholder.jpg	track_today_6506	17.367050576476863	t	33cc3464-58ff-4136-8b08-cd3f96e86a94	2026-03-10 19:08:02.038666+00	2026-03-11 20:41:19.890262+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-03-10 09:32:01.045828+00	no_mask	High	f	placeholder.jpg	track_today_2015	26.37093970242691	t	62b7d665-1c27-4414-be98-cb83245a16a7	2026-03-10 19:08:02.038666+00	2026-03-11 20:41:31.592954+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-03-10 08:42:42.045828+00	smoking	Low	f	placeholder.jpg	track_today_3374	8.453401079043214	t	97b0b8b0-ca98-4c99-93c6-4641bfac4cc4	2026-03-10 19:08:02.038666+00	2026-03-11 20:41:35.617606+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-03-10 08:14:32.452949+00	smoking	Critical	f	placeholder.jpg	track_today_7541	12.49828868651593	t	87f10f58-3dc6-4fa2-8b31-495e87070d14	2026-03-10 08:51:34.44482+00	2026-03-11 20:41:43.532139+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-10 06:44:53.452949+00	no_mask	High	f	placeholder.jpg	track_today_2030	26.3565948009228	t	d99a26c5-a09d-48af-94f1-757ddf5afc21	2026-03-10 08:51:34.44482+00	2026-03-11 20:41:50.476545+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-03-10 05:11:21.045828+00	no_cap	Medium	f	placeholder.jpg	track_today_7390	6.52308811268756	t	dde8271e-d4fd-4a8c-bd2d-b428747e3e35	2026-03-10 19:08:02.038666+00	2026-03-11 20:42:17.677027+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-03-10 14:49:31.045828+00	no_gloves	Critical	f	placeholder.jpg	track_today_9017	16.630801821873266	t	db1f0111-97fd-45d7-ac59-452d27b57b63	2026-03-10 19:08:02.038666+00	2026-03-10 19:08:02.038666+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-10 05:02:01.045828+00	no_cap	Medium	f	placeholder.jpg	track_today_7353	19.894616520461852	f	4af9d7bc-4a6f-4a9f-a960-3eda61acd54e	2026-03-10 19:08:02.038666+00	2026-03-10 19:08:02.038666+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-03-19 02:43:31.878344+00	book	Medium	f	placeholder.jpg	track_today_6849	22.18393134047288	t	296e3729-d027-4d15-bf26-6f202bd5a0f8	2026-03-19 11:11:46.820895+00	2026-03-19 11:11:46.820895+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-03-19 08:24:58.878344+00	bear	High	t	placeholder.jpg	track_today_3970	23.78250665143736	t	0fea5d88-50fb-411f-b1c6-cd04325ad61f	2026-03-19 11:11:46.820895+00	2026-03-19 11:11:46.820895+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-03-19 04:23:38.878344+00	banana	Critical	f	placeholder.jpg	track_today_1727	13.312792660614246	t	906cf3ba-1de3-44f9-8f0d-76d79718b628	2026-03-19 11:11:46.820895+00	2026-03-19 11:11:46.820895+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-03-10 14:32:04.045828+00	no_cap	Critical	f	placeholder.jpg	track_today_7628	13.195875594980988	t	07a5b57f-9781-4d4a-9a53-c1ccc7437624	2026-03-10 19:08:02.038666+00	2026-03-11 20:52:56.756995+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-17 02:59:32.502827+00	no_medical_coat	Critical	f	placeholder.jpg	track_today_5748	19.115282084685347	f	b52253a7-c247-4d4e-bd35-73f8765024ca	2026-03-17 06:19:54.452383+00	2026-03-17 06:19:54.452383+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-03-17 04:30:21.502827+00	no_mask	Low	f	placeholder.jpg	track_today_9176	27.572612699967703	t	25e0b023-19e1-44e2-aba0-e25f72618ed7	2026-03-17 06:19:54.452383+00	2026-03-17 06:19:54.452383+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-03-17 02:34:21.502827+00	no_mask	Medium	f	placeholder.jpg	track_today_2556	4.925218549459844	t	174b3439-1938-4d02-b0bd-dce902fc581c	2026-03-17 06:19:54.452383+00	2026-03-17 06:19:54.452383+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-17 01:58:21.502827+00	smoking	High	f	placeholder.jpg	track_today_5426	15.900825616569875	t	deffd9c4-8d63-4a69-9bf8-f86151301548	2026-03-17 06:19:54.452383+00	2026-03-17 06:19:54.452383+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-17 01:31:25.502827+00	no_medical_coat	Low	f	placeholder.jpg	track_today_3534	7.643144847418716	t	9b710a5d-ac74-4de7-965e-8695c4b5f2ab	2026-03-17 06:19:54.452383+00	2026-03-17 06:19:54.452383+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-17 06:57:35.502827+00	smoking	High	f	placeholder.jpg	track_today_8283	14.8224371849556	t	0315f3f6-acbc-47cb-b96e-eb6c9d3fb355	2026-03-17 06:19:54.452383+00	2026-03-17 06:19:54.452383+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-03-17 03:47:15.502827+00	no_cap	Low	f	placeholder.jpg	track_today_6341	12.829903865155208	f	10b49f7a-44b0-4535-8118-cadb98999fe1	2026-03-17 06:19:54.452383+00	2026-03-17 06:19:54.452383+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-03-17 05:20:59.502827+00	no_gloves	High	f	placeholder.jpg	track_today_4522	44.71804331838309	f	4f42bfd2-7aa1-480f-9906-1b16377d34a4	2026-03-17 06:19:54.452383+00	2026-03-17 06:19:54.452383+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-03-17 06:16:59.502827+00	smoking	High	t	placeholder.jpg	track_today_2787	31.521623340898095	t	5025ec4c-6a20-4956-9ce3-0d163d89f242	2026-03-17 06:19:54.452383+00	2026-03-17 06:19:54.452383+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-03-17 03:50:40.502827+00	no_mask	Critical	f	placeholder.jpg	track_today_9838	2.6159822580010266	t	b23e36bd-1bd3-4f48-8d95-3149c614f016	2026-03-17 06:19:54.452383+00	2026-03-17 06:19:54.452383+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-17 06:01:57.502827+00	no_gloves	Low	t	placeholder.jpg	track_today_6241	3.7931267459932267	t	d856fbf8-03db-43ef-a20f-1cf47bb52ee3	2026-03-17 06:19:54.452383+00	2026-03-17 06:19:54.452383+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-03-17 05:00:48.502827+00	no_medical_coat	High	f	placeholder.jpg	track_today_3104	21.176662947983264	t	6aab8c4c-b5c3-4763-bff0-5f7659474775	2026-03-17 06:19:54.452383+00	2026-03-17 06:19:54.452383+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-03-17 04:19:05.502827+00	no_mask	Medium	f	placeholder.jpg	track_today_1850	37.472530326415786	t	9a3f4673-a10f-42f4-9f48-cda65097ba97	2026-03-17 06:19:54.452383+00	2026-03-17 06:19:54.452383+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-03-17 03:22:30.502827+00	no_medical_coat	High	f	placeholder.jpg	track_today_8648	33.67695937120294	f	d0605992-f00d-4d85-bcc1-6d344f6ddc18	2026-03-17 06:19:54.452383+00	2026-03-17 06:19:54.452383+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-03-17 00:39:40.502827+00	smoking	Medium	f	placeholder.jpg	track_today_7921	10.71967505976153	f	a9e41b5e-b6ce-40ea-9679-39a184713a0a	2026-03-17 06:19:54.452383+00	2026-03-17 06:19:54.452383+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-03-17 05:42:04.502827+00	no_gloves	Critical	f	placeholder.jpg	track_today_9663	27.844819067135823	t	f1697fd9-e620-4ce8-8d1b-57b63712bf52	2026-03-17 06:19:54.452383+00	2026-03-17 06:19:54.452383+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-03-17 04:45:15.502827+00	smoking	High	f	placeholder.jpg	track_today_9218	19.035341101025473	t	173c0cf3-206e-45d9-bbee-85c9126a3a1a	2026-03-17 06:19:54.452383+00	2026-03-17 06:19:54.452383+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-17 01:58:30.502827+00	smoking	Critical	f	placeholder.jpg	track_today_4978	31.523551423659136	f	c4322f09-2252-4949-9bcd-9ab1d82ca21f	2026-03-17 06:19:54.452383+00	2026-03-17 06:19:54.452383+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-03-17 02:35:34.502827+00	no_mask	Medium	f	placeholder.jpg	track_today_6935	18.701763525155283	t	4afa9a78-2004-4a5c-a25e-e7021b5d9590	2026-03-17 06:19:54.452383+00	2026-03-17 06:19:54.452383+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-03-17 02:17:40.502827+00	no_mask	High	f	placeholder.jpg	track_today_3058	27.18998820109914	f	e059e2d9-ca06-4b35-85e7-21ce2b56058d	2026-03-17 06:19:54.452383+00	2026-03-17 06:19:54.452383+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-03-18 07:16:37.362484+00	no_medical_coat	Medium	f	placeholder.jpg	track_today_5712	12.854785627260751	t	22e5ef5d-0dac-4a6e-8a2e-54df62f1ed24	2026-03-18 12:27:28.328403+00	2026-03-18 12:27:28.328403+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-03-18 08:57:49.362484+00	smoking	Critical	f	placeholder.jpg	track_today_9664	10.853766549352885	f	4c73f242-9d2e-4c42-9b32-83540da3f20f	2026-03-18 12:27:28.328403+00	2026-03-18 12:27:28.328403+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-18 05:29:36.362484+00	no_gloves	Medium	f	placeholder.jpg	track_today_1054	12.663160133506373	f	5e85d6d3-adb6-4ef5-937f-7b69ec55ddad	2026-03-18 12:27:28.328403+00	2026-03-18 12:27:28.328403+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-18 12:01:59.362484+00	no_medical_coat	Critical	f	placeholder.jpg	track_today_4706	9.508959108245888	f	f55cf639-d2df-4916-9ae9-989c429e0758	2026-03-18 12:27:28.328403+00	2026-03-18 12:27:28.328403+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-03-18 10:20:33.362484+00	no_gloves	Critical	f	placeholder.jpg	track_today_9926	37.17571177203649	t	ab59a9a6-f1bd-4f30-9bae-d8500cfb4aa5	2026-03-18 12:27:28.328403+00	2026-03-18 12:27:28.328403+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-03-18 09:38:08.362484+00	no_medical_coat	Critical	f	placeholder.jpg	track_today_2518	8.285988771319937	f	ae7aebe7-655e-4cd8-9f4e-a6d42b25dc12	2026-03-18 12:27:28.328403+00	2026-03-18 12:27:28.328403+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-03-18 01:54:06.362484+00	no_mask	Critical	f	placeholder.jpg	track_today_3871	32.01263532811089	f	6fc630e3-77cb-458a-beab-c9fe4c2090c3	2026-03-18 12:27:28.328403+00	2026-03-18 12:27:28.328403+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-03-18 08:53:24.362484+00	smoking	Low	f	placeholder.jpg	track_today_7315	8.886782724485963	f	d75899db-bb97-4e05-b5dc-401fc797a4f6	2026-03-18 12:27:28.328403+00	2026-03-18 12:27:28.328403+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-03-18 10:38:45.362484+00	no_mask	Critical	f	placeholder.jpg	track_today_5223	6.4520445664244175	t	c3eaae52-1954-4583-b826-1365efabe790	2026-03-18 12:27:28.328403+00	2026-03-18 12:27:28.328403+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-03-18 02:34:49.362484+00	smoking	Critical	f	placeholder.jpg	track_today_1276	25.10937098618472	f	c39b6f95-11b7-47fa-addc-abba7a29311c	2026-03-18 12:27:28.328403+00	2026-03-18 12:27:28.328403+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-03-18 04:09:58.362484+00	no_medical_coat	High	f	placeholder.jpg	track_today_1689	10.692358234106436	t	32579399-73c6-4878-bf30-23725a6c74a3	2026-03-18 12:27:28.328403+00	2026-03-18 12:27:28.328403+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-03-18 04:03:01.362484+00	no_medical_coat	Medium	f	placeholder.jpg	track_today_3091	27.36271999329478	t	b934728b-8bbd-4866-9fa5-b65e5d5fc491	2026-03-18 12:27:28.328403+00	2026-03-18 12:27:28.328403+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-18 00:42:24.362484+00	smoking	High	t	placeholder.jpg	track_today_8288	2.8524199015058063	t	37e4030c-d291-4a6c-9bb7-5a53be3c052b	2026-03-18 12:27:28.328403+00	2026-03-18 12:27:28.328403+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-18 09:02:08.362484+00	smoking	Critical	f	placeholder.jpg	track_today_5138	20.28824006490413	t	c9de2a40-177d-4d56-bedf-3c94cf51dd52	2026-03-18 12:27:28.328403+00	2026-03-18 12:27:28.328403+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-03-18 05:31:39.362484+00	no_cap	Critical	f	placeholder.jpg	track_today_8683	6.179872997267951	f	8850d6fd-f3d2-4610-a203-0dcb801a21f5	2026-03-18 12:27:28.328403+00	2026-03-18 12:27:28.328403+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-03-18 09:18:58.362484+00	no_cap	Critical	f	placeholder.jpg	track_today_7559	7.79826439964633	t	57129a52-41ec-4174-aa49-147f5ea5be61	2026-03-18 12:27:28.328403+00	2026-03-18 12:27:28.328403+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-03-18 11:18:41.362484+00	no_gloves	High	f	placeholder.jpg	track_today_9055	27.252884269885616	t	22c64412-08ad-485f-b7c1-da288f2d8acf	2026-03-18 12:27:28.328403+00	2026-03-18 12:27:28.328403+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-03-18 05:22:57.362484+00	smoking	Low	f	placeholder.jpg	track_today_9065	12.042613376724685	f	50f243c6-50c7-4006-b9d4-4029e8b3a3d2	2026-03-18 12:27:28.328403+00	2026-03-18 12:27:28.328403+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-03-18 00:18:11.362484+00	no_medical_coat	High	f	placeholder.jpg	track_today_5742	3.2119019766816783	f	67de08d8-06fb-4bb0-b542-9d5f74a8c7c3	2026-03-18 12:27:28.328403+00	2026-03-18 12:27:28.328403+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-18 02:17:53.362484+00	no_mask	Critical	f	placeholder.jpg	track_today_8845	37.45816756047141	f	460dd548-16df-4dff-bccf-0d5612ba8c13	2026-03-18 12:27:28.328403+00	2026-03-18 12:27:28.328403+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-03-19 10:19:20.878344+00	mouse	Critical	f	placeholder.jpg	track_today_2834	13.69065080705721	t	fdf698be-5015-40fe-8a3b-e8754c9f6ff7	2026-03-19 11:11:46.820895+00	2026-03-19 11:11:46.820895+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-03-19 03:58:34.878344+00	pizza	High	f	placeholder.jpg	track_today_2312	32.24790814944129	t	161c63da-e654-4cef-945f-88faa613bde3	2026-03-19 11:11:46.820895+00	2026-03-19 11:11:46.820895+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-03-19 06:20:34.878344+00	truck	Low	f	placeholder.jpg	track_today_1726	38.309893209269674	f	b772516f-d783-43b6-beb5-8733a727e55c	2026-03-19 11:11:46.820895+00	2026-03-19 11:11:46.820895+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-03-19 00:17:44.878344+00	orange	Medium	f	placeholder.jpg	track_today_4093	14.687891980000657	t	610af9ac-a9b8-4a42-bcd3-9d27e66c5db1	2026-03-19 11:11:46.820895+00	2026-03-19 11:11:46.820895+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-03-19 09:15:05.878344+00	surfboard	Medium	f	placeholder.jpg	track_today_4423	4.673252833549464	f	b520d1ec-bd79-4864-804a-7e9115abc9df	2026-03-19 11:11:46.820895+00	2026-03-19 11:11:46.820895+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-03-19 06:31:48.878344+00	snowboard	Low	f	placeholder.jpg	track_today_7401	35.79306542030086	t	e0aae6e9-ec6d-41ff-8f87-1ed7f8890c8b	2026-03-19 11:11:46.820895+00	2026-03-19 11:11:46.820895+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-03-19 07:54:37.878344+00	handbag	High	f	placeholder.jpg	track_today_8646	26.677295752755104	f	27bedf05-f0d0-4ede-b0c3-0e70ea4bfbe0	2026-03-19 11:11:46.820895+00	2026-03-19 11:11:46.820895+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-03-19 02:35:55.878344+00	frisbee	Low	f	placeholder.jpg	track_today_3742	25.40944206702879	f	abfa26bb-6338-4a85-a550-e4868c8f0302	2026-03-19 11:11:46.820895+00	2026-03-19 11:11:46.820895+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-03-19 01:00:22.878344+00	sink	Medium	f	placeholder.jpg	track_today_5801	9.836253636112144	t	75e07355-970a-4a1b-b96e-d59cc3276c4a	2026-03-19 11:11:46.820895+00	2026-03-19 11:11:46.820895+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-03-19 00:39:49.878344+00	parking_meter	Critical	f	placeholder.jpg	track_today_3109	9.463480635251422	t	ee710881-8ded-4e08-b42c-1c62c345135a	2026-03-19 11:11:46.820895+00	2026-03-19 11:11:46.820895+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-03-19 08:22:49.878344+00	remote	Medium	f	placeholder.jpg	track_today_9225	37.10350816852881	t	01d9576a-3aea-4a55-9e80-d2892963e6cf	2026-03-19 11:11:46.820895+00	2026-03-19 11:11:46.820895+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-19 00:54:08.878344+00	tennis_racket	Medium	f	placeholder.jpg	track_today_6708	42.10936944928941	t	277d4380-d62b-4b12-933a-fcaec3aab18e	2026-03-19 11:11:46.820895+00	2026-03-19 11:11:46.820895+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-19 09:23:26.878344+00	hair_drier	Critical	f	placeholder.jpg	track_today_9563	7.165047008208739	f	e2cb0804-283b-4aaa-9a11-4c2ca2c074b4	2026-03-19 11:11:46.820895+00	2026-03-19 11:11:46.820895+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-03-19 01:51:37.878344+00	surfboard	High	f	placeholder.jpg	track_today_9615	15.445726997234807	t	93868d64-2043-4c51-8204-78c5088fdfbb	2026-03-19 11:11:46.820895+00	2026-03-19 11:11:46.820895+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-03-19 04:43:52.878344+00	orange	High	f	placeholder.jpg	track_today_4772	8.885666979636504	t	d50edb91-6815-4fe8-83fc-31ef78e84239	2026-03-19 11:11:46.820895+00	2026-03-19 11:11:46.820895+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c9d0dff8-33e5-436c-9f8c-c9986fb49be0	2026-03-19 03:29:00.878344+00	book	High	f	placeholder.jpg	track_today_5002	21.52395540118243	t	4ceecf32-021d-4d59-aae7-d2b29e96734e	2026-03-19 11:11:46.820895+00	2026-03-19 11:11:46.820895+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-03-19 02:15:48.878344+00	dining_table	Medium	t	placeholder.jpg	track_today_2868	29.832503744217867	t	d947a104-237f-42d8-886a-6ccc673f7a18	2026-03-19 11:11:46.820895+00	2026-03-19 11:11:46.820895+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-29 02:21:58.823612+00	tennis_racket	Critical	f	placeholder.jpg	track_today_3922	10.041148065307045	f	e0fbed26-18dc-4282-8abf-007d1ac38cf1	2026-03-29 18:21:24.815965+00	2026-03-29 18:21:24.815965+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-03-29 09:58:14.823612+00	laptop	Medium	f	placeholder.jpg	track_today_3253	17.565055481809928	f	e3d65674-ec63-4b9b-9b4a-8d96872e7ea5	2026-03-29 18:21:24.815965+00	2026-03-29 18:21:24.815965+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-29 17:01:30.823612+00	hot_dog	Critical	f	placeholder.jpg	track_today_9538	44.549845980670575	t	c1c05072-d5d1-4c7f-80bb-3fead0ac2630	2026-03-29 18:21:24.815965+00	2026-03-29 18:21:24.815965+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-29 09:44:56.823612+00	elephant	Medium	f	placeholder.jpg	track_today_8568	4.3569316796378565	t	d4f8fc1d-c090-4425-bcda-97de593c402a	2026-03-29 18:21:24.815965+00	2026-03-29 18:21:24.815965+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-29 03:43:33.823612+00	boat	Low	f	placeholder.jpg	track_today_5456	16.323055046463665	f	4dbf0f47-cfe1-4f9f-997f-282dbce8d35b	2026-03-29 18:21:24.815965+00	2026-03-29 18:21:24.815965+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-03-29 16:53:23.823612+00	skateboard	Medium	f	placeholder.jpg	track_today_8789	32.68517580201602	t	b2070480-5e06-43fb-bcec-af1330f5718d	2026-03-29 18:21:24.815965+00	2026-03-29 18:21:24.815965+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-03-29 18:59:11.823612+00	toaster	High	f	placeholder.jpg	track_today_9930	4.417741140789643	f	c267f15c-93c6-4315-99d2-cfc3539d5456	2026-03-29 18:21:24.815965+00	2026-03-29 18:21:24.815965+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-03-29 02:46:59.823612+00	cat	Critical	f	placeholder.jpg	track_today_7507	11.144516275198322	f	a9fbb925-21cf-4788-ba66-e5d2569b3cb3	2026-03-29 18:21:24.815965+00	2026-03-29 18:21:24.815965+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-29 08:25:40.823612+00	giraffe	Critical	f	placeholder.jpg	track_today_8096	4.032814248672698	t	f43c1c13-5012-4d05-b9f9-a62ae956fc88	2026-03-29 18:21:24.815965+00	2026-03-29 18:21:24.815965+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-03-29 12:39:18.823612+00	hair_drier	Low	t	placeholder.jpg	track_today_3895	34.9935117341449	t	8ab66893-51dc-46fe-95ba-2608a4001a00	2026-03-29 18:21:24.815965+00	2026-03-29 18:21:24.815965+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-03-29 00:08:45.823612+00	fire_hydrant	Low	f	placeholder.jpg	track_today_1782	39.74145522976901	f	468675eb-5c7b-4b73-8918-b7d559198c58	2026-03-29 18:21:24.815965+00	2026-03-29 18:21:24.815965+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-03-29 18:14:42.823612+00	laptop	Low	f	placeholder.jpg	track_today_9753	43.46409940380841	f	cd353bd6-d740-485b-9c51-814447d57b8c	2026-03-29 18:21:24.815965+00	2026-03-29 18:21:24.815965+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-29 02:29:29.823612+00	hair_drier	Medium	f	placeholder.jpg	track_today_6420	12.807338561452607	t	590e8d3b-8e91-4b11-8552-ea14d5aa090a	2026-03-29 18:21:24.815965+00	2026-03-29 18:21:24.815965+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f94b3d22-74e9-4c0f-9d66-15816ba4bf28	2026-03-29 16:44:07.823612+00	skateboard	Low	f	placeholder.jpg	track_today_2031	22.875138800552584	t	e30d9411-e882-43c0-8ee1-1b53bd708915	2026-03-29 18:21:24.815965+00	2026-03-29 18:21:24.815965+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-03-29 09:44:15.823612+00	potted_plant	High	f	placeholder.jpg	track_today_6961	5.4867452377626975	t	d99c7e77-9398-4c81-94b1-c3c0ef8e8c15	2026-03-29 18:21:24.815965+00	2026-03-29 18:21:24.815965+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-29 06:44:53.823612+00	sheep	High	t	placeholder.jpg	track_today_5631	7.669631052007926	t	a4a238d1-98ab-405e-a0cb-898a4ea44d28	2026-03-29 18:21:24.815965+00	2026-03-29 18:21:24.815965+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-03-29 03:07:02.823612+00	cell_phone	Critical	f	placeholder.jpg	track_today_5983	41.93099340169448	f	6cf426ea-62d2-4b23-a3ed-e5469a4e7478	2026-03-29 18:21:24.815965+00	2026-03-29 18:21:24.815965+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-03-29 17:45:10.823612+00	dining_table	High	f	placeholder.jpg	track_today_6200	36.94438627392532	t	c5d25c7e-47ac-406f-a505-3cfecf8e8e19	2026-03-29 18:21:24.815965+00	2026-03-29 18:21:24.815965+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	550d705a-de12-4566-afcd-b6290bdd6efd	2026-03-29 03:41:45.823612+00	tv	Medium	f	placeholder.jpg	track_today_1811	18.926395434518167	f	bc54a41b-6657-4b0a-8dc3-b95203ad5ccd	2026-03-29 18:21:24.815965+00	2026-03-29 18:21:24.815965+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-03-29 12:16:16.823612+00	skis	Medium	f	placeholder.jpg	track_today_9230	41.62078586147715	t	6d244a15-d15c-47d9-9d12-3f2e703d60aa	2026-03-29 18:21:24.815965+00	2026-03-29 18:21:24.815965+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-04-25 14:32:03.890832+00	pizza	Critical	t	placeholder.jpg	track_today_2021	28.836429762642304	f	bfa0dd05-281b-4d04-a618-e5c17ccf1c5d	2026-04-25 18:25:52.862158+00	2026-04-25 18:25:52.862158+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-04-25 09:50:26.890832+00	sports_ball	Medium	f	placeholder.jpg	track_today_9006	17.22888066491573	t	8c46c8a2-c630-4b4b-b7c8-9c24f9402827	2026-04-25 18:25:52.862158+00	2026-04-25 18:25:52.862158+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-04-25 10:44:49.890832+00	orange	High	f	placeholder.jpg	track_today_2589	29.00255091129816	t	d326a6fd-d6c8-4072-8d9e-4d5a3a90b35a	2026-04-25 18:25:52.862158+00	2026-04-25 18:25:52.862158+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-04-25 13:46:14.890832+00	tennis_racket	High	f	placeholder.jpg	track_today_4358	39.95468687882911	f	46627915-048c-48bb-9aa8-5cc21d0acfbc	2026-04-25 18:25:52.862158+00	2026-04-25 18:25:52.862158+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-04-25 10:17:11.890832+00	elephant	Medium	f	placeholder.jpg	track_today_2473	20.525057717448806	f	faf99f5c-a559-43ba-ab45-972d779f0c27	2026-04-25 18:25:52.862158+00	2026-04-25 18:25:52.862158+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-04-25 12:51:46.890832+00	toaster	Low	f	placeholder.jpg	track_today_2188	36.545401218174575	t	3de85711-cb6a-4c09-a11b-f608bae2b22a	2026-04-25 18:25:52.862158+00	2026-04-25 18:25:52.862158+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-04-25 14:50:49.890832+00	stop_sign	Medium	f	placeholder.jpg	track_today_7435	4.593004555532442	f	26013e4f-d308-4638-9336-6925e5b162ab	2026-04-25 18:25:52.862158+00	2026-04-25 18:25:52.862158+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	7641b663-6d92-48a1-89d9-1e922e5ad73a	2026-04-25 02:40:40.890832+00	fork	High	f	placeholder.jpg	track_today_6131	11.237738593375996	f	6d1be6b9-ca16-44e7-b7e3-ed7d6ba3df59	2026-04-25 18:25:52.862158+00	2026-04-25 18:25:52.862158+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	19f09d60-c541-480a-87ce-64758b2ccb88	2026-04-25 16:58:32.890832+00	sports_ball	Low	f	placeholder.jpg	track_today_3802	41.927125001398736	t	7b2575ed-19f6-4d67-a420-75b616aef3db	2026-04-25 18:25:52.862158+00	2026-04-25 18:25:52.862158+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-04-25 10:24:35.890832+00	hot_dog	High	f	placeholder.jpg	track_today_3314	43.91902002112856	t	3b67cf91-9186-463b-87e2-a272b9aea3b0	2026-04-25 18:25:52.862158+00	2026-04-25 18:25:52.862158+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	c1d7603c-4498-46d7-9fd2-071f48578e17	2026-04-25 01:05:52.890832+00	dining_table	Low	f	placeholder.jpg	track_today_2963	25.567950633839644	t	815085bd-a790-4be0-a3a6-2014246eed86	2026-04-25 18:25:52.862158+00	2026-04-25 18:25:52.862158+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-04-25 00:24:42.890832+00	keyboard	High	f	placeholder.jpg	track_today_1960	21.666661073969706	t	5b627ede-51e8-4ea9-b5ad-a0b74fae4b98	2026-04-25 18:25:52.862158+00	2026-04-25 18:25:52.862158+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-04-25 13:51:50.890832+00	oven	High	f	placeholder.jpg	track_today_9553	14.481915384353128	f	0b19ddfa-c88d-4612-b105-71d2125ea2e5	2026-04-25 18:25:52.862158+00	2026-04-25 18:25:52.862158+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-04-25 13:39:39.890832+00	truck	High	f	placeholder.jpg	track_today_6041	29.85225990572926	t	79671136-4416-4276-b983-3f58660d0acf	2026-04-25 18:25:52.862158+00	2026-04-25 18:25:52.862158+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-04-25 14:08:29.890832+00	cat	High	f	placeholder.jpg	track_today_2245	38.74548108142169	t	a096a140-14dd-4549-94f2-120497e30bd2	2026-04-25 18:25:52.862158+00	2026-04-25 18:25:52.862158+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-04-25 06:18:40.890832+00	bed	Critical	t	placeholder.jpg	track_today_5418	16.171401046201673	f	f44a41e5-e0bd-4da9-921e-a4dbab2abace	2026-04-25 18:25:52.862158+00	2026-04-25 18:25:52.862158+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-04-25 14:25:01.890832+00	skateboard	Critical	f	placeholder.jpg	track_today_8975	18.800729715970416	f	59b350a2-6ef1-4e4c-9ebb-be347b8edcb6	2026-04-25 18:25:52.862158+00	2026-04-25 18:25:52.862158+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	6aa9be75-a251-446f-8503-45fac97be873	2026-04-25 00:52:33.890832+00	tie	Critical	f	placeholder.jpg	track_today_9159	3.7892833470271934	f	e4e5beff-d910-4a18-adfb-8f855b791cae	2026-04-25 18:25:52.862158+00	2026-04-25 18:25:52.862158+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	67cb79a1-b1c2-4144-9fbd-ecd1575cf4e7	2026-04-25 01:05:05.890832+00	carrot	Medium	f	placeholder.jpg	track_today_2769	41.094325576122195	f	7a7b1ace-5b8d-43a4-bced-6307b2025a02	2026-04-25 18:25:52.862158+00	2026-04-25 18:25:52.862158+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	f9ab3e9d-be5d-4f67-b012-cdbaaa74827d	2026-04-25 18:01:16.890832+00	hair_drier	Medium	t	placeholder.jpg	track_today_3985	22.701176506398344	t	ed416b52-45d6-403b-9f61-285391821d6e	2026-04-25 18:25:52.862158+00	2026-04-30 11:55:42.621648+00
16f28877-4fc0-467e-98f9-d4dfb7acafc2	5f3f0032-5b28-4b50-8e1f-e72d0b41f641	2026-01-29 18:55:55.926889+00	no_mask	Critical	t	https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=400&h=300&fit=crop	\N	16.9213081068016	f	027e2c5d-0582-469c-9ad0-74f74a7e1d68	2026-01-30 17:46:53.343632+00	2026-05-01 11:49:30.596203+00
\.


--
-- Name: organization_capabilities _org_object_uc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_capabilities
    ADD CONSTRAINT _org_object_uc UNIQUE (organization_id, object_code);


--
-- Name: activity_logs activity_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_pkey PRIMARY KEY (id);


--
-- Name: camera_rules camera_rules_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camera_rules
    ADD CONSTRAINT camera_rules_id_key UNIQUE (id);


--
-- Name: camera_rules camera_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camera_rules
    ADD CONSTRAINT camera_rules_pkey PRIMARY KEY (camera_id, id);


--
-- Name: cameras cameras_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cameras
    ADD CONSTRAINT cameras_pkey PRIMARY KEY (id);


--
-- Name: devices devices_device_token_secret_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_device_token_secret_key UNIQUE (device_token_secret);


--
-- Name: devices devices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- Name: organization_capabilities organization_capabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_capabilities
    ADD CONSTRAINT organization_capabilities_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_api_key_public_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_api_key_public_key UNIQUE (api_key_public);


--
-- Name: organizations organizations_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_name_key UNIQUE (name);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: users uix_user_email_org; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uix_user_email_org UNIQUE (email, organization_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: violations violations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.violations
    ADD CONSTRAINT violations_pkey PRIMARY KEY (id);


--
-- Name: ix_activity_logs_org_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_activity_logs_org_created ON public.activity_logs USING btree (organization_id, created_at);


--
-- Name: ix_cameras_organization_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_cameras_organization_id ON public.cameras USING btree (organization_id);


--
-- Name: ix_devices_organization_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_devices_organization_id ON public.devices USING btree (organization_id);


--
-- Name: ix_users_organization_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_users_organization_id ON public.users USING btree (organization_id);


--
-- Name: ix_users_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_users_username ON public.users USING btree (username);


--
-- Name: ix_violations_organization_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_violations_organization_id ON public.violations USING btree (organization_id);


--
-- Name: ix_violations_timestamp_utc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_violations_timestamp_utc ON public.violations USING btree (timestamp_utc);


--
-- Name: activity_logs activity_logs_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: activity_logs activity_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: camera_rules camera_rules_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camera_rules
    ADD CONSTRAINT camera_rules_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES public.cameras(id) ON DELETE CASCADE;


--
-- Name: cameras cameras_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cameras
    ADD CONSTRAINT cameras_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(id) ON DELETE CASCADE;


--
-- Name: cameras cameras_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cameras
    ADD CONSTRAINT cameras_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: devices devices_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: organization_capabilities organization_capabilities_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_capabilities
    ADD CONSTRAINT organization_capabilities_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: users users_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: violations violations_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.violations
    ADD CONSTRAINT violations_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES public.cameras(id) ON DELETE CASCADE;


--
-- Name: violations violations_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.violations
    ADD CONSTRAINT violations_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict J9arZXTiYUakmnuF07HLnqXwkhRgVEmg6O0rlg9scA8kahnD7k1240Mxvz0p650

