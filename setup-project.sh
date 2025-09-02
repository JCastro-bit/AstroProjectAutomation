#!/bin/bash

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Función para logging
log() {
    echo -e "${GREEN}[SETUP]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Verificar argumentos
if [ $# -eq 0 ]; then
    echo "Uso: ./setup-project.sh <nombre-proyecto>"
    exit 1
fi

PROJECT_NAME=$1

log "🚀 Iniciando setup para: $PROJECT_NAME"

# 1. Crear proyecto base
log "📦 Creando proyecto Astro..."
npx create-astro@latest $PROJECT_NAME --template with-tailwindcss --install --add react

cd $PROJECT_NAME

# 2. Instalar dependencias adicionales
log "📚 Instalando dependencias comunes..."
npm install astro-robots-txt @fontsource/inter @heroicons/react clsx tailwind-merge

# 3. Añadir sitemap
log "🗺️ Añadiendo sitemap..."
npx astro add sitemap --yes

# 4. Instalar dependencias de desarrollo
log "🛠️ Instalando dev dependencies..."
npm install -D @types/node prettier prettier-plugin-astro prettier-plugin-tailwindcss

# 5. Crear estructura de carpetas
log "📁 Creando estructura de carpetas..."
mkdir -p src/{components/{ui,layout,sections},lib,styles,types,data}
mkdir -p public/{images,icons}
mkdir -p scripts

# 6. Crear archivos base
log "📄 Creando archivos de configuración..."

# Prettier config
cat > .prettierrc << 'EOF'
{
  "semi": false,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 80,
  "plugins": ["prettier-plugin-astro", "prettier-plugin-tailwindcss"],
  "overrides": [
    {
      "files": "*.astro",
      "options": {
        "parser": "astro"
      }
    }
  ]
}
EOF

# VSCode settings
mkdir -p .vscode
cat > .vscode/settings.json << 'EOF'
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "[astro]": {
    "editor.defaultFormatter": "astro-build.astro-vscode"
  },
  "emmet.includeLanguages": {
    "astro": "html"
  }
}
EOF

# TypeScript config update
cat > tsconfig.json << 'EOF'
{
  "extends": "astro/tsconfigs/strict",
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@/components/*": ["./src/components/*"],
      "@/lib/*": ["./src/lib/*"],
      "@/types/*": ["./src/types/*"],
      "@/data/*": ["./src/data/*"]
    }
  }
}
EOF

# 7. Crear script de componentes
log "🎨 Creando script de componentes..."
cat > scripts/create-components.cjs << 'EOF'
const fs = require('fs').promises
const path = require('path')

const components = {
  // Layout Components
  'src/components/layout/Navbar.astro': `---
export interface Props {
  transparent?: boolean;
}

const { transparent = false } = Astro.props;
---

<nav class:list={[
  "fixed top-0 w-full z-50 transition-all duration-300",
  transparent ? "bg-transparent" : "bg-white shadow-sm"
]}>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex justify-between items-center h-16">
      <div class="flex-shrink-0">
        <a href="/" class="text-xl font-bold">
          Logo
        </a>
      </div>
      
      <div class="hidden md:block">
        <div class="ml-10 flex items-baseline space-x-4">
          <a href="/" class="px-3 py-2 rounded-md text-sm font-medium text-gray-700 hover:text-blue-600 transition-colors">Inicio</a>
          <a href="/servicios" class="px-3 py-2 rounded-md text-sm font-medium text-gray-700 hover:text-blue-600 transition-colors">Servicios</a>
          <a href="/nosotros" class="px-3 py-2 rounded-md text-sm font-medium text-gray-700 hover:text-blue-600 transition-colors">Nosotros</a>
          <a href="/contacto" class="px-3 py-2 rounded-md text-sm font-medium text-gray-700 hover:text-blue-600 transition-colors">Contacto</a>
        </div>
      </div>
      
      <div class="md:hidden">
        <button id="mobile-menu-button" class="p-2">
          <span class="sr-only">Abrir menú</span>
          <!-- Ícono hamburguesa -->
        </button>
      </div>
    </div>
  </div>
</nav>`,

  'src/components/layout/Footer.astro': `---
const currentYear = new Date().getFullYear();
---

<footer class="bg-gray-900 text-white">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
    <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
      <div class="col-span-1 md:col-span-2">
        <h3 class="text-xl font-bold mb-4">Tu Empresa</h3>
        <p class="text-gray-300 mb-4">
          Descripción breve de tu empresa y servicios.
        </p>
      </div>
      
      <div>
        <h4 class="font-semibold mb-4">Enlaces</h4>
        <ul class="space-y-2">
          <li><a href="/" class="text-gray-300 hover:text-white">Inicio</a></li>
          <li><a href="/servicios" class="text-gray-300 hover:text-white">Servicios</a></li>
          <li><a href="/contacto" class="text-gray-300 hover:text-white">Contacto</a></li>
        </ul>
      </div>
      
      <div>
        <h4 class="font-semibold mb-4">Contacto</h4>
        <ul class="space-y-2 text-gray-300">
          <li>📧 email@empresa.com</li>
          <li>📱 +52 33 1234 5678</li>
          <li>📍 Guadalajara, Jalisco</li>
        </ul>
      </div>
    </div>
    
    <div class="border-t border-gray-800 mt-8 pt-8 text-center text-gray-300">
      <p>&copy; {currentYear} Tu Empresa. Todos los derechos reservados.</p>
    </div>
  </div>
</footer>`,

  'src/components/sections/Hero.astro': `---
export interface Props {
  title: string;
  subtitle?: string;
  ctaText?: string;
  ctaLink?: string;
  image?: string;
}

const { 
  title, 
  subtitle, 
  ctaText = "Comenzar", 
  ctaLink = "/contacto",
  image 
} = Astro.props;
---

<section class="relative min-h-screen flex items-center justify-center overflow-hidden">
  {image && (
    <div class="absolute inset-0 z-0">
      <img 
        src={image} 
        alt="Hero background" 
        class="w-full h-full object-cover"
      />
      <div class="absolute inset-0 bg-black/50"></div>
    </div>
  )}
  
  <div class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
    <h1 class="text-4xl md:text-6xl font-bold mb-6 text-gray-900">
      {title}
    </h1>
    
    {subtitle && (
      <p class="text-xl md:text-2xl mb-8 text-gray-700 max-w-3xl mx-auto">
        {subtitle}
      </p>
    )}
    
    <a 
      href={ctaLink}
      class="inline-block bg-blue-600 hover:bg-blue-700 text-white font-semibold py-3 px-8 rounded-lg transition-colors"
    >
      {ctaText}
    </a>
  </div>
</section>`,

  'src/components/ui/Button.astro': `---
export interface Props extends astroHTML.JSX.ButtonHTMLAttributes {
  variant?: 'primary' | 'secondary' | 'outline';
  size?: 'sm' | 'md' | 'lg';
}

const { 
  variant = 'primary', 
  size = 'md', 
  class: className,
  ...props 
} = Astro.props;

const baseClasses = 'inline-flex items-center justify-center font-medium rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2';

const variants = {
  primary: 'bg-blue-600 hover:bg-blue-700 text-white focus:ring-blue-500',
  secondary: 'bg-gray-600 hover:bg-gray-700 text-white focus:ring-gray-500',
  outline: 'border border-gray-300 bg-white hover:bg-gray-50 text-gray-700 focus:ring-blue-500'
};

const sizes = {
  sm: 'px-3 py-2 text-sm',
  md: 'px-4 py-2 text-base',
  lg: 'px-6 py-3 text-lg'
};

const classes = [
  baseClasses,
  variants[variant],
  sizes[size],
  className
].filter(Boolean).join(' ');
---

<button class={classes} {...props}>
  <slot />
</button>`,

  'src/lib/utils.ts': `import { type ClassValue, clsx } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function formatDate(date: Date | string): string {
  return new Intl.DateTimeFormat('es-ES', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  }).format(new Date(date))
}

export function slugify(text: string): string {
  return text
    .toString()
    .toLowerCase()
    .trim()
    .replace(/\\s+/g, '-')
    .replace(/[^\\w\\-]+/g, '')
    .replace(/\\-\\-+/g, '-')
    .replace(/^-+/, '')
    .replace(/-+$/, '')
}`,

  'src/types/index.ts': `export interface ContactForm {
  name: string
  email: string
  phone?: string
  message: string
}

export interface Project {
  id: string
  title: string
  description: string
  image: string
  tags: string[]
  url?: string
  github?: string
}

export interface Testimonial {
  id: string
  name: string
  role: string
  content: string
  avatar?: string
  rating: number
}`,

  'src/layouts/Layout.astro': `---
import '../styles/global.css'
import '@fontsource/inter/400.css'
import '@fontsource/inter/500.css'
import '@fontsource/inter/600.css'
import '@fontsource/inter/700.css'

export interface Props {
  title: string
  description?: string
  image?: string
  noIndex?: boolean
}

const {
  title,
  description = 'Descripción por defecto',
  image = '/images/og-image.jpg',
  noIndex = false
} = Astro.props

const canonicalURL = new URL(Astro.url.pathname, Astro.site)
---

<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="UTF-8" />
    <meta name="description" content={description} />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
    <meta name="generator" content={Astro.generator} />
    <link rel="canonical" href={canonicalURL} />
    
    <!-- Open Graph -->
    <meta property="og:type" content="website" />
    <meta property="og:url" content={Astro.url} />
    <meta property="og:title" content={title} />
    <meta property="og:description" content={description} />
    <meta property="og:image" content={new URL(image, Astro.url)} />
    
    <!-- Twitter -->
    <meta property="twitter:card" content="summary_large_image" />
    <meta property="twitter:url" content={Astro.url} />
    <meta property="twitter:title" content={title} />
    <meta property="twitter:description" content={description} />
    <meta property="twitter:image" content={new URL(image, Astro.url)} />
    
    {noIndex && <meta name="robots" content="noindex, nofollow" />}
    
    <title>{title}</title>
  </head>
  <body class="min-h-screen bg-white text-gray-900 font-sans antialiased">
    <slot />
  </body>
</html>

<style is:global>
  html {
    font-family: 'Inter', system-ui, sans-serif;
  }
</style>`
}

async function createComponents() {
  console.log('🎨 Creando componentes base...')
  
  for (const [filePath, content] of Object.entries(components)) {
    const dir = path.dirname(filePath)
    await fs.mkdir(dir, { recursive: true })
    await fs.writeFile(filePath, content)
    console.log(`✅ Creado: ${filePath}`)
  }
  
  console.log('🎉 Componentes base creados exitosamente!')
}

createComponents().catch(console.error)
EOF

# 8. Añadir script al package.json
log "📝 Actualizando package.json..."
npm pkg set scripts.setup-components="node scripts/create-components.cjs"
npm pkg set scripts.format="prettier --write ."

# 9. Actualizar astro.config.mjs para añadir robots-txt y alias
log "⚙️ Configurando Astro..."
cat > astro.config.mjs << 'EOF'
// @ts-check
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';
import react from '@astrojs/react';
import sitemap from '@astrojs/sitemap';
import robotsTxt from 'astro-robots-txt';

// https://astro.build/config
export default defineConfig({
  site: 'https://tu-dominio.com',
  vite: {
    plugins: [tailwindcss()],
    resolve: {
      alias: {
        '@': '/src',
      },
    },
  },
  integrations: [react(), sitemap(), robotsTxt()]
});
EOF

# 10. Crear página de inicio personalizada
log "🏠 Creando página de inicio..."
cat > src/pages/index.astro << EOF
---
import Layout from '@/layouts/Layout.astro';
import Navbar from '@/components/layout/Navbar.astro';
import Hero from '@/components/sections/Hero.astro';
import Footer from '@/components/layout/Footer.astro';

const projectName = '$PROJECT_NAME';
---

<Layout title={projectName} description="Proyecto creado con Astro y Tailwind CSS">
  <Navbar transparent />
  
  <Hero 
    title={projectName}
    subtitle="Proyecto creado con Astro + React + Tailwind CSS"
    ctaText="Ver Componentes"
    ctaLink="#componentes"
  />
  
  <main id="componentes" class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
    <div class="text-center">
      <h2 class="text-3xl font-bold mb-8">Componentes Disponibles</h2>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
        <div class="p-6 border rounded-lg">
          <h3 class="text-xl font-semibold mb-4">Layout</h3>
          <p class="text-gray-600">Navbar y Footer listos para usar</p>
        </div>
        <div class="p-6 border rounded-lg">
          <h3 class="text-xl font-semibold mb-4">Secciones</h3>
          <p class="text-gray-600">Hero y componentes de secciones</p>
        </div>
        <div class="p-6 border rounded-lg">
          <h3 class="text-xl font-semibold mb-4">UI</h3>
          <p class="text-gray-600">Botones y elementos reutilizables</p>
        </div>
      </div>
    </div>
  </main>
  
  <Footer />
</Layout>
EOF

log "✅ Setup completado para: $PROJECT_NAME"
info "📂 Estructura creada exitosamente"
echo ""
warn "🔧 Siguientes pasos:"
echo -e "${BLUE}   cd $PROJECT_NAME${NC}"
echo -e "${BLUE}   npm run setup-components${NC}"
echo -e "${BLUE}   npm run dev${NC}"