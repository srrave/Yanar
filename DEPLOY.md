# 🚀 YANAR – Deployment Guide
### Free hosting using Supabase + Vercel

---

## ✅ What You Need
- A computer with a browser
- Free accounts on: **Supabase** and **Vercel** and **GitHub**
- No coding knowledge required beyond copy-paste!

---

## STEP 1 — Set Up Supabase (Database)

1. Go to **https://supabase.com** → Sign Up (free)
2. Click **"New Project"**
   - Name: `yanar`
   - Password: choose a strong password (save it!)
   - Region: **Singapore** (closest to India)
   - Click **Create Project** (takes ~2 min)

3. Once ready, go to **SQL Editor** (left sidebar)
4. Click **"New Query"**
5. Open `supabase-setup.sql` from this folder
6. Copy ALL the contents and paste into the SQL editor
7. Click **"Run"** — you should see "Success"

8. Now go to **Settings → API** (left sidebar)
   - Copy **Project URL** (looks like `https://abcdef.supabase.co`)
   - Copy **anon public** key (long string starting with `eyJ…`)
   - **Save both** — you'll need them soon

---

## STEP 2 — Deploy to Vercel

### Option A: Drag & Drop (Easiest — no GitHub needed)

1. Go to **https://vercel.com** → Sign Up (free)
2. From your dashboard, click **"Add New → Project"**
3. Scroll down and find **"Deploy from your computer"** or use **Vercel CLI**
4. Or use **https://vercel.com/new** and drag the entire `yanar-full` folder

### Option B: GitHub (Recommended for updates)

1. Go to **https://github.com** → Sign Up → New Repository
   - Name: `yanar`
   - Public or Private (either works)
   - Click **Create Repository**

2. Upload all files from this folder to the repository:
   - `index.html`
   - `sw.js`
   - `manifest.json`
   - `icon-192.png` (add your own icon or generate one)
   - `icon-512.png`

3. Go to **https://vercel.com** → Sign Up with GitHub
4. Click **"Add New Project"** → Import your `yanar` GitHub repo
5. Framework Preset: **Other**
6. Click **Deploy** — done in 60 seconds!

7. Vercel gives you a free URL like: `yanar.vercel.app`
   - You can also add a custom domain for free!

---

## STEP 3 — Connect Supabase to YANAR

When you first open your deployed YANAR app, it shows a setup screen:

1. Paste your **Supabase Project URL**
2. Paste your **Supabase anon public key**
3. Click **"Connect & Launch YANAR"**

That's it! The config is saved in the browser.

> **Note:** For production, it's better to hardcode the keys directly in `index.html`.
> Find these lines and replace:
> ```js
> // Replace the setup screen with hardcoded values:
> initSupabase('YOUR_SUPABASE_URL', 'YOUR_SUPABASE_ANON_KEY');
> ```
> Then remove the `#setup-screen` div entirely.

---

## STEP 4 — Make It Installable as a PWA

### On Android:
1. Open the site in Chrome
2. Tap the 3-dot menu → "Add to Home Screen"
3. YANAR installs like a native app!

### On iPhone:
1. Open in Safari
2. Tap Share button → "Add to Home Screen"

---

## 🎯 Free Tier Limits (Supabase)
| Feature | Free Limit |
|---------|------------|
| Database | 500 MB |
| Storage (files) | 1 GB |
| Monthly Active Users | 50,000 |
| Realtime connections | 200 concurrent |
| API requests | 2 million/month |

This is **more than enough** to serve thousands of students!

---

## 🔒 Security Notes
- The `anon` key is safe to expose in frontend code
- Row Level Security (RLS) is enabled — users can only edit their own data
- Passwords are hashed by Supabase Auth (never stored in plain text)
- File uploads are restricted to authenticated users

---

## 📱 Custom Domain (Optional, Free)
1. In Vercel dashboard → your project → Settings → Domains
2. Add your domain (e.g., `yanar.in`)
3. Update DNS records as instructed
4. Free SSL certificate included!

---

## ❓ Need Help?
- Supabase docs: https://supabase.com/docs
- Vercel docs: https://vercel.com/docs
- If stuck, share the error message and ask for help!
