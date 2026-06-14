## Attendance tracker setup script

This repository contains a script that orchestrates the project structure of an Attendance tracker system, using linux shell  and dynamic configuration to update marks thresholds for warning and failure

## Core functions
-  initialize_script: for starting the whole setup and asking the user to input variation value for the project
-  dynamic_configuration: Using sed command to update marks thresholds for attendance
-  environment_validator: To verify if python3 is installed and all files have been created for the attendance tracker
-  user_interupt: Process management function when user does ctrl + c or sends a SIGINT

## How to run instructions

1. Clone this repository

git clone https://github.com/jngoh-maker/deploy_agent_jngoh-maker

cd deploy_agent_jnghoh-maker

2. Grant the execute permission to the script

chmod 755 setup_project.sh

3. Run the script

./setup_script.sh

4. Follow the prompts, so that the script creates you the workspace

5. To interupt the script use "CTRL + C" and a new archive will create itself automatically

