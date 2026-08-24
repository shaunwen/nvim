local ls = require('luasnip')

local snip = ls.s
local node = ls.snippet_node
local text = ls.t
local insert = ls.i
local choice = ls.choice_node
local dynamicn = ls.dynamic_node

local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

local function get_port_snip(args)
  local service_type = args[1] and args[1][1]
  local indent = '      '

  if service_type == 'NodePort' or service_type == 'LoadBalancer' then
    return node(
      nil,
      fmt('- port: {}\n{}targetPort: {}\n{}nodePort: {}', {
        insert(1, '30000'),
        indent,
        insert(2, '80'),
        indent,
        insert(3, '30000'),
      })
    )
  end

  return node(
    nil,
    fmt('- port: {}\n{}targetPort: {}', {
      insert(1, '30000'),
      indent,
      insert(2, '80'),
    })
  )
end

return {
  snip(
    { trig = 'pod', namr = 'k8s Pod', dscr = 'Kubernetes Pod definition' },
    fmt(
      [[
        apiVersion: v1
        kind: Pod
        metadata:
          name: {}
          labels:
            {}: {}
        spec:
          containers:
          - name: {}
            image: {}:{}
            ports:
            - containerPort: {}
      ]],
      {
        insert(1, 'nginx'),
        insert(2, 'run'),
        insert(3, 'nginx'),
        insert(4, 'nginx'),
        insert(5, 'nginx'),
        insert(6, 'latest'),
        insert(7, '80'),
      },
      { dedent = true }
    )
  ),
  snip(
    { trig = 'deploy', namr = 'k8s Deployment', dscr = 'Kubernetes Deployment definition' },
    fmt(
      [[
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          name: {}
          labels:
            {}
        spec:
          replicas: {}
          selector:
            matchLabels:
              {}
          template:
            metadata:
              labels:
                {}
            spec:
              containers:
              - name: {}
                image: {}:{}
                ports:
                - containerPort: {}
      ]],
      {
        insert(1, 'name'),
        insert(2, 'label'),
        insert(3, '1'),
        insert(4, 'label'),
        rep(4),
        insert(5, 'container_name'),
        insert(6, 'image'),
        insert(7, '1.0'),
        insert(8, '80'),
      },
      { dedent = true }
    )
  ),
  snip(
    { trig = 'service', namr = 'k8s Service', dscr = 'Kubernetes Service definition' },
    fmt(
      [[
        apiVersion: v1
        kind: Service
        metadata:
          name: {}
          labels:
            {}
        spec:
          selector:
            {}
          type: {}
          ports:
            {}
      ]],
      {
        insert(1, 'name'),
        insert(2),
        insert(3),
        choice(4, {
          text('ClusterIP'),
          text('NodePort'),
          text('LoadBalancer'),
        }),
        dynamicn(5, get_port_snip, { 4 }),
      },
      { dedent = true }
    )
  ),
}
