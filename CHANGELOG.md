## 1.0.2

- Fixed: The `find_bracketing_interval` function now supports extremely high rates, improving precision for very high XIRRs (over 1E300%). Dynamic step sizing ensures accurate results even at extreme rates.

## 1.0.1

- Fixed: Resolved an issue where calculating XIRR with an empty cash flow array returned 10. It now correctly returns 0.

## 1.0.0 / 2024-07-03

### Initial Release

