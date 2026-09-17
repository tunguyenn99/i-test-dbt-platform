# Reusable Jinja / SQL Macros

This directory contains modular Jinja SQL macros designed to enforce DRY (Don't Repeat Yourself) SQL standards across all transformation layers.

## Available Macros

### 1. `clean_text(column_name)`
- **File**: [`clean_text.sql`](clean_text.sql)
- **Purpose**: Strips leading and trailing whitespace from string columns and casts empty strings (`''`) to native SQL `NULL`.
- **Usage Example**:
  ```sql
  {{ clean_text('raw_description') }} as description
  ```

### 2. `count_delimited_values(column_name, delimiter=',')`
- **File**: [`count_delimited_values.sql`](count_delimited_values.sql)
- **Purpose**: Counts the number of comma-separated (or custom delimiter) values in a text column, returning `0` when the column is `NULL` or empty.
- **Usage Example**:
  ```sql
  {{ count_delimited_values('languages') }} as language_count
  ```

### 3. `safe_divide(numerator, denominator)`
- **File**: [`safe_divide.sql`](safe_divide.sql)
- **Purpose**: Performs division returning `NULL` if the denominator is zero or `NULL`, eliminating runtime division-by-zero SQL errors.
- **Usage Example**:
  ```sql
  {{ safe_divide('rated_count', 'total_count') }} as rated_ratio
  ```
