#!jinja|yaml
{% set node_ids = salt['pillar.get']('haproxy:lookup:pcs:node_ids') -%}
{% set admin_node_id = salt['pillar.get']('haproxy:lookup:pcs:admin_node_id') -%}

# node_ids: {{node_ids|json}}
# admin_node_id: {{admin_node_id}}

haproxy_orchestration__install:
  salt.state:
    - tgt: {{node_ids|json}}
    - tgt_type: list
    - expect_minions: True
    - sls: haproxy

haproxy_orchestration__pcs:
  salt.state:
    - tgt: {{admin_node_id}}
    - expect_minions: True
    - sls: haproxy.pcs
    - require:
      - salt: haproxy_orchestration__install
