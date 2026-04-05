# Kraken Knowledge: Design & Accessibility

## Design Principles

### Visual Hierarchy
Every screen has exactly one primary action. The eye should follow: primary action → supporting content → secondary actions → metadata. Use size, color weight, and spacing to establish hierarchy. Never let two elements compete for attention equally.

### Progressive Disclosure
Show only what's needed at each step. Hide complexity behind progressive layers. Use expandable sections, modals, and step wizards for complex flows. Default state should show the minimum viable information.

### Spacing System — 8px Grid
All spacing uses multiples of 8px: 8, 16, 24, 32, 40, 48, 56, 64. Use 4px for minor internal adjustments only. Consistent spacing creates visual rhythm and reduces cognitive load.

### Typography Rules
Maximum 2-3 font sizes per screen. Use font weight (not size) for secondary emphasis. Line height: 1.5 for body text, 1.2-1.3 for headings. Maximum line length: 65-75 characters for readability.

### Functional Color
Every color must have a semantic meaning: primary action, destructive action, success, warning, error, informational. Never use color as the ONLY way to convey information (accessibility). Maintain consistent color meanings across the entire application.

### Meaningful Motion
Animation duration: 150-300ms for micro-interactions, 300-500ms for page transitions. Use easing: ease-out for elements entering, ease-in for elements leaving. Motion should communicate state change, not decorate. Respect `prefers-reduced-motion` media query.

### Mobile-First Design
Design for the smallest screen first, then enhance for larger. Touch targets: minimum 44x44px with 8px spacing between targets. Thumb zone: place primary actions in the bottom 2/3 of the screen. Avoid hover-dependent interactions on mobile.

## WCAG 2.2 AA Requirements

### Perceivable
- Text contrast ratio: minimum 4.5:1 for normal text, 3:1 for large text (18px+ or 14px+ bold)
- Non-text contrast: minimum 3:1 for UI components and graphical objects
- All images have alt text (decorative images use alt="")
- No information conveyed by color alone
- Captions for all pre-recorded audio/video content
- Content is responsive and reflows at 320px width without horizontal scrolling

### Operable
- All functionality accessible via keyboard
- No keyboard traps (user can always Tab away)
- Focus indicators visible on all interactive elements (minimum 2px outline)
- Focus order matches visual order (logical tab sequence)
- Skip navigation link at top of page
- Touch targets: minimum 24x24px (44x44px recommended)
- No time limits (or provide extension mechanism)
- No content flashing more than 3 times per second

### Understandable
- Language attribute set on HTML element
- Form inputs have visible labels (not just placeholders)
- Error messages identify the field and describe the issue
- Error suggestions provided when detectable
- Consistent navigation across pages
- Consistent component identification

### Robust
- Valid HTML (proper nesting, unique IDs, complete start/end tags)
- ARIA landmarks used correctly (nav, main, aside, footer)
- Custom components have proper ARIA roles, states, and properties
- Status messages communicated via aria-live regions
- Name, role, value programmatically determinable for all UI components

## Component State Matrix Template

Every interactive component MUST define these states:

| State | Required Properties |
|---|---|
| Default | Base visual appearance, initial ARIA state |
| Hover | Visual change on mouse enter (cursor, background, shadow) |
| Focus | Visible outline (2px+), high contrast, never remove default outline without replacement |
| Active | Visual feedback on press (scale, color shift) |
| Disabled | Reduced opacity (0.5), cursor: not-allowed, aria-disabled="true", removed from tab order |
| Loading | Skeleton or spinner, aria-busy="true", disable interactions, preserve layout space |
| Error | Red border/icon, error message linked via aria-describedby, focus moved to first error |
| Success | Green indicator, success message via aria-live="polite", auto-dismiss after 5s |
| Empty | Empty state message with call-to-action, illustration optional |
| Selected | Visual indicator (checkbox, highlight), aria-selected="true" or aria-checked="true" |

## Responsive Breakpoints

| Breakpoint | Target | Layout Strategy |
|---|---|---|
| <640px | Mobile | Single column, stacked layout, full-width inputs, bottom-anchored CTAs |
| 640-1024px | Tablet | 2-column where beneficial, side panels collapse to overlays |
| 1024-1440px | Desktop | Full layout, sidebars visible, multi-column grids |
| >1440px | Wide | Max-width container (1200-1440px), center content, prevent line-length > 75ch |

## API Contract Design (Backend Phase 5)

### API Documentation Standard (from documentation-generator pattern)

Every API endpoint MUST be documented with:
1. **Signature:** Method + path + description
2. **Parameters:** Name, type, required/optional, constraints, default
3. **Request body:** Full schema with field descriptions
4. **Response:** Success + every error case with example bodies
5. **Errors:** Specific error codes, messages, and recovery actions
6. **Example:** Complete request/response pair for happy path
7. **Authentication:** What auth is required, what scopes/roles

### Response Format Consistency
All API responses in a project MUST use the same envelope structure:
```
Success: { data: T, meta?: { pagination, timestamp } }
Error: { error: { code: string, message: string, fields?: FieldError[] } }
```

### Status Code Usage
- 200: Successful GET, PUT, PATCH
- 201: Successful POST that creates a resource (include Location header)
- 204: Successful DELETE (no body)
- 400: Validation error (client can fix and retry)
- 401: Not authenticated (missing or invalid token)
- 403: Authenticated but not authorized for this resource
- 404: Resource not found (don't reveal existence to unauthorized users)
- 409: Conflict (duplicate, version mismatch)
- 422: Semantically invalid (syntactically correct but business rules prevent it)
- 429: Rate limited (include Retry-After header)
- 500: Server error (never expose stack traces in production)
