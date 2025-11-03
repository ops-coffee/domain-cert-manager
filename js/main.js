// 确保DOM内容加载完毕后再执行脚本
document.addEventListener("DOMContentLoaded", function() {
  // 移动端菜单控制
  const btn = document.getElementById('menu-btn');
  const nav = document.getElementById('mobile-nav');
  if (btn && nav) {
    btn.addEventListener('click', () => {
      nav.classList.toggle('active');
      btn.innerHTML = nav.classList.contains('active')
        ? '<i class="ri-close-line text-xl"></i>'
        : '<i class="ri-menu-line text-xl"></i>';
    });
  }

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