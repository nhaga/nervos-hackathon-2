const routes = [
  {
    path: '/', component: () => import('./layouts/GlassLayout.vue'), children: [
      { path: '', component: () => import('./pages/Docs.vue'), },
      { path: 'trade', component: () => import('./pages/Trade.vue'), },
      { path: 'liquidation', component: () => import('./pages/Liquidation.vue'), },
      { path: 'wallet', component: () => import('./pages/Wallet.vue'), },
    ]
  }
]

export { routes }