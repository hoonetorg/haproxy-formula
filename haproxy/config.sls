haproxy.config:
 file.managed:
   - name: {{ salt['pillar.get']('haproxy:config_file_path', '/etc/haproxy/haproxy.cfg') }}
   - source: salt://haproxy/templates/haproxy.jinja
   - template: jinja
   - user: root
   - group: root
   - mode: 644
{% if salt['pillar.get']('haproxy:service_state', 'running') in [ 'running', 'dead' ] %}
   - require_in:
     - service: haproxy.service
   - watch_in:
     - service: haproxy.service
{% endif %}
