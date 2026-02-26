const CACHE = 'yanar-v3';
const STATIC = ['/index.html'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(STATIC).catch(()=>{})));
  self.skipWaiting();
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', e => {
  // Skip Supabase API calls entirely - never cache these
  if (e.request.url.includes('supabase.co') || 
      e.request.url.includes('supabase-js') ||
      e.request.method !== 'GET') {
    return;
  }
  
  e.respondWith(
    caches.match(e.request).then(cached => {
      if (cached) return cached;
      return fetch(e.request).then(res => {
        // Only cache same-origin static assets
        if (res && res.status === 200 && res.type === 'basic') {
          const cloned = res.clone();
          caches.open(CACHE).then(c => c.put(e.request, cloned));
        }
        return res;
      }).catch(() => cached || new Response('Offline', {status: 503}));
    })
  );
});
