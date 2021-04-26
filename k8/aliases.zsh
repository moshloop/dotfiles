function kdeletens() {
    NAMESPACE=$1
    kubectl proxy &>/dev/null &
    PROXY_PID=$!
    killproxy () {
        kill $PROXY_PID
    }
    trap killproxy EXIT
    kubectl get namespace $NAMESPACE -o json |jq '.spec = {"finalizers":[]}' >temp.json
    curl -k -H "Content-Type: application/json" -X PUT --data-binary @temp.json 127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/finalize
    rm temp.json
}

function kdeletefailed() {
    IFS=$(echo -en "\n\b")
    for po in $(kubectl get po --all-namespaces | grep -v Running ); do
        kubectl delete po   --wait=false -n $(echo $po | awk '{print $1}') $(echo $po | awk '{print $2}');
    done
}

function kdeletecreating() {
    IFS=$(echo -en "\n\b")
    for po in $(kubectl get po --all-namespaces | grep ContainerCreating  ); do
        kubectl delete po   --wait=false -n $(echo $po | awk '{print $1}') $(echo $po | awk '{print $2}');
    done
}

function kcleanup() {

    kubectl get po | grep -v Running | grep -v Pending | grep -v ContainerCreating | awk '{print $1}' | xargs kubectl delete po

}
function kuse() {
    kubectl config set-context $(kubectl config current-context) --namespace=$1
}

function kctx() {
    kubectl config set-context $1
}

function kns() {
    context=$(kubectl config current-context)
    kubectl config set-context $context --namespace=$1
}


function kubectl-rename-context() {
    auth_info=$(kubectl config get-contexts $1 | awk '{print $4}' | tail -n 1)
    kubectl config set-context $2 --cluster $1 --user $auth_info
    kubectl config delete-context $1
}

function kubectl-import-context() {
    export KUBECONFIG=$HOME/.kube/config:$1
    kubectl config view --flatten > $HOME/.kube/config
}

function kdall() {
    for o in cm ds pvc svc po deploy ds sa statefulsets; do
     k get $o -n $1 | aq | xargs kubectl delete $o -n $1
    done
}
# Drop into an interactive terminal on a container
alias keti='kubectl exec -ti'

dbash() {
    echo docker ps -qa --filter name=$1
    cid="$(docker ps -qa --filter name=$1)"
    echo docker exec -it $cid bash
     docker exec -it $cid bash
}

function kn() {
    kubectl get -o yaml $* | kubectl-neat
}

alias sterna="stern --container-state=terminated   --container-state=running --container-state=waiting"

alias k=kubectl
# Manage configuration quickly to switch contexts between local, dev ad staging.
alias kcuc='kubectl config use-context'
alias kcsc='kubectl config set-context'
alias kcdc='kubectl config delete-context'
alias kccc='kubectl config current-context'
alias kl='kubectl logs'
alias kd='kubectl describe'
alias kg='kubectl get'
alias kga='kubectl get --all-namespaces'
alias kda='kubectl describe --all-namespaces'

# Pod management.
alias kgp='kubectl get pods'
alias klp='kubectl logs pods'
alias kep='kubectl edit pods'
alias kdp='kubectl describe pods'
alias kdelp='kubectl delete pods'

# Service management.
alias kgs='kubectl get svc'
alias kes='kubectl edit svc'
alias kds='kubectl describe svc'
alias kdels='kubectl delete svc'

# Secret management
alias kgsec='kubectl get secret'
alias kdsec='kubectl describe secret'
alias kdelsec='kubectl delete secret'

# Deployment management.
alias kgd='kubectl get deployment'
alias ked='kubectl edit deployment'
alias kdd='kubectl describe deployment'
alias kdeld='kubectl delete deployment'
alias ksd='kubectl scale deployment'
alias krsd='kubectl rollout status deployment'

# Rollout management.
alias kgrs='kubectl get rs'
alias krh='kubectl rollout history'
alias kru='kubectl rollout undo'
