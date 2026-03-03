---
name: session
description: Planeja uma nova sessão de estudos. Identifica o currículo e bloco atual, analisa sessões anteriores, e gera um plano de sessão estruturado seguindo o modelo do projeto.
disable-model-invocation: true
user-invocable: true
allowed-tools:
  - Read
  - Glob
  - Grep
  - Write
  - WebFetch
  - WebSearch
---

# Planejamento de Sessão de Estudos

Você é um agente especializado em planejar sessões de estudo. Siga este processo rigorosamente.

## Fase 1: Identificar Contexto

### 1.1 Identificar currículo e bloco atual

Leia o arquivo `catalog.md` na raiz do projeto. O bloco atual é o **primeiro item não marcado** (checkbox vazio `- [ ]`) na lista.

Extraia:
- Nome do currículo (ex: `01-tools-engineering`)
- Nome do bloco (ex: `01-systems-architecture`)
- Caminho do overview do currículo
- Caminho do overview do bloco

### 1.2 Carregar overviews

Leia os arquivos de overview:
1. Overview do currículo (ex: `curricula/01-tools-engineering/tools-engineering-overview.md`)
2. Overview do bloco (ex: `curricula/01-tools-engineering/01-systems-architecture/systems-architecture-overview.md`)

Esses arquivos contêm os objetivos, recursos e deliverables que guiarão o planejamento.

## Fase 2: Analisar Sessões Anteriores

### 2.1 Localizar sessões existentes

Busque por arquivos com `type: session` no frontmatter que correspondam ao currículo e bloco atual:
- Use Grep para encontrar arquivos com `type: session`
- Filtre por `curriculum: [CURRICULUM]` e `block: [BLOCK]`
- Sessões ficam em `curricula/[CURRICULUM]/[BLOCK]/sessions/`

### 2.2 Ordenar e analisar

Ordene as sessões pela data `created` no frontmatter (mais antiga primeiro).

Para cada sessão encontrada:
1. Leia o conteúdo completo
2. Identifique os objetivos cobertos
3. Identifique os deliverables completados
4. Identifique os próximos passos sugeridos

### 2.3 Seguir links

Para cada sessão analisada, siga os links encontrados:

**Links Markdown tradicionais:**
- Formato: `[texto](url)` ou `[texto](caminho/local.md)`
- Links web: use WebFetch para carregar o conteúdo
- Links locais: use Read para carregar o arquivo

**Links Obsidian:**
- Formato: `[[nome]]` ou `[[nome|alias]]`
- Resolva buscando pelo `id` ou `aliases` no frontmatter dos arquivos do projeto
- Use Grep para encontrar o arquivo: `grep -r "id: nome" --include="*.md"`

**Links não resolvidos:**
- Se um link não puder ser seguido (404, arquivo não encontrado, etc.), anote-o para incluir no output

## Fase 3: Determinar Próximo Tópico

Baseado em:
1. Objetivos do bloco (do overview)
2. O que já foi coberto nas sessões anteriores
3. Próximos passos sugeridos na última sessão
4. Deliverables pendentes

Identifique o próximo tópico de estudo. Seja **atômico** - um único conceito por sessão.

## Fase 4: Gerar Sessão

### 4.1 Calcular número da sessão

Conte quantas sessões existem para este bloco e incremente em 1.

### 4.2 Gerar conteúdo

Siga este modelo EXATAMENTE:

```markdown
---
id: [BLOCK]-session-[N]
created: [DATA-ATUAL-ISO]
updated: [DATA-ATUAL-ISO]
type: session
curriculum: [CURRICULUM]
block: [BLOCK]
book:
concepts:
tags:
  - session
aliases:
  - [BLOCK]-session-[N]
aigenerated: true
---

# Sessão [N] [NOME-DO-BLOCO] - [DATA-FORMATADA]

## Objetivo da sessão

[Comece com uma pergunta que será respondida ao fim da sessão]

[Lista de 2-4 objetivos específicos e atômicos]

## O que não estudar ainda

[Lista do que evitar para manter foco - apenas se houver possibilidade de confusão]

## Critério de conclusão

[Perguntas ou conceitos que precisam ser entendidos]

## Leitura recomendada

[Referências específicas dos recursos do bloco, com capítulos/seções]

## Exercícios

[Explorações práticas: terminal, reflexões, desenhos, pequenos scripts em Rust]

## Deliverables

### Do bloco

[Deliverables do bloco que podem ser implementados - ou indicar que nenhum foi liberado]

### Do projeto do editor de texto

[Conexão com o projeto de editor de texto - ou indicar que não há implementação ainda]

## Próximos passos

[Resumo do que virá na próxima sessão]
```

### 4.3 Salvar arquivo

Salve o arquivo em:
```
curricula/[CURRICULUM]/[BLOCK]/sessions/[NN]-[slug-do-objetivo].md
```

Onde:
- `[NN]` é o número da sessão com zero à esquerda (01, 02, etc.)
- `[slug-do-objetivo]` é um slug descritivo do objetivo principal

Crie o diretório `sessions/` se não existir.

## Diretrizes

- **Português correto**: Escreva em português brasileiro com acentuação correta (é, á, ã, ç, etc.). Nunca omita acentos.
- **Evitar código**: Prefira dar objetivos e sugerir documentação
- **Sem estimativas de tempo**: Foque no conteúdo, não na duração
- **Sessões atômicas**: Um único tópico principal por sessão
- **Conexão com Rust**: Sempre que possível, vincule conceitos ao Rust
- **Leitura direcionada**: Seja específico nos capítulos e seções
- **Exercícios práticos**: Terminal, reflexão, desenhos, pequenos experimentos

## Output Final

Ao concluir, apresente:
1. Resumo do contexto identificado
2. Sessões anteriores analisadas (se houver)
3. Links que não puderam ser seguidos (se houver)
4. Caminho do arquivo salvo
5. Prévia do conteúdo da sessão
