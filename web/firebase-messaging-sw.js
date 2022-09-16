importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyCHMU7B6X-3ZvoiGcUislxFhkDaRycZIQ0",
    authDomain: "spiceheaven-67f86.firebaseapp.com",
    projectId: "spiceheaven-67f86",
    storageBucket: "spiceheaven-67f86.appspot.com",
    messagingSenderId: "489549892011",
    appId: "1:489549892011:web:08ec2a932dec42f2fa6aee",
    databaseURL: "...",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
});
