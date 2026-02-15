-- ============================================================================
-- MIGRATION 001: Extensions and Initial Configuration
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- Base: Legacy v1.0 + v2.0 improvements
-- ============================================================================
-- //AI-GENERATED

-- Habilitar extensoes necessarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";      -- Geracao de UUIDs
CREATE EXTENSION IF NOT EXISTS "pgcrypto";        -- Funcoes criptograficas
CREATE EXTENSION IF NOT EXISTS "postgis";         -- Suporte a geolocalizacao (check-in GPS)

-- Configurar timezone padrao para Brasil
ALTER DATABASE postgres SET timezone TO 'America/Sao_Paulo';
SET timezone = 'America/Sao_Paulo';

-- Habilitar Row Level Security globalmente
ALTER DATABASE postgres SET row_security = on;
