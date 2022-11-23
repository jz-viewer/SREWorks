apiVersion: core.oam.dev/v1alpha2
kind: ApplicationConfiguration
metadata:
  annotations:
    appId: dataops
    clusterId: master
    namespaceId: ${NAMESPACE_ID}
    stageId: prod
  name: dataops
spec:
  components:
  - dependencies:
    - component: RESOURCE_ADDON|system-env@system-env
    parameterValues:
    - name: values
      toFieldPaths:
      - spec.values
      value:
        global:
          storageClass: '{{ Global.STORAGE_CLASS }}'
        image:
          registry: sreworks-registry.cn-beijing.cr.aliyuncs.com
          repository: hub/kafka
        persistence:
          size: 20Gi
        zookeeper:
          image:
            registry: sreworks-registry.cn-beijing.cr.aliyuncs.com
            repository: hub/zookeeper
          persistence:
            size: 20Gi
    - name: name
      toFieldPaths:
      - spec.name
      value: '{{ Global.STAGE_ID }}-dataops-kafka'
    revisionName: HELM|kafka|_
    scopes:
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Cluster
        name: '{{ Global.CLUSTER_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Namespace
        name: '{{ Global.NAMESPACE_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Stage
        name: '{{ Global.STAGE_ID }}'
    traits: []
  - dependencies:
    - component: RESOURCE_ADDON|system-env@system-env
    parameterValues:
    - name: values
      toFieldPaths:
      - spec.values
      value:
        clusterController:
          enabled: false
          image: sreworks-registry.cn-beijing.cr.aliyuncs.com/mirror/kubecost1/cluster-controller
          imagePullPolicy: Always
          tag: v0.0.2
        global:
          grafana:
            domainName: prod-dataops-grafana.sreworks-dataops
            enabled: false
            proxy: false
          notifications:
            alertmanager:
              enabled: false
              fqdn: http://{{ Global.DATA_PROM_HOST}}:{{ Global.DATA_PROM_PORT }}
          prometheus:
            enabled: false
            fqdn: http://{{ Global.DATA_PROM_HOST}}:{{ Global.DATA_PROM_PORT }}
          thanos:
            enabled: false
        grafana:
          grafana.ini:
            server:
              root_url: '%(protocol)s://%(domain)s:%(http_port)s/grafana'
          sidecar:
            dashboards:
              enabled: true
              label: kubecost_grafana_dashboard
            datasources:
              enabled: false
        ingress:
          annotations: null
          className: nginx
          enabled: false
          hosts:
          - kubecost-cost-analyzer.c38cca9c474484bdc9873f44f733d8bcd.cn-beijing.alicontainer.com
          pathType: ImplementationSpecific
          paths:
          - /
          tls: []
        kubecost:
          disableServer: false
          image: sreworks-registry.cn-beijing.cr.aliyuncs.com/mirror/kubecost1/server
          resources:
            requests:
              cpu: 100m
              memory: 55Mi
        kubecostDeployment:
          replicas: 1
        kubecostFrontend:
          image: sreworks-registry.cn-beijing.cr.aliyuncs.com/mirror/kubecost1/frontend
          imagePullPolicy: Always
          resources:
            requests:
              cpu: 10m
              memory: 55Mi
        kubecostModel:
          image: sreworks-registry.cn-beijing.cr.aliyuncs.com/mirror/kubecost1/cost-model
          imagePullPolicy: Always
          resources:
            requests:
              cpu: 200m
              memory: 55Mi
        kubecostProductConfigs:
          clusterName: cluster123
          currencyCode: CNY
        kubecostToken: MzEyMTg5Mzk3QHFxLmNvbQ==xm343yadf98
        networkCosts:
          enabled: false
          image: sreworks-registry.cn-beijing.cr.aliyuncs.com/mirror/kubecost1/kubecost-network-costs
          imagePullPolicy: Always
          podSecurityPolicy:
            enabled: false
          port: 3001
          prometheusScrape: false
          resources: {}
          tag: v15.7
          trafficLogging: true
        persistentVolume:
          accessModes:
          - ReadWriteOnce
          dbSize: 100.0Gi
          enabled: true
          size: 100Gi
          storageClass: '{{ Global.STORAGE_CLASS }}'
        prometheus:
          alertmanager:
            enabled: false
            persistentVolume:
              enabled: true
          kube-state-metrics:
            disabled: false
            image:
              pullPolicy: Always
              repository: sreworks-registry.cn-beijing.cr.aliyuncs.com/mirror/kube-state-metrics
              tag: v1.9.8
          nodeExporter:
            enabled: true
            service:
              annotations:
                prometheus.io/scrape: 'true'
              clusterIP: None
              hostPort: 9010
              servicePort: 9010
              type: ClusterIP
          pushgateway:
            enabled: false
            persistentVolume:
              enabled: true
          server:
            extraArgs:
              query.max-concurrency: 1
              query.max-samples: 100000000
            global:
              evaluation_interval: 1m
              external_labels:
                cluster_id: cluster123
              scrape_interval: 1m
              scrape_timeout: 10s
            persistentVolume:
              accessModes:
              - ReadWriteOnce
              enabled: true
              size: 100Gi
              storageClass: '{{ Global.STORAGE_CLASS }}'
            resources: {}
            tolerations: []
        service:
          annotations: {}
          labels: {}
          port: 9090
          targetPort: 9090
          type: ClusterIP
    - name: name
      toFieldPaths:
      - spec.name
      value: '{{ Global.STAGE_ID }}-dataops-kubecost'
    revisionName: HELM|kubecost|_
    scopes:
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Cluster
        name: '{{ Global.CLUSTER_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Namespace
        name: '{{ Global.NAMESPACE_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Stage
        name: '{{ Global.STAGE_ID }}'
    traits: []
  - dependencies:
    - component: RESOURCE_ADDON|system-env@system-env
    parameterValues:
    - name: values
      toFieldPaths:
      - spec.values
      value:
        alertmanager:
          enabled: false
        configmapReload:
          alertmanager:
            enabled: false
          prometheus:
            enabled: false
        kubeStateMetrics:
          enabled: false
        nodeExporter:
          enabled: false
        podSecurityPolicy:
          enabled: false
        pushgateway:
          enabled: false
        rbac:
          create: true
        server:
          enabled: true
          persistentVolume:
            accessModes:
            - ReadWriteOnce
            enabled: true
            existingClaim: ''
            mountPath: /data
            size: 20Gi
            storageClass: '{{ Global.STORAGE_CLASS }}'
        serverFiles:
          prometheus.yml:
            rule_files:
            - /etc/config/recording_rules.yml
            - /etc/config/alerting_rules.yml
            scrape_configs:
            - job_name: prometheus
              static_configs:
              - targets:
                - localhost:9090
            - job_name: kubernetes-pods
              kubernetes_sd_configs:
              - role: pod
              relabel_configs:
              - action: keep
                regex: true
                source_labels:
                - __meta_kubernetes_pod_annotation_prometheus_io_scrape
              - action: replace
                regex: (.+)
                source_labels:
                - __meta_kubernetes_pod_annotation_prometheus_io_path
                target_label: __metrics_path__
              - action: replace
                regex: ([^:]+)(?::\d+)?;(\d+)
                replacement: $1:$2
                source_labels:
                - __address__
                - __meta_kubernetes_pod_annotation_prometheus_io_port
                target_label: __address__
              - action: labelmap
                regex: __meta_kubernetes_pod_label_(.+)
              - action: replace
                source_labels:
                - __meta_kubernetes_namespace
                target_label: kubernetes_namespace
              - action: replace
                source_labels:
                - __meta_kubernetes_pod_name
                target_label: kubernetes_pod_name
            - bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
              job_name: kubernetes-nodes-cadvisor
              kubernetes_sd_configs:
              - role: node
              metric_relabel_configs:
              - action: keep
                regex: (container_cpu_usage_seconds_total|container_memory_working_set_bytes|container_network_receive_errors_total|container_network_transmit_errors_total|container_network_receive_packets_dropped_total|container_network_transmit_packets_dropped_total|container_memory_usage_bytes|container_cpu_cfs_throttled_periods_total|container_cpu_cfs_periods_total|container_fs_usage_bytes|container_fs_limit_bytes|container_cpu_cfs_periods_total|container_fs_inodes_free|container_fs_inodes_total|container_fs_usage_bytes|container_fs_limit_bytes|container_cpu_cfs_throttled_periods_total|container_cpu_cfs_periods_total|container_network_receive_bytes_total|container_network_transmit_bytes_total|container_fs_inodes_free|container_fs_inodes_total|container_fs_usage_bytes|container_fs_limit_bytes|container_spec_cpu_shares|container_spec_memory_limit_bytes|container_network_receive_bytes_total|container_network_transmit_bytes_total|container_fs_reads_bytes_total|container_network_receive_bytes_total|container_fs_writes_bytes_total|container_fs_reads_bytes_total|cadvisor_version_info)
                source_labels:
                - __name__
              - action: replace
                regex: (.+)
                source_labels:
                - container
                target_label: container_name
              - action: replace
                regex: (.+)
                source_labels:
                - pod
                target_label: pod_name
              relabel_configs:
              - action: labelmap
                regex: __meta_kubernetes_node_label_(.+)
              - replacement: kubernetes.default.svc:443
                target_label: __address__
              - regex: (.+)
                replacement: /api/v1/nodes/$1/proxy/metrics/cadvisor
                source_labels:
                - __meta_kubernetes_node_name
                target_label: __metrics_path__
              scheme: https
              tls_config:
                ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
                insecure_skip_verify: true
            - job_name: kubernetes-service-endpoints
              kubernetes_sd_configs:
              - role: endpoints
              metric_relabel_configs:
              - action: keep
                regex: (container_gpu_allocation|container_cpu_allocation|container_cpu_usage_seconds_total|container_fs_limit_bytes|container_memory_allocation_bytes|container_memory_usage_bytes|container_memory_working_set_bytes|container_network_receive_bytes_total|container_network_transmit_bytes_total|deployment_match_labels|kube_deployment_spec_replicas|kube_deployment_status_replicas_available|kube_job_status_failed|kube_namespace_annotations|kube_namespace_labels|kube_node_info|kube_node_labels|kube_node_status_capacity|kube_node_status_capacity_cpu_cores|kube_node_status_capacity_memory_bytes|kube_node_status_condition|kube_persistentvolume_capacity_bytes|kube_persistentvolume_status_phase|kube_persistentvolumeclaim_info|kube_persistentvolumeclaim_resource_requests_storage_bytes|kube_persistentvolumeclaim_resource_requests_storage_bytes|container_memory_allocation_bytes|kube_pod_container_resource_limits|kube_pod_container_resource_limits_cpu_cores|kube_pod_container_resource_limits_memory_bytes|kube_pod_container_resource_requests_cpu_cores|kube_pod_container_resource_requests_cpu_cores|container_cpu_usage_seconds_total|kube_pod_container_resource_requests_memory_bytes|kube_pod_container_resource_requests_memory_bytes|kube_pod_container_resource_requests|kube_pod_container_status_restarts_total|kube_pod_container_status_running|kube_pod_container_status_terminated_reason|kube_pod_labels|kube_pod_owner|kube_pod_status_phase|kubecost_cluster_memory_working_set_bytes|kubecost_pod_network_egress_bytes_total|node_cpu_hourly_cost|node_cpu_seconds_total|node_disk_reads_completed|node_disk_reads_completed_total|node_disk_writes_completed|node_disk_writes_completed_total|node_filesystem_device_error|node_gpu_hourly_cost|node_memory_Buffers_bytes|node_memory_Cached_bytes|node_memory_MemAvailable_bytes|node_memory_MemFree_bytes|node_memory_MemTotal_bytes|node_network_transmit_bytes_total|node_ram_hourly_cost|pod_pvc_allocation|pv_hourly_cost|service_selector_labels|statefulSet_match_labels|up|kube_node_status_allocatable|kube_node_status_allocatable_cpu_cores|kube_node_status_allocatable_memory_bytes|container_fs_writes_bytes_total|kube_deployment_status_replicas|kube_statefulset_replicas|kube_daemonset_status_desired_number_scheduled|kube_deployment_status_replicas_available|kube_statefulset_status_replicas|kube_daemonset_status_number_ready|kube_deployment_status_replicas|kube_statefulset_replicas|kube_daemonset_status_desired_number_scheduled|kube_replicaset_owner|kube_pod_container_info|DCGM_FI_DEV_GPU_UTIL)
                source_labels:
                - __name__
              relabel_configs:
              - action: keep
                regex: true
                source_labels:
                - __meta_kubernetes_service_annotation_prometheus_io_scrape
              - action: replace
                regex: (https?)
                source_labels:
                - __meta_kubernetes_service_annotation_prometheus_io_scheme
                target_label: __scheme__
              - action: replace
                regex: (.+)
                source_labels:
                - __meta_kubernetes_service_annotation_prometheus_io_path
                target_label: __metrics_path__
              - action: replace
                regex: ([^:]+)(?::\d+)?;(\d+)
                replacement: $1:$2
                source_labels:
                - __address__
                - __meta_kubernetes_service_annotation_prometheus_io_port
                target_label: __address__
              - action: labelmap
                regex: __meta_kubernetes_service_label_(.+)
              - action: replace
                source_labels:
                - __meta_kubernetes_namespace
                target_label: kubernetes_namespace
              - action: replace
                source_labels:
                - __meta_kubernetes_service_name
                target_label: kubernetes_name
              - action: replace
                source_labels:
                - __meta_kubernetes_pod_node_name
                target_label: kubernetes_node
            - job_name: kubernetes-service-endpoints-slow
              kubernetes_sd_configs:
              - role: endpoints
              relabel_configs:
              - action: keep
                regex: true
                source_labels:
                - __meta_kubernetes_service_annotation_prometheus_io_scrape_slow
              - action: replace
                regex: (https?)
                source_labels:
                - __meta_kubernetes_service_annotation_prometheus_io_scheme
                target_label: __scheme__
              - action: replace
                regex: (.+)
                source_labels:
                - __meta_kubernetes_service_annotation_prometheus_io_path
                target_label: __metrics_path__
              - action: replace
                regex: ([^:]+)(?::\d+)?;(\d+)
                replacement: $1:$2
                source_labels:
                - __address__
                - __meta_kubernetes_service_annotation_prometheus_io_port
                target_label: __address__
              - action: labelmap
                regex: __meta_kubernetes_service_label_(.+)
              - action: replace
                source_labels:
                - __meta_kubernetes_namespace
                target_label: kubernetes_namespace
              - action: replace
                source_labels:
                - __meta_kubernetes_service_name
                target_label: kubernetes_name
              - action: replace
                source_labels:
                - __meta_kubernetes_pod_node_name
                target_label: kubernetes_node
              scrape_interval: 5m
              scrape_timeout: 30s
            - honor_labels: true
              job_name: prometheus-pushgateway
              kubernetes_sd_configs:
              - role: service
              relabel_configs:
              - action: keep
                regex: pushgateway
                source_labels:
                - __meta_kubernetes_service_annotation_prometheus_io_probe
            - job_name: kubernetes-services
              kubernetes_sd_configs:
              - role: service
              metrics_path: /probe
              params:
                module:
                - http_2xx
              relabel_configs:
              - action: keep
                regex: true
                source_labels:
                - __meta_kubernetes_service_annotation_prometheus_io_probe
              - source_labels:
                - __address__
                target_label: __param_target
              - replacement: blackbox
                target_label: __address__
              - source_labels:
                - __param_target
                target_label: instance
              - action: labelmap
                regex: __meta_kubernetes_service_label_(.+)
              - source_labels:
                - __meta_kubernetes_namespace
                target_label: kubernetes_namespace
              - source_labels:
                - __meta_kubernetes_service_name
                target_label: kubernetes_name
            - dns_sd_configs:
              - names:
                - prod-dataops-kubecost-cost-analyzer
                port: 9003
                type: A
              honor_labels: true
              job_name: kubecost
              metrics_path: /metrics
              scheme: http
              scrape_interval: 1m
              scrape_timeout: 10s
            - job_name: kubecost-networking
              kubernetes_sd_configs:
              - role: pod
              relabel_configs:
              - action: keep
                regex: prod-dataops-kubecost-network-costs
                source_labels:
                - __meta_kubernetes_pod_label_app
          recording_rules.yml:
            groups:
            - name: CPU
              rules:
              - expr: sum(rate(container_cpu_usage_seconds_total{container_name!=""}[5m]))
                record: cluster:cpu_usage:rate5m
              - expr: rate(container_cpu_usage_seconds_total{container_name!=""}[5m])
                record: cluster:cpu_usage_nosum:rate5m
              - expr: avg(irate(container_cpu_usage_seconds_total{container_name!="POD", container_name!=""}[5m])) by (container_name,pod_name,namespace)
                record: kubecost_container_cpu_usage_irate
              - expr: sum(container_memory_working_set_bytes{container_name!="POD",container_name!=""}) by (container_name,pod_name,namespace)
                record: kubecost_container_memory_working_set_bytes
              - expr: sum(container_memory_working_set_bytes{container_name!="POD",container_name!=""})
                record: kubecost_cluster_memory_working_set_bytes
            - name: Savings
              rules:
              - expr: sum(avg(kube_pod_owner{owner_kind!="DaemonSet"}) by (pod) * sum(container_cpu_allocation) by (pod))
                labels:
                  daemonset: 'false'
                record: kubecost_savings_cpu_allocation
              - expr: sum(avg(kube_pod_owner{owner_kind="DaemonSet"}) by (pod) * sum(container_cpu_allocation) by (pod)) / sum(kube_node_info)
                labels:
                  daemonset: 'true'
                record: kubecost_savings_cpu_allocation
              - expr: sum(avg(kube_pod_owner{owner_kind!="DaemonSet"}) by (pod) * sum(container_memory_allocation_bytes) by (pod))
                labels:
                  daemonset: 'false'
                record: kubecost_savings_memory_allocation_bytes
              - expr: sum(avg(kube_pod_owner{owner_kind="DaemonSet"}) by (pod) * sum(container_memory_allocation_bytes) by (pod)) / sum(kube_node_info)
                labels:
                  daemonset: 'true'
                record: kubecost_savings_memory_allocation_bytes
              - expr: label_replace(sum(kube_pod_status_phase{phase="Running",namespace!="kube-system"} > 0) by (pod, namespace), "pod_name", "$1", "pod", "(.+)")
                record: kubecost_savings_running_pods
              - expr: sum(rate(container_cpu_usage_seconds_total{container_name!="",container_name!="POD",instance!=""}[5m])) by (namespace, pod_name, container_name, instance)
                record: kubecost_savings_container_cpu_usage_seconds
              - expr: sum(container_memory_working_set_bytes{container_name!="",container_name!="POD",instance!=""}) by (namespace, pod_name, container_name, instance)
                record: kubecost_savings_container_memory_usage_bytes
              - expr: avg(sum(kube_pod_container_resource_requests{resource="cpu", unit="core", namespace!="kube-system"}) by (pod, namespace, instance)) by (pod, namespace)
                record: kubecost_savings_pod_requests_cpu_cores
              - expr: avg(sum(kube_pod_container_resource_requests{resource="memory", unit="byte", namespace!="kube-system"}) by (pod, namespace, instance)) by (pod, namespace)
                record: kubecost_savings_pod_requests_memory_bytes
        serviceAccounts:
          alertmanager:
            annotations: {}
            create: true
            name: null
          nodeExporter:
            annotations: {}
            create: true
            name: null
          pushgateway:
            annotations: {}
            create: true
            name: null
          server:
            annotations: {}
            create: true
            name: null
    - name: name
      toFieldPaths:
      - spec.name
      value: '{{ Global.STAGE_ID }}-dataops-prometheus'
    revisionName: HELM|prometheus|_
    scopes:
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Cluster
        name: '{{ Global.CLUSTER_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Namespace
        name: '{{ Global.NAMESPACE_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Stage
        name: '{{ Global.STAGE_ID }}'
    traits: []
  - dependencies:
    - component: RESOURCE_ADDON|system-env@system-env
    parameterValues:
    - name: values
      toFieldPaths:
      - spec.values
      value:
        clusterHealthCheckEnable: false
        clusterName: '{{ Global.STAGE_ID }}-dataops-elasticsearch'
        esConfig:
          elasticsearch.yml: 'xpack.security.enabled: true

            discovery.type: single-node

            path.data: /usr/share/elasticsearch/data

            '
        extraEnvs:
        - name: cluster.initial_master_nodes
          value: ''
        - name: ELASTIC_PASSWORD
          value: '{{ Global.DATA_ES_PASSWORD }}'
        - name: ELASTIC_USERNAME
          value: '{{ Global.DATA_ES_USER }}'
        image: sreworks-registry.cn-beijing.cr.aliyuncs.com/mirror/elasticsearch
        imageTag: 7.10.2-with-plugins
        minimumMasterNodes: 1
        replicas: 1
        volumeClaimTemplate:
          accessModes:
          - ReadWriteOnce
          resources:
            requests:
              storage: 100Gi
          storageClassName: '{{ Global.STORAGE_CLASS }}'
    - name: name
      toFieldPaths:
      - spec.name
      value: '{{ Global.STAGE_ID }}-dataops-elasticsearch'
    revisionName: HELM|elasticsearch|_
    scopes:
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Cluster
        name: '{{ Global.CLUSTER_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Namespace
        name: '{{ Global.NAMESPACE_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Stage
        name: '{{ Global.STAGE_ID }}'
    traits: []
  - dependencies:
    - component: RESOURCE_ADDON|system-env@system-env
    parameterValues:
    - name: values
      toFieldPaths:
      - spec.values
      value:
        extraEnvs:
        - name: NODE_NAME
          valueFrom:
            fieldRef:
              fieldPath: spec.nodeName
        filebeatConfig:
          filebeat.yml: "filebeat.autodiscover:\n  providers:\n    - type: kubernetes\n      node: ${NODE_NAME}\n      resource: pod\n      scope: node\n      templates:\n        - condition:\n            equals:\n              kubernetes.labels.sreworks-telemetry-log: enable\n          config:\n            - type: container\n              paths:\n                - /var/log/containers/*${data.kubernetes.container.id}.log\n              multiline:\n                type: pattern\n                pattern: '^(\\[)?20\\d{2}-(1[0-2]|0?[1-9])-(0?[1-9]|[1-2]\\d|30|31)'\n                negate: true\n                match: after\n              processors:\n                - add_kubernetes_metadata:\n                    host: ${NODE_NAME}\n                    matchers:\n                    - logs_path:\n                        logs_path: \"/var/log/containers/\"\n\nsetup.ilm.enabled: auto\nsetup.ilm.rollover_alias: \"filebeat\"\nsetup.ilm.pattern: \"{now/d}-000001\"\nsetup.template.name: \"filebeat\"\nsetup.template.pattern: \"filebeat-*\"\n\noutput.elasticsearch:\n  hosts: '{{ Global.DATA_ES_HOST }}:{{ Global.DATA_ES_PORT }}'\n  index: \"filebeat-%{+yyyy.MM.dd}\"\n  username: \"{{ Global.DATA_ES_USER }}\"\n  password: \"{{ Global.DATA_ES_PASSWORD }}\""
        hostNetworking: true
        image: sreworks-registry.cn-beijing.cr.aliyuncs.com/mirror/filebeat
        imageTag: 7.10.2
        labels:
          k8s-app: filebeat
        podAnnotations:
          name: filebeat
    - name: name
      toFieldPaths:
      - spec.name
      value: '{{ Global.STAGE_ID }}-dataops-filebeat'
    revisionName: HELM|filebeat|_
    scopes:
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Cluster
        name: '{{ Global.CLUSTER_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Namespace
        name: '{{ Global.NAMESPACE_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Stage
        name: '{{ Global.STAGE_ID }}'
    traits: []
  - dependencies:
    - component: RESOURCE_ADDON|system-env@system-env
    parameterValues:
    - name: values
      toFieldPaths:
      - spec.values
      value:
        adminPassword: sreworks123456
        adminUser: admin
        dashboardProviders:
          dashboardproviders.yaml:
            apiVersion: 1
            providers:
            - disableDeletion: false
              editable: true
              folder: sreworks-dataops
              name: flink
              options:
                path: /var/lib/grafana/dashboards/flink
              orgId: 1
              type: file
            - disableDeletion: false
              editable: true
              folder: sreworks-dataops
              name: cost
              options:
                path: /var/lib/grafana/dashboards/cost
              orgId: 1
              type: file
        dashboards:
          cost:
            cost-dashboard:
              file: dashboards/cost-dashboard.json
          flink:
            flink-dashboard:
              file: dashboards/flink-dashboard.json
        datasources:
          datasources.yaml:
            apiVersion: 1
            datasources:
            - access: proxy
              basicAuth: true
              basicAuthPassword: '{{ Global.DATA_ES_PASSWORD }}'
              basicAuthUser: '{{ Global.DATA_ES_USER }}'
              database: '[metricbeat]*'
              isDefault: true
              jsonData:
                esVersion: 70
                interval: Yearly
                timeField: '@timestamp'
              name: elasticsearch-metricbeat
              type: elasticsearch
              url: http://{{ Global.DATA_ES_HOST }}:{{ Global.DATA_ES_PORT }}
            - access: proxy
              basicAuth: true
              basicAuthPassword: '{{ Global.DATA_ES_PASSWORD }}'
              basicAuthUser: '{{ Global.DATA_ES_USER }}'
              database: '[filebeat]*'
              isDefault: false
              jsonData:
                esVersion: 70
                interval: Yearly
                logLevelField: fields.level
                logMessageField: message
                timeField: '@timestamp'
              name: elasticsearch-filebeat
              type: elasticsearch
              url: http://{{ Global.DATA_ES_HOST }}:{{ Global.DATA_ES_PORT }}
            - access: proxy
              httpMethod: POST
              name: dataops-prometheus
              type: prometheus
              url: http://{{ Global.DATA_PROM_HOST}}:{{ Global.DATA_PROM_PORT }}
            - access: proxy
              httpMethod: POST
              name: prometheus-cluster-default
              type: prometheus
              url: http://{{ Global.DATA_PROM_HOST}}:{{ Global.DATA_PROM_PORT }}
            - access: proxy
              isDefault: false
              name: dataset
              type: marcusolsson-json-datasource
              url: http://{{ Global.STAGE_ID }}-{{ Global.APP_ID }}-dataset.{{ Global.NAMESPACE_ID }}
        grafana.ini:
          auth.anonymous:
            enabled: false
          auth.basic:
            enabled: false
          auth.proxy:
            auto_sign_up: true
            enable_login_token: false
            enabled: true
            header_name: x-auth-user
            headers: Name:x-auth-user Email:x-auth-email-addr
            ldap_sync_ttl: 60
            sync_ttl: 60
          security:
            allow_embedding: true
          server:
            root_url: /gateway/dataops-grafana/
            serve_from_sub_path: true
        image:
          repository: sreworks-registry.cn-beijing.cr.aliyuncs.com/mirror/grafana
          tag: 7.5.3
        plugins:
        - marcusolsson-json-datasource
    - name: name
      toFieldPaths:
      - spec.name
      value: '{{ Global.STAGE_ID }}-dataops-grafana'
    revisionName: HELM|grafana|_
    scopes:
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Cluster
        name: '{{ Global.CLUSTER_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Namespace
        name: '{{ Global.NAMESPACE_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Stage
        name: '{{ Global.STAGE_ID }}'
    traits: []
  - dependencies:
    - component: RESOURCE_ADDON|system-env@system-env
    parameterValues:
    - name: values
      toFieldPaths:
      - spec.values
      value:
        elasticsearchHosts: http://{{ Global.DATA_ES_HOST }}:{{ Global.DATA_ES_PORT }}
        image: sreworks-registry.cn-beijing.cr.aliyuncs.com/mirror/kibana
        ingress:
          enabled: false
        kibanaConfig:
          kibana.yml: 'elasticsearch.username: {{ Global.DATA_ES_USER }}

            elasticsearch.password: {{ Global.DATA_ES_PASSWORD }}'
        resources:
          limits:
            cpu: 300m
            memory: 512Mi
          requests:
            cpu: 200m
            memory: 512Mi
    - name: name
      toFieldPaths:
      - spec.name
      value: '{{ Global.STAGE_ID }}-dataops-kibana'
    revisionName: HELM|kibana|_
    scopes:
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Cluster
        name: '{{ Global.CLUSTER_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Namespace
        name: '{{ Global.NAMESPACE_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Stage
        name: '{{ Global.STAGE_ID }}'
    traits: []
  - dependencies:
    - component: RESOURCE_ADDON|system-env@system-env
    parameterValues:
    - name: values
      toFieldPaths:
      - spec.values
      value:
        clusterRoleRules:
        - apiGroups:
          - ''
          resources:
          - nodes
          - namespaces
          - events
          - pods
          verbs:
          - get
          - list
          - watch
        - apiGroups:
          - extensions
          resources:
          - replicasets
          verbs:
          - get
          - list
          - watch
        - apiGroups:
          - apps
          resources:
          - statefulsets
          - deployments
          - replicasets
          verbs:
          - get
          - list
          - watch
        - apiGroups:
          - ''
          resources:
          - nodes/stats
          - nodes
          - services
          - endpoints
          - pods
          verbs:
          - get
          - list
          - watch
        - nonResourceURLs:
          - /metrics
          verbs:
          - get
        - apiGroups:
          - coordination.k8s.io
          resources:
          - leases
          verbs:
          - '*'
        daemonset:
          annotations:
            name: metricbeat
          enabled: true
          extraEnvs:
          - name: ELASTICSEARCH_HOSTS
            value: '{{ Global.STAGE_ID }}-dataops-elasticsearch-master.{{ Global.NAMESPACE_ID }}.svc.cluster.local'
          - name: NODE_NAME
            valueFrom:
              fieldRef:
                fieldPath: spec.nodeName
          - name: NODE_IP
            valueFrom:
              fieldRef:
                fieldPath: status.hostIP
          hostNetworking: true
          labels:
            k8s-app: metricbeat
          metricbeatConfig:
            metricbeat.yml: "metricbeat.modules:\n- module: prometheus\n  period: 1m\n  hosts: [\"{{ Global.DATA_PROM_HOST}}:{{ Global.DATA_PROM_PORT }}\"]\n  metricsets: [\"query\"]\n  queries:\n  - name: \"pod_ram_gb_hours_allocation\"\n    path: \"/api/v1/query\"\n    params:\n      query: 'avg(avg_over_time(container_memory_allocation_bytes{container!=\"\", container!=\"POD\", node!=\"\"}[1h])) by (pod, namespace, node) / 1024 / 1024 / 1024 + on(pod, namespace) group_left(label_labels_appmanager_oam_dev_appInstanceId, label_labels_appmanager_oam_dev_appId, label_labels_appmanager_oam_dev_appInstanceName, label_labels_appmanager_oam_dev_clusterId, label_labels_appmanager_oam_dev_componentName, label_labels_appmanager_oam_dev_stageId)(0 * kube_pod_labels{uid!=\"\",label_labels_appmanager_oam_dev_appInstanceId!=\"\"})'\n  - name: \"pod_ram_gb_hours_usage_avg\"\n    path: \"/api/v1/query\"\n    params:\n      query: 'avg(avg_over_time(container_memory_working_set_bytes{container!=\"\", container_name!=\"POD\", container!=\"POD\"}[1h])) by (pod, namespace) / 1024 / 1024 / 1024 + on(pod, namespace) group_left(label_labels_appmanager_oam_dev_appInstanceId, label_labels_appmanager_oam_dev_appId, label_labels_appmanager_oam_dev_appInstanceName, label_labels_appmanager_oam_dev_clusterId, label_labels_appmanager_oam_dev_componentName, label_labels_appmanager_oam_dev_stageId)(0 * kube_pod_labels{uid!=\"\",label_labels_appmanager_oam_dev_appInstanceId!=\"\"})'\n  - name: \"pod_cpu_core_hours_allocation\"\n    path: \"/api/v1/query\"\n    params:\n      query: 'avg(avg_over_time(container_cpu_allocation{container!=\"\", container!=\"POD\", node!=\"\"}[1h])) by (pod, namespace, node) + on(pod, namespace) group_left(label_labels_appmanager_oam_dev_appInstanceId, label_labels_appmanager_oam_dev_appId, label_labels_appmanager_oam_dev_appInstanceName, label_labels_appmanager_oam_dev_clusterId, label_labels_appmanager_oam_dev_componentName, label_labels_appmanager_oam_dev_stageId)(0 * kube_pod_labels{uid!=\"\",label_labels_appmanager_oam_dev_appInstanceId!=\"\"})'\n  - name: \"pod_cpu_core_hours_usage_avg\"\n    path: \"/api/v1/query\"\n    params:\n      query: 'avg(rate(container_cpu_usage_seconds_total{container!=\"\", container_name!=\"POD\", container!=\"POD\"}[1h])) by (pod, namespace) + on(pod, namespace) group_left(label_labels_appmanager_oam_dev_appInstanceId, label_labels_appmanager_oam_dev_appId, label_labels_appmanager_oam_dev_appInstanceName, label_labels_appmanager_oam_dev_clusterId, label_labels_appmanager_oam_dev_componentName, label_labels_appmanager_oam_dev_stageId)(0 * kube_pod_labels{uid!=\"\",label_labels_appmanager_oam_dev_appInstanceId!=\"\"})'\n  - name: \"pod_pvc_gb_hours_allocation\"\n    path: \"/api/v1/query\"\n    params:\n      query: 'avg(avg_over_time(pod_pvc_allocation[1h])) by (pod, namespace) / 1024 / 1024 / 1024 + on(pod, namespace) group_left(label_labels_appmanager_oam_dev_appInstanceId, label_labels_appmanager_oam_dev_appId, label_labels_appmanager_oam_dev_appInstanceName, label_labels_appmanager_oam_dev_clusterId, label_labels_appmanager_oam_dev_componentName, label_labels_appmanager_oam_dev_stageId)(0 * kube_pod_labels{uid!=\"\",label_labels_appmanager_oam_dev_appInstanceId!=\"\"})'\n- module: kubernetes\n  metricsets:\n    - container\n    - node\n    - pod\n    - system\n    - volume\n  period: 1m\n  host: \"${NODE_NAME}\"\n  hosts: [\"https://${NODE_IP}:10250\"]\n  bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token\n  ssl.verification_mode: \"none\"\n  # If using Red Hat OpenShift remove ssl.verification_mode entry and\n  # uncomment these settings:\n  ssl.certificate_authorities:\n    - /var/run/secrets/kubernetes.io/serviceaccount/ca.crt\n  processors:\n  - add_kubernetes_metadata: ~\n- module: kubernetes\n  enabled: true\n  metricsets:\n    - event\n- module: kubernetes\n  metricsets:\n    - proxy\n  period: 1m\n  host: ${NODE_NAME}\n  hosts: [\"localhost:10249\"]\n- module: system\n  period: 1m\n  metricsets:\n    - cpu\n    - load\n    - memory\n    - network\n    - process\n    - process_summary\n  cpu.metrics: [percentages, normalized_percentages]\n  processes: ['.*']\n  process.include_top_n:\n    by_cpu: 5\n    by_memory: 5\n- module: system\n  period: 1m\n  metricsets:\n    - filesystem\n    - fsstat\n  processors:\n  - drop_event.when.regexp:\n      system.filesystem.mount_point: '^/(sys|cgroup|proc|dev|etc|host|lib)($|/)'\n\nmetricbeat.autodiscover:\n  providers:\n    - type: kubernetes\n      scope: node\n      node: ${NODE_NAME}\n      include_labels: [\"sreworks-telemetry-metric\"]\n      resource: pod\n      templates:\n        - condition:\n            equals:\n              kubernetes.labels.sreworks-telemetry-metric: enable\n          config:\n            - module: http\n              metricsets:\n                - json\n              period: 1m\n              hosts: [\"http://${data.host}:10080\"]\n              namespace: \"${data.kubernetes.namespace}#${data.kubernetes.service.name}\"\n              path: \"/\"\n              method: \"GET\"\n\n    - type: kubernetes\n      scope: cluster\n      node: ${NODE_NAME}\n      unique: true\n      include_labels: [\"sreworks-prometheus-scrape-metric\"]\n      templates:\n        - condition:\n            equals:\n              kubernetes.labels.sreworks-prometheus-scrape-metric: enable\n          config:\n            - module: prometheus\n              period: 1m\n              hosts: [\"${data.host}:${data.port}\"]\n              metrics_path: /metrics\n\n    - type: kubernetes\n      scope: cluster\n      node: ${NODE_NAME}\n      unique: true\n      templates:\n        - config:\n            - module: kubernetes\n              hosts: [\"prod-dataops-kubecost-kube-state-metrics.sreworks-dataops.svc.cluster.local:8080\"]\n              period: 1m\n              add_metadata: true\n              metricsets:\n                - state_node\n                - state_deployment\n                - state_daemonset\n                - state_replicaset\n                - state_pod\n                - state_container\n                - state_cronjob\n                - state_resourcequota\n                - state_statefulset\n                - state_service\n\nprocessors:\n  - add_cloud_metadata:\n\nsetup.ilm.enabled: auto\nsetup.ilm.rollover_alias: \"metricbeat\"\nsetup.ilm.pattern: \"{now/d}-000001\"\nsetup.template.name: \"metricbeat\"\nsetup.template.pattern: \"metricbeat-*\"\n\noutput.elasticsearch:\n  hosts: '{{ Global.DATA_ES_HOST }}:{{ Global.DATA_ES_PORT }}'\n  index: \"metricbeat-%{+yyyy.MM.dd}\"\n  username: \"{{ Global.DATA_ES_USER }}\"\n  password: \"{{ Global.DATA_ES_PASSWORD }}\"\n"
          resources:
            limits:
              cpu: 1000m
              memory: 500Mi
            requests:
              cpu: 100m
              memory: 100Mi
        deployment:
          enabled: false
        image: sreworks-registry.cn-beijing.cr.aliyuncs.com/mirror/metricbeat
        kube_state_metrics:
          enabled: false
        serviceAccount: metricbeat-sa
    - name: name
      toFieldPaths:
      - spec.name
      value: '{{ Global.STAGE_ID }}-dataops-metricbeat'
    revisionName: HELM|metricbeat|_
    scopes:
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Cluster
        name: '{{ Global.CLUSTER_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Namespace
        name: '{{ Global.NAMESPACE_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Stage
        name: '{{ Global.STAGE_ID }}'
    traits: []
  - dependencies:
    - component: RESOURCE_ADDON|system-env@system-env
    parameterValues:
    - name: values
      toFieldPaths:
      - spec.values
      value:
        auth:
          rootPassword: cb56b5is5e21_c359b42223
        global:
          storageClass: '{{ Global.STORAGE_CLASS }}'
        image:
          registry: sreworks-registry.cn-beijing.cr.aliyuncs.com
          repository: mirror/mysql
          tag: 8.0.22-debian-10-r44
        primary:
          extraFlags: --max-connect-errors=1000 --max_connections=10000
          persistence:
            size: 50Gi
          service:
            type: ClusterIP
        replication:
          enabled: false
    - name: name
      toFieldPaths:
      - spec.name
      value: '{{ Global.STAGE_ID }}-dataops-mysql'
    revisionName: HELM|mysql|_
    scopes:
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Cluster
        name: '{{ Global.CLUSTER_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Namespace
        name: '{{ Global.NAMESPACE_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Stage
        name: '{{ Global.STAGE_ID }}'
    traits: []
  - dependencies:
    - component: RESOURCE_ADDON|system-env@system-env
    parameterValues:
    - name: values
      toFieldPaths:
      - spec.values
      value:
        elasticsearch:
          config:
            host: '{{ Global.STAGE_ID }}-dataops-elasticsearch-master.{{ Global.NAMESPACE_ID }}.svc.cluster.local'
            password: '{{ Global.DATA_ES_PASSWORD }}'
            port:
              http: 9200
            user: '{{ Global.DATA_ES_USER }}'
          enabled: false
        oap:
          image:
            repository: sreworks-registry.cn-beijing.cr.aliyuncs.com/mirror/skywalking-oap-server-utc-8
            tag: 9.2.0
          javaOpts: -Xmx1g -Xms1g
          replicas: 1
          storageType: elasticsearch
        ui:
          image:
            repository: sreworks-registry.cn-beijing.cr.aliyuncs.com/mirror/skywalking-ui
            tag: 9.2.0
    - name: name
      toFieldPaths:
      - spec.name
      value: '{{ Global.STAGE_ID }}-dataops-skywalking'
    revisionName: HELM|skywalking|_
    scopes:
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Cluster
        name: '{{ Global.CLUSTER_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Namespace
        name: '{{ Global.NAMESPACE_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Stage
        name: '{{ Global.STAGE_ID }}'
    traits: []
  - dependencies:
    - component: RESOURCE_ADDON|system-env@system-env
    parameterValues:
    - name: values
      toFieldPaths:
      - spec.values
      value:
        acceptCommunityEditionLicense: true
        blobStorageCredentials:
          s3:
            accessKeyId: '{{ Global.MINIO_ACCESS_KEY }}'
            secretAccessKey: '{{ Global.MINIO_SECRET_KEY }}'
        persistentVolume:
          accessModes:
          - ReadWriteOnce
          annotations: {}
          enabled: true
          size: 20Gi
          storageClass: '{{ Global.STORAGE_CLASS }}'
          subPath: ''
        vvp:
          blobStorage:
            baseUri: s3://vvp
            s3:
              endpoint: http://sreworks-minio.sreworks:9000
          globalDeploymentDefaults: "spec:\n  state: RUNNING\n  template:\n    spec:\n      resources:\n        jobmanager:\n          cpu: 0.5\n          memory: 1G\n        taskmanager:\n          cpu: 0.5\n          memory: 1G\n      flinkConfiguration:\n        state.backend: filesystem\n        taskmanager.memory.managed.fraction: 0.0 # no managed memory needed for filesystem statebackend\n        high-availability: vvp-kubernetes\n        metrics.reporter.prom.class: org.apache.flink.metrics.prometheus.PrometheusReporter\n        execution.checkpointing.interval: 10s\n        execution.checkpointing.externalized-checkpoint-retention: RETAIN_ON_CANCELLATION\n"
          persistence:
            type: local
          registry: sreworks-registry.cn-beijing.cr.aliyuncs.com/mirror
          sqlService:
            pool:
              coreSize: 1
              maxSize: 1
    - name: name
      toFieldPaths:
      - spec.name
      value: '{{ Global.STAGE_ID }}-dataops-ververica-platform'
    revisionName: HELM|ververica-platform|_
    scopes:
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Cluster
        name: '{{ Global.CLUSTER_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Namespace
        name: '{{ Global.NAMESPACE_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Stage
        name: '{{ Global.STAGE_ID }}'
    traits: []
  - dataInputs: []
    dataOutputs: []
    dependencies: []
    parameterValues:
    - name: STAGE_ID
      toFieldPaths:
      - spec.stageId
      value: prod
    revisionName: INTERNAL_ADDON|productopsv2|_
    scopes:
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Cluster
        name: '{{ Global.CLUSTER_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Namespace
        name: '{{ Global.NAMESPACE_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Stage
        name: '{{ Global.STAGE_ID }}'
    traits: []
  - parameterValues:
    - name: STAGE_ID
      toFieldPaths:
      - spec.stageId
      value: prod
    revisionName: INTERNAL_ADDON|developmentmeta|_
    scopes:
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Cluster
        name: '{{ Global.CLUSTER_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Namespace
        name: '{{ Global.NAMESPACE_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Stage
        name: '{{ Global.STAGE_ID }}'
  - parameterValues:
    - name: STAGE_ID
      toFieldPaths:
      - spec.stageId
      value: prod
    - name: OVERWRITE_IS_DEVELOPMENT
      toFieldPaths:
      - spec.overwriteIsDevelopment
      value: 'true'
    revisionName: INTERNAL_ADDON|appmeta|_
    scopes:
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Cluster
        name: '{{ Global.CLUSTER_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Namespace
        name: '{{ Global.NAMESPACE_ID }}'
    - scopeRef:
        apiVersion: apps.abm.io/v1
        kind: Stage
        name: '{{ Global.STAGE_ID }}'
  parameterValues:
  - name: CLUSTER_ID
    value: master
  - name: NAMESPACE_ID
    value: ${NAMESPACE_ID}
  - name: STAGE_ID
    value: prod
  - name: APP_ID
    value: dataops
  - name: KAFKA_ENDPOINT
    value: ${KAFKA_ENDPOINT}:9092
  - name: DATA_ES_HOST
    value: ${DATA_ES_HOST}
  - name: DATA_ES_PORT
    value: ${DATA_ES_PORT}
  policies: []
  workflow:
    steps: []
