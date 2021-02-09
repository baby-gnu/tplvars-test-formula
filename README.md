# Verify the usablity of `tpldir` and `tplroot` for formulas

I see 2 distinct problems with the use of `tpldir` and `tplroot`:

1. how to reference the import `map.jinja` from `.sls` files (see the [blah/blah/blah case](https://github.com/saltstack/salt/issues/41195#issuecomment-577159561))
2. how to reference YAML files used by `map.jinja` within `map.jinja` itself (see the [apache case](https://github.com/saltstack-formulas/apache-formula/issues/295))

# Reference `map.jinja` from `.sls` files

## The ideal

What we would like is being able to import `map.jinja` the same way from any `.sls` files:

```sls
{%- from some_magic_var ~ "/map.jinja" import mapdata %}
```

## The current way of doing it

In the saltstack-formulas community, we encourage:

1. `map.jinja` must be located at the root of the formula directory: `salt://<formula>/map.jinja`
2. compute a `tplroot` variable to have the same import line for every `.sls` files:
   ```sls
   {%- set tplroot = tpldir.split("/")[0] %}
   {%- from tplroot ~ "/map.jinja" import mapdata %}
   ```

## Unsolved problem

If the formula is located deep in a sub directory hierarchy:

- master `file_roots`:
```yaml
  base:
    - /srv/salt
```
- the formula is located in `/srv/salt/a-top-level-directory/a-first-subdirectory/formula-dir/`
- the `map.jinja` must be loaded with static `tplroot`
  ```sls
  {%- set tplroot = "a-top-level-directory/a-first-subdirectory/formula-dir/" %}
  {%- from tplroot ~ "/map.jinja" import mapdata %}
  ```

This render this formula hard to relocate


# Reference YAML files from `map.jinja`

The current state of how to reference `map.jinja` in `.sls` files is with passing the [Jinja2 context](https://jinja.palletsprojects.com/en/2.11.x/templates/#import-context-behavior):

```sls
{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata with context %}
```

The problem is that when using `with context`, the `tpldir` variable in `map.jinja` is equal to the path of the `.sls` file importing it.

This makes impossible for a formula `b` to load variables of a formula `a`, for example `b/test-import-a-map.jinja` could contains something like:

```sls
{%- from "a/map.jinja" import mapdata as a_mapdata with context %}
```

This does not work since the `tplroot` computed by `map.jinja` to load YAML files (`defaults.yaml`, etc.) is equal to `b/` instead of `a/`.

The solution to this issue is simple: never pass context when importing `map.jinja`:

- implicitly since it's the default behaviour:
```sls
{%- from "a/map.jinja" import mapdata as a_mapdata %}
```
- explicitly:
```sls
{%- from "a/map.jinja" import mapdata as a_mapdata without context %}
```

I made [some tests](https://github.com/saltstack-formulas/apache-formula/issues/295#issuecomment-762902071)

`map.jinja` can avoid the use of context by detecting if the `tplfile` does not end with `/map.jinja`:

```jinja
{#- Make sure `map.jinja` is imported without the context #}
{#- Import `with context` override the `tplfile` and `tpldir` variables #}
{%- if not tplfile.endswith("/map.jinja") %}
{{ raise("Import error: map.jinja must be imported without context. tplfile='" ~ tplfile ~ "'") }}
{%- endif %}
```

[More tests](https://github.com/saltstack-formulas/apache-formula/issues/295#issuecomment-769424133) show another thing that should be take care: avoid relative imports like:

```sls
{%- from "../map.jinja" import mapdata %}
```

This can be detected by the following Jinja2 code:

```jinja
{#-
     Relative import can't work, for example:
    `../map.jinja` would try to load `../parameters/defaults.yaml` relatively to the directory of `map.jinja`
    i.e. `salt://<tplroot>/../parameters/defaults.yaml` ⮕ `salt://parameters/defaults.yaml` instead of `salt://<tplroot>/parameters/defaults.yaml`
#}
{%- if not tplfile.startswith("../") %}
{{ raise("Import error: map.jinja must be imported with absolute path. tplfile='" ~ tplfile ~ "'") }}
{%- endif %}
```
