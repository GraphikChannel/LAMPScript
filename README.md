# Installation process 
### Developpment
 1. Install docker
 2. Execute from the DockerFile directory `docker build . --tag lampimage`
 3. Create a container : `docker run --name lamp -it -p80:80 -p3306:3306 lampimage`  
 4. Go to `/var/www/vimeoApp` and `git clone https://github.com/GraphikChannel/vimeoDeploy.git .`

