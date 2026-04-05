# Kraken Knowledge: Testing Strategy

## Testing Pyramid

### Unit Tests (70% of test suite)
- Test individual functions/methods in isolation
- Mock all external dependencies (database, API, file system)
- Fast: entire unit suite runs in <10 seconds
- Naming: `should [expected behavior] when [condition]`
- One assertion per test (or one logical assertion group)

### Integration Tests (20% of test suite)
- Test interaction between 2+ components
- Use real database (test container or in-memory)
- Test API endpoints with real middleware chain
- Verify serialization/deserialization
- Test repository methods against real schema

### E2E Tests (10% of test suite)
- Test critical user journeys end-to-end
- Use browser automation (Playwright preferred)
- Cover: login flow, primary CRUD operations, payment flow
- Slow but high confidence — run on CI, not on every save

## TDD Workflow

1. Write a failing test that describes desired behavior
2. Write the minimum code to make the test pass
3. Refactor while keeping tests green
4. Repeat for next behavior

## Arrange/Act/Assert Pattern (MANDATORY)

Every test follows this structure:

```
test('should [expected behavior] when [condition]', () => {
  // Arrange — set up test data, mocks, preconditions
  const input = createTestInput();
  const mockService = createMock();
  
  // Act — execute the function under test (ONE call)
  const result = functionUnderTest(input);
  
  // Assert — verify expected outcome (focused assertions)
  expect(result).toEqual(expectedOutput);
  expect(mockService).toHaveBeenCalledWith(expectedArgs);
});
```

Rules:
- ONE act per test. If you need two acts, write two tests.
- Arrange should be minimal — only set up what THIS test needs.
- Assert should be focused — don't assert everything, assert what matters.

## Test Grouping Structure (MANDATORY)

Organize tests by scenario type using describe blocks:

```
describe('FunctionName', () => {
  describe('Happy Path', () => {
    test('should return result with valid input', ...);
    test('should handle multiple valid items', ...);
  });
  
  describe('Edge Cases', () => {
    test('should handle empty input', ...);
    test('should handle boundary values', ...);
    test('should handle maximum allowed size', ...);
  });
  
  describe('Error Handling', () => {
    test('should throw on null input', ...);
    test('should throw on invalid format', ...);
    test('should handle service unavailable', ...);
  });
  
  describe('Integration', () => {
    test('should work with real database', ...);
    test('should call dependencies in correct order', ...);
  });
  
  describe('Performance', () => {
    test('should complete within 100ms for 1000 items', ...);
  });
});
```

## Test Data Management

- Create factory functions: `createTestUser()`, `createTestOrder()` with sensible defaults
- Override only what matters per test: `createTestUser({ age: 17 })` for underage test
- Never share mutable state between tests
- Setup heavy fixtures in `beforeAll`, per-test state in `beforeEach`
- Always clean up: database rows, file system, mock state

## What to Test

### Always Test
- Happy path (expected input → expected output)
- Validation rules (invalid input → specific error)
- Boundary values (empty, null, zero, max, min)
- Authorization (user A can't access user B's data)
- Error handling (service down → graceful degradation)

### Never Test
- Framework internals (don't test that Express routes work)
- Third-party library behavior (don't test that bcrypt hashes)
- Private methods directly (test through public interface)
- Trivial getters/setters with no logic

## Coverage Targets

- Branch coverage target: ≥80%
- Critical paths (auth, payment, data mutation): 100% branch coverage
- UI components: snapshot + interaction tests for all states
- Coverage is a metric, not a goal — 100% coverage with bad tests is worse than 80% with good tests

## Test Organization

- Co-locate tests with source: `src/services/UserService.ts` → `src/services/UserService.test.ts`
- Shared fixtures in `__fixtures__/` or `test/helpers/`
- Test database setup/teardown in `beforeAll`/`afterAll`, not `beforeEach`
- Never share mutable state between tests
