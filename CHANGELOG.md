## 1.1.0
! IMPORTANT: This version modifies default values. While not introducing breaking changes, it may produce different results compared to the previous version.

- Added: New optional `initial_bracket` parameter allows customizing the search interval for Brent's method. This enables users to guide the algorithm towards specific rate ranges or help convergence in challenging scenarios.
- Change: Default Brent's method search initial interval changed from [0.999, 10.0] to [0.3, 10.0]. This improves convergence in typical financial scenarios where multiple solutions exist.

## 1.0.2

- Fixed: The `find_bracketing_interval` function now supports extremely high rates, improving precision for very high XIRRs (over 1E300%). Dynamic step sizing ensures accurate results even at extreme rates.

## 1.0.1

- Fixed: Resolved an issue where calculating XIRR with an empty cash flow array returned 10. It now correctly returns 0.

## 1.0.0 / 2024-07-03

### Initial Release

