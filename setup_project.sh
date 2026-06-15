#!/bin/bash

trap user_interupt SIGINT

initialize_system() {
    echo "Student Attendance Tracker system deploy agent"
    read -p "Please provide the workspace name: " name

    workspace_name="attendance_tracker_$name"

    if [ -d $workspace_name ]; then
	echo "$workspace_name directory already exists. In this environment"
	exit 0
    fi
    
    
    echo "Creating your workspace directory: $workspace_name"

    mkdir "$workspace_name"

    echo "Workspace ($workspace_name) created"

    mkdir "${workspace_name}/Helpers" "${workspace_name}/reports"

    echo "Created sub-directories for the project"
    echo "Starting to move the source files to the workspace"

    cp "source/attendance_checker.py" "$workspace_name/"
    cp "source/assets.csv" "$workspace_name/Helpers"
    cp "source/config.json" "$workspace_name/Helpers"
    cp "source/reports.log" "$workspace_name/reports"

    echo "Successfully moved all source files"

    dynamic_configuration
    
}

dynamic_configuration() {
    echo "UPDATING ATTENDANCE MARKS THRESHOLDS"
    read -p "Do you want to update the thresholds(y,n)? " update

    if [[ "$update" == "y" ]]; then
	read -p "Please specify the new warning percentage: " warning
	read -p "Please specify the new failure percentage: " failure

	if [[ ! "$warning" =~ ^[0-9]+$ ]]; then
	    echo "Warning threshold must be a number."
	    dynamic_configuration
	elif [[ ! "$failure" =~ ^[0-9]+$ ]]; then
	    echo "Failure threshold must be a number."
	    dynamic_configuration
	else
	    sed -Ei \
		-e 's|("warning": )[0-9]+|\1'"$warning"'|' \
		-e 's|("failure": )[0-9]+|\1'"$failure"'|' \
		"$workspace_name/Helpers/config.json"
	    echo "New thresholds set: $warning for Warning & $failure for Failure"
	fi
    else
	echo "Default thresholds used: 75% for Warning & 50% for Failure"
    fi

    environment_validator
}

environment_validator() {
    echo "WORKSPACE ENVIRONMENT VALIDATION"

    echo "Checking if Python 3 is installed..."

    if version=$(python3 --version 2>/dev/null); then
        echo "Python has been found on your system ($version)"
    else
        echo "Python is missing on your system"
    fi

    echo "checking if all files have been created in workspace"

    if [ ! -d "$workspace_name" ]; then
	echo "The workspace($workspace_name) has not been created"
    else
	echo "Worksace direcotory exists"
    fi

    if [ ! -f "$workspace_name/attendance_checker.py" ]; then
	echo "The attendance_checker.py file is missing"
    else
	echo "attendance_checker.py file is present"
    fi

    if [ ! -f "$workspace_name/Helpers/assets.csv" ]; then
	echo "The assets.csv file is missing"
    else
	echo "assets.csv file is present"
    fi

    if [ ! -f "$workspace_name/Helpers/config.json" ]; then
	echo "The config.json file is missing"
    else
	echo "config.json is present"
    fi
    
    if [ ! -f "$workspace_name/reports/reports.log" ]; then
	echo "The reports.log file is missing"
    else
	echo "reports.log is present"
    fi
    
}

user_interupt() {
    echo "USER INTERUPTED THE PROCESS"
    echo "Archiving your current progress.."

    if [ ! -d "$workspace_name" ]; then
	echo "The workspace doesnt exist to be archived"
	exit 0
    fi

    tar -czf "archive_$workspace_name" "$workspace_name"

    echo "Archive created successfully, now removing the incomplete workspace"
    rm -rf "$workspace_name"

    echo "Archiving completed. Now exiting"
    exit 0
}

initialize_system
