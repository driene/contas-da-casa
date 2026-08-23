# Contas da Casa — MVP

PWA mobile-first para registrar e pesquisar gastos familiares.

## Rodar localmente
1. `npm install`
2. copie `.env.example` para `.env.local`
3. preencha `VITE_SUPABASE_URL`, `VITE_SUPABASE_PUBLISHABLE_KEY` e `VITE_APP_URL` (a URL de produção, por exemplo `https://contas-da-casa-six-sigma.vercel.app`)
4. `npm run dev`

## Deploy
Importe o repositório no Vercel e configure as mesmas variáveis de ambiente. Em Supabase Auth > URL Configuration, defina a Site URL e adicione `https://contas-da-casa-six-sigma.vercel.app/**` (ou a URL configurada em `VITE_APP_URL`) nas Redirect URLs.

Nunca coloque service-role keys no frontend.
