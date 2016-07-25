#!/bin/sh
__reload_dotfiles() {
  PATH="$(command -p getconf PATH):/usr/local/bin"
  . ~/.zshrc
  cd .
}


alias reload!='__reload_dotfiles'
alias jup="git fetch && git rebase origin master && jekyll serve"
alias rscp='rsync -v -e "ssh" --rsync-path="sudo rsync"  -arvuz --exclude ".DS_Store" --exclude ".git" '
alias build='gulp --gulpfile $BUILD/Gulpfile.js --cwd ./'
alias slaves='python $OPS/vm/__init__.py --type'
alias s3='s3cmd  --access_key=$S3_ACCESS_KEY --secret_key=$S3_SECRET'
alias grad="gradle jar && cp build/libs/egis-* $WORK_DIR/build"
alias mvn_down='java -jar ~/.dotfiles/bin/ivy.jar -retrieve "libs/[artifact]-[type]-[revision].[ext]" '

export GROOVY_HOME=/usr/local/opt/groovy/libexec
CP() {
	BIN=buck-out/gen/lib__mrp__output/mrp.jar
	COMMON=/workspace/Utils/build/libs/egis-utils.jar:/workspace/misc/Kernel/build/libs/egis-kernel.jar:/workspace/PT/Core/build/papertrail-core-api.jar 
	CLASSPATH=$(echo libs/*.jar test-libs/*.jar . | sed 's/ /:/g')
	CLASSPATH=$CLASSPATH:$COMMON:$BIN
	echo $CLASSPATH
}

groovy() {
	java -classpath `CP` "groovy.lang.GroovyShell" $1
}

jenkins_load() {
	cd /workspace/ops/ansible
	python scripts/pt/ESX.py --esx 191.9.110.43 -a start -s "ubuntu_slave"
}

port_forward() {
	echo "forward $1 to $2:$3"
	echo "
		rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port $1 ->  $2 port $3
	" | sudo pfctl -ef -
}


switch_local() {
	export PT_API=http://localhost:8080
	export PT_API_USER=admin
	export PT_API_PASS=p
}

pt_login() {
	echo "Hostname:"
	read PT_API
	echo "Username:"
	read PT_API_USER 
	echo "Password:"
	read PT_API_PASS 
}


pt_kill() {
	sudo jps | grep Startup | cut -d" " -f 1 | xargs sudo kill -KILL
}

pt_get() {
	http --auth $PT_API_USER:$PT_API_PASS GET "$PT_API/$1"
}

pt_post() {
	http --auth $PT_API_USER:$PT_API_PASS POST "$PT_API/$1"
}

pt_action() {
	echo "executing $1 with " "$@[2,-1]"
	pt_form action/execute/$1 "$@[2,-1]"
}

pt_form() {
	http --form --ignore-stdin  --auth $PT_API_USER:$PT_API_PASS POST "$PT_API/$1"  "$@[2,-1]"
}

pt_deploy() {
	pt_form action/execute/deploy_pack "file@$1"
}


pt_query() {
	pt_get "document/query?columns=docId&query=$1" | jq '.items[][0] | tonumber'
}

# e.g. pt_script-e "new Date()"
pt_script-e() {
	out=`pt_form script/execute "code=$1"`
	echo $out

}

# e.g. pt_script test.groovy
pt_script() {
	script=`cat $1`
	out=`pt_form script/execute "code=$script"`
	echo $out
}


pt_logs() {
	ssh $1 tail -f /opt/Papertrail/nohup.out
}


# e.g. pt_upload System/scripts/TEST.groovy build/libTest.groovy
pt_upload() {
	http --auth $PT_API_USER:$PT_API_PASS POST $PT_API/public/file/$1 Content-Type:application/octet-stream  < $2
}

pt_redeploy() {
	http --auth $PT_API_USER:$PT_API_PASS POST $PT_API/workflow/redeploy Content-Type:application/octet-stream 
}


# e.g. update_script test.groovy
update_script() {
	http --auth $PT_API_USER:$PT_API_PASS POST $PT_API/public/file/System/scripts/$1 Content-Type:application/octet-stream  < $1
	http --auth $PT_API_USER:$PT_API_PASS POST $PT_API/workflow/redeploy Content-Type:application/octet-stream 
}

#e.g. update_doc Systems/forms FORM.pdf
update_doc() {
	http --auth $PT_API_USER:$PT_API_PASS POST $PT_API/public/file/$2/$1 Content-Type:application/octet-stream  < $1
}


pt_create() {
	pt_form "action/execute/create_document" template="Item (no file)" filename="$1" node="$2" | jq '.docId'
}

# e.g. download_script test.groovy
download_script() {
	http --auth $PT_API_USER:$PT_API_PASS GET $PT_API/public/file/System/scripts/$1/$1 > $1
}

new_token() {
	http --body --auth $PT_API_USER:$PT_API_PASS GET "$PT_API/token/generate?url=/$1"
}

#e.g. new_form "Job Req"
new_form() {
	docId=`http --form --auth $PT_API_USER:$PT_API_PASS POST $PT_API/action/execute/new_form form="$1" | jq '.docId'`
	token=`http --body --auth $PT_API_USER:$PT_API_PASS GET "$PT_API/token/generate?url=/web/eSign"`
	open "$token?$docId"
}

#e.g. new_class "Jpb Req v1"
new_classic() {
	docId=`http --form --auth $PT_API_USER:$PT_API_PASS POST $PT_API/action/execute/new_form form="$1" | jq '.docId'`
	token=`http --body --auth $PT_API_USER:$PT_API_PASS GET "$PT_API/token/generate?url=/jsForm/edit/"`
	open "$token?$docId"
}
