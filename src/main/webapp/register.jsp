<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Foody - Register</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Playfair+Display:ital,wght@0,500;0,600;0,700;1,500&display=swap" rel="stylesheet">

<style>
:root {
	--ink: #202821;
	--muted: #73796f;
	--paper: #f4f2ea;
	--surface: #fffefa;
	--tomato: #b94b33;
	--tomato-dark: #93351f;
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
	min-height: 100vh;
	min-height: 100svh;
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 30px;

	color: var(--ink);
	background:
		radial-gradient(ellipse at 10% 18%, rgba(190, 202, 166, 0.28), transparent 29rem),
		radial-gradient(ellipse at 93% 86%, rgba(212, 151, 112, 0.18), transparent 28rem),
		var(--paper);

	font-family: var(--sans);
	-webkit-font-smoothing: antialiased;
	animation: pageFadeIn 0.6s ease both;
}

@keyframes pageFadeIn {
	from { opacity: 0; }
	to   { opacity: 1; }
}

a { color: inherit; text-decoration: none; }

a:focus-visible, button:focus-visible, input:focus-visible, textarea:focus-visible {
	outline: 3px solid rgba(72, 92, 70, 0.55);
	outline-offset: 3px;
}

/* =========================================================
   REGISTER SHELL — SLIDE IN
========================================================= */

.register-shell {
	width: min(1020px, 100%);
	min-height: 700px;

	display: grid;
	grid-template-columns: 1.05fr 1fr;

	overflow: hidden;

	background: var(--surface);
	border: 1px solid rgba(32, 40, 33, 0.08);
	border-radius: 16px;

	box-shadow:
		0 32px 90px rgba(44, 46, 37, 0.16),
		0 3px 12px rgba(44, 46, 37, 0.06);

	animation: shellEnter 1.1s cubic-bezier(0.2, 0.75, 0.25, 1) both;
}

@keyframes shellEnter {
	from {
		opacity: 0;
		transform: translateY(44px) scale(0.96);
	}
	to {
		opacity: 1;
		transform: translateY(0) scale(1);
	}
}

/* =========================================================
   BRAND PANEL (LEFT)
========================================================= */

.brand-panel {
	position: relative;
	isolation: isolate;
	overflow: hidden;

	display: flex;
	flex-direction: column;
	justify-content: space-between;

	padding: 44px 40px;

	color: #fffdf7;
	background: #30392c;
}

/* Ken Burns image */
.brand-panel::before {
	content: "";
	position: absolute;
	z-index: -1;
	inset: 0;

	background:
		linear-gradient(180deg, rgba(24, 31, 24, 0.2) 0%, rgba(24, 31, 24, 0.76) 100%),
		linear-gradient(90deg, rgba(24, 31, 24, 0.2), transparent 90%),
		url("https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1200&q=88")
		center / cover no-repeat;

	animation: imageDrift 16s ease-in-out infinite alternate;
}

@keyframes imageDrift {
	from { transform: scale(1.04) translate3d(0, 0, 0); }
	to   { transform: scale(1.18) translate3d(-3%, 2.5%, 0); }
}

/* Brand badge */
.brand-badge {
	width: fit-content;
	padding: 9px 15px;
	border: 1px solid rgba(255, 255, 255, 0.32);
	border-radius: 5px;
	color: rgba(255, 253, 247, 0.94);
	background: rgba(24, 31, 24, 0.28);
	font-size: 0.68rem;
	font-weight: 700;
	letter-spacing: 0.14em;
	text-transform: uppercase;
	backdrop-filter: blur(8px);
	animation: contentRise 1s .25s both,
		badgePulse 2.6s ease-in-out 1.2s infinite;
}

@keyframes badgePulse {
	0%, 100% { box-shadow: 0 0 0 0 rgba(255, 255, 255, 0.15); }
	50%      { box-shadow: 0 0 0 10px rgba(255, 255, 255, 0); }
}

/* Brand text */
.brand-text {
	animation: contentRise 1s .4s both;
}

.brand-text h1 {
	font-family: var(--serif);
	font-size: clamp(2.6rem, 4vw, 3.8rem);
	font-weight: 500;
	line-height: 1.08;
	letter-spacing: -0.02em;
	margin-bottom: 16px;
}

.brand-text h1 em {
	color: #d7dfbb;
	font-style: italic;
}

.brand-text p {
	max-width: 380px;
	color: rgba(255, 253, 247, 0.86);
	font-size: 0.9rem;
	line-height: 1.75;
}

/* Benefit boxes */
.benefits {
	display: flex;
	flex-wrap: wrap;
	gap: 12px;
	animation: contentRise 1s .55s both;
}

.benefit-box {
	flex: 1 1 120px;
	padding: 15px 16px;
	border: 1px solid rgba(255, 255, 255, 0.22);
	border-radius: 8px;
	background: rgba(255, 255, 255, 0.12);
	backdrop-filter: blur(7px);
	transition:
		transform .4s cubic-bezier(.2, .75, .25, 1),
		background-color .35s ease,
		border-color .35s ease;
}

.benefit-box:hover {
	transform: translateY(-6px);
	background: rgba(255, 255, 255, 0.18);
	border-color: rgba(255, 255, 255, 0.4);
}

.benefit-box strong {
	display: block;
	margin-bottom: 5px;
	font-family: var(--serif);
	font-size: 1.4rem;
	font-weight: 600;
}

.benefit-box span {
	color: rgba(255, 253, 247, 0.78);
	font-size: 0.74rem;
	letter-spacing: 0.02em;
}

@keyframes contentRise {
	from { opacity: 0; transform: translateY(36px); }
	to   { opacity: 1; transform: translateY(0); }
}

/* =========================================================
   FORM PANEL (RIGHT)
========================================================= */

.form-panel {
	display: flex;
	align-items: center;
	justify-content: center;

	padding: 42px 44px;
	background:
		radial-gradient(ellipse at 100% 0%, rgba(215, 223, 187, 0.20), transparent 22rem),
		var(--surface);
}

.form-box {
	width: 100%;
	max-width: 460px;
	animation: contentRise 1s .3s both;
}

.form-topline {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 26px;
}

.logo {
	color: var(--tomato);
	font-family: var(--serif);
	font-size: 1.75rem;
	font-weight: 600;
	letter-spacing: -0.02em;
	transition: transform .4s cubic-bezier(.2, .75, .25, 1);
}

.logo:hover {
	transform: scale(1.06) rotate(-3deg);
}

.mini-tag {
	padding: 7px 11px;
	border: 1px solid #e4e8da;
	border-radius: 5px;
	color: var(--sage);
	background: #f1f3eb;
	font-size: 0.65rem;
	font-weight: 700;
	letter-spacing: 0.05em;
	text-transform: uppercase;
}

.form-heading {
	margin-bottom: 26px;
}

.form-heading h2 {
	margin: 0;
	font-family: var(--serif);
	font-size: clamp(2.15rem, 3.5vw, 2.7rem);
	font-weight: 500;
	line-height: 1.1;
	color: var(--ink);
}

.subtitle {
	margin: 10px 0 0;
	color: var(--muted);
	font-size: 0.88rem;
	line-height: 1.6;
}

/* Form grid */
form {
	display: grid;
	grid-template-columns: repeat(2, minmax(0, 1fr));
	gap: 18px;
}

.full-width {
	grid-column: 1 / -1;
}

.input-group {
	display: flex;
	flex-direction: column;
	gap: 8px;
	opacity: 0;
	animation: inputSlideIn 0.7s cubic-bezier(.2, .75, .25, 1) both;
}

.input-group:nth-of-type(1) { animation-delay: 0.5s; }
.input-group:nth-of-type(2) { animation-delay: 0.6s; }
.input-group:nth-of-type(3) { animation-delay: 0.7s; }
.input-group:nth-of-type(4) { animation-delay: 0.8s; }
.input-group:nth-of-type(5) { animation-delay: 0.9s; }
.input-group:nth-of-type(6) { animation-delay: 1.0s; }

@keyframes inputSlideIn {
	from { opacity: 0; transform: translateY(22px); }
	to   { opacity: 1; transform: translateY(0); }
}

.input-group label {
	color: #343b33;
	font-size: 0.8rem;
	font-weight: 700;
}

.input-group input,
.input-group textarea {
	width: 100%;
	padding: 0 15px;
	border: 1px solid #deddd4;
	border-radius: 7px;
	outline: none;
	color: var(--ink);
	background: rgba(255, 255, 255, 0.82);
	font-family: var(--sans);
	font-size: 0.9rem;
	transition:
		border-color .35s ease,
		box-shadow .35s ease,
		background-color .35s ease,
		transform .35s ease;
}

.input-group input {
	height: 50px;
}

.input-group textarea {
	min-height: 80px;
	padding-top: 14px;
	padding-bottom: 14px;
	resize: vertical;
	line-height: 1.5;
}

.input-group input::placeholder,
.input-group textarea::placeholder {
	color: #a0a197;
}

.input-group input:hover,
.input-group textarea:hover {
	border-color: #bfc3b3;
}

.input-group input:focus,
.input-group textarea:focus {
	border-color: #879174;
	background: #fff;
	box-shadow: 0 0 0 4px rgba(72, 92, 70, 0.12);
	transform: translateY(-2px);
}

/* Register button */
.register-btn {
	grid-column: 1 / -1;
	position: relative;
	width: 100%;
	min-height: 54px;
	overflow: hidden;

	border: none;
	border-radius: 7px;
	background: var(--tomato);
	color: white;

	font-family: var(--sans);
	font-size: 0.94rem;
	font-weight: 700;

	cursor: pointer;
	box-shadow: 0 9px 20px rgba(149, 57, 37, 0.16);

	opacity: 0;
	animation: inputSlideIn 0.7s 1.1s cubic-bezier(.2, .75, .25, 1) both;

	transition:
		background-color .35s ease,
		transform .35s cubic-bezier(.2, .75, .25, 1),
		box-shadow .35s ease;
}

.register-btn::before {
	content: "";
	position: absolute;
	inset: 0;
	background: linear-gradient(110deg, transparent 25%, rgba(255, 255, 255, 0.22) 48%, transparent 70%);
	transform: translateX(-110%);
	transition: transform .85s cubic-bezier(.2, .65, .3, 1);
}

.register-btn:hover {
	transform: translateY(-4px);
	background: var(--tomato-dark);
	box-shadow: 0 14px 26px rgba(149, 57, 37, 0.22);
}

.register-btn:hover::before {
	transform: translateX(110%);
}

.register-btn:active {
	transform: translateY(1px) scale(0.97);
}

/* Login link */
.login-text {
	grid-column: 1 / -1;
	margin-top: 6px;
	color: var(--muted);
	font-size: 0.84rem;
	text-align: center;
	opacity: 0;
	animation: inputSlideIn 0.7s 1.2s cubic-bezier(.2, .75, .25, 1) both;
}

.login-text a {
	color: var(--tomato-dark);
	font-weight: 700;
	text-underline-offset: 4px;
	transition: color .35s ease;
}

.login-text a:hover {
	color: var(--tomato);
	text-decoration: underline;
}

/* =========================================================
   RESPONSIVE
========================================================= */

@media (max-width: 860px) {
	body {
		padding: 18px;
	}

	.register-shell {
		grid-template-columns: 1fr;
		min-height: 0;
	}

	.brand-panel {
		min-height: 320px;
		padding: 34px 30px;
	}

	.brand-text h1 {
		font-size: clamp(2.3rem, 7vw, 3rem);
	}

	.form-panel {
		padding: 34px clamp(24px, 6vw, 44px) 38px;
	}

	form {
		grid-template-columns: 1fr;
	}

	.full-width {
		grid-column: 1 / -1;
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
<!-- REGISTER SHELL -->
<div class="register-shell">

	<!-- ================================
	     BRAND PANEL (LEFT)
	================================ -->
	<div class="brand-panel">

		<div class="brand-badge">Join Foody</div>

		<div class="brand-text">
			<h1>
				Fresh flavors,<br>
				<em>happy moments</em>
			</h1>
			<p>
				Create an account and enjoy exclusive offers,
				fast delivery, and your favorite meals from the
				best local restaurants.
			</p>
		</div>

		<div class="benefits">
			<div class="benefit-box">
				<strong>15%</strong>
				<span>Welcome offer</span>
			</div>
			<div class="benefit-box">
				<strong>30 min</strong>
				<span>Fast delivery</span>
			</div>
		</div>

	</div>

	<!-- ================================
	     FORM PANEL (RIGHT)
	================================ -->
	<div class="form-panel">

		<div class="form-box">

			<div class="form-topline">
				<a href="home" class="logo">Foody</a>
				<div class="mini-tag">New account</div>
			</div>

			<div class="form-heading">
				<h2>Register</h2>
				<p class="subtitle">
					Create your account and start ordering now
				</p>
			</div>

			<!-- REGISTER FORM -->
			<form action="register" method="post">

				<div class="input-group">
					<label for="username">Full Name</label>
					<input
						id="username"
						type="text"
						name="username"
						placeholder="Enter your name"
						required>
				</div>

				<div class="input-group">
					<label for="phone">Phone</label>
					<input
						id="phone"
						type="text"
						name="phone"
						placeholder="Enter your phone number">
				</div>

				<div class="input-group full-width">
					<label for="email">Email</label>
					<input
						id="email"
						type="email"
						name="email"
						placeholder="Enter your email"
						required>
				</div>

				<div class="input-group">
					<label for="password">Password</label>
					<input
						id="password"
						type="password"
						name="password"
						placeholder="Create password"
						required>
				</div>

				<div class="input-group">
					<label for="confirmPassword">Confirm Password</label>
					<input
						id="confirmPassword"
						type="password"
						name="confirmPassword"
						placeholder="Confirm password"
						required>
				</div>

				<div class="input-group full-width">
					<label for="address">Address</label>
					<textarea
						id="address"
						name="address"
						placeholder="Your delivery address"></textarea>
				</div>

				<button type="submit" class="register-btn">
					Create Account
				</button>

				<p class="login-text">
					Already have an account?
					<a href="login.jsp">Login</a>
				</p>

			</form>

		</div>

	</div>

</div>

<!-- SCRIPT -->
<script>

/* =====================================================
   1. INPUT STATE TRACKING
===================================================== */
document.addEventListener("DOMContentLoaded", function () {

	/* Add .has-value class so we can style filled inputs */
	var inputs = document.querySelectorAll(".input-group input, .input-group textarea");

	inputs.forEach(function (input) {

		/* Check on page load */
		if (input.value.length > 0) {
			input.classList.add("has-value");
		}

		input.addEventListener("input", function () {
			if (input.value.length > 0) {
				input.classList.add("has-value");
			} else {
				input.classList.remove("has-value");
			}
		});
	});

});

/* =====================================================
   2. PASSWORD MATCH PRE-VALIDATION
===================================================== */
document.addEventListener("DOMContentLoaded", function () {

	var form = document.querySelector("form");

	if (!form) return;

	var password = document.getElementById("password");
	var confirm = document.getElementById("confirmPassword");

	if (!password || !confirm) return;

	form.addEventListener("submit", function (e) {

		if (password.value !== confirm.value) {

			e.preventDefault();

			confirm.style.borderColor = "#c94a3d";
			confirm.style.boxShadow = "0 0 0 4px rgba(201, 74, 61, 0.14)";

			confirm.animate(
				[
					{ transform: "translateX(0)" },
					{ transform: "translateX(-6px)" },
					{ transform: "translateX(6px)" },
					{ transform: "translateX(-4px)" },
					{ transform: "translateX(4px)" },
					{ transform: "translateX(0)" }
				],
				{ duration: 500, easing: "ease-in-out" }
			);

			confirm.focus();
		}
	});

	/* Clear error state when user types */
	confirm.addEventListener("input", function () {
		confirm.style.borderColor = "";
		confirm.style.boxShadow = "";
	});
});

</script>

</body>

</html>