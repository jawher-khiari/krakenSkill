# Kraken Anti-Rationalization Reference

> Absorbed from [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills). Anti-rationalization tables prevent the agent from cutting corners by pre-empting common excuses with documented rebuttals.

## Phase 1: RECEIVE (Spec & Requirements)

| Rationalization | Reality |
|---|---|
| "This is simple, I don't need a spec" | Simple tasks still need acceptance criteria. A two-line spec is fine. |
| "I'll write the spec after I code it" | That's documentation, not specification. The spec's value is in forcing clarity BEFORE code. |
| "The spec will slow us down" | A 15-minute spec prevents hours of rework. |
| "Requirements will change anyway" | That's why the spec is a living document. An outdated spec is still better than no spec. |
| "The user knows what they want" | Even clear requests have implicit assumptions. The spec surfaces them. |

## Phase 2: BRAINSTORM (Exploration)

| Rationalization | Reality |
|---|---|
| "I know what the bug is, I'll just fix it" | You might be right 70% of the time. The other 30% costs hours. Explore first. |
| "The agent should figure out the conventions" | It can't read your mind. Write conventions down — 10 minutes saves hours. |
| "More context is always better" | Performance degrades with too many instructions. Be selective. |
| "I'll just correct it when it goes wrong" | Prevention is cheaper than correction. Upfront context prevents drift. |

## Phase 3: DECOMPOSE (Task Breakdown)

| Rationalization | Reality |
|---|---|
| "I'll figure it out as I go" | That's how you end up with a tangled mess and rework. 10 minutes of planning saves hours. |
| "The tasks are obvious" | Write them down anyway. Explicit tasks surface hidden dependencies and forgotten edge cases. |
| "Planning is overhead" | Planning IS the task. Implementation without a plan is just typing. |
| "I can hold it all in my head" | Context windows are finite. Written plans survive session boundaries. |

## Phase 4: PLAN (Detailed Planning)

| Rationalization | Reality |
|---|---|
| "We'll document the API later" | The types ARE the documentation. Define them first. |
| "We don't need pagination for now" | You will the moment someone has 100+ items. Add it from the start. |
| "Internal APIs don't need contracts" | Internal consumers are still consumers. Contracts prevent coupling. |
| "We'll version the API when we need to" | Breaking changes without versioning break consumers. Design for extension from the start. |
| "Nobody uses that undocumented behavior" | Hyrum's Law: if it's observable, somebody depends on it. |

## Phase 5: DESIGN-UI

| Rationalization | Reality |
|---|---|
| "Accessibility is a nice-to-have" | It's a legal requirement in many jurisdictions and an engineering quality standard. |
| "We'll make it responsive later" | Retrofitting responsive design is 3x harder than building it from the start. |
| "The design isn't final, so I'll skip styling" | Use the design system defaults. Unstyled UI creates broken first impressions. |
| "This is just a prototype" | Prototypes become production code. Build the foundation right. |
| "The AI aesthetic is fine for now" | It signals low quality. Use the project's actual design system. |

## Phase 6: IMPLEMENT

| Rationalization | Reality |
|---|---|
| "I'll test it all at the end" | Bugs compound. A bug in Slice 1 makes Slices 2-5 wrong. Test each slice. |
| "It's faster to do it all at once" | It FEELS faster until something breaks and you can't find which of 500 lines caused it. |
| "These changes are too small to commit separately" | Small commits are free. Large commits hide bugs and make rollbacks painful. |
| "I'll add the feature flag later" | If the feature isn't complete, it shouldn't be user-visible. Add the flag now. |
| "This refactor is small enough to include" | Refactors mixed with features make both harder to review. Separate them. |
| "I'll write tests after the code works" | You won't. And tests written after the fact test implementation, not behavior. |
| "This is too simple to test" | Simple code gets complicated. The test documents the expected behavior. |
| "I tested it manually" | Manual testing doesn't persist. Tomorrow's change might break it with no way to know. |
| "I'll commit when the feature is done" | One giant commit is impossible to review, debug, or revert. Commit each slice. |
| "The message doesn't matter" | Messages are documentation. Future you will need to understand what changed and why. |

## Phase 7: SECURITY-AUDIT

| Rationalization | Reality |
|---|---|
| "This is an internal tool, security doesn't matter" | Internal tools get compromised. Attackers target the weakest link. |
| "We'll add security later" | Security retrofitting is 10x harder than building it in. Add it now. |
| "No one would try to exploit this" | Automated scanners will find it. Security by obscurity is not security. |
| "The framework handles security" | Frameworks provide tools, not guarantees. You still need to use them correctly. |
| "It's just a prototype" | Prototypes become production. Security habits from day one. |

## Phase 8: REVIEW

| Rationalization | Reality |
|---|---|
| "It works, that's good enough" | Working code that's unreadable, insecure, or architecturally wrong creates compounding debt. |
| "I wrote it, so I know it's correct" | Authors are blind to their own assumptions. Every change benefits from another perspective. |
| "We'll clean it up later" | Later never comes. The review is the quality gate — use it. |
| "AI-generated code is probably fine" | AI code needs MORE scrutiny, not less. It's confident and plausible, even when wrong. |
| "The tests pass, so it's good" | Tests are necessary but not sufficient. They don't catch architecture, security, or readability problems. |

## Phase 9: OPTIMIZE

| Rationalization | Reality |
|---|---|
| "It's working, no need to touch it" | Working code that's hard to read will be hard to fix when it breaks. |
| "Fewer lines is always simpler" | A 1-line nested ternary is not simpler than a 5-line if/else. Simplicity is about comprehension speed. |
| "We'll optimize later" | Performance debt compounds. Fix obvious anti-patterns now, defer micro-optimizations. |
| "It's fast on my machine" | Your machine isn't the user's. Profile on representative hardware. |
| "This optimization is obvious" | If you didn't measure, you don't know. Profile first. |
| "The original author must have had a reason" | Maybe. Check git blame — apply Chesterton's Fence. But complexity often has no reason; it's residue of iteration under pressure. |

## Phase 10: VERIFY (Ship)

| Rationalization | Reality |
|---|---|
| "It works in staging, it'll work in production" | Production has different data, traffic patterns, and edge cases. Monitor after deploy. |
| "We don't need feature flags for this" | Every feature benefits from a kill switch. Even "simple" changes can break things. |
| "Monitoring is overhead" | Not having monitoring means you discover problems from user complaints. |
| "Rolling back is admitting failure" | Rolling back is responsible engineering. Shipping a broken feature is the failure. |
| "The code is self-documenting" | Code shows what. It doesn't show why, what alternatives were rejected, or what constraints apply. |
| "ADRs are overhead" | A 10-minute ADR prevents a 2-hour debate about the same decision six months later. |
