---
theme: default
colorSchema: dark
title: "Deck Title"
info: One-line description of the deck
class: text-left
transition: slide-left
mdc: true
css: ./style.css
---

<div class="hero-card">
  <p class="kicker">Category</p>
  <h1>Main Title Goes Here</h1>
  <p class="hero-copy">One or two sentences establishing the core claim.</p>
</div>

---

<p class="kicker">Section Label</p>

## Concrete Heading That Carries the Point

<div class="grid grid-cols-2 gap-5 items-start">
<div class="glass-card">
<ul class="tight-list">
  <li>First key point</li>
  <li>Second key point</li>
  <li>Third key point</li>
</ul>
</div>
<div class="glass-card">
<ul class="tight-list">
  <li>Supporting detail or second angle</li>
  <li>Another supporting point</li>
</ul>
</div>
</div>

---

<p class="kicker">Architecture</p>

## Slide With a Mermaid Diagram

<div class="grid grid-cols-2 gap-5 items-start">
<div class="glass-card">
<ul class="tight-list">
  <li>Explain what the diagram shows</li>
  <li>Call out the key transition</li>
  <li>Note the terminal state</li>
</ul>
</div>
<div class="diagram-card">

```mermaid {scale: 0.68}
stateDiagram-v2
  direction LR
  [*] --> StateA
  StateA --> StateB: action
  StateB --> StateC: next
  StateC --> [*]
```

</div>
</div>

---

<p class="kicker">Features</p>

## Slide With Pills and Chips

<div class="grid grid-cols-2 gap-5 items-start">
<div class="glass-card">
<ul class="tight-list">
  <li>Feature description one</li>
  <li>Feature description two</li>
  <li>Feature description three</li>
</ul>
</div>
<div class="glass-card">
<p><strong>ENUM_NAME</strong></p>
<div class="chip-row">
  <span class="pill">value_one</span>
  <span class="pill">value_two</span>
  <span class="pill">value_three</span>
  <span class="pill">value_four</span>
</div>
</div>
</div>

---

<p class="kicker">Impact</p>

## Three-Column Metrics Slide

<div class="grid grid-cols-3 gap-5 items-start">
<div class="glass-card">
<p><strong>Metric A ↑</strong></p>
<ul class="mini-list">
  <li>Reason one</li>
  <li>Reason two</li>
</ul>
</div>
<div class="glass-card">
<p><strong>Metric B ↓</strong></p>
<ul class="mini-list">
  <li>Reason one</li>
  <li>Reason two</li>
</ul>
</div>
<div class="glass-card">
<p><strong>Metric C ↑</strong></p>
<ul class="mini-list">
  <li>Reason one</li>
  <li>Reason two</li>
</ul>
</div>
</div>
