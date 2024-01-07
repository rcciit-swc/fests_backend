alter table "public"."event_categories" drop constraint "event_categories_pkey";

drop index if exists "public"."event_categories_pkey";

create table "public"."defined_roles" (
    "role" text not null
);


alter table "public"."defined_roles" enable row level security;

create table "public"."events" (
    "id" uuid not null default gen_random_uuid(),
    "event_category_id" uuid,
    "fest_name" text not null,
    "year" smallint not null,
    "min_team_member" smallint not null default '1'::smallint,
    "max_team_member" smallint not null default '1'::smallint,
    "desc" text,
    "registration_fees" smallint,
    "event_name" text,
    "event_image_url" text,
    "is_open" boolean not null default true
);


alter table "public"."events" enable row level security;

create table "public"."fests" (
    "name" text not null,
    "year" smallint not null
);


alter table "public"."fests" enable row level security;

create table "public"."max_participation_allowed" (
    "event_id" uuid not null,
    "max_allowed" smallint
);


alter table "public"."max_participation_allowed" enable row level security;

create table "public"."participations" (
    "phone" text not null,
    "created_at" timestamp with time zone not null default now(),
    "team_id" uuid not null,
    "payment_stats" text not null default 'unverified'::text
);


alter table "public"."participations" enable row level security;

create table "public"."roles" (
    "id" uuid not null,
    "role" text not null,
    "event_id" uuid,
    "created_at" timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text)
);


alter table "public"."roles" enable row level security;

create table "public"."teams" (
    "event_id" uuid not null,
    "created_at" timestamp with time zone not null default now(),
    "team_name" text not null,
    "team_id" uuid not null default gen_random_uuid(),
    "transaction_id" text not null,
    "transaction_ss_filename" text,
    "transaction_verfied" boolean not null default false,
    "team_lead_phone" text not null
);


alter table "public"."teams" enable row level security;

create table "public"."users" (
    "name" text,
    "college" text,
    "phone" text,
    "id" uuid not null,
    "gender" text,
    "college_roll" text,
    "email" text not null
);


alter table "public"."users" enable row level security;

alter table "public"."event_categories" add column "fest_name" text;

alter table "public"."event_categories" add column "id" uuid not null default gen_random_uuid();

alter table "public"."event_categories" add column "year" smallint;

CREATE UNIQUE INDEX defined_roles_pkey ON public.defined_roles USING btree (role);

CREATE UNIQUE INDEX events_pkey ON public.events USING btree (id);

CREATE UNIQUE INDEX fests_pkey ON public.fests USING btree (name, year);

CREATE UNIQUE INDEX max_participation_allowed_id_key ON public.max_participation_allowed USING btree (event_id);

CREATE UNIQUE INDEX max_participation_allowed_pkey ON public.max_participation_allowed USING btree (event_id);

CREATE UNIQUE INDEX participations_pkey ON public.participations USING btree (created_at, team_id);

CREATE UNIQUE INDEX roles_pkey ON public.roles USING btree (created_at, id);

CREATE UNIQUE INDEX "teams_Transaction_id_key" ON public.teams USING btree (transaction_id);

CREATE UNIQUE INDEX teams_pkey ON public.teams USING btree (team_id);

CREATE UNIQUE INDEX teams_team_id_key ON public.teams USING btree (team_id);

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);

CREATE UNIQUE INDEX users_phone_key ON public.users USING btree (phone);

CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id);

CREATE UNIQUE INDEX event_categories_pkey ON public.event_categories USING btree (id);

alter table "public"."defined_roles" add constraint "defined_roles_pkey" PRIMARY KEY using index "defined_roles_pkey";

alter table "public"."events" add constraint "events_pkey" PRIMARY KEY using index "events_pkey";

alter table "public"."fests" add constraint "fests_pkey" PRIMARY KEY using index "fests_pkey";

alter table "public"."max_participation_allowed" add constraint "max_participation_allowed_pkey" PRIMARY KEY using index "max_participation_allowed_pkey";

alter table "public"."participations" add constraint "participations_pkey" PRIMARY KEY using index "participations_pkey";

alter table "public"."roles" add constraint "roles_pkey" PRIMARY KEY using index "roles_pkey";

alter table "public"."teams" add constraint "teams_pkey" PRIMARY KEY using index "teams_pkey";

alter table "public"."users" add constraint "users_pkey" PRIMARY KEY using index "users_pkey";

alter table "public"."event_categories" add constraint "event_categories_pkey" PRIMARY KEY using index "event_categories_pkey";

alter table "public"."event_categories" add constraint "event_categories_fkey" FOREIGN KEY (year, fest_name) REFERENCES fests(year, name) not valid;

alter table "public"."event_categories" validate constraint "event_categories_fkey";

alter table "public"."events" add constraint "event_fkey" FOREIGN KEY (year, fest_name) REFERENCES fests(year, name) not valid;

alter table "public"."events" validate constraint "event_fkey";

alter table "public"."events" add constraint "events_event_category_id_fkey" FOREIGN KEY (event_category_id) REFERENCES event_categories(id) not valid;

alter table "public"."events" validate constraint "events_event_category_id_fkey";

alter table "public"."max_participation_allowed" add constraint "max_participation_allowed_event_id_fkey" FOREIGN KEY (event_id) REFERENCES events(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."max_participation_allowed" validate constraint "max_participation_allowed_event_id_fkey";

alter table "public"."max_participation_allowed" add constraint "max_participation_allowed_id_key" UNIQUE using index "max_participation_allowed_id_key";

alter table "public"."participations" add constraint "participations_team_id_fkey" FOREIGN KEY (team_id) REFERENCES teams(team_id) not valid;

alter table "public"."participations" validate constraint "participations_team_id_fkey";

alter table "public"."roles" add constraint "roles_event_id_fkey" FOREIGN KEY (event_id) REFERENCES events(id) not valid;

alter table "public"."roles" validate constraint "roles_event_id_fkey";

alter table "public"."roles" add constraint "roles_id_fkey" FOREIGN KEY (id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."roles" validate constraint "roles_id_fkey";

alter table "public"."roles" add constraint "roles_role_fkey" FOREIGN KEY (role) REFERENCES defined_roles(role) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."roles" validate constraint "roles_role_fkey";

alter table "public"."teams" add constraint "teams_Transaction_id_key" UNIQUE using index "teams_Transaction_id_key";

alter table "public"."teams" add constraint "teams_event_id_fkey" FOREIGN KEY (event_id) REFERENCES events(id) not valid;

alter table "public"."teams" validate constraint "teams_event_id_fkey";

alter table "public"."teams" add constraint "teams_team_id_key" UNIQUE using index "teams_team_id_key";

alter table "public"."teams" add constraint "teams_team_lead_phone_fkey" FOREIGN KEY (team_lead_phone) REFERENCES users(phone) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."teams" validate constraint "teams_team_lead_phone_fkey";

alter table "public"."users" add constraint "users_email_key" UNIQUE using index "users_email_key";

alter table "public"."users" add constraint "users_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."users" validate constraint "users_id_fkey";

alter table "public"."users" add constraint "users_phone_key" UNIQUE using index "users_phone_key";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.add_user_to_user_profile()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  INSERT INTO public.users (id, email)
  VALUES (NEW.id, NEW.email);
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.check_if_user_registered(phone_param text)
 RETURNS TABLE(team_id uuid, team_name text, is_team_lead boolean, created_at timestamp with time zone, transaction_id text, transaction_ss_filename text, transaction_verfied boolean, payment_stats text, event_id uuid, event_name text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT
    t.team_id,
    t.team_name,
    CASE WHEN (p.phone = phone_param)
    THEN FALSE
    ELSE TRUE END AS is_team_lead,
    t.created_at,
    t.transaction_id,
    t.transaction_ss_filename,
    t.transaction_verfied,
    p.payment_stats,
    e.id AS event_id,
    e.event_name
    FROM teams t
    LEFT JOIN participations p ON t.team_id = p.team_id
    JOIN events e ON e.id = t.event_id
    WHERE (p.phone = phone_param OR t.team_lead_phone = phone_param);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.check_max_participation()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM max_participation_allowed
    WHERE event_id = NEW.event_id
      AND (max_allowed IS NULL OR (SELECT COUNT(*) FROM teams WHERE event_id = NEW.event_id) >= max_allowed)
  ) THEN
    RAISE EXCEPTION 'Max participation limit reached for the event';
  END IF;

  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.fetch_event_roles_using_uid(user_id_param uuid DEFAULT auth.uid(), fest_name_param text DEFAULT NULL::text, year_param smallint DEFAULT NULL::smallint)
 RETURNS TABLE(event_id uuid, role text)
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN QUERY
  SELECT r.event_id, r.role FROM public.roles r
  JOIN events e ON e.id = r.event_id
  WHERE r.id = user_id_param
  AND CASE WHEN (fest_name_param IS NULL) THEN 1 = 1 ELSE e.fest_name = fest_name_param END
  AND CASE WHEN (year_param IS NULL) THEN 1 = 1 ELSE e.year = year_param END;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.fetch_team_registrations_by_events(event_id_param uuid DEFAULT NULL::uuid, transaction_id_param text DEFAULT NULL::text, phone_param text DEFAULT NULL::text)
 RETURNS TABLE(team_id uuid, team_lead_phone text, event_id uuid, event_name text, transaction_id text, transaction_ss_filename text, transaction_verfied boolean, team_name text, college text, name text, gender text, team_member_phones text[], is_team boolean)
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN QUERY
  SELECT
    t.team_id,
    t.team_lead_phone,
    t.event_id,
    e.event_name,
    t.transaction_id,
    t.transaction_ss_filename,
    t.transaction_verfied,
    t.team_name,
    u.college,
    u.name,
    u.gender,
    array_agg(p.phone) as team_member_phones,
    CASE WHEN (COUNT(p.phone) > 0) THEN TRUE ELSE FALSE END AS is_team
  FROM teams t
  LEFT JOIN participations p
  ON t.team_id = p.team_id
  JOIN events e
  ON e.id = t.event_id
  JOIN users u
  ON t.team_lead_phone = u.phone
  WHERE CASE WHEN (event_id_param IS NULL) THEN 1 = 1 ELSE t.event_id = event_id_param END
  AND CASE WHEN (transaction_id_param IS NULL) THEN 1 = 1 ELSE t.transaction_id = transaction_id_param END
  AND CASE WHEN (phone_param IS NULL) THEN 1 = 1 ELSE t.team_lead_phone = phone_param END 
  GROUP BY t.team_id, t.team_lead_phone, e.event_name, u.college, u.name, u.gender;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_event_participations(event_id_param uuid DEFAULT NULL::uuid, phone_param text DEFAULT ''::text, transaction_id_param text DEFAULT ''::text)
 RETURNS TABLE(event_name text, team_name text, team_lead_phone text, transaction_id text, transaction_ss_filename text, transaction_verfied boolean, user_name text, college text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT e.event_name, t.team_name, t.team_lead_phone, t.transaction_id, t.transaction_ss_filename, t.transaction_verfied, u.name AS user_name, u.college 
    FROM teams t
    JOIN users u ON (t.team_lead_phone = u.phone)
    JOIN events e ON (e.id = t.event_id)
    LEFT JOIN participations p ON (p.team_id = t.team_id)
    WHERE CASE WHEN (event_id_param IS NULL) THEN 1 = 1 ELSE e.id = event_id_param END
    AND CASE WHEN (transaction_id_param = '') THEN 1 = 1 ELSE t.transaction_id = transaction_id_param END
    AND CASE WHEN (phone_param = '') THEN 1 = 1 ELSE (t.team_lead_phone = phone_param OR p.phone = phone_param) END;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.regs_closed(event_id_param uuid)
 RETURNS TABLE(closed boolean)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  RETURN QUERY
  SELECT
    CASE
      WHEN ((
        SELECT
          COALESCE(COUNT(t.event_id), 0) AS registration_count
        FROM
            events e
        LEFT JOIN
            teams t ON e.id = t.event_id
        WHERE
            e.id = event_id_param
        GROUP BY
            e.id
      ) >= (SELECT max_allowed FROM max_participation_allowed WHERE event_id = event_id_param)
      OR (SELECT is_open FROM events WHERE id = event_id_param) = FALSE) THEN TRUE
    ELSE FALSE
  END AS closed;
END;
$function$
;

create policy "enable read access for auth users"
on "public"."defined_roles"
as permissive
for select
to authenticated
using (true);


create policy "Enable read access for all users"
on "public"."events"
as permissive
for select
to public
using (true);


create policy "Enable read access for all users"
on "public"."fests"
as permissive
for select
to public
using (true);


create policy "Enable insert for authenticated users only"
on "public"."participations"
as permissive
for insert
to authenticated
with check (true);


create policy "Enable read access for authenticated users"
on "public"."participations"
as permissive
for select
to authenticated
using (true);


create policy "Enable update for users based on email"
on "public"."participations"
as permissive
for update
to public
using (true)
with check (true);


create policy "Enable delete for users based on user_id"
on "public"."roles"
as permissive
for delete
to authenticated
using ((auth.uid() IN ( SELECT roles_1.id
   FROM roles roles_1
  WHERE (roles_1.role = 'super_admin'::text))));


create policy "Enable insert for super_admin roles"
on "public"."roles"
as permissive
for insert
to authenticated
with check ((auth.uid() IN ( SELECT r.id AS uid
   FROM roles r
  WHERE ((r.role = 'super_admin'::text) AND (r.id = auth.uid())))));


create policy "access for id"
on "public"."roles"
as permissive
for select
to authenticated
using (true);


create policy "allow super_admin"
on "public"."roles"
as permissive
for update
to authenticated
using ((auth.uid() IN ( SELECT roles_1.id
   FROM roles roles_1
  WHERE (roles_1.role = 'super_admin'::text))))
with check ((auth.uid() IN ( SELECT roles_1.id
   FROM roles roles_1
  WHERE (roles_1.role = 'super_admin'::text))));


create policy "Enable read access for authenticated users"
on "public"."teams"
as permissive
for select
to authenticated
using (true);


create policy "enable insert for specific users only"
on "public"."teams"
as permissive
for insert
to authenticated
with check ((team_lead_phone = ( SELECT users.phone
   FROM users
  WHERE (users.id = auth.uid()))));


create policy "Enable insert for authenticated users only"
on "public"."users"
as permissive
for insert
to authenticated
with check ((auth.uid() = id));


create policy "Enable update for users based on email"
on "public"."users"
as permissive
for update
to authenticated
using ((auth.uid() = id))
with check ((auth.uid() = id));


create policy "read access for user object owners and super_admins"
on "public"."users"
as permissive
for select
to authenticated
using (((auth.uid() = id) OR (auth.uid() IN ( SELECT r.id
   FROM roles r
  WHERE ((r.role = 'super_admin'::text) OR (r.role = 'event_coordinator'::text))))));


CREATE TRIGGER before_insert_teams BEFORE INSERT ON public.teams FOR EACH ROW EXECUTE FUNCTION check_max_participation();


