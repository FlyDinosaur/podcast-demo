<!--
Sync Impact Report
- Version change: template -> 1.0.0
- Modified principles:
  - Template Principle 1 -> I. MVVC Architecture Mandate
  - Template Principle 2 -> II. Component Separation Is Mandatory
  - Template Principle 3 -> III. Group Boundaries, Frontend Scope, and Naming Rules
  - Template Principle 4 -> IV. SwiftUI and iOS 17 Baseline
  - Template Principle 5 -> V. Function Documentation Requirement
- Added sections:
  - Implementation Constraints
  - Delivery Workflow and Compliance
- Removed sections: None
- Templates requiring updates:
  - ✅ updated: .specify/templates/plan-template.md
  - ✅ updated: .specify/templates/spec-template.md
  - ✅ updated: .specify/templates/tasks-template.md
  - ⚠ pending: .specify/templates/commands/ (directory not present, no files to update)
- Follow-up TODOs: None
-->
# Poadcast Constitution

## Core Principles

### I. MVVC Architecture Mandate
All feature work MUST adopt MVVC architecture. Every deliverable MUST define
clear responsibilities for Model, View, ViewModel, and Controller. Business
state and data shaping belong in Model, presentation belongs in View, UI state
binding and transformation belong in ViewModel, and flow coordination belongs
in Controller. Mixing these responsibilities in one type is prohibited.

Rationale: the project requires a stable structure that remains maintainable as
features grow and makes reviews objective.

### II. Component Separation Is Mandatory
All code MUST be split into focused components with single responsibilities.
Views, reusable UI fragments, state handlers, and feature coordinators MUST be
implemented as separate units instead of large mixed files. Reuse through
composition is required; copy-paste expansion of UI logic is prohibited unless
documented as a temporary exception in the implementation plan.

Rationale: strict separation reduces coupling and keeps SwiftUI screens
reviewable, testable, and replaceable.

### III. Group Boundaries, Frontend Scope, and Naming Rules
Each feature MUST be organized into exactly four top-level groups or folders:
Model, View, ViewModel, and Controller. Code belonging to one layer MUST stay
inside its corresponding group. The project scope is frontend only; backend
implementation, server contracts, persistence services, and deployment logic are
out of scope unless a future constitution amendment explicitly adds them.

All identifiers for variables MUST use camelCase. Every variable name MUST end
with a type suffix that states the stored type or role, such as `titleString`,
`countInt`, `isEnabledBool`, `episodeArray`, or `playerViewModel`. Abbreviated
or implicit type endings are not allowed.

Rationale: explicit group boundaries and naming rules make architectural drift
easy to detect during review.

### IV. SwiftUI and iOS 17 Baseline
All UI implementation MUST use SwiftUI. UIKit-based screens, Storyboards, XIBs,
or mixed UI stacks are prohibited unless a constitution amendment creates a
documented exception. The minimum supported platform MUST be iOS 17. Any
dependency, API choice, or design decision that lowers compatibility below iOS
17 is non-compliant.

Rationale: a single framework and platform baseline prevents duplicate patterns
and avoids compatibility ambiguity.

### V. Function Documentation Requirement
Every feature function MUST have a documentation block immediately above it.
That block MUST state the function name, accepted parameters, function purpose,
and return value. Missing documentation is a compliance failure even when the
function body is short. Generated or helper functions are not exempt.

Rationale: required documentation makes reviews faster and preserves intent in a
strictly layered codebase.

## Implementation Constraints

- Feature plans MUST describe the concrete MVVC split before implementation.
- Source structure for iOS features MUST map directly to `Model/`, `View/`,
  `ViewModel/`, and `Controller/` groups.
- New work MUST preserve frontend-only scope and MUST NOT introduce backend
  tickets, API servers, or database tasks unless the feature spec explicitly
  states they are placeholders outside implementation.
- Variable and function naming reviews MUST be part of every compliance check.

## Delivery Workflow and Compliance

- `spec.md` documents MUST state that the feature targets SwiftUI on iOS 17+ and
  frontend-only scope.
- `plan.md` documents MUST include a Constitution Check that validates MVVC
  boundaries, four-group placement, naming suffix compliance, and function
  documentation coverage.
- `tasks.md` documents MUST generate tasks separately for Model, View,
  ViewModel, and Controller work when a feature spans multiple layers.
- Code review MUST reject changes that place logic in the wrong layer, omit
  required function documentation, or violate camelCase plus type-suffix naming.

## Governance

This constitution overrides conflicting local habits, templates, and ad hoc
design decisions. Amendments require updating this file, documenting the impact
on plan/spec/tasks templates, and recording a semantic version bump rationale.
Versioning follows semantic rules: MAJOR for incompatible governance changes,
MINOR for new principles or materially expanded obligations, and PATCH for
wording-only clarifications. Every implementation plan and review MUST include a
constitution compliance check before coding begins and before merge approval is
granted.

**Version**: 1.0.0 | **Ratified**: 2026-05-26 | **Last Amended**: 2026-05-26
