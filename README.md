## Overview

BeamEcho is a tool that can help you engage with the users of your iOS application. Imagine having a list of users stored in a PostgreSQL database, and you wish to send them targeted marketing messages or other communications. By adding your database as a "source" in BeamEcho, you can utilize SQL queries to send push notifications to specific segments of your audience.

Consider a table named `demo_table` with the following structure:

| id | username     | device_token | current_level | last_visit          | inserted_at         | updated_at          |
|----|--------------|--------------|---------------|---------------------|---------------------|---------------------|
| 2  | Martin Garcia| [REDACTED]   | 5             | 2024-02-01 19:25:16 | 2023-12-27 09:40:49 | 2024-02-01 19:25:16 |
| 1  | John Smith   | [REDACTED]   | 5             | 2024-02-01 20:01:35 | 2023-12-27 09:40:46 | 2024-02-01 20:01:35 |

The next video will demonstrate how you can remind your users — who haven't visited your application for more than a week — by sending them an Apple push notification.

<table>
  <tr>
   <td width="77.7%">
     <video src="https://github.com/abc3/beamecho/assets/1172600/6d069d60-e7de-4808-a305-e59f05280527" >
   </td>
   <td>
     <video src="https://github.com/abc3/beamecho/assets/1172600/c59fde50-a711-405b-a100-86d7180b5e69">
   </td>
  </tr>
</table>





## Future Work

In the future, we plan to extend the functionality of BeamEcho in several ways:

- **Additional Database Sources**: The aim is to support more types of databases as sources, including popular databases like MySQL, MongoDB, and ClickHouse.

- **Android Push Notifications**: At present, BeamEcho supports sending push notifications to iOS devices. The plan is to extend this support to Android devices as well.

For feature requests or suggestions, please feel encouraged to open an issue on the GitHub repository. Community contributions and feedback are highly appreciated.

Stay tuned for updates!

## Setup

`Dockerfile` and `docker-compose.yml` are included in the project. To run the application using Docker you can use the following commands:

```bash
docker-compose up --build
```
This command will build the images if they don't exist and starts the containers.

If you want just build the image and run the container:

```bash
docker build --no-cache -t beamecho .  
```

This command will build a Docker image named beamecho from the Dockerfile in the current directory.

### Adding a User

You can add a user to the application by making a POST request to the `/api/registration` endpoint. This is only possible if the users table is currently empty. Here's an example using `curl`:

```bash
curl  -X POST \
  'http://localhost:8080/api/registration' \
  --header 'Accept: */*' \
  --header 'Content-Type: application/json' \
  --data-raw '{
  "user": {
    "email": "user@email.com",
    "password": "admin_demo",
    "password_confirmation": "admin_demo"
  }
}'
```

That's it! Now you can visit [`localhost:8080`](http://localhost:8080) from your browser.

## Local setup

### To start server:

  1. Run `mix deps.get` to install dependencies

  2. Set up your PostgreSQL database. A schema named `_beamecho` should be created in your PostgreSQL database. You can do this by running the following command in your PostgreSQL command line:

    `create schema if not exists _beamecho;`

    After creating the schema, apply the migrations by running the following command in your terminal, replacing `YOUR_PG_URI` with your actual PostgreSQL URI:

    `DATABASE_URL=YOUR_PG_URI make db_migrate`

  3. Start application with `DATABASE_URL=YOUR_PG_URI make dev`

  4. As in the docker setup, you should add a user to the application:

```bash
curl  -X POST \
  'http://localhost:4000/api/registration' \
  --header 'Accept: */*' \
  --header 'Content-Type: application/json' \
  --data-raw '{
  "user": {
    "email": "user@email.com",
    "password": "admin_demo",
    "password_confirmation": "admin_demo"
  }
}'
```
