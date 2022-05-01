/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/packs/";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = "./app/javascript/packs/flash.js");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./app/javascript/packs/flash.js":
/*!***************************************!*\
  !*** ./app/javascript/packs/flash.js ***!
  \***************************************/
/*! no static exports found */
/***/ (function(module, exports) {

// turbolinks:loadでページ読み込み時に実行
document.addEventListener('turbolinks:load', function () {
  // flashメッセージ要素を取得
  var flashMessage = document.querySelector('.alert'); // フェードアウトさせる（徐々に透過し,非表示にする）関数を定義

  var fadeOutFlashMessage = function fadeOutFlashMessage() {
    // setIntervalを特定するために返り値を変数timer_idに格納
    var timer_id = setInterval(function () {
      // flashメッセージのstyle属性 opacityを取得
      var opacity = flashMessage.style.opacity;

      if (opacity > 0) {
        // opacityの値が0より大きければ0.02ずつ値を減少させる
        flashMessage.style.opacity = opacity - 0.02;
      } else {
        // opacityの値が0になったら非表示に
        flashMessage.style.display = 'none'; // setIntervalをストップさせる

        clearInterval(timer_id);
      }

      ;
    }, 50); // 今回は0.05秒ごとにsetIntervalを実行
  }; // flashメッセージがある場合のみ実行


  if (flashMessage !== null) {
    // style属性opacityをセット
    flashMessage.style.opacity = 1; // 今回は表示から3秒後に上記で定義したフェードアウトさせる関数を実行

    setTimeout(fadeOutFlashMessage, 3000);
  }

  ;
});

/***/ })

/******/ });
//# sourceMappingURL=flash-437cc0dece443695dd9f.js.map