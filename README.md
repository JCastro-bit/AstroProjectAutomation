# Automatización de Proyectos Astro

Script de configuración rápida que reduce el setup de proyectos Astro de 30+ minutos a 2-3 minutos.

## Instalación

```bash
cd tu-carpeta-de-proyectos
git clone https://github.com/tu-usuario/astro-automation.git SetupNewProject
chmod +x SetupNewProject/setup-project.sh
```

## Uso

```bash
# Desde tu directorio de proyectos
SetupNewProject/setup-project.sh nombre-proyecto
cd nombre-proyecto
npm run setup-components
npm run dev
```

## Qué Incluye

- **Astro + React + TypeScript + Tailwind CSS**
- **Componentes listos**: Navbar, Footer, Hero, Button
- **Layout SEO optimizado** con Open Graph
- **Integraciones**: Sitemap, Robots.txt
- **Herramientas**: Prettier, VSCode settings
- **Utilidades TypeScript** y helpers

## Estructura Generada

```
proyecto/
├── src/
│   ├── components/
│   │   ├── layout/ (Navbar, Footer)
│   │   ├── sections/ (Hero)
│   │   └── ui/ (Button)
│   ├── layouts/Layout.astro
│   ├── lib/utils.ts
│   ├── types/index.ts
│   └── pages/index.astro
├── public/images/
├── astro.config.mjs (preconfigurado)
└── tsconfig.json (con alias @/)
```

## Componentes

### Hero Section
```astro
<Hero 
  title="Mi Empresa"
  subtitle="Servicios profesionales"
  ctaText="Contactar"
  ctaLink="/contacto"
  image="/hero.jpg"
/>
```

### Button Variants
```astro
<Button variant="primary" size="lg">Primario</Button>
<Button variant="outline">Contorno</Button>
```

## Scripts Disponibles

```bash
npm run dev              # Desarrollo
npm run build           # Producción
npm run setup-components # Regenerar componentes
npm run format          # Prettier
```

## Personalización

1. **Actualizar dominio** en `astro.config.mjs`
2. **Modificar logo** en `Navbar.astro`
3. **Cambiar enlaces** de navegación
4. **Personalizar colores** en componentes

## Despliegue

### Vercel
```bash
npm i -g vercel && vercel
```

### Netlify
- Build: `npm run build`
- Publish: `dist`

## Troubleshooting

**Permission denied**
```bash
chmod +x SetupNewProject/setup-project.sh
```

**Module not found**
```bash
npm install
```

## Características Técnicas

- ⚡ Astro para máximo rendimiento
- 📱 Diseño mobile-first
- 🎨 Componentes TypeScript tipados
- 🔍 SEO optimizado por defecto
- 🛠️ Developer Experience mejorada

## Tiempo de Setup

- Proyecto base: **1-2 minutos**
- Componentes: **30 segundos**
- Total desarrollo: **2-3 minutos**

## Contribuir

1. Fork del repositorio
2. Crear rama: `git checkout -b feature/mejora`
3. Commit: `git commit -m 'Add mejora'`
4. Push: `git push origin feature/mejora`
5. Pull Request

## Licencia

MIT - libre para uso personal y comercial