---
name: manage-tolaria-vault
description: >
  Create, organize, review, or refactor Tolaria Markdown vault content using the
  Tolaria knowledge method. Use when working with notes, inbox cleanup,
  canonical frontmatter schema, note types, projects, responsibilities,
  procedures, topics, people, events, workspaces, semantic fields, underscore
  system properties, typed relations, parser/UI filtering expectations, capture
  to organize workflows, or vault conventions. Do not use for general product
  strategy, positioning, or Tolaria app implementation work unless the task
  directly concerns vault content, frontmatter conventions, or schema behavior.
---

# Manage Tolaria Vault

Use this skill to organize knowledge inside a Tolaria vault. Preserve the core
discipline: capture fast, organize deliberately, and connect notes to useful
work.

## Core Ontology

Classify work using two axes:

```text
                 One-time                  Recurring
Multi-session    Project                   Responsibility
Single-session   Task (external manager)    Procedure
```

Use these supporting types:

- Note: atomic unit of knowledge; should connect to at least one useful context.
- Topic: area of interest or repository of knowledge with no performance
  expectation.
- Event: dated thing that happened.
- People: contacts and history.
- Evergreen note: refined, reusable idea used especially for writing and
  content creation.

Tasks usually live in a task manager, not as first-class Tolaria containers.

## Purpose Rule

Notes exist to get things done. During organization, ask: "What is this useful
for?" If the answer is unclear, deleting the note is acceptable. Deleting more
than half of captured notes during review can be healthy.

## Capture To Organize

Capture:

- Keep it fast and available everywhere.
- Accept unconnected notes, rough thoughts, saved articles, highlights, voice
  memos, and raw imports.
- Do not force classification, relations, or cleanup during capture.

Organize:

- Review periodically, usually weekly.
- Delete weak captures.
- Convert surviving captures into useful notes.
- Connect each note to at least one Project, Responsibility, Procedure, Topic,
  Event, or Person.
- Create evergreen notes when a raw capture contains a timeless, reusable idea.

The Inbox is a derived state: notes with no outgoing relationships. It is not a
folder. Connecting a note removes it from the Inbox.

## Relation Conventions

Relations are typed and bidirectional product objects, not just casual wiki
links. Use relation fields to make structure explicit:

```yaml
Workspace: [[workspace/refactoring]]
belongs_to: [[projects/tolaria-launch]]
related_to: [[topics/ai-native-pkm]]
has:
  - [[procedures/weekly-review]]
People: [[people/luca-rossi]]
Event: [[events/2026-03-01-product-call]]
```

Prefer specific relation names from the vault's conventions when they exist.
If editing an existing vault, inspect nearby notes before inventing fields.

## Frontmatter Schema

Tolaria uses convention-based frontmatter fields with UI meaning. For new
notes, prefer these canonical field names:

| Field | Meaning | UI behavior |
| --- | --- | --- |
| `title:` | Legacy display-title fallback | Used only when a note has no H1; do not write automatically for new notes |
| `type:` | Entity type, such as Project, Person, or Quarter | Type chip in note list and sidebar grouping |
| `status:` | Lifecycle stage, such as active, done, or blocked | Colored chip in note list and editor header |
| `icon:` | Per-note icon: emoji, Phosphor name, or HTTP/HTTPS image URL | Rendered on note title surfaces; editable from Properties |
| `url:` | External link | Clickable link chip in editor header |
| `date:` | Single date | Formatted date badge |
| `start_date:` + `end_date:` | Duration or timespan | Date range badge |
| `goal:` + `result:` | Progress | Progress indicator in editor header |
| `Workspace:` | Vault context filter | Global workspace filter |
| `belongs_to:` | Parent relationship | Humanized to Belongs to in the UI |
| `related_to:` | Lateral relationship | Humanized to Related to in the UI |
| `has:` | Contained relationship | Humanized to Has in the UI |

For existing vaults, inspect nearby notes before normalizing. Do not create
parallel fields like `workspace`, `Workspace`, and `workspaces` unless
migrating intentionally. If legacy notes use humanized fields such as
`Belongs to`, prefer canonical `belongs_to` for new notes and only migrate old
fields when the user asks or a migration is already in scope.

Value tips:

- Prefer an H1 for display title. Use `title:` only as a legacy fallback when no
  H1 exists; do not add it to new notes automatically.
- Use stable type names such as `Project`, `Responsibility`, `Procedure`,
  `Topic`, `Person`, and `Event` unless the vault has established variants.
- Use ISO-like dates (`YYYY-MM-DD`) for `date`, `start_date`, and `end_date`
  unless nearby notes show a different convention.
- Use `icon:` for a per-note visible icon; use `_icon:` for a Type note or
  internal type-level preference.
- Use `url:` for a single external link that should appear as an editor-header
  chip. Keep supporting links in the Markdown body when there are many.
- Use `goal:` and `result:` together when the note needs progress display.

## System Properties

Any frontmatter field whose name starts with `_` is a system property:

- It is not shown in the Properties panel for notes or Type notes.
- It is not exposed as a user-visible property in search, filters, or normal UI.
- It remains editable directly in the raw editor for power users.
- It stores Tolaria configuration, behavior, and UI preferences on disk as plain
  text.

Examples:

```yaml
_pinned_properties:
  - key: status
    icon: circle-dot
_icon: shapes
_color: blue
_order: 10
_sidebar_label: Projects
_width: wide
```

Use the `_field_name` convention for future system-level frontmatter, especially
in Type notes. Do not store these preferences only in localStorage or hidden app
state.

## Parser And UI Filtering Notes

When work touches Tolaria frontmatter behavior, preserve these implementation
expectations even from vault-focused tasks:

- Rust `vault/mod.rs` and TS `utils/frontmatter.ts` must filter out `_*` fields
  before passing properties to the Properties panel, search facets, filters, or
  other normal user-visible UI surfaces.
- Preserve `_*` fields during read/write cycles.
- Preserve unknown non-system frontmatter fields unless a migration explicitly
  changes them.
- Humanize canonical relation keys in the UI: `belongs_to` becomes Belongs to,
  `related_to` becomes Related to, and `has` becomes Has.
- Avoid destructive rewrites of existing frontmatter. Keep diffs stable and
  minimal so Git history remains readable.

## Frontmatter Editing Workflow

1. Inspect nearby notes and Type notes before editing schema-sensitive fields.
2. Keep existing unknown fields unless the user asked for a migration.
3. Prefer canonical fields for new work: `Workspace`, `belongs_to`,
   `related_to`, and `has`.
4. Move internal UI preferences into `_` system fields, not visible fields.
5. Preserve H1 headings as the primary title source.
6. If migrating legacy fields, report the old field, the new canonical field,
   and any notes changed.

## Suggested Note Shapes

Project:

```markdown
---
type: Project
status: active
Workspace: [[workspace/refactoring]]
start_date: 2026-03-01
end_date:
---

# Project Name

## Outcome

## Current State

## Related Notes
```

Responsibility:

```markdown
---
type: Responsibility
status: active
Workspace: [[workspace/refactoring]]
goal:
result:
---

# Responsibility Name

## Standard

## Review Cadence

## Procedures
```

Procedure:

```markdown
---
type: Procedure
status: active
belongs_to: [[responsibilities/publishing]]
---

# Procedure Name

## Checklist

- [ ] Step
```

Type note with system preferences:

```markdown
---
type: Type
_icon: shapes
_color: blue
_order: 10
_sidebar_label: Projects
_pinned_properties:
  - key: status
    icon: circle-dot
  - key: Workspace
    icon: buildings
---

# Project
```

## Organization Workflow

1. Inspect existing vault conventions, folders, and frontmatter.
2. Identify unorganized notes by absence of outgoing relations.
3. For each note, decide: delete, leave captured for later, connect, split, or
   refine into evergreen form.
4. Add the smallest set of typed relations needed to make the note useful.
5. Preserve Markdown readability outside Tolaria.
6. Summarize changed notes and any new conventions introduced.

## Guardrails

- Do not turn every note into an evergreen note; only stable reusable ideas need
  that treatment.
- Do not make the Inbox a manual folder.
- Do not over-structure capture notes before the user has reviewed usefulness.
- Do not store important vault behavior only in app-local state.
- Do not expose `_` system properties as normal user-facing properties.
- Do not use humanized relation labels as new canonical frontmatter keys.
- Do not break plain Markdown portability.

## Response Checklist

When finishing vault work, report:

- Notes reviewed, created, deleted, or connected.
- Containers or contexts used: Project, Responsibility, Procedure, Topic, Event,
  or Person.
- Relation fields added or normalized.
- Remaining Inbox or review items.
- Any assumptions about vault conventions.
