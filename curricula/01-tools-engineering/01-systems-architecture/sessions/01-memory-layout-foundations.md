---
id: systems-architecture-session-1
created: 2026-02-25T00:00:00-03:00
updated: 2026-02-25T11:25:28-03:00
type: session
curriculum: 01-tools-engineering
block: 01-systems-architecture
book:
  - csapp
concepts:
  - memory-layout
  - stack
  - heap
  - data-segments
  - address-space
tags:
  - session
aliases:
  - systems-architecture-session-1
aigenerated: true
---

# Sessão 1 Systems Architecture - 25 de Fevereiro de 2026

## Objetivo da sessão

**Pergunta central:** Quando um programa Rust é executado, onde exatamente ficam
as variáveis, funções e dados na memória?

- Entender o layout de memória de um processo: stack, heap, data, text
- Saber diferenciar alocação estática, automática e dinâmica
- Visualizar o espaço de endereçamento virtual de um processo
- Conectar esses conceitos com o que Rust faz por baixo dos panos

## O que não estudar ainda

- Virtual memory em profundidade (paging, page tables) — virá em sessão futura
- Detalhes de CPU caches — bloco posterior
- Memory allocators customizados — virá após entender o básico

## Critério de conclusão

Você deve conseguir responder:

1. Qual a diferença entre stack e heap? Por que Rust prefere stack quando
   possível?
2. O que acontece quando você chama `Box::new()`?
3. Onde fica o código compilado do seu programa na memória?
4. O que são os segmentos .text, .data, .bss e .rodata?
5. Como visualizar o layout de memória de um processo em execução?

## Leitura recomendada

### Computer Systems: A Programmer's Perspective (CS:APP)

- **Capítulo 7.1-7.4**: Linking — explica como o programa é organizado em seções
- **Capítulo 9.1-9.3**: Virtual Memory — conceitos básicos de espaço de
  endereçamento

### Operating Systems: Three Easy Pieces (OSTEP)

- **Capítulo 13**: Address Spaces — introdução clara e visual
- **Capítulo 14**: Memory API — malloc, free, e o que acontece por baixo

### Documentação Rust

- [The Stack and the Heap](https://doc.rust-lang.org/book/ch04-01-what-is-ownership.html#the-stack-and-the-heap)
  — Book oficial

## Exercícios

### 1. Exploração no terminal

Execute os comandos abaixo em um programa Rust simples compilado:

```bash
# Compile um programa Rust com debug symbols
cargo build

# Veja as seções do binário
objdump -h target/debug/seu_programa

# Ou com readelf
readelf -S target/debug/seu_programa
```

Identifique: .text, .rodata, .data, .bss. Anote o tamanho de cada seção.

### 2. Mapa de memória em execução

```bash
# Execute seu programa e em outro terminal:
cat /proc/PID/maps
```

Desenhe um diagrama do espaço de endereçamento que você observou.

### 3. Reflexão

Escreva em um papel ou arquivo:

- Um programa que só usa stack (sem Box, Vec, String)
- Um programa que usa heap
- O que muda no `/proc/PID/maps` entre eles?

### 4. Experimento Rust

Sem escrever código extenso, apenas observe:

```rust
fn main() {
    let x = 42;           // Onde fica x?
    let y = Box::new(42); // Onde fica o 42 de y?
    let s = "hello";      // Onde fica "hello"?
}
```

Use `println!("{:p}", &x)` para imprimir endereços e compare os valores.

## Deliverables

### Do bloco

Nenhum deliverable é liberado nesta sessão. O foco é construir fundamentos
conceituais antes de implementar.

### Do projeto do editor de texto

Nenhuma implementação ainda. Primeiro precisamos entender como a memória
funciona para depois usar `mmap` e carregar arquivos eficientemente.

## Próximos passos

Na próxima sessão, estudaremos **Virtual Memory** — como o sistema operacional
cria a ilusão de que cada processo tem toda a memória para si, e o que são pages
e page faults. Isso é pré-requisito para entender `mmap`.
