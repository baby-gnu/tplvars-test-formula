{%- from tpldir ~ "/map.jinja" import mapdata %}
{%- from tpldir ~ "/map.jinja" import mapdata as context_mapdata with context %}

from-deep-autonomous-sub-component-without-context:
  file.managed:
    - name: /tmp/from-deep-autonomous-sub-component-without-context.txt
    - source: salt://tplvars-test/tplvars.txt.jinja
    - template: jinja
    - context:
        mapdata: {{ mapdata | json }}

from-deep-autonomous-sub-component-with-context:
  file.managed:
    - name: /tmp/from-deep-autonomous-sub-component-with-context.txt
    - source: salt://tplvars-test/tplvars.txt.jinja
    - template: jinja
    - context:
        mapdata: {{ context_mapdata | json }}
