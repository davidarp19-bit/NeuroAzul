-- ============================================================
-- NeuroAzul
-- Esquema inicial de Supabase
-- Fecha: 2026-11-09
--
-- Incluye:
-- - Tablas remotas
-- - Restricciones
-- - Relaciones
-- - Row Level Security
-- - Politicas de acceso
-- ============================================================


-- ============================================================
-- 1. PERFILES INFANTILES
-- ============================================================

CREATE TABLE public.child_profiles (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    adult_id uuid NOT NULL,
    alias text NOT NULL,
    age_range text NOT NULL,
    avatar_key text,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),

    CONSTRAINT child_profiles_pkey
        PRIMARY KEY (id),

    CONSTRAINT child_profiles_adult_id_fkey
        FOREIGN KEY (adult_id)
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    CONSTRAINT child_profiles_age_range_check
        CHECK (
            age_range = ANY (
                ARRAY[
                    '6-8'::text,
                    '9-10'::text,
                    '11-12'::text
                ]
            )
        ),

    CONSTRAINT child_profiles_alias_check
        CHECK (
            char_length(alias) >= 1
            AND char_length(alias) <= 40
        )
);


-- ============================================================
-- 2. INTENTOS DE EMOCIONES
-- ============================================================

CREATE TABLE public.emotion_attempts (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    profile_id uuid NOT NULL,
    question_id text NOT NULL,
    selected_emotion text NOT NULL,
    is_correct boolean NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT now(),

    CONSTRAINT emotion_attempts_pkey
        PRIMARY KEY (id),

    CONSTRAINT emotion_attempts_profile_id_fkey
        FOREIGN KEY (profile_id)
        REFERENCES public.child_profiles(id)
        ON DELETE CASCADE
);


-- ============================================================
-- 3. INTENTOS DE PICTOGRAMAS
-- ============================================================

CREATE TABLE public.pictogram_attempts (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    profile_id uuid NOT NULL,
    question_id text NOT NULL,
    selected_id text NOT NULL,
    is_correct boolean NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT now(),

    CONSTRAINT pictogram_attempts_pkey
        PRIMARY KEY (id),

    CONSTRAINT pictogram_attempts_profile_id_fkey
        FOREIGN KEY (profile_id)
        REFERENCES public.child_profiles(id)
        ON DELETE CASCADE
);


-- ============================================================
-- 4. INTENTOS DE RUTINAS
-- ============================================================

CREATE TABLE public.routine_attempts (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    profile_id uuid NOT NULL,
    routine_id text NOT NULL,
    selected_order jsonb NOT NULL,
    is_correct boolean NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT now(),

    CONSTRAINT routine_attempts_pkey
        PRIMARY KEY (id),

    CONSTRAINT routine_attempts_profile_id_fkey
        FOREIGN KEY (profile_id)
        REFERENCES public.child_profiles(id)
        ON DELETE CASCADE
);


-- ============================================================
-- 5. ROW LEVEL SECURITY
-- ============================================================

ALTER TABLE public.child_profiles
ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.emotion_attempts
ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.pictogram_attempts
ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.routine_attempts
ENABLE ROW LEVEL SECURITY;


-- ============================================================
-- 6. POLITICAS RLS - CHILD PROFILES
-- ============================================================

CREATE POLICY "Adults can create their child profiles"
ON public.child_profiles
AS PERMISSIVE
FOR INSERT
TO authenticated
WITH CHECK (
    (SELECT auth.uid() AS uid) = adult_id
);


CREATE POLICY "Adults can delete their child profiles"
ON public.child_profiles
AS PERMISSIVE
FOR DELETE
TO authenticated
USING (
    (SELECT auth.uid() AS uid) = adult_id
);


CREATE POLICY "Adults can update their child profiles"
ON public.child_profiles
AS PERMISSIVE
FOR UPDATE
TO authenticated
USING (
    (SELECT auth.uid() AS uid) = adult_id
)
WITH CHECK (
    (SELECT auth.uid() AS uid) = adult_id
);


CREATE POLICY "Adults can view their child profiles"
ON public.child_profiles
AS PERMISSIVE
FOR SELECT
TO authenticated
USING (
    (SELECT auth.uid() AS uid) = adult_id
);


-- ============================================================
-- 7. POLITICAS RLS - EMOTION ATTEMPTS
-- ============================================================

CREATE POLICY "Adults can create emotion attempts for their child profiles"
ON public.emotion_attempts
AS PERMISSIVE
FOR INSERT
TO authenticated
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.child_profiles cp
        WHERE cp.id = emotion_attempts.profile_id
          AND cp.adult_id = (SELECT auth.uid() AS uid)
    )
);


CREATE POLICY "Adults can view emotion attempts from their child profiles"
ON public.emotion_attempts
AS PERMISSIVE
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM public.child_profiles cp
        WHERE cp.id = emotion_attempts.profile_id
          AND cp.adult_id = (SELECT auth.uid() AS uid)
    )
);


-- ============================================================
-- 8. POLITICAS RLS - PICTOGRAM ATTEMPTS
-- ============================================================

CREATE POLICY "Adults can create attempts for their child profiles"
ON public.pictogram_attempts
AS PERMISSIVE
FOR INSERT
TO authenticated
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.child_profiles cp
        WHERE cp.id = pictogram_attempts.profile_id
          AND cp.adult_id = (SELECT auth.uid() AS uid)
    )
);


CREATE POLICY "Adults can view attempts from their child profiles"
ON public.pictogram_attempts
AS PERMISSIVE
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM public.child_profiles cp
        WHERE cp.id = pictogram_attempts.profile_id
          AND cp.adult_id = (SELECT auth.uid() AS uid)
    )
);


-- ============================================================
-- 9. POLITICAS RLS - ROUTINE ATTEMPTS
-- ============================================================

CREATE POLICY "Adults can create routine attempts for their child profiles"
ON public.routine_attempts
AS PERMISSIVE
FOR INSERT
TO authenticated
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.child_profiles cp
        WHERE cp.id = routine_attempts.profile_id
          AND cp.adult_id = (SELECT auth.uid() AS uid)
    )
);


CREATE POLICY "Adults can view routine attempts from their child profiles"
ON public.routine_attempts
AS PERMISSIVE
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM public.child_profiles cp
        WHERE cp.id = routine_attempts.profile_id
          AND cp.adult_id = (SELECT auth.uid() AS uid)
    )
);
-- ============================================================
-- 10. PRIVILEGIOS DE ACCESO
-- ============================================================

-- El rol anon no dispone de acceso directo a las tablas
-- funcionales de NeuroAzul.
REVOKE ALL ON TABLE public.child_profiles FROM anon;
REVOKE ALL ON TABLE public.emotion_attempts FROM anon;
REVOKE ALL ON TABLE public.pictogram_attempts FROM anon;
REVOKE ALL ON TABLE public.routine_attempts FROM anon;


-- Usuario adulto autenticado:
-- administración de sus perfiles infantiles.
GRANT SELECT, INSERT, UPDATE, DELETE
ON TABLE public.child_profiles
TO authenticated;


-- Los intentos son registros históricos:
-- el cliente únicamente los crea y consulta.
GRANT SELECT, INSERT
ON TABLE public.emotion_attempts
TO authenticated;

GRANT SELECT, INSERT
ON TABLE public.pictogram_attempts
TO authenticated;

GRANT SELECT, INSERT
ON TABLE public.routine_attempts
TO authenticated;


-- Rol administrativo utilizado por Supabase.
GRANT SELECT, INSERT, UPDATE, DELETE,
      TRUNCATE, REFERENCES, TRIGGER
ON TABLE public.child_profiles
TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE,
      TRUNCATE, REFERENCES, TRIGGER
ON TABLE public.emotion_attempts
TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE,
      TRUNCATE, REFERENCES, TRIGGER
ON TABLE public.pictogram_attempts
TO service_role;

GRANT SELECT, INSERT, UPDATE, DELETE,
      TRUNCATE, REFERENCES, TRIGGER
ON TABLE public.routine_attempts
TO service_role;