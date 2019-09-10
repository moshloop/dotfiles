#!/bin/bash

docker_runas_me() {
  ARGS=""
  ENV_NAMES=$(env | cut -d= -f1)
  # echo $ENV_NAMES
  for ARG in "$ENV_NAMES"; do

      # if [[ "$ARG" == "AWS_"* || "$ARG" == "GOVC_"* || "$ARG" == "ANSIBLE_"* ]]; then
        echo $ARG=${!ARG}
          ARGS+=" -e $ARG=${!ARG}"
      # fi
  done

  for folder in .ansible .aws .ssh .kube; do
    [[ -e "$HOME/$folder" ]] && ARGS+=" -v $HOME/$folder:/root/$folder"
  done

  for abs in /var/run/docker.sock /work $HOME; do
    [[ -e "$abs" ]] && ARGS+=" -v $abs:$abs "
  done

  # allows passing an ssh-agent through
  ARGS+=" --volume ssh:/ssh --env SSH_AUTH_SOCK=/ssh/auth/sock"
  ARGS+=" -e USER=$(whoami)"
  echo $ARGS

}


systemd-container() {
 echo  docker run --rm -it --privileged --tmpfs /tmp --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro --entrypoint /lib/systemd/systemd $(docker_runas_me) moshloop/docker-ubuntu1804-ansible
}
