# UX Interaction Patterns by Domain

## Forms

### The Step-by-Step Pattern (Wizard / Stepper)
**When:** More than 5-7 fields, or fields that span distinct logical stages (personal info →
shipping → payment → review).
**Structure:**
- Each step has a single clear purpose
- Progress indicator always visible (step 2 of 4)
- Never disable the Back button
- Validate on step completion, not on final submit
- Allow jump-to (clicking step 3 from step 5 to edit) for review flows

**Rule of thumb:** If a form has more than one "section heading", it should be a stepper.

---

### Conditional / Smart Fields
**When:** Fields only become relevant based on previous answers.
**Approach:**
- Hide irrelevant fields entirely (not just disable them)
- Animate them into existence smoothly
- Re-validate when conditions change
**Example:** "Do you have a VAT number?" → If Yes, show VAT field. If No, hide it entirely.

---

### Inline Validation
**When:** Always, for any input with format requirements.
**Rules:**
- Validate on blur (when user leaves field), NOT on every keystroke (except password strength)
- Show success state (green checkmark) as well as error state
- Error message must be adjacent to the field, not at the top of the form
- Never clear a valid field's success state without reason

---

### Smart Defaults
**When:** You have data to pre-fill, or can infer a likely answer.
**Examples:**
- Country field defaults to user's locale
- "Same as billing address" checkbox for shipping
- Pre-fill returning user's saved payment method
- Default quantity to 1
**Rule:** A smart default that's wrong is better than no default — it's faster to change than to fill.

---

### The Summary Pattern
**When:** Any multi-step form or checkout.
**Structure:** Final step shows a read-only summary of all inputs with an "Edit" affordance per section.
**Do:** Make the summary skimmable (key-value pairs, not re-rendered form fields).
**Don't:** Make users scroll back through all steps to review.

---

### Progressive Form Disclosure
**When:** Form has fields for advanced/power users that most users don't need.
**Approach:**
- Show core fields by default
- "Show advanced options" toggle reveals additional fields
- Remember the user's preference (if they opened advanced options, keep them open)

---

## Navigation

### Hub and Spoke
**When:** Mobile apps, wizard flows, onboarding.
**Structure:** Central "home" or "dashboard" links to task-specific screens. Users always
return to hub after completing a task. No deep nesting.

---

### Breadcrumb Trail
**When:** Deep hierarchical content (e-commerce categories, documentation, settings).
**Rules:**
- Always show full path from root
- Last item (current page) is not a link
- On mobile: show only parent + current

---

### Tab Navigation
**When:** Peer-level content that users switch between frequently (Dashboard / Analytics / Settings).
**Rules:**
- Maximum 5-6 tabs before switching to a sidebar or dropdown
- Active tab must be clearly distinct
- Don't use tabs for sequential steps (use a stepper)
- Don't hide critical actions behind tabs users won't discover

---

### Sticky Navigation
**When:** Long-scrolling pages where primary actions must always be accessible.
**Use:** Top nav (always), bottom bar on mobile, sticky sidebar for secondary navigation.
**Don't:** Sticky headers that eat more than 10-15% of viewport height.

---

### Contextual Action Menus
**When:** Actions on list items or table rows.
**Pattern:** Hover reveals action row (edit, delete, share). On mobile, long-press or swipe.
**Don't:** Show all row actions inline — use ellipsis/kebab menu for secondary actions.

---

## Onboarding

### The Empty State as Teacher
**When:** User first encounters a feature with no data.
**Structure:**
- Illustration or icon (humanizes the space)
- One-line explanation of what this space is for
- Single primary CTA to create the first item
**Don't:** Show an empty table with no guidance.

---

### Progressive Onboarding
**When:** Feature-rich product with many capabilities.
**Approach:**
- Start with the 20% of features that deliver 80% of value
- Reveal advanced features contextually as user progresses
- Don't front-load everything in a tour
- Use tooltips/spotlights triggered by user actions, not on login

---

### The Quick Win Pattern
**When:** Onboarding a new user.
**Structure:** Design the first experience to deliver a "win" within 5 minutes.
The win should be a demonstration of core value, not setup completion.
**Example:** Notion shows you a sample page before you create one.

---

### The Checklist Pattern
**When:** Setup requires multiple independent steps (not sequential).
**Structure:**
- Show all steps upfront (Zeigarnik effect creates pull to complete)
- Allow any order
- Checkmark + strikethrough when complete
- Optional: progress bar or percentage
**Example:** GitHub repo setup checklist, profile completion indicators.

---

## Dashboards

### The Inverted Pyramid Dashboard
**Structure:**
1. **Top:** KPIs / summary numbers (the answer)
2. **Middle:** Charts / breakdowns (the explanation)
3. **Bottom:** Tables / raw data / logs (the evidence)
Users scan top-down; most never reach the bottom. Design accordingly.

---

### Contextual Filters
**When:** Dashboard with multiple data dimensions.
**Pattern:** Filter controls at the top of the section they affect, not in a separate panel.
**Don't:** Require users to interact with a filter sidebar and then look at a separate chart area.

---

### The Sparkline Pattern
**When:** You need to show trend alongside a KPI without using a full chart.
**Use:** Small inline sparkline next to the number. No axes needed — just trend direction.

---

## E-Commerce

### The Checkout Funnel
**Optimal structure (fewest fields, highest conversion):**
1. Cart review (edit quantities, remove items)
2. Email / account (guest option prominently offered)
3. Shipping address (auto-complete via Google Places or similar)
4. Shipping method (pre-selected to cheapest or most popular)
5. Payment (Stripe/PayPal; save card option)
6. Review & confirm (summary + single CTA)
7. Confirmation (order number, next steps, upsell if appropriate)

**Rules:**
- Guest checkout must be at least as prominent as account creation
- Don't ask for phone number unless you'll actually call them
- Show order summary persistently on the right (desktop)
- Auto-detect card type from number
- Never clear payment fields on validation error

---

### The Product Page Pattern
**Structure:**
- Images left / info right (desktop); images top / info below (mobile)
- Price must be visible without scrolling
- Primary CTA (Add to Cart) always in viewport
- Variant selectors (size, color) before the CTA, never after
- Inventory signals near CTA ("Only 3 left", "In stock", "Ships tomorrow")

---

### The Cart Pattern
**Options:**
- **Slide-out drawer:** Best for high-frequency add-to-cart flows (fashion, grocery)
- **Dedicated cart page:** Best for considered purchases (electronics, furniture)
- **Mini cart dropdown:** Avoid — too small for real interaction, too large to be subtle

---

## Search & Filtering

### Search-First vs Filter-First
**Search-first:** User knows what they want (e-commerce, documentation, directory)
**Filter-first:** User is browsing and narrowing (real estate, job listings, travel)
Choose based on user's mental model, not what's easier to build.

---

### Faceted Filtering
**When:** Large, structured dataset with multiple filter dimensions.
**Patterns:**
- Show item count per filter option ("Nike (143)")
- Disable (gray out) filter options that would return 0 results
- Allow multi-select within a category
- Clear all filters as single action
- Applied filters shown as removable chips/tags at top of results

---

### The Autocomplete Contract
**Rules:**
- Results must appear in under 300ms or show a spinner
- Keyboard navigation must work (arrow keys, enter, escape)
- Highlight the matching substring in results
- "No results" state must be helpful ("No results for 'bleu'. Try 'blue'?")
- Mobile: submit button in keyboard, not just Enter key

---

## Modals & Overlays

### When to Use a Modal
**Use:**
- Confirmation of irreversible action (delete, cancel subscription)
- Quick single-action forms (rename, add tag, invite user)
- Media lightbox
**Don't use:**
- Multi-step flows (user gets trapped)
- Content that needs deep linking
- Tasks that require reference to content behind the modal
- On mobile for complex tasks

---

### The Bottom Sheet (Mobile)
**Use instead of modal on mobile for:**
- Action sheets (share, options menu)
- Quick filters
- Map detail panels
**Don't use for:** Full-page workflows. Use a full-screen modal instead.

---

## Feedback & Status

### The Optimistic UI Pattern
**When:** An action is very likely to succeed (liking, following, toggling).
**Approach:** Update the UI immediately; roll back if the request fails.
**Don't:** Make users wait for server confirmation before showing feedback.

---

### Toast vs Inline vs Banner
| Type | When to use |
|---|---|
| **Toast** (floating, auto-dismiss) | Non-critical success/info ("Saved", "Copied to clipboard") |
| **Inline message** | Contextual feedback tied to a specific element (form field error, table row action) |
| **Persistent banner** | Critical system state requiring user action (account suspended, required update) |
| **Alert dialog** | Requires acknowledgment before proceeding (data loss warning) |

**Rule:** Toasts must not contain critical information. If the user must act on it, use a banner or dialog.

---

### Empty States
Every list, table, chart, and inbox needs an empty state design. It should:
1. Explain the space with one clear sentence
2. Offer a specific CTA to populate it
3. Use a simple illustration or icon (optional but improves feel)

Never show a heading + nothing. Never show "No data available."
