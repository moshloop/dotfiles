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
alias aliases.zsh="subl -w ~/.dotfiles/zsh/aliases.zsh && source ~/.dotfiles/zsh/aliases.zsh"

CP() {
	CLASSPATH=
	if [ -d "libs" ]; then
		CLASSPATH=$CLASSPATH:$(echo libs/*jar | sed 's/ /:/g')
	else
		CLASSPATH=$CLASSPATH:$(echo $WORK_DIR/libs/*jar | sed 's/ /:/g')
	fi
	if [ -d "test-libs" ]; then
		CLASSPATH=$CLASSPATH:$(echo test-libs/*jar | sed 's/ /:/g')
	else
		CLASSPATH=$CLASSPATH:$(echo $WORK_DIR/test-libs/*jar | sed 's/ /:/g')
	fi


	CLASSPATH=$CLASSPATH:$(echo $WORK_DIR/Utils/build/classes $WORK_DIR/Kernel/build/classes $WORK_DIR/Core/bin | sed 's/ /:/g')

	if [ -d "build/classes/main" ]; then
		CLASSPATH=$CLASSPATH:build/classes/main
	fi

	if [ -d "build/classes/test" ]; then
		CLASSPATH=$CLASSPATH:build/classes/test
	fi
	CLASSPATH=$CLASSPATH:.
	echo $CLASSPATH
}

groovy() {
	java -classpath `CP` "groovy.lang.GroovyShell"  "$@[1,-1]"
}

gtest() {
	gradle test -x compileJava -x compileGroovy -x processResources -x compileTestJava -x compileTestGroovy -x testClasses -x classes --info "$@[1,-1]"
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
	export PT_USER=admin
	export PT_PASS=p
}

pt_login() {
	echo "Hostname:"
	read PT_API
	echo "Username:"
	read PT_API_USER
	export PT_USER=$PT_API_USER
	echo "Password:"
	read PT_API_PASS
	export PT_PASS=$PT_API_PASS
}



pt_kill() {
	sudo jps | grep Startup | cut -d" " -f 1 | xargs sudo kill -KILL
}

pt_get() {
	http --auth $PT_API_USER:$PT_API_PASS GET "$PT_API/$1" Content-Type:plain/text
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


pt_logs() {
	ssh $1 tail -f /opt/Papertrail/nohup.out
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

