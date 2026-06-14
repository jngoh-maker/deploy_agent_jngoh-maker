#!/bin/bash

initialize_system() {
    echo "Student Attendance Tracker system deploy agent"
    read -p "Please provide the workspace name: " name

    workspace_name="attendance_tracker_$name"

    echo "Creating your workspace directory: $workspace_name"

    mkdir "$workspace_name"

    echo "Workspace ($workspace_name) created"

    mkdir "${workspace_name}/Helpers" "${workspace_name}/reports"

    echo "Created sub-directories for the project"
    echo "Starting to move the source files to the workspace"

    cp "source/attendnace_checker.py" "$workspace_name/"
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

	sed -Ei \
	    -e 's|("warning": )[0-9]+|\1'"$warning"'|' \
	    -e 's|("failure": )[0-9]+|\1'"$failure"'|' \
	    "$workspace_name/Helpers/config.json"

	echo "New thresholds set: $warning for Warning & $failure for Failure"
    else
	echo "Default thresholds used: 75% for Warning & 50% for Failure"
    fi
}
