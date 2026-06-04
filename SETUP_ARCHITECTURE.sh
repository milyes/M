#!/bin/bash

# 🚀 LearnLinkc Multi-Platform Architecture Setup Script
# Cette script crée toute la structure du projet automatiquement

set -e  # Exit on error

echo "🎯 LearnLinkc - Architecture Multi-Plateforme Setup"
echo "=================================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Create new branch
echo -e "${BLUE}📍 Étape 1: Créer la branche refactor/multi-platform-architecture${NC}"
git checkout -b refactor/multi-platform-architecture 2>/dev/null || git checkout refactor/multi-platform-architecture
echo -e "${GREEN}✅ Branche créée/sélectionnée${NC}"
echo ""

# Step 2: Create directory structure
echo -e "${BLUE}📍 Étape 2: Créer la structure des dossiers${NC}"
mkdir -p backend/src
mkdir -p frontend/src
mkdir -p mobile/src
mkdir -p desktop/src
mkdir -p docs
mkdir -p .github/workflows
echo -e "${GREEN}✅ Dossiers créés${NC}"
echo ""

# Step 3: Create root package.json
echo -e "${BLUE}📍 Étape 3: Créer package.json (root)${NC}"
cat > package.json << 'EOF'
{
  "name": "learnlinkc-monorepo",
  "version": "1.0.0",
  "description": "LearnLinkc - Multi-platform Educational Platform",
  "private": true,
  "workspaces": [
    "backend",
    "frontend",
    "mobile",
    "desktop"
  ],
  "scripts": {
    "install-all": "yarn install",
    "dev": "yarn workspaces foreach -p run dev",
    "build": "yarn workspaces foreach run build",
    "test": "yarn workspaces foreach run test",
    "lint": "yarn workspaces foreach run lint"
  },
  "devDependencies": {
    "concurrently": "^8.2.0"
  },
  "engines": {
    "node": ">=18.0.0",
    "yarn": ">=3.6.0"
  }
}
EOF
echo -e "${GREEN}✅ package.json créé${NC}"
echo ""

# Step 4: Create backend files
echo -e "${BLUE}📍 Étape 4: Créer les fichiers Backend${NC}"

cat > backend/package.json << 'EOF'
{
  "name": "learnlinkc-backend",
  "version": "1.0.0",
  "description": "LearnLinkc Backend API",
  "main": "src/server.js",
  "scripts": {
    "dev": "nodemon src/server.js",
    "build": "echo 'Backend build complete'",
    "start": "node src/server.js",
    "test": "jest",
    "lint": "eslint src/"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "dotenv": "^16.3.1",
    "pg": "^8.11.3",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.1.2",
    "joi": "^17.11.0"
  },
  "devDependencies": {
    "nodemon": "^3.0.1",
    "eslint": "^8.53.0",
    "jest": "^29.7.0"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
EOF

cat > backend/.env.example << 'EOF'
PORT=3000
NODE_ENV=development
DATABASE_URL=postgresql://user:password@localhost:5432/learnlinkc
JWT_SECRET=your_jwt_secret_key_here
JWT_EXPIRE=7d
EOF

cat > backend/src/server.js << 'EOF'
const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'LearnLinkc Backend is running' });
});

// Courses endpoint
app.get('/api/courses', (req, res) => {
  res.json({
    courses: [
      { id: 1, title: 'JavaScript Basics', category: 'Programming' },
      { id: 2, title: 'React Advanced', category: 'Frontend' }
    ]
  });
});

// Error handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Internal Server Error' });
});

app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});
EOF

echo -e "${GREEN}✅ Fichiers Backend créés${NC}"
echo ""

# Step 5: Create frontend files
echo -e "${BLUE}📍 Étape 5: Créer les fichiers Frontend${NC}"

cat > frontend/package.json << 'EOF'
{
  "name": "learnlinkc-frontend",
  "version": "1.0.0",
  "description": "LearnLinkc Web Frontend",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "lint": "eslint src/"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.18.0",
    "axios": "^1.6.2",
    "zustand": "^4.4.1"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.2.0",
    "vite": "^5.0.2",
    "tailwindcss": "^3.3.6",
    "postcss": "^8.4.31",
    "autoprefixer": "^10.4.16",
    "eslint": "^8.53.0"
  }
}
EOF

cat > frontend/vite.config.js << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3001,
    open: true
  }
})
EOF

cat > frontend/src/App.jsx << 'EOF'
import React, { useState, useEffect } from 'react';
import axios from 'axios';

function App() {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchCourses = async () => {
      try {
        const response = await axios.get('http://localhost:3000/api/courses');
        setCourses(response.data.courses);
      } catch (error) {
        console.error('Error fetching courses:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchCourses();
  }, []);

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-600 to-purple-600">
      <nav className="bg-white shadow-lg">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <h1 className="text-3xl font-bold text-gray-800">📚 LearnLinkc</h1>
        </div>
      </nav>

      <main className="max-w-7xl mx-auto px-4 py-8">
        <h2 className="text-2xl font-bold text-white mb-6">Explore Courses</h2>

        {loading ? (
          <div className="text-white text-center">Loading courses...</div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {courses.map(course => (
              <div key={course.id} className="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition">
                <h3 className="text-xl font-semibold text-gray-800">{course.title}</h3>
                <p className="text-gray-600 mt-2">Category: {course.category}</p>
                <button className="mt-4 w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700">
                  View Course
                </button>
              </div>
            ))}
          </div>
        )}
      </main>
    </div>
  );
}

export default App;
EOF

echo -e "${GREEN}✅ Fichiers Frontend créés${NC}"
echo ""

# Step 6: Create mobile files
echo -e "${BLUE}📍 Étape 6: Créer les fichiers Mobile${NC}"

cat > mobile/package.json << 'EOF'
{
  "name": "learnlinkc-mobile",
  "version": "1.0.0",
  "description": "LearnLinkc Mobile App (React Native)",
  "main": "node_modules/expo/AppEntry.js",
  "scripts": {
    "dev": "expo start",
    "build": "eas build",
    "android": "expo start --android",
    "ios": "expo start --ios",
    "web": "expo start --web"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-native": "^0.72.0",
    "expo": "^50.0.0",
    "expo-router": "^2.0.0",
    "axios": "^1.6.2"
  },
  "devDependencies": {
    "@types/react": "^18.2.0"
  }
}
EOF

cat > mobile/src/App.tsx << 'EOF'
import React from 'react';
import { View, Text, StyleSheet, ScrollView } from 'react-native';

export default function App() {
  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>📚 LearnLinkc</Text>
      </View>
      
      <ScrollView style={styles.content}>
        <Text style={styles.subtitle}>Explore Courses</Text>
        {/* Courses will be rendered here */}
        <Text style={styles.placeholder}>Loading courses...</Text>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  header: {
    backgroundColor: '#2563eb',
    paddingVertical: 20,
    paddingHorizontal: 16,
    marginTop: 40,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#fff',
  },
  content: {
    flex: 1,
    padding: 16,
  },
  subtitle: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 16,
    color: '#333',
  },
  placeholder: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
  },
});
EOF

echo -e "${GREEN}✅ Fichiers Mobile créés${NC}"
echo ""

# Step 7: Create desktop files
echo -e "${BLUE}📍 Étape 7: Créer les fichiers Desktop${NC}"

cat > desktop/package.json << 'EOF'
{
  "name": "learnlinkc-desktop",
  "version": "1.0.0",
  "description": "LearnLinkc Desktop App (Electron)",
  "main": "src/main.js",
  "scripts": {
    "dev": "electron-dev .",
    "build": "electron-builder"
  },
  "dependencies": {
    "electron-squirrel-startup": "^1.1.0"
  },
  "devDependencies": {
    "electron": "^27.0.0",
    "electron-builder": "^24.6.4",
    "electron-dev": "^1.0.1"
  },
  "build": {
    "appId": "com.learnlinkc.desktop",
    "productName": "LearnLinkc",
    "files": [
      "src/**/*",
      "node_modules/**/*"
    ]
  }
}
EOF

cat > desktop/src/main.js << 'EOF'
const { app, BrowserWindow } = require('electron');
const path = require('path');

function createWindow() {
  const mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      nodeIntegration: false
    }
  });

  if (process.env.NODE_ENV === 'development') {
    mainWindow.loadURL('http://localhost:3001');
    mainWindow.webContents.openDevTools();
  } else {
    mainWindow.loadFile('build/index.html');
  }
}

app.on('ready', createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) createWindow();
});
EOF

echo -e "${GREEN}✅ Fichiers Desktop créés${NC}"
echo ""

# Step 8: Create Docker files
echo -e "${BLUE}📍 Étape 8: Créer les fichiers Docker${NC}"

cat > Dockerfile << 'EOF'
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY backend ./backend

WORKDIR /app/backend

EXPOSE 3000

CMD ["npm", "start"]
EOF

cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  backend:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://postgres:password@db:5432/learnlinkc
    depends_on:
      - db
    volumes:
      - ./backend:/app/backend

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
      POSTGRES_DB: learnlinkc
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  frontend:
    image: node:18-alpine
    working_dir: /app/frontend
    ports:
      - "3001:3001"
    volumes:
      - ./frontend:/app/frontend
    command: sh -c "npm install && npm run dev"

volumes:
  postgres_data:
EOF

echo -e "${GREEN}✅ Fichiers Docker créés${NC}"
echo ""

# Step 9: Create GitHub Actions CI/CD
echo -e "${BLUE}📍 Étape 9: Créer le pipeline CI/CD${NC}"

cat > .github/workflows/ci-cd.yml << 'EOF'
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:15-alpine
        env:
          POSTGRES_PASSWORD: postgres
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432

    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'yarn'
    
    - name: Install dependencies
      run: yarn install
    
    - name: Lint
      run: yarn lint
    
    - name: Test
      run: yarn test

  build:
    needs: test
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'yarn'
    
    - name: Install dependencies
      run: yarn install
    
    - name: Build
      run: yarn build

  docker:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2
    
    - name: Build Docker image
      uses: docker/build-push-action@v4
      with:
        context: .
        push: false
        tags: learnlinkc:latest
EOF

echo -e "${GREEN}✅ Pipeline CI/CD créé${NC}"
echo ""

# Step 10: Create documentation
echo -e "${BLUE}📍 Étape 10: Créer la documentation${NC}"

cat > docs/ARCHITECTURE.md << 'EOF'
# 🏗️ LearnLinkc - Architecture Multi-Plateforme

## Vue d'ensemble

LearnLinkc est une plateforme éducative complète conçue pour fonctionner sur 4 plateforme:
- **Web** (React + Vite)
- **Mobile** (React Native + Expo)
- **Desktop** (Electron)
- **Backend API** (Node.js + Express)

## Architecture générale

```
┌─────────────────────────────────────────────┐
│        Frontend Layer                        │
├──────────────┬──────────────┬────────────────┤
│   Web/React  │   Mobile/RN  │ Desktop/Electron
└──────────────┴──────────────┴────────────────┘
                      │
            ┌─────────┴─────────┐
            │   API Gateway     │
            │  (Express/Node)   │
            └─────────┬─────────┘
                      │
        ┌─────────────┴─────────────┐
        │   Database Layer           │
        │  (PostgreSQL + Redis)      │
        └────────────────────────────┘
```

## Technologies utilisées

### Backend
- **Node.js + Express** - Framework API
- **PostgreSQL** - Base de données relationnelle
- **Redis** - Cache et sessions
- **JWT** - Authentification
- **Joi** - Validation des données

### Frontend Web
- **React 18** - Framework UI
- **Vite** - Build tool rapide
- **Tailwind CSS** - Styling
- **Zustand** - State management
- **Axios** - HTTP client

### Mobile
- **React Native** - Framework mobile cross-platform
- **Expo** - Tooling React Native
- **TypeScript** - Type safety

### Desktop
- **Electron** - Framework desktop
- **Electron Builder** - Empaquetage

### DevOps
- **Docker** - Containerization
- **Docker Compose** - Local development
- **GitHub Actions** - CI/CD

## API Endpoints

```
GET    /api/health              # Check server status
GET    /api/courses             # Get all courses
POST   /api/courses             # Create course (admin)
GET    /api/courses/:id         # Get course details
POST   /api/auth/register       # User registration
POST   /api/auth/login          # User login
POST   /api/auth/logout         # User logout
GET    /api/user/profile        # Get user profile
POST   /api/user/favorites      # Add to favorites
GET    /api/user/favorites      # Get user favorites
```

---

**Version**: 1.0.0
**Last Updated**: June 2026
EOF

cat > docs/SETUP.md << 'EOF'
# 🚀 Guide Setup Complet - LearnLinkc

## Étape 1: Prérequis

### Installer les outils nécessaires

#### macOS
```bash
brew install node@18
brew install yarn
brew install docker
```

#### Windows
- Télécharger [Node.js 18 LTS](https://nodejs.org/)
- Télécharger [Yarn](https://yarnpkg.com/getting-started/install)
- Télécharger [Docker Desktop](https://www.docker.com/products/docker-desktop)

#### Linux (Ubuntu/Debian)
```bash
curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs yarn docker.io docker-compose
```

## Étape 2: Installation

```bash
git clone https://github.com/milyes/M.git
cd M
git checkout refactor/multi-platform-architecture
yarn install-all
```

## Étape 3: Configuration

```bash
cp backend/.env.example backend/.env
# Éditer backend/.env avec vos valeurs
```

## Étape 4: Démarrage

### Option A: Docker Compose
```bash
docker-compose up -d
```

### Option B: Manuel
```bash
# Terminal 1
cd backend && yarn dev

# Terminal 2
cd frontend && yarn dev
```

## Vérification

```bash
# Backend
curl http://localhost:3000/api/health

# Frontend
open http://localhost:3001
```

---

**Prêt à développer! 🚀**
EOF

cat > README_REFACTOR.md << 'EOF'
# 🚀 LearnLinkc - Architecture Multi-Plateforme

> **Transformation du projet vers une plateforme éducative moderne, scalable et multi-plateforme**

## 👀 Vue d'ensemble

LearnLinkc est une **plateforme éducative complète** conçue pour offrir une expérience d'apprentissage cohérente sur:

- 🌐 **Web** - React + Vite + Tailwind
- 📱 **Mobile** - React Native + Expo
- 🖥️ **Desktop** - Electron
- 🔌 **Backend API** - Node.js + Express + PostgreSQL

## 🚀 Quick Start

```bash
# Installation
git clone https://github.com/milyes/M.git && cd M
git checkout refactor/multi-platform-architecture
yarn install-all

# Configuration
cp backend/.env.example backend/.env

# Démarrage
docker-compose up -d
```

## 📊 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/health` | Check server |
| GET | `/api/courses` | List courses |
| GET | `/api/courses/:id` | Get course |
| POST | `/api/auth/register` | Register user |
| POST | `/api/auth/login` | Login user |

## 📖 Documentation

- [Architecture complète](docs/ARCHITECTURE.md)
- [Guide setup détaillé](docs/SETUP.md)

---

**Version**: 1.0.0-alpha
**Status**: 🚧 En développement
EOF

echo -e "${GREEN}✅ Documentation créée${NC}"
echo ""

# Step 11: Create .gitignore
echo -e "${BLUE}📍 Étape 11: Créer .gitignore${NC}"

cat > .gitignore << 'EOF'
# Dependencies
node_modules/
yarn.lock
package-lock.json

# Environment
.env
.env.local
.env.*.local

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Build
dist/
build/
*.prod.js

# Logs
logs/
*.log
npm-debug.log*

# Docker
.dockerignore

# Mobile
.expo/
.expo-shared/

# Desktop
dist_electron/
out/

# Database
*.db
*.sqlite
postgres_data/

# Misc
.cache/
temp/
tmp/
EOF

echo -e "${GREEN}✅ .gitignore créé${NC}"
echo ""

# Step 12: Commit and push
echo -e "${BLUE}📍 Étape 12: Committer et pousser les changements${NC}"
git add .
git commit -m "feat: add complete multi-platform architecture for LearnLinkc

- Add backend (Node.js + Express)
- Add frontend (React + Vite)
- Add mobile (React Native + Expo)
- Add desktop (Electron)
- Add Docker setup (docker-compose)
- Add CI/CD pipeline (GitHub Actions)
- Add comprehensive documentation"

git push -u origin refactor/multi-platform-architecture

echo ""
echo -e "${GREEN}✅ ====== SUCCÈS! ======${NC}"
echo ""
echo "🎉 L'architecture multi-plateforme a été créée avec succès!"
echo ""
echo -e "${YELLOW}Prochaines étapes:${NC}"
echo "1. ✅ Branche créée: refactor/multi-platform-architecture"
echo "2. ✅ Tous les fichiers poussés"
echo "3. 📝 Créer une Pull Request sur GitHub"
echo ""
echo "Pour voir vos changements:"
echo "📌 https://github.com/milyes/M/tree/refactor%2Fmulti-platform-architecture"
echo ""
echo -e "${BLUE}Commandes utiles:${NC}"
echo "  yarn install-all    # Installer toutes les dépendances"
echo "  yarn dev            # Démarrer tous les services"
echo "  docker-compose up   # Démarrer avec Docker"
echo ""
echo -e "${GREEN}Prêt à développer! 🚀${NC}"
