<template>
  <h1>Login 테스트</h1>

  <!-- 로그인 실패시 화면 -->
  <div v-if="!isLoggedIn">
    <form @submit.prevent="handleLogin">
      <div>
        username :
        <input type="text" v-model="loginForm.username" />
      </div>

      <div>
        password :
        <input type="password" v-model="loginForm.password" />
      </div>

      <div>
        <button type="submit">로그인</button>
      </div>
    </form>
  </div>

  <!-- 로그인 성공시 화면 -->
  <div v-else>
    <h1>환영합니다</h1>
    <div>
      <button @click="handleLogout">로그 아웃</button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import axios from 'axios';

// 로그인 상태 반응형 데이터
const isLoggedIn = ref(false);

// 로그인 입력 상태 반응형 데이터 (객체)
const loginForm = ref({
  username: '',
  password: '',
});

// 로그인 처리 함수
const handleLogin = async () => {
  try {
    // 실제 요청 주소 : http://localhost:8080/api/auth/login -> vite.config.js 참고
    // loginForm.value -> {username : '', password : '',}
    // -> axios가 자동으로 JSON으로 변환
    const response = await axios.post('/api/auth/login', loginForm.value);

    console.log(response.data);

    // 구조 분해 할당
    const { token, user } = response.data;

    // 로컬 스토리지에 토큰 저장
    localStorage.setItem('authToken', token);
    // 로컬 스토리지에 사용자 정보 저장
    localStorage.setItem('userInfo', JSON.stringify(user));

    // 상태 업데이트
    isLoggedIn.value = true;

    // 로그인 폼에 입력된 값 초기화(v-model)
    loginForm.value = {
      username: '',
      password: '',
    };
  } catch (error) {}
};

// 로그아웃 처리 함수
const handleLogout = () => {
  // 로컬 스토리지에 저장된 내용 비우기
  // localStorage.clear(); -> 모두 지우기

  localStorage.removeItem('authToken');
  localStorage.removeItem('userInfo');

  // 상태 업데이트
  isLoggedIn.value = false;
};
</script>
