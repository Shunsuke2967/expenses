// turbolinks:loadでページ読み込み時に実行
document.addEventListener('turbolinks:load', () => {

  // flashメッセージ要素を取得
  const flashMessage = document.querySelector('#hidden');

  // フェードアウトさせる（徐々に透過し,非表示にする）関数を定義
  const fadeOutFlashMessage = () => {
    // setIntervalを特定するために返り値を変数timer_idに格納
    const timer_id = setInterval(() => {
      // flashメッセージのstyle属性 opacityを取得
      const opacity = flashMessage.style.opacity;

      if (opacity > 0) {
      // opacityの値が0より大きければ0.02ずつ値を減少させる
        flashMessage.style.opacity = opacity - 0.02;
      } else {
        // opacityの値が0になったら非表示に
        flashMessage.style.display = 'none';
        // setIntervalをストップさせる
        clearInterval(timer_id);
      };
    }, 50); // 今回は0.05秒ごとにsetIntervalを実行
  }

  // flashメッセージがある場合のみ実行
  if (flashMessage !== null) {
    // style属性opacityをセット
    flashMessage.style.opacity = 1;
    // 今回は表示から3秒後に上記で定義したフェードアウトさせる関数を実行
    setTimeout(fadeOutFlashMessage, 3000);
  };
});




