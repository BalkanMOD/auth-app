# Auth App

Simple Node.js authentication app with registration, login, and JWT-protected profile route.

## Setup

1. Open a terminal in `C:\Users\robin\auth-app`
2. Run `npm install`
3. Start the app with `npm start`

## Environment

You can set a custom JWT secret with `JWT_SECRET` and a custom expiration with `JWT_EXPIRES_IN`.

## Environment

Create a `.env` file from `.env.example` and set:

- `PORT`
- `JWT_SECRET`
- `JWT_EXPIRES_IN`

Example:

```env
PORT=4000
JWT_SECRET=your_strong_secret_here
JWT_EXPIRES_IN=1h
```

## API Endpoints

- `POST /register`
  - body: `{ "email": "user@example.com", "password": "secret" }`
- `POST /login`
  - body: `{ "email": "user@example.com", "password": "secret" }`
- `GET /profile`
  - header: `Authorization: Bearer <token>`

## Notes

This example uses a local `users.json` file for storage and is intended for learning and prototyping.
