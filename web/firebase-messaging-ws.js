importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyA1780Kr__B6ieiG15g8BHAkNK2BzqL5PU",
    authDomain: "talking-dev.firebaseapp.com",
    projectId: "talking-dev",
    storageBucket: "talking-dev.appspot.com",
    messagingSenderId: "975167234645",
    appId: "1:975167234645:web:04146c706b6ff320fd6adc",
    measurementId: "G-WQLZ1WZ844",
    databaseURL: "https://talking-dev.firebaseio.com",
});

const messaging = firebase.messaging();