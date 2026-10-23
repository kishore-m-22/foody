<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.LinkedHashMap"%>
<%@ page import="com.tap.model.Menu"%>
<%@ page import="com.tap.model.CartItem"%>

<%
List<Menu> menus = (List<Menu>) request.getAttribute("menus");
Integer restaurantId = (Integer) request.getAttribute("restaurantId");

if (menus == null) { menus = new java.util.ArrayList<>(); }
if (restaurantId == null) { restaurantId = 0; }

@SuppressWarnings("unchecked")
Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

if (cart == null) {
    cart = new LinkedHashMap<>();
    session.setAttribute("cart", cart);
}

int cartCount = 0;
double menuItemTotal = 0;

for (CartItem item : cart.values()) {
    cartCount += item.getQuantity();
    menuItemTotal += item.getTotalPrice();
}

boolean freeDelivery = (menuItemTotal > 300 && cartCount > 0);

String cartConflict = request.getParameter("cartConflict");
String cartPopup = (String) session.getAttribute("cartPopup");

if (cartPopup != null) { session.removeAttribute("cartPopup"); }
%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Foody - Menu</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Playfair+Display:ital,wght@0,500;0,600;0,700;1,500;1,600&display=swap" rel="stylesheet">

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
	background: radial-gradient(ellipse at 92% 8%, rgba(190, 202, 166, 0.20), transparent 29rem), radial-gradient(ellipse at 8% 92%, rgba(212, 151, 112, 0.14), transparent 26rem), var(--paper);
	font-family: var(--sans);
	-webkit-font-smoothing: antialiased;
	animation: pageFadeIn 0.6s ease both;
}

a { text-decoration: none; color: inherit; }

a:focus-visible, button:focus-visible, input:focus-visible {
	outline: 3px solid rgba(72, 92, 70, 0.55);
	outline-offset: 3px;
}

.bg-floaters {
	position: fixed;
	inset: 0;
	pointer-events: none;
	z-index: 0;
	overflow: hidden;
	opacity: 0.55;
}

.bg-floaters span {
	position: absolute;
	font-size: 2rem;
	opacity: 0.14;
	animation: bgFloat 20s linear infinite;
}

.bg-floaters span:nth-child(1) { left: 6%; top: 15%; animation-duration: 24s; animation-delay: 0s; }
.bg-floaters span:nth-child(2) { left: 88%; top: 22%; animation-duration: 28s; animation-delay: 3s; }
.bg-floaters span:nth-child(3) { left: 18%; top: 78%; animation-duration: 22s; animation-delay: 6s; }
.bg-floaters span:nth-child(4) { left: 76%; top: 62%; animation-duration: 26s; animation-delay: 2s; }
.bg-floaters span:nth-child(5) { left: 42%; top: 8%; animation-duration: 25s; animation-delay: 4s; }
.bg-floaters span:nth-child(6) { left: 62%; top: 90%; animation-duration: 23s; animation-delay: 1s; }

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

.back-to-top.show::after { animation: ringPulse 2.4s ease-out infinite; }

.back-to-top:hover {
	background: var(--tomato-dark);
	transform: translateY(-5px) scale(1.12) rotate(-6deg);
}

.back-to-top:active { transform: scale(0.9); }

.page {
	position: relative;
	z-index: 1;
	width: min(1220px, calc(100% - 64px));
	margin: 46px auto 72px;
}

.page-header {
	position: relative;
	margin-bottom: 30px;
	padding-bottom: 22px;
	border-bottom: 1px solid var(--line);
	opacity: 0;
	animation: fadeRise 1s .1s cubic-bezier(.2, .75, .25, 1) both;
}

.page-header::after {
	content: "";
	position: absolute;
	left: 0;
	bottom: -1px;
	height: 2px;
	width: 0;
	background: linear-gradient(90deg, var(--tomato), transparent);
	animation: headerLineGrow 1.6s .5s cubic-bezier(.2, .75, .25, 1) forwards;
}

.page-header h1 {
	color: var(--ink);
	font: 500 clamp(2.4rem, 5vw, 3.5rem)/1.1 var(--serif);
	display: inline-block;
	animation: titleFadeIn 1s .2s cubic-bezier(.2, .75, .25, 1) both;
}

.page-header p {
	margin-top: 8px;
	color: var(--muted);
	font-size: 0.9rem;
	animation: subtitleSlide 1.2s .6s cubic-bezier(.2, .75, .25, 1) both;
}

.menu-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(min(100%, 285px), 1fr));
	gap: 21px;
	perspective: 1200px;
}

.menu-card {
	display: flex;
	flex-direction: column;
	overflow: hidden;
	position: relative;
	border: 1px solid rgba(32, 40, 33, 0.07);
	border-radius: 9px;
	background: var(--surface);
	box-shadow: 0 7px 22px rgba(32, 40, 33, 0.055);
	opacity: 1;
	transform: translateY(0);
	transform-style: preserve-3d;
	transition: opacity .9s cubic-bezier(.2, .75, .25, 1), transform .5s cubic-bezier(.2, .75, .25, 1), box-shadow .4s ease, border-color .4s ease;
	will-change: transform, opacity;
}

body.js-reveal .menu-card.reveal {
	opacity: 0;
	transform: perspective(900px) rotateX(-12deg) translateY(60px) scale(.94);
}

body.js-reveal .menu-card.reveal.visible {
	opacity: 1;
	transform: perspective(900px) rotateX(0) translateY(0) scale(1);
}

.menu-card:hover {
	transform: translateY(-14px) scale(1.03);
	border-color: rgba(185, 75, 51, .28);
	box-shadow: 0 30px 55px rgba(32, 40, 33, 0.16), 0 0 0 1px rgba(185, 75, 51, 0.1);
}

.menu-card:focus-within {
	outline: 2px solid rgba(72, 92, 70, 0.45);
	outline-offset: 4px;
}

.menu-image-wrap {
	position: relative;
	overflow: hidden;
	height: 205px;
	background: #eeeeee;
}

.menu-image-wrap::before {
	content: "";
	position: absolute;
	top: 0;
	left: -80%;
	width: 60%;
	height: 100%;
	background: linear-gradient(100deg, transparent, rgba(255, 255, 255, .5), transparent);
	transform: skewX(-22deg);
	z-index: 2;
	opacity: 0;
	pointer-events: none;
}

.menu-card:hover .menu-image-wrap::before {
	opacity: 1;
	animation: imageShine 1.1s cubic-bezier(.2, .7, .25, 1) forwards;
}

.menu-image-wrap::after {
	content: "";
	position: absolute;
	inset: 0;
	background: linear-gradient(to bottom, transparent 40%, rgba(185, 75, 51, 0.35) 100%);
	opacity: 0;
	transition: opacity .5s ease;
	z-index: 1;
}

.menu-card:hover .menu-image-wrap::after { opacity: 1; }

.menu-image {
	width: 100%;
	height: 100%;
	display: block;
	object-fit: cover;
	transition: transform 1s cubic-bezier(.2, .65, .3, 1), filter .5s ease;
}

.menu-card:hover .menu-image {
	transform: scale(1.14) rotate(1deg);
	filter: saturate(1.15) brightness(1.06);
}

.menu-content {
	flex: 1;
	display: flex;
	flex-direction: column;
	padding: 18px;
	position: relative;
}

.menu-content::before {
	content: "";
	position: absolute;
	top: 0;
	left: 18px;
	right: 18px;
	height: 1px;
	background: linear-gradient(90deg, transparent, var(--tomato), transparent);
	transform: scaleX(0);
	transform-origin: left;
	transition: transform .6s cubic-bezier(.2, .75, .25, 1);
}

.menu-card:hover .menu-content::before { transform: scaleX(1); }

.menu-name {
	margin-bottom: 8px;
	color: var(--ink);
	font: 600 1.28rem/1.3 var(--serif);
	transition: color .3s ease, transform .35s cubic-bezier(.2, .75, .25, 1);
}

.menu-card:hover .menu-name {
	color: var(--tomato-dark);
	transform: translateX(4px);
}

.menu-description {
	min-height: 42px;
	margin-bottom: 12px;
	color: var(--muted);
	font-size: 0.82rem;
	line-height: 1.65;
}

.menu-bottom {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 8px;
	width: 100%;
	margin-top: auto;
	padding-top: 12px;
}

.price {
	flex: 0 0 auto;
	white-space: nowrap;
	color: var(--ink);
	font-size: 1.05rem;
	font-weight: 700;
	display: inline-block;
	transition: color .3s ease;
}

.menu-card:hover .price {
	color: var(--tomato);
	animation: priceBounce .8s cubic-bezier(.2, 1.5, .4, 1) forwards;
}

.add-btn {
	position: relative;
	border: none;
	border-radius: 5px;
	padding: 10px 17px 10px 34px;
	color: white;
	background: var(--tomato);
	font-size: 13px;
	font-weight: 700;
	cursor: pointer;
	white-space: nowrap;
	overflow: hidden;
	z-index: 0;
	transition: transform 320ms cubic-bezier(.2, .75, .25, 1), background-position 500ms ease, box-shadow 350ms ease, padding 400ms cubic-bezier(.2, .75, .25, 1);
}

.add-btn::before {
	content: "+";
	position: absolute;
	left: 50%;
	top: 50%;
	transform: translate(-50%, -50%) rotate(-90deg) scale(0);
	opacity: 0;
	font-size: 16px;
	font-weight: 900;
	transition: all .4s cubic-bezier(.2, 1.4, .4, 1);
	z-index: 2;
}

.add-btn:hover::before {
	left: 16px;
	transform: translate(0, -50%) rotate(0) scale(1);
	opacity: 1;
}

.add-btn .ripple {
	position: absolute;
	border-radius: 50%;
	background: rgba(255, 255, 255, 0.55);
	transform: translate(-50%, -50%) scale(0);
	pointer-events: none;
	animation: rippleGrow .6s ease-out forwards;
	z-index: 1;
}

.add-btn:hover {
	transform: translateY(-5px) scale(1.04);
	background: linear-gradient(135deg, var(--tomato), var(--tomato-dark), var(--tomato));
	background-size: 200% auto;
	background-position: 100% center;
	box-shadow: 0 12px 26px rgba(185, 75, 51, 0.35), 0 0 0 4px rgba(185, 75, 51, 0.12);
	padding-left: 40px;
}

.add-btn:active { transform: scale(0.9); }

.cart-controls {
	display: flex;
	align-items: center;
	justify-content: flex-end;
	gap: 5px;
	flex-wrap: nowrap;
	flex-shrink: 0;
	min-width: 0;
	animation: cartControlsIn .5s cubic-bezier(.2, 1.4, .4, 1) both;
}

.quantity-control {
	display: flex;
	align-items: center;
	height: 38px;
	flex-shrink: 0;
	overflow: hidden;
	border: 1px solid #d7ddcf;
	border-radius: 5px;
	background: white;
	transition: transform .35s cubic-bezier(.2, .75, .25, 1), box-shadow .35s ease, border-color .35s ease;
}

.quantity-control:hover {
	transform: translateY(-3px) scale(1.03);
	border-color: var(--sage);
	box-shadow: 0 8px 20px rgba(72, 92, 70, 0.2);
}

.quantity-control form { margin: 0; padding: 0; flex-shrink: 0; }

.quantity-control button {
	width: 31px;
	height: 38px;
	border: none;
	background: #eef1e8;
	color: var(--sage);
	font-size: 18px;
	font-weight: 800;
	cursor: pointer;
	transition: transform 320ms ease, color 350ms ease, background-color 350ms ease;
}

.quantity-control button:hover {
	background: var(--sage);
	color: white;
	transform: scale(1.12);
}

.quantity-control button:active { transform: scale(0.85) rotate(15deg); }

.quantity {
	min-width: 31px;
	text-align: center;
	color: var(--ink);
	font-size: 14px;
	font-weight: 800;
	display: inline-block;
	animation: qtyPop .5s cubic-bezier(.2, 1.4, .4, 1);
}

.remove-btn {
	height: 38px;
	padding: 0 9px;
	border: 1px solid #d9a194;
	border-radius: 5px;
	color: var(--tomato);
	background: white;
	font-size: 12px;
	font-weight: 700;
	cursor: pointer;
	white-space: nowrap;
	flex-shrink: 0;
	position: relative;
	overflow: hidden;
	z-index: 0;
	transition: transform 320ms ease, color 350ms ease, border-color 350ms ease, box-shadow 350ms ease;
}

.remove-btn::before {
	content: "";
	position: absolute;
	inset: 0;
	background: var(--tomato);
	transform: scaleY(0);
	transform-origin: bottom;
	z-index: -1;
	transition: transform .4s cubic-bezier(.2, .75, .25, 1);
}

.remove-btn:hover::before { transform: scaleY(1); }

.remove-btn:hover {
	color: white;
	border-color: var(--tomato);
	transform: translateY(-3px);
	box-shadow: 0 8px 18px rgba(185, 75, 51, 0.3);
}

.remove-btn:active { transform: scale(0.9); }

.available { margin-top: 12px; color: var(--sage); font-size: 13px; font-weight: 700; }
.unavailable { margin-top: 12px; color: #898c83; font-size: 13px; font-weight: 700; }

.empty {
	padding: 60px;
	border: 1px solid var(--line);
	border-radius: 9px;
	color: var(--muted);
	background: var(--surface);
	text-align: center;
	opacity: 0;
	animation: fadeRise 1s .2s cubic-bezier(.2, .75, .25, 1) both;
}

.empty h2 { color: var(--ink); font: 500 1.8rem/1.3 var(--serif); }

.modal-overlay {
	position: fixed;
	inset: 0;
	z-index: 2000;
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 20px;
	background: rgba(24, 31, 24, 0.58);
	backdrop-filter: blur(7px);
	animation: fadeIn .45s ease both;
}

.modal {
	width: min(430px, 90%);
	padding: 30px;
	border: 1px solid rgba(32, 40, 33, 0.08);
	border-radius: 10px;
	background: var(--surface);
	box-shadow: 0 20px 50px rgba(0, 0, 0, 0.25);
	text-align: center;
	animation: modalPop .55s cubic-bezier(.2, 1.3, .4, 1) both;
}

.modal h2 { margin-bottom: 12px; color: var(--ink); font: 600 1.55rem/1.3 var(--serif); }
.modal p { margin-bottom: 25px; color: var(--muted); line-height: 1.5; }

.modal-actions { display: flex; justify-content: center; gap: 12px; }
.modal-actions form { margin: 0; }

.modal-actions button {
	min-width: 100px;
	padding: 11px 18px;
	border-radius: 5px;
	font-weight: 700;
	cursor: pointer;
	transition: transform 320ms ease, color 350ms ease, background-color 350ms ease, border-color 350ms ease, box-shadow 350ms ease;
}

.yes-btn {
	border: none;
	background: var(--tomato);
	color: white;
	animation: glowPulse 2s ease-in-out infinite;
}

.yes-btn:hover {
	transform: translateY(-3px);
	background: var(--tomato-dark);
	box-shadow: 0 10px 20px rgba(185, 75, 51, .3);
}

.no-btn { border: 1px solid var(--line); background: white; color: #444; }
.no-btn:hover { background: #f5f4ef; transform: translateY(-2px); }
.modal-actions button:active { transform: scale(0.96); }

.cart-popup {
	position: fixed;
	top: 94px;
	right: 28px;
	z-index: 3000;
	width: min(390px, calc(100% - 32px));
	display: flex;
	align-items: flex-start;
	gap: 13px;
	padding: 16px 17px;
	border: 1px solid rgba(72, 92, 70, 0.15);
	border-radius: 10px;
	background: #fffefa;
	box-shadow: 0 14px 38px rgba(32, 40, 33, 0.18);
	animation: popupSlideIn .6s cubic-bezier(.2, 1.2, .4, 1) both;
	overflow: hidden;
}

.cart-popup-icon {
	width: 38px;
	height: 38px;
	display: flex;
	align-items: center;
	justify-content: center;
	flex-shrink: 0;
	border-radius: 50%;
	background: #eef1e8;
	color: var(--sage);
	font-size: 18px;
	font-weight: 800;
	animation: popIn .5s .15s cubic-bezier(.2, 1.4, .4, 1) both, heartbeat 2.4s ease-in-out 1s infinite;
}

.cart-popup-content { flex: 1; padding-top: 1px; }

.cart-popup-title { margin-bottom: 4px; color: var(--ink); font-size: 14px; font-weight: 800; }
.cart-popup-message { color: var(--muted); font-size: 12.5px; line-height: 1.5; }

.cart-popup-close {
	width: 25px;
	height: 25px;
	display: flex;
	align-items: center;
	justify-content: center;
	flex-shrink: 0;
	border: none;
	border-radius: 50%;
	background: transparent;
	color: #777;
	font-size: 18px;
	line-height: 1;
	cursor: pointer;
	transition: background-color 320ms ease, color 320ms ease, transform 320ms ease;
}

.cart-popup-close:hover {
	background: #f2eee8;
	color: var(--tomato);
	transform: rotate(90deg);
}

.cart-popup-progress {
	position: absolute;
	bottom: 0;
	left: 0;
	height: 3px;
	width: 100%;
	background: rgba(72, 92, 70, 0.15);
	overflow: hidden;
}

.cart-popup-progress::before {
	content: "";
	position: absolute;
	inset: 0;
	background: linear-gradient(90deg, var(--sage), var(--tomato));
	transform-origin: left;
	animation: popupCountdown 4.2s linear forwards;
}

.cart-popup.close { animation: popupSlideOut .35s ease forwards; }

.flying-item {
	position: fixed;
	z-index: 9998;
	border-radius: 50%;
	object-fit: cover;
	pointer-events: none;
	box-shadow: 0 10px 30px rgba(185, 75, 51, 0.4);
	transition: all 1s cubic-bezier(.5, -0.3, .7, 1.3);
}

.foody-cart-badge.bounce { animation: badgeBounce .8s cubic-bezier(.2, 1.4, .4, 1); }

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

.celebrate-emoji {
	font-size: 3rem;
	margin-bottom: 8px;
	display: inline-block;
	animation: emojiSpin 1s ease-in-out infinite;
}

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

.burst-particle {
	position: absolute;
	width: 10px;
	height: 10px;
	border-radius: 50%;
	pointer-events: none;
	animation: burstFly 1.4s cubic-bezier(0.15, 0.55, 0.4, 1) forwards;
}

.celebrate-confetti {
	position: absolute;
	top: -20px;
	width: 9px;
	height: 14px;
	opacity: 0.95;
	animation: confettiDance linear forwards;
}

/* =========================================================
   ALL KEYFRAMES — single line each
========================================================= */

@keyframes pageFadeIn { from { opacity: 0; } to { opacity: 1; } }

@keyframes bgFloat { 0% { transform: translate(0, 0) rotate(0deg); } 25% { transform: translate(30px, -40px) rotate(90deg); } 50% { transform: translate(-20px, -80px) rotate(180deg); } 75% { transform: translate(40px, -40px) rotate(270deg); } 100% { transform: translate(0, 0) rotate(360deg); } }

@keyframes ringPulse { 0% { opacity: 0.6; transform: scale(0.9); } 100% { opacity: 0; transform: scale(1.4); } }

@keyframes fadeRise { from { opacity: 0; transform: translateY(38px); } to { opacity: 1; transform: translateY(0); } }

@keyframes headerLineGrow { to { width: 100%; } }

@keyframes titleFadeIn { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }

@keyframes subtitleSlide { from { opacity: 0; transform: translateX(-20px); } to { opacity: 1; transform: translateX(0); } }

@keyframes imageShine { from { left: -80%; } to { left: 130%; } }

@keyframes priceBounce { 0% { transform: scale(1) translateY(0); } 30% { transform: scale(1.18) translateY(-4px); } 55% { transform: scale(0.96) translateY(0); } 75% { transform: scale(1.06) translateY(-2px); } 100% { transform: scale(1.08) translateY(-2px); } }

@keyframes rippleGrow { to { transform: translate(-50%, -50%) scale(4); opacity: 0; } }

@keyframes cartControlsIn { from { opacity: 0; transform: scale(0.8) translateY(6px); } to { opacity: 1; transform: scale(1) translateY(0); } }

@keyframes qtyPop { 0% { transform: scale(.5) rotateX(-90deg); opacity: 0; } 70% { transform: scale(1.25) rotateX(0); opacity: 1; } 100% { transform: scale(1) rotateX(0); } }

@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }

@keyframes modalPop { from { opacity: 0; transform: scale(.85) translateY(30px); } to { opacity: 1; transform: scale(1) translateY(0); } }

@keyframes glowPulse { 0%, 100% { box-shadow: 0 0 0 0 rgba(185, 75, 51, 0.4); } 50% { box-shadow: 0 0 0 12px rgba(185, 75, 51, 0); } }

@keyframes popupSlideIn { from { opacity: 0; transform: translateX(120px) scale(.85); } to { opacity: 1; transform: translateX(0) scale(1); } }

@keyframes popIn { 0% { opacity: 0; transform: scale(.4); } 70% { transform: scale(1.15); } 100% { opacity: 1; transform: scale(1); } }

@keyframes heartbeat { 0%, 100% { transform: scale(1); } 14% { transform: scale(1.15); } 28% { transform: scale(1); } 42% { transform: scale(1.15); } 70% { transform: scale(1); } }

@keyframes popupCountdown { from { transform: scaleX(1); } to { transform: scaleX(0); } }

@keyframes popupSlideOut { from { opacity: 1; transform: translateX(0) scale(1); } to { opacity: 0; transform: translateX(120px) scale(.9); } }

@keyframes badgeBounce { 0% { transform: scale(1); } 25% { transform: scale(1.6) rotate(-8deg); } 55% { transform: scale(0.85) rotate(6deg); } 80% { transform: scale(1.15) rotate(-2deg); } 100% { transform: scale(1); } }

@keyframes celebrateFlash { 0% { background: rgba(20, 25, 20, 0); } 10% { background: rgba(20, 25, 20, 0.35); } 50% { background: rgba(20, 25, 20, 0.15); } 100% { background: rgba(20, 25, 20, 0); } }

@keyframes bannerDrop { 0% { opacity: 0; transform: translate(-50%, -50%) scale(0.5) rotate(-8deg); } 60% { opacity: 1; transform: translate(-50%, -50%) scale(1.08) rotate(2deg); } 100% { opacity: 1; transform: translate(-50%, -50%) scale(1) rotate(0); } }

@keyframes bannerExit { to { opacity: 0; transform: translate(-50%, -50%) scale(0.85); } }

@keyframes emojiSpin { 0%, 100% { transform: rotate(0deg) scale(1); } 25% { transform: rotate(-12deg) scale(1.15); } 75% { transform: rotate(12deg) scale(1.15); } }

@keyframes ringExpand { 0% { opacity: 1; width: 20px; height: 20px; border-width: 6px; } 100% { opacity: 0; width: 500px; height: 500px; border-width: 1px; } }

@keyframes burstFly { 0% { opacity: 1; transform: translate(0, 0) scale(1); } 100% { opacity: 0; transform: translate(var(--dx), var(--dy)) scale(0.3); } }

@keyframes confettiDance { 0% { transform: translateY(0) rotate(0deg); opacity: 1; } 100% { transform: translateY(105vh) rotate(720deg); opacity: 0; } }

/* RESPONSIVE */
@media (max-width: 900px) {
	.page { width: calc(100% - 48px); }
	.menu-grid { grid-template-columns: repeat(auto-fit, minmax(min(100%, 280px), 1fr)); }
	.cart-controls { gap: 5px; }
}

@media (max-width: 650px) {
	.page { width: calc(100% - 36px); margin: 34px auto 50px; }
	.page-header h1 { font-size: 2.6rem; }
	.menu-grid { grid-template-columns: 1fr; }
	.menu-bottom { align-items: flex-start; flex-direction: column; gap: 10px; }
	.cart-controls { width: 100%; justify-content: flex-start; }
	.cart-popup { top: 88px; right: 16px; width: calc(100% - 32px); }
	.bg-floaters span { font-size: 1.4rem; }
	.celebrate-banner { padding: 20px 26px; max-width: 90vw; }
}

@media (max-width: 380px) {
	.page { width: calc(100% - 24px); }
	.page-header h1 { font-size: 2.3rem; }
	.menu-content { padding: 16px; }
	.modal { padding: 24px 18px; }
	.cart-popup { right: 12px; width: calc(100% - 24px); }
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

<!-- FLOATING BACKGROUND INGREDIENTS -->
<div class="bg-floaters" aria-hidden="true">
	<span>🍕</span> <span>🍔</span> <span>🍜</span> <span>🍣</span> <span>🍩</span> <span>🌮</span>
</div>

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

<!-- CART POPUP -->
<%
	if (cartPopup != null && !cartPopup.trim().isEmpty()) {
%>

<div id="cartPopup" class="cart-popup">
	<div class="cart-popup-icon">✓</div>
	<div class="cart-popup-content">
		<div class="cart-popup-title">Cart updated</div>
		<div class="cart-popup-message"><%= cartPopup %></div>
	</div>
	<button type="button" class="cart-popup-close" onclick="closeCartPopup()" aria-label="Close">×</button>
	<div class="cart-popup-progress"></div>
</div>

<%
	}
%>

<!-- MENU -->
<main class="page">

	<div class="page-header">
		<h1>Menu</h1>
		<p>Choose your favourite food and add it to your cart.</p>
	</div>

	<%
		if (menus.isEmpty()) {
	%>

	<div class="empty">
		<h2>No menu items available.</h2>
		<p style="margin-top: 10px;">Please check back later.</p>
	</div>

	<%
		} else {
	%>

	<div class="menu-grid">

		<%
			for (Menu menu : menus) {

				CartItem existingItem = cart.get(menu.getMenuId());

				int quantity = 0;

				if (existingItem != null) {
					quantity = existingItem.getQuantity();
				}
		%>

		<div class="menu-card reveal tilt-card">

			<div class="menu-image-wrap">

				<img class="menu-image"
					src="<%= menu.getImagePath() %>"
					alt="<%= menu.getItemName() %>"
					data-menu-id="<%= menu.getMenuId() %>">

			</div>

			<div class="menu-content">

				<div class="menu-name">
					<%= menu.getItemName() %>
				</div>

				<div class="menu-description">
					<%= menu.getDescription() %>
				</div>

				<div class="menu-bottom">

					<div class="price">
						₹<%= String.format("%.2f", menu.getPrice()) %>
					</div>

					<%
						if (menu.isAvailable()) {

							if (quantity == 0) {
					%>

					<form action="cart" method="post" onsubmit="return handleAddToCart(event, this);">
						<input type="hidden" name="action" value="add">
						<input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
						<input type="hidden" name="returnPage" value="menu">
						<button type="submit" class="add-btn">Add to Cart</button>
					</form>

					<%
							} else {
					%>

					<div class="cart-controls">

						<div class="quantity-control">

							<form action="cart" method="post">
								<input type="hidden" name="action" value="decrease">
								<input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
								<input type="hidden" name="returnPage" value="menu">
								<button type="submit" title="Decrease quantity">−</button>
							</form>

							<span class="quantity"><%= quantity %></span>

							<form action="cart" method="post">
								<input type="hidden" name="action" value="increase">
								<input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
								<input type="hidden" name="returnPage" value="menu">
								<button type="submit" title="Increase quantity">+</button>
							</form>

						</div>

						<form action="cart" method="post">
							<input type="hidden" name="action" value="remove">
							<input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
							<input type="hidden" name="returnPage" value="menu">
							<button type="submit" class="remove-btn">Remove</button>
						</form>

					</div>

					<%
							}

						} else {
					%>

					<span style="color: #999; font-size: 13px; font-weight: 700;">Unavailable</span>

					<%
						}
					%>

				</div>

				<%
					if (menu.isAvailable()) {
				%>

				<div class="available">✓ Available</div>

				<%
					} else {
				%>

				<div class="unavailable">Currently unavailable</div>

				<%
					}
				%>

			</div>

		</div>

		<%
			}
		%>

	</div>

	<%
		}
	%>

</main>

<!-- MODAL -->
<%
	if ("true".equals(cartConflict)) {
%>

<div class="modal-overlay">
	<div class="modal">
		<h2>Change restaurant?</h2>
		<p>Can you remove the old restaurant and add this item?</p>

		<div class="modal-actions">

			<form action="cart" method="post">
				<input type="hidden" name="action" value="confirmReplace">
				<button type="submit" class="yes-btn">Yes</button>
			</form>

			<form action="cart" method="post">
				<input type="hidden" name="action" value="cancelReplace">
				<button type="submit" class="no-btn">No</button>
			</form>

		</div>
	</div>
</div>

<%
	}
%>

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

	revealElements.forEach(function (el, index) {
		el.style.transitionDelay = (index % 3) * 0.08 + "s";
		observer.observe(el);
	});

	setTimeout(function () {
		document.querySelectorAll(".reveal:not(.visible)").forEach(function (el) {
			el.classList.add("visible");
		});
	}, 2500);
});

/* =====================================================
   3. 3D CARD TILT
===================================================== */
(function () {
	if (window.matchMedia("(pointer: coarse)").matches) return;

	var cards = document.querySelectorAll(".tilt-card");

	cards.forEach(function (card) {

		card.addEventListener("mousemove", function (e) {
			var rect = card.getBoundingClientRect();
			var x = e.clientX - rect.left;
			var y = e.clientY - rect.top;
			var cx = rect.width / 2;
			var cy = rect.height / 2;

			var rotateY = ((x - cx) / cx) * 5;
			var rotateX = -((y - cy) / cy) * 5;

			card.style.transform = "perspective(900px) rotateX(" + rotateX + "deg) rotateY(" + rotateY + "deg) translateY(-14px) scale(1.03)";
		});

		card.addEventListener("mouseleave", function () {
			card.style.transform = "";
		});
	});
})();

/* =====================================================
   4. RIPPLE ON ADD TO CART
===================================================== */
document.addEventListener("click", function (e) {

	var btn = e.target.closest(".add-btn");
	if (!btn) return;

	var rect = btn.getBoundingClientRect();
	var ripple = document.createElement("span");
	ripple.className = "ripple";

	var size = Math.max(rect.width, rect.height);
	ripple.style.width = size + "px";
	ripple.style.height = size + "px";
	ripple.style.left = (e.clientX - rect.left) + "px";
	ripple.style.top = (e.clientY - rect.top) + "px";

	btn.appendChild(ripple);
	setTimeout(function () { ripple.remove(); }, 700);
});

/* =====================================================
   5. FLYING ITEM TO CART
===================================================== */
function handleAddToCart(event, form) {

	var card = form.closest(".menu-card");
	if (!card) return true;

	var img = card.querySelector(".menu-image");
	if (!img) return true;

	var cartLink = document.querySelector(".foody-cart-link") || document.querySelector(".foody-cart-badge");

	var startRect = img.getBoundingClientRect();
	var endX, endY;

	if (cartLink) {
		var endRect = cartLink.getBoundingClientRect();
		endX = endRect.left + endRect.width / 2;
		endY = endRect.top + endRect.height / 2;
	} else {
		endX = window.innerWidth - 80;
		endY = 40;
	}

	var flyer = document.createElement("img");
	flyer.src = img.src;
	flyer.className = "flying-item";

	var size = 80;
	flyer.style.left = (startRect.left + startRect.width / 2 - size / 2) + "px";
	flyer.style.top = (startRect.top + startRect.height / 2 - size / 2) + "px";
	flyer.style.width = size + "px";
	flyer.style.height = size + "px";

	document.body.appendChild(flyer);

	requestAnimationFrame(function () {
		requestAnimationFrame(function () {
			flyer.style.left = (endX - size / 2) + "px";
			flyer.style.top = (endY - size / 2) + "px";
			flyer.style.width = "20px";
			flyer.style.height = "20px";
			flyer.style.opacity = "0.3";
		});
	});

	setTimeout(function () {
		var badge = document.querySelector(".foody-cart-badge");
		if (badge) {
			badge.classList.add("bounce");
			setTimeout(function () { badge.classList.remove("bounce"); }, 900);
		}
	}, 900);

	setTimeout(function () { flyer.remove(); }, 1200);

	return true;
}

/* =====================================================
   6. CART POPUP AUTO-CLOSE
===================================================== */
function closeCartPopup() {
	var popup = document.getElementById("cartPopup");
	if (!popup) return;

	popup.classList.add("close");
	setTimeout(function () { if (popup) popup.remove(); }, 350);
}

document.addEventListener("DOMContentLoaded", function () {
	var popup = document.getElementById("cartPopup");
	if (popup) { setTimeout(closeCartPopup, 4200); }
});

/* =====================================================
   7. BACK TO TOP
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
   8. FREE DELIVERY CELEBRATION + RE-ARM
===================================================== */
(function () {

	var FREE_DELIVERY_ACTIVE = <%= freeDelivery ? "true" : "false" %>;
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