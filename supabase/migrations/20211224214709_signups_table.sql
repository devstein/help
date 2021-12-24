-- This script was generated by the Schema Diff utility in pgAdmin 4
-- For the circular dependencies, the order in which Schema Diff writes the objects is not very sophisticated
-- and may require manual changes to the script to ensure changes are applied in the correct order.
-- Please report an issue for any failure with the reproduction steps.

CREATE OR REPLACE FUNCTION public.handle_new_verified_user()
RETURNS trigger
LANGUAGE 'plpgsql'
COST 100
VOLATILE NOT LEAKPROOF SECURITY DEFINER
SET search_path=public
AS $BODY$
begin
    insert into public.signups (id, email)
    values (new.id, new.email);
    return new;
end;
$BODY$;

ALTER FUNCTION public.handle_new_verified_user()
OWNER TO postgres;

GRANT EXECUTE ON FUNCTION public.handle_new_verified_user() TO authenticated;

GRANT EXECUTE ON FUNCTION public.handle_new_verified_user() TO postgres;

GRANT EXECUTE ON FUNCTION public.handle_new_verified_user() TO PUBLIC;

GRANT EXECUTE ON FUNCTION public.handle_new_verified_user() TO anon;

GRANT EXECUTE ON FUNCTION public.handle_new_verified_user() TO service_role;

CREATE TABLE IF NOT EXISTS public.signups
(
    id uuid NOT NULL,
    position_number serial,
    email text COLLATE pg_catalog."default" NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT signups_pkey PRIMARY KEY (id),
    CONSTRAINT signups_id_fkey FOREIGN KEY (id)
    REFERENCES auth.users (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.signups
OWNER to postgres;

ALTER TABLE IF EXISTS public.signups
ENABLE ROW LEVEL SECURITY;

GRANT ALL ON TABLE public.signups TO anon;

GRANT ALL ON TABLE public.signups TO authenticated;

GRANT ALL ON TABLE public.signups TO postgres;

GRANT ALL ON TABLE public.signups TO service_role;
CREATE POLICY "Signups are viewable by the users who created them."
ON public.signups
AS PERMISSIVE
FOR SELECT
    TO public
    USING ((auth.uid() = id));
