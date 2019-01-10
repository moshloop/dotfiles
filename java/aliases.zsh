#!/bin/sh


alias mvncie='mvn clean install eclipse:eclipse'
alias mvnci='mvn clean install'
alias mvne='mvn eclipse:eclipse'
alias mvnce='mvn clean eclipse:clean eclipse:eclipse'
alias mvnd='mvn deploy'
alias mvnp='mvn package'
alias mvnc='mvn clean'
alias mvncom='mvn compile'
alias mvnt='mvn test'
alias mvnag='mvn archetype:generate'
alias mvnnew='mvn archetype:generate -DarchetypeArtifactId=maven-archetype-quickstart'
alias mvn_down='java -jar ~/.dotfiles/bin/ivy.jar -retrieve "libs/[artifact]-[type]-[revision].[ext]" '


mvn() {
  # shellcheck disable=SC2068
  command mvn $@
  local message="'mvn $*' done!"
  which terminal-notifier > /dev/null && terminal-notifier -message "$message"
  which notify-send > /dev/null && notify-send "$message"
}


CP() {
    unsetopt nomatch
    CLASSPATH=""
    for lib in 'bin' 'build/classes/main' 'build/classes/test' 'build/classes/api'
    do

        if [ -d "$lib" ]; then
            CLASSPATH=$CLASSPATH:$lib
        fi

        P=$( echo $WORK_DIR/*/$lib )
        if test "${P#*\*}" = "$P"
        then
            CLASSPATH=$CLASSPATH:$P
        fi
    done
    for lib in 'libs' 'test-libs' 'build' 'deploy'
    do
       if [ -d "$lib" ]; then
        CLASSPATH=$CLASSPATH:$( echo $lib/*.jar)
       fi
       if [ -d "$WORK_DIR/$lib" ]; then
        CLASSPATH=$CLASSPATH:$( echo $WORK_DIR/$lib/*.jar)
       fi
    done

    CLASSPATH=$(echo $CLASSPATH | sed 's/ /:/g')
    CLASSPATH=$CLASSPATH:.
    echo $CLASSPATH
}

# groovy() {
#     java -classpath `CP` "groovy.lang.GroovyShell"  "$@[1,-1]"
# }