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
          <a href="/" class="nav-link">Inicio</a>
          <a href="/servicios" class="nav-link">Servicios</a>
          <a href="/nosotros" class="nav-link">Nosotros</a>
          <a href="/contacto" class="nav-link">Contacto</a>
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
</nav>

<style>
  .nav-link {
    @apply px-3 py-2 rounded-md text-sm font-medium text-gray-700 hover:text-blue-600 transition-colors;
  }
</style>`,

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
    <h1 class="text-4xl md:text-6xl font-bold mb-6 text-white">
      {title}
    </h1>
    
    {subtitle && (
      <p class="text-xl md:text-2xl mb-8 text-gray-200 max-w-3xl mx-auto">
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
}`
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