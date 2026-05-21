# Rename flutter_ble_peripheral Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace all occurrences of `flutter_ble_peripheral` with `ble_peripheral` in the thesis document and bibliography.

**Architecture:** Systematic search and replace across LaTeX and BibTeX files to reflect the package rename.

**Tech Stack:** LaTeX, BibTeX.

---

### Task 1: Update Architecture Project Analysis

**Files:**
- Modify: `/home/grifinoman/flutter-apps/Bachelor-Thesis/analyza/architektura_projektu.tex`

- [ ] **Step 1: Replace flutter_ble_peripheral**
Replace `flutter_ble_peripheral` with `ble_peripheral` on line 44.

### Task 2: Update Flutter Library Analysis

**Files:**
- Modify: `/home/grifinoman/flutter-apps/Bachelor-Thesis/analyza/flutter_knihovny.tex`

- [ ] **Step 1: Replace all occurrences**
Replace `flutter_ble_peripheral` with `ble_peripheral` on lines 22, 23, and 26.

### Task 3: Update Data Transfer Methods Analysis

**Files:**
- Modify: `/home/grifinoman/flutter-apps/Bachelor-Thesis/analyza/metody_prenosu_dat.tex`

- [ ] **Step 1: Replace occurrence**
Replace `flutter_ble_peripheral` with `ble_peripheral` on line 45.

### Task 4: Update Bibliography

**Files:**
- Modify: `/home/grifinoman/flutter-apps/Bachelor-Thesis/mybase.bib`

- [ ] **Step 1: Replace all occurrences**
Replace `flutter_ble_peripheral` with `ble_peripheral` on lines 83 and 85 (Title and URL).

### Task 5: Final Verification

- [ ] **Step 1: Run grep to ensure no remaining occurrences**
Run: `grep -r "flutter_ble_peripheral" /home/grifinoman/flutter-apps/Bachelor-Thesis/`
Expected: No output.
