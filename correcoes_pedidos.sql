-- ============================================
-- ELINE BOLOS — Correções de Pedidos
-- Cole no SQL Editor do Supabase e execute
-- ============================================

-- 1. PROBLEMA: pedidos apagados no admin "voltam" após recarregar a página
-- CAUSA: não existia política de DELETE para a tabela pedidos.
--        O Supabase bloqueia o delete silenciosamente (sem erro),
--        então a linha nunca é removida de verdade do banco.
DROP POLICY IF EXISTS "pedidos_delete" ON pedidos;
CREATE POLICY "pedidos_delete" ON pedidos FOR DELETE TO anon USING (true);

-- 2. NOVA FUNCIONALIDADE: confirmação manual de pagamento
-- Agora o pedido é salvo no painel assim que o cliente gera o PIX,
-- clica no link de cartão ou escolhe pagar em dinheiro — mesmo que
-- ele feche o navegador antes de voltar. A Eline confirma manualmente
-- quando o pagamento realmente cair.
ALTER TABLE pedidos
  ADD COLUMN IF NOT EXISTS pagamento_confirmado BOOLEAN NOT NULL DEFAULT false;
