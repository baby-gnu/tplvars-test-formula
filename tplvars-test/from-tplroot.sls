{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata %}
{%- from tplroot ~ "/map.jinja" import mapdata as context_mapdata with context %}

from-tplroot-without-context:
  file.managed:
    - name: /tmp/from-tplroot-without-context.txt
    - source: salt://tplvars-test/tplvars.txt.jinja
    - template: jinja
    - context:
        mapdata: {{ mapdata | json }}

from-tplroot-with-context:
  file.managed:
    - name: /tmp/from-tplroot-with-context.txt
    - source: salt://tplvars-test/tplvars.txt.jinja
    - template: jinja
    - context:
        mapdata: {{ context_mapdata | json }}
