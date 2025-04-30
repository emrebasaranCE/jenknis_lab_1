# Introduction

In this file, I explain how can you use Gitlab with jenkins.

## Contents

- [1. Creating The Container](#1-creating-the-container)
- [2. Logging into the Gitlab](#2-logging-into-the-gitlab)
- [3. Managing Users](#3-managing-users)
- [4. Uploading Files To The New Repository Inside Our Gitlab Container](#4-uploading-files-to-the-new-repository-inside-our-gitlab-container)


## 1. Creating The Container

If we look at the docuemntation of [Gitlab](https://docs.gitlab.com/install/docker/installation/), we can add this part to our docker-compose.yml file:

```yaml
  gitlab:
    image: gitlab/gitlab-ee:<version>-ee.0
    container_name: gitlab_container
    restart: always
    hostname: 'gitlab.example.com'
    ports:
      - '8090:80'
    volumes:
      - '$GITLAB_HOME/config:/etc/gitlab'
      - '$GITLAB_HOME/logs:/var/log/gitlab'
      - '$GITLAB_HOME/data:/var/opt/gitlab'
    networks:
      - net
```

And then

```bash
docker compose up -d
```
We got this:
![`docker ps` for gitlab_container](image.png)

### 2. Logging into the Gitlab
Once the container is up, we need to acquire our password for root with this:

```bash
docker exec gitlab_container bash -c "cat /etc/gitlab/initial_root_password | grep Password"
```

After downloading and creating our gitlab cointainer, we now need to proceed to the gui for more action which is `localhost:8090` for me:

<img src="image-2.png" alt="Image 4" width="100%" style="margin-right: 10px;">

Now we have to create a group for our projects and the group name will be used in the urls while accessing future repositories:

<p align="center">
  <img src="image_3.png" alt="Image 4" width="45%" style="margin-right: 10px;">
  <img src="image_4.png" alt="Image 5" width="45%">
</p>

And then we can create our first repository like this:

![alt text](image-5.png)

### 3. Managing Users

In gitlab, we can create new users for developers and then gave them specific permissions. This adds another layer of security when creating and using gitlab on our local servers or pcs which is great. [To add user](https://docs.gitlab.com/user/profile/account/create_accounts/#:~:text=Create%20users%20on%20sign%2Din,on%20the%20sign%2Din%20page.), we simply go to the `Admin -> Users(Overview) -> New User` and voila. We just created a user named kinaru with the password pass1234:

![alt text](image-6.png)

Also after creating the user, we need to give access to our project like this:

![alt text](image-7.png)
### 4. Uploading Files To The New Repository Inside Our Gitlab Container

First we need to install the repo we want to use to our local machine like this

```bash
git clone https://github.com/jenkins-docs/simple-java-maven-app.git
```

and then we will also clone our gitlab repository like this:

```bash
git clone http://kinaru:pass1234@gitlab.example.com:8090/jenkins/maven.git   
```

We will get this output:

![alt text](image-8.png)

Now lets copy our jave app into our maven repository:

```bash
cp simple-java-maven-app/* maven/ -r
```