import './assets/main.css';
import 'bootstrap/dist/css/bootstrap.css'; // Bootstrap CSS 추가
import 'vue-awesome-paginate/dist/style.css';

import { createApp } from 'vue';
import { createPinia } from 'pinia';
import VueAwesomePaginate from 'vue-awesome-paginate';
import { useKakao } from 'vue3-kakao-maps/@utils';

import App from './App.vue';
import router from './router';

// JavaScript 키로 Kakao API 초기화
const rest_api_key = '3a73e7d2098fcb17ff7e26918740ef0b';
useKakao(rest_api_key, ['services']); // services 라이브러리 포함

const app = createApp(App);

app.use(VueAwesomePaginate);
app.use(createPinia()); // 상태 관리
app.use(router); // 라우팅
app.mount('#app');
