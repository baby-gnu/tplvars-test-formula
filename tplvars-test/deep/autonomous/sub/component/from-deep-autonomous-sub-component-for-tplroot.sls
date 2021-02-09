{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata %}
{%- from tplroot ~ "/map.jinja" import mapdata as context_mapdata with context %}

from-deep-autonomous-sub-component-without-context-for-tplroot:
  file.managed:
    - name: /tmp/from-deep-autonomous-sub-component-for-tplroot-without-context.txt
    - source: salt://tplvars-test/tplvars.txt.jinja
    - template: jinja
    - context:
        mapdata: {{ mapdata | json }}

from-deep-autonomous-sub-component-for-tplroot-with-context:
  file.managed:
    - name: /tmp/from-deep-autonomous-sub-component-for-tplroot-with-context.txt
    - source: salt://tplvars-test/tplvars.txt.jinja
    - template: jinja
    - context:
        mapdata: {{ context_mapdata | json }}
