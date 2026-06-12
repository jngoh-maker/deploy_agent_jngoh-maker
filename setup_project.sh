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
}
