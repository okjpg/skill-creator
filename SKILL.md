---
name: criar-skill
description: >
  Cria um SKILL.md completo para Claude Code a partir de qualquer workflow, sessão
  executada ou ideia nova. Acionar quando o usuário pedir para criar, montar, construir
  ou salvar uma skill — mesmo que não use a palavra "skill". Triggers: "cria uma skill",
  "transforma isso em skill", "quero automatizar esse processo", "salva o que você
  acabou de fazer como skill", "faz uma skill de...", "como eu crio uma skill para...",
  "/criar-skill", "transforma essa sessão em skill", "quero repetir isso automaticamente".
  Também ativa ao final de sessões longas quando o usuário pede para capturar o que foi
  feito. NÃO use para executar skills existentes, criar outros tipos de arquivo,
  refatorar código, ou tarefas que não sejam construção de novas skills.
---

# Skill: criar-skill

Cria um SKILL.md completo a partir de workflows existentes ou ideias novas. Roda
QA automático, detecta credenciais expostas, e deploya em `~/.claude/skills/` com
backup opcional no GitHub.

---

## Antes de Começar

Esta skill requer:
- **Claude Code** instalado e rodando (`claude` no terminal)
- Pasta `~/.claude/skills/` existindo (criada automaticamente pelo Claude Code)
- **Opcional:** GitHub CLI (`gh`) autenticado, para backup no GitHub
- **Opcional:** 1Password CLI (`op`) autenticado, para proteger credenciais

Se você não tem `~/.claude/skills/`, rode `claude` uma vez — ele cria a pasta.

---

## Detecção de Modo

Antes de qualquer ação, identificar o modo com base no contexto:

| Condição | Modo |
|----------|------|
| Invocada sem input E há histórico de tarefa executada na sessão | Modo 1: Captura de Sessão |
| Input contém etapas numeradas, bullets de ação, ou palavras como "primeiro/depois/se/quando" | Modo 2: Análise de Workflow |
| Input é descrição vaga, ideia ou intenção sem etapas definidas | Modo 3: Entrevista |
| Ambíguo | Perguntar: "Você quer capturar o que fizemos nessa sessão, analisar um workflow que vai colar, ou criar algo novo do zero?" |

---

## Modo 1: Captura de Sessão

**Quando:** Invocada sem input após execução de tarefa longa na mesma sessão.

1. Ler o histórico completo da conversa atual.
2. Extrair três camadas:
   - **Fluxo principal:** todas as ações executadas em ordem sequencial
   - **Decision points:** condicionais identificadas (ex: "SE login expirado → renovar sessão antes de prosseguir")
   - **Edge cases:** erros que ocorreram + como foram resolvidos
3. Montar rascunho do SKILL.md seguindo o template em `references/skill-anatomy.md`.
4. Apresentar o rascunho: "Identifiquei esses passos. Está correto? Posso ajustar qualquer etapa antes de prosseguir."
5. Aguardar confirmação ou correções.
6. Após confirmação, ir para **QA Automático**.

---

## Modo 2: Análise de Workflow

**Quando:** O usuário cola texto com etapas, notas ou processo descrito.

1. Identificar estrutura de processo no texto colado.
2. Extrair:
   - Ações sequenciais → seção Workflow
   - Condicionais → decision points dentro do Workflow
   - Situações de falha mencionadas → Edge Cases
3. Se algum passo ficou ambíguo, fazer no máximo 2 perguntas de esclarecimento antes de gerar.
4. Montar SKILL.md seguindo `references/skill-anatomy.md`.
5. Ir para **QA Automático**.

---

## Modo 3: Entrevista

**Quando:** O usuário descreve uma ideia sem estrutura de processo definida.

### Fase 1 — Definição da tarefa
- Perguntar: "O que essa skill faz? Descreva o input e o output específico."
- Se a resposta for vaga (ex: "ajuda com emails"), pedir: "Pode descrever um exemplo concreto? O que entra exatamente, o que sai?"
- Confirmar em 1 frase: "Então essa skill recebe [X] e produz [Y]. Correto?"
- Não avançar até ter confirmação explícita.

### Fase 2 — Triggers
- Perguntar: "Quais são as 5 formas diferentes que você digitaria para ativar essa skill?"
- Sugerir 3-5 frases adicionais que o usuário provavelmente não mencionou.
- Perguntar: "O que NÃO deve ativar essa skill? Quais pedidos parecidos mas diferentes ela deve ignorar?"

### Fase 3 — Padrão de qualidade
- Perguntar: "Como é um output perfeito? Se puder, mostre um exemplo real."
- Perguntar: "Como é um output que falhou? O que você não quer ver?"
- Perguntar: "Qual o input mais quebrado ou incompleto que essa skill poderia receber? Como deve reagir?"

### Fase 4 — Confirmar brief
Compilar e apresentar:
```
Nome sugerido: [kebab-case]
Propósito: [1 frase]
Triggers: [lista]
Negative boundaries: [lista]
Input: [descrição]
Output: [descrição]
Edge cases: [lista]
```
Perguntar: "Está correto? Posso ajustar qualquer campo antes de gerar."
Após confirmação, gerar SKILL.md com `references/skill-anatomy.md` e ir para **QA Automático**.

---

## QA Automático

Executar TODOS os 9 checks antes de mostrar o SKILL.md gerado. Não pular nenhum.

```
□ 1. Nome em kebab-case? (sem espaços, sem underscores, sem maiúsculas)
□ 2. Description com 50+ palavras, terceira pessoa, 5+ trigger phrases, negative boundaries?
□ 3. Cada etapa do Workflow é uma ação única, imperativa e não-ambígua?
□ 4. Pelo menos 2 exemplos concretos com input real → output real?
□ 5. Edge Cases cobertos? (input faltando, ambíguo, formato errado)
□ 6. Output Format explicitamente definido?
□ 7. Sem linguagem vaga? ("handle appropriately", "format nicely", "as needed" são proibidos)
□ 8. Negative boundaries definidos no YAML?
□ 9. SKILL.md contém credencial, senha, token ou API key hardcoded?
```

**Score < 7:** corrigir os itens com falha automaticamente, sem mostrar ao usuário.
**Score ≥ 7:** mostrar SKILL.md com score "QA: X/9 ✓" e listar o que ainda poderia melhorar.

### Se check 9 falhar (credencial detectada):

1. Executar `op --version` para verificar se 1Password CLI está disponível.
2. **Se op disponível:**
   - Listar itens: `op item list --vault "{SEU_VAULT}"`
   - Se credencial já existe no vault: substituir no SKILL.md por:
     `op item get "{NOME_DO_ITEM}" --vault "{SEU_VAULT}" --field credential --reveal`
   - Se não existe: criar com `op item create --category login --vault "{SEU_VAULT}"`,
     depois referenciar conforme acima.
3. **Se op ausente:**
   - Salvar credencial no `.env` do projeto atual (ou `~/.claude/.env` se não houver projeto).
   - Substituir no SKILL.md pela variável de ambiente: `$NOME_DA_CREDENCIAL`
   - Informar: "Salvei a credencial em .env como $NOME_DA_CREDENCIAL. Não commite esse arquivo."

---

## Apresentação e Revisão

Após QA aprovado:

1. Mostrar o SKILL.md completo.
2. Exibir: "QA: X/9 ✓" e lista dos itens que poderiam melhorar (se houver).
3. Perguntar: "Quer ajustar algo antes do deploy?"
4. Aguardar aprovação explícita antes de prosseguir.

---

## Deploy

Após aprovação do SKILL.md:

### Deploy Claude Code

1. Criar pasta `~/.claude/skills/{nome-da-skill}/`
2. Salvar o SKILL.md nessa pasta.
3. Confirmar: "✓ Deployado em ~/.claude/skills/{nome}/"

### GitHub (opcional)

Perguntar: "Quer salvar no GitHub como backup?"

Se sim:
1. Verificar autenticação: `gh auth status`
   - Se não autenticado: "Execute `gh auth login` e tente novamente."
2. Perguntar: "Qual o nome do seu repositório? (ex: {SEU_USUARIO}/skills)"
3. Verificar se repo existe: `gh repo view {REPO}`
   - Se não existe: `gh repo create {REPO} --public`
4. Commit e push com mensagem: `feat: add {nome} skill`
5. Confirmar com URL do arquivo no GitHub.

---

## Refinamento Pós-Deploy

**Uma skill deployada não é uma skill pronta. É uma skill que precisa ser testada.**

Após o deploy, rodar a skill com um input real. Quando algo sair errado, não descarte — corrija a instrução no SKILL.md e teste de novo. Skills melhoram com uso.

Guia completo de refinamento com exemplo real: `references/guia-refinamento.md`

---

## Edge Cases

- **Modo 1 sem histórico relevante:** "Não encontrei um workflow executado nessa sessão. Quer colar um processo ou criar algo do zero?"
- **Skill com nome já existente:** "Já existe uma skill chamada {nome}. Deseja sobrescrever, renomear ou cancelar?"
- **Workflow com mais de 50 etapas:** Sugerir dividir em 2-3 skills menores antes de gerar. Apresentar sugestão de como dividir.
- **Usuário cancela durante entrevista:** Salvar brief parcial em `~/.claude/skills/criar-skill/drafts/{nome}-draft.md` e informar o caminho.
- **GitHub sem autenticação gh CLI:** "gh CLI não autenticado. Execute `gh auth login` e tente de novo."
- **op CLI disponível mas não autenticado:** "1Password CLI encontrado mas não autenticado. Execute `op signin` ou use .env como alternativa."

---

## Exemplos

### Exemplo 1 — Captura de Sessão

**Contexto:** Acabou de executar um workflow de emissão de NF na prefeitura.
**Input:** `/criar-skill` (sem texto adicional)

**Output esperado:**
```
Identifiquei esses passos na sessão:

## Workflow
1. Acessar portal da prefeitura
2. SE sessão expirada → fazer login antes de prosseguir
3. Clicar em "Emitir NF"
4. Preencher campos: tomador (CNPJ), serviço (código), valor, descrição
5. Confirmar emissão → aguardar processamento (5-10 segundos)
6. Baixar PDF gerado

## Edge Cases identificados
- Se portal retornar erro 503: aguardar 30s e tentar novamente
- Se CNPJ do tomador não encontrado: verificar cadastro no sistema antes de emitir

Está correto? Posso ajustar qualquer etapa antes de prosseguir.
```

### Exemplo 2 — Modo Entrevista (ideia vaga)

**Input:** "quero criar uma skill que me ajuda a responder comentários no Instagram"

**Output esperado (Fase 1):**
```
Entendi que você quer automatizar respostas no Instagram.

Para montar essa skill corretamente, preciso entender o que entra e o que sai.

O que entra: você cola o comentário aqui e eu sugiro uma resposta?
Ou você quer que eu acesse o Instagram diretamente e responda?
```

### Exemplo 3 — Modo Análise de Workflow

**Input:** "toda semana eu: 1) acesso o notion, 2) pego os cards marcados como 'publicar', 3) exporto o texto, 4) formato pra linkedin, 5) agende no buffer"

**Output esperado:**
```
Identifiquei um workflow de publicação semanal com 5 etapas.

Antes de gerar, 2 perguntas rápidas:

1. No passo 4 (formatar pro LinkedIn): você segue algum padrão específico de formato? (ex: tamanho máximo, emojis, estrutura de parágrafos)
2. O agendamento no Buffer é manual ou você quer que a skill faça via API?
```
