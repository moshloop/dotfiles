#!/bin/sh

curl -sLS https://get.arkade.dev | sudo sh

arkade system install go node prometheus pwsh caddy buildkitd

arkade get kubectl atuin jq k3s kubectx kubens stern kubie mkcert op sops yq

export PATH="$HOME/.krew/bin:$PATH"

kubectl completion zsh > $( dirname "$0")/completion.zsh


kubectl krew install neat get-all debug-shell df-pv  ingress-nginx  oidc-login rbac-lookup access-matrix  whoami view-secret  resource-capacity resource-snapshot rbac-view tap tree view-utilization who-can
