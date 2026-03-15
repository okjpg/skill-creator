# skill-creator

Uma skill para Claude Code e agentes de IA que cria outras skills automaticamente.

Você descreve um processo. O agente transforma em uma skill estruturada, passa por QA automático, e faz o deploy em `~/.claude/skills/` — pronta para usar.

---

## O que é uma skill?

Uma skill é um arquivo de instrução (SKILL.md) que você coloca no Claude Code para automatizar tarefas repetitivas. Em vez de explicar o que fazer toda vez, você escreve uma vez e o Claude executa sempre que você acionar.

Exemplos de skills que você pode criar com esse repositório:
- Skill de geração de posts LinkedIn a partir de vídeos
- Skill de emissão de notas fiscais
- Skill de análise de concorrentes
- Skill de responder comentários com seu tom de voz
- Qualquer processo que você repete toda semana

---

## Como instalar

### Uma linha

```bash
curl -fsSL https://raw.githubusercontent.com/okjpg/skill-creator/main/install.sh | bash
```

O script detecta automaticamente se você tem Claude Code, OpenClaw, ou ambos — e instala em todos os ambientes encontrados.

Depois da instalação, abra seu agente e digite:
```
/criar-skill
```

### Telegram (via agente de IA)

Copie o conteúdo de `prompt-instalacao.md` e envie para o seu agente no Telegram. O agente vai executar a instalação automaticamente.

---

## Como usar

### 3 formas de criar uma skill

**Modo 1 — Capturar o que você acabou de fazer**

Você acabou de executar um processo no Claude. Digita:
```
/criar-skill
```
O agente lê o histórico da sessão, identifica os passos, e gera a skill automaticamente.

**Modo 2 — Colar um workflow existente**

Você tem um processo descrito em texto (notas, Notion, papel). Cola no chat:
```
/criar-skill

Todo dia eu: 1) acesso o painel, 2) exporto o relatório, 3) formato e mando por email
```
O agente extrai os passos e gera a skill.

**Modo 3 — Descrever uma ideia**

Você tem uma ideia vaga do que quer automatizar:
```
/criar-skill quero algo que me ajude a responder comentários no Instagram
```
O agente faz perguntas para entender o que entra, o que sai, e como é um resultado perfeito. Depois gera.

---

## O que acontece depois que você digita /criar-skill

```
Você descreve →  Claude estrutura o workflow
                    ↓
              QA automático (10 checks)
                    ↓
              Você revisa e aprova
                    ↓
              Deploy em ~/.claude/skills/
              (SKILL.md + evals/evals.json)
                    ↓
              Skill pronta para usar
```

O QA automático verifica:
- Nome no formato correto (kebab-case)
- Descrição com triggers suficientes para o Claude entender quando ativar
- Cada passo do workflow é claro e imperativo
- Exemplos reais de input e output
- Edge cases cobertos
- Sem credenciais expostas no arquivo
- Evals preparados para teste (prompt + output esperado)

---

## Estrutura de uma skill gerada

Toda skill criada pelo `/criar-skill` gera no mínimo:

```
skill-name/
├── SKILL.md              # Workflow, regras, edge cases
└── evals/
    └── evals.json        # Casos de teste (prompt + expected_output)
```

O `evals.json` permite testar se a skill está funcionando corretamente após refinamentos e serve como documentação de uso para quem instalar a skill.

Opcionais (quando necessário):
- `references/` — docs de apoio, specs, guias de estilo
- `scripts/` — código executável (ex: geração de imagem, PDF)
- `assets/` — fontes, templates, arquivos estáticos

---

## Skills não saem perfeitas na primeira vez

Isso é esperado e normal.

Depois do deploy, rode a skill com um input real. Quando algo sair errado, identifique a causa e corrija a instrução no SKILL.md. Skills melhoram com uso — cada refinamento que você documenta torna a skill mais robusta para sempre.

Guia completo: `references/guia-refinamento.md`

---

## Estrutura do repositório

```
skill-creator/
├── SKILL.md                        # A skill em si (instalar aqui)
├── README.md                       # Este arquivo
├── LICENSE                         # MIT
├── prompt-instalacao.md            # Prompt para configurar via agente
├── evals/
│   └── evals.json                  # Casos de teste do próprio skill-creator
└── references/
    ├── skill-anatomy.md            # Template de anatomia de uma skill
    └── guia-refinamento.md         # Guia de refinamento pós-deploy
```

---

## Requisitos

- [Claude Code](https://claude.ai/code) instalado
- Opcional: [GitHub CLI](https://cli.github.com/) para backup das skills no GitHub
- Opcional: [1Password CLI](https://developer.1password.com/docs/cli/) para proteger credenciais

---

## Feito por

Bruno Okamoto — fundador do maior ecossistema de Micro-SaaS do Brasil.

[LinkedIn](https://linkedin.com/in/brunookamoto) · [YouTube](https://youtube.com/@brunookamoto) · [Comunidade Micro-SaaS PRO](https://microsaas.com.br)
