# Prompt de Instalação — skill-creator

Copie e cole este prompt no seu agente (Claude Code, Telegram, ou qualquer interface de IA) para instalar a skill-creator automaticamente.

---

## Prompt de instalação completa

```
Quero instalar a skill-creator no meu Claude Code. Siga os passos abaixo:

1. Verificar se Claude Code está instalado
   - Rodar: claude --version
   - Se não estiver instalado: informar que preciso instalar em claude.ai/code antes de continuar

2. Criar a estrutura de pastas da skill
   - Criar: ~/.claude/skills/criar-skill/
   - Criar: ~/.claude/skills/criar-skill/references/

3. Baixar os arquivos do repositório okjpg/skill-creator
   - Opção A (com git): git clone https://github.com/okjpg/skill-creator /tmp/skill-creator-tmp
   - Opção B (com curl, arquivo por arquivo):
     curl -s https://raw.githubusercontent.com/okjpg/skill-creator/main/SKILL.md -o ~/.claude/skills/criar-skill/SKILL.md
     curl -s https://raw.githubusercontent.com/okjpg/skill-creator/main/references/skill-anatomy.md -o ~/.claude/skills/criar-skill/references/skill-anatomy.md
     curl -s https://raw.githubusercontent.com/okjpg/skill-creator/main/references/guia-refinamento.md -o ~/.claude/skills/criar-skill/references/guia-refinamento.md

4. Se usou Opção A (git clone), copiar os arquivos para o lugar certo:
   cp /tmp/skill-creator-tmp/SKILL.md ~/.claude/skills/criar-skill/SKILL.md
   cp /tmp/skill-creator-tmp/references/skill-anatomy.md ~/.claude/skills/criar-skill/references/
   cp /tmp/skill-creator-tmp/references/guia-refinamento.md ~/.claude/skills/criar-skill/references/
   rm -rf /tmp/skill-creator-tmp

5. Verificar que os arquivos estão no lugar:
   ls ~/.claude/skills/criar-skill/
   ls ~/.claude/skills/criar-skill/references/

6. Confirmar a instalação rodando:
   cat ~/.claude/skills/criar-skill/SKILL.md | head -5

7. Informar: "✓ skill-creator instalada em ~/.claude/skills/criar-skill/ — use /criar-skill para começar"

Se qualquer passo falhar: mostrar o erro exato e sugerir o que fazer.
```

---

## Prompt de teste pós-instalação

Depois de instalar, use este prompt para testar se a skill está funcionando:

```
Quero testar a skill-creator.

Crie uma skill simples chamada "ola-mundo" que, quando eu digitar "oi" ou "olá", responda com uma saudação personalizada usando meu nome.

Use o modo entrevista (/criar-skill) para criar essa skill do zero.
```

---

## Prompt de criação rápida (Modo 2 — workflow colado)

Use quando você já tem um processo descrito:

```
/criar-skill

Meu processo toda semana:
1. Acesso o [FERRAMENTA] e exporto o relatório de [TIPO]
2. Abro no Excel e filtro por [CRITÉRIO]
3. Copio os dados e formato num email no padrão: assunto "[ASSUNTO]", destinatários [LISTA]
4. Reviso e envio

Quero automatizar os passos 2 e 3.
```

Substitua os valores entre colchetes pelo seu processo real antes de enviar.

---

## Prompt de captura de sessão (Modo 1 — pós-execução)

Use depois de executar qualquer tarefa longa no Claude Code:

```
/criar-skill

Acabei de executar esse processo com você. Captura tudo que fizemos nessa sessão e transforma em uma skill para eu poder repetir sempre que precisar.
```

---

## Prompt para Telegram (agente configurado com Claude)

Se você usa um bot no Telegram conectado ao Claude, envie:

```
Instala a skill skill-creator no meu Claude Code.
Repositório: https://github.com/okjpg/skill-creator
Segue as instruções do arquivo prompt-instalacao.md
```

O agente vai executar os passos de instalação via terminal no seu computador (requer que o agente tenha acesso ao shell local ou via SSH).

---

## Solução de problemas comuns

**"claude: command not found"**
Claude Code não está instalado. Acesse claude.ai/code para instalar.

**"Permission denied" ao criar ~/.claude/skills/"**
Rodar com permissão correta:
```bash
mkdir -p ~/.claude/skills/criar-skill/references
chmod 755 ~/.claude/skills/criar-skill
```

**"curl: command not found"**
Usar wget como alternativa:
```bash
wget -q https://raw.githubusercontent.com/okjpg/skill-creator/main/SKILL.md -O ~/.claude/skills/criar-skill/SKILL.md
```

**A skill não ativa quando digito /criar-skill**
Fechar e reabrir o Claude Code — skills são carregadas na inicialização.
