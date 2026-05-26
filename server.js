require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 4000;
const USERS_FILE = path.join(__dirname, 'users.json');
const JWT_SECRET = process.env.JWT_SECRET || 'supersecretkey';
const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || '1h';

app.use(bodyParser.json());

function loadUsers() {
  if (!fs.existsSync(USERS_FILE)) {
    return [];
  }
  const raw = fs.readFileSync(USERS_FILE, 'utf8');
  try {
    return JSON.parse(raw);
  } catch (err) {
    return [];
  }
}

function saveUsers(users) {
  fs.writeFileSync(USERS_FILE, JSON.stringify(users, null, 2), 'utf8');
}

app.post('/register', async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ error: 'Email and password are required.' });
  }

  const users = loadUsers();
  if (users.some((user) => user.email === email)) {
    return res.status(409).json({ error: 'Email already registered.' });
  }

  const hashedPassword = await bcrypt.hash(password, 10);
  const newUser = { id: Date.now(), email, password: hashedPassword };
  users.push(newUser);
  saveUsers(users);

  return res.status(201).json({ message: 'User registered successfully.' });
});

app.post('/login', async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ error: 'Email and password are required.' });
  }

  const users = loadUsers();
  const user = users.find((u) => u.email === email);
  if (!user) {
    return res.status(401).json({ error: 'Invalid credentials.' });
  }

  const validPassword = await bcrypt.compare(password, user.password);
  if (!validPassword) {
    return res.status(401).json({ error: 'Invalid credentials.' });
  }

  const token = jwt.sign({ userId: user.id, email: user.email }, JWT_SECRET, {
    expiresIn: JWT_EXPIRES_IN,
  });

  return res.json({ token, expiresIn: JWT_EXPIRES_IN, tokenType: 'Bearer' });
});

function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  if (!token) {
    return res.status(401).json({ error: 'No token provided.' });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Invalid or expired token.' });
    }
    req.user = user;
    next();
  });
}

app.get('/profile', authenticateToken, (req, res) => {
  res.json({ message: 'Authenticated request successful.', user: req.user });
});

app.listen(PORT, () => {
  console.log(`Auth app running on http://localhost:${PORT}`);
});
