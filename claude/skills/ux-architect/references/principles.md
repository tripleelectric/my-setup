# UX Principles Reference

## Cognitive Load Principles

### Miller's Law
Users can hold **7 ± 2 items** in working memory at once. In practice, aim for 5 or fewer
choices/fields/options per screen. Chunking (grouping related items) lets you present more
without violating this — the brain processes chunks as single units.

**Application:** Never show more than 5-7 form fields simultaneously. Break long processes
into steps. Group navigation into categories.

---

### Hick's Law
Decision time increases logarithmically with the number of choices. Every additional option
adds cognitive cost, even if the user doesn't choose it.

**Application:** Reduce navigation items. Default to the most common selection. Use
progressive disclosure to hide advanced options. Prefer fewer, clearer CTAs over many options.

---

### Fitts's Law
The time to reach a target is a function of its size and distance. Small, far-away targets
are slow and error-prone.

**Application:** Primary CTAs should be large. Destructive actions (delete, cancel) should be
small and distant from the primary action. On mobile, tap targets must be ≥ 44×44pt. Don't
place "Save" and "Delete" side by side.

---

### Progressive Disclosure
Show only what the user needs for the current task. Reveal complexity on demand.

**Levels:**
1. **Beginner path:** Only essential fields/options visible by default
2. **Advanced path:** Revealed via "Advanced options", "Show more", or conditional logic
3. **Expert path:** Accessible via keyboard shortcuts, settings, or developer mode

**Application:** Checkout forms, settings pages, filter panels, long registration flows.

---

### Cognitive Tunneling
Users in task-focus mode ignore peripheral information. Important warnings placed outside
the task flow are missed.

**Application:** Inline validation (not end-of-form). Contextual help next to the relevant
field. Don't rely on top-of-page banners for critical form errors.

---

## Behavioral Principles

### Peak-End Rule (Kahneman)
Users judge an experience primarily by its **peak** (most intense moment) and its **end**,
not the average. A painful middle step is forgiven if the end is satisfying.

**Application:**
- Make the final step of a flow feel rewarding (success animation, confirmation, next-step CTA)
- Smooth out the highest-friction moment (usually: account creation, payment entry)
- End onboarding with a win, not a wall of settings

---

### Jakob's Law
Users spend most of their time on *other* sites. They expect your interface to work like the
ones they already know.

**Application:** Don't invent novel navigation patterns without strong reason. Use established
conventions: top nav, hamburger on mobile, cart icon top-right, logo links to home. Novelty
has a usability tax.

---

### Law of Proximity
Items grouped visually are perceived as related. Whitespace creates separation.

**Application:** Group related form fields. Use section headers + whitespace to separate
unrelated groups. Buttons that act on the same object should be near that object.

---

### Zeigarnik Effect
People remember incomplete tasks better than completed ones. Progress indicators create
psychological pull to finish.

**Application:** Progress bars on multi-step flows. Completion percentages on profiles.
"You're 80% done" messaging. Saved drafts that invite return.

---

### Von Restorff Effect (Isolation Effect)
An item that stands out from its context is more memorable and attention-grabbing.

**Application:** Primary CTA should be visually distinct (color, size). Error states should
stand out. Don't make everything bold — nothing is bold.

---

### Doherty Threshold
Productivity increases dramatically when a system responds in under **400ms**. Perceived
delays change user behavior.

**Application:** Show skeleton screens or spinners immediately (< 100ms). Optimistic UI for
user-initiated actions. Never let a form submit button appear to do nothing.

---

## Error & Trust Principles

### Nielsen's 10 Heuristics (Selected)

**#1 Visibility of System Status**
Always tell users what's happening. Loading states, save confirmations, progress indicators.

**#5 Error Prevention**
Better to prevent errors than recover from them. Inline validation, disabled states with
tooltips, confirmation for destructive actions.

**#6 Recognition over Recall**
Don't make users remember information from one screen to use on another. Show context,
show previous selections, show summaries.

**#9 Help Users Recognize, Diagnose, and Recover from Errors**
Error messages must: name what went wrong, explain why (if useful), suggest a fix.
"Invalid email" is bad. "Email can't contain spaces — try removing them" is good.

---

### Poka-Yoke (Mistake-Proofing)
Design interfaces where errors are structurally impossible, not just warned against.

**Application:**
- Phone number fields that only accept digits (strip spaces/dashes automatically)
- Date pickers instead of free-text date fields
- Quantity steppers instead of free-text number inputs
- Confirm email field that rejects copy-paste

---

### Trust Signals
Users subconsciously evaluate trustworthiness constantly. Friction at high-trust moments
(payment, signup) destroys conversion.

**Application:**
- Show security badges near payment fields
- Use real testimonials/logos near conversion points
- Explain *why* you need sensitive info ("We need your DOB to verify your age")
- Don't ask for information you don't need yet

---

## Information Architecture Principles

### F-Pattern Reading (Nielsen)
Users scan text in an F-shaped pattern: across the top, down the left edge, with shorter
horizontal scans lower down.

**Application:**
- Most important information top-left
- CTAs on the left or full-width
- Don't put critical info in the bottom-right of a page

---

### Z-Pattern Reading
For sparse layouts (landing pages, cards), users scan in a Z: top-left → top-right →
diagonal → bottom-left → bottom-right.

**Application:**
- Logo top-left, primary CTA top-right
- Hero content in the middle diagonal
- Secondary CTA bottom-right

---

### Three-Click Rule (as principle, not law)
Users shouldn't need more than 3 clicks to reach any important content. Modern research
shows click count matters less than confidence — users don't mind clicks if they feel
they're making progress.

**Application:** Prioritize clear information scent (labels that tell you what you'll find)
over minimizing clicks.

---

### Inverted Pyramid
Lead with the conclusion, then supporting details, then background.

**Application:** Page titles and headings should state the outcome, not the process.
"Your order is confirmed" not "Order Processing Complete." "Get started free" not "Registration."
