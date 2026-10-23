<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.tap.model.Order" %>
<%@ page import="com.tap.model.OrderItem" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.model.User" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    @SuppressWarnings("unchecked")
    List<Order> orders =
            (List<Order>) request.getAttribute("orders");

    @SuppressWarnings("unchecked")
    Map<Integer, String> restaurantNames =
            (Map<Integer, String>) request.getAttribute("restaurantNames");

    @SuppressWarnings("unchecked")
    Map<Integer, List<OrderItem>> orderItemsMap =
            (Map<Integer, List<OrderItem>>) request.getAttribute("orderItemsMap");

    @SuppressWarnings("unchecked")
    Map<Integer, Menu> menuMap =
            (Map<Integer, Menu>) request.getAttribute("menuMap");

    DateTimeFormatter orderDateFormatter =
            DateTimeFormatter.ofPattern("dd MMMM yyyy, h:mm a");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Orders - Foody</title>

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

a:focus-visible, button:focus-visible {
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
.container {
	position: relative;
	z-index: 1;
	width: min(1100px, calc(100% - 64px));
	margin: 48px auto 72px;
}

.page-title {
	margin-bottom: 8px;
	padding-bottom: 22px;
	border-bottom: 1px solid var(--line);
	position: relative;
	color: var(--ink);
	font: 500 clamp(2.2rem, 5vw, 3.1rem) / 1.1 var(--serif);
	display: inline-block;
	opacity: 0;
	animation: titleFadeIn 1s .1s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes titleFadeIn {
	from { opacity: 0; transform: translateY(30px); }
	to   { opacity: 1; transform: translateY(0); }
}

.page-subtitle {
	color: var(--muted);
	margin-bottom: 32px;
	font-size: 0.92rem;
	opacity: 0;
	animation: subtitleSlide 1.2s .35s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes subtitleSlide {
	from { opacity: 0; transform: translateX(-20px); }
	to   { opacity: 1; transform: translateX(0); }
}

/* EMPTY STATE */
.empty-orders {
	background: var(--surface);
	border-radius: 14px;
	padding: 80px 24px;
	text-align: center;
	box-shadow: 0 7px 22px rgba(32, 40, 33, 0.055);
	border: 1px solid rgba(32, 40, 33, 0.06);
	opacity: 0;
	animation: emptyPop 1s .3s cubic-bezier(.2, 1.3, .4, 1) both;
}

@keyframes emptyPop {
	from { opacity: 0; transform: scale(.9) translateY(30px); }
	to   { opacity: 1; transform: scale(1) translateY(0); }
}

.empty-icon {
	font-size: 4rem;
	margin-bottom: 20px;
	display: inline-block;
	animation: float 3.4s ease-in-out infinite;
}

@keyframes float {
	0%, 100% { transform: translateY(0); }
	50%      { transform: translateY(-14px); }
}

.empty-orders h2 {
	margin-bottom: 10px;
	font-family: var(--serif);
	font-size: 1.8rem;
	font-weight: 500;
	color: var(--ink);
}

.empty-orders p {
	color: var(--muted);
	margin-bottom: 26px;
	font-size: 0.95rem;
}

.browse-btn {
	display: inline-block;
	background: var(--tomato);
	color: white;
	padding: 13px 26px;
	border-radius: 8px;
	font-weight: 700;
	position: relative;
	overflow: hidden;
	transition:
		transform .4s cubic-bezier(.2, .75, .25, 1),
		background-color .35s ease,
		box-shadow .35s ease;
}

.browse-btn::before {
	content: "";
	position: absolute;
	top: 0;
	left: -100%;
	width: 100%;
	height: 100%;
	background: linear-gradient(100deg, transparent, rgba(255, 255, 255, 0.35), transparent);
	transition: left .7s ease;
}

.browse-btn:hover::before { left: 100%; }

.browse-btn:hover {
	background: var(--tomato-dark);
	transform: translateY(-5px);
	box-shadow: 0 12px 26px rgba(185, 75, 51, 0.35);
}

.browse-btn:active { transform: scale(0.96); }

/* ORDER CARD */
.order-card {
	background: var(--surface);
	border-radius: 14px;
	margin-bottom: 22px;
	padding: 26px;
	box-shadow: 0 7px 22px rgba(32, 40, 33, 0.055);
	border: 1px solid rgba(32, 40, 33, 0.07);
	opacity: 1;
	transform: translateY(0);
	transition:
		opacity .9s cubic-bezier(.2, .75, .25, 1),
		transform .5s cubic-bezier(.2, .75, .25, 1),
		box-shadow .4s ease,
		border-color .4s ease;
	will-change: transform, opacity;
}

body.js-reveal .order-card.reveal {
	opacity: 0;
	transform: perspective(900px) rotateX(-10deg) translateY(50px) scale(.96);
}

body.js-reveal .order-card.reveal.visible {
	opacity: 1;
	transform: perspective(900px) rotateX(0) translateY(0) scale(1);
}

.order-card:hover {
	transform: translateY(-6px);
	border-color: rgba(185, 75, 51, 0.22);
	box-shadow:
		0 22px 45px rgba(32, 40, 33, 0.14),
		0 0 0 1px rgba(185, 75, 51, 0.08);
}

/* ORDER TOP */
.order-top {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding-bottom: 18px;
	border-bottom: 1px solid #eeeeea;
	gap: 15px;
}

.order-id {
	font-size: 1.15rem;
	font-weight: 700;
	color: var(--ink);
	font-family: var(--serif);
	transition: color .3s ease;
}

.order-card:hover .order-id {
	color: var(--tomato-dark);
}

.order-date {
	color: var(--muted);
	font-size: 13.5px;
	margin-top: 6px;
}

.status {
	padding: 7px 14px;
	border-radius: 20px;
	background: #e8f7ee;
	color: #168544;
	font-size: 12.5px;
	font-weight: 700;
	letter-spacing: 0.03em;
	text-transform: uppercase;
	animation: badgePulse 2.6s ease-in-out infinite;
	transition: transform .35s ease;
}

.order-card:hover .status {
	transform: scale(1.06);
}

@keyframes badgePulse {
	0%, 100% { box-shadow: 0 0 0 0 rgba(22, 133, 68, 0.25); }
	50%      { box-shadow: 0 0 0 8px rgba(22, 133, 68, 0); }
}

/* ORDER DETAILS */
.order-details {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 18px;
	padding: 22px 0;
}

.detail-box {
	background: #fafaf7;
	padding: 15px 16px;
	border-radius: 10px;
	border: 1px solid rgba(32, 40, 33, 0.05);
	transition:
		transform .35s cubic-bezier(.2, .75, .25, 1),
		background-color .35s ease,
		border-color .35s ease;
}

.order-card:hover .detail-box {
	border-color: rgba(72, 92, 70, 0.14);
	background: #f7f7f1;
}

.detail-box:hover {
	transform: translateY(-4px);
	background: #f1f2ea;
}

.detail-label {
	font-size: 12px;
	color: #888;
	margin-bottom: 6px;
	letter-spacing: 0.03em;
	text-transform: uppercase;
	font-weight: 600;
}

.detail-value {
	font-size: 15px;
	font-weight: 700;
	color: var(--ink);
	word-break: break-word;
}

/* ITEMS SECTION */
.items-section {
	border-top: 1px solid #eeeeea;
	padding-top: 20px;
	padding-bottom: 20px;
}

.items-title {
	font-size: 14px;
	font-weight: 700;
	color: var(--ink);
	margin-bottom: 14px;
	letter-spacing: 0.02em;
	text-transform: uppercase;
}

.items-list {
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.order-item {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 13px 15px;
	background: #fafaf7;
	border: 1px solid rgba(32, 40, 33, 0.05);
	border-radius: 9px;
	gap: 12px;
	opacity: 0;
	animation: itemFadeIn 0.6s cubic-bezier(.2, .75, .25, 1) both;
	transition:
		background-color .35s ease,
		padding .35s ease,
		border-color .35s ease;
}

.order-item:nth-child(1) { animation-delay: 0.15s; }
.order-item:nth-child(2) { animation-delay: 0.25s; }
.order-item:nth-child(3) { animation-delay: 0.35s; }
.order-item:nth-child(4) { animation-delay: 0.45s; }
.order-item:nth-child(5) { animation-delay: 0.55s; }

@keyframes itemFadeIn {
	from { opacity: 0; transform: translateX(-20px); }
	to   { opacity: 1; transform: translateX(0); }
}

.order-item:hover {
	background: #f1f2ea;
	border-color: rgba(72, 92, 70, 0.16);
	padding-left: 20px;
	padding-right: 20px;
}

.item-left {
	display: flex;
	align-items: center;
	gap: 12px;
	min-width: 0;
	flex: 1;
}

.item-number {
	width: 28px;
	height: 28px;
	display: flex;
	align-items: center;
	justify-content: center;
	flex-shrink: 0;
	border-radius: 50%;
	background: #f7e9e4;
	color: var(--tomato);
	font-size: 12px;
	font-weight: 700;
	transition: transform .35s cubic-bezier(.2, 1.4, .4, 1), background .3s ease;
}

.order-item:hover .item-number {
	transform: scale(1.15) rotate(-8deg);
	background: var(--tomato);
	color: white;
}

.item-name {
	font-size: 14.5px;
	font-weight: 600;
	color: var(--ink);
	word-break: break-word;
	display: inline-flex;
	align-items: center;
	gap: 8px;
	flex-wrap: wrap;
}

/* QUANTITY BADGE */
.item-qty {
	display: inline-block;
	padding: 2px 9px;
	border-radius: 5px;
	background: #f3ece2;
	color: var(--tomato);
	font-size: 12px;
	font-weight: 800;
	letter-spacing: 0.02em;
	line-height: 1.4;
	transition: background .3s ease, color .3s ease, transform .3s ease;
}

.order-item:hover .item-qty {
	background: var(--tomato);
	color: white;
	transform: scale(1.08);
}

.item-price {
	font-size: 14.5px;
	font-weight: 700;
	color: var(--tomato);
	white-space: nowrap;
	transition: transform .35s ease;
	flex-shrink: 0;
}

.order-item:hover .item-price {
	transform: scale(1.06);
}

.no-items {
	color: #888;
	font-size: 14px;
	padding: 10px 0;
}

/* =========================================================
   BILL BREAKDOWN
========================================================= */

.bill {
	border-top: 1px solid #eeeeea;
	padding-top: 16px;
	display: flex;
	flex-direction: column;
	gap: 9px;
}

.bill-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	gap: 15px;
	color: var(--muted);
	font-size: 14px;
	opacity: 0;
	animation: billRowIn 0.5s cubic-bezier(.2, .75, .25, 1) both;
}

.bill-row:nth-child(1) { animation-delay: 0.15s; }
.bill-row:nth-child(2) { animation-delay: 0.22s; }
.bill-row:nth-child(3) { animation-delay: 0.29s; }
.bill-row:nth-child(4) { animation-delay: 0.36s; }
.bill-row:nth-child(5) { animation-delay: 0.43s; }

@keyframes billRowIn {
	from { opacity: 0; transform: translateY(6px); }
	to   { opacity: 1; transform: translateY(0); }
}

.bill-row span:first-child {
	display: inline-flex;
	align-items: center;
	gap: 6px;
}

.bill-row span:last-child {
	color: var(--ink);
	font-weight: 600;
}

.bill-row.discount,
.bill-row.discount span:last-child {
	color: #2f7d45;
	font-weight: 700;
}

.bill-row.delivery-free span:last-child {
	color: #2f7d45;
	font-weight: 700;
}

.bill-row.total {
	border-top: 1px solid #eeeeea;
	padding-top: 13px;
	margin-top: 5px;
	color: var(--ink);
	font-size: 1.2rem;
	font-weight: 700;
	animation: billRowIn 0.5s .5s cubic-bezier(.2, .75, .25, 1) both,
		totalPulse 2.6s ease-in-out 1.6s infinite;
}

.bill-row.total span:last-child {
	color: var(--tomato);
	font-family: var(--sans);
	font-size: 1.35rem;
}

@keyframes totalPulse {
	0%, 100% { transform: scale(1); }
	50%      { transform: scale(1.04); }
}

/* Save-badge pill (optional flourish) */
.save-pill {
	display: inline-block;
	margin-left: 6px;
	padding: 1px 8px;
	border-radius: 5px;
	background: #e6f4ea;
	color: #2f7d45;
	font-size: 11px;
	font-weight: 800;
	letter-spacing: 0.03em;
	text-transform: uppercase;
}

/* RESPONSIVE */
@media (max-width: 700px) {
	.container {
		width: calc(100% - 36px);
		margin: 30px auto 50px;
	}

	.page-title { font-size: 2rem; }

	.order-card { padding: 20px; }

	.order-details {
		grid-template-columns: 1fr;
		gap: 12px;
	}

	.order-top {
		align-items: flex-start;
		gap: 12px;
	}

	.order-item {
		align-items: flex-start;
		gap: 10px;
	}

	.item-left { align-items: flex-start; }

	.bill-row { font-size: 13px; }

	.bill-row.total {
		font-size: 1.1rem;
	}

	.bill-row.total span:last-child {
		font-size: 1.2rem;
	}
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
<div class="container">

	<h1 class="page-title">My Orders</h1>

	<p class="page-subtitle">
		View your recent Foody orders
	</p>

	<%
		if (orders == null || orders.isEmpty()) {
	%>

	<!-- EMPTY STATE -->
	<div class="empty-orders">
		<div class="empty-icon">🍽️</div>
		<h2>No orders yet</h2>
		<p>You haven't placed any orders yet.</p>
		<a href="restaurants" class="browse-btn">
			Browse Restaurants
		</a>
	</div>

	<%
		} else {

			for (Order order : orders) {
	%>

	<!-- ORDER CARD -->
	<div class="order-card reveal">

		<!-- ORDER TOP -->
		<div class="order-top">

			<div>
				<div class="order-id">
					Order #<%= order.getOrderId() %>
				</div>
				<div class="order-date">
					<%= order.getOrderDate().format(orderDateFormatter) %>
				</div>
			</div>

			<div class="status">
				<%= order.getStatus() %>
			</div>

		</div>

		<!-- ORDER DETAILS -->
		<div class="order-details">

			<div class="detail-box">
				<div class="detail-label">Restaurant</div>
				<div class="detail-value">
					<%
						String restaurantName =
								restaurantNames.get(order.getRestaurantId());

						if (restaurantName == null) {
							restaurantName =
									"Restaurant #" + order.getRestaurantId();
						}
					%>
					<%= restaurantName %>
				</div>
			</div>

			<div class="detail-box">
				<div class="detail-label">Payment</div>
				<div class="detail-value">
					<%= order.getPaymentMode() %>
				</div>
			</div>

			<div class="detail-box">
				<div class="detail-label">Order Status</div>
				<div class="detail-value">
					<%= order.getStatus() %>
				</div>
			</div>

		</div>

		<!-- ORDER ITEMS -->
		<div class="items-section">

			<div class="items-title">Items Ordered</div>

			<div class="items-list">

				<%
					List<OrderItem> orderItems =
							orderItemsMap.get(order.getOrderId());
				%>

				<%
					if (orderItems != null && !orderItems.isEmpty()) {

						int itemNumber = 1;

						for (OrderItem orderItem : orderItems) {

							Menu menu =
									menuMap.get(orderItem.getMenuId());
				%>

				<div class="order-item">

					<div class="item-left">

						<div class="item-number">
							<%= itemNumber++ %>
						</div>

						<div class="item-name">

							<%
								if (menu != null) {
							%>
								<%= menu.getItemName() %>
							<%
								} else {
							%>
								Menu Item #<%= orderItem.getMenuId() %>
							<%
								}
							%>

							<span class="item-qty">
								× <%= orderItem.getQuantity() %>
							</span>

						</div>

					</div>

					<div class="item-price">
						₹<%= String.format(
								"%.2f",
								orderItem.getTotalAmount()
							) %>
					</div>

				</div>

				<%
						}

					} else {
				%>

				<div class="no-items">
					No item details available.
				</div>

				<%
					}
				%>

			</div>

		</div>

		<!-- =========================================================
		     BILL BREAKDOWN
		========================================================= -->
		<div class="bill">

			<!-- ITEMS SUBTOTAL -->
			<div class="bill-row">
				<span>Items Subtotal</span>
				<span>₹<%= String.format("%.2f", order.getSubtotal()) %></span>
			</div>

			<!-- RESTAURANT DISCOUNT -->
			<%
				if (order.getDiscountPercent() > 0) {
			%>

			<div class="bill-row discount">
				<span>
					Restaurant Discount (<%= order.getDiscountPercent() %>%)
				</span>
				<span>
					-₹<%= String.format("%.2f", order.getDiscountAmount()) %>
				</span>
			</div>

			<%
				}
			%>

			<!-- DELIVERY FEE -->
			<div class="bill-row <%= order.getDeliveryFee() == 0 ? "delivery-free" : "" %>">
				<span>Delivery Fee</span>
				<span>
					<%
						if (order.getDeliveryFee() == 0) {
					%>
						FREE
					<%
						} else {
					%>
						₹<%= String.format("%.2f", order.getDeliveryFee()) %>
					<%
						}
					%>
				</span>
			</div>

			<!-- TAX -->
			<div class="bill-row">
				<span>Taxes (5%)</span>
				<span>₹<%= String.format("%.2f", order.getTax()) %></span>
			</div>

			<!-- TOTAL -->
			<div class="bill-row total">
				<span>
					Order Total
					<%
						if (order.getDiscountAmount() > 0) {
					%>
					<span class="save-pill">
						Saved ₹<%= String.format("%.0f", order.getDiscountAmount()) %>
					</span>
					<%
						}
					%>
				</span>
				<span>
					₹<%= String.format("%.2f", order.getTotalAmount()) %>
				</span>
			</div>

		</div>

	</div>

	<%
			}
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

	revealElements.forEach(function (el, index) {
		el.style.transitionDelay = (index % 4) * 0.08 + "s";
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

</script>

</body>

</html>