// 确保DOM内容加载完毕后再执行脚本
document.addEventListener("DOMContentLoaded", function() {

  // 1. 初始化 Swiper
  const swiper = new Swiper(".swiper-container", {
    loop: true,
    autoplay: {
      delay: 3000,
      disableOnInteraction: false,
    },
    pagination: {
      el: ".swiper-pagination",
      clickable: true,
    },
    navigation: {
      nextEl: ".swiper-button-next",
      prevEl: ".swiper-button-prev",
    },
    slidesPerView: 1,
    spaceBetween: 20,
  });

  // 2. 初始化 AOS (Animate On Scroll)
  AOS.init({
    duration: 800,
    once: true // 动画是否只播放一次
  });

});