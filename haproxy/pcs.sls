# -*- coding: utf-8 -*-
# vim: ft=sls

#FIXME
{# from "haproxy/map.jinja" import haproxy with context #}

{% set haproxy = salt['pillar.get']('haproxy', {}) %}

{% if haproxy.resources_extra_cib is defined and haproxy.resources_extra_cib %}
haproxy_pcs__cib_created_{{haproxy.resources_extra_cib}}:
  pcs.cib_created:
    - cibname: {{haproxy.resources_extra_cib}}
{% endif %}

{% for resource, resource_data in haproxy.resources.items()|sort %}
haproxy_pcs__resource_created_{{resource}}:
  pcs.resource_created:
    - resource_id: {{resource}}
    - resource_type: "{{resource_data.resource_type}}"
    - resource_options: {{resource_data.resource_options|json}}
{% if haproxy.resources_extra_cib is defined and haproxy.resources_extra_cib %}
    - require:
      - pcs: haproxy_pcs__cib_created_{{haproxy.resources_extra_cib}}
    - require_in:
      - pcs: haproxy_pcs__cib_pushed_{{haproxy.resources_extra_cib}}
    - cibname: {{haproxy.resources_extra_cib}}
{% endif %}
{% endfor %}

{% if haproxy.resources_extra_cib is defined and haproxy.resources_extra_cib %}
haproxy_pcs__cib_pushed_{{haproxy.resources_extra_cib}}:
  pcs.cib_pushed:
    - cibname: {{haproxy.resources_extra_cib}}
{% endif %}
