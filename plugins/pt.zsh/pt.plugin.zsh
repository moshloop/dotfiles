export OPS=/workspace/ops
export WORK_DIR=/workspace/PT
export BUILD=/workspace/misc/build-tools/
export PT_HOME=/workspace/PT
export PT=$PT_HOME
export LIB_CACHE=$PT/libs
export PROJECTS=$PT_HOME

switch_local() {
    export PT_API=http://127.0.0.1:8080
    export PT_USER=admin
    export PT_PASS=p
}

pt_login() {
    echo "Hostname:"
    read PT_API
    echo "Username:"
    read PT_USER
    echo "Password:"
    read PT_PASS
}

pt_kill() {
    sudo jps | grep Startup | cut -d" " -f 1 | xargs sudo kill -KILL
}

pt_get() {
    http --auth $PT_USER:$PT_PASS GET "$PT_API/$1" Content-Type:plain/text
}

pt_post() {
    http --auth $PT_USER:$PT_PASS POST "$PT_API/$1"
}

pt_action() {
    echo "executing $1 with " "$@[2,-1]"
    pt_form action/execute/$1 "$@[2,-1]"
}

pt_form() {
    http --form --ignore-stdin  --auth $PT_USER:$PT_PASS POST "$PT_API/$1"  "$@[2,-1]"
}

pt_logs() {
    ssh $1 tail -f /opt/Papertrail/nohup.out
}
