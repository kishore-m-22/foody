<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.Map" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.DaoImpl.RestaurantDaoImpl" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    @SuppressWarnings("unchecked")
    Map<Integer, CartItem> cart =
        (Map<Integer, CartItem>) session.getAttribute("cart");

    if (cart == null || cart.isEmpty()) {
        response.sendRedirect("cart");
        return;
    }

    double itemTotal = 0;

    for (CartItem item : cart.values()) {
        itemTotal += item.getTotalPrice();
    }

    CartItem firstCartItem = cart.values().iterator().next();

    int restaurantId = firstCartItem.getMenu().getRestaurantId();

    RestaurantDaoImpl restaurantDao = new RestaurantDaoImpl();

    Restaurant restaurant = restaurantDao.getRestaurant(restaurantId);

    int discountPercent = 0;
    String restaurantName = "Restaurant";

    if (restaurant != null) {
        discountPercent = restaurant.getDiscountPercent();
        restaurantName = restaurant.getName();
    }

    double discountAmount = itemTotal * discountPercent / 100.0;

    double discountedSubtotal = itemTotal - discountAmount;

    double deliveryFee;

    if (discountedSubtotal > 300) {
        deliveryFee = 0;
    } else {
        deliveryFee = 40;
    }

    double tax = discountedSubtotal * 0.05;

    double finalTotal =
        discountedSubtotal + deliveryFee + tax;
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Checkout - Foody</title>

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

a:focus-visible, button:focus-visible, input:focus-visible, textarea:focus-visible {
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

/* PAGE */
.page {
	position: relative;
	z-index: 1;
	max-width: 1200px;
	margin: 48px auto 72px;
	padding: 0 32px;
}

.page-title {
	margin-bottom: 30px;
	padding-bottom: 22px;
	border-bottom: 1px solid var(--line);
	position: relative;
	opacity: 0;
	animation: fadeRise 1s .1s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes fadeRise {
	from { opacity: 0; transform: translateY(38px); }
	to   { opacity: 1; transform: translateY(0); }
}

.page-title::after {
	content: "";
	position: absolute;
	left: 0;
	bottom: -1px;
	height: 2px;
	width: 0;
	background: linear-gradient(90deg, var(--tomato), transparent);
	animation: headerLineGrow 1.6s .5s cubic-bezier(.2, .75, .25, 1) forwards;
}

@keyframes headerLineGrow {
	to { width: 100%; }
}

.page-title h1 {
	color: var(--ink);
	font: 500 clamp(2.2rem, 5vw, 3.2rem) / 1.1 var(--serif);
	display: inline-block;
	animation: titleFadeIn 1s .2s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes titleFadeIn {
	from { opacity: 0; transform: translateY(30px); }
	to   { opacity: 1; transform: translateY(0); }
}

.page-title p {
	margin-top: 8px;
	color: var(--muted);
	font-size: 0.9rem;
	animation: subtitleSlide 1.2s .6s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes subtitleSlide {
	from { opacity: 0; transform: translateX(-20px); }
	to   { opacity: 1; transform: translateX(0); }
}

/* LAYOUT */
.checkout-layout {
	display: grid;
	grid-template-columns: minmax(0, 1.5fr) minmax(300px, 0.85fr);
	gap: 25px;
	align-items: start;
}

/* CARD */
.card {
	margin-bottom: 20px;
	padding: 25px;
	background: var(--surface);
	border: 1px solid rgba(32, 40, 33, 0.07);
	border-radius: 14px;
	box-shadow: 0 7px 22px rgba(32, 40, 33, 0.055);
	opacity: 0;
	animation: cardSlideLeft 1s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes cardSlideLeft {
	from { opacity: 0; transform: translateX(-40px); }
	to   { opacity: 1; transform: translateX(0); }
}

/* Right column cards slide from right */
.checkout-layout > div:last-child .card {
	animation: cardSlideRight 1s .25s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes cardSlideRight {
	from { opacity: 0; transform: translateX(40px); }
	to   { opacity: 1; transform: translateX(0); }
}

.card-title {
	margin-bottom: 20px;
	color: var(--ink);
	font-size: 1.15rem;
	font-weight: 700;
	font-family: var(--serif);
	position: relative;
	padding-bottom: 12px;
}

.card-title::after {
	content: "";
	position: absolute;
	left: 0;
	bottom: 0;
	width: 34px;
	height: 3px;
	border-radius: 3px;
	background: var(--tomato);
	transition: width .4s cubic-bezier(.2, .75, .25, 1);
}

.card:hover .card-title::after { width: 60px; }

/* USER INFO */
.user-info {
	margin-bottom: 20px;
	padding: 16px;
	background: #f4f5ed;
	border-radius: 10px;
	transition: background .35s ease, transform .35s ease;
}

.user-info:hover {
	background: #eff1e6;
	transform: translateY(-3px);
}

.user-info p {
	margin: 0 0 8px;
	font-size: 14px;
	line-height: 1.5;
}

.user-info p:last-child { margin-bottom: 0; }

.user-label {
	color: #777d75;
	margin-right: 4px;
	font-weight: 500;
}

.user-info strong {
	color: var(--ink);
	font-weight: 700;
}

/* ADDRESS */
.address-label {
	display: block;
	margin-bottom: 10px;
	color: var(--ink);
	font-size: 14px;
	font-weight: 700;
}

textarea {
	width: 100%;
	min-height: 100px;
	resize: vertical;
	padding: 13px 15px;
	border: 1px solid #ddd;
	border-radius: 10px;
	outline: none;
	background: #ffffff;
	font-family: var(--sans);
	font-size: 14px;
	color: var(--ink);
	line-height: 1.6;
	transition: border-color .35s ease, box-shadow .35s ease;
}

textarea:hover { border-color: #c1c4b5; }

textarea:focus {
	border-color: var(--tomato);
	box-shadow: 0 0 0 4px rgba(185, 75, 51, 0.10);
}

/* PAYMENT */
.payment-title {
	margin-top: 30px;
}

.payment-option {
	display: flex;
	align-items: center;
	gap: 14px;
	margin-bottom: 12px;
	padding: 16px 18px;
	border: 1px solid #e5e5df;
	border-radius: 10px;
	background: var(--surface);
	cursor: pointer;
	position: relative;
	overflow: hidden;
	transition:
		border-color .35s ease,
		background-color .35s ease,
		transform .35s cubic-bezier(.2, .75, .25, 1),
		box-shadow .35s ease;
}

/* Left accent bar that grows on hover */
.payment-option::before {
	content: "";
	position: absolute;
	left: 0;
	top: 0;
	height: 100%;
	width: 3px;
	background: var(--tomato);
	transform: scaleY(0);
	transform-origin: bottom;
	transition: transform .4s cubic-bezier(.2, .75, .25, 1);
}

.payment-option:hover::before {
	transform: scaleY(1);
	transform-origin: top;
}

.payment-option:hover {
	border-color: var(--tomato);
	background: #fffaf7;
	transform: translateX(6px) translateY(-3px);
	box-shadow: 0 10px 22px rgba(185, 75, 51, 0.12);
}

.payment-option:has(input:checked) {
	border-color: var(--tomato);
	background: #fff8f5;
	box-shadow: 0 0 0 3px rgba(185, 75, 51, 0.10);
}

.payment-option input {
	width: 18px;
	height: 18px;
	accent-color: var(--tomato);
	flex-shrink: 0;
	cursor: pointer;
}

.payment-icon {
	font-size: 1.6rem;
	flex-shrink: 0;
	transition: transform .4s cubic-bezier(.2, 1.4, .4, 1);
}

.payment-option:hover .payment-icon {
	transform: scale(1.2) rotate(-8deg);
}

.payment-option:has(input:checked) .payment-icon {
	transform: scale(1.15);
}

.payment-content {
	display: flex;
	flex-direction: column;
	gap: 4px;
}

.payment-name {
	color: var(--ink);
	font-size: 15px;
	font-weight: 700;
}

.payment-description {
	color: var(--muted);
	font-size: 12.5px;
}

/* ORDER ITEMS */
.order-item {
	display: flex;
	align-items: center;
	gap: 14px;
	padding: 14px 0;
	border-bottom: 1px solid #eee;
	opacity: 0;
	animation: fadeRise 0.7s cubic-bezier(.2, .75, .25, 1) both;
	transition: background-color .35s ease, padding .35s ease;
}

.order-item:last-child { border-bottom: none; }

.order-item:nth-child(2) { animation-delay: .1s; }
.order-item:nth-child(3) { animation-delay: .2s; }
.order-item:nth-child(4) { animation-delay: .3s; }
.order-item:nth-child(5) { animation-delay: .4s; }
.order-item:nth-child(6) { animation-delay: .5s; }

.order-item:hover {
	background: #f7f7f0;
	padding-left: 10px;
	padding-right: 10px;
	border-radius: 8px;
}

.food-image {
	width: 65px;
	height: 65px;
	flex-shrink: 0;
	object-fit: cover;
	border-radius: 10px;
	background: #eee;
	transition: transform .5s cubic-bezier(.2, .65, .3, 1), box-shadow .35s ease;
}

.order-item:hover .food-image {
	transform: scale(1.08);
	box-shadow: 0 10px 22px rgba(32, 40, 33, 0.15);
}

.food-details {
	flex: 1;
	min-width: 0;
}

.food-name {
	margin-bottom: 5px;
	color: var(--ink);
	font-size: 15px;
	font-weight: 700;
	font-family: var(--serif);
}

.food-price {
	color: var(--muted);
	font-size: 13px;
}

.quantity {
	color: #555;
	font-weight: 700;
}

.item-total {
	color: var(--ink);
	font-size: 14.5px;
	font-weight: 700;
	white-space: nowrap;
	transition: color .3s ease, transform .35s ease;
}

.order-item:hover .item-total {
	color: var(--tomato);
	transform: scale(1.06);
}

/* SUMMARY ROWS */
.summary-row {
	display: flex;
	justify-content: space-between;
	gap: 20px;
	padding: 11px 0;
	color: var(--muted);
	font-size: 14.5px;
	opacity: 0;
	animation: fadeRise 0.7s cubic-bezier(.2, .75, .25, 1) both;
}

.summary-row:nth-of-type(1) { animation-delay: .5s; }
.summary-row:nth-of-type(2) { animation-delay: .6s; }
.summary-row:nth-of-type(3) { animation-delay: .7s; }
.summary-row:nth-of-type(4) { animation-delay: .8s; }

.summary-row.discount {
	color: #2f7d45;
	font-weight: 600;
}

.summary-row.discount span:last-child {
	color: #2f7d45;
	font-weight: 700;
}

.summary-row.subtotal {
	color: var(--ink);
	font-weight: 600;
}

.summary-row.delivery-free {
	color: #2f7d45;
	font-weight: 600;
}

.summary-row.total {
	margin-top: 10px;
	padding-top: 18px;
	border-top: 1px solid var(--line);
	color: var(--ink);
	font-size: 1.25rem;
	font-weight: 700;
	animation-delay: .9s;
}

.summary-row.total span:last-child {
	color: var(--tomato);
	animation: totalPulse 2.4s ease-in-out 1.6s infinite;
}

@keyframes totalPulse {
	0%, 100% { transform: scale(1); }
	50%      { transform: scale(1.06); }
}

/* NOTES */
.discount-note,
.free-delivery-note {
	margin-top: 15px;
	padding: 12px 14px;
	border-radius: 8px;
	font-size: 12.5px;
	line-height: 1.55;
	opacity: 0;
	animation: notePop 0.7s 1s cubic-bezier(.2, 1.3, .4, 1) both;
}

.discount-note {
	background: #eef8f0;
	border: 1px solid #d6ead9;
	color: #2f7d45;
}

.free-delivery-note {
	background: #f1f8f2;
	border: 1px solid #d6ead9;
	color: #2f7d45;
	font-weight: 600;
}

@keyframes notePop {
	from { opacity: 0; transform: scale(.9) translateY(10px); }
	to   { opacity: 1; transform: scale(1) translateY(0); }
}

/* PLACE ORDER BUTTON */
.place-order {
	width: 100%;
	margin-top: 20px;
	padding: 15px 18px;
	border: none;
	border-radius: 8px;
	background: var(--tomato);
	color: white;
	font-family: var(--sans);
	font-size: 16px;
	font-weight: 700;
	cursor: pointer;
	position: relative;
	overflow: hidden;
	z-index: 0;
	animation: glowPulse 2.4s ease-in-out infinite;
	transition:
		transform .35s cubic-bezier(.2, .75, .25, 1),
		background-color .35s ease,
		box-shadow .35s ease;
}

.place-order::before {
	content: "";
	position: absolute;
	top: 0;
	left: -100%;
	width: 100%;
	height: 100%;
	background: linear-gradient(100deg, transparent, rgba(255, 255, 255, 0.35), transparent);
	transition: left .7s ease;
}

.place-order:hover::before { left: 100%; }

.place-order:hover {
	transform: translateY(-4px);
	background: var(--tomato-dark);
	box-shadow: 0 14px 28px rgba(185, 75, 51, 0.35);
}

.place-order:active { transform: scale(0.97); }

@keyframes glowPulse {
	0%, 100% { box-shadow: 0 0 0 0 rgba(185, 75, 51, 0.35); }
	50%      { box-shadow: 0 0 0 12px rgba(185, 75, 51, 0); }
}

.secure-text {
	margin-top: 12px;
	color: var(--muted);
	text-align: center;
	font-size: 12.5px;
	letter-spacing: 0.02em;
}

/* BACK LINK */
.back-link {
	display: inline-block;
	margin-top: 8px;
	color: var(--tomato);
	font-size: 14px;
	font-weight: 600;
	position: relative;
	transition: color .3s ease, transform .3s ease;
}

.back-link::after {
	content: "";
	position: absolute;
	left: 0;
	bottom: -3px;
	width: 100%;
	height: 1px;
	background: currentColor;
	transform: scaleX(0);
	transform-origin: right;
	transition: transform .4s cubic-bezier(.2, .75, .25, 1);
}

.back-link:hover::after {
	transform: scaleX(1);
	transform-origin: left;
}

.back-link:hover {
	color: var(--tomato-dark);
	transform: translateX(-3px);
}

/* RESPONSIVE */
@media (max-width: 900px) {
	.checkout-layout { grid-template-columns: 1fr; }
}

@media (max-width: 650px) {
	.page {
		padding: 0 18px;
		margin: 34px auto 50px;
	}
	.page-title h1 { font-size: 2.2rem; }
	.card { padding: 20px; }
	.food-image {
		width: 55px;
		height: 55px;
	}
	.item-total { font-size: 13.5px; }
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

<!-- MAIN -->
<main class="page">

	<!-- PAGE TITLE -->
	<div class="page-title">
		<h1>Checkout</h1>
		<p>Complete your order and enjoy your food.</p>
	</div>

	<!-- CHECKOUT LAYOUT -->
	<div class="checkout-layout">

		<!-- ================================
		     LEFT SIDE
		================================ -->
		<div>

			<!-- DELIVERY DETAILS -->
			<div class="card">

				<div class="card-title">Delivery Details</div>

				<div class="user-info">

					<p>
						<span class="user-label">Name:</span>
						<strong><%= user.getUsername() %></strong>
					</p>

					<p>
						<span class="user-label">Email:</span>
						<strong><%= user.getEmail() %></strong>
					</p>

					<p>
						<span class="user-label">Phone:</span>
						<strong><%= user.getPhone() %></strong>
					</p>

				</div>

				<!-- ORDER FORM -->
				<form id="orderForm" action="placeOrder" method="post">

					<label class="address-label" for="address">
						Delivery Address
					</label>

					<textarea
						id="address"
						name="address"
						form="orderForm"
						placeholder="Enter your delivery address..."
						required><%= user.getAddress() %></textarea>

					<!-- PAYMENT -->
					<div class="card-title payment-title">
						Payment Method
					</div>

					<!-- CASH ON DELIVERY -->
					<label class="payment-option">
						<input type="radio" name="paymentMode" value="Cash on Delivery" checked>
						<span class="payment-icon">💵</span>
						<span class="payment-content">
							<span class="payment-name">Cash on Delivery</span>
							<span class="payment-description">Pay when your food arrives</span>
						</span>
					</label>

					<!-- UPI -->
					<label class="payment-option">
						<input type="radio" name="paymentMode" value="UPI">
						<span class="payment-icon">📱</span>
						<span class="payment-content">
							<span class="payment-name">UPI</span>
							<span class="payment-description">Pay using Google Pay, PhonePe or UPI</span>
						</span>
					</label>

					<!-- CARD -->
					<label class="payment-option">
						<input type="radio" name="paymentMode" value="Card">
						<span class="payment-icon">💳</span>
						<span class="payment-content">
							<span class="payment-name">Credit / Debit Card</span>
							<span class="payment-description">Secure card payment</span>
						</span>
					</label>

				</form>

			</div>

			<!-- ORDER ITEMS -->
			<div class="card">

				<div class="card-title">Your Order</div>

				<%
					for (CartItem item : cart.values()) {
				%>

				<div class="order-item">

					<img
						src="<%= item.getMenu().getImagePath() %>"
						class="food-image"
						alt="<%= item.getMenu().getItemName() %>">

					<div class="food-details">

						<div class="food-name">
							<%= item.getMenu().getItemName() %>
						</div>

						<div class="food-price">
							₹<%= String.format("%.2f", item.getMenu().getPrice()) %>
							×
							<span class="quantity"><%= item.getQuantity() %></span>
						</div>

					</div>

					<div class="item-total">
						₹<%= String.format("%.2f", item.getTotalPrice()) %>
					</div>

				</div>

				<%
					}
				%>

			</div>

		</div>

		<!-- ================================
		     RIGHT SIDE
		================================ -->
		<div>

			<!-- BILL DETAILS -->
			<div class="card">

				<div class="card-title">Bill Details</div>

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

				<!-- DISCOUNTED SUBTOTAL -->
				<div class="summary-row subtotal">
					<span>Discounted Subtotal</span>
					<span>₹<%= String.format("%.2f", discountedSubtotal) %></span>
				</div>

				<!-- DELIVERY FEE -->
				<div class="summary-row <%= deliveryFee == 0 ? "delivery-free" : "" %>">
					<span>Delivery Fee</span>
					<span>
						<%
							if (deliveryFee == 0) {
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

				<!-- TAX -->
				<div class="summary-row">
					<span>Taxes &amp; Charges</span>
					<span>₹<%= String.format("%.2f", tax) %></span>
				</div>

				<!-- TOTAL -->
				<div class="summary-row total">
					<span>Total</span>
					<span>₹<%= String.format("%.2f", finalTotal) %></span>
				</div>

				<!-- DISCOUNT MESSAGE -->
				<%
					if (discountPercent > 0) {
				%>

				<div class="discount-note">
					🎉 You saved
					<strong>₹<%= String.format("%.2f", discountAmount) %></strong>
					with the
					<strong><%= restaurantName %></strong>
					discount.
				</div>

				<%
					}
				%>

				<!-- FREE DELIVERY MESSAGE -->
				<%
					if (deliveryFee == 0) {
				%>

				<div class="free-delivery-note">
					🚚 FREE delivery unlocked on this order!
				</div>

				<%
					} else {

						double amountNeeded = 300 - discountedSubtotal;

						if (amountNeeded > 0) {
				%>

				<div class="free-delivery-note">
					🚚 Add
					<strong>₹<%= String.format("%.2f", amountNeeded) %></strong>
					more to unlock FREE delivery.
				</div>

				<%
						}
					}
				%>

				<!-- PLACE ORDER BUTTON -->
				<button type="submit" form="orderForm" class="place-order">
					Place Order
				</button>

				<div class="secure-text">
					🔒 Your order information is secure
				</div>

			</div>

			<!-- BACK TO CART -->
			<a href="cart" class="back-link">
				← Back to Cart
			</a>

		</div>

	</div>

</main>

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
   2. BACK TO TOP
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
   3. SMOOTH PAYMENT OPTION FOCUS
   (auto-focus textarea when the page loads)
===================================================== */
document.addEventListener("DOMContentLoaded", function () {
	var ta = document.getElementById("address");

	if (ta && !ta.value) {
		/* Only auto-focus if empty */
		/* Small delay lets the entrance animation finish */
		setTimeout(function () { ta.focus(); }, 900);
	}
});

</script>

</body>

</html>