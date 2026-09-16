# Macros

Reusable SQL/Jinja helpers used by the model layers:

- `clean_text`: trim blank strings to null.
- `count_delimited_values`: count comma-delimited values such as languages.
- `safe_divide`: return null instead of raising on zero or null denominators.
