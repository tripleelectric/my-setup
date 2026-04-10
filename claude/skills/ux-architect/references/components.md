# Component Selection Guide

## Core Principle
Every component choice is a UX decision. The wrong component creates friction even if it
"works." Always ask: **what is the user's mental model for this input?**

---

## Input / Selection Components

### Text Input
**Use when:** The answer is free-form and cannot be enumerated.
**Don't use when:** The possible values are bounded and known — use a select, radio, or segmented control instead.
**Variants:**
- Single line: short text (name, email, city)
- Multi-line (textarea): long text (description, notes, message)
- Auto-growing textarea: better UX than fixed-height for variable-length content

---

### Radio Buttons
**Use when:**
- 2-5 mutually exclusive options
- User benefits from seeing all options simultaneously (comparison)
- Options are meaningful enough to label clearly
**Don't use:** More than 5-6 options (use select instead). When options are boolean (use toggle).
**Layout:** Vertical list for 3+ options. Horizontal for 2 options if labels are short.

---

### Select / Dropdown
**Use when:**
- 5+ mutually exclusive options
- Options are well-known and don't need to be compared simultaneously
- Space is constrained
**Don't use:** For fewer than 5 options (radio buttons give better affordance).
**Prefer native select on mobile** — it triggers the native picker, which is faster for users.

---

### Segmented Control
**Use when:**
- 2-4 options that are mode/view selections (not data input)
- Switching between options changes the view below (List / Grid / Map)
**Don't use for:** Data input. More than 4 options (labels become too small).

---

### Toggle / Switch
**Use when:** A binary on/off state with immediate effect.
**Don't use:** When the user needs to confirm before the change takes effect (use checkbox + save button).
**Label rule:** The label describes the ON state, not the action. "Email notifications" not "Enable email notifications."

---

### Checkbox
**Use when:**
- Multiple independent items can be selected from a list
- A single binary choice that requires explicit acknowledgment (terms of service)
**Don't use:** For mutually exclusive options (use radio). For on/off settings with immediate effect (use toggle).

---

### Combobox (Searchable Select)
**Use when:** Select with 10+ options where user may know what they're looking for.
**Examples:** Country selector, product category, user lookup.
**Must have:** Keyboard navigation, clear on-selection display, loading state if async.

---

### Tag Input / Multi-select
**Use when:** User needs to select or create multiple values (skills, tags, assignees).
**Pattern:** Input field with autocomplete → selected items render as removable chips/tags above or inline.

---

### Number Stepper (+/- buttons)
**Use when:** Numeric input with a constrained range and likely small adjustments (quantity 1-10, number of guests).
**Don't use:** For large ranges (use a slider or text input instead).
**Mobile rule:** Always use a stepper for quantities — number keyboards on mobile are slow for small adjustments.

---

### Range Slider
**Use when:** User is selecting within a continuous range and precision is less important than speed (price range, age filter, volume).
**Dual handle slider:** For min/max selection (price range).
**Don't use:** When user needs to enter an exact value (use number input with validation instead).

---

### Date Picker
**Use when:** Date selection with calendar context matters (booking, scheduling, filtering by date range).
**Don't use:** For birth year/month input — a select pair (month + year) is faster.
**Mobile:** Native date inputs are usually better than custom pickers.
**Date range:** Two calendars side-by-side (desktop) or sequential selection (mobile).

---

### File Upload
**Variants:**
- **Button trigger:** Simple, for single file, when file type is clear
- **Drag-and-drop zone:** When multiple files or when users are likely to have files ready in Finder/Explorer
- **Camera capture (mobile):** For documents, photos, receipts — use `accept="image/*" capture`
**Always show:** File name after selection, size, option to remove and re-select.

---

## Display Components

### Table
**Use when:** Users need to compare values across multiple items on the same attribute.
**Rules:**
- Right-align numbers (enables column scanning)
- Left-align text
- Numeric columns should have consistent decimal places
- Row actions: show on hover (desktop), always visible on mobile
- Sort indicator on active column, not all columns
- Sticky header on scroll for long tables

**Don't use for:** Displaying a single record's details (use a detail view/card instead).

---

### Card
**Use when:** Each item is an independent entity with multiple attributes worth showing (products, articles, users, projects).
**Rules:**
- The entire card should be clickable if it navigates somewhere
- Primary action should be discoverable without hovering
- Consistent card height in a grid (use min-height, not fixed height)

---

### Accordion / Disclosure
**Use when:** Content sections that most users won't need, but some will (FAQ, advanced settings, contextual help).
**Don't use for:** Primary content that most users need — progressive disclosure shouldn't hide things people consistently need.

---

### Tabs (within a page)
**Use when:** Peer-level sections that users switch between, where showing all simultaneously would be too long.
**Don't use:** More than 6 tabs (use a sidebar nav). For sequential steps (use a stepper).

---

## Feedback Components

### Loading States
| Duration | Pattern |
|---|---|
| < 300ms | No indicator needed |
| 300ms – 1s | Spinner (inline, near the element) |
| 1s – 5s | Skeleton screen (mimics content layout) |
| > 5s | Progress bar with estimated time |

**Rule:** Always show something within 100ms of user action. Silence is the worst UX.

---

### Inline Validation States
Every validated input needs 3 states beyond default:
1. **Error** — Red border, error icon, message below field
2. **Success** — Green border or checkmark (for required fields)
3. **Warning** — For soft issues (e.g., "This username is available but commonly misspelled")

---

### Tooltips vs Popovers vs Inline Help
| Type | When to use |
|---|---|
| **Tooltip** (hover, auto-dismiss) | Icon labels, abbreviation expansion, brief clarification |
| **Popover** (click, persists) | More complex explanation, links, interactive content |
| **Inline help text** (always visible) | Required explanation for a field (shows under label) |

**Rule:** If the user needs to read the help text to complete the field correctly, use inline help text — not a tooltip they might miss.

---

## Navigation Components

### Bottom Navigation Bar (Mobile)
**Use when:** 3-5 primary destinations in a mobile app.
**Rules:**
- Always show labels (icon-only fails recognition)
- Active state must be clear
- Don't hide behind scroll (always sticky)
- More than 5 items → use bottom nav + "More" overflow

---

### Sidebar Navigation (Desktop)
**Use when:** Complex app with many sections (dashboard, admin, SaaS product).
**Variants:**
- **Persistent:** Always visible (best for power users)
- **Collapsible:** Icon-only when collapsed, expands on hover or click
- **Overlay:** Slides over content — only for mobile

---

### Breadcrumbs
**Required when:** Content is 3+ levels deep and users may navigate non-linearly.
**Format:** Root > Category > Subcategory > **Current Page**
**Mobile:** Collapse to parent only: `← Category`

---

### Command Palette (⌘K)
**Use when:** Power users with complex apps who need fast navigation across many features.
**Trigger:** ⌘K (Mac) / Ctrl+K (Win) — this is now a recognized standard.
**Content:** Recent pages, all nav items, actions (create new, search, settings).

---

## When to Modal, When to Inline, When to Navigate

| Scenario | Pattern |
|---|---|
| Create new item (simple, < 5 fields) | Modal |
| Create new item (complex, multi-step) | Dedicated page |
| Edit an item inline | Inline edit (click-to-edit) |
| Edit an item with many fields | Slide-out panel or dedicated page |
| Confirm destructive action | Modal (single CTA) |
| Show item detail | Slide-out panel (list context) or dedicated page |
| Filter/sort a list | Inline controls or collapsible panel (not modal) |
| Settings and preferences | Dedicated page |
