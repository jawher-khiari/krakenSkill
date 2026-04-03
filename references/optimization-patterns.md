# Optimization Patterns — Refactoring Catalog + Performance Budgets + Caching

Load this file during **Phase 9: OPTIMIZE**.

---

## Table of Contents
1. [Refactoring Patterns (Martin Fowler)](#refactoring-patterns)
2. [Frontend Performance Budgets](#frontend-performance)
3. [Backend Performance Patterns](#backend-performance)
4. [Caching Strategy Selection](#caching-strategies)
5. [Database Optimization](#database-optimization)
6. [Bundle Optimization](#bundle-optimization)
7. [Connection Pool Sizing](#connection-pool-sizing)
8. [Pagination Strategy](#pagination-strategy)

---

## Refactoring Patterns

### Tier 1 — The Big Five (use these first, they solve 80% of complexity)

**1. Extract Function**
- When: Code fragment can be grouped and named
- How: Pull into new function, name by what it does, pass required data
- Signal: Method >20 lines, or a comment explaining a block
```
BEFORE: 50-line method with inline calculation + validation + formatting
AFTER: calculateTotal() + validateOrder() + formatReceipt()
```

**2. Replace Conditional with Polymorphism**
- When: Switch/if chain selects behavior based on type
- How: Create interface, implement per type, let dispatch handle selection
- Signal: `if (type === 'A') ... else if (type === 'B') ...`

**3. Replace Nested Conditional with Guard Clauses**
- When: Deeply nested if/else with special cases
- How: Check special cases first, return early, leave happy path flat
- Signal: Nesting >3 levels, especially with error/validation checks
```
BEFORE: if (valid) { if (auth) { if (exists) { doThing() } } }
AFTER: if (!valid) return error; if (!auth) return 401; if (!exists) return 404; doThing();
```

**4. Introduce Parameter Object**
- When: 3+ parameters travel together across functions
- How: Group into a typed object/class. Pass the object instead.
- Signal: Same params appear in multiple function signatures

**5. Decompose Conditional**
- When: Complex boolean expression in condition
- How: Extract into named function that reads like prose
- Signal: `if (a && (b || c) && !d && e.length > 0)`
```
BEFORE: if (user.age >= 18 && user.country === 'US' && !user.banned && user.verified)
AFTER: if (isEligibleForService(user))
```

### Tier 2 — Structural Refactoring

**6. Move Method** — Method uses more data from another class → move it there
**7. Extract Class** — Class doing 2+ distinct things → split into focused classes
**8. Inline Class** — Class doing too little → merge into its only consumer
**9. Replace Temp with Query** — Temp variable used once → replace with function call
**10. Encapsulate Collection** — Expose iterator instead of raw collection
**11. Replace Magic Number with Constant** — `if (status === 3)` → `if (status === Status.COMPLETED)`
**12. Collapse Hierarchy** — Subclass not adding value → merge into parent

### Tier 3 — Design Pattern Application

**13. Replace Type Code with Strategy** — Behavior varies by type → Strategy pattern
**14. Introduce Null Object** — Frequent null checks → NullObject that implements interface
**15. Replace Constructor with Factory** — Complex creation logic → Factory method
**16. Separate Query from Modifier** — Function both reads and writes → split into two

---

## Frontend Performance Budgets

### Core Web Vitals (2025 thresholds — enforce in CI)

| Metric | Good | Needs Improvement | Poor |
|---|---|---|---|
| **LCP** (Largest Contentful Paint) | ≤2.5s | 2.5-4.0s | >4.0s |
| **INP** (Interaction to Next Paint) | ≤200ms | 200-500ms | >500ms |
| **CLS** (Cumulative Layout Shift) | ≤0.1 | 0.1-0.25 | >0.25 |

Assessment: 75% of page loads must meet "Good" threshold.

### Bundle Budgets
| Resource | Budget | Rationale |
|---|---|---|
| **Main JS bundle (gzipped)** | ≤170KB | Tinder production budget |
| **Total JS (gzipped)** | ≤300KB | Above-fold interactivity |
| **Critical CSS (inline)** | ≤14KB | Fits in first TCP round-trip |
| **LCP image** | ≤100KB | Preload with `fetchpriority="high"` |
| **Total page weight** | ≤1.5MB | 3G load time target |
| **Web fonts** | ≤100KB total | Use `font-display: optional` or `swap` |

### Frontend Optimization Checklist
- [ ] LCP image preloaded with `<link rel="preload" fetchpriority="high">`
- [ ] Images: WebP (30-50% smaller than JPEG) or AVIF (50% smaller)
- [ ] Route-based code splitting: `React.lazy()`, `next/dynamic`, dynamic `import()`
- [ ] Critical CSS inlined in `<head>` (≤14KB)
- [ ] Below-fold images: `loading="lazy"` (native)
- [ ] `font-display: optional` for best CLS (or `swap` for fastest text)
- [ ] Long tasks (>50ms) broken up with `scheduler.yield()` for INP
- [ ] Third-party scripts deferred or loaded after LCP
- [ ] No layout shifts from images/ads without explicit `width`/`height`
- [ ] Tree-shaking enabled, dead code eliminated in build

---

## Backend Performance Patterns

### N+1 Query Detection and Resolution
**Detection:** Enable query logging in development. Count queries per request.
- Rails: Bullet gem
- Django: django-debug-toolbar
- Node: Prisma query events, TypeORM logger
- .NET: EF Core query logging

**Resolution patterns:**
1. **Eager loading (JOIN)** — Load related data in same query. Best for 1:1 and 1:few.
2. **Batch loading (WHERE IN)** — Load all related IDs in one query. Best for 1:many.
3. **DataLoader pattern** — Batches and caches within a single request. Best for GraphQL.
4. **Projection** — Select only needed columns. Don't `SELECT *`.

### Async Patterns
- [ ] No blocking calls (`Thread.Sleep`, sync HTTP) on async paths
- [ ] No fire-and-forget without error handling (`_ = DoAsync()` is dangerous)
- [ ] Use `Task.WhenAll()` / `Promise.all()` for parallel independent operations
- [ ] Set timeouts on ALL external calls (HTTP, DB, queue, cache)
- [ ] Cancel tokens propagated through entire call chain
- [ ] Connection pool not exhausted by long-running tasks (use background workers)

---

## Caching Strategies

| Strategy | How it works | Best for | Risk |
|---|---|---|---|
| **Cache-Aside** | App checks cache → miss → load from DB → write to cache | Read-heavy, tolerance for stale | Cache stampede on cold start |
| **Write-Through** | App writes to cache + DB simultaneously | Strong consistency required (banking) | Higher write latency |
| **Write-Behind** | App writes to cache, async batch writes to DB | Write-heavy, performance-critical | Data loss if cache crashes |
| **Read-Through** | Cache auto-loads from DB on miss | Simplify app code | Cache library must support |

### TTL Guidelines
| Data Type | TTL | Rationale |
|---|---|---|
| User session | 30 minutes | Security — limit window |
| User profile | 5 minutes | Balances freshness and load |
| Product catalog | 1 hour | Changes infrequently |
| Static reference data | 24 hours | Rarely changes |
| Search results | 5-15 minutes | Balance relevance and DB load |
| API rate limit counters | 1-60 minutes | Match rate limit window |

### Cache Invalidation Rules
1. Invalidate on write (delete cache key when source data changes)
2. Use cache tags/groups for bulk invalidation
3. Never cache user-specific data in shared cache without user-scoped keys
4. Monitor cache hit ratio — below 80% means TTL or key strategy needs work

---

## Database Optimization

### Index Strategy
| Index Type | Use When | Don't Use When |
|---|---|---|
| **B-tree** (default) | Range queries, sorting, equality | — |
| **Hash** | Exact equality only (key lookup) | Range queries, sorting |
| **GIN** | Full-text search, JSONB, arrays | Simple equality |
| **BRIN** | Very large naturally-ordered tables (time series) | Random access patterns |

### Composite Index Rules
- **Leftmost prefix rule:** Index (A, B, C) supports queries on (A), (A, B), (A, B, C) but NOT (B, C) alone
- **Column order:** Most selective column first (highest cardinality)
- **Include clause:** Add frequently selected but not filtered columns to avoid table lookup
- **Don't over-index:** Each index slows writes. Remove unused indexes.

### When NOT to Index
- Tables under 1,000 rows (full scan is fast enough)
- Columns with very low cardinality (boolean, status with 3 values)
- Tables with heavy write/light read patterns
- Columns never used in WHERE, JOIN, or ORDER BY

---

## Bundle Optimization

### JavaScript
- [ ] Tree-shaking enabled (ES modules, `sideEffects: false` in package.json)
- [ ] Route-based code splitting (lazy load pages/routes)
- [ ] Dynamic `import()` for heavy libraries (charts, editors, rich text)
- [ ] Analyze bundle: `webpack-bundle-analyzer` or `vite-plugin-visualizer`
- [ ] Replace heavy libraries with lighter alternatives when possible
- [ ] Dead code elimination in production build
- [ ] No duplicate dependencies (check with `npm dedupe`)

### CSS
- [ ] Remove unused CSS (PurgeCSS, Tailwind's built-in purge)
- [ ] Critical CSS inlined, rest loaded async
- [ ] No CSS-in-JS in SSR without proper extraction
- [ ] CSS custom properties over preprocessor variables (runtime theming)

### Images
- [ ] WebP/AVIF with fallback (`<picture>` element)
- [ ] Responsive images (`srcset` + `sizes`)
- [ ] Lazy loading for below-fold images
- [ ] SVG for icons and illustrations (not PNG/JPG)
- [ ] Image CDN with auto-optimization (Cloudinary, Imgix, Vercel Image)

---

## Connection Pool Sizing

### Formula (HikariCP/general purpose)
```
optimal_pool_size = (core_count × 2) + effective_spindle_count
```

| Server | Cores | Storage | Optimal Pool |
|---|---|---|---|
| 4-core, SSD | 4 | SSD (1) | 9 connections |
| 8-core, SSD | 8 | SSD (1) | 17 connections |
| 4-core, HDD | 4 | HDD (1) | 9 connections |

**The counterintuitive truth:** A 4-core server with 100 connections performs WORSE than
9 connections due to context switching overhead. More connections ≠ more throughput.

### Pool Configuration
- `minimumIdle`: Set equal to `maximumPoolSize` for consistent performance
- `connectionTimeout`: 30 seconds (fail fast, don't queue forever)
- `idleTimeout`: 10 minutes (reclaim unused connections)
- `maxLifetime`: 30 minutes (prevent stale connections)
- Monitor: track pool wait time, active connections, timeouts

---

## Pagination Strategy

| Strategy | Use When | Performance | UX |
|---|---|---|---|
| **Offset** (`LIMIT/OFFSET`) | <10K rows, page numbers needed | Degrades with large offsets | Jump to any page |
| **Cursor/Keyset** | >100K rows, infinite scroll, APIs | Consistent O(1) regardless of depth | Forward/backward only |
| **Seek** | Time-series, real-time feeds | Excellent for chronological data | Newest/oldest navigation |

### Performance Benchmark
| Method | Row 50,000 | Speed |
|---|---|---|
| OFFSET 50000 | ~8 seconds | Baseline |
| Cursor/Keyset | ~45ms | **177× faster** |

### Implementation Notes
- Offset: `SELECT * FROM items ORDER BY id LIMIT 20 OFFSET 40`
- Cursor: `SELECT * FROM items WHERE id > :last_seen_id ORDER BY id LIMIT 20`
- Always include `ORDER BY` with pagination (results must be deterministic)
- Return metadata: `{ data, nextCursor, hasMore, totalCount (offset only) }`
- Cursor values should be opaque to clients (base64-encode if needed)
