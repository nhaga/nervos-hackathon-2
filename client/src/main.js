import { createApp } from 'vue'
import { createRouter, createWebHashHistory } from 'vue-router'
import App from './App.vue'
import { routes } from './routes'
import store from './store'
import VueBottomNavigation from "bottom-navigation-vue";

import './assets/tailwind.css'

const router = createRouter({
  history: createWebHashHistory(),
  routes,
})

const app = createApp(App)
app.use(router)
app.use(store)
app.use(VueBottomNavigation);

app.mount('#app')
