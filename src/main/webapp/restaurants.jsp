<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.tap.model.Restaurant"%>

<%
    List<Restaurant> restaurants =
        (List<Restaurant>) request.getAttribute("restaurants");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Foody - Restaurants</title>

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
		radial-gradient(ellipse at 92% 10%, rgba(190, 202, 166, 0.20), transparent 29rem),
		radial-gradient(ellipse at 8% 92%, rgba(212, 151, 112, 0.14), transparent 26rem),
		var(--paper);
	font-family: var(--sans);
	-webkit-font-smoothing: antialiased;
	animation: pageFadeIn 0.6s ease both;
}

@keyframes pageFadeIn {
	from { opacity: 0; }
	to   { opacity: 1; }
}

a { text-decoration: none; color: inherit; }

a:focus-visible, button:focus-visible, input:focus-visible {
	outline: 3px solid rgba(72, 92, 70, 0.55);
	outline-offset: 3px;
}

/* SCROLL PROGRESS */
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

/* BACK TO TOP */
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

@keyframes ringPulse {
	0%   { opacity: 0.6; transform: scale(0.9); }
	100% { opacity: 0;   transform: scale(1.4); }
}

.back-to-top:hover {
	background: var(--tomato-dark);
	transform: translateY(-5px) scale(1.12) rotate(-6deg);
}

.back-to-top:active { transform: scale(0.9); }

/* PAGE HEADER */
.page-header {
	position: relative;
	max-width: 1200px;
	margin: 52px auto 25px;
	padding: 0 20px 25px;
	border-bottom: 1px solid var(--line);
	opacity: 0;
	animation: fadeRise 1s .1s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes fadeRise {
	from { opacity: 0; transform: translateY(38px); }
	to   { opacity: 1; transform: translateY(0); }
}

.page-header::after {
	content: "";
	position: absolute;
	left: 20px;
	bottom: -1px;
	height: 2px;
	width: 0;
	background: linear-gradient(90deg, var(--tomato), transparent);
	animation: headerLineGrow 1.6s .5s cubic-bezier(.2, .75, .25, 1) forwards;
}

@keyframes headerLineGrow {
	to { width: calc(100% - 40px); }
}

.page-header h1 {
	margin-bottom: 8px;
	color: var(--ink);
	font: 500 clamp(2.2rem, 5vw, 3.2rem) / 1.1 var(--serif);
	display: inline-block;
	animation: titleFadeIn 1s .2s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes titleFadeIn {
	from { opacity: 0; transform: translateY(30px); }
	to   { opacity: 1; transform: translateY(0); }
}

.page-header p {
	color: var(--muted);
	font-size: 0.9rem;
	animation: subtitleSlide 1.2s .6s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes subtitleSlide {
	from { opacity: 0; transform: translateX(-20px); }
	to   { opacity: 1; transform: translateX(0); }
}

/* SEARCH */
.search-section {
	max-width: 1200px;
	margin: 0 auto 30px;
	padding: 0 20px;
	animation: fadeRise 1s .3s cubic-bezier(.2, .75, .25, 1) both;
}

.search-box {
	height: 56px;
	display: flex;
	align-items: center;
	padding: 0 18px;
	background: var(--surface);
	border: 1px solid #deded4;
	border-radius: 8px;
	box-shadow: 0 8px 22px rgba(32, 40, 33, 0.045);
	transition: border-color .35s ease, box-shadow .35s ease, transform .35s ease;
}

.search-box:focus-within {
	border-color: #879174;
	box-shadow: 0 0 0 4px rgba(72, 92, 70, 0.10),
		0 8px 22px rgba(32, 40, 33, 0.08);
	transform: translateY(-2px);
}

.search-icon {
	color: var(--sage);
	font-size: 1rem;
	margin-right: 10px;
	transition: transform .35s ease;
}

.search-box:focus-within .search-icon {
	transform: scale(1.15) rotate(-8deg);
}

.search-box input {
	width: 100%;
	height: 100%;
	border: none;
	outline: none;
	color: var(--ink);
	background: transparent;
	font: 400 0.92rem var(--sans);
}

/* RESTAURANT CONTAINER */
.restaurant-container {
	max-width: 1200px;
	margin: auto;
	padding: 0 20px 60px;
}

/* GRID */
.restaurant-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(min(100%, 300px), 1fr));
	gap: 22px;
}

/* CARD */
.restaurant-card {
	background: var(--surface);
	border: 1px solid rgba(32, 40, 33, 0.07);
	border-radius: 14px;
	overflow: hidden;
	box-shadow: 0 7px 22px rgba(32, 40, 33, 0.055);
	opacity: 1;
	transform: translateY(0);
	transition:
		opacity .9s cubic-bezier(.2, .75, .25, 1),
		transform .5s cubic-bezier(.2, .75, .25, 1),
		box-shadow .4s ease,
		border-color .4s ease;
	will-change: transform, opacity;
}

body.js-reveal .restaurant-card.reveal {
	opacity: 0;
	transform: perspective(900px) rotateX(-12deg) translateY(60px) scale(.94);
}

body.js-reveal .restaurant-card.reveal.visible {
	opacity: 1;
	transform: perspective(900px) rotateX(0) translateY(0) scale(1);
}

.restaurant-card:hover {
	transform: translateY(-12px) scale(1.02);
	border-color: rgba(185, 75, 51, 0.22);
	box-shadow:
		0 28px 55px rgba(32, 40, 33, 0.14),
		0 0 0 1px rgba(185, 75, 51, 0.08);
}

.restaurant-card:focus-within {
	outline: 2px solid rgba(72, 92, 70, 0.45);
	outline-offset: 4px;
}

/* IMAGE */
.image-container {
	height: 225px;
	position: relative;
	overflow: hidden;
	background: #eeeeee;
}

.image-container::before {
	content: "";
	position: absolute;
	top: 0;
	left: -80%;
	width: 60%;
	height: 100%;
	background: linear-gradient(100deg, transparent, rgba(255, 255, 255, 0.45), transparent);
	transform: skewX(-22deg);
	z-index: 2;
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

.image-container::after {
	content: "";
	position: absolute;
	inset: 45% 0 0;
	pointer-events: none;
	background: linear-gradient(to bottom, transparent, rgba(0, 0, 0, 0.22));
	opacity: 0.7;
	transition: opacity .4s ease;
	z-index: 1;
}

.restaurant-card:hover .image-container::after {
	opacity: 1;
}

.restaurant-image {
	width: 100%;
	height: 100%;
	object-fit: cover;
	display: block;
	transition: transform 1s cubic-bezier(.2, .65, .3, 1), filter .5s ease;
}

.restaurant-card:hover .restaurant-image {
	transform: scale(1.1);
	filter: saturate(1.12) brightness(1.05);
}

/* DISCOUNT BADGE */
.discount-badge {
	position: absolute;
	left: 14px;
	bottom: 14px;
	z-index: 3;
	padding: 8px 13px;
	border-radius: 6px;
	background: var(--tomato);
	color: white;
	font-size: 0.72rem;
	font-weight: 800;
	letter-spacing: 0.05em;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
	transition: transform .35s ease, background .35s ease;
}

.restaurant-card:hover .discount-badge {
	transform: translateY(-4px) scale(1.06);
	background: var(--tomato-dark);
}

/* CARD CONTENT */
.card-content {
	padding: 20px;
}

.restaurant-top {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	gap: 10px;
	margin-bottom: 8px;
}

.restaurant-name {
	color: var(--ink);
	font-family: var(--serif);
	font-size: 1.32rem;
	font-weight: 600;
	line-height: 1.25;
	transition: color .3s ease, transform .35s cubic-bezier(.2, .75, .25, 1);
}

.restaurant-card:hover .restaurant-name {
	color: var(--tomato-dark);
	transform: translateX(3px);
}

.rating {
	padding: 5px 9px;
	border-radius: 5px;
	background: var(--sage);
	color: white;
	font-size: 13px;
	font-weight: 700;
	white-space: nowrap;
	transition: transform .35s cubic-bezier(.2, 1.4, .4, 1), background .35s ease;
}

.restaurant-card:hover .rating {
	transform: scale(1.1);
	background: var(--tomato);
}

.cuisine {
	color: var(--muted);
	font-size: 14px;
	margin-bottom: 15px;
	transition: color .3s ease;
}

.restaurant-card:hover .cuisine {
	color: #585f56;
}

/* INFO ROW */
.restaurant-info {
	display: flex;
	flex-wrap: wrap;
	gap: 14px;
	color: var(--muted);
	font-size: 14px;
	margin-bottom: 10px;
}

.info-item {
	display: inline-flex;
	align-items: center;
	gap: 5px;
	transition: color .3s ease, transform .35s ease;
}

.restaurant-card:hover .info-item {
	color: var(--ink);
	transform: translateX(2px);
}

.address {
	color: #878b80;
	font-size: 13px;
	margin-bottom: 18px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

/* VIEW MENU BUTTON */
.menu-button {
	display: block;
	width: 100%;
	padding: 13px 16px;
	border-radius: 8px;
	background: var(--sage);
	color: white;
	text-align: center;
	font-size: 15px;
	font-weight: 700;
	position: relative;
	overflow: hidden;
	transition:
		color .35s ease,
		background-color .35s ease,
		transform .35s cubic-bezier(.2, .75, .25, 1),
		box-shadow .35s ease,
		padding .35s ease;
}

.menu-button::before {
	content: "→";
	position: absolute;
	right: 16px;
	top: 50%;
	transform: translate(-6px, -50%);
	opacity: 0;
	transition: opacity .35s ease, transform .35s ease;
}

.menu-button:hover::before {
	opacity: 1;
	transform: translate(0, -50%);
}

.menu-button:hover {
	transform: translateY(-4px);
	background: #344733;
	box-shadow: 0 12px 24px rgba(72, 92, 70, 0.3);
	padding-right: 40px;
}

.menu-button:active {
	transform: scale(0.97);
}

/* EMPTY */
.empty-state {
	text-align: center;
	padding: 70px 20px;
	background: var(--surface);
	border: 1px solid var(--line);
	border-radius: 14px;
	box-shadow: 0 7px 22px rgba(32, 40, 33, 0.055);
	opacity: 0;
	animation: fadeRise 1s .2s cubic-bezier(.2, .75, .25, 1) both;
}

.empty-state h2 {
	margin-bottom: 10px;
	color: var(--ink);
	font-family: var(--serif);
	font-size: 1.8rem;
	font-weight: 500;
}

.empty-state p {
	color: var(--muted);
}

/* RESPONSIVE */
@media (max-width: 900px) {
	.page-header { margin-top: 42px; }
}

@media (max-width: 600px) {
	.page-header {
		margin-top: 34px;
		padding-left: 20px;
		padding-right: 20px;
	}
	.page-header h1 { font-size: 2.2rem; }
	.restaurant-container { padding-bottom: 42px; }
	.image-container { height: 215px; }
	.card-content { padding: 18px; }
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

<!-- HEADER -->
<jsp:include page="/include/header.jsp" />

<!-- PAGE HEADER -->
<section class="page-header">
	<h1>Restaurants</h1>
	<p>Discover delicious food from the best restaurants around you.</p>
</section>

<!-- SEARCH -->
<section class="search-section">
	<div class="search-box">
		<span class="search-icon">🔍</span>
		<input
			type="text"
			id="restaurantSearch"
			placeholder="Search restaurants or cuisines..."
			onkeyup="searchRestaurants()">
	</div>
</section>

<!-- RESTAURANTS -->
<section class="restaurant-container">

	<%
		if (restaurants != null && !restaurants.isEmpty()) {
	%>

	<div class="restaurant-grid" id="restaurantGrid">

		<%
			for (Restaurant restaurant : restaurants) {

				if (!restaurant.isActive()) {
					continue;
				}
		%>

		<div class="restaurant-card reveal"

			data-name="<%= restaurant.getName().toLowerCase() %>"

			data-cuisine="<%= restaurant.getCuisineType() != null
					? restaurant.getCuisineType().toLowerCase()
					: "" %>">

			<!-- IMAGE -->
			<div class="image-container">

				<img
					class="restaurant-image"
					src="<%= restaurant.getImagePath() %>"
					alt="<%= restaurant.getName() %>">

				<%
					if (restaurant.getDiscountPercent() > 0) {
				%>

				<div class="discount-badge">
					<%= restaurant.getDiscountPercent() %>% OFF
				</div>

				<%
					}
				%>

			</div>

			<!-- CONTENT -->
			<div class="card-content">

				<div class="restaurant-top">

					<div class="restaurant-name">
						<%= restaurant.getName() %>
					</div>

					<div class="rating">
						<%= restaurant.getRating() %> ★
					</div>

				</div>

				<div class="cuisine">
					<%= restaurant.getCuisineType() %>
				</div>

				<div class="restaurant-info">

					<div class="info-item">
						🕐 <%= restaurant.getDeliveryTime() %> min
					</div>

					<div class="info-item">
						🍽️ Food
					</div>

				</div>

				<div class="address">
					📍 <%= restaurant.getAddress() %>
				</div>

				<a
					href="menu?restaurantId=<%= restaurant.getRestaurantId() %>"
					class="menu-button">
					View Menu
				</a>

			</div>

		</div>

		<%
			}
		%>

	</div>

	<%
		} else {
	%>

	<!-- EMPTY STATE -->
	<div class="empty-state">
		<h2>No restaurants available</h2>
		<p>We couldn't find any restaurants right now.</p>
	</div>

	<%
		}
	%>

</section>

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
		el.style.transitionDelay = (index % 3) * 0.09 + "s";
		observer.observe(el);
	});

	/* Safety net */
	setTimeout(function () {
		document.querySelectorAll(".reveal:not(.visible)").forEach(function (el) {
			el.classList.add("visible");
		});
	}, 2500);
});

/* =====================================================
   3. LIVE SEARCH FILTER
===================================================== */
function searchRestaurants() {

	var input =
		document.getElementById("restaurantSearch")
			.value
			.toLowerCase()
			.trim();

	var cards = document.querySelectorAll(".restaurant-card");

	cards.forEach(function (card) {

		var name = card.getAttribute("data-name") || "";
		var cuisine = card.getAttribute("data-cuisine") || "";

		if (name.indexOf(input) !== -1 || cuisine.indexOf(input) !== -1) {
			card.style.display = "";
		} else {
			card.style.display = "none";
		}
	});
}

/* =====================================================
   4. BACK TO TOP
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

</script>

</body>

</html>