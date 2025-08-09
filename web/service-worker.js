importScripts('https://storage.googleapis.com/workbox-cdn/releases/6.4.1/workbox-sw.js');

workbox.setConfig({
  debug: false // установите true для разработки
});

// Кэширование основных ресурсов Flutter
workbox.routing.registerRoute(
  /\.(?:js|css|html|json)$/,
  new workbox.strategies.StaleWhileRevalidate()
);

// Долгосрочное кэширование изображений
workbox.routing.registerRoute(
  /\.(?:png|jpg|jpeg|webp|svg|gif|ico)$/,
  new workbox.strategies.CacheFirst({
    cacheName: 'long-term-image-cache',
    plugins: [
      new workbox.expiration.ExpirationPlugin({
        maxEntries: 200,
        maxAgeSeconds: 365 * 24 * 60 * 60, // 1 год
        purgeOnQuotaError: true
      }),
      new workbox.cacheableResponse.CacheableResponsePlugin({
        statuses: [0, 200]
      })
    ]
  })
);

// Кэширование основного HTML
workbox.routing.registerRoute(
  ({url}) => url.origin === self.location.origin,
  new workbox.strategies.NetworkFirst()
);