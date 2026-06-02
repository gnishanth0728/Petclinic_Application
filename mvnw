#!/bin/sh

# Find project root (.mvn directory)
find_maven_basedir() {
    wdir="$1"

    while [ "$wdir" != "/" ]; do
        if [ -d "$wdir/.mvn" ]; then
            echo "$wdir"
            return 0
        fi
        wdir=$(dirname "$wdir")
    done

    return 1
}

BASE_DIR=$(find_maven_basedir "$(pwd)")

if [ -z "$BASE_DIR" ]; then
    echo "Unable to locate Maven project root"
    exit 1
fi

export MAVEN_PROJECTBASEDIR="$BASE_DIR"

# Locate Java
if [ -n "$JAVA_HOME" ]; then
    JAVACMD="$JAVA_HOME/bin/java"
else
    JAVACMD=$(command -v java)
fi

if [ ! -x "$JAVACMD" ]; then
    echo "Java not found"
    exit 1
fi

# Download wrapper jar if missing
WRAPPER_JAR="$BASE_DIR/.mvn/wrapper/maven-wrapper.jar"

if [ ! -f "$WRAPPER_JAR" ]; then
    curl -fsSL \
      https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/3.1.1/maven-wrapper-3.1.1.jar \
      -o "$WRAPPER_JAR"
fi

exec "$JAVACMD" \
  -classpath "$WRAPPER_JAR" \
  -Dmaven.multiModuleProjectDirectory="$MAVEN_PROJECTBASEDIR" \
  org.apache.maven.wrapper.MavenWrapperMain "$@"
