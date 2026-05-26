# Auth App

Simple Node.js authentication app with registration, login, and JWT-protected profile route.

## Setup

1. Open a terminal in `C:\Users\robin\BALKANMOD\auth-app`
2. Run `npm install`
3. Start the app with `npm start`

### One-line Termux installer

If you want to download the Termux helper script directly, use:

```bash
curl -fsSL https://raw.githubusercontent.com/BALKANMOD/auth-app/master/termux-auth.sh -o termux-auth.sh && chmod +x termux-auth.sh
```

Or use the quick-start script to install, register, and login in one command:

```bash
curl -fsSL https://raw.githubusercontent.com/BALKANMOD/auth-app/master/termux-quickstart.sh -o termux-quickstart.sh && chmod +x termux-quickstart.sh
./termux-quickstart.sh 10.0.2.2 user@example.com secret
```

Then run:

```bash
TERMUX_SERVER_URL=http://<server-ip>:4000 ./termux-auth.sh login user@example.com secret
```

> If you are running Termux inside MEmu, the emulator host usually maps to `10.0.2.2`.

### Termux usage

- Set the server URL for your PC or server:
  ```bash
  export TERMUX_SERVER_URL=http://<server-ip>:4000
  ```
  If you are in MEmu, try:
  ```bash
  export TERMUX_SERVER_URL=http://10.0.2.2:4000
  ```
- Register a user:
  ```bash
  ./termux-auth.sh register user@example.com secret
  ```
- Login and receive a token and refresh token:
  ```bash
  ./termux-auth.sh login user@example.com secret
  ```
- Use the refresh token to get a new access token:
  ```bash
  ./termux-auth.sh refresh <refreshToken>
  ```
- Call the protected profile endpoint:
  ```bash
  ./termux-auth.sh profile <token>
  ```

## Environment

You can set a custom JWT secret with `JWT_SECRET`, a custom expiration with `JWT_EXPIRES_IN`, and refresh token settings with `REFRESH_TOKEN_SECRET` and `REFRESH_TOKEN_EXPIRES_IN`.

Create a `.env` file from `.env.example` and set:

- `PORT`
- `JWT_SECRET`
- `REFRESH_TOKEN_SECRET`
- `JWT_EXPIRES_IN`
- `REFRESH_TOKEN_EXPIRES_IN`

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
