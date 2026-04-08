# Kraken Accessibility Reference (WCAG 2.1 AA)

> Absorbed from [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) — accessibility-checklist reference + frontend-ui-engineering skill.

## Essential Checks

### Keyboard Navigation
- All interactive elements focusable via Tab
- Focus order follows visual/logical order
- Focus is visible (outline/ring on focused elements)
- Custom widgets: Enter to activate, Escape to close
- No keyboard traps (user can always Tab away)
- Skip-to-content link at top of page
- Modals trap focus while open, return focus on close

### Screen Readers
- All images have `alt` text (or `alt=""` for decorative)
- All form inputs have associated labels (`<label>` or `aria-label`)
- Buttons and links have descriptive text (not "Click here")
- Icon-only buttons have `aria-label`
- Page has one `<h1>`, headings don't skip levels
- Dynamic content changes announced (`aria-live` regions)
- Tables have `<th>` headers with scope

### Visual
- Text contrast ≥ 4.5:1 (normal text) or ≥ 3:1 (large text 18px+)
- UI component contrast ≥ 3:1 against background
- Color is NOT the only way to convey information
- Text resizable to 200% without breaking layout
- No content flashing more than 3 times per second

### Forms
- Every input has a visible label
- Required fields indicated (not by color alone)
- Error messages specific and associated with the field
- Error state visible by more than color (icon, text, border)
- Form submission errors summarized and focusable

### Content
- Language declared (`<html lang="en">`)
- Page has a descriptive `<title>`
- Links distinguishable from surrounding text (not by color alone)

## ARIA Quick Reference

### Live Regions
```html
<!-- Polite: announced after current speech -->
<div aria-live="polite">Status updated</div>

<!-- Assertive: interrupts current speech -->
<div aria-live="assertive">Error: session expired</div>
```

### Common Patterns
```html
<!-- Icon button -->
<button aria-label="Close dialog"><XIcon /></button>

<!-- Loading state -->
<div aria-busy="true" aria-live="polite">Loading...</div>

<!-- Tabs -->
<div role="tablist">
  <button role="tab" aria-selected="true" aria-controls="panel-1">Tab 1</button>
</div>
<div role="tabpanel" id="panel-1">Content</div>
```

## Testing Tools
- axe-core / axe DevTools browser extension
- Lighthouse accessibility audit
- VoiceOver (macOS), NVDA (Windows), TalkBack (Android)
- Keyboard-only navigation test (unplug mouse)
- `prefers-reduced-motion` and `prefers-color-scheme` media queries

## Red Flags
- Components with 200+ lines (split them)
- Inline styles or arbitrary pixel values
- Missing error/loading/empty states
- No keyboard navigation testing
- Color as sole state indicator (red/green without text/icons)
- Generic "AI look" (purple gradients, oversized cards)
