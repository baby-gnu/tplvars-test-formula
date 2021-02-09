{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata %}
{%- from tplroot ~ "/map.jinja" import mapdata as context_mapdata with context %}

from-subcomponent-without-context:
  file.managed:
    - name: /tmp/from-subcomponent-without-context.txt
    - source: salt://tplvars-test/tplvars.txt.jinja
    - template: jinja
    - context:
        mapdata: {{ mapdata | json }}

from-subcomponent-with-context:
  file.managed:
    - name: /tmp/from-subcomponent-with-context.txt
    - source: salt://tplvars-test/tplvars.txt.jinja
    - template: jinja
    - context:
        mapdata: {{ context_mapdata | json }}
