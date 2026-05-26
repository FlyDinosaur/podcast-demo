---

description: "Task list template for feature implementation"
---

# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: The examples below include test tasks. Tests are OPTIONAL - only include them if explicitly requested in the feature specification.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Single project**: `src/`, `tests/` at repository root
- **Web app**: `backend/src/`, `frontend/src/`
- **Mobile SwiftUI app**: `Poadcast/Model/`, `Poadcast/View/`,
  `Poadcast/ViewModel/`, `Poadcast/Controller/`, `PoadcastTests/`
- Paths shown below assume single project - adjust based on plan.md structure

<!--
  ============================================================================
  IMPORTANT: The tasks below are SAMPLE TASKS for illustration purposes only.

  The /speckit-tasks command MUST replace these with actual tasks based on:
  - User stories from spec.md (with their priorities P1, P2, P3...)
  - Feature requirements from plan.md
  - Entities from data-model.md
  - Endpoints from contracts/

  Tasks MUST be organized by user story so each story can be:
  - Implemented independently
  - Tested independently
  - Delivered as an MVP increment

  DO NOT keep these sample tasks in the generated tasks.md file.
  ============================================================================
-->

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create project structure per implementation plan
- [ ] T002 Initialize [language] project with [framework] dependencies
- [ ] T003 [P] Configure linting and formatting tools
- [ ] T004 Create or verify `Model/`, `View/`, `ViewModel/`, and `Controller/`
      groups for the feature

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

Examples of foundational tasks (adjust based on your project):

- [ ] T005 Define MVVC responsibility boundaries for the feature
- [ ] T006 [P] Establish shared SwiftUI design and state conventions for iOS 17+
- [ ] T007 [P] Define naming rules for camelCase plus type suffix usage
- [ ] T008 Create base models/entities that all stories depend on
- [ ] T009 Setup shared error and state handling infrastructure
- [ ] T010 Add function documentation templates or review checklist support

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - [Title] (Priority: P1) 🎯 MVP

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 1 (OPTIONAL - only if tests requested) ⚠️

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [ ] T011 [P] [US1] ViewModel or interaction test in PoadcastTests/[name].swift
- [ ] T012 [P] [US1] SwiftUI flow or integration test in PoadcastTests/[name].swift

### Implementation for User Story 1

- [ ] T013 [P] [US1] Create or update models in Poadcast/Model/[feature]Model.swift
- [ ] T014 [P] [US1] Build views in Poadcast/View/[feature]View.swift
- [ ] T015 [P] [US1] Build view models in
      Poadcast/ViewModel/[feature]ViewModel.swift
- [ ] T016 [US1] Build coordinators/controllers in
      Poadcast/Controller/[feature]Controller.swift
- [ ] T017 [US1] Verify variable naming uses camelCase plus type suffixes
- [ ] T018 [US1] Add required function documentation blocks above each feature
      function

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - [Title] (Priority: P2)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 2 (OPTIONAL - only if tests requested) ⚠️

- [ ] T019 [P] [US2] ViewModel or interaction test in PoadcastTests/[name].swift
- [ ] T020 [P] [US2] SwiftUI flow or integration test in PoadcastTests/[name].swift

### Implementation for User Story 2

- [ ] T021 [P] [US2] Create or update models in Poadcast/Model/[feature]Model.swift
- [ ] T022 [P] [US2] Build views in Poadcast/View/[feature]View.swift
- [ ] T023 [P] [US2] Build view models in
      Poadcast/ViewModel/[feature]ViewModel.swift
- [ ] T024 [US2] Build coordinators/controllers in
      Poadcast/Controller/[feature]Controller.swift
- [ ] T025 [US2] Verify naming and function documentation compliance

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - [Title] (Priority: P3)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 3 (OPTIONAL - only if tests requested) ⚠️

- [ ] T026 [P] [US3] ViewModel or interaction test in PoadcastTests/[name].swift
- [ ] T027 [P] [US3] SwiftUI flow or integration test in PoadcastTests/[name].swift

### Implementation for User Story 3

- [ ] T028 [P] [US3] Create or update models in Poadcast/Model/[feature]Model.swift
- [ ] T029 [P] [US3] Build views in Poadcast/View/[feature]View.swift
- [ ] T030 [P] [US3] Build view models in
      Poadcast/ViewModel/[feature]ViewModel.swift
- [ ] T031 [US3] Build coordinators/controllers in
      Poadcast/Controller/[feature]Controller.swift
- [ ] T032 [US3] Verify naming and function documentation compliance

**Checkpoint**: All user stories should now be independently functional

---

[Add more user story phases as needed, following the same pattern]

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] TXXX [P] Documentation updates in docs/
- [ ] TXXX Code cleanup and refactoring
- [ ] TXXX Performance optimization across all stories
- [ ] TXXX [P] Additional unit tests (if requested) in PoadcastTests/
- [ ] TXXX Architecture audit for MVVC boundary violations
- [ ] TXXX Run quickstart.md validation

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - May integrate with US1 but should be independently testable
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - May integrate with US1/US2 but should be independently testable

### Within Each User Story

- Tests (if included) MUST be written and FAIL before implementation
- Models before ViewModels
- ViewModels before Views when dependencies exist
- Controllers only after the participating layers are defined
- Every implementation task includes naming and function documentation checks
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- All tests for a user story marked [P] can run in parallel
- Models within a story marked [P] can run in parallel
- Different user stories can be worked on in parallel by different team members

---

## Parallel Example: User Story 1

```bash
# Launch all tests for User Story 1 together (if tests requested):
Task: "ViewModel or interaction test in PoadcastTests/[name].swift"
Task: "SwiftUI flow or integration test in PoadcastTests/[name].swift"

# Launch all models for User Story 1 together:
Task: "Create or update models in Poadcast/Model/[feature]Model.swift"
Task: "Build views in Poadcast/View/[feature]View.swift"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1
   - Developer B: User Story 2
   - Developer C: User Story 3
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Verify tests fail before implementing
- Enforce MVVC layering with explicit tasks for Model, View, ViewModel, and Controller
- Enforce camelCase plus type suffix naming and function documentation in every story
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
