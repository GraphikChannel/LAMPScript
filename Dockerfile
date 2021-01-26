FROM ubuntu 
RUN apt-get update 
RUN apt-get install -y iputils-ping vim net-tools dstat 
COPY deployLAMP.sh .
RUN ["chmod", "+x", "deployLAMP.sh"]
RUN ./deployLAMP.sh
COPY startContainer.sh .
RUN ["chmod", "+x", "startContainer.sh"]
ENTRYPOINT ["startContainer.sh"]
