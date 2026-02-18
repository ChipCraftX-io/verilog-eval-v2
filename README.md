# VerilogEval v2 Benchmark Results — ChipCraftX

**98.7% pass rate (154/156)** on the VerilogEval v2 spec-to-RTL benchmark, establishing a new state-of-the-art for AI-powered Verilog generation.

<p align="center">

| Metric | Value |
|--------|-------|
| **Pass Rate** | **154/156 (98.7%)** |
| **First-Attempt Pass** | 133/156 (85.3%) |
| **Avg Iterations** | 1.15 |
| **Total Time** | 35.5 min |
| **Avg Time/Problem** | 13.7s |

</p>

## About VerilogEval v2

[VerilogEval](https://github.com/NVlabs/verilog-eval) is the standard benchmark for evaluating LLM-based Verilog code generation, developed by NVIDIA Research. The **spec-to-RTL** variant (v2) presents 156 hardware design problems as natural language specifications — ranging from simple combinational logic to complex finite state machines — and requires generating functionally correct, synthesizable Verilog-2001 RTL.

Each generated module is validated through:
1. **Compilation** via Icarus Verilog (iverilog)
2. **Functional simulation** comparing output waveforms against a golden reference module

This is the most practically relevant evaluation: it mirrors real-world hardware design where engineers write RTL from specifications, not by completing partial code.

## Comparison with Prior Work

### Agentic / Iterative Systems (multi-turn with EDA feedback)

| System | Pass Rate | Max Iters | LLM Backbone | Year |
|--------|-----------|-----------|-------------|------|
| **ChipCraftX (Ours)** | **98.7%** | **5** | **Claude Sonnet 4.5 / Opus** | **2026** |
| MAGE | 95.7% | 10 | GPT-4 | 2024 |
| REvolution + DeepSeek-V3 | 95.5% | — | DeepSeek-V3 | 2025 |
| VerilogCoder | ~94% | 10 | GPT-4 | 2024 |

### Single-Turn Systems (one LLM call, no EDA feedback)

| System | Pass Rate | LLM | Year |
|--------|-----------|-----|------|
| GPT-4o | 62.6% | GPT-4o | 2024 |
| Llama 3.1 405B | 58.3% | Llama 3.1 | 2024 |
| GPT-4 Turbo | 56.7% | GPT-4 Turbo | 2024 |
| RTL-Coder 6.7B | 34.0% | RTL-Coder | 2024 |

> **Note:** Agentic systems use iterative compilation/simulation feedback loops, making them not directly comparable to single-turn approaches. Both categories are included for completeness. ChipCraftX achieves the highest reported pass rate in either category.

## System Architecture

ChipCraftX is a multi-agent RTL generation system with iterative EDA validation:

```
Natural Language Spec
        │
        ▼
┌─────────────────────┐
│  Spec Analysis &    │  Architecture detection, complexity estimation,
│  Guidance Injection │  pattern-specific guidance from 321-entry knowledge base
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│  Multi-Agent LLM    │  Agent selection: GENIUS (Opus) for complex specs,
│  Generation         │  FAST (Sonnet) for quick iterations, DEBUG for fixes
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│  EDA Validation     │  iverilog compile → vvp simulate → compare with
│  (Icarus Verilog)   │  golden reference
└────────┬────────────┘
         │
    ┌────┴────┐
    │  PASS?  │──── Yes ──→ Done
    └────┬────┘
         │ No
         ▼
┌─────────────────────┐
│  Error Analysis &   │  Parse errors, select repair strategy,
│  Iterative Repair   │  re-generate (up to 5 iterations)
└─────────────────────┘
```

### Key Components

- **Multi-Agent System**: 5 specialized agents (GENIUS, FAST, DEBUG, OPTIMIZE, TESTBENCH) with different LLM configurations optimized for different problem types
- **Knowledge Base**: 321 curated hardware design patterns covering FSMs, memories, interfaces, arithmetic, CDC, and more
- **Spec Guidance**: Pattern-specific guidance injection that enriches natural language specs with structural hints for known problem archetypes
- **Algorithmic Solvers**: K-map and truth table solvers for combinational logic problems (6 problems solved deterministically, 0 iterations)
- **Iterative Debugging**: Up to 5 iterations of compile → simulate → analyze errors → re-generate

## Results Breakdown

### Iteration Distribution

| Iterations | Problems | Description |
|-----------|----------|-------------|
| 0 | 6 | Solved by algorithmic K-map solver (no LLM needed) |
| 1 | 133 | First-attempt pass (85.3%) |
| 2 | 12 | Passed after one correction |
| 3 | 1 | Required two corrections |
| 4 | 2 | Required three corrections |
| 5 | 2 | Max iterations reached (failed) |

### Failures (2/156)

| Problem | Type | Failure Mode | Notes |
|---------|------|-------------|-------|
| Prob066_edgecapture | Sequential | Simulation mismatch | 32-bit edge capture register |
| Prob092_gatesv100 | Combinational | Compile error | 100-bit neighbor vector operations |

### Problem Categories Covered

The 156 problems span the full range of digital design:

- **Combinational Logic**: Gates, multiplexers, decoders, encoders, priority circuits
- **Arithmetic**: Adders, subtractors, population counts, BCD
- **Sequential Logic**: Flip-flops, counters, shift registers, edge detection
- **Finite State Machines**: Mealy/Moore machines, serial protocols, timers, game logic
- **Memory & Buffers**: Shift registers, history buffers, Conway's Game of Life
- **Complex Systems**: PS/2 protocol, serial receivers, branch predictors, fancy timers

## Repository Structure

```
├── README.md                          # This file
├── results/
│   └── benchmark_results.json         # Full per-problem results with metrics
└── solutions/
    ├── Prob001_zero/
    │   └── TopModule.v                # Generated Verilog solution
    ├── Prob002_m2014_q4i/
    │   └── TopModule.v
    ├── ...
    └── Prob156_review2015_fancytimer/
        └── TopModule.v
```

### Results JSON Schema

Each entry in `results/benchmark_results.json` contains:

```json
{
  "problem_id": "Prob001_zero",
  "passed": true,
  "iterations": 1,
  "elapsed_seconds": 0.8,
  "compile_passed": true,
  "sim_passed": true
}
```

## Reproducing Results

### Prerequisites

Results were generated using the [VerilogEval v2](https://github.com/NVlabs/verilog-eval) benchmark dataset (spec-to-RTL variant, 156 problems). Validation used:

- **Icarus Verilog** v12 (`iverilog -g2005-sv`)
- **Python** 3.11+
- **Golden reference modules** provided by the VerilogEval benchmark

### Validation

Each solution can be independently verified:

```bash
# Clone the official VerilogEval benchmark
git clone https://github.com/NVlabs/verilog-eval.git

# For any problem (e.g., Prob001_zero):
cd verilog-eval/dataset_spec-to-rtl

# Compile solution with testbench and reference
iverilog -g2005-sv -o sim \
    ../../solutions/Prob001_zero/TopModule.v \
    Prob001_zero_ref.sv \
    Prob001_zero_tb.sv

# Run simulation
vvp sim
```

A simulation producing `0 mismatches` confirms functional correctness.

## Citation

If you use these results in your research, please cite:

```bibtex
@inproceedings{chipcraftbrain2026,
    title={ChipCraftBrain: From Spec to Silicon, Multi-Agent RL for Automated RTL Generation},
    author={ChipCraftX},
    year={2026},
    address={San Francisco, CA},
    url={https://chipcraftx.io}
}
```

## References

- [VerilogEval: Evaluating Large Language Models for Verilog Code Generation](https://arxiv.org/abs/2309.07544) — Liu et al., 2023 (ICCAD)
- [Revisiting VerilogEval: Newer LLMs, In-Context Learning, and Specification-to-RTL Tasks](https://arxiv.org/abs/2408.11053) — Pinckney et al., 2024 (ACM TODAES)
- [MAGE: A Multi-Agent Engine for Automated RTL Code Generation](https://arxiv.org/abs/2412.07822) — Zhang et al., 2024
- [VerilogCoder: Autonomous Verilog Coding Agents with Graph-based Planning](https://arxiv.org/abs/2408.08927) — Ho et al., 2024

## License

This repository contains benchmark results and generated Verilog solutions. The VerilogEval benchmark dataset is maintained by [NVIDIA Research](https://github.com/NVlabs/verilog-eval) under its own license.

Generated Verilog solutions are released under the [MIT License](LICENSE).
