# Jenkins & Ansible Lab 1

In this lab, i will create the architecture based on my course in this [link](https://www.udemy.com/course/jenkins-from-zero-to-hero/learn/lecture/12999622#overview)


First we created jenkins container with our current docker-compose.yaml file.

After using `docker compose up -d`, our jenkins container is active.

Then we can proceed to install nedeed plugins with the given key from jenkins container:
![alt text](/images_for_readme/image.png)

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