# Guia de Refinamento Pós-Deploy

**Uma skill deployada não é uma skill pronta. É uma skill que precisa ser testada.**

O `/criar-skill` gera o melhor SKILL.md possível com as informações disponíveis. Mas algumas coisas só aparecem quando a skill roda de verdade — respostas de API inesperadas, tom que fica levemente errado, comportamento que faz sentido no papel mas falha na prática.

Isso é normal. É o processo.

---

## O que testar após o deploy

Rodar a skill com um input real e avaliar cada etapa:

1. **A entrada funcionou?** A skill recebeu os dados do jeito esperado (URL, texto, arquivo)?
2. **O processamento gerou o resultado certo?** A saída tem o conteúdo correto, no formato correto, no tom correto?
3. **As integrações funcionaram?** APIs responderam como esperado? Os dados foram salvos onde deveriam?
4. **O resultado parece genérico?** Se qualquer pessoa poderia ter produzido aquela saída, a skill não está usando os diferenciais que você definiu.

---

## Como refinar quando algo sair errado

Quando um resultado ficar ruim, não descarte — **documente o erro e corrija a instrução**:

- **Resultado genérico/abstrato:** Adicionar exemplos concretos na seção de geração. A skill precisa de âncoras reais, não só regras.
- **Tom errado:** Incluir referência a exemplos reais do seu conteúdo publicado. O guia analítico descreve o estilo — os exemplos demonstram.
- **Integração com formato inesperado:** Testar a API, documentar o campo correto no arquivo de configuração, corrigir o código.
- **Comportamento incompleto:** Adicionar um edge case específico para aquela situação.

---

## Exemplo real: refinamento da skill /linkedin-posts

Essa skill passou por 3 ciclos de refinamento após o deploy:

**Ciclo 1 — Tom genérico**
Posts gerados soavam como conteúdo de consultor de marketing, não como o autor.
Causa: a skill lia o guia analítico de voz, mas não os posts reais como exemplos.
Correção: incluir instrução explícita de ler exemplos reais (posts publicados) como calibração antes de gerar.

**Ciclo 2 — Posts curtos, sem storytelling**
Posts tinham as regras de formatação certas (frases curtas, setas, sem emojis) mas faltava a narrativa.
Causa: as regras diziam O QUE evitar, mas não descreviam a estrutura narrativa esperada.
Correção: adicionar instrução explícita de estrutura: hook → contexto pessoal → jornada → insight → fechamento.

**Ciclo 3 — API com formato diferente do documentado**
O campo para extrair o ID do bloco criado era `items[0].id`, não `blocks[0].pageId` como estava documentado.
Causa: documentação escrita antes de testar a API em produção.
Correção: testar a chamada real, documentar o campo correto no arquivo de configuração.

**Conclusão:** a skill ficou boa depois de 3 rodadas de teste → erro → correção → reteste. Não em uma.

---

## Mentalidade certa

Skills são como receitas: na primeira vez que você tenta, descobre o que precisa ajustar. Na segunda, você sabe exatamente o que fazer. Na terceira, está no automático.

Cada correção que você documenta no SKILL.md torna a skill mais robusta para sempre — não só para a próxima vez que você usar, mas para qualquer pessoa da equipe que usar depois.
