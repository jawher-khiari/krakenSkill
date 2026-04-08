# Kraken Observability & Monitoring Reference

> Absorbed from [jwadow/agentic-prompts](https://github.com/jwadow/agentic-prompts) (Observer persona), [microsoft/TaskWeaver](https://github.com/microsoft/TaskWeaver) (stateful execution).

## Observability by Design

Code is NOT "done" until it is instrumented. Every new endpoint, service, or feature must answer: "How will we know this works correctly in production?"

## Three Pillars of Observability

### 1. Logs — "What happened?"
Chronological record of discrete events.

**Rules:**
- Logs MUST be structured (JSON). Unstructured text logs are unmaintainable.
- Every log MUST include `correlation_id` / `trace_id` for request chain tracking.
- Log levels used correctly: ERROR (action needed), WARN (degradation), INFO (events), DEBUG (development only).
- NEVER log: passwords, tokens, PII, credit card numbers, session IDs.

```json
{"event": "user_registered", "user_id": 123, "source": "web", "trace_id": "xyz-123", "timestamp": "2026-01-01T00:00:00Z"}
```

### 2. Metrics — "How is the system feeling?"
Numeric values aggregated over time. Four types:
- **Counter:** Monotonically increasing (requests_total, errors_total)
- **Gauge:** Can increase or decrease (active_connections, queue_size, memory_usage)
- **Histogram:** Distribution in buckets (request_duration_seconds) — enables percentiles (p99, p95)
- **Summary:** Client-side percentiles — use sparingly

### 3. Traces — "Why did this happen?"
Full path of one request through all components (spans).
```
2ms (API Gateway) → 50ms (Auth Service) → 300ms (DB Query) → 10ms (Serialization)
```
Immediately identifies bottleneck = DB query.

## Four Golden Signals (Google SRE)

Every service dashboard MUST show:
1. **Latency** — Response time distribution (p50, p95, p99)
2. **Traffic** — Requests per second (RPS)
3. **Errors** — Error rate (5xx/total, failed operations/total)
4. **Saturation** — How "full" the system is (CPU, memory, disk, queue depth)

## Health Checks

### Levels
- **Liveness:** "Is the process running?" → `/healthz` returning 200
- **Readiness:** "Can it accept traffic?" → `/ready` checking DB, cache, dependencies
- **Startup:** "Has it finished initializing?" → `/startup` for slow-starting services

### Docker HEALTHCHECK
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s CMD curl --fail http://localhost:8080/healthz || exit 1
```

## Alerting Rules

- Alert on SYMPTOMS, not causes: "P99 latency > 500ms for 5 minutes" not "CPU > 80%"
- Every alert must have a runbook link
- Group related alerts to prevent alert storms
- Implement alert severity levels: PAGE (immediate), TICKET (next business day), LOG (review weekly)

## Predictive Monitoring

Analyze trends to predict failures:
- Disk usage growing 1GB/day → out of space in 7 days → act now
- Error rate slowly climbing → investigate before it becomes an incident
- Connection pool utilization trending toward max → scale before saturation

## Kraken Application

| Phase | Observability Action |
|---|---|
| P4: PLAN | Include logging/metrics/traces in technical plan per slice |
| P5: DESIGN-UI | Add health check endpoints for BACKEND/FULLSTACK |
| P6: IMPLEMENT | Instrument code with structured logs, metrics, traces |
| P8: REVIEW | Verify observability in Pass 7 (Documentation) |
| P10: VERIFY | Confirm health checks pass, monitoring dashboards exist |

## Complexity Tax Calculation

For every feature, estimate the hidden cost:
- **Development tax:** Ongoing maintenance hours/month
- **Testing tax:** CI/CD pipeline time added
- **Cognitive tax:** How much harder is onboarding?
- **Operational tax:** Monitoring/alerting/on-call burden

If tax exceeds value → candidate for removal (Annihilator verdict).
