#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: $0 container_name"
	exit 0
fi

current_user=$(id -un)
current_user_id=$(id -u)
current_group=$(id -gn)
current_group_id=$(id -g)
current_dir=$(pwd)
#docker_name=ubuntu16.04
docker_name="$1"
docker_user_id=$(docker exec -i $docker_name cat /etc/passwd | grep $current_user_id)
docker_group_id=$(docker exec -i $docker_name cat /etc/group | grep $current_group_id)

yesno()
{
	echo "yes/no?"
	while true
	do
		read x
		case $x in
			y | Y | yes | Yes | YES)
				return 0
				;;
			n | N | no | No | NO)
				return 1
				;;
			*)
				echo "please enter a valid value!"
				echo "yes/no?"
				continue
				;;
		esac
	done
}

if [ -z "$docker_group_id" ]; then
	echo "there is no docker group $current_group"
	echo "do you want to create new docker group $current_group, which gid is $current_group_id"
	yesno
	if [ $? -eq 0 ]; then
		docker exec -i $docker_name groupadd -g $current_group_id $current_group
	fi
else
	echo "docker group $current_group is already existence, gid is $current_group_id"
fi

if [ -z "$docker_user_id" ]; then
	echo "there is no docker user $current_user"
	echo "do you want to create new docker user $current_user, which uid is $current_user_id"
	yesno
	if [ $? -eq 0 ]; then
		docker exec -i -u root:root $docker_name useradd -d /home/$current_user -u $current_user_id -g $current_group -m -p $current_user $current_user
		if [ $? -eq 0 ]; then
			echo "you have success add a docker user $current_user, the passwd is $current_user"
		else
			echo "add docker user $current_user failed!"
		fi
	fi
else
	echo "docker user $current_user_info is already existence, uid is $current_user_id"
fi

echo "$current_user_id"
echo "$current_group_id"
echo "$current_dir"

