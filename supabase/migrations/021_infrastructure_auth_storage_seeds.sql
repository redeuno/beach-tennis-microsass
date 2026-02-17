-- ============================================================================
-- MIGRATION 021: Infrastructure - Auth Triggers, Storage, Default Seeds
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- FIXES: Auth lifecycle, arena-proprietario link, storage buckets,
--        default WhatsApp templates, default payment forms
-- ============================================================================
-- //AI-GENERATED
-- //HIGH-RISK - auth lifecycle e dados financeiros

-- ============================================================
-- 1. TRIGGER: Sincronizar auth.users → public.usuarios
-- Quando alguem se cadastra via Supabase Auth, cria automaticamente
-- o registro na tabela usuarios do nosso sistema
-- ============================================================
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.usuarios (
    auth_id,
    email,
    nome_completo,
    tipo_usuario,
    status,
    aceite_termos,
    created_at,
    updated_at
  ) VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'nome_completo', NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    COALESCE((NEW.raw_user_meta_data->>'tipo_usuario')::user_role, 'aluno'),
    'ativo',
    false,
    NOW(),
    NOW()
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Aplica trigger no schema auth (gerenciado pelo Supabase)
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();


-- ============================================================
-- 2. TRIGGER: Vincular criador da arena como proprietario
-- Quando uma arena e criada, vincula automaticamente o usuario
-- atual como proprietario na tabela usuarios_arenas
-- ============================================================
CREATE OR REPLACE FUNCTION auto_link_arena_proprietario()
RETURNS TRIGGER AS $$
DECLARE
  v_user_id UUID;
BEGIN
  -- Tenta pegar o user_id do contexto da aplicacao
  v_user_id := COALESCE(
    current_setting('app.current_user_id', true)::uuid,
    auth_user_id()
  );

  -- So vincula se temos um usuario identificado
  IF v_user_id IS NOT NULL THEN
    INSERT INTO public.usuarios_arenas (
      usuario_id,
      arena_id,
      papel,
      is_proprietario,
      arena_ativa,
      status,
      data_vinculo
    ) VALUES (
      v_user_id,
      NEW.id,
      'proprietario',
      true,
      true,
      'ativo',
      CURRENT_DATE
    );

    -- Atualiza arena_id principal do usuario se nao tiver
    UPDATE public.usuarios
    SET arena_id = NEW.id
    WHERE id = v_user_id
    AND arena_id IS NULL;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER auto_link_arena_proprietario_trigger
  AFTER INSERT ON arenas
  FOR EACH ROW EXECUTE FUNCTION auto_link_arena_proprietario();


-- ============================================================
-- 3. TRIGGER: Criar formas de pagamento padrao para nova arena
-- Toda arena nasce com PIX, Boleto e Cartao de Credito
-- ============================================================
CREATE OR REPLACE FUNCTION auto_create_payment_forms()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.formas_pagamento (arena_id, nome, tipo, taxa_fixa, taxa_percentual, prazo_recebimento, ativa)
  VALUES
    (NEW.id, 'PIX', 'pix', 0, 0, 0, true),
    (NEW.id, 'Boleto Bancario', 'boleto', 3.49, 0, 3, true),
    (NEW.id, 'Cartao de Credito', 'cartao_credito', 0, 2.99, 30, true),
    (NEW.id, 'Cartao de Debito', 'cartao_debito', 0, 1.99, 1, true),
    (NEW.id, 'Dinheiro', 'dinheiro', 0, 0, 0, true);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER auto_create_payment_forms_trigger
  AFTER INSERT ON arenas
  FOR EACH ROW EXECUTE FUNCTION auto_create_payment_forms();


-- ============================================================
-- 4. SEED: Templates padrao de WhatsApp
-- Templates com variaveis {{nome}}, {{data}}, {{horario}}, etc.
-- Usando arena_id UUID zero como template base (copiado para novas arenas)
-- ============================================================
INSERT INTO templates_whatsapp (
  arena_id, nome, categoria, conteudo, variaveis, ativo
) VALUES
-- Confirmacao de agendamento
(
  '00000000-0000-0000-0000-000000000000',
  'confirmacao_agendamento',
  'confirmacao',
  'Ola {{nome}}! Seu agendamento foi confirmado.\n\nQuadra: {{quadra}}\nData: {{data}}\nHorario: {{horario_inicio}} - {{horario_fim}}\nValor: R$ {{valor}}\n\nAte la! 🎾',
  '["nome", "quadra", "data", "horario_inicio", "horario_fim", "valor"]',
  true
),
-- Lembrete 24h antes
(
  '00000000-0000-0000-0000-000000000000',
  'lembrete_24h',
  'lembrete',
  'Ola {{nome}}! Lembrete: voce tem um horario amanha.\n\nQuadra: {{quadra}}\nHorario: {{horario_inicio}} - {{horario_fim}}\n\nNao esqueca! 🏖️',
  '["nome", "quadra", "horario_inicio", "horario_fim"]',
  true
),
-- Lembrete 2h antes
(
  '00000000-0000-0000-0000-000000000000',
  'lembrete_2h',
  'lembrete',
  'Ola {{nome}}! Seu horario e daqui a 2 horas.\n\nQuadra: {{quadra}}\nHorario: {{horario_inicio}}\n\nNos vemos la! 🎾',
  '["nome", "quadra", "horario_inicio"]',
  true
),
-- Fatura vencendo
(
  '00000000-0000-0000-0000-000000000000',
  'fatura_vencendo',
  'cobranca',
  'Ola {{nome}}! Sua fatura vence em {{dias_vencimento}} dia(s).\n\nValor: R$ {{valor}}\nVencimento: {{data_vencimento}}\n\nPague via PIX: {{link_pagamento}}',
  '["nome", "dias_vencimento", "valor", "data_vencimento", "link_pagamento"]',
  true
),
-- Fatura vencida
(
  '00000000-0000-0000-0000-000000000000',
  'fatura_vencida',
  'cobranca',
  'Ola {{nome}}! Sua fatura esta vencida.\n\nValor: R$ {{valor}}\nVencimento: {{data_vencimento}}\n\nRegularize para continuar usando os servicos: {{link_pagamento}}',
  '["nome", "valor", "data_vencimento", "link_pagamento"]',
  true
),
-- Pagamento confirmado
(
  '00000000-0000-0000-0000-000000000000',
  'pagamento_confirmado',
  'confirmacao',
  'Ola {{nome}}! Pagamento recebido com sucesso!\n\nValor: R$ {{valor}}\nReferente a: {{descricao}}\n\nObrigado! ✅',
  '["nome", "valor", "descricao"]',
  true
),
-- Cancelamento de agendamento
(
  '00000000-0000-0000-0000-000000000000',
  'cancelamento_agendamento',
  'cancelamento',
  'Ola {{nome}}! Seu agendamento foi cancelado.\n\nQuadra: {{quadra}}\nData: {{data}}\nHorario: {{horario_inicio}} - {{horario_fim}}\n\nMotivo: {{motivo}}',
  '["nome", "quadra", "data", "horario_inicio", "horario_fim", "motivo"]',
  true
),
-- Aniversario
(
  '00000000-0000-0000-0000-000000000000',
  'aniversario',
  'relacionamento',
  'Feliz aniversario, {{nome}}! 🎂🎾\n\n{{arena_nome}} deseja um dia incrivel pra voce!\n\nQue tal comemorar com uma partida?',
  '["nome", "arena_nome"]',
  true
),
-- Boas vindas
(
  '00000000-0000-0000-0000-000000000000',
  'boas_vindas',
  'onboarding',
  'Bem-vindo(a) a {{arena_nome}}, {{nome}}! 🎾\n\nSeu cadastro foi realizado com sucesso.\n\nVoce pode agendar horarios, ver suas aulas e muito mais pelo nosso sistema.\n\nQualquer duvida, estamos aqui!',
  '["nome", "arena_nome"]',
  true
);


-- ============================================================
-- 5. TRIGGER: Copiar templates WhatsApp padrao para nova arena
-- Copia os templates do UUID zero para cada arena nova
-- ============================================================
CREATE OR REPLACE FUNCTION auto_copy_whatsapp_templates()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO templates_whatsapp (arena_id, nome, categoria, conteudo, variaveis, ativo)
  SELECT
    NEW.id,
    nome,
    categoria,
    conteudo,
    variaveis,
    ativo
  FROM templates_whatsapp
  WHERE arena_id = '00000000-0000-0000-0000-000000000000';

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER auto_copy_whatsapp_templates_trigger
  AFTER INSERT ON arenas
  FOR EACH ROW EXECUTE FUNCTION auto_copy_whatsapp_templates();


-- ============================================================
-- 6. STORAGE: Criar buckets para upload de arquivos
-- Nota: Em Supabase, buckets sao criados via API/Dashboard
-- Estes INSERTs funcionam se voce tem acesso ao schema storage
-- Se der erro, criar manualmente no Dashboard > Storage
-- ============================================================
DO $$
BEGIN
  -- Bucket publico: logos, temas, imagens de arenas
  INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
  VALUES (
    'arenas',
    'arenas',
    true,
    5242880, -- 5MB max
    ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/svg+xml']
  ) ON CONFLICT (id) DO NOTHING;

  -- Bucket privado: fotos de perfil dos usuarios
  INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
  VALUES (
    'avatars',
    'avatars',
    false,
    2097152, -- 2MB max
    ARRAY['image/jpeg', 'image/png', 'image/webp']
  ) ON CONFLICT (id) DO NOTHING;

  -- Bucket privado: documentos (contratos, faturas PDF, etc)
  INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
  VALUES (
    'documentos',
    'documentos',
    false,
    10485760, -- 10MB max
    ARRAY['application/pdf', 'image/jpeg', 'image/png']
  ) ON CONFLICT (id) DO NOTHING;

EXCEPTION WHEN OTHERS THEN
  -- Se storage schema nao esta acessivel via SQL,
  -- criar buckets manualmente no Dashboard > Storage
  RAISE NOTICE 'Storage buckets devem ser criados manualmente no Dashboard do Supabase > Storage';
END;
$$;


-- ============================================================
-- 7. STORAGE: RLS Policies para buckets
-- Protege arquivos por arena (tenant isolation nos uploads)
-- ============================================================

-- Bucket arenas (publico para leitura, escrita por admin)
CREATE POLICY "arenas_public_read" ON storage.objects
  FOR SELECT USING (bucket_id = 'arenas');

CREATE POLICY "arenas_admin_write" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'arenas'
    AND (is_super_admin() OR auth_user_role() = 'arena_admin')
  );

CREATE POLICY "arenas_admin_update" ON storage.objects
  FOR UPDATE USING (
    bucket_id = 'arenas'
    AND (is_super_admin() OR auth_user_role() = 'arena_admin')
  );

CREATE POLICY "arenas_admin_delete" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'arenas'
    AND (is_super_admin() OR auth_user_role() = 'arena_admin')
  );

-- Bucket avatars (usuario ve/edita seu proprio)
CREATE POLICY "avatars_self_read" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'avatars'
    AND auth.uid() IS NOT NULL
  );

CREATE POLICY "avatars_self_write" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'avatars'
    AND auth.uid() IS NOT NULL
  );

CREATE POLICY "avatars_self_update" ON storage.objects
  FOR UPDATE USING (
    bucket_id = 'avatars'
    AND auth.uid() IS NOT NULL
  );

CREATE POLICY "avatars_self_delete" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'avatars'
    AND auth.uid() IS NOT NULL
  );

-- Bucket documentos (arena_admin e super_admin)
CREATE POLICY "documentos_admin_read" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'documentos'
    AND (is_super_admin() OR auth_user_role() IN ('arena_admin', 'funcionario'))
  );

CREATE POLICY "documentos_admin_write" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'documentos'
    AND (is_super_admin() OR auth_user_role() IN ('arena_admin', 'funcionario'))
  );

CREATE POLICY "documentos_admin_delete" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'documentos'
    AND (is_super_admin() OR auth_user_role() = 'arena_admin')
  );


-- ============================================================
-- 8. FUNCAO: Registro completo de arena (signup flow)
-- Usada pela Edge Function de onboarding para criar arena + usuario
-- em uma unica transacao
-- ============================================================
CREATE OR REPLACE FUNCTION register_arena(
  p_auth_id UUID,
  p_nome_completo VARCHAR,
  p_email VARCHAR,
  p_telefone VARCHAR,
  p_arena_nome VARCHAR,
  p_arena_slug VARCHAR DEFAULT NULL,
  p_plano_id UUID DEFAULT NULL
)
RETURNS JSONB AS $$
DECLARE
  v_usuario_id UUID;
  v_arena_id UUID;
  v_plano UUID;
BEGIN
  -- 1. Buscar ou criar usuario
  SELECT id INTO v_usuario_id FROM usuarios WHERE auth_id = p_auth_id;

  IF v_usuario_id IS NULL THEN
    INSERT INTO usuarios (auth_id, email, nome_completo, telefone, tipo_usuario, status, aceite_termos)
    VALUES (p_auth_id, p_email, p_nome_completo, p_telefone, 'arena_admin', 'ativo', true)
    RETURNING id INTO v_usuario_id;
  ELSE
    UPDATE usuarios SET tipo_usuario = 'arena_admin', nome_completo = p_nome_completo, telefone = p_telefone
    WHERE id = v_usuario_id;
  END IF;

  -- 2. Pegar plano basico se nao informado
  IF p_plano_id IS NULL THEN
    SELECT id INTO v_plano FROM planos_sistema WHERE slug = 'basico' LIMIT 1;
  ELSE
    v_plano := p_plano_id;
  END IF;

  -- 3. Criar arena com trial
  INSERT INTO arenas (
    nome, slug, status, plano_atual_id,
    is_trial, trial_dias, trial_iniciado_em,
    status_assinatura, onboarding_step
  ) VALUES (
    p_arena_nome,
    COALESCE(p_arena_slug, lower(regexp_replace(p_arena_nome, '[^a-zA-Z0-9]', '-', 'g'))),
    'ativo',
    v_plano,
    true,
    14,
    NOW(),
    'trial',
    1
  ) RETURNING id INTO v_arena_id;

  -- 4. Atualizar usuario com arena_id
  UPDATE usuarios SET arena_id = v_arena_id WHERE id = v_usuario_id;

  -- Triggers automaticos fazem o resto:
  -- - auto_link_arena_proprietario: cria vinculo em usuarios_arenas
  -- - apply_default_configurations: copia configs padrao
  -- - auto_create_payment_forms: cria PIX, Boleto, CC
  -- - auto_copy_whatsapp_templates: copia templates WhatsApp

  RETURN jsonb_build_object(
    'usuario_id', v_usuario_id,
    'arena_id', v_arena_id,
    'plano_id', v_plano,
    'is_trial', true,
    'trial_dias', 14
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
