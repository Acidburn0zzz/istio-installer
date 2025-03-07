FROM alpine:latest

ENV ISTIO_VERSION 1.7.6

RUN apk update && apk add curl bash coreutils jq

# Get Istio Charts


# Get Istio
RUN curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} sh -
RUN mv istio-${ISTIO_VERSION}/bin/istioctl /usr/bin && chmod +x /usr/bin/istioctl

# Get kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN mv ./kubectl /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

# Add scripts for Istio
COPY scripts /usr/local/app/scripts/
RUN chmod +x /usr/local/app/scripts/init_kubeconfig.sh /usr/local/app/scripts/run.sh /usr/local/app/scripts/create_istio_system.sh /usr/local/app/scripts/uninstall_istio_system.sh /usr/local/app/scripts/get_grafana_dashboards.sh
RUN mkdir -p /usr/local/app/dashboards && /usr/local/app/scripts/get_grafana_dashboards.sh
ENTRYPOINT [ "/usr/local/app/scripts/run.sh" ]
