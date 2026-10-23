<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.Map" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.DaoImpl.RestaurantDaoImpl" %>

<%
    @SuppressWarnings("unchecked")
    Map<Integer, CartItem> cart =
        (Map<Integer, CartItem>) session.getAttribute("cart");

    /* =====================================================
       1. ITEM TOTAL + CART COUNT
    ===================================================== */

    double itemTotal = 0;
    int cartCount = 0;

    if (cart != null) {
        for (CartItem item : cart.values()) {
            itemTotal += item.getTotalPrice();
            cartCount += item.getQuantity();
        }
    }

    /* =====================================================
       2. GET RESTAURANT DISCOUNT
    ===================================================== */

    int discountPercent = 0;
    double discountAmount = 0;
    double discountedSubtotal = itemTotal;

    String restaurantName = "Restaurant";

    if (cart != null && !cart.isEmpty()) {

        CartItem firstItem = cart.values().iterator().next();

        int restaurantId = firstItem.getMenu().getRestaurantId();

        RestaurantDaoImpl restaurantDao =
            new RestaurantDaoImpl();

        Restaurant restaurant =
            restaurantDao.getRestaurant(restaurantId);

        if (restaurant != null) {
            discountPercent = restaurant.getDiscountPercent();
            restaurantName = restaurant.getName();

            discountAmount = itemTotal * discountPercent / 100.0;
            discountedSubtotal = itemTotal - discountAmount;
        }
    }

    /* =====================================================
       3. FREE DELIVERY (on discounted subtotal > 300)
    ===================================================== */

    boolean freeDelivery = (discountedSubtotal > 300 && cartCount > 0);

    double deliveryFee;
    if (freeDelivery) {
        deliveryFee = 0;
    } else if (cartCount > 0) {
        deliveryFee = 40;
    } else {
        deliveryFee = 0;
    }

    /* =====================================================
       4. TAX (on discounted subtotal)
    ===================================================== */

    double taxes = discountedSubtotal * 0.05;

    /* =====================================================
       5. FINAL TOTAL
    ===================================================== */

    double finalTotal = discountedSubtotal + deliveryFee + taxes;
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Foody - Cart</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Playfair+Display:ital,wght@0,500;0,600;0,700;1,500&display=swap" rel="stylesheet">

<style>
:root {
	--ink: #202821;
	--muted: #71786f;
	--paper: #f4f2ea;
	--surface: #fffefa;
	--tomato: #b94b33;
	--tomato-dark: #943922;
	--sage: #485c46;
	--line: #e6e3d9;
	--serif: "Playfair Display", Georgia, serif;
	--sans: "DM Sans", "Segoe UI", sans-serif;
}

*, *::before, *::after {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

html, body { overflow-x: hidden; }

body {
	min-width: 320px;
	color: var(--ink);
	background:
		radial-gradient(ellipse at 8% 18%, rgba(190, 202, 166, 0.20), transparent 29rem),
		radial-gradient(ellipse at 92% 88%, rgba(212, 151, 112, 0.14), transparent 26rem),
		var(--paper);
	font-family: var(--sans);
	-webkit-font-smoothing: antialiased;
	animation: pageFadeIn 0.6s ease both;
}

@keyframes pageFadeIn { from { opacity: 0; } to { opacity: 1; } }

a { text-decoration: none; color: inherit; }

a:focus-visible, button:focus-visible, input:focus-visible {
	outline: 3px solid rgba(72, 92, 70, 0.55);
	outline-offset: 3px;
}

.scroll-progress {
	position: fixed;
	top: 0;
	left: 0;
	height: 3px;
	width: 0%;
	background: linear-gradient(90deg, var(--tomato), #d7a05a, var(--sage));
	z-index: 9999;
	transition: width 0.1s linear;
	box-shadow: 0 0 12px rgba(185, 75, 51, 0.5);
}

.back-to-top {
	position: fixed;
	bottom: 30px;
	right: 30px;
	width: 46px;
	height: 46px;
	border-radius: 50%;
	background: var(--tomato);
	color: white;
	border: none;
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 20px;
	font-weight: bold;
	box-shadow: 0 8px 24px rgba(185, 75, 51, 0.35);
	opacity: 0;
	visibility: hidden;
	transform: translateY(20px) scale(0.8);
	transition: opacity 0.4s ease, visibility 0.4s ease, transform 0.5s cubic-bezier(.2, 1.2, .4, 1), background-color 0.3s ease;
	z-index: 5000;
}

.back-to-top.show {
	opacity: 1;
	visibility: visible;
	transform: translateY(0) scale(1);
}

.back-to-top::after {
	content: "";
	position: absolute;
	inset: -6px;
	border-radius: 50%;
	border: 2px solid rgba(185, 75, 51, 0.35);
	opacity: 0;
	transform: scale(0.9);
}

.back-to-top.show::after {
	animation: ringPulse 2.4s ease-out infinite;
}

@keyframes ringPulse { 0% { opacity: 0.6; transform: scale(0.9); } 100% { opacity: 0; transform: scale(1.4); } }

.back-to-top:hover {
	background: var(--tomato-dark);
	transform: translateY(-5px) scale(1.12) rotate(-6deg);
}

.back-to-top:active { transform: scale(0.9); }

.page-container {
	position: relative;
	z-index: 1;
	width: min(1200px, calc(100% - 64px));
	margin: 48px auto 72px;
}

.page-heading {
	margin-bottom: 30px;
	padding-bottom: 22px;
	border-bottom: 1px solid var(--line);
	position: relative;
	opacity: 0;
	animation: fadeRise 1s .1s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes fadeRise { from { opacity: 0; transform: translateY(38px); } to { opacity: 1; transform: translateY(0); } }

.page-heading::after {
	content: "";
	position: absolute;
	left: 0;
	bottom: -1px;
	height: 2px;
	width: 0;
	background: linear-gradient(90deg, var(--tomato), transparent);
	animation: headerLineGrow 1.6s .5s cubic-bezier(.2, .75, .25, 1) forwards;
}

@keyframes headerLineGrow { to { width: 100%; } }

.page-heading h1 {
	color: var(--ink);
	font: 500 clamp(2.2rem, 5vw, 3.2rem) / 1.1 var(--serif);
	display: inline-block;
	animation: titleFadeIn 1s .2s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes titleFadeIn { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }

.page-heading p {
	margin-top: 8px;
	color: var(--muted);
	font-size: 0.9rem;
	animation: subtitleSlide 1.2s .6s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes subtitleSlide { from { opacity: 0; transform: translateX(-20px); } to { opacity: 1; transform: translateX(0); } }

.cart-layout {
	display: grid;
	grid-template-columns: minmax(0, 1fr) 360px;
	gap: 28px;
	align-items: start;
}

.cart-items {
	background: var(--surface);
	border: 1px solid rgba(32, 40, 33, 0.07);
	border-radius: 14px;
	padding: 8px 24px;
	box-shadow: 0 7px 22px rgba(32, 40, 33, 0.055);
	animation: fadeRise 1s .25s cubic-bezier(.2, .75, .25, 1) both;
}

.cart-item {
	display: grid;
	grid-template-columns: 120px 1fr auto;
	gap: 20px;
	align-items: center;
	padding: 22px 0;
	border-bottom: 1px solid #eeeeee;
	opacity: 1;
	transform: translateY(0);
	transition: opacity .8s cubic-bezier(.2, .75, .25, 1), transform .5s cubic-bezier(.2, .75, .25, 1), background-color .4s ease, padding .35s ease;
}

.cart-item:last-child { border-bottom: none; }

body.js-reveal .cart-item.reveal { opacity: 0; transform: translateX(-40px); }
body.js-reveal .cart-item.reveal.visible { opacity: 1; transform: translateX(0); }

.cart-item:hover {
	background: #f7f7f0;
	padding-left: 14px;
	padding-right: 14px;
	border-radius: 8px;
}

.food-image {
	width: 120px;
	height: 100px;
	object-fit: cover;
	border-radius: 10px;
	background: #eeeeee;
	transition: transform .6s cubic-bezier(.2, .65, .3, 1), box-shadow .4s ease;
}

.cart-item:hover .food-image {
	transform: scale(1.06);
	box-shadow: 0 12px 24px rgba(32, 40, 33, 0.18);
}

.item-name {
	font-size: 1.15rem;
	font-weight: 700;
	margin-bottom: 6px;
	color: var(--ink);
	font-family: var(--serif);
	transition: color .3s ease, transform .35s cubic-bezier(.2, .75, .25, 1);
}

.cart-item:hover .item-name {
	color: var(--tomato-dark);
	transform: translateX(4px);
}

.item-price {
	color: var(--muted);
	font-size: 14px;
	margin-bottom: 12px;
}

.quantity-box {
	display: flex;
	align-items: center;
	gap: 8px;
}

.quantity-form { display: inline; }

.quantity-button {
	width: 34px;
	height: 34px;
	border: 1px solid #ddd;
	background: white;
	border-radius: 6px;
	cursor: pointer;
	font-size: 18px;
	line-height: 1;
	font-weight: 700;
	color: var(--sage);
	transition: background-color .35s ease, color .35s ease, border-color .35s ease, transform .35s cubic-bezier(.2, .75, .25, 1), box-shadow .35s ease;
}

.quantity-button:hover {
	border-color: var(--sage);
	color: white;
	background: var(--sage);
	transform: translateY(-3px) scale(1.06);
	box-shadow: 0 8px 18px rgba(72, 92, 70, 0.22);
}

.quantity-button:active { transform: scale(0.88) rotate(8deg); }

.quantity {
	min-width: 30px;
	text-align: center;
	font-weight: 800;
	color: var(--ink);
	display: inline-block;
	animation: qtyPop .5s cubic-bezier(.2, 1.4, .4, 1);
}

@keyframes qtyPop { 0% { transform: scale(.5) rotateX(-90deg); opacity: 0; } 70% { transform: scale(1.25) rotateX(0); opacity: 1; } 100% { transform: scale(1) rotateX(0); } }

.remove-form { margin-top: 9px; }

.remove-button {
	border: none;
	background: none;
	color: var(--tomato);
	cursor: pointer;
	font-size: 13px;
	font-weight: 700;
	padding: 0;
	position: relative;
	transition: color .3s ease, transform .3s ease;
}

.remove-button::after {
	content: "";
	position: absolute;
	bottom: -3px;
	left: 0;
	width: 100%;
	height: 1px;
	background: currentColor;
	transform: scaleX(0);
	transform-origin: right;
	transition: transform .4s cubic-bezier(.2, .75, .25, 1);
}

.remove-button:hover::after { transform: scaleX(1); transform-origin: left; }

.remove-button:hover {
	color: var(--tomato-dark);
	transform: translateX(2px);
}

.item-total {
	font-size: 18px;
	font-weight: 700;
	text-align: right;
	white-space: nowrap;
	color: var(--ink);
	transition: color .3s ease, transform .4s cubic-bezier(.2, 1.4, .4, 1);
}

.cart-item:hover .item-total {
	color: var(--tomato);
	transform: scale(1.08);
}

.summary {
	background: var(--surface);
	border: 1px solid rgba(32, 40, 33, 0.07);
	border-radius: 14px;
	padding: 26px;
	box-shadow: 0 7px 22px rgba(32, 40, 33, 0.055);
	position: sticky;
	top: 95px;
	animation: summarySlide 1s .35s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes summarySlide { from { opacity: 0; transform: translateX(50px) scale(.96); } to { opacity: 1; transform: translateX(0) scale(1); } }

.summary h2 {
	font-size: 1.4rem;
	margin-bottom: 22px;
	color: var(--ink);
	font-family: var(--serif);
	font-weight: 600;
	transition: color .3s ease;
}

.summary h2::after {
	content: "";
	display: block;
	width: 44px;
	height: 3px;
	border-radius: 3px;
	background: var(--tomato);
	margin-top: 10px;
	transition: width .4s cubic-bezier(.2, .75, .25, 1);
}

.summary:hover h2::after { width: 70px; }

.summary-row {
	display: flex;
	justify-content: space-between;
	margin-bottom: 16px;
	color: var(--muted);
	font-size: 15px;
	opacity: 0;
	animation: fadeRise 0.7s cubic-bezier(.2, .75, .25, 1) both;
	transition: color .3s ease;
}

.summary-row:nth-of-type(1) { animation-delay: .5s; }
.summary-row:nth-of-type(2) { animation-delay: .58s; }
.summary-row:nth-of-type(3) { animation-delay: .66s; }
.summary-row:nth-of-type(4) { animation-delay: .74s; }

.summary-row:hover { color: var(--ink); }

.summary-row span:last-child {
	color: var(--ink);
	font-weight: 600;
}

.summary-row.discount,
.summary-row.discount span:last-child {
	color: #2f7d45;
	font-weight: 700;
}

.summary-row.delivery-free span:last-child {
	color: #2f7d45;
	font-weight: 800;
	animation: freePulse 1.6s ease-in-out infinite;
}

@keyframes freePulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.08); } }

.summary-total {
	display: flex;
	justify-content: space-between;
	border-top: 1px solid var(--line);
	margin-top: 20px;
	padding-top: 18px;
	font-size: 1.3rem;
	font-weight: 700;
	color: var(--ink);
	animation: fadeRise 0.7s .8s cubic-bezier(.2, .75, .25, 1) both;
}

.summary-total span:last-child {
	color: var(--tomato);
	animation: totalPulse 2.4s ease-in-out 1.6s infinite;
}

@keyframes totalPulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.08); } }

.free-note {
	margin-top: -6px;
	margin-bottom: 14px;
	font-size: 12px;
	color: #2f7d45;
	font-weight: 600;
	letter-spacing: 0.01em;
	opacity: 0;
	animation: fadeRise 0.7s .65s cubic-bezier(.2, .75, .25, 1) both;
}

.free-note strong { color: var(--tomato); }

.checkout-button {
	display: block;
	width: 100%;
	margin-top: 24px;
	padding: 15px;
	background: var(--tomato);
	color: white;
	text-align: center;
	border-radius: 8px;
	font-size: 16px;
	font-weight: 700;
	position: relative;
	overflow: hidden;
	z-index: 0;
	transition: transform .4s cubic-bezier(.2, .75, .25, 1), background-color .35s ease, box-shadow .35s ease;
}

.checkout-button::before {
	content: "";
	position: absolute;
	top: 0;
	left: -100%;
	width: 100%;
	height: 100%;
	background: linear-gradient(100deg, transparent, rgba(255, 255, 255, 0.35), transparent);
	transition: left .7s ease;
}

.checkout-button:hover::before { left: 100%; }

.checkout-button:hover {
	transform: translateY(-5px);
	background: var(--tomato-dark);
	box-shadow: 0 14px 28px rgba(185, 75, 51, 0.35);
}

.checkout-button:active { transform: scale(0.97); }

.continue-button {
	display: block;
	width: 100%;
	margin-top: 12px;
	padding: 13px;
	border: 1px solid var(--line);
	background: white;
	color: var(--sage);
	text-align: center;
	border-radius: 8px;
	font-size: 14px;
	font-weight: 700;
	transition: transform .35s cubic-bezier(.2, .75, .25, 1), background-color .3s ease, color .3s ease;
}

.continue-button:hover {
	transform: translateY(-3px);
	background: #f0f2e9;
	color: var(--sage);
}

.continue-button:active { transform: scale(0.97); }

.empty-cart {
	background: var(--surface);
	border: 1px solid rgba(32, 40, 33, 0.07);
	border-radius: 14px;
	padding: 90px 25px;
	text-align: center;
	box-shadow: 0 7px 22px rgba(32, 40, 33, 0.055);
	opacity: 0;
	animation: emptyCartPop 1s .2s cubic-bezier(.2, 1.3, .4, 1) both;
}

@keyframes emptyCartPop { from { opacity: 0; transform: scale(.9) translateY(30px); } to { opacity: 1; transform: scale(1) translateY(0); } }

.empty-icon {
	font-size: 4rem;
	margin-bottom: 20px;
	display: inline-block;
	animation: float 3.4s ease-in-out infinite;
}

@keyframes float { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-14px); } }

.empty-cart h2 {
	font-size: 1.9rem;
	margin-bottom: 10px;
	color: var(--ink);
	font-family: var(--serif);
	font-weight: 500;
}

.empty-cart p {
	color: var(--muted);
	margin-bottom: 26px;
	font-size: 0.95rem;
}

.browse-button {
	display: inline-block;
	padding: 13px 26px;
	background: var(--tomato);
	color: white;
	border-radius: 8px;
	font-weight: 700;
	position: relative;
	overflow: hidden;
	transition: transform .4s cubic-bezier(.2, .75, .25, 1), background-color .35s ease, box-shadow .35s ease;
}

.browse-button::before {
	content: "";
	position: absolute;
	top: 0;
	left: -100%;
	width: 100%;
	height: 100%;
	background: linear-gradient(100deg, transparent, rgba(255, 255, 255, 0.35), transparent);
	transition: left .7s ease;
}

.browse-button:hover::before { left: 100%; }

.browse-button:hover {
	transform: translateY(-5px);
	background: var(--tomato-dark);
	box-shadow: 0 12px 24px rgba(185, 75, 51, 0.35);
}

.browse-button:active { transform: scale(0.96); }

/* =========================================================
   FREE DELIVERY CELEBRATION
========================================================= */

.celebrate-overlay {
	position: fixed;
	inset: 0;
	z-index: 99999;
	pointer-events: none;
	overflow: hidden;
	display: none;
}

.celebrate-overlay.active {
	display: block;
	animation: celebrateFlash 2.2s ease-out forwards;
}

@keyframes celebrateFlash { 0% { background: rgba(20, 25, 20, 0); } 10% { background: rgba(20, 25, 20, 0.35); } 50% { background: rgba(20, 25, 20, 0.15); } 100% { background: rgba(20, 25, 20, 0); } }

.celebrate-banner {
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%) scale(0.5);
	opacity: 0;
	padding: 26px 44px;
	background: linear-gradient(135deg, #fffefa, #f4f2ea);
	border: 1px solid rgba(185, 75, 51, 0.18);
	border-radius: 18px;
	text-align: center;
	box-shadow: 0 30px 80px rgba(0, 0, 0, 0.28), 0 0 0 1px rgba(185, 75, 51, 0.1);
	animation: bannerDrop 0.9s 0.15s cubic-bezier(0.2, 1.4, 0.4, 1) forwards, bannerExit 0.5s 3.2s ease-in forwards;
	animation-fill-mode: both;
}

@keyframes bannerDrop { 0% { opacity: 0; transform: translate(-50%, -50%) scale(0.5) rotate(-8deg); } 60% { opacity: 1; transform: translate(-50%, -50%) scale(1.08) rotate(2deg); } 100% { opacity: 1; transform: translate(-50%, -50%) scale(1) rotate(0); } }

@keyframes bannerExit { to { opacity: 0; transform: translate(-50%, -50%) scale(0.85); } }

.celebrate-emoji {
	font-size: 3rem;
	margin-bottom: 8px;
	display: inline-block;
	animation: emojiSpin 1s ease-in-out infinite;
}

@keyframes emojiSpin { 0%, 100% { transform: rotate(0deg) scale(1); } 25% { transform: rotate(-12deg) scale(1.15); } 75% { transform: rotate(12deg) scale(1.15); } }

.celebrate-title {
	font-family: "Playfair Display", Georgia, serif;
	font-size: clamp(1.6rem, 4.5vw, 2.4rem);
	font-weight: 700;
	letter-spacing: -0.01em;
	color: #b94b33;
	margin-bottom: 6px;
	text-shadow: 0 2px 0 rgba(255, 255, 255, 0.8);
}

.celebrate-subtitle {
	color: #485c46;
	font-size: 0.95rem;
	font-weight: 600;
}

.celebrate-ring {
	position: absolute;
	top: 50%;
	left: 50%;
	width: 20px;
	height: 20px;
	border: 3px solid rgba(185, 75, 51, 0.7);
	border-radius: 50%;
	transform: translate(-50%, -50%);
	animation: ringExpand 1.2s ease-out forwards;
	pointer-events: none;
}

@keyframes ringExpand { 0% { opacity: 1; width: 20px; height: 20px; border-width: 6px; } 100% { opacity: 0; width: 500px; height: 500px; border-width: 1px; } }

.burst-particle {
	position: absolute;
	width: 10px;
	height: 10px;
	border-radius: 50%;
	pointer-events: none;
	animation: burstFly 1.4s cubic-bezier(0.15, 0.55, 0.4, 1) forwards;
}

@keyframes burstFly { 0% { opacity: 1; transform: translate(0, 0) scale(1); } 100% { opacity: 0; transform: translate(var(--dx), var(--dy)) scale(0.3); } }

.celebrate-confetti {
	position: absolute;
	top: -20px;
	width: 9px;
	height: 14px;
	opacity: 0.95;
	animation: confettiDance linear forwards;
}

@keyframes confettiDance { 0% { transform: translateY(0) rotate(0deg); opacity: 1; } 100% { transform: translateY(105vh) rotate(720deg); opacity: 0; } }

@media (max-width: 900px) {
	.cart-layout { grid-template-columns: 1fr; }
	.summary { position: static; }
}

@media (max-width: 650px) {
	.page-container { width: calc(100% - 36px); margin: 34px auto 50px; }
	.page-heading h1 { font-size: 2.2rem; }
	.cart-item { grid-template-columns: 82px minmax(0, 1fr); gap: 13px; }
	.food-image { width: 82px; height: 78px; }
	.item-total { grid-column: 2; text-align: left; }
	.cart-items { padding: 4px 16px; }
	.summary { padding: 22px; }
	.celebrate-banner { padding: 20px 26px; max-width: 90vw; }
}

@media (prefers-reduced-motion: reduce) {
	*, *::before, *::after {
		scroll-behavior: auto !important;
		animation-duration: 0.01ms !important;
		animation-iteration-count: 1 !important;
		transition-duration: 0.01ms !important;
	}
}
</style>

</head>

<body>
<!-- SCROLL PROGRESS -->
<div class="scroll-progress" id="scrollProgress"></div>

<!-- FREE DELIVERY CELEBRATION -->
<div id="freeDeliveryCelebration" class="celebrate-overlay" aria-hidden="true">
	<div class="celebrate-banner">
		<div class="celebrate-emoji">🎉</div>
		<div class="celebrate-title">FREE DELIVERY UNLOCKED!</div>
		<div class="celebrate-subtitle">You just saved ₹40 on this order</div>
	</div>
</div>

<!-- HEADER -->
<jsp:include page="/include/header.jsp" />

<!-- MAIN -->
<div class="page-container">

	<div class="page-heading">
		<h1>Your Cart 🛒</h1>
		<p>Review your items before placing your order.</p>
	</div>

	<%
		if (cart != null && !cart.isEmpty()) {
	%>

	<div class="cart-layout">

		<div class="cart-items">

			<%
				int itemIndex = 0;

				for (CartItem item : cart.values()) {

					itemIndex++;
			%>

			<div class="cart-item reveal"
				style="transition-delay: <%= (itemIndex % 5) * 0.07 %>s;">

				<img class="food-image"
					src="<%= item.getMenu().getImagePath() %>"
					alt="<%= item.getMenu().getItemName() %>">

				<div>

					<div class="item-name">
						<%= item.getMenu().getItemName() %>
					</div>

					<div class="item-price">
						₹<%= String.format("%.2f", item.getMenu().getPrice()) %>
						per item
					</div>

					<div class="quantity-box">

						<form class="quantity-form" action="cart" method="post">
							<input type="hidden" name="action" value="decrease">
							<input type="hidden" name="menuId" value="<%= item.getMenu().getMenuId() %>">
							<input type="hidden" name="returnPage" value="cart">
							<button type="submit" class="quantity-button">−</button>
						</form>

						<span class="quantity"><%= item.getQuantity() %></span>

						<form class="quantity-form" action="cart" method="post">
							<input type="hidden" name="action" value="increase">
							<input type="hidden" name="menuId" value="<%= item.getMenu().getMenuId() %>">
							<input type="hidden" name="returnPage" value="cart">
							<button type="submit" class="quantity-button">+</button>
						</form>

					</div>

					<form class="remove-form" action="cart" method="post">
						<input type="hidden" name="action" value="remove">
						<input type="hidden" name="menuId" value="<%= item.getMenu().getMenuId() %>">
						<input type="hidden" name="returnPage" value="cart">
						<button type="submit" class="remove-button">Remove</button>
					</form>

				</div>

				<div class="item-total">
					₹<%= String.format("%.2f", item.getTotalPrice()) %>
				</div>

			</div>

			<%
				}
			%>

		</div>

		<div class="summary">

			<h2>Order Summary</h2>

			<!-- ITEM TOTAL -->
			<div class="summary-row">
				<span>Item Total</span>
				<span>₹<%= String.format("%.2f", itemTotal) %></span>
			</div>

			<!-- RESTAURANT DISCOUNT -->
			<%
				if (discountPercent > 0) {
			%>

			<div class="summary-row discount">
				<span>Restaurant Discount (<%= discountPercent %>%)</span>
				<span>-₹<%= String.format("%.2f", discountAmount) %></span>
			</div>

			<%
				}
			%>

			<!-- DISCOUNTED SUBTOTAL (only if discount applied) -->
			<%
				if (discountPercent > 0) {
			%>

			<div class="summary-row">
				<span>Discounted Subtotal</span>
				<span>₹<%= String.format("%.2f", discountedSubtotal) %></span>
			</div>

			<%
				}
			%>

			<!-- DELIVERY FEE -->
			<div class="summary-row <%= freeDelivery ? "delivery-free" : "" %>">
				<span>Delivery Fee</span>
				<span>
					<%
						if (freeDelivery) {
					%>
						FREE
					<%
						} else {
					%>
						₹<%= String.format("%.2f", deliveryFee) %>
					<%
						}
					%>
				</span>
			</div>

			<!-- "ADD MORE" HINT -->
			<%
				if (!freeDelivery && cartCount > 0) {

					double remaining = 300 - discountedSubtotal;

					if (remaining > 0) {
			%>

			<div class="free-note">
				Add <strong>₹<%= String.format("%.2f", remaining) %></strong>
				more to unlock FREE delivery 🚚
			</div>

			<%
					}
				}
			%>

			<!-- TAXES -->
			<div class="summary-row">
				<span>Taxes (5%)</span>
				<span>₹<%= String.format("%.2f", taxes) %></span>
			</div>

			<!-- TOTAL -->
			<div class="summary-total">
				<span>Total</span>
				<span>₹<%= String.format("%.2f", finalTotal) %></span>
			</div>

			<a href="checkout" class="checkout-button">
				Proceed to Checkout
			</a>

			<a href="restaurants" class="continue-button">
				← Continue Shopping
			</a>

		</div>

	</div>

	<%
		} else {
	%>

	<div class="empty-cart">

		<div class="empty-icon">🛒</div>

		<h2>Cart is empty.</h2>

		<p>Add some delicious food from our restaurants.</p>

		<a href="restaurants" class="browse-button">
			Browse Restaurants
		</a>

	</div>

	<%
		}
	%>

</div>

<!-- FOOTER -->
<jsp:include page="/include/footer.jsp" />

<!-- BACK TO TOP -->
<button id="backToTop" class="back-to-top" aria-label="Back to top">↑</button>

<!-- SCRIPT -->
<script>

/* =====================================================
   1. SCROLL PROGRESS BAR
===================================================== */
(function () {
	var bar = document.getElementById("scrollProgress");
	if (!bar) return;

	function update() {
		var scrollTop = window.pageYOffset || document.documentElement.scrollTop;
		var docHeight = document.documentElement.scrollHeight - window.innerHeight;
		var percent = docHeight > 0 ? (scrollTop / docHeight) * 100 : 0;
		bar.style.width = percent + "%";
	}

	window.addEventListener("scroll", update, { passive: true });
	window.addEventListener("resize", update);
	update();
})();

/* =====================================================
   2. SCROLL REVEAL
===================================================== */
document.addEventListener("DOMContentLoaded", function () {

	document.body.classList.add("js-reveal");

	var revealElements = document.querySelectorAll(".reveal");

	if (!("IntersectionObserver" in window)) {
		for (var i = 0; i < revealElements.length; i++) {
			revealElements[i].classList.add("visible");
		}
		return;
	}

	var observer = new IntersectionObserver(function (entries, obs) {
		entries.forEach(function (entry) {
			if (entry.isIntersecting) {
				entry.target.classList.add("visible");
				obs.unobserve(entry.target);
			}
		});
	}, { threshold: 0.05, rootMargin: "0px 0px -40px 0px" });

	revealElements.forEach(function (el) {
		observer.observe(el);
	});

	setTimeout(function () {
		document.querySelectorAll(".reveal:not(.visible)").forEach(function (el) {
			el.classList.add("visible");
		});
	}, 2000);
});

/* =====================================================
   3. BACK TO TOP
===================================================== */
(function () {
	var btn = document.getElementById("backToTop");
	if (!btn) return;

	window.addEventListener("scroll", function () {
		if (window.pageYOffset > 400) {
			btn.classList.add("show");
		} else {
			btn.classList.remove("show");
		}
	}, { passive: true });

	btn.addEventListener("click", function () {
		window.scrollTo({ top: 0, behavior: "smooth" });
	});
})();

/* =====================================================
   4. FREE DELIVERY CELEBRATION — with RE-ARM
===================================================== */
(function () {

	var FREE_DELIVERY_ACTIVE =
		<%= freeDelivery ? "true" : "false" %>;

	var SESSION_KEY = "foodyFreeDeliveryCelebrated";
	var alreadyCelebrated = sessionStorage.getItem(SESSION_KEY) === "1";

	/* CASE 1: Below 300 → re-arm */
	if (!FREE_DELIVERY_ACTIVE) {
		if (alreadyCelebrated) {
			sessionStorage.removeItem(SESSION_KEY);
			console.log("[Foody] Free delivery re-armed (cart below 300).");
		}
		return;
	}

	/* CASE 2: Already celebrated → do nothing */
	if (alreadyCelebrated) {
		return;
	}

	/* CASE 3: Fire! */
	sessionStorage.setItem(SESSION_KEY, "1");

	window.addEventListener("load", function () {
		setTimeout(runCelebration, 500);
	});

	function runCelebration() {

		var overlay = document.getElementById("freeDeliveryCelebration");
		if (!overlay) return;

		overlay.classList.add("active");

		spawnRing(overlay, 0);
		spawnRing(overlay, 250);

		spawnBurst(overlay, window.innerWidth / 2, window.innerHeight / 2, 70);

		var spots = [
			{ x: 0.15, y: 0.25 },
			{ x: 0.85, y: 0.30 },
			{ x: 0.25, y: 0.75 },
			{ x: 0.78, y: 0.70 },
			{ x: 0.50, y: 0.20 }
		];

		spots.forEach(function (spot, i) {
			setTimeout(function () {
				spawnBurst(overlay, window.innerWidth * spot.x, window.innerHeight * spot.y, 35);
			}, 300 + i * 180);
		});

		for (var i = 0; i < 60; i++) {
			spawnConfetti(overlay, i);
		}

		setTimeout(function () {
			overlay.classList.remove("active");
			overlay.innerHTML =
				'<div class="celebrate-banner">' +
					'<div class="celebrate-emoji">🎉</div>' +
					'<div class="celebrate-title">FREE DELIVERY UNLOCKED!</div>' +
					'<div class="celebrate-subtitle">You just saved ₹40 on this order</div>' +
				'</div>';
		}, 4200);
	}

	function spawnRing(parent, delay) {
		setTimeout(function () {
			var ring = document.createElement("div");
			ring.className = "celebrate-ring";
			parent.appendChild(ring);
			setTimeout(function () { ring.remove(); }, 1500);
		}, delay);
	}

	function spawnBurst(parent, cx, cy, count) {

		var colors = ["#b94b33", "#485c46", "#d7a05a", "#e8d5b7", "#7a9e7e", "#ff5a36", "#ffd166", "#06d6a0"];

		for (var i = 0; i < count; i++) {

			var p = document.createElement("div");
			p.className = "burst-particle";

			var angle = (Math.PI * 2 * i) / count + (Math.random() * 0.3 - 0.15);
			var distance = 160 + Math.random() * 320;
			var size = 6 + Math.random() * 10;

			p.style.left = cx + "px";
			p.style.top = cy + "px";
			p.style.width = size + "px";
			p.style.height = size + "px";
			p.style.background = colors[Math.floor(Math.random() * colors.length)];

			p.style.setProperty("--dx", (Math.cos(angle) * distance) + "px");
			p.style.setProperty("--dy", (Math.sin(angle) * distance) + "px");

			if (Math.random() > 0.5) { p.style.borderRadius = "2px"; }

			p.style.animationDuration = (0.9 + Math.random() * 0.9) + "s";
			parent.appendChild(p);

			setTimeout(function () { p.remove(); }, 2000);
		}
	}

	function spawnConfetti(parent, index) {

		var colors = ["#b94b33", "#485c46", "#d7a05a", "#ff5a36", "#ffd166", "#06d6a0"];

		var c = document.createElement("div");
		c.className = "celebrate-confetti";

		c.style.left = (Math.random() * 100) + "vw";
		c.style.background = colors[Math.floor(Math.random() * colors.length)];
		c.style.animationDuration = (2.2 + Math.random() * 1.8) + "s";
		c.style.animationDelay = (Math.random() * 1.2) + "s";
		c.style.width = (6 + Math.random() * 6) + "px";

		if (Math.random() > 0.5) { c.style.borderRadius = "50%"; }

		parent.appendChild(c);
		setTimeout(function () { c.remove(); }, 5500);
	}

})();

</script>

</body>

</html>