#!/bin/sh

if [ $# -lt 1 ]; then
    echo "Copies all the required files to the given directory, renaming the project to \"project_name\".\nUsage: copy_to_project.sh directory [project_name]\n\n\tdirectory will be created if it does not exist\n\tproject_name is optional."
else
    if [ ! -d "$1" ]; then
	mkdir -p "$1"
    fi
    
    project_name=${2:-$1}

    echo "Creating project '$project_name' in the '$1' directory"
    
    BASEDIR=$(dirname $(readlink -f "$0" || realpath "$0"))

    cp -R "$BASEDIR/glad" "$1/"
    cp "$BASEDIR/.gitignore" "$1/"
    cp "$BASEDIR/CMakeLists.txt" "$1/"
    cp "$BASEDIR/LICENSE" "$1/"
    cp "$BASEDIR/README.org" "$1/"
    cp "$BASEDIR/main.cpp" "$1/"
    
    # portable, non-bash way
    if echo "$OSTYPE" | grep -q "darwin"; then 
        SEDOPT="''" 
    else 
        SEDOPT=
    fi

    SEDCMD="LC_ALL=C sed -i $SEDOPT -e \"s/gl_glad_template/$project_name/g\" \$(find \"$1\" -type f -not -path \"$1/.git/*\" -not -path \"$1/build/*\")"
    eval $SEDCMD
fi
