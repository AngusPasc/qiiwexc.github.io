'use strict';

// get version number
var xhr = new XMLHttpRequest();
xhr.open('GET', 'https://raw.githubusercontent.com/qiiwexc/qiiwexc.github.io/master/dev/version');
xhr.onload = function () {
  document.getElementsByTagName('title')[0].innerHTML = document.getElementsByTagName('title')[0].innerHTML + ' v' + xhr.responseText;
  document.getElementsByTagName('h2')[0].innerHTML = 'v' + xhr.responseText + ' | ' + document.getElementsByTagName('h2')[0].innerHTML;
};
xhr.send();

// detect system architecture
var systemArchitecture;
if (navigator.userAgent.indexOf('WOW64') !== -1 || navigator.userAgent.indexOf('Win64') !== -1) {
  systemArchitecture = 64;
} else {
  systemArchitecture = 86;
}

// detect system language
var systemLanguage;
if (navigator.language.indexOf('lv') !== -1) {
  systemLanguage = 'LV';
} else if (navigator.language.indexOf('ru') !== -1) {
  systemLanguage = 'RU';
} else {
  systemLanguage = 'EN';
}

// detect system version
var systemVersion;
if (navigator.appVersion.indexOf('Windows NT 10.0') !== -1) {
  systemVersion = 10;
} else if (navigator.appVersion.indexOf('Windows NT 6.4') !== -1) {
  systemVersion = 10;
} else if (navigator.appVersion.indexOf('Windows NT 6.3') !== -1) {
  systemVersion = 8.1;
} else if (navigator.appVersion.indexOf('Windows NT 6.2') !== -1) {
  systemVersion = 8;
} else if (navigator.appVersion.indexOf('Windows NT 6.1') !== -1) {
  systemVersion = 7;
} else if (navigator.appVersion.indexOf('Windows NT 6.0') !== -1) {
  systemVersion = 'Vista';
} else if (navigator.appVersion.indexOf('Windows NT 5.2') !== -1) {
  systemVersion = 'XP';
} else if (navigator.appVersion.indexOf('Windows NT 5.1') !== -1) {
  systemVersion = 'XP';
} else if (navigator.appVersion.indexOf('Windows NT 5.0') !== -1) {
  systemVersion = 2000;
} else if (navigator.appVersion.indexOf('Windows NT 4.0') !== -1) {
  systemVersion = 'NT';
} else {
  systemVersion = '?';
}

// display system information
document.getElementsByClassName('info')[0].innerHTML = (systemVersion === '?' ? 'Unknown Operating System' : 'Windows ' + systemVersion) + ' x' + systemArchitecture + ' | ' + systemLanguage;

// highlight suggested language
var elements = document.getElementsByClassName(systemLanguage);
for (var i = 0; i < elements.length; i++) {
  elements[i].className = systemLanguage + ' suggest';
}

// search for drivers
document.getElementsByTagName('form')[0].onsubmit = function (event) {
  var text = document.getElementsByTagName('input')[0].value;
  event.preventDefault(); // do not reload the page

  // notify if search box is empty, otherwise - go to devid.info
  if (text.replace(new RegExp(' ', 'g'), '').length < 1) {
    window.alert('The search field is empty!');
  } else {
    window.open('http://devid.info/search?text=' + text.replace(/&/g, '%26'));
  }
};
