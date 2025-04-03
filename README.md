# Jenkins & Ansible Lab 1

In this lab, i will create the architecture based on my course in this [link](https://www.udemy.com/course/jenkins-from-zero-to-hero/learn/lecture/12999622#overview)


First we created jenkins container with our current docker-compose.yaml file.

After using `docker compose up -d`, our jenkins container is active.

Then we can proceed to install nedeed plugins with the given key from jenkins container:
![alt text](/images_for_readme/image_1.png)

#

## Creating basic job

In our host machine we can create a script inludes following lines:

    #!/bin/bash

    NAME=$1
    LASTNAME=$2
    
    echo "Hello, $NAME $LASTNAME"

And copy this script like this to our jenkins container:

    docker cp basic_script.sh jenkins:/tmp/script.sh

In our jenkins client, we can parameterise our job like this and we will have 2 different variable called `FIRST_NAME` and `LAST_NAME`

![alt text](/images_for_readme/image_3.png)

If we add Execute Shell in build steps and fill it like this:

![alt text](/images_for_readme/image_2.png)

We can access this variables. If we build this job, we can see an output like this:

<p align="center">
  <img src="/images_for_readme/image_4.png" alt="Image 4" width="45%" style="margin-right: 10px;">
  <img src="/images_for_readme/image_5.png" alt="Image 5" width="45%">
</p>

# 

## Creating Container From Fedore OS

We create new Dockerfile for fedora container at `fedora/Dockerfile` and we update our docker-compose file for remote-host container.

If you guys counter any error that stops jenkins container running, this might be because of the jenkins doesn't have rights to write onto the file `jenkins_home`. So to solve this we basicly use this command:

    sudo chown -R 1000:1000 ./jenkins_home

We are giving needed permission of the jenkins container to write or read from this file path.

# 
![alt text](/images_for_readme/image_6.png)

As we can see, our both jenkins and remote-host container is running. We can access remote-host from jenkins container:

![alt text](/images_for_readme/image_7.png)

We can copy remote-key file inside of our jenkins container and we can use this file for accessing remote-host container.  

The reason we are doing this is to actaully access this remote-host via jenkins for job usage. In future, we actually gonna use ansible for ssh connections. 