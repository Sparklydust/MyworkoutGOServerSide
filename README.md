# MyworkoutGOServerSide


## Contact: roland.lariotte@gmail.com



### Starting the MyworkoutGOServerSide



1. Setup Docker.

You’ll need to have Docker installed and running. Visit the [Docker Website](https://www.docker.com/get-docker) 
and follow the instructions to install it.


2. Configure your PostgresSQL data base.

In your Terminal, type the following to create a database.

```
docker run --name MyworkoutGO \
  -e POSTGRES_DB=MyworkoutGO_database \
  -e POSTGRES_USER=MyworkoutGO_username \
  -e POSTGRES_PASSWORD=MyworkoutGO_password \
  -p 5432:5432 -d postgres
```
  
To check that your database is running, enter the following in Terminal to list 
all active containers:
  
```
docker ps
```


3. Run MyworkoutGOServerSide

- In the MyworkoutGOServerSide root project, start the server by running 
clicking on the Package.swift.

- Set the active scheme to MyworkoutGOServerSide with My Mac as the destination. 

- Build and run. Check the console and see that the migrations have run.
