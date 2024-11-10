# README

## Prerequisites
- ruby 3.3.2
- rails 7.2.2
- postgres

## Installation steps

```bash
git clone https://github.com/Deepak18-06/tm-tool
cd tm-tool
```

Install Dependecies
```bash
bundle install
```

Create and configure
```bash
rails db:create
rails db:migrate
```

Running server
```bash
rails server
```

## APIs
### User management
- Signup
```bash
curl --location 'http://127.0.0.1:3000//signup' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0LCJleHAiOjE3MzEzMjM3MTZ9.3P-mjuIPN7p6ZE-TOf1s5tLiRttJYVvIDjNo5LJJsr4' \
--header 'Content-Type: application/json' \
--data '{"user": {
    "first_name": "test",
    "last_name": "user",
    "email": "test@example.com",
    "password": "password123"
}}'
#response
{
    "message": "User created successfully"
}
```
- Login
```bash
curl --location 'http://127.0.0.1:3000//login' \
--header 'Content-Type: application/json' \
--data-raw '{
    "user":{
    "email": "test@example.com",
    "password": "password123"
}}'
# response 
{
    "token": "<jwt-token>",
    "message": "Login successful"
}

```

### Team Management
- Create Team
```bash
curl --location 'http://127.0.0.1:3000//teams' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.v1e2wGEBpr7c2wJLJl2WGSrpccjUTwAtcqFS0bLqLq8' \
--header 'Content-Type: application/json' \
--data '{"team": {
    "name": "team A",
    "description": "test team a",
    "owner": 1
}}'

# response
{
    "id": 1,
    "name": "team A",
    "description": "test team a",
    "owner_id": 1,
    "created_at": "2024-11-10T16:14:32.688Z",
    "updated_at": "2024-11-10T16:14:32.688Z"
}
```

- View team
```bash
curl --location --request GET 'http://127.0.0.1:3000//teams/1' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.v1e2wGEBpr7c2wJLJl2WGSrpccjUTwAtcqFS0bLqLq8' \
--header 'Content-Type: application/json'

# response
{
    "id": 1,
    "name": "team A",
    "description": "test team a",
    "owner_id": 1,
    "created_at": "2024-11-10T16:14:32.688Z",
    "updated_at": "2024-11-10T16:14:32.688Z",
    "users": []
}
```

- Update Team
```bash
curl --location --request PUT 'http://127.0.0.1:3000//teams/2' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.v1e2wGEBpr7c2wJLJl2WGSrpccjUTwAtcqFS0bLqLq8' \
--header 'Content-Type: application/json' \
--data '{"team": {
    "description": "updated test team a"
}}'

# response
{
    "description": "updated test team a",
    "owner_id": 1,
    "id": 1,
    "name": "team A",
    "created_at": "2024-11-10T16:14:32.688Z",
    "updated_at": "2024-11-10T16:49:18.963Z"
}
```
- Delete Team
```bash
curl --location --request DELETE 'http://127.0.0.1:3000//teams/1' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.v1e2wGEBpr7c2wJLJl2WGSrpccjUTwAtcqFS0bLqLq8' \
--header 'Content-Type: application/json'
```

- List all teams
```bash
curl --location --request GET 'http://127.0.0.1:3000//teams' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.v1e2wGEBpr7c2wJLJl2WGSrpccjUTwAtcqFS0bLqLq8' \
--header 'Content-Type: application/json'

# response
[
    {
        "id": 1,
        "name": "team1",
        "description": "team owned by 10",
        "owner_id": 1,
        "created_at": "2024-11-09T12:38:37.031Z",
        "updated_at": "2024-11-09T12:38:37.031Z",
        "users": []
    },
    {
        "id": 2,
        "name": "team A",
        "description": "updated test team b",
        "owner_id": 1,
        "created_at": "2024-11-10T16:14:32.688Z",
        "updated_at": "2024-11-10T16:49:18.963Z",
        "users": []
    }
]
```

### Member Management
- Add member to a team
```bash
curl --location 'http://127.0.0.1:3000//teams/2/team_members' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.v1e2wGEBpr7c2wJLJl2WGSrpccjUTwAtcqFS0bLqLq8' \
--header 'Content-Type: application/json' \
--data '{"user_id": 1}'
# response
{
    "message": "User added to the team"
}

```
- Remove member from team
```bash
curl --location --request DELETE 'http://127.0.0.1:3000//teams/3/team_members/1' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.v1e2wGEBpr7c2wJLJl2WGSrpccjUTwAtcqFS0bLqLq8' \
--header 'Content-Type: application/json'
```

- List all Team Member
```bash
curl --location --request GET 'http://127.0.0.1:3000//teams/4/team_members' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.v1e2wGEBpr7c2wJLJl2WGSrpccjUTwAtcqFS0bLqLq8' \
--header 'Content-Type: application/json' 
# response
[
    {
        "id": 1,
        "first_name": "John",
        "last_name": "Doe",
        "email": "john@example.com@example.com"
    }
]
```

- Filter Team member by last name
```bash
curl --location --request GET 'http://127.0.0.1:3000//teams/4/team_members?last_name=Doe' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.v1e2wGEBpr7c2wJLJl2WGSrpccjUTwAtcqFS0bLqLq8' \
--header 'Content-Type: application/json' 
```

- View Member Details
```bash
curl --location --request GET 'http://127.0.0.1:3000//teams/4/team_members/1' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.v1e2wGEBpr7c2wJLJl2WGSrpccjUTwAtcqFS0bLqLq8' \
--header 'Content-Type: application/json'
```

### 