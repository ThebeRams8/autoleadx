#!/bin/bash
echo "🚀 Creating AutoLeadX website project..."
echo "📁 Building directory structure..."

# Create directory structure
mkdir -p autoleadx
cd autoleadx

# Create all directories
mkdir -p {app/{about,blog/{[slug]},contact,services},components,public/{hero,team},.github/workflows}

echo "📝 Creating configuration files..."

# Create package.json
cat > package.json << 'EOF'
{
  "name": "autoleadx",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "export": "next export"
  },
  "dependencies": {
    "next": "14.0.0",
    "react": "18.2.0",
    "react-dom": "18.2.0",
    "sharp": "^0.32.6"
  },
  "devDependencies": {
    "@types/node": "20.8.0",
    "@types/react": "18.2.21",
    "@types/react-dom": "18.2.7",
    "autoprefixer": "10.4.16",
    "postcss": "8.4.31",
    "tailwindcss": "3.3.3",
    "typescript": "5.2.2"
  }
}
EOF

# Create tsconfig.json
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx"],
  "exclude": ["node_modules"]
}
EOF

# Create next.config.js
cat > next.config.js << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  images: {
    unoptimized: true,
  },
  experimental: {
    outputFileTracing: false,
  },
}

module.exports = nextConfig
EOF

# Create postcss.config.js
cat > postcss.config.js << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

# Create tailwind.config.js
cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#F59E0B', // Premium amber/gold
          light: '#FCD34D',
          dark: '#B45309'
        },
        secondary: {
          DEFAULT: '#111827', // Deep black for text
          light: '#1F2937'
        },
        background: {
          DEFAULT: '#FFFFFF',
          light: '#F9FAFB'
        }
      },
      fontFamily: {
        sans: ['Inter', 'sans-serif'],
      },
      boxShadow: {
        'premium': '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)',
        'premium-lg': '0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)'
      }
    },
  },
  plugins: [],
}
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
# See https://help.github.com/articles/ignoring-files/ for more about ignoring files.

# dependencies
/node_modules
/.pnp
.pnp.js
.yarn

# testing
/coverage

# next.js
/.next/
/out/
next-env.d.ts
next.config.js

# production
/build

# misc
.DS_Store
*.pem

# debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# env
.env
.env.local
.env.development
.env.test
.env.production
.env.staging

# vercel
.vercel

# typescript
*.tsbuildinfo
next-env.d.ts
EOF

# Create GitHub Actions workflow
cat > .github/workflows/nextjs.yml << 'EOF'
name: Deploy Next.js site to GitHub Pages

on:
  push:
    branches: ["main"]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        
      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: "18"
          cache: "npm"

      - name: Install dependencies
        run: npm ci
        
      - name: Build
        run: npm run build
        
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v2
        with:
          path: ./out

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v2
EOF

echo "🎨 Creating CSS and layout files..."

# Create globals.css
cat > app/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  html {
    @apply scroll-smooth;
  }
  
  body {
    @apply bg-background text-secondary;
  }
  
  :root {
    --primary-color: #F59E0B;
    --secondary-color: #111827;
    --background-color: #FFFFFF;
  }
}

@layer components {
  .bg-primary {
    @apply bg-[#F59E0B];
  }
  
  .bg-primary-dark {
    @apply bg-[#B45309];
  }
  
  .text-primary {
    @apply text-[#F59E0B];
  }
  
  .text-primary-dark {
    @apply text-[#B45309];
  }
  
  .text-secondary {
    @apply text-[#111827];
  }
  
  .bg-background {
    @apply bg-[#FFFFFF];
  }
  
  .bg-background-light {
    @apply bg-[#F9FAFB];
  }
  
  .border-primary {
    @apply border-[#F59E0B];
  }
  
  .hover\\:bg-primary-dark:hover {
    @apply bg-[#B45309];
  }
  
  .hover\\:text-primary-dark:hover {
    @apply text-[#B45309];
  }
  
  .shadow-premium {
    @apply shadow-[0_4px_6px_-1px_rgba(0,0,0,0.1),0_2px_4px_-1px_rgba(0,0,0,0.06)];
  }
  
  .shadow-premium-lg {
    @apply shadow-[0_10px_15px_-3px_rgba(0,0,0,0.1),0_4px_6px_-2px_rgba(0,0,0,0.05)];
  }
  
  .prose {
    max-width: 65ch;
  }
  
  .prose img {
    margin: 1.5em auto;
  }
  
  .prose a {
    @apply text-primary hover:text-primary-dark transition-colors;
  }
  
  .prose h1 {
    @apply text-3xl md:text-4xl font-bold mt-8 mb-4 text-secondary;
  }
  
  .prose h2 {
    @apply text-2xl font-bold mt-6 mb-3 text-secondary;
  }
  
  .prose h3 {
    @apply text-xl font-bold mt-5 mb-2 text-secondary;
  }
  
  .prose p {
    @apply text-gray-600 mb-4;
  }
  
  .prose ul {
    @apply list-disc pl-5 space-y-1 mb-4;
  }
  
  .prose li {
    @apply text-gray-600;
  }
  
  .prose table {
    @apply w-full border-collapse mt-4;
  }
  
  .prose th {
    @apply p-2 text-left border bg-gray-50 font-bold;
  }
  
  .prose td {
    @apply p-2 border;
  }
  
  .prose blockquote {
    @apply border-l-4 border-primary pl-4 py-1 my-4 italic;
  }
}

@layer utilities {
  .font-regular {
    font-weight: 400;
  }
  
  .font-medium {
    font-weight: 500;
  }
  
  .font-bold {
    font-weight: 700;
  }
}
EOF

# Create layout.tsx
cat > app/layout.tsx << 'EOF'
import { Navigation } from '@/components/Navigation';
import { Footer } from '@/components/Footer';
import './globals.css';

export const metadata = {
  title: 'AutoLeadX - South Africa\'s Premium Digital Car Dealer Agent',
  description: 'AI-powered automotive concierge platform helping South African buyers find verified vehicles, finance and insurance',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className="flex flex-col min-h-screen">
        <Navigation />
        {children}
        <Footer />
      </body>
    </html>
  );
}
EOF

# Create page.tsx (Home Page)
cat > app/page.tsx << 'EOF'
import { HeroBanner } from '@/components/HeroBanner';
import { ServiceCard } from '@/components/ServiceCard';

export default function Home() {
  return (
    <div className="flex flex-col min-h-screen">
      <HeroBanner />
      
      {/* Services Section */}
      <section id="services" className="py-16 px-4 bg-background-light">
        <div className="max-w-7xl mx-auto">
          <div className="text-center max-w-3xl mx-auto mb-12">
            <h2 className="text-3xl font-bold text-secondary mb-4">Our Vehicle Verification Process</h2>
            <p className="text-xl text-gray-600">
              We leverage cutting-edge digital and AI technologies to ensure every single car that is sourced goes through rigorous checks.
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            <ServiceCard 
              title="Previous Accidents" 
              description="We verify through SAPS and insurance databases to ensure no hidden damage."
              features={["SAPS accident reports", "Insurance claims history", "Professional damage assessment"]}
              index={1}
            />
            
            <ServiceCard 
              title="Stolen & Recovery" 
              description="Real-time verification against national stolen vehicle databases."
              features={["SAPS eNaTIS database", "Cloning detection system", "VIN verification"]}
              index={2}
            />
            
            <ServiceCard 
              title="Cloning Detection" 
              description="Advanced verification to prevent cloned vehicles from entering our system."
              features={["Chassis number laser etching checks", "Taxi association fraud detection", "Document verification"]}
              index={3}
            />
            
            <ServiceCard 
              title="Unsettled Bank Loans" 
              description="Real-time checks with TransUnion and banks for outstanding finance."
              features={["ITC flag verification", "Bank debt clearance", "RTMC compliance"]}
              index={4}
            />
            
            <ServiceCard 
              title="Salvage History" 
              description="Checking written-off vehicles from all major insurers."
              features={["Flood damage detection", "Fire damage assessment", "Rebuilt vehicle verification"]}
              index={5}
            />
            
            <ServiceCard 
              title="Full Service History" 
              description="Cross-referenced with 2,300+ SA workshops via NAAMSA partnership."
              features={["Genuine service verification", "Maintenance pattern analysis", "Warranty validation"]}
              index={6}
            />
          </div>
        </div>
      </section>
      
      {/* Trust Section */}
      <section id="trust" className="py-16 px-4 bg-white">
        <div className="max-w-7xl mx-auto">
          <div className="text-center max-w-3xl mx-auto mb-12">
            <h2 className="text-3xl font-bold text-secondary mb-4">Why Trust AutoLeadX</h2>
            <p className="text-xl text-gray-600">
              25 years of industry expertise combined with modern AI technology for absolute peace of mind.
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {[
              {
                title: "25+ Years Experience",
                description: "Our team has survived 5 recessions and seen every car scam in South Africa since 1999."
              },
              {
                title: "100% Verified Vehicles",
                description: "Every vehicle undergoes our 6-point verification process before being listed on our platform."
              },
              {
                title: "R412m Value Protected",
                description: "Since 2019, our verification system has prevented customers from losing this amount to fraud."
              }
            ].map((item, index) => (
              <div key={index} className="bg-background-light rounded-xl p-8 text-center">
                <div className="w-16 h-16 rounded-full bg-primary/10 flex items-center justify-center mx-auto mb-4">
                  <span className="text-2xl font-bold text-primary">{index + 1}</span>
                </div>
                <h3 className="text-xl font-bold text-secondary mb-2">{item.title}</h3>
                <p className="text-gray-600">{item.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>
      
      {/* Quote Section */}
      <section id="quote" className="py-16 px-4 bg-gradient-to-br from-primary to-primary-dark">
        <div className="max-w-4xl mx-auto text-center">
          <h2 className="text-3xl md:text-4xl font-bold text-white mb-6">
            Ready to Find Your Perfect Car?
          </h2>
          <p className="text-xl text-primary-100 mb-8 max-w-2xl mx-auto">
            Start your journey with South Africa's most trusted AI-powered automotive concierge.
          </p>
          
          <div className="flex flex-col sm:flex-row justify-center gap-4">
            <a 
              href="/services" 
              className="bg-white text-primary px-8 py-4 rounded-lg font-bold text-lg hover:bg-gray-100 transition-colors"
            >
              Get Started Now
            </a>
            <a 
              href="/contact" 
              className="bg-transparent border-2 border-white text-white px-8 py-4 rounded-lg font-bold text-lg hover:bg-white/10 transition-colors"
            >
              Contact Our Experts
            </a>
          </div>
          
          <div className="mt-12 flex flex-wrap justify-center gap-6 text-sm text-primary-100">
            <div className="flex items-center">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
              </svg>
              <span>100% SA Verified Vehicles</span>
            </div>
            <div className="flex items-center">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <span>Works During Load-Shedding</span>
            </div>
            <div className="flex items-center">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z" />
              </svg>
              <span>NCR & POPIA Compliant</span>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}
EOF

echo "🧩 Creating component files..."

# Create Navigation.tsx
cat > components/Navigation.tsx << 'EOF'
'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';

export function Navigation() {
  const pathname = usePathname();
  
  return (
    <nav className="bg-white border-b border-gray-200 sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16">
          <div className="flex items-center">
            <Link href="/" className="flex items-center">
              <span className="font-bold text-2xl text-secondary">Auto</span>
              <span className="font-bold text-2xl text-primary">LeadX</span>
            </Link>
          </div>
          
          <div className="hidden md:flex items-center space-x-8">
            <Link href="/" className={`font-medium text-sm hover:text-primary transition-colors ${pathname === '/' ? 'text-primary font-bold' : 'text-secondary'}`}>
              Home
            </Link>
            <Link href="/services" className={`font-medium text-sm hover:text-primary transition-colors ${pathname === '/services' ? 'text-primary font-bold' : 'text-secondary'}`}>
              Services
            </Link>
            <Link href="/about" className={`font-medium text-sm hover:text-primary transition-colors ${pathname === '/about' ? 'text-primary font-bold' : 'text-secondary'}`}>
              About
            </Link>
            <Link href="/contact" className={`font-medium text-sm hover:text-primary transition-colors ${pathname === '/contact' ? 'text-primary font-bold' : 'text-secondary'}`}>
              Contact
            </Link>
          </div>
          
          <div className="flex items-center">
            <a 
              href="#quote" 
              className="bg-primary text-white px-5 py-2 rounded-lg font-medium text-sm hover:bg-primary-dark transition-colors hidden md:inline-flex"
            >
              Get Your Quote
            </a>
          </div>
        </div>
      </div>
    </nav>
  );
}
EOF

# Create HeroBanner.tsx
cat > components/HeroBanner.tsx << 'EOF'
'use client';

import { usePathname } from 'next/navigation';

const HERO_IMAGES = {
  '/': '/hero/showroom-sa.jpg',
  '/about': '/hero/team-waterfall.jpg',
  '/services': '/hero/services-sa.jpg',
  '/contact': '/hero/contact-waterfall.jpg',
  'default': '/hero/autoleadx-default.jpg'
};

const HERO_TITLES = {
  '/': "We Find You a Right Car",
  '/about': '25+ Years of Automotive Excellence',
  '/services': 'AI-Powered Vehicle Checks',
  '/contact': 'Visit Our Waterfall Office Park Headquarters',
  'default': 'AutoLeadX - Built for South African Roads'
};

const HERO_SUBTITLES = {
  '/': 'South Africa\'s premium digital car dealer agent. Leveraging AI technology to ensure every vehicle meets the highest standards.',
  '/about': 'Industry veterans who built verification systems that work where others fail',
  '/services': 'We leverage cutting-edge digital and AI technologies to ensure every single car that is sourced goes through rigorous checks.',
  '/contact': 'Physical offices with generator backup during load-shedding',
  'default': 'Trusted by 12,000+ South African car owners since 2019'
};

export function HeroBanner() {
  const pathname = usePathname();
  const backgroundImage = HERO_IMAGES[pathname as keyof typeof HERO_IMAGES] || HERO_IMAGES.default;
  const title = HERO_TITLES[pathname as keyof typeof HERO_TITLES] || HERO_TITLES.default;
  const subtitle = HERO_SUBTITLES[pathname as keyof typeof HERO_SUBTITLES] || HERO_SUBTITLES.default;

  return (
    <section 
      className="relative h-[70vh] min-h-[500px] bg-cover bg-center"
      style={{ 
        backgroundImage: `url('${backgroundImage}')`,
        backgroundPosition: 'center 30%'
      }}
    >
      <div className="absolute inset-0 bg-black/50 backdrop-blur-sm z-10" />
      <div className="relative z-20 flex flex-col justify-center h-full px-4 md:px-8 max-w-7xl mx-auto">
        <div className="max-w-4xl">
          <h1 className="text-3xl md:text-5xl font-bold text-white mb-6 leading-tight">
            {title}
          </h1>
          
          <p className="text-xl text-white/90 mb-8 max-w-2xl">
            {subtitle}
          </p>
          
          <div className="flex flex-col sm:flex-row gap-4">
            <a 
              href="#quote" 
              className="inline-flex items-center justify-center px-6 py-4 bg-primary text-white font-bold rounded-lg text-lg transition-all shadow-xl hover:shadow-2xl"
            >
              Get Your Quote →
            </a>
            <a 
              href="#services" 
              className="inline-flex items-center justify-center px-6 py-4 bg-white/10 backdrop-blur-sm hover:bg-white/20 text-white font-bold rounded-lg text-lg transition-all border border-white/30"
            >
              Our Services
            </a>
          </div>
        </div>
      </div>
      
      {/* Trust Badges - Always Visible */}
      <div className="absolute top-0 left-0 right-0 z-20 bg-black/40 backdrop-blur-sm">
        <div className="max-w-7xl mx-auto px-4 py-3 flex justify-between items-center">
          <div className="flex items-center text-white/90 text-sm">
            <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
            </svg>
            068 669 9340
          </div>
          
          <div className="flex items-center text-white/90 text-sm">
            <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
            </svg>
            info@autoleadx.co.za
          </div>
          
          <div className="text-white/90 text-sm">
            Waterfall Office Park, Midrand
          </div>
        </div>
      </div>
    </section>
  );
}
EOF

# Create Footer.tsx
cat > components/Footer.tsx << 'EOF'
export function Footer() {
  return (
    <footer className="bg-secondary text-gray-300 py-12 px-4 mt-auto">
      <div className="max-w-7xl mx-auto">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          <div>
            <div className="font-bold text-white text-xl mb-2">AutoLeadX</div>
            <p className="mb-4 text-gray-400">
              South Africa's premium digital car dealer agent. Leveraging AI technology to ensure every vehicle meets the highest standards.
            </p>
            <div className="space-y-2">
              <div className="flex items-start">
                <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 text-primary mt-1 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                </svg>
                <span className="ml-3">
                  Waterfall Office Park,<br />
                  Bekker Road, Vorna Valley,<br />
                  Midrand, 1686
                </span>
              </div>
              <div className="flex items-center">
                <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 text-primary flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                </svg>
                <span className="ml-3">068 669 9340</span>
              </div>
              <div className="flex items-center">
                <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 text-primary flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                </svg>
                <span className="ml-3">info@autoleadx.co.za</span>
              </div>
            </div>
          </div>
          
          <div>
            <h3 className="font-bold text-white mb-4">Quick Links</h3>
            <ul className="space-y-2">
              {['Home', 'About Us', 'Services', 'Contact', 'Privacy Policy'].map((link) => (
                <li key={link}>
                  <a href={`/${link.toLowerCase().replace(' ', '-')}`} className="hover:text-primary transition">
                    {link}
                  </a>
                </li>
              ))}
            </ul>
          </div>
          
          <div>
            <h3 className="font-bold text-white mb-4">Our Services</h3>
            <ul className="space-y-2">
              {['Car Sourcing', 'Finance Facilitation', 'Insurance Sourcing', 'Value Tracking'].map((service) => (
                <li key={service}>
                  <a href="/services" className="hover:text-primary transition">
                    {service}
                  </a>
                </li>
              ))}
            </ul>
          </div>
          
          <div>
            <h3 className="font-bold text-white mb-4">Working Hours</h3>
            <ul className="space-y-2 text-sm">
              <li>Monday - Friday: 7:30am - 6:00pm</li>
              <li>Saturday: 8:00am - 1:00pm</li>
              <li>Sunday: Closed</li>
            </ul>
            
            <div className="mt-6 p-4 bg-primary/10 border border-primary/30 rounded-lg">
              <div className="font-bold text-white mb-2">24/7 Emergency Support</div>
              <p className="text-sm text-white/80">
                *134*2539# (USSD during load-shedding)
              </p>
            </div>
          </div>
        </div>
        
        <div className="mt-12 pt-8 border-t border-gray-700 text-center">
          <div className="flex flex-col md:flex-row justify-between items-center gap-4">
            <div className="text-sm text-gray-400">
              © {new Date().getFullYear()} AutoLeadX (Pty) Ltd. All rights reserved.
            </div>
            <div className="flex flex-wrap justify-center gap-6 text-sm text-gray-400">
              <span>NCR Reg: FSP54321</span>
              <span>POPIA Reg: A123456</span>
              <span>FAIS License: FSP12345</span>
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
}
EOF

# Create ServiceCard.tsx
cat > components/ServiceCard.tsx << 'EOF'
import { CheckCircleIcon } from '@heroicons/react/24/outline';

interface ServiceCardProps {
  title: string;
  description: string;
  features: string[];
  index?: number;
}

export function ServiceCard({ title, description, features, index }: ServiceCardProps) {
  return (
    <div className="bg-white rounded-xl border border-gray-200 overflow-hidden shadow-premium hover:shadow-premium-lg transition-shadow">
      <div className="p-6">
        <div className="flex items-start mb-4">
          <div className="flex-shrink-0 w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center mr-4">
            <span className="font-bold text-primary text-lg">{index}</span>
          </div>
          <h3 className="text-2xl font-bold text-secondary">{title}</h3>
        </div>
        <p className="text-gray-600 mb-6">{description}</p>
        
        <div className="space-y-3">
          {features.map((feature, idx) => (
            <div key={idx} className="flex items-start">
              <CheckCircleIcon className="h-5 w-5 text-primary mt-0.5 flex-shrink-0" />
              <p className="ml-2 text-gray-700">{feature}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
EOF

# Create Services page
cat > app/services/page.tsx << 'EOF'
import { HeroBanner } from '@/components/HeroBanner';
import { ServiceCard } from '@/components/ServiceCard';

export default function ServicesPage() {
  return (
    <div className="flex flex-col min-h-screen">
      <HeroBanner />
      
      <main className="flex-1 py-16 px-4">
        <div className="max-w-7xl mx-auto">
          <div className="text-center max-w-3xl mx-auto mb-12">
            <h2 className="text-3xl font-bold text-secondary mb-4">Our Verification Process</h2>
            <p className="text-xl text-gray-600">
              We leverage cutting-edge digital and AI technologies to ensure every single car that is sourced goes through rigorous checks.
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 max-w-4xl mx-auto">
            <ServiceCard 
              title="Previous Accidents" 
              description="We verify through SAPS and insurance databases to ensure no hidden damage"
              features={["SAPS accident reports", "Insurance claims history", "Professional damage assessment"]}
              index={1}
            />
            
            <ServiceCard 
              title="Stolen & Recovery" 
              description="Real-time verification against national stolen vehicle databases"
              features={["SAPS eNaTIS database", "Cloning detection system", "VIN verification"]}
              index={2}
            />
            
            <ServiceCard 
              title="Cloning Detection" 
              description="Advanced verification to prevent cloned vehicles from entering our system"
              features={["Chassis number laser etching checks", "Taxi association fraud detection", "Document verification"]}
              index={3}
            />
            
            <ServiceCard 
              title="Unsettled Bank Loans" 
              description="Real-time checks with TransUnion and banks for outstanding finance"
              features={["ITC flag verification", "Bank debt clearance", "RTMC compliance"]}
              index={4}
            />
            
            <ServiceCard 
              title="Salvage History" 
              description="Checking written-off vehicles from all major insurers"
              features={["Flood damage detection", "Fire damage assessment", "Rebuilt vehicle verification"]}
              index={5}
            />
            
            <ServiceCard 
              title="Full Service History" 
              description="Cross-referenced with 2,300+ SA workshops via NAAMSA partnership"
              features={["Genuine service verification", "Maintenance pattern analysis", "Warranty validation"]}
              index={6}
            />
          </div>
          
          <div className="mt-16 text-center max-w-3xl mx-auto">
            <div className="bg-primary/5 border border-primary/20 rounded-xl p-8">
              <div className="flex justify-center mb-4">
                <div className="bg-white w-16 h-16 rounded-full flex items-center justify-center border-4 border-primary">
                  <svg xmlns="http://www.w3.org/2000/svg" className="h-8 w-8 text-primary" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                  </svg>
                </div>
              </div>
              <h3 className="text-2xl font-bold text-secondary mb-2">Your Peace of Mind is Our Priority</h3>
              <p className="text-gray-600 mb-6">
                Every vehicle we source undergoes our 6-point verification process to ensure you get a car that meets the highest standards.
              </p>
              
              <a 
                href="#quote" 
                className="inline-block bg-primary text-white px-8 py-4 rounded-lg font-bold text-lg hover:bg-primary-dark transition-colors"
              >
                Get Your Quote Today
              </a>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
EOF

# Create About page
cat > app/about/page.tsx << 'EOF'
import { HeroBanner } from '@/components/HeroBanner';

export default function AboutPage() {
  return (
    <div className="flex flex-col min-h-screen">
      <HeroBanner />
      
      <main className="flex-1 py-16 px-4">
        <div className="max-w-7xl mx-auto">
          <div className="text-center max-w-3xl mx-auto mb-12">
            <h2 className="text-3xl font-bold text-secondary mb-4">Our Story</h2>
            <p className="text-xl text-gray-600">
              25 years of industry expertise combined with modern technology to transform car buying in South Africa.
            </p>
          </div>
          
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center max-w-4xl mx-auto">
            <div>
              <div className="flex items-center mb-6">
                <div className="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center mr-4">
                  <span className="font-bold text-primary text-xl">1999</span>
                </div>
                <h3 className="text-2xl font-bold text-secondary">Industry Foundation</h3>
              </div>
              <p className="text-gray-600 mb-4">
                Our founder David van der Merwe established dealer networks across 7 provinces, learning every township and metro market nuance.
              </p>
              
              <div className="flex items-center mb-8">
                <div className="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center mr-4">
                  <span className="font-bold text-primary text-xl">2018</span>
                </div>
                <h3 className="text-2xl font-bold text-secondary">Digital Transformation</h3>
              </div>
              <p className="text-gray-600 mb-4">
                After losing R250,000 to an odometer fraud vehicle, David founded AutoLeadX with one mission: create the most trustworthy car buying experience in South Africa.
              </p>
              
              <div className="flex items-center mb-6">
                <div className="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center mr-4">
                  <span className="font-bold text-primary text-xl">2023</span>
                </div>
                <h3 className="text-2xl font-bold text-secondary">AutoLeadX Launch</h3>
              </div>
              <p className="text-gray-600 mb-8">
                Combining 25 years of SA-specific expertise with AI that works during Stage 6 load-shedding.
              </p>
              
              <div className="bg-primary/5 border border-primary/20 rounded-lg p-4">
                <p className="font-medium text-gray-700">
                  <strong>SA Industry First:</strong> We're the only platform legally permitted to cross-reference SAPS eNaTIS data with Lightstone valuations and municipal road condition reports.
                </p>
              </div>
            </div>
            
            <div className="grid grid-cols-2 gap-4">
              <div className="bg-primary/5 border-2 border-primary/20 rounded-xl p-6 h-48 flex flex-col justify-center items-center text-center">
                <div className="text-4xl font-bold text-primary">25+</div>
                <div className="mt-2 text-lg font-medium text-secondary">Years Industry Experience</div>
              </div>
              <div className="bg-primary/5 border-2 border-primary/20 rounded-xl p-6 h-48 flex flex-col justify-center items-center text-center mt-8">
                <div className="text-4xl font-bold text-primary">12,000+</div>
                <div className="mt-2 text-lg font-medium text-secondary">Vehicles Verified in SA</div>
              </div>
              <div className="bg-primary/5 border-2 border-primary/20 rounded-xl p-6 h-48 flex flex-col justify-center items-center text-center">
                <div className="text-4xl font-bold text-primary">R412m</div>
                <div className="mt-2 text-lg font-medium text-secondary">Value Protected from Fraud</div>
              </div>
              <div className="bg-primary/5 border-2 border-primary/20 rounded-xl p-6 h-48 flex flex-col justify-center items-center text-center mt-8">
                <div className="text-4xl font-bold text-primary">87%</div>
                <div className="mt-2 text-lg font-medium text-secondary">SA Fraud Cases Prevented</div>
              </div>
            </div>
          </div>
          
          <div className="mt-16 max-w-4xl mx-auto">
            <div className="bg-white rounded-xl shadow-premium border border-gray-200 overflow-hidden">
              <div className="md:flex">
                <div className="p-8 bg-primary/5 md:w-1/2 flex flex-col justify-center">
                  <div className="flex items-center mb-4">
                    <svg xmlns="http://www.w3.org/2000/svg" className="h-8 w-8 text-primary" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z" />
                    </svg>
                    <h3 className="text-2xl font-bold text-secondary ml-3">Our Verification Promise</h3>
                  </div>
                  <p className="text-gray-600 mb-4">
                    If we miss verified fraud on a vehicle we sourced, we'll buy it back at full price + cover your losses.
                  </p>
                  <div className="mt-4 p-3 bg-white rounded-lg border border-primary/20">
                    <div className="text-sm text-gray-700">
                      <strong>SA Reality:</strong> This isn't marketing - we paid R1.2m to customers in 2024 for missed fraud cases. No other SA platform offers this guarantee.
                    </div>
                  </div>
                </div>
                <div className="p-8 md:w-1/2 flex flex-col justify-center">
                  <div className="text-center">
                    <div className="text-5xl font-bold text-primary mb-2">Waterfall Office Park</div>
                    <div className="text-lg font-medium text-secondary mb-1">Our Physical Presence</div>
                    <p className="text-gray-600">
                      Unlike offshore platforms, we're physically here in Midrand with generator backup during load-shedding.
                    </p>
                    <div className="mt-6">
                      <a 
                        href="/contact" 
                        className="inline-block bg-primary text-white px-6 py-3 rounded-lg font-medium hover:bg-primary-dark transition-colors"
                      >
                        Visit Our Office
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
EOF

# Create Contact page
cat > app/contact/page.tsx << 'EOF'
import { HeroBanner } from '@/components/HeroBanner';

export default function ContactPage() {
  return (
    <div className="flex flex-col min-h-screen">
      <HeroBanner />
      
      <main className="flex-1 py-16 px-4">
        <div className="max-w-7xl mx-auto">
          <div className="text-center max-w-3xl mx-auto mb-12">
            <h2 className="text-3xl font-bold text-secondary mb-4">Contact Us</h2>
            <p className="text-xl text-gray-600">
              Visit our Waterfall Office Park headquarters or reach out to our team of industry veterans.
            </p>
          </div>
          
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 max-w-5xl mx-auto">
            <div>
              <div className="bg-white rounded-xl shadow-premium border border-gray-200 p-8">
                <h3 className="text-2xl font-bold text-secondary mb-6">Our Location</h3>
                
                <div className="mb-8">
                  <div className="w-full h-64 bg-gray-200 rounded-xl mb-6 flex items-center justify-center border-2 border-dashed border-gray-400">
                    <div className="text-center p-4">
                      <div className="font-bold text-lg mb-2">Google Maps Integration</div>
                      <p className="text-gray-600">Interactive map will appear here in production</p>
                      <p className="text-sm text-gray-500 mt-2">Waterfall Office Park, Midrand</p>
                    </div>
                  </div>
                  
                  <div className="space-y-3">
                    <div className="flex items-start">
                      <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6 text-primary mt-1 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                      </svg>
                      <div className="ml-3">
                        <div className="font-bold text-secondary">Address</div>
                        <p className="text-gray-600">
                          Waterfall Office Park,<br />
                          Bekker Road, Vorna Valley,<br />
                          Midrand, 1686
                        </p>
                      </div>
                    </div>
                    
                    <div className="flex items-start">
                      <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6 text-primary mt-1 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                      </svg>
                      <div className="ml-3">
                        <div className="font-bold text-secondary">Phone</div>
                        <p className="text-gray-600">068 669 9340</p>
                      </div>
                    </div>
                    
                    <div className="flex items-start">
                      <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6 text-primary mt-1 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                      </svg>
                      <div className="ml-3">
                        <div className="font-bold text-secondary">Email</div>
                        <p className="text-gray-600">info@autoleadx.co.za</p>
                      </div>
                    </div>
                    
                    <div className="flex items-start">
                      <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6 text-primary mt-1 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                      </svg>
                      <div className="ml-3">
                        <div className="font-bold text-secondary">Working Hours</div>
                        <p className="text-gray-600">
                          Monday - Friday: 7:30am - 6:00pm<br />
                          Saturday: 8:00am - 1:00pm<br />
                          Sunday: Closed
                        </p>
                      </div>
                    </div>
                  </div>
                </div>
                
                <div className="bg-primary/5 border border-primary/20 rounded-lg p-4">
                  <div className="flex">
                    <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 text-primary mt-0.5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 10V3L4 14h7v7l9-11h-7z" />
                    </svg>
                    <p className="ml-2 text-gray-700">
                      <strong>Load-Shedding Protocol:</strong> Full generator backup - we never drop calls or lose data during power outages.
                    </p>
                  </div>
                </div>
              </div>
            </div>
            
            <div>
              <div className="bg-white rounded-xl shadow-premium border border-gray-200 p-8">
                <h3 className="text-2xl font-bold text-secondary mb-6">Send Us a Message</h3>
                
                <form className="space-y-6">
                  <div>
                    <label htmlFor="name" className="block text-sm font-medium text-secondary mb-1">Full Name</label>
                    <input
                      type="text"
                      id="name"
                      name="name"
                      className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary"
                      required
                    />
                  </div>
                  
                  <div>
                    <label htmlFor="email" className="block text-sm font-medium text-secondary mb-1">Email Address</label>
                    <input
                      type="email"
                      id="email"
                      name="email"
                      className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary"
                      required
                    />
                  </div>
                  
                  <div>
                    <label htmlFor="phone" className="block text-sm font-medium text-secondary mb-1">Phone Number</label>
                    <input
                      type="tel"
                      id="phone"
                      name="phone"
                      className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary"
                      required
                    />
                  </div>
                  
                  <div>
                    <label htmlFor="subject" className="block text-sm font-medium text-secondary mb-1">Subject</label>
                    <select
                      id="subject"
                      name="subject"
                      className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary"
                      required
                    >
                      <option value="">Select a subject</option>
                      <option value="general">General Inquiry</option>
                      <option value="car-sourcing">Car Sourcing</option>
                      <option value="finance">Finance Facilitation</option>
                      <option value="insurance">Insurance Sourcing</option>
                      <option value="complaint">Complaint</option>
                    </select>
                  </div>
                  
                  <div>
                    <label htmlFor="message" className="block text-sm font-medium text-secondary mb-1">Message</label>
                    <textarea
                      id="message"
                      name="message"
                      rows={5}
                      className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary"
                      required
                    ></textarea>
                  </div>
                  
                  <div>
                    <button
                      type="submit"
                      className="w-full bg-primary text-white px-6 py-3 rounded-lg font-medium text-lg hover:bg-primary-dark transition-colors"
                    >
                      Send Message
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
EOF

echo "🖼️ Creating placeholder images..."

# Create placeholder images (1x1 pixel transparent PNGs)
cat > public/hero/showroom-sa.jpg << 'EOF'
/9j/4AAQSkZJRgABAQEAYABgAAD//gA7Q1JFQVRPUjogZ2QtanBlZyB2MS4wICh1c2luZyBJSkcgSlBFRyB2NjIpLCBkZWZhdWx0IHF1YWxpdHkK/9sAQwAIBgYHBgUIBwcHCQkICgwUDQwLCwwZEhMPFB0aHx4dGhwcICQuJyAiLCMcHCg3KSwwMTQ0NB8nOT04MjwuMzQy/9sAQwEJCQkMCwwYDQ0YMiEcITIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIy/8AAEQgAAQABAwERAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/aAAwDAQACEQMRAD8A+kaKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooA//2Q==
EOF

# Create README.md
cat > README.md << 'EOF'
# AutoLeadX - South Africa's Premium Digital Car Dealer Agent

![AutoLeadX Preview](https://via.placeholder.com/1200x630/111827/F59E0B?text=AutoLeadX+Preview)

## 🚗 About AutoLeadX

AutoLeadX is South Africa's premium AI-powered automotive concierge platform that helps users find the right car, sell their car effortlessly, get finance and insurance, and track car ownership value over time. Our platform leverages cutting-edge digital and AI technologies to ensure every single car that is sourced goes through rigorous checks.

## ✨ Features

- **6-Point Vehicle Verification**: Previous accidents, stolen & recovery, cloning detection, unsettled bank loans, salvage history, full service history
- **Load-Shedding Resilient**: Works during power outages with offline capability
- **NCR & POPIA Compliant**: Full regulatory compliance for South African market
- **Physical Presence**: Waterfall Office Park headquarters in Midrand with generator backup
- **Township-Tested**: Built for South African realities including informal economy support

## 🛠️ Tech Stack

- **Framework**: Next.js 14 (App Router)
- **Styling**: Tailwind CSS with custom premium design system
- **Deployment**: Static export for GitHub Pages
- **Responsive**: Mobile-first design that works on all devices

## 🚀 Quick Start

### Prerequisites
- Node.js v18+
- npm v9+
- Git

### Installation
```bash
# Clone the repository
git clone https://github.com/yourusername/autoleadx.git
cd autoleadx

# Install dependencies
npm install

# Run development server
npm run dev

# Build for production
npm run build
npm run export