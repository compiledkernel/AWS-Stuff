#!/bin/bash
set -e
#Provide me some data dude
aws_username=<your_username>
aws_password=<your_password>

#Now Do Stuff
create_user() {

  user=${1}
  password=${2}
  group=${3}

  aws iam create-user --user-name ${user}
  aws iam create-login-profile --user-name ${user} --password ${password} --password-reset-required
  aws iam add-user-to-group --user-name ${user} --group-name ${group}
}

AWS_PROFILE=<your_profile> create_user ${aws_username} ${aws_password} <your_group>
