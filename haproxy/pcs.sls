# -*- coding: utf-8 -*-
# vim: ft=sls

#FIXME
{# from "haproxy/map.jinja" import haproxy with context #}

{% set haproxy = salt['pillar.get']('haproxy:lookup:pcs', {}) %}

{% if haproxy.haproxy_cib is defined and haproxy.haproxy_cib %}
haproxy_pcs__cib_created_{{haproxy.haproxy_cib}}:
  pcs.cib_created:
    - cibname: {{haproxy.haproxy_cib}}
{% endif %}

{% if 'resources' in haproxy %}
{% for resource, resource_data in haproxy.resources.items()|sort %}
haproxy_pcs__resource_created_{{resource}}:
  pcs.resource_created:
    - resource_id: {{resource}}
    - resource_type: "{{resource_data.resource_type}}"
    - resource_options: {{resource_data.resource_options|json}}
{% if haproxy.haproxy_cib is defined and haproxy.haproxy_cib %}
    - require:
      - pcs: haproxy_pcs__cib_created_{{haproxy.haproxy_cib}}
    - require_in:
      - pcs: haproxy_pcs__cib_pushed_{{haproxy.haproxy_cib}}
    - cibname: {{haproxy.haproxy_cib}}
{% endif %}
{% endfor %}
{% endif %}

{% if 'constraints' in haproxy %}
{% for constraint, constraint_data in haproxy.constraints.items()|sort %}
haproxy_pcs__constraint_created_{{constraint}}:
  pcs.constraint_created:
    - constraint_id: {{constraint}}
    - constraint_type: "{{constraint_data.constraint_type}}"
    - constraint_options: {{constraint_data.constraint_options|json}}
{% if haproxy.haproxy_cib is defined and haproxy.haproxy_cib %}
    - require:
      - pcs: haproxy_pcs__cib_created_{{haproxy.haproxy_cib}}
    - require_in:
      - pcs: haproxy_pcs__cib_pushed_{{haproxy.haproxy_cib}}
    - cibname: {{haproxy.haproxy_cib}}
{% endif %}
{% endfor %}
{% endif %}

{% if haproxy.haproxy_cib is defined and haproxy.haproxy_cib %}
haproxy_pcs__cib_pushed_{{haproxy.haproxy_cib}}:
  pcs.cib_pushed:
    - cibname: {{haproxy.haproxy_cib}}
{% endif %}
