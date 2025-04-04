# Jenkins & Ansible Lab 1

In this lab, i will create the architecture based on my course in this [link](https://www.udemy.com/course/jenkins-from-zero-to-hero/learn/lecture/12999622#overview)


First we created jenkins container with our current docker-compose.yaml file.

After using `docker compose up -d`, our jenkins container is active.

Then we can proceed to install nedeed plugins with the given key from jenkins container:
![alt text](/images_for_readme/image_1.png)

#

## Creating basic job

In our host machine we can create a script inludes following lines:

```bash
    #!/bin/bash

    NAME=$1
    LASTNAME=$2
    
    echo "Hello, $NAME $LASTNAME"
```

And copy this script like this to our jenkins container:

```bash
docker cp basic_script.sh jenkins:/tmp/script.sh
```

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

After editing Dockerfile in fedora file path, we can creat a ssh key using:

```bash
ssh-keygen -t rsa -m PEM -f remote-key
```
If you guys counter any error that stops jenkins container running, this might be because of the jenkins doesn't have rights to write onto the file `jenkins_home`. So to solve this we basicly use this command:

```bash
sudo chown -R 1000:1000 ./jenkins_home
```

We are giving needed permission of the jenkins container to write or read from this file path.

# 
![alt text](/images_for_readme/image_6.png)

As we can see, our both jenkins and remote-host container is running. We can access remote-host from jenkins container:

![alt text](/images_for_readme/image_7.png)

We can copy remote-key file inside of our jenkins container and we can use this file for accessing remote-host container.  

The reason we are doing this is to actaully access this remote-host via jenkins for job usage. In future, we actually gonna use ansible for ssh connections. 

# 

Now we can add ssh remote host from jenkins configuration page:

![alt text](/images_for_readme/image_8.png)

If we give the information inside the job's configuration to use ssh and enter basic command:

<p align="center">
  <img src="/images_for_readme/image_9.png" alt="Image 9" width="45%" style="margin-right: 10px;">
  <img src="/images_for_readme/image_10.png" alt="Image 10" width="45%">
</p>

We can see here that our job is worked out and we can communicate with remote-host container via our jenkins container! That's greatt!!!

## Creating MySql Server in Docker

We updated our docker-compose.yaml file like this:

```
db_host:
    container_name: db
    image: mysql
    environment:
    - "MYSQL_ROOT_PASSWORD=1234"
    volumes:
    - $PWD/db_data:/var/lib/mysql
    networks:
    - net
```

And when we do:

```bash
docker compose down
docker compose up -d
```

We can see that our services is up:

![alt text](/images_for_readme/image_11.png)

We just added needed AWS tools in our remote-host container like this:

```
RUN yum -y install mysql

RUN yum -y install python3-pip && \
    pip3 install --upgrade pip && \
    pip3 install awscli
```

If we go into our remote-host bash and connect to the mysql container using this command:

```bash
mysql -u root -h db_host -p 
```

this will ask us a password which we set it to 1234, then we are inside the mysql. Now we can create sample database and input some data into db like this:

```sql
create database testdb;
use testdb;
create table info(name varchar(20), lastname varchar(20), age int(2)); 
insert into info values ('mandalina', 'lastname', 22); 
# and with last command, we can see inside of our table
SELECT * FROM info;
``` 
Okey, we just created our database and inserted some information. 

### What to do next? 

To make more complex operation, we can create a db backup and send this backup to the AWS S3 service. After creating S3 bucket. We will create a simple script for this occasion in `aws_backup_script.sh`.

But before running this script in jenkins job, we need more security for our secret keys and passwords, for that we can use jenkins' credentials:

<p align="center">
  <img src="/images_for_readme/image_12.png" alt="Image 9" width="45%" style="margin-right: 10px;">
  <img src="/images_for_readme/image_13.png" alt="Image 10" width="45%">
</p>

Our script takes 5 arguments to run, we created 2 of them using credentials in jenkins 

| Variable      | Description                          |
|---------------|--------------------------------------|
| DB_PASSWORD   | Created inside Jenkins credentials   |
| AWS_SECRET    | Created inside Jenkins credentials   |
| DB_HOST       |
| DB_NAME       |
| BUCKET_NAME   |


So for the rest of the variables, we are creating variable inside our job confiration on jenkins. After creating, this is our situation:


| Variable      | Description                          |
|---------------|--------------------------------------|
| DB_PASSWORD   | Created inside Jenkins credentials   |
| AWS_SECRET    | Created inside Jenkins credentials   |
| DB_HOST       | Created variable inside Jenkins job  |
| DB_NAME       | Created variable inside Jenkins job  |
| BUCKET_NAME   | Created variable inside Jenkins job  |

In build settings, we also configuring the `Execute shell script on remote host using ssh` like this:

![alt text](/images_for_readme/image_14.png)

If you get an error, don't worry. You forgot to give the appropiate permissions like me :')

```bash
chmod +x aws_backup_script.sh 
```

Ups! I forgot to add bindings in job configurations. Our job doesn't know what credentials to use soo we are using bindings like this:

![alt text](/images_for_readme/image_15.png)

But now our job can access all of our variables and run smoothly!

![alt text](/images_for_readme/image_16.png)

And if we look into our bucket on AWS S3, we can see our uploaded object: 

![alt text](/images_for_readme/image_17.png)
