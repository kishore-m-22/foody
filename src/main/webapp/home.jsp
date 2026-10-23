<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>

<%@ page import="com.tap.model.User"%>
<%@ page import="com.tap.model.Restaurant"%>
<%@ page import="com.tap.model.CartItem"%>
<%@ page import="com.tap.DaoImpl.RestaurantDaoImpl"%>

<%
    User user = (User) session.getAttribute("user");

    List<Restaurant> discountedRestaurants =
        (List<Restaurant>) request.getAttribute("discountedRestaurants");

    if (discountedRestaurants == null) {

        discountedRestaurants = new ArrayList<>();

        RestaurantDaoImpl restaurantDao =
            new RestaurantDaoImpl();

        List<Restaurant> allRestaurants =
            restaurantDao.getAllRestaurants();

        if (allRestaurants != null) {
            for (Restaurant restaurant : allRestaurants) {
                if (restaurant.getDiscountPercent() > 0) {
                    discountedRestaurants.add(restaurant);
                }
            }
        }
    }

    Map<Integer, CartItem> homeCart =
        (Map<Integer, CartItem>) session.getAttribute("cart");

    int homeCartCount = 0;

    if (homeCart != null) {
        for (CartItem item : homeCart.values()) {
            homeCartCount += item.getQuantity();
        }
    }
%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Foody - Food Delivered To You</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Playfair+Display:ital,wght@0,500;0,600;0,700;1,500&display=swap" rel="stylesheet">

<style>
:root {
	--ink: #202821;
	--muted: #71786f;
	--paper: #f6f4ed;
	--surface: #fffefa;
	--tomato: #c4472d;
	--tomato-dark: #96331f;
	--sage: #485c46;
	--line: #e6e3d9;
	--serif: "Playfair Display", Georgia, serif;
	--sans: "DM Sans", "Segoe UI", sans-serif;
}

* { box-sizing: border-box; }

html { scroll-behavior: smooth; overflow-x: hidden; }

body {
	margin: 0;
	padding: 0;
	color: var(--ink);
	background: var(--paper);
	font-family: var(--sans);
	-webkit-font-smoothing: antialiased;
	overflow-x: hidden;
	animation: pageFadeIn 0.6s ease both;
}

@keyframes pageFadeIn {
	from { opacity: 0; }
	to { opacity: 1; }
}

a { color: inherit; text-decoration: none; }

a:focus-visible, button:focus-visible, input:focus-visible {
	outline: 3px solid rgba(72, 92, 70, .65);
	outline-offset: 4px;
}

/* =========================================================
   SCROLL PROGRESS BAR
========================================================= */
.scroll-progress {
	position: fixed;
	top: 0;
	left: 0;
	height: 3px;
	width: 0%;
	background: linear-gradient(90deg, var(--tomato), #d7a05a, var(--sage));
	z-index: 9999;
	transition: width 0.1s linear;
	box-shadow: 0 0 12px rgba(196, 71, 45, .5);
}

/* =========================================================
   BACK TO TOP
========================================================= */
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
	box-shadow: 0 8px 24px rgba(196, 71, 45, 0.35);
	opacity: 0;
	visibility: hidden;
	transform: translateY(20px);
	transition: opacity 0.4s ease, visibility 0.4s ease, transform 0.4s ease, background-color 0.3s ease;
	z-index: 5000;
}

.back-to-top.show {
	opacity: 1;
	visibility: visible;
	transform: translateY(0);
}

.back-to-top:hover {
	background: var(--tomato-dark);
	transform: translateY(-4px) scale(1.08);
}

.back-to-top:active { transform: scale(0.9); }

/* =========================================================
   HERO
========================================================= */
.hero {
	min-height: 590px;
	display: flex;
	align-items: center;
	justify-content: flex-start;
	position: relative;
	isolation: isolate;
	padding: 65px max(7%, calc(( 100% - 1220px)/2));
	overflow: hidden;
	background: linear-gradient(90deg, rgba(15, 23, 17, .88) 0%,
		rgba(15, 23, 17, .62) 48%, rgba(15, 23, 17, .12) 100%),
		linear-gradient(0deg, rgba(15, 23, 17, .24), transparent 60%),
		url('https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=1800&q=85')
		center/cover no-repeat;
	background-size: 100% auto;
	animation: heroEnter 1.4s cubic-bezier(.2, .75, .25, 1) both,
		heroSlowZoom 22s ease-in-out 1.4s infinite alternate;
}

@keyframes heroEnter {
	from { opacity: 0; filter: blur(6px); background-size: 115% auto; }
	to   { opacity: 1; filter: blur(0); background-size: 100% auto; }
}

@keyframes heroSlowZoom {
	from { background-size: 100% auto; background-position: center center; }
	to   { background-size: 108% auto; background-position: 52% center; }
}

.hero::after {
	content: "";
	position: absolute;
	z-index: -1;
	inset: 0;
	background: linear-gradient(110deg, rgba(196, 71, 45, .13), transparent 65%);
	pointer-events: none;
}

.hero::before {
	content: "";
	position: absolute;
	top: -50%;
	left: -50%;
	width: 200%;
	height: 200%;
	z-index: 0;
	background: radial-gradient(circle at 30% 40%, rgba(255, 255, 255, .07), transparent 40%),
		radial-gradient(circle at 70% 60%, rgba(215, 223, 187, .06), transparent 40%);
	pointer-events: none;
	animation: heroShine 12s ease-in-out infinite alternate;
}

@keyframes heroShine {
	from { transform: translate(-4%, -4%) rotate(0deg); }
	to   { transform: translate(4%, 4%) rotate(8deg); }
}

/* Floating food particles */
.hero-particles {
	position: absolute;
	inset: 0;
	z-index: 1;
	pointer-events: none;
	overflow: hidden;
}

.hero-particles span {
	position: absolute;
	font-size: 1.5rem;
	opacity: .18;
	animation: particleFloat linear infinite;
}

.hero-particles span:nth-child(1) { left: 8%;  top: 20%; animation-duration: 14s; animation-delay: 0s; }
.hero-particles span:nth-child(2) { left: 22%; top: 70%; animation-duration: 18s; animation-delay: 2s; }
.hero-particles span:nth-child(3) { left: 48%; top: 15%; animation-duration: 16s; animation-delay: 1s; }
.hero-particles span:nth-child(4) { left: 78%; top: 60%; animation-duration: 20s; animation-delay: 3s; }
.hero-particles span:nth-child(5) { left: 90%; top: 30%; animation-duration: 15s; animation-delay: 1.5s; }
.hero-particles span:nth-child(6) { left: 60%; top: 80%; animation-duration: 17s; animation-delay: 2.5s; }

@keyframes particleFloat {
	0%   { transform: translateY(0) rotate(0deg); opacity: 0; }
	10%  { opacity: .18; }
	50%  { transform: translateY(-70px) rotate(180deg); opacity: .28; }
	90%  { opacity: .18; }
	100% { transform: translateY(-140px) rotate(360deg); opacity: 0; }
}

.hero-content {
	width: min(680px, 100%);
	position: relative;
	z-index: 2;
}

.hero-content > * {
	opacity: 0;
	animation: fadeRiseLeft 1s cubic-bezier(.2, .75, .25, 1) both;
}

.hero-content .location   { animation-delay: .25s; }
.hero-content h1          { animation-delay: .4s; }
.hero-content p           { animation-delay: .55s; }
.hero-content .search-box { animation-delay: .7s; }

@keyframes fadeRiseLeft {
	from { opacity: 0; transform: translateX(-40px); }
	to   { opacity: 1; transform: translateX(0); }
}

.location {
	display: inline-block;
	padding: 11px 16px;
	margin-bottom: 22px;
	border: 1px solid rgba(255, 255, 255, .35);
	border-radius: 30px;
	color: white;
	background: rgba(255, 255, 255, .12);
	backdrop-filter: blur(10px);
	font-size: .82rem;
	letter-spacing: .025em;
	animation: fadeRiseLeft 1s .25s cubic-bezier(.2, .75, .25, 1) both,
		float 3.5s ease-in-out 1.2s infinite,
		locationPulse 2.6s ease-in-out 1.2s infinite;
}

@keyframes float {
	0%, 100% { transform: translateY(0); }
	50%      { transform: translateY(-8px); }
}

@keyframes locationPulse {
	0%, 100% { box-shadow: 0 0 0 0 rgba(255, 255, 255, .18); }
	50%      { box-shadow: 0 0 0 12px rgba(255, 255, 255, 0); }
}

.hero h1 {
	max-width: 720px;
	margin: 0 0 22px;
	color: white;
	font-family: var(--serif);
	font-size: clamp(3.1rem, 6.5vw, 5.3rem);
	font-weight: 600;
	line-height: 1.05;
	letter-spacing: -.035em;
	text-wrap: balance;
	background: linear-gradient(90deg, #fff 0%, #fff 35%, #d7dfbb 50%, #fff 65%, #fff 100%);
	background-size: 220% auto;
	-webkit-background-clip: text;
	background-clip: text;
	-webkit-text-fill-color: transparent;
	animation: fadeRiseLeft 1s .4s cubic-bezier(.2, .75, .25, 1) both,
		heroTextShine 5s ease-in-out 1.6s infinite;
}

@keyframes heroTextShine {
	0%, 100% { background-position: 0% center; }
	50%      { background-position: 100% center; }
}

.hero p {
	max-width: 490px;
	margin: 0 0 32px;
	color: rgba(255, 255, 255, .88);
	font-size: 1.05rem;
	line-height: 1.8;
	animation: fadeRiseLeft 1s .55s cubic-bezier(.2, .75, .25, 1) both;
}

/* =========================================================
   SEARCH BAR
========================================================= */
.search-box {
	display: flex;
	width: min(600px, 100%);
	min-height: 64px;
	margin: 0;
	overflow: hidden;
	background: white;
	border: 1px solid rgba(255, 255, 255, .7);
	border-radius: 12px;
	box-shadow: 0 18px 50px rgba(0, 0, 0, .24);
	transition: box-shadow .3s ease, transform .3s ease;
	animation: fadeRiseLeft 1s .7s cubic-bezier(.2, .75, .25, 1) both,
		searchGlow 3.5s ease-in-out 1.8s infinite;
}

@keyframes searchGlow {
	0%, 100% { box-shadow: 0 18px 50px rgba(0, 0, 0, .24); }
	50%      { box-shadow: 0 18px 50px rgba(0, 0, 0, .24), 0 0 0 8px rgba(255, 255, 255, .08); }
}

.search-box:focus-within {
	box-shadow: 0 0 0 4px rgba(255, 255, 255, .25), 0 18px 50px rgba(0, 0, 0, .25);
	transform: translateY(-2px);
}

.search-box input {
	flex: 1;
	min-width: 0;
	padding: 0 22px;
	border: 0;
	outline: none;
	color: var(--ink);
	background: transparent;
	font: 400 .94rem var(--sans);
}

.search-box button {
	width: 120px;
	flex-shrink: 0;
	border: 0;
	color: white;
	background: var(--tomato);
	font: 700 .95rem var(--sans);
	cursor: pointer;
	position: relative;
	overflow: hidden;
	transition: background .25s ease, transform .25s ease;
}

.search-box button::before {
	content: "";
	position: absolute;
	top: 50%;
	left: 50%;
	width: 0;
	height: 0;
	background: rgba(255, 255, 255, .25);
	border-radius: 50%;
	transform: translate(-50%, -50%);
	transition: width .6s ease, height .6s ease;
}

.search-box button:hover::before { width: 320px; height: 320px; }
.search-box button:hover { background: var(--tomato-dark); transform: scale(1.04); }
.search-box button:active { transform: scale(.96); }

/* =========================================================
   SECTION
========================================================= */
.section {
	width: min(1220px, calc(100% - 64px));
	margin: 76px auto 88px;
}

.section-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 16px;
	margin-bottom: 32px;
	opacity: 0;
	animation: fadeRiseUp 1s .3s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes fadeRiseUp {
	from { opacity: 0; transform: translateY(40px); }
	to   { opacity: 1; transform: translateY(0); }
}

.section-title {
	position: relative;
	margin: 0;
	padding-bottom: 13px;
	font: 600 clamp(1.9rem, 3vw, 2.65rem)/1.2 var( --serif);
	letter-spacing: -.025em;
}

.section-title::after {
	content: "";
	position: absolute;
	left: 0;
	bottom: 0;
	width: 58px;
	height: 4px;
	border-radius: 4px;
	background: var(--tomato);
	animation: underlineGrow 1s .8s cubic-bezier(.2, .75, .25, 1) both;
	transition: width .35s ease;
}

@keyframes underlineGrow {
	from { width: 0; }
	to   { width: 58px; }
}

.section-header:hover .section-title::after { width: 94px; }

.view-all {
	display: inline-flex;
	align-items: center;
	gap: 8px;
	color: var(--tomato);
	font-size: .9rem;
	font-weight: 700;
	transition: color .25s ease, gap .25s ease;
}

.view-all:hover { gap: 13px; color: var(--tomato-dark); }

/* =========================================================
   RESTAURANT GRID
========================================================= */
.restaurant-grid {
	display: grid;
	grid-template-columns: repeat(3, minmax(0, 1fr));
	gap: 27px;
}

/* CARD — visible by default; hidden only if JS loads */
.restaurant-card {
	min-width: 0;
	overflow: hidden;
	position: relative;
	border: 1px solid rgba(32, 40, 33, .07);
	border-radius: 17px;
	background: var(--surface);
	box-shadow: 0 7px 25px rgba(32, 40, 33, .055);
	opacity: 1;
	transform: translateY(0);
	transition:
		opacity .9s cubic-bezier(.2, .75, .25, 1),
		transform .9s cubic-bezier(.2, .75, .25, 1),
		box-shadow .4s ease,
		border-color .4s ease;
	will-change: transform, opacity;
}

body.js-reveal .restaurant-card.reveal {
	opacity: 0;
	transform: translateY(60px) scale(.96);
}

body.js-reveal .restaurant-card.reveal.visible {
	opacity: 1;
	transform: translateY(0) scale(1);
}

.restaurant-card:hover {
	transform: translateY(-12px) scale(1.02);
	border-color: rgba(196, 71, 45, .22);
	box-shadow: 0 28px 55px rgba(32, 40, 33, .16),
		0 0 0 1px rgba(196, 71, 45, .08);
}

.restaurant-card:focus-within {
	outline: 2px solid rgba(72, 92, 70, .5);
	outline-offset: 4px;
}

/* =========================================================
   IMAGE
========================================================= */
.image-container {
	height: 235px;
	position: relative;
	overflow: hidden;
	background: #e9e6dc;
}

.image-container::after {
	content: "";
	position: absolute;
	inset: 45% 0 0;
	pointer-events: none;
	background: linear-gradient(to bottom, transparent, rgba(0, 0, 0, .24));
	opacity: .65;
	transition: opacity .4s ease;
}

.image-container::before {
	content: "";
	position: absolute;
	top: 0;
	left: -80%;
	width: 60%;
	height: 100%;
	background: linear-gradient(100deg, transparent, rgba(255, 255, 255, .35), transparent);
	transform: skewX(-22deg);
	z-index: 1;
	opacity: 0;
	pointer-events: none;
}

.restaurant-card:hover .image-container::before {
	opacity: 1;
	animation: imageShine 1.1s cubic-bezier(.2, .7, .25, 1) forwards;
}

@keyframes imageShine {
	from { left: -80%; }
	to   { left: 130%; }
}

.restaurant-image {
	display: block;
	width: 100%;
	height: 100%;
	object-fit: cover;
	transition: transform .9s cubic-bezier(.2, .65, .3, 1), filter .5s ease;
}

.restaurant-card:hover .restaurant-image {
	transform: scale(1.12) rotate(1deg);
	filter: saturate(1.12) brightness(1.04);
}

.restaurant-card:hover .image-container::after { opacity: .95; }

/* =========================================================
   DISCOUNT BADGE
========================================================= */
.discount-badge {
	position: absolute;
	z-index: 2;
	left: 15px;
	bottom: 15px;
	padding: 9px 14px;
	border: 1px solid rgba(255, 255, 255, .25);
	border-radius: 7px;
	color: white;
	background: var(--tomato);
	box-shadow: 0 5px 15px rgba(0, 0, 0, .18);
	font-size: .75rem;
	font-weight: 800;
	letter-spacing: .045em;
	transform-origin: center;
	animation: popIn .6s .7s cubic-bezier(.2, 1.4, .4, 1) both,
		float 3.4s ease-in-out 1.4s infinite;
	transition: transform .35s ease, background .35s ease;
}

@keyframes popIn {
	0%   { opacity: 0; transform: scale(.4); }
	70%  { transform: scale(1.12); }
	100% { opacity: 1; transform: scale(1); }
}

.restaurant-card:hover .discount-badge {
	transform: translateY(-4px) scale(1.05);
	background: var(--tomato-dark);
}

/* =========================================================
   CARD CONTENT
========================================================= */
.card-content { padding: 23px; }

.restaurant-name {
	margin-bottom: 9px;
	overflow: hidden;
	color: var(--ink);
	font: 600 1.35rem/1.35 var( --serif);
	white-space: nowrap;
	text-overflow: ellipsis;
	transition: color .3s ease;
}

.restaurant-card:hover .restaurant-name { color: var(--tomato-dark); }

.cuisine {
	margin-bottom: 17px;
	overflow: hidden;
	color: var(--muted);
	font-size: .86rem;
	line-height: 1.5;
	white-space: nowrap;
	text-overflow: ellipsis;
}

.restaurant-details {
	display: flex;
	flex-wrap: wrap;
	align-items: center;
	gap: 15px;
	margin-bottom: 20px;
	color: var(--muted);
	font-size: .82rem;
}

.rating {
	color: var(--sage);
	font-weight: 800;
	display: inline-block;
	transition: transform .35s ease, color .35s ease;
}

.restaurant-card:hover .rating {
	color: var(--tomato);
	transform: scale(1.12);
}

/* =========================================================
   VIEW MENU BUTTON
========================================================= */
.menu-btn {
	display: block;
	width: 100%;
	padding: 13px 16px;
	border: 1px solid #dfe4d7;
	border-radius: 9px;
	color: var(--sage);
	background: #f1f3eb;
	text-align: center;
	font-size: .91rem;
	font-weight: 700;
	position: relative;
	overflow: hidden;
	transition: color .3s ease, background .3s ease, border-color .3s ease,
		transform .3s ease, box-shadow .3s ease, padding .3s ease;
}

.menu-btn::before {
	content: "→";
	position: absolute;
	right: 16px;
	top: 50%;
	transform: translate(-6px, -50%);
	opacity: 0;
	transition: opacity .35s ease, transform .35s ease;
}

.menu-btn:hover::before { opacity: 1; transform: translate(0, -50%); }

.menu-btn:hover {
	transform: translateY(-3px);
	border-color: var(--sage);
	color: white;
	background: var(--sage);
	box-shadow: 0 10px 22px rgba(72, 92, 70, .22);
	padding-right: 40px;
}

.menu-btn:active { transform: scale(.98); }

/* =========================================================
   EMPTY OFFERS
========================================================= */
.no-offers {
	padding: 48px 25px;
	border: 1px solid var(--line);
	border-radius: 15px;
	color: var(--muted);
	background: var(--surface);
	text-align: center;
	box-shadow: 0 8px 24px rgba(32, 40, 33, .04);
	opacity: 1;
	transform: translateY(0);
	transition: opacity .9s cubic-bezier(.2, .75, .25, 1), transform .9s cubic-bezier(.2, .75, .25, 1);
}

body.js-reveal .no-offers.reveal {
	opacity: 0;
	transform: translateY(30px);
}

body.js-reveal .no-offers.reveal.visible {
	opacity: 1;
	transform: translateY(0);
}

.no-offers h3 {
	margin: 0;
	color: var(--ink);
	font-family: var(--serif);
	font-size: 1.5rem;
}

.no-offers p { margin: 10px 0 0; line-height: 1.7; }

/* =========================================================
   TOAST
========================================================= */
.foody-toast {
	position: fixed;
	bottom: 28px;
	left: 50%;
	transform: translate(-50%, 130%);
	z-index: 9998;
	padding: 13px 22px;
	border-radius: 10px;
	background: var(--ink);
	color: #fff;
	font-size: .88rem;
	font-weight: 600;
	letter-spacing: .01em;
	box-shadow: 0 14px 34px rgba(32, 40, 33, .3);
	transition: transform .5s cubic-bezier(.2, 1.2, .4, 1);
	pointer-events: none;
}

.foody-toast.show { transform: translate(-50%, 0); }

/* =========================================================
   RESPONSIVE
========================================================= */
@media ( max-width : 950px) {
	.hero { min-height: 530px; padding-left: 6%; padding-right: 6%; }
	.restaurant-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 22px; }
	.section { width: calc(100% - 48px); }
}

@media ( max-width : 700px) {
	.hero { min-height: 490px; padding: 48px 6%; background-position: 58% center; }
	.hero h1 { font-size: clamp(2.7rem, 10vw, 4rem); }
	.hero p { font-size: .96rem; }
	.section { width: calc(100% - 36px); margin: 48px auto 58px; }
	.restaurant-grid { grid-template-columns: 1fr; gap: 22px; }
	.image-container { height: 245px; }
	.card-content { padding: 21px; }
}

@media ( max-width : 420px) {
	.hero { min-height: 455px; }
	.hero h1 { font-size: 2.55rem; }
	.search-box { min-height: 55px; }
	.search-box input { padding: 0 12px; font-size: .82rem; }
	.search-box button { width: 88px; font-size: .85rem; }
	.section-header { align-items: flex-start; flex-direction: column; }
	.image-container { height: 220px; }
}

@media ( prefers-reduced-motion : reduce) {
	*, *::before, *::after {
		scroll-behavior: auto !important;
		animation-duration: .01ms !important;
		animation-iteration-count: 1 !important;
		transition-duration: .01ms !important;
	}
}
</style>

</head>

<body>

<!-- SCROLL PROGRESS BAR -->
<div class="scroll-progress" id="scrollProgress"></div>

<!-- =========================
     SHARED HEADER
     ========================= -->

<jsp:include page="/include/header.jsp" />

<!-- =========================
     HERO
     ========================= -->

<section class="hero">

	<div class="hero-particles" aria-hidden="true">
		<span>🍕</span>
		<span>🍔</span>
		<span>🍜</span>
		<span>🍣</span>
		<span>🍩</span>
		<span>🌮</span>
	</div>

	<div class="hero-content">

		<div class="location">📍 BTM Layout, Bengaluru</div>

		<h1>
			Delicious food, delivered to <br> you
		</h1>

		<p>Discover great restaurants and delicious meals around you.</p>

		<div class="search-box">
			<input type="text" placeholder="Search for restaurants or dishes">
			<button type="button" onclick="showToast('Search is coming soon! 🔍')">Search</button>
		</div>

	</div>

</section>

<!-- =========================
     OFFERS
     ========================= -->

<section class="section">

	<div class="section-header">
		<h2 class="section-title">Offers for You</h2>
		<a href="restaurants" class="view-all"> View All → </a>
	</div>

	<%
		if (discountedRestaurants.isEmpty()) {
	%>

	<div class="no-offers reveal">
		<h3>No offers available right now.</h3>
		<p>Explore our restaurants for delicious food.</p>
	</div>

	<%
		} else {
	%>

	<div class="restaurant-grid">

		<%
			for (Restaurant restaurant : discountedRestaurants) {
		%>

		<div class="restaurant-card reveal">

			<div class="image-container">
				<img class="restaurant-image"
					src="<%= restaurant.getImagePath() %>"
					alt="<%= restaurant.getName() %>">

				<div class="discount-badge">
					<%= restaurant.getDiscountPercent() %>% OFF
				</div>
			</div>

			<div class="card-content">

				<div class="restaurant-name">
					<%= restaurant.getName() %>
				</div>

				<div class="cuisine">
					<%= restaurant.getCuisineType() %>
				</div>

				<div class="restaurant-details">
					<span class="rating"> <%= restaurant.getRating() %> ★ </span>
					<span> 🕒 <%= restaurant.getDeliveryTime() %> min </span>
				</div>

				<a href="menu?restaurantId=<%= restaurant.getRestaurantId() %>"
					class="menu-btn"> View Menu </a>

			</div>

		</div>

		<%
			}
		%>

	</div>

	<%
		}
	%>

</section>

<!-- =========================
     SHARED FOOTER
     ========================= -->

<jsp:include page="/include/footer.jsp" />

<!-- BACK TO TOP -->
<button id="backToTop" class="back-to-top" aria-label="Back to top">↑</button>

<!-- TOAST -->
<div class="foody-toast" id="foodyToast">Ready!</div>

<!-- =========================
     SCRIPT
     ========================= -->

<script>
/* =====================================================
   1. SCROLL PROGRESS BAR
===================================================== */
(function () {
	var bar = document.getElementById("scrollProgress");

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
		el.style.transitionDelay = (index % 3) * 0.09 + "s";
		observer.observe(el);
	});

	/* Safety net */
	setTimeout(function () {
		document.querySelectorAll(".reveal:not(.visible)").forEach(function (el