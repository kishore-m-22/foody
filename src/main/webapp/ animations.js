/* =========================================================
   FOODYY — GLOBAL ANIMATION ENGINE
   ========================================================= */

(function () {
    "use strict";

    document.documentElement.classList.add("js-enabled");

    document.addEventListener("DOMContentLoaded", function () {

        document.body.classList.add("js-reveal");

        initScrollProgress();
        initScrollReveal();
        initBackToTop();
        initStickyHeader();
        initCursorSpotlight();
        initCardTilt();
        initMagneticButtons();
        initParallax();
        initCountUp();
        initSplitText();

        window.showToast = showToast;
        window.burstConfetti = burstConfetti;
    });


    /* =====================================================
       SCROLL PROGRESS BAR
    ===================================================== */
    function initScrollProgress() {

        let bar = document.getElementById("scrollProgress");

        if (!bar) {
            bar = document.createElement("div");
            bar.id = "scrollProgress";
            bar.className = "scroll-progress";
            document.body.appendChild(bar);
        }

        function update() {
            const scrollTop = window.scrollY;
            const docHeight = document.documentElement.scrollHeight - window.innerHeight;
            const percent = docHeight > 0 ? (scrollTop / docHeight) * 100 : 0;
            bar.style.width = percent + "%";
        }

        window.addEventListener("scroll", update, { passive: true });
        window.addEventListener("resize", update);
        update();
    }


    /* =====================================================
       SCROLL REVEAL
    ===================================================== */
    function initScrollReveal() {

        const targets = document.querySelectorAll(
            ".reveal, .reveal-left, .reveal-right, .reveal-scale"
        );

        if (!targets.length) return;

        if (!("IntersectionObserver" in window)) {
            targets.forEach(function (el) { el.classList.add("visible"); });
            return;
        }

        const observer = new IntersectionObserver(function (entries, obs) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add("visible");
                    obs.unobserve(entry.target);
                }
            });
        }, {
            threshold: 0.06,
            rootMargin: "0px 0px -40px 0px"
        });

        targets.forEach(function (el, i) {
            if (!el.style.transitionDelay) {
                el.style.transitionDelay = (i % 4) * 0.07 + "s";
            }
            observer.observe(el);
        });

        setTimeout(function () {
            document
                .querySelectorAll(".reveal:not(.visible), .reveal-left:not(.visible), .reveal-right:not(.visible), .reveal-scale:not(.visible)")
                .forEach(function (el) { el.classList.add("visible"); });
        }, 2500);
    }


    /* =====================================================
       BACK TO TOP
    ===================================================== */
    function initBackToTop() {

        let btn = document.getElementById("backToTop");

        if (!btn) {
            btn = document.createElement("button");
            btn.id = "backToTop";
            btn.className = "back-to-top";
            btn.setAttribute("aria-label", "Back to top");
            btn.innerHTML = "\u2191";
            document.body.appendChild(btn);
        }

        window.addEventListener("scroll", function () {
            if (window.scrollY > 400) {
                btn.classList.add("show");
            } else {
                btn.classList.remove("show");
            }
        }, { passive: true });

        btn.addEventListener("click", function () {
            window.scrollTo({ top: 0, behavior: "smooth" });
        });
    }


    /* =====================================================
       STICKY HEADER MORPH
    ===================================================== */
    function initStickyHeader() {

        const header =
            document.querySelector(".foody-header") ||
            document.querySelector("header");

        if (!header) return;

        function onScroll() {
            if (window.scrollY > 12) {
                header.classList.add("scrolled");
            } else {
                header.classList.remove("scrolled");
            }
        }

        window.addEventListener("scroll", onScroll, { passive: true });
        onScroll();
    }


    /* =====================================================
       CURSOR SPOTLIGHT (over hero)
    ===================================================== */
    function initCursorSpotlight() {

        const hero = document.querySelector(".hero");

        if (!hero) return;

        if (window.matchMedia("(pointer: coarse)").matches) return;

        const spot = document.createElement("div");
        spot.className = "cursor-spotlight";
        document.body.appendChild(spot);

        let raf = null;
        let targetX = 0;
        let targetY = 0;
        let currentX = 0;
        let currentY = 0;

        function loop() {
            currentX += (targetX - currentX) * 0.12;
            currentY += (targetY - currentY) * 0.12;

            spot.style.left = currentX + "px";
            spot.style.top = currentY + "px";

            raf = requestAnimationFrame(loop);
        }

        hero.addEventListener("mouseenter", function () {
            spot.classList.add("active");
            if (!raf) loop();
        });

        hero.addEventListener("mouseleave", function () {
            spot.classList.remove("active");
        });

        hero.addEventListener("mousemove", function (e) {
            targetX = e.clientX;
            targetY = e.clientY;
        });
    }


    /* =====================================================
       3D CARD TILT
    ===================================================== */
    function initCardTilt() {

        const cards = document.querySelectorAll(
            ".tilt-card, .restaurant-card, .menu-card"
        );

        if (!cards.length) return;

        if (window.matchMedia("(pointer: coarse)").matches) return;

        cards.forEach(function (card) {

            card.addEventListener("mousemove", function (e) {
                const rect = card.getBoundingClientRect();
                const x = e.clientX - rect.left;
                const y = e.clientY - rect.top;
                const cx = rect.width / 2;
                const cy = rect.height / 2;

                const rotateY = ((x - cx) / cx) * 6;
                const rotateX = -((y - cy) / cy) * 6;

                card.style.transform =
                    "perspective(900px) rotateX(" +
                    rotateX +
                    "deg) rotateY(" +
                    rotateY +
                    "deg) translateY(-8px) scale(1.02)";
            });

            card.addEventListener("mouseleave", function () {
                card.style.transform = "";
            });
        });
    }


    /* =====================================================
       MAGNETIC BUTTONS
    ===================================================== */
    function initMagneticButtons() {

        const magnets = document.querySelectorAll(
            ".magnetic, .menu-btn, .checkout-button, .add-btn, .register-btn"
        );

        if (!magnets.length) return;

        if (window.matchMedia("(pointer: coarse)").matches) return;

        magnets.forEach(function (el) {

            el.addEventListener("mousemove", function (e) {
                const rect = el.getBoundingClientRect();
                const x = e.clientX - rect.left - rect.width / 2;
                const y = e.clientY - rect.top - rect.height / 2;

                el.style.transform =
                    "translate(" +
                    x * 0.22 +
                    "px, " +
                    y * 0.32 +
                    "px)";
            });

            el.addEventListener("mouseleave", function () {
                el.style.transform = "";
            });
        });
    }


    /* =====================================================
       PARALLAX
    ===================================================== */
    function initParallax() {

        const items = document.querySelectorAll(".parallax");

        if (!items.length) return;

        let ticking = false;

        function update() {

            const scrollY = window.scrollY;

            items.forEach(function (el) {
                const speed = parseFloat(el.dataset.speed || "0.3");
                const rect = el.getBoundingClientRect();
                const offset = rect.top + scrollY - window.innerHeight / 2;
                const y = -offset * speed;

                el.style.transform = "translate3d(0, " + y + "px, 0)";
            });

            ticking = false;
        }

        window.addEventListener("scroll", function () {
            if (!ticking) {
                requestAnimationFrame(update);
                ticking = true;
            }
        }, { passive: true });

        update();
    }


    /* =====================================================
       NUMBER COUNT-UP
    ===================================================== */
    function initCountUp() {

        const counters = document.querySelectorAll(".count-up");

        if (!counters.length) return;

        if (!("IntersectionObserver" in window)) {
            counters.forEach(function (el) {
                el.textContent = el.dataset.target || el.textContent;
            });
            return;
        }

        const observer = new IntersectionObserver(function (entries, obs) {

            entries.forEach(function (entry) {

                if (!entry.isIntersecting) return;

                const el = entry.target;

                const target = parseFloat(el.dataset.target || el.textContent);
                const duration = parseInt(el.dataset.duration || "1400", 10);
                const prefix = el.dataset.prefix || "";
                const suffix = el.dataset.suffix || "";
                const decimals = parseInt(el.dataset.decimals || "0", 10);

                const start = performance.now();

                function step(now) {
                    const progress = Math.min((now - start) / duration, 1);
                    const eased = 1 - Math.pow(1 - progress, 3);
                    const value = (target * eased).toFixed(decimals);

                    el.textContent = prefix + value + suffix;

                    if (progress < 1) {
                        requestAnimationFrame(step);
                    } else {
                        el.textContent = prefix + target.toFixed(decimals) + suffix;
                    }
                }

                requestAnimationFrame(step);
                obs.unobserve(el);
            });

        }, { threshold: 0.3 });

        counters.forEach(function (el) { observer.observe(el); });
    }


    /* =====================================================
       TEXT LETTER REVEAL
    ===================================================== */
    function initSplitText() {

        const targets = document.querySelectorAll(".split-text");

        if (!targets.length) return;

        targets.forEach(function (el) {

            const text = el.textContent.trim();
            el.textContent = "";

            text.split("").forEach(function (ch, i) {

                const span = document.createElement("span");
                span.textContent = ch === " " ? "\u00A0" : ch;
                span.style.animationDelay = (i * 0.035) + "s";

                el.appendChild(span);
            });
        });
    }


    /* =====================================================
       TOAST
    ===================================================== */
    let toastTimer = null;

    function showToast(message) {

        let toast = document.getElementById("foodyToast");

        if (!toast) {
            toast = document.createElement("div");
            toast.id = "foodyToast";
            toast.className = "foody-toast";
            document.body.appendChild(toast);
        }

        toast.textContent = message;
        toast.classList.add("show");

        clearTimeout(toastTimer);

        toastTimer = setTimeout(function () {
            toast.classList.remove("show");
        }, 2400);
    }


    /* =====================================================
       CONFETTI
    ===================================================== */
    function burstConfetti(count) {

        count = count || 80;

        const colors = [
            "#b94b33", "#485c46", "#d7a05a",
            "#e8d5b7", "#7a9e7e", "#96331f"
        ];

        for (let i = 0; i < count; i++) {

            const piece = document.createElement("div");
            piece.className = "confetti-piece";

            piece.style.left = Math.random() * 100 + "vw";
            piece.style.background =
                colors[Math.floor(Math.random() * colors.length)];
            piece.style.width = (6 + Math.random() * 8) + "px";
            piece.style.height = (6 + Math.random() * 8) + "px";
            piece.style.animationDuration = (2 + Math.random() * 2) + "s";
            piece.style.animationDelay = (Math.random() * 0.5) + "s";
            piece.style.opacity = 0.7 + Math.random() * 0.3;

            document.body.appendChild(piece);

            setTimeout(function () {
                piece.remove();
            }, 5000);
        }
    }

})();