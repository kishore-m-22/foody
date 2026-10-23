<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.tap.model.User" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer orderId =
            (Integer) session.getAttribute("lastOrderId");

    String address =
            (String) session.getAttribute("orderAddress");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Order Confirmed - Foody</title>

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
		radial-gradient(ellipse at 50% 0%, rgba(190, 202, 166, 0.26), transparent 34rem),
		radial-gradient(ellipse at 8% 90%, rgba(212, 151, 112, 0.14), transparent 26rem),
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

/* CONFETTI */
.confetti-layer {
	position: fixed;
	inset: 0;
	pointer-events: none;
	z-index: 9000;
	overflow: hidden;
}

.confetti-piece {
	position: absolute;
	width: 10px;
	height: 10px;
	top: -20px;
	border-radius: 2px;
	opacity: 0.9;
	animation: confettiFall linear forwards;
}

@keyframes confettiFall {
	0% {
		transform: translateY(-20px) rotate(0deg);
		opacity: 1;
	}
	100% {
		transform: translateY(110vh) rotate(720deg);
		opacity: 0;
	}
}

/* PAGE CONTAINER */
.page {
	position: relative;
	z-index: 1;
	width: min(720px, calc(100% - 40px));
	margin: 58px auto 72px;
	animation: pageRise 1s cubic-bezier(0.2, 0.75, 0.25, 1) both;
}

@keyframes pageRise {
	from { opacity: 0; transform: translateY(40px); }
	to   { opacity: 1; transform: translateY(0); }
}

/* SUCCESS CARD */
.success-card {
	position: relative;
	overflow: hidden;
	padding: 45px;
	border: 1px solid rgba(32, 40, 33, 0.08);
	border-radius: 14px;
	background: var(--surface);
	box-shadow:
		0 24px 65px rgba(44, 46, 37, 0.1),
		0 3px 12px rgba(44, 46, 37, 0.06);
	text-align: center;
}

/* Top accent line */
.success-card::before {
	content: "";
	position: absolute;
	top: 0;
	left: 50%;
	width: 160px;
	height: 3px;
	border-radius: 3px;
	background: linear-gradient(90deg, transparent, #879174, transparent);
	transform: translateX(-50%);
	animation: accentGrow 1.4s .4s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes accentGrow {
	from { width: 0; }
	to   { width: 160px; }
}

/* Floating ingredient subtle glow */
.success-card::after {
	content: "";
	position: absolute;
	top: -80px;
	right: -80px;
	width: 260px;
	height: 260px;
	border-radius: 50%;
	background: radial-gradient(circle, rgba(190, 202, 166, 0.28), transparent 65%);
	pointer-events: none;
	animation: glowPulse 5s ease-in-out infinite;
}

@keyframes glowPulse {
	0%, 100% { transform: scale(1); opacity: 0.6; }
	50%      { transform: scale(1.15); opacity: 1; }
}

/* SUCCESS ICON */
.success-icon {
	width: 84px;
	height: 84px;
	margin: 0 auto 25px;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;

	background: #e8f4ec;
	color: #2f7d45;
	border: 1px solid #cfe6d4;

	font-size: 2.2rem;
	font-weight: 700;

	animation:
		successPop 1s .15s cubic-bezier(.2, 1.4, .4, 1) both,
		ringPulse 2.8s ease-out 1.4s infinite;
}

@keyframes successPop {
	0% {
		opacity: 0;
		transform: scale(0.4) rotate(-40deg);
	}
	70% {
		transform: scale(1.12) rotate(4deg);
	}
	100% {
		opacity: 1;
		transform: scale(1) rotate(0);
	}
}

@keyframes ringPulse {
	0% {
		box-shadow: 0 0 0 0 rgba(47, 125, 69, 0.4);
	}
	100% {
		box-shadow: 0 0 0 20px rgba(47, 125, 69, 0);
	}
}

/* HEADING */
.success-card h1 {
	margin-bottom: 14px;
	color: var(--ink);
	font: 500 clamp(1.9rem, 4vw, 2.6rem) / 1.1 var(--serif);

	opacity: 0;
	animation: titleFadeIn 1s .35s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes titleFadeIn {
	from { opacity: 0; transform: translateY(24px); }
	to   { opacity: 1; transform: translateY(0); }
}

/* MESSAGE */
.success-message {
	max-width: 480px;
	margin: 0 auto 30px;
	color: var(--muted);
	font-size: 0.95rem;
	line-height: 1.65;

	opacity: 0;
	animation: titleFadeIn 1s .5s cubic-bezier(.2, .75, .25, 1) both;
}

.success-message strong {
	color: var(--ink);
	font-weight: 700;
}

/* ORDER BOX */
.order-box {
	margin-bottom: 30px;
	padding: 4px 22px;
	border: 1px solid var(--line);
	border-radius: 10px;
	background: #f8f8f2;
	text-align: left;

	opacity: 0;
	animation: boxSlide 1s .65s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes boxSlide {
	from { opacity: 0; transform: translateY(24px) scale(.98); }
	to   { opacity: 1; transform: translateY(0) scale(1); }
}

.order-row {
	display: flex;
	justify-content: space-between;
	gap: 20px;
	padding: 15px 0;
	border-bottom: 1px solid #e8e7dd;

	opacity: 0;
	animation: rowFade 0.6s cubic-bezier(.2, .75, .25, 1) both;
}

.order-row:last-child { border-bottom: none; }

.order-row:nth-child(1) { animation-delay: 0.85s; }
.order-row:nth-child(2) { animation-delay: 0.95s; }
.order-row:nth-child(3) { animation-delay: 1.05s; }

@keyframes rowFade {
	from { opacity: 0; transform: translateX(-12px); }
	to   { opacity: 1; transform: translateX(0); }
}

.order-label {
	color: var(--muted);
	font-size: 0.85rem;
	font-weight: 500;
	letter-spacing: 0.02em;
}

.order-value {
	color: var(--ink);
	font-size: 0.9rem;
	font-weight: 700;
	text-align: right;
	word-break: break-word;
	max-width: 70%;
}

.order-value.status-badge {
	display: inline-block;
	padding: 4px 12px;
	border-radius: 20px;
	background: #e8f7ee;
	color: #168544;
	font-size: 0.78rem;
	letter-spacing: 0.05em;
	text-transform: uppercase;
	animation: badgePulse 2.6s ease-in-out infinite;
}

@keyframes badgePulse {
	0%, 100% { box-shadow: 0 0 0 0 rgba(22, 133, 68, 0.28); }
	50%      { box-shadow: 0 0 0 8px rgba(22, 133, 68, 0); }
}

.order-value.order-id-value {
	color: var(--tomato);
	font-size: 1.05rem;
	font-family: var(--serif);
}

/* BUTTONS */
.buttons {
	display: flex;
	justify-content: center;
	gap: 12px;

	opacity: 0;
	animation: titleFadeIn 1s 1.2s cubic-bezier(.2, .75, .25, 1) both;
}

.btn {
	position: relative;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	gap: 8px;

	min-height: 48px;
	padding: 13px 26px;

	border-radius: 8px;
	font-size: 0.92rem;
	font-weight: 700;

	overflow: hidden;
	z-index: 0;

	transition:
		transform .35s cubic-bezier(.2, .75, .25, 1),
		background-color .35s ease,
		box-shadow .35s ease,
		color .35s ease;
}

.btn::before {
	content: "";
	position: absolute;
	top: 0;
	left: -100%;
	width: 100%;
	height: 100%;
	background: linear-gradient(100deg, transparent, rgba(255, 255, 255, 0.35), transparent);
	transition: left .7s ease;
	z-index: -1;
}

.btn:hover::before { left: 100%; }

.btn-primary {
	background: var(--tomato);
	color: white;
	box-shadow: 0 9px 20px rgba(149, 57, 37, 0.18);
}

.btn-primary:hover {
	background: var(--tomato-dark);
	transform: translateY(-4px);
	box-shadow: 0 14px 26px rgba(149, 57, 37, 0.28);
}

.btn-secondary {
	border: 1px solid var(--line);
	background: transparent;
	color: var(--sage);
}

.btn-secondary:hover {
	background: #f0f2e9;
	transform: translateY(-4px);
}

.btn:active { transform: scale(0.96); }

/* RESPONSIVE */
@media (max-width: 700px) {
	.page {
		width: calc(100% - 28px);
		margin: 28px auto 44px;
	}

	.success-card {
		padding: 34px 22px;
	}

	.success-card h1 {
		font-size: 1.85rem;
	}

	.order-box {
		padding: 4px 16px;
	}

	.order-row {
		gap: 12px;
	}

	.order-value {
		max-width: 60%;
		font-size: 0.85rem;
	}

	.buttons {
		flex-direction: column;
		gap: 10px;
	}

	.btn {
		width: 100%;
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
<!-- CONFETTI LAYER -->
<div class="confetti-layer" id="confettiLayer" aria-hidden="true"></div>

<!-- HEADER -->
<jsp:include page="/include/header.jsp" />

<!-- MAIN -->
<main class="page">

	<div class="success-card">

		<!-- SUCCESS ICON -->
		<div class="success-icon">✓</div>

		<!-- HEADING -->
		<h1>Order Confirmed!</h1>

		<!-- MESSAGE -->
		<p class="success-message">
			Thank you, <strong><%= user.getUsername() %></strong>!
			<br>
			Your order has been placed successfully.
		</p>

		<!-- ORDER BOX -->
		<div class="order-box">

			<div class="order-row">
				<span class="order-label">Order ID</span>
				<span class="order-value order-id-value">
					#<%= orderId != null ? orderId : "—" %>
				</span>
			</div>

			<div class="order-row">
				<span class="order-label">Status</span>
				<span class="order-value status-badge">
					PLACED
				</span>
			</div>

			<div class="order-row">
				<span class="order-label">Delivery Address</span>
				<span class="order-value">
					<%= address != null ? address : "—" %>
				</span>
			</div>

		</div>

		<!-- BUTTONS -->
		<div class="buttons">

			<a href="orders" class="btn btn-primary">
				View Orders
			</a>

			<a href="restaurants" class="btn btn-secondary">
				Order More Food
			</a>

		</div>

	</div>

</main>

<!-- FOOTER -->
<jsp:include page="/include/footer.jsp" />

<!-- SCRIPT -->
<script>

/* =====================================================
   1. CONFETTI BURST ON PAGE LOAD
===================================================== */
(function () {

	var layer = document.getElementById("confettiLayer");

	if (!layer) return;

	var colors = [
		"#b94b33",   // tomato
		"#485c46",   // sage
		"#d7a05a",   // warm gold
		"#e8d5b7",   // sand
		"#7a9e7e",   // soft green
		"#943922"    // deep tomato
	];

	var pieceCount = 90;

	for (var i = 0; i < pieceCount; i++) {

		var piece = document.createElement("div");

		piece.className = "confetti-piece";

		/* Random horizontal position */
		piece.style.left = (Math.random() * 100) + "vw";

		/* Random color */
		piece.style.background =
			colors[Math.floor(Math.random() * colors.length)];

		/* Random size */
		var size = 6 + Math.random() * 8;
		piece.style.width = size + "px";
		piece.style.height = size + "px";

		/* Slight round corners randomly */
		if (Math.random() > 0.5) {
			piece.style.borderRadius = "50%";
		}

		/* Random fall duration */
		piece.style.animationDuration =
			(2.4 + Math.random() * 2.2) + "s";

		/* Slight random delay */
		piece.style.animationDelay =
			(Math.random() * 0.9) + "s";

		/* Slight random tilt */
		piece.style.transform = "rotate(" + (Math.random() * 360) + "deg)";

		layer.appendChild(piece);
	}

	/* Remove all confetti after animation finishes */
	setTimeout(function () {
		if (layer) layer.remove();
	}, 6500);

})();

/* =====================================================
   2. SUCCESS PAGE AUTO-DISMISS — none
   (page stays until user clicks a button)
===================================================== */

</script>

</body>

</html>