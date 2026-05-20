# Contributing to ESC Firmware

Thank you for contributing to the ESC Firmware repository!

## Project Overview

This repository contains firmware and control software for several hardware subsystems:

| Subsystem | Directory |
|-----------|-----------|
| Deformable Mirror | `DMInterface/` |
| Fine Steering Mirror | `FineSteeringMirrorController/` |
| Filter Wheel | `Filterwheel/`, `FilterwheelTq144/` |
| PZT Controller | `PZTController/` |

Shared libraries (UART drivers, CGraph hardware interfaces, etc.) live in `include/`. Host-side command-line tools and hardware emulators are in `BinaryCmdrs/` and `HardwareEmulators/`, respectively.

Doxygen-generated documentation is published at [https://uasal.github.io/firmware/](https://uasal.github.io/firmware/).

## Useful Resources

- [Git workflow guide](https://uasal.github.io/uasal_development_guide/git/git-flow-guide.html)
- [Pull request checklist](https://uasal.github.io/uasal_development_guide/git/pull_request_checklist.html)
- [C++ coding standards](https://uasal.github.io/uasal_development_guide/C%2B%2B/general.html), formatting and style
- [Doxygen documentation guidelines](https://uasal.github.io/uasal_development_guide/C%2B%2B/documentation.html)
- [Testing guidelines](https://uasal.github.io/uasal_development_guide/C%2B%2B/testing.html) and the Catch2 framework

## VHDL Standards

- Target `VHDL2008` (GHDL is configured for `--std=08`)
- Place new components under `include/fpga/` and testbenches under `include/fpga/testbenches/`
- Follow the naming convention of existing files (e.g. `UartRx.vhd` / `UartRx_tb.vhd`)
- Every new component requires a `_tb.vhd` testbench that reports `PASS` or `FAIL` on stdout
- Reuse existing components from `include/fpga/` before writing new implementations

## Contributing TLDR

- Create your branch from `master`, with a short name following the template `username/branch-description`.
- Commit small units of work at a time without leaving the codebase in a breaking state.
- Write clear commit log messages. One-line messages are fine for small changes; bigger changes should describe what changed and its impact.
- Link related issues in your commits and PR description (e.g. `Fixes #123`, `Related to #456`).
- Before opening a PR:
  - Run `cd include/fpga/testbenches && make all` if you modified any VHDL in `include/fpga/`.
  - Run any C++ tests associated with any modified C++ files.
  - Confirm no new compiler warnings are introduced.
  - Add or update Doxygen headers and comments for any new or modified files.
- Open a new Pull Request using the template provided, fill in the requested information and go through the checklists.
