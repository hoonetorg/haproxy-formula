haproxy.service:
  service.{{salt['pillar.get']('haproxy:service_state', 'running')}}:
    - name: haproxy
{% if salt['pillar.get']('haproxy:service_state', 'running') in [ 'running', 'dead' ] %}
    - enable: {{salt['pillar.get']('haproxy:enable', True)}}
    - reload: {{salt['pillar.get']('haproxy:service_reload', True)}}
{% endif %}
    - require:
      - pkg: haproxy
{% if salt['grains.get']('os_family') == 'Debian' %}
      - file: haproxy.service
{% endif %}
{% if salt['grains.get']('os_family') == 'Debian' %}
  file.replace:
    - name: /etc/default/haproxy
{% if salt['pillar.get']('haproxy:enabled', True) %}
    - pattern: ^\s*ENABLED\s*=\s*.*$
    - repl: ENABLED=1
{% else %}
    - pattern: ^\s*ENABLED\s*=\s*.*$
    - repl: ENABLED=0
{% endif %}
    - show_changes: True
{% endif %}
