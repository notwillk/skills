# Skills To-Do List

Future skills to implement, based on patterns identified during devcontainer feature development.

## Planned Skills (Need More Definition)

| Skill Name | Description | Priority | Dependencies |
|------------|-------------|----------|--------------|
| `create-github-action-generic` | Framework for creating arbitrary GitHub Actions workflows beyond devcontainer publishing. Support for matrix builds, multi-job pipelines, composite actions, reusable workflows. **Needs:** full workflow pattern library, job orchestration templates, action marketplace integration. | Medium | Extends create-github-action |
| `detect-repo-changes-advanced` | Enhanced change detection with full git ancestry, commit message parsing, semantic version detection from conventional commits, cross-branch comparison. **Needs:** full git graph traversal, commit message analysis, change categorization ML/regex. | Low | Extends detect-repo-changes |

## Planned Skills (Defined)

| Skill Name | Description | Priority | Dependencies |
|------------|-------------|----------|--------------|
| `evaluate-devcontainer-feature` | Systematically test devcontainer features against assertions (similar to evaluate-skill-quality but for feature outputs). Run feature in container, verify binary works, check version matches, validate options passed correctly. | Medium | Uses devcontainer CLI test patterns |
| `migrate-devcontainer-feature` | Migrate features between repositories or rename features with proper `legacyIds` handling. Update all references, bump versions, manage deprecation notices. | Low | Cross-reference with manage-devcontainer-feature |
| `optimize-install-script` | Analyze install.sh for best practices (architecture detection, error handling, cleanup, verification). Suggest improvements, detect common anti-patterns, auto-fix issues. | Medium | Uses shellcheck patterns |
| `batch-feature-update` | Update multiple features in a repository simultaneously. Detect all changed features, determine version bumps for each, batch commit with consistent messages. | Medium | Uses detect-repo-changes, manage-devcontainer-feature |
| `create-devcontainer-template` | Create devcontainer.json templates for common project types (similar to create-devcontainer-config but with full template library). Include complete working setups for Node/Express, Python/Django, Rust/Axum, etc. | Low | Cross-reference with existing devcontainer skills |
| `validate-devcontainer-artifact` | Validate devcontainer-feature.json against schema, check install.sh syntax, verify test.sh structure, ensure all required files present. Pre-commit validation. | High | Uses JSON schema validation |
| `generate-feature-documentation` | Auto-generate README.md from devcontainer-feature.json and install.sh analysis. Create usage examples, option documentation, architecture support matrix. | Low | Uses templates |

## Potential Enhancements to Existing Skills

| Enhancement | Target Skill | Description |
|-------------|--------------|-------------|
| Integration tests | manage-devcontainer-feature | Test full chains: create → find → update, debug → update |
| Edge case tests | manage-devcontainer-feature | Malformed JSON, multi-feature requests, exotic dependencies |
| Git history tracking | detect-repo-changes | Track changes across multiple commits with ancestry detection |
| Workflow templates | create-github-action | More templates: release-please, semantic-release, multi-platform builds |
| Feature dependency graph | manage-devcontainer-feature | Visualize or analyze dependsOn/installsAfter relationships |

## Notes

- All skills should follow the established pattern: SKILL.md + references/ + optional evals/
- Keep under 500 lines
- Include gotchas section for activation-critical warnings
- Provide concrete examples
- Cross-reference related skills
- Use self-contained references (no external dependencies)

## "Needs More Info" Skills

These skills were created as **placeholders/frameworks** with the understanding they'd be iterated on:

1. **create-github-action-generic** - Currently only has basic generic workflow support. Needs full pattern library for:
   - Matrix strategy workflows
   - Multi-job dependency chains  
   - Composite actions
   - Reusable workflow templates
   - Integration with GitHub marketplace actions

2. **detect-repo-changes-advanced** - Currently has basic cascade. Needs:
   - Full git commit ancestry traversal
   - Conventional commit parsing (feat:, fix:, BREAKING CHANGE:)
   - Semantic version detection from commit messages
   - Cross-branch diff (not just current branch)
   - File change categorization (source vs test vs docs)

These will be fleshed out when specific use cases emerge.

## Completed Skills (Reference)

| Skill | Status | Date | Notes |
|-------|--------|------|-------|
| detect-repo-changes | ✅ Complete | 2026-04-26 | Basic cascade implementation |
| manage-devcontainer-feature | ✅ Complete | 2026-04-26 | Full feature with 3 templates + examples |
| create-github-action | ✅ Complete | 2026-04-26 | Devcontainer publish workflow + generic basic |

## Completed Skills - Future Iterations

| Skill | Current | Future Enhancement |
|-------|---------|-------------------|
| detect-repo-changes | Git cascade + agent knowledge | Full git ancestry, conventional commits |
| create-github-action | Devcontainer publish + basic generic | Arbitrary workflow patterns, marketplace |

---

*Last updated: 2026-04-26*
