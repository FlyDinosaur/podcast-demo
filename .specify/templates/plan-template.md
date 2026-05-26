# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]

**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

[Extract from feature spec: primary requirement + technical approach from research]

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: [e.g., Swift 5.9+ for iOS 17 or NEEDS CLARIFICATION]

**Primary Dependencies**: [e.g., SwiftUI, Observation, XCTest or NEEDS CLARIFICATION]

**Storage**: [if applicable, e.g., local files, in-memory state, CoreData, or N/A]

**Testing**: [e.g., XCTest, Swift Testing or NEEDS CLARIFICATION]

**Target Platform**: [e.g., iOS 17+ or NEEDS CLARIFICATION]

**Project Type**: [e.g., SwiftUI mobile app frontend or NEEDS CLARIFICATION]

**Performance Goals**: [domain-specific, e.g., 1000 req/s, 10k lines/sec, 60 fps or NEEDS CLARIFICATION]

**Constraints**: [domain-specific, e.g., frontend-only, MVVC-required, iOS 17+, or NEEDS CLARIFICATION]

**Scale/Scope**: [domain-specific, e.g., 10k users, 1M LOC, 50 screens or NEEDS CLARIFICATION]

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Confirm the feature is implemented with MVVC architecture and that Model,
  View, ViewModel, and Controller responsibilities are explicitly defined.
- Confirm the planned source tree places code into dedicated `Model/`, `View/`,
  `ViewModel/`, and `Controller/` groups with no mixed-responsibility files.
- Confirm scope is frontend only and does not include backend implementation.
- Confirm all new variable names will follow camelCase and end with a type
  suffix.
- Confirm every function will include a documentation block listing function
  name, accepted parameters, function purpose, and return value.
- Confirm all UI implementation uses SwiftUI and remains compatible with iOS 17+.

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
# [REMOVE IF UNUSED] Option 1: Single project (DEFAULT)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [REMOVE IF UNUSED] Option 2: Web application (when "frontend" + "backend" detected)
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [REMOVE IF UNUSED] Option 3: iOS SwiftUI frontend (MVVC required)
Poadcast/
├── Model/
├── View/
├── ViewModel/
└── Controller/

PoadcastTests/
└── [feature or layer-specific tests]
```

**Structure Decision**: [Document the selected structure and confirm how Model,
View, ViewModel, and Controller groups are mapped to real directories]

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
