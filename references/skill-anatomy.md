# Anatomia de um SKILL.md (Claude Code)

## Estrutura obrigatória

```
---
name: kebab-case-sem-espacos
description: >
  [50+ palavras. Terceira pessoa ("Processa...", não "Eu processo...").
  5+ trigger phrases explícitas que o usuário poderia digitar.
  Negative boundaries: "NÃO use para X, Y, Z."
  Quanto mais específico, melhor.]
---

# [Nome da Skill]

[Parágrafo de Overview: o que a skill faz e quando ativa — escrito para o Claude, não para humano]

## Workflow
1. [Ação imperativa específica — "Ler o arquivo X" não "O arquivo X deve ser lido"]
2. [SE condição → ação alternativa]
3. [Próxima ação]
...

## Output Format
[Estrutura exata do output: tipo de arquivo, seções, formatação, tom]

## Edge Cases
- Se [condição específica]: [ação específica]
- Se [input faltando]: [o que fazer]
- Se [formato errado]: [o que fazer]

## Examples

### Exemplo 1 (happy path)
Input: [exemplo real e concreto]
Output: [exemplo real e concreto do que Claude deve produzir]

### Exemplo 2 (edge case)
Input: [exemplo de input quebrado ou incomum]
Output: [como Claude deve reagir]
```

## Regras de qualidade

**YAML description:**
- Terceira pessoa obrigatória
- Mínimo 5 trigger phrases explícitas
- Negative boundaries sempre presentes
- "Pushy": quanto mais específico, maior a chance de ativar corretamente

**Workflow:**
- Cada passo = uma única ação
- Voz imperativa: "Ler", "Extrair", "Perguntar" — não "Deve ser lido", "É necessário extrair"
- Condicionais explícitas: "SE [condição] → [ação]"
- Sem linguagem vaga: banido "handle appropriately", "format nicely", "as needed", "quando relevante"

**Exemplos:**
- Input e output REAIS, não descrições abstratas
- Pelo menos 1 edge case
- Quanto mais concretos, melhor o comportamento

## Tamanho ideal
- 100 a 300 linhas
- Acima de 300: considerar dividir em múltiplas skills ou mover conteúdo para references/
