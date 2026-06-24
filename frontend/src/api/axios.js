import axios from 'axios';

const API = axios.create({
    // Added /api to match your backend's SecurityFilter paths
    baseURL: 'http://localhost:8080/api', 
    headers: {
        'Content-Type': 'application/json'
    }
});

// Interceptor to attach the JWT Token to requests automatically once logged in
API.interceptors.request.use((config) => {
    const token = localStorage.getItem('token');
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
}, (error) => {
    return Promise.reject(error);
});

export default API;