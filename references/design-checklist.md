# Design Checklist — WCAG 2.2 + Design Tokens + Animation Timing + Component Architecture

Load this file during **Phase 5: DESIGN-UI**.

---

## Table of Contents
1. [WCAG 2.2 AA Compliance Checklist](#wcag-22-aa-checklist)
2. [Design Token Architecture](#design-token-architecture)
3. [Animation & Motion Timing Reference](#animation-timing)
4. [Component State Matrix Template](#component-state-matrix)
5. [Visual Hierarchy Rules](#visual-hierarchy)
6. [Responsive & Mobile-First Rules](#responsive-rules)
7. [Color System Design](#color-system)
8. [Typography System](#typography-system)
9. [Minimum Component Library](#minimum-components)

---

## WCAG 2.2 AA Compliance Checklist

### Perceivable
- [ ] **Text contrast ≥4.5:1** for normal text (<24px regular, <18.66px bold)
- [ ] **Text contrast ≥3:1** for large text (≥24px regular, ≥18.66px bold)
- [ ] **UI component contrast ≥3:1** for borders, icons, controls against background
- [ ] **Focus indicator contrast ≥3:1** between focused and unfocused states
- [ ] **Focus indicator ≥2px thick** visible outline/ring
- [ ] Non-text content has text alternatives (alt text, ARIA labels)
- [ ] Color is NOT the only means of conveying information (add icons, text, patterns)
- [ ] Audio/video has captions and transcripts
- [ ] Content readable at 200% zoom without horizontal scrolling
- [ ] Text spacing adjustable without loss of content (1.5× line height, 2× letter spacing)

### Operable
- [ ] **All functionality keyboard accessible** — Tab, Enter, Space, Escape, Arrow keys
- [ ] **Visible focus indicator** on every interactive element (never `outline: none` without replacement)
- [ ] **Focus Not Obscured (2.4.11)** — Focused element not fully hidden by sticky headers/footers/modals
- [ ] **Focus order logical** — Tab order matches visual layout (no tabindex > 0)
- [ ] **Target Size Minimum (2.5.8)** — Interactive targets ≥24×24 CSS pixels with adequate spacing
- [ ] **Touch target size** — ≥44×44px (Apple HIG) / ≥48×48dp (Material Design)
- [ ] **Dragging Movements (2.5.7)** — Single-pointer alternatives for ALL drag operations
- [ ] No keyboard traps (user can always Tab/Escape out of any component)
- [ ] Skip navigation link for screen readers
- [ ] Page titles descriptive and unique
- [ ] No auto-play audio/video (or provide immediate stop control)
- [ ] Time limits: warn user, allow extension, or remove

### Understandable
- [ ] **Redundant Entry (3.3.7)** — Don't ask users for same information twice in a flow
- [ ] **Accessible Authentication (3.3.8)** — No cognitive function tests for login. Allow paste. Support password managers.
- [ ] Form inputs have visible labels (not just placeholder text)
- [ ] Error messages identify the field AND describe how to fix
- [ ] Error messages announced to screen readers via `aria-live` or `role="alert"`
- [ ] Consistent navigation across pages
- [ ] Language attribute set on `<html>` element

### Robust
- [ ] Valid, semantic HTML (correct heading hierarchy, landmark regions)
- [ ] ARIA used correctly: `aria-label`, `aria-describedby`, `aria-expanded`, `aria-hidden`
- [ ] Custom components meet ARIA Authoring Practices (APG) patterns
- [ ] Status messages announced via `aria-live="polite"` or `role="status"`
- [ ] Works with major screen readers (NVDA, JAWS, VoiceOver)

---

## Design Token Architecture

Three-tier system — changes at primitive level cascade everywhere:

### Tier 1: Primitive Tokens (Raw Values)
```css
/* Colors */
--color-blue-50: #eff6ff;
--color-blue-500: #3b82f6;
--color-blue-700: #1d4ed8;
--color-red-500: #ef4444;
--color-green-500: #22c55e;
--color-amber-500: #f59e0b;
--color-gray-50: #f9fafb;
--color-gray-100: #f3f4f6;
--color-gray-200: #e5e7eb;
--color-gray-400: #9ca3af;
--color-gray-600: #4b5563;
--color-gray-800: #1f2937;
--color-gray-900: #111827;

/* Spacing (8px grid) */
--space-1: 4px;   /* sub-grid fine adjustment */
--space-2: 8px;
--space-3: 12px;
--space-4: 16px;
--space-6: 24px;
--space-8: 32px;
--space-10: 40px;
--space-12: 48px;
--space-16: 64px;

/* Typography */
--font-size-xs: 12px;
--font-size-sm: 14px;
--font-size-base: 16px;
--font-size-lg: 18px;
--font-size-xl: 20px;
--font-size-2xl: 24px;
--font-size-3xl: 30px;

/* Radius */
--radius-sm: 4px;
--radius-md: 8px;
--radius-lg: 12px;
--radius-xl: 16px;
--radius-full: 9999px;

/* Shadows */
--shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
--shadow-md: 0 4px 6px rgba(0,0,0,0.07);
--shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
```

### Tier 2: Semantic Tokens (Purpose-Based — flip for dark mode)
```css
/* Light mode */
--color-bg-primary: var(--color-gray-50);
--color-bg-surface: #ffffff;
--color-bg-elevated: #ffffff;
--color-text-primary: var(--color-gray-900);
--color-text-secondary: var(--color-gray-600);
--color-text-muted: var(--color-gray-400);
--color-action-primary: var(--color-blue-500);
--color-action-primary-hover: var(--color-blue-700);
--color-border: var(--color-gray-200);
--color-error: var(--color-red-500);
--color-success: var(--color-green-500);
--color-warning: var(--color-amber-500);
--color-info: var(--color-blue-500);

/* Dark mode — only semantic tokens change */
[data-theme="dark"] {
  --color-bg-primary: var(--color-gray-900);
  --color-bg-surface: var(--color-gray-800);
  --color-text-primary: var(--color-gray-50);
  --color-text-secondary: var(--color-gray-400);
  --color-border: var(--color-gray-600);
}
```

### Tier 3: Component Tokens (Specific Bindings)
```css
--button-bg-primary: var(--color-action-primary);
--button-bg-primary-hover: var(--color-action-primary-hover);
--button-text-primary: #ffffff;
--button-radius: var(--radius-md);
--button-padding: var(--space-3) var(--space-6);
--input-border: var(--color-border);
--input-border-focus: var(--color-action-primary);
--input-border-error: var(--color-error);
--card-bg: var(--color-bg-surface);
--card-shadow: var(--shadow-md);
--card-radius: var(--radius-lg);
```

---

## Animation & Motion Timing Reference

### Interaction Timing
| Interaction | Duration | Easing | Notes |
|---|---|---|---|
| Hover state | 100-150ms | ease-out | Instant feel, smooth transition |
| Button press | 100-200ms | ease-out | Scale 0.98 + color shift |
| Focus ring | 0ms (instant) | — | Never delay focus indicators |
| Tooltip show | 200ms delay + 150ms fade | ease-out | Delay prevents flicker |
| Dropdown open | 150-200ms | ease-out | Slide + fade |
| Modal enter | 200-300ms | ease-out | Scale from 0.95 + fade |
| Modal exit | 150-200ms | ease-in | Exits always faster than enters |
| Page transition | 300-500ms | ease-in-out | Cross-fade or slide |
| Toast notification | 300ms enter, 200ms exit | ease-out / ease-in | Auto-dismiss 5-8s |
| Skeleton pulse | 1.5-2s cycle | ease-in-out | Opacity 0.4 → 1.0 |
| Loading spinner | 1s rotation | linear | Continuous |

### Performance Rules
- Only animate `transform` and `opacity` (GPU-accelerated)
- NEVER animate `height`, `width`, `top`, `left`, `margin`, `padding`
- Use `will-change` sparingly and only on elements that will animate
- Always respect `prefers-reduced-motion: reduce` — disable non-essential motion
- Use `animation-fill-mode: both` to prevent flash of initial state

### CSS Pattern
```css
@media (prefers-reduced-motion: no-preference) {
  .element {
    transition: transform 200ms ease-out, opacity 200ms ease-out;
  }
}
@media (prefers-reduced-motion: reduce) {
  .element {
    transition: none;
  }
}
```

---

## Component State Matrix Template

Copy and fill for EVERY new interactive component:

| State | Visual | CSS/Class | ARIA | Interaction |
|---|---|---|---|---|
| **Default** | Standard appearance | `.btn` | — | Clickable |
| **Hover** | Subtle elevation or color shift | `.btn:hover` | — | Cursor pointer |
| **Focus** | 2px+ ring, 3:1 contrast | `.btn:focus-visible` | — | Keyboard accessible |
| **Active** | Scale 0.98 or darken | `.btn:active` | — | Visual press feedback |
| **Disabled** | 40-50% opacity | `.btn:disabled` | `aria-disabled="true"` | Not clickable, not focusable |
| **Loading** | Spinner or skeleton | `.btn--loading` | `aria-busy="true"` | Not clickable |
| **Error** | Red border/outline | `.btn--error` | `aria-invalid="true"` | Shows error message |
| **Success** | Green indicator | `.btn--success` | `role="status"` | Temporary (2-3s) |
| **Selected** | Filled or checked | `.btn--selected` | `aria-pressed="true"` | Toggle behavior |

---

## Visual Hierarchy Rules

1. **Primary action** = Solid filled button with brand color. ONE per screen/section.
2. **Secondary action** = Outlined or ghost button. Support the primary.
3. **Tertiary action** = Text link or icon button. Least important.
4. **Destructive action** = Red. Separated from other actions. Requires confirmation.
5. **Size hierarchy** = Large (primary CTA) > Medium (standard) > Small (inline/table actions)
6. **Spacing creates grouping** = Related items close together, unrelated items far apart (Gestalt proximity)
7. **Typography weight** = Bold headings > Medium subheadings > Regular body > Light captions
8. **Color saturation** = High saturation draws attention. Use for CTAs and alerts. Desaturate backgrounds.

---

## Responsive & Mobile-First Rules

1. Design for 320px width FIRST, then expand: 320 → 375 → 768 → 1024 → 1280 → 1440
2. Touch targets: minimum 44×44px with ≥8px spacing between targets
3. Forms: single column on mobile. Labels above inputs (not beside).
4. Navigation: bottom bar for ≤5 items, hamburger for more. Top bar for desktop.
5. Tables: horizontal scroll with frozen first column on mobile. Or card-based layout.
6. Images: `srcset` + `sizes` for responsive images. WebP with JPEG fallback.
7. Font sizes: never below 12px for any text. Body ≥16px to prevent iOS zoom on focus.
8. Modals: full-screen on mobile (bottom sheet pattern). Centered overlay on desktop.
9. Padding: ≥16px horizontal on mobile screens. ≥24px on tablet+.

---

## Color System Design

### Functional Color Assignments
| Function | Color | Usage |
|---|---|---|
| Primary action | Brand blue | CTAs, links, active states |
| Success | Green (#22c55e) | Confirmations, valid states, completed |
| Warning | Amber (#f59e0b) | Cautions, pending states |
| Error/Danger | Red (#ef4444) | Errors, destructive actions, invalid |
| Info | Blue (#3b82f6) | Informational notices |
| Disabled | Gray 40-50% opacity | Inactive states |
| Neutral | Gray scale | Backgrounds, borders, secondary text |

### Dark Mode Rules
- Never just invert colors. Redesign with dark-mode-specific palette.
- Reduce saturation slightly for dark backgrounds (vivid on dark = eye strain)
- Shadows become subtle glows or elevated background colors
- Borders become lighter (gray-600 instead of gray-200)
- Primary text becomes gray-50, secondary becomes gray-400

---

## Typography System

```css
/* Scale: Major Third (1.25) */
--text-xs: 0.75rem;    /* 12px — minimum for any text */
--text-sm: 0.875rem;   /* 14px — captions, labels, metadata */
--text-base: 1rem;     /* 16px — body text, inputs */
--text-lg: 1.125rem;   /* 18px — large body, intro text */
--text-xl: 1.25rem;    /* 20px — H4, card titles */
--text-2xl: 1.5rem;    /* 24px — H3, section headers */
--text-3xl: 1.875rem;  /* 30px — H2, page sections */
--text-4xl: 2.25rem;   /* 36px — H1, page title */

/* Line heights */
--leading-tight: 1.25;   /* headings */
--leading-normal: 1.5;   /* body text — WCAG minimum */
--leading-relaxed: 1.75;  /* long-form reading */

/* Max 2-3 font sizes per screen section */
/* Rule: Heading + Body + Caption = done */
```

---

## Minimum Component Library

Every design system needs at least these ~32 components:

### Input Components
Button, Text Input, Textarea, Select/Dropdown, Checkbox, Radio, Toggle/Switch,
Slider, Date Picker, File Upload, Search Input, Autocomplete

### Navigation Components
Top Bar/Header, Bottom Navigation, Sidebar, Breadcrumbs, Tabs, Pagination, Link

### Data Display Components
Card, Table, List, Badge/Tag, Avatar, Tooltip, Accordion/Disclosure,
Progress Bar/Indicator

### Feedback Components
Modal/Dialog, Toast/Snackbar, Alert/Banner, Spinner/Loading, Skeleton Loader,
Empty State, Popover, Confirmation Dialog
