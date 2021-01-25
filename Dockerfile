FROM ubuntu 
RUN apt-get update 
RUN apt-get install -y iputils-ping vim net-tools dstat 
COPY utils.sh .
RUN ./utils.sh
COPY installApache.sh .
RUN ./installApache.sh
COPY installPhp.sh .
RUN installPhp.sh
COPY installDB.sh .
RUN ./installDB.sh
COPY getSourceCode.sh .
RUN ./getSourceCode.sh