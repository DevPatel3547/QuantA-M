# QuantA&M Project

Main: [![Rails tests](https://github.com/CSCE431-Software-Engineering/QuantAM/actions/workflows/test.yml/badge.svg)](https://github.com/CSCE431-Software-Engineering/QuantAM/actions/workflows/test.yml)
Test: [![Rails tests](https://github.com/CSCE431-Software-Engineering/QuantAM/actions/workflows/test.yml/badge.svg?branch=test)](https://github.com/CSCE431-Software-Engineering/QuantAM/actions/workflows/test.yml)
Dev: [![Rails tests](https://github.com/CSCE431-Software-Engineering/QuantAM/actions/workflows/test.yml/badge.svg?branch=dev)](https://github.com/CSCE431-Software-Engineering/QuantAM/actions/workflows/test.yml)

## Introduction
This project seeks to provide an application to QuantA&M, a club at
Texas A&M University that focuses on quantum computing. The application
serves as both a member participation tracker and a repository of different
resources for members to access. The application is built using Ruby on Rails,
and it is hosted on Heroku.

## Development
To develop on this repository, you will need Docker. Once you have Docker installed,
you can run the following commands to get started. Keep in mind that you will need
to run these commands in the root directory of the repository.

### Running the Application

```bash
docker-compose build
docker-compose up
```

This will start the application and the database. You can access the application
at `localhost:3000`. You can access the database at `localhost:5432`. When you run
docker-compose up, the application will be running in the foreground. If you want to
run the application in the background, you can run `docker-compose up -d`.

### Initializing the Database

```bash
docker-compose exec app rake db:create db:migrate
```

### Seeding the Database

```bash
docker-compose exec app rake db:seed
```

Test data will be created in the database. This will allow you to test the application
with some data already in the database.

### Stopping/Removing the Application

```bash
docker-compose down
```

This will stop the application and the database. If you want to start the application
again, you can run `docker-compose up` again. There's no need to run `docker-compose build` unless
you've made changes to the `Dockerfile` or `docker-compose.yml`. Also, you only need to run
`docker compose down` if you ran 'docker-compose up -d'. If you ran 'docker-compose up', you can
just press `Ctrl+C` to stop the application.

## Testing
To run the tests, you can run the following command:

```bash
docker-compose run app rspec
```
