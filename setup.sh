#!/usr/bin/env bash
set -e

echo "🎓 Gate School — Setup"
echo "======================"

# ============ FOLDERS ============
mkdir -p public
mkdir -p src/components
mkdir -p src/pages
mkdir -p src/context
mkdir -p src/hooks
mkdir -p src/i18n
mkdir -p src/utils
mkdir -p src/content/id/level-1
mkdir -p src/content/id/level-2
mkdir -p src/content/id/level-3
mkdir -p src/content/id/level-4
mkdir -p src/content/id/level-5
mkdir -p src/content/en/level-1
mkdir -p src/content/en/level-2
mkdir -p src/content/en/level-3
mkdir -p src/content/en/level-4
mkdir -p src/content/en/level-5
mkdir -p .github/workflows

echo "📁 Folders created"

# ============ package.json ============
cat > package.json << 'GATE_EOF'
{
  "name": "gate-school",
  "private": true,
  "version": "1.0.0",
  "type": "module",
  "description": "Sekolah Prompt AI — bilingual, interaktif, open source.",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "react-router-dom": "^6.26.2",
    "marked": "^14.1.2",
    "highlight.js": "^11.10.0"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.3.1",
    "vite": "^5.4.8"
  }
}
GATE_EOF

# ============ vite.config.js ============
cat > vite.config.js << 'GATE_EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  base: '/gate-school/',
  build: { outDir: 'dist', assetsInlineLimit: 4096 },
})
GATE_EOF

# ============ index.html ============
cat > index.html << 'GATE_EOF'
<!DOCTYPE html>
<html lang="id">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover" />
    <meta name="theme-color" content="#000000" />
    <meta name="description" content="Gate School — Sekolah Prompt AI bilingual. Belajar prompting dari nol sampai master. Gratis, interaktif, open source." />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
    <meta name="apple-mobile-web-app-title" content="Gate School" />
    <meta property="og:title" content="Gate School — Prompt Mastery" />
    <meta property="og:description" content="Belajar prompting AI dari nol sampai master. Bilingual ID/EN." />
    <link rel="apple-touch-icon" href="/logo.svg" />
    <link rel="manifest" href="/manifest.json" />
    <title>Gate School — Prompt Mastery</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
GATE_EOF

# ============ public/manifest.json ============
cat > public/manifest.json << 'GATE_EOF'
{
  "name": "Gate School — Prompt Mastery",
  "short_name": "Gate School",
  "description": "Sekolah Prompt AI bilingual. Dari nol sampai master.",
  "start_url": "/gate-school/",
  "scope": "/gate-school/",
  "display": "standalone",
  "background_color": "#000000",
  "theme_color": "#000000",
  "orientation": "portrait",
  "lang": "id",
  "icons": [
    { "src": "/gate-school/logo.svg", "sizes": "any", "type": "image/svg+xml", "purpose": "any maskable" }
  ]
}
GATE_EOF

# ============ public/logo.svg ============
cat > public/logo.svg << 'GATE_EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" fill="none">
  <defs>
    <linearGradient id="gs" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="#ffffff"/>
      <stop offset="100%" stop-color="#a0a0a0"/>
    </linearGradient>
  </defs>
  <rect width="512" height="512" rx="112" fill="#000000"/>
  <path d="M140 140 L140 372 L256 372 L256 300 L216 300 L216 268 L280 268 L280 372 L372 372 L372 140 L140 140 Z M216 216 L296 216 L296 244 L216 244 L216 216 Z" fill="url(#gs)"/>
</svg>
GATE_EOF

# ============ public/favicon.svg ============
cat > public/favicon.svg << 'GATE_EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
  <rect width="512" height="512" rx="112" fill="#000000"/>
  <path d="M140 140 L140 372 L256 372 L256 300 L216 300 L216 268 L280 268 L280 372 L372 372 L372 140 L140 140 Z M216 216 L296 216 L296 244 L216 244 L216 216 Z" fill="#ffffff"/>
</svg>
GATE_EOF

# ============ public/sw.js ============
cat > public/sw.js << 'GATE_EOF'
const CACHE = 'gate-school-v1'
const PRECACHE = ['/gate-school/','/gate-school/index.html','/gate-school/manifest.json','/gate-school/logo.svg','/gate-school/favicon.svg']
self.addEventListener('install', (e) => {
  e.waitUntil(caches.open(CACHE).then((c) => c.addAll(PRECACHE).catch(() => {})))
  self.skipWaiting()
})
self.addEventListener('activate', (e) => {
  e.waitUntil(caches.keys().then((keys) => Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k)))))
  self.clients.claim()
})
self.addEventListener('fetch', (e) => {
  const { request } = e
  if (request.method !== 'GET') return
  if (!request.url.startsWith(self.location.origin)) return
  e.respondWith(
    caches.match(request).then((cached) => {
      const fetchPromise = fetch(request).then((res) => {
        if (res && res.status === 200 && res.type === 'basic') {
          const clone = res.clone()
          caches.open(CACHE).then((c) => c.put(request, clone))
        }
        return res
      }).catch(() => cached)
      return cached || fetchPromise
    })
  )
})
GATE_EOF

# ============ src/main.jsx ============
cat > src/main.jsx << 'GATE_EOF'
import React from 'react'
import ReactDOM from 'react-dom/client'
import { BrowserRouter } from 'react-router-dom'
import App from './App.jsx'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <BrowserRouter basename="/gate-school">
      <App />
    </BrowserRouter>
  </React.StrictMode>
)

if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/gate-school/sw.js', { scope: '/gate-school/' }).catch(() => {})
  })
}
GATE_EOF

echo "✅ Config files done"
