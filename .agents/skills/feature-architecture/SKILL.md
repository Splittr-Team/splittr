---
name: feature-architecture
description: Guidelines on scaffolding a new feature under lib/features/ in splittr
---

# Feature Scaffolding

Ensure any newly created feature adheres to clean architecture principles and utilizes the core `sky_*` packages correctly.

## Checklist
- [ ] Read the feature architecture scaffolding rules in docs/ai_rules/feature_architecture.md.
- [ ] Read package-specific rules for sky_bloc, sky_design_system, sky_architecture, and sky_router.
- [ ] Scaffold folder structure under lib/features/<name> using data, domain, and presentation/ui.
- [ ] Implement entities, abstract repository, usecases, models, mappers, repositories, blocs, and UI.
- [ ] Run code generation via build_runner.
