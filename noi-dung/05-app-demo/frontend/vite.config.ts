import path from 'path';
import { defineConfig, loadEnv } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig(({ mode }) => {
    const env = loadEnv(mode, '.', '');
    return {
      server: {
        allowedHosts: ['superpiously-dissociative-shaquana.ngrok-free.dev'],
        port: 3000,
        host: '0.0.0.0',
        proxy: {
          '/api': {
            target: 'http://0.0.0.0:3001',
            changeOrigin: true,
            secure: false,
          },
        },
      },
      plugins: [react()],
      base: '/ie103-project-report/',
      define: {
        'process.env.API_KEY': JSON.stringify(env.GEMINI_API_KEY),
        'process.env.GEMINI_API_KEY': JSON.stringify(env.GEMINI_API_KEY)
      },
      resolve: {
        alias: {
          '@': path.resolve(__dirname, '.'),
        }
      },
    };
});
