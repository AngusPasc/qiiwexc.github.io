'use strict';

// detect system language
var systemLanguage;
if(navigator.language) {
  systemLanguage = navigator.language;
} else {
  systemLanguage = navigator.browserLanguage;
}

if (systemLanguage.indexOf('lv') !== -1) {
  systemLanguage = 'LV';
} else if (systemLanguage.indexOf('ru') !== -1) {
  systemLanguage = 'RU';
} else {
  systemLanguage = 'EN';
}

// unhighlight all languages
var elements = document.getElementsByClassName('lang');
for (var i = 0; i < elements.length; i++) {
  elements[i].className = elements[i].className + ' link';
}

// highlight suggested language
elements = document.getElementsByClassName(systemLanguage);
for (var i = 0; i < elements.length; i++) {
  elements[i].className = systemLanguage;
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





// TEST
document.getElementById('test').onclick = function (event) {
  document.getElementById('test').innerHTML='<object type="text/html" data="https://www.piriform.com/recuva/download/standard"></object>'
  // document.getElementById('test').innerHTML='<object type="text/html" style="width: 0px; height: 0px" data="https://www.piriform.com/recuva/download/standard"></object>'
};
