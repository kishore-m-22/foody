<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String checkoutMessage =
            (String) session.getAttribute("checkoutMessage");

    String error =
            request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="theme-color" content="#f4f1e9">
<title>Sign in | Foody</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Playfair+Display:ital,wght@0,500;0,600;0,700;1,500;1,600&display=swap" rel="stylesheet">

<style>
:root {
	color-scheme: light;
	--ink: #202821;
	--muted: #73796f;
	--paper: #fbfaf6;
	--surface: #fffefa;
	--tomato: #bd492f;
	--tomato-dark: #93351f;
	--sage: #485c46;
	--line: #e7e4da;
	--serif: "Playfair Display", Georgia, serif;
	--sans: "DM Sans", "Segoe UI", sans-serif;
}

*, *::before, *::after {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

body {
	min-width: 320px;
	min-height: 100vh;
	min-height: 100svh;
	margin: 0;
	display: grid;
	place-items: center;
	padding: 32px;

	color: var(--ink);
	background:
		radial-gradient(ellipse at 12% 18%, rgba(188, 198, 157, 0.34), transparent 28rem),
		radial-gradient(ellipse at 92% 84%, rgba(212, 151, 112, 0.22), transparent 30rem),
		#f4f1e9;

	font-family: var(--sans);
	-webkit-font-smoothing: antialiased;
}

a {
	color: inherit;
	text-decoration: none;
}

a:focus-visible,
button:focus-visible,
input:focus-visible {
	outline: 3px solid rgba(72, 92, 70, 0.55);
	outline-offset: 3px;
}

/* =========================================================
   MAIN SHELL — SLIDE IN
========================================================= */

.login-shell {
	width: min(1160px, 100%);
	min-height: min(720px, calc(100svh - 64px));
	display: grid;
	grid-template-columns: 1.02fr 0.98fr;
	overflow: hidden;

	border: 1px solid rgba(32, 40, 33, 0.09);
	border-radius: 18px;
	background: var(--paper);

	box-shadow:
		0 32px 90px rgba(44, 46, 37, 0.16),
		0 3px 12px rgba(44, 46, 37, 0.06);

	animation: shellEnter 1.2s cubic-bezier(0.2, 0.75, 0.25, 1) both;
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
   BRAND PANEL (left)
========================================================= */

.brand-panel {
	position: relative;
	isolation: isolate;
	min-height: 660px;
	display: flex;
	flex-direction: column;
	justify-content: space-between;
	overflow: hidden;
	padding: clamp(30px, 4vw, 54px);

	color: #fffdf7;
	background: #30392c;
}

.brand-panel::before,
.brand-panel::after {
	position: absolute;
	z-index: -1;
	inset: 0;
	content: "";
}

/* Ken Burns background */
.brand-panel::before {
	background:
		linear-gradient(180deg, rgba(24, 31, 24, 0.28) 0%, rgba(24, 31, 24, 0.06) 34%, rgba(24, 31, 24, 0.82) 100%),
		linear-gradient(90deg, rgba(24, 31, 24, 0.18), transparent 80%),
		url("https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=1500&q=88")
		center / cover no-repeat;
	transform: scale(1.04);
	animation: imageDrift 16s ease-in-out infinite alternate;
}

@keyframes imageDrift {
	from { transform: scale(1.04) translate3d(0, 0, 0); }
	to   { transform: scale(1.18) translate3d(-3%, 2.5%, 0); }
}

/* Orbit ring */
.brand-panel::after {
	inset: auto -120px -190px auto;
	width: 430px;
	height: 430px;
	border: 1px solid rgba(255, 250, 232, 0.32);
	border-radius: 50%;
	box-shadow:
		0 0 0 28px rgba(255, 250, 232, 0.04),
		0 0 0 58px rgba(255, 250, 232, 0.035);
	animation: orbitBreathe 5.5s ease-in-out infinite;
}

@keyframes orbitBreathe {
	0%, 100% { transform: scale(0.9); opacity: 0.55; }
	50%      { transform: scale(1.08); opacity: 1; }
}

/* Staggered top / text / footer */
.brand-top,
.brand-text,
.brand-footer {
	animation: contentRise 1s both;
}

.brand-top { animation-delay: 0.26s; }
.brand-text { animation-delay: 0.4s; }
.brand-footer { animation-delay: 0.56s; }

@keyframes contentRise {
	from { opacity: 0; transform: translateY(36px); }
	to   { opacity: 1; transform: translateY(0); }
}

.brand-top {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 18px;
}

.brand-badge {
	width: fit-content;
	padding: 9px 13px;
	border: 1px solid rgba(255, 255, 255, 0.32);
	border-radius: 6px;
	color: rgba(255, 253, 247, 0.92);
	background: rgba(24, 31, 24, 0.28);
	font-size: 0.68rem;
	font-weight: 700;
	letter-spacing: 0.14em;
	text-transform: uppercase;
	backdrop-filter: blur(8px);
	animation: badgePulse 2.6s ease-in-out infinite;
}

@keyframes badgePulse {
	0%, 100% { box-shadow: 0 0 0 0 rgba(255, 255, 255, 0.15); }
	50%      { box-shadow: 0 0 0 10px rgba(255, 255, 255, 0); }
}

.brand-text h1 {
	margin: 0;
	font-family: var(--serif);
	font-size: clamp(3.2rem, 5.5vw, 5rem);
	font-weight: 500;
	line-height: 1.03;
	letter-spacing: -0.02em;
}

.brand-text h1 em {
	color: #d7dfbb;
	font-style: italic;
}

.brand-text p {
	max-width: 370px;
	margin-top: 20px;
	color: rgba(255, 253, 247, 0.84);
	font-size: 0.93rem;
	line-height: 1.75;
}

.brand-footer {
	display: flex;
	align-items: end;
	justify-content: space-between;
	gap: 22px;
	padding-top: 20px;
	border-top: 1px solid rgba(255, 255, 255, 0.27);
}

.brand-footer p {
	max-width: 250px;
	color: rgba(255, 253, 247, 0.76);
	font-size: 0.77rem;
	line-height: 1.6;
}

.edition-mark {
	color: rgba(255, 253, 247, 0.7);
	font-family: var(--serif);
	font-size: 0.9rem;
	font-style: italic;
	white-space: nowrap;
}

/* =========================================================
   FORM PANEL (right)
========================================================= */

.form-panel {
	display: flex;
	align-items: center;
	justify-content: center;
	padding: clamp(34px, 6vw, 76px);
	background:
		radial-gradient(ellipse at 100% 0%, rgba(215, 223, 187, 0.22), transparent 22rem),
		var(--paper);
}

.form-box {
	width: min(100%, 390px);
	animation: contentRise 1.05s 0.32s both;
}

.form-topline {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: clamp(46px, 7vh, 76px);
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
	border-radius: 6px;
	color: var(--sage);
	background: #f1f3eb;
	font-size: 0.65rem;
	font-weight: 700;
	letter-spacing: 0.05em;
	text-transform: uppercase;
}

.form-heading {
	margin-bottom: 30px;
}

.form-heading h2 {
	margin: 0;
	font-family: var(--serif);
	font-size: clamp(2.3rem, 4vw, 2.9rem);
	font-weight: 500;
	line-height: 1.1;
	color: var(--ink);
}

.subtitle {
	margin: 12px 0 0;
	color: var(--muted);
	font-size: 0.9rem;
	line-height: 1.6;
}

/* Notices */
.notice {
	margin: 0 0 20px;
	padding: 13px 15px;
	border: 1px solid;
	border-radius: 8px;
	font-size: 0.85rem;
	line-height: 1.55;
	animation: contentRise 0.9s ease-out both;
}

.checkout-message {
	border-color: #d9dfc9;
	color: #47533b;
	background: #f0f3e9;
}

.error-message {
	border-color: #edc6b9;
	color: #913a28;
	background: #fff0e9;
	animation: contentRise 0.9s ease-out both, shake 0.55s ease-in-out;
}

@keyframes shake {
	0%, 100% { transform: translateX(0); }
	20%      { transform: translateX(-8px); }
	40%      { transform: translateX(8px); }
	60%      { transform: translateX(-6px); }
	80%      { transform: translateX(6px); }
}

/* Form */
form {
	display: grid;
	gap: 20px;
}

.input-group {
	display: grid;
	gap: 9px;
	opacity: 0;
	animation: inputSlideIn 0.7s cubic-bezier(.2, .75, .25, 1) both;
}

.input-group:nth-of-type(1) { animation-delay: 0.55s; }
.input-group:nth-of-type(2) { animation-delay: 0.68s; }

@keyframes inputSlideIn {
	from { opacity: 0; transform: translateY(22px); }
	to   { opacity: 1; transform: translateY(0); }
}

.input-group label {
	color: #343b33;
	font-size: 0.79rem;
	font-weight: 700;
}

.input-group input {
	width: 100%;
	height: 54px;
	padding: 0 16px;
	border: 1px solid #deddd4;
	border-radius: 7px;
	outline: none;
	color: var(--ink);
	background: rgba(255, 255, 255, 0.78);
	font-family: var(--sans);
	font-size: 0.91rem;
	transition:
		border-color .35s ease,
		box-shadow .35s ease,
		background-color .35s ease,
		transform .35s ease;
}

.input-group input::placeholder {
	color: #a0a197;
}

.input-group input:hover {
	border-color: #bfc3b3;
}

.input-group input:focus {
	border-color: #858f6c;
	background: #fff;
	box-shadow: 0 0 0 4px rgba(133, 143, 108, 0.16);
	transform: translateY(-2px);
}

/* Remember / forgot row */
.form-row {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 12px;
	margin-top: -3px;
	opacity: 0;
	animation: inputSlideIn 0.7s .8s cubic-bezier(.2, .75, .25, 1) both;
}

.remember-label {
	display: inline-flex;
	align-items: center;
	gap: 9px;
	color: var(--muted);
	font-size: 0.78rem;
	cursor: pointer;
}

.remember-label input {
	width: 15px;
	height: 15px;
	margin: 0;
	accent-color: var(--tomato);
	cursor: pointer;
	transition: box-shadow .35s ease;
}

.remember-label input:checked {
	box-shadow: 0 0 0 4px rgba(189, 73, 47, 0.12);
}

.forgot-link {
	color: var(--tomato-dark);
	font-size: 0.78rem;
	font-weight: 700;
	position: relative;
	transition: color .35s ease;
}

.forgot-link::after {
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

.forgot-link:hover::after {
	transform: scaleX(1);
	transform-origin: left;
}

.forgot-link:hover {
	color: var(--tomato);
}

/* Login button */
.login-btn {
	position: relative;
	min-height: 56px;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 12px;
	overflow: hidden;
	margin-top: 5px;
	padding: 0 20px;
	border: 0;
	border-radius: 7px;
	color: #fffdf8;
	background: var(--tomato);
	box-shadow: 0 9px 20px rgba(149, 57, 37, 0.15);
	cursor: pointer;
	font-family: var(--sans);
	font-size: 0.92rem;
	font-weight: 700;
	opacity: 0;
	animation: inputSlideIn 0.7s .92s cubic-bezier(.2, .75, .25, 1) both;
	transition:
		background-color .35s ease,
		box-shadow .35s ease,
		transform .35s cubic-bezier(.2, .75, .25, 1);
}

.login-btn::before {
	position: absolute;
	inset: 0;
	background: linear-gradient(110deg, transparent 25%, rgba(255, 255, 255, 0.22) 48%, transparent 70%);
	content: "";
	transform: translateX(-110%);
	transition: transform .85s cubic-bezier(.2, .65, .3, 1);
}

.login-btn:hover {
	transform: translateY(-5px);
	background: var(--tomato-dark);
	box-shadow: 0 14px 26px rgba(149, 57, 37, 0.24);
}

.login-btn:hover::before {
	transform: translateX(110%);
}

.login-btn:active {
	transform: translateY(1px) scale(0.97);
}

.button-arrow {
	width: 8px;
	height: 8px;
	border-top: 1.5px solid currentColor;
	border-right: 1.5px solid currentColor;
	transform: rotate(45deg);
	transition: transform .4s ease;
}

.login-btn:hover .button-arrow {
	transform: translateX(3px) rotate(45deg);
}

/* Divider + socials */
.divider {
	display: flex;
	align-items: center;
	gap: 13px;
	margin: 22px 0 13px;
	color: #999b91;
	font-size: 0.64rem;
	letter-spacing: 0.13em;
	text-transform: uppercase;
	opacity: 0;
	animation: inputSlideIn 0.7s 1.02s cubic-bezier(.2, .75, .25, 1) both;
}

.divider::before,
.divider::after {
	height: 1px;
	flex: 1;
	background: var(--line);
	content: "";
}

.socials {
	display: grid;
	grid-template-columns: repeat(2, minmax(0, 1fr));
	gap: 11px;
	opacity: 0;
	animation: inputSlideIn 0.7s 1.12s cubic-bezier(.2, .75, .25, 1) both;
}

.social-btn {
	min-height: 45px;
	border: 1px solid var(--line);
	border-radius: 7px;
	color: var(--ink);
	background: rgba(255, 255, 255, 0.72);
	cursor: pointer;
	font-family: var(--sans);
	font-size: 0.82rem;
	font-weight: 600;
	transition:
		border-color .35s ease,
		background-color .35s ease,
		transform .35s cubic-bezier(.2, .75, .25, 1),
		box-shadow .35s ease;
}

.social-btn:hover {
	transform: translateY(-4px);
	border-color: #c4c8b8;
	background: #fff;
	box-shadow: 0 10px 20px rgba(32, 40, 33, 0.08);
}

.social-btn:active {
	transform: scale(0.95);
}

/* Register link */
.register-text {
	margin: 26px 0 0;
	color: var(--muted);
	font-size: 0.83rem;
	line-height: 1.6;
	text-align: center;
	opacity: 0;
	animation: inputSlideIn 0.7s 1.22s cubic-bezier(.2, .75, .25, 1) both;
}

.register-text a {
	margin-left: 4px;
	color: var(--tomato-dark);
	font-weight: 700;
	position: relative;
	transition: color .35s ease;
}

.register-text a:hover {
	color: var(--tomato);
	text-decoration: underline;
	text-underline-offset: 4px;
}

/* =========================================================
   RESPONSIVE
========================================================= */

@media (max-width: 900px) {
	body { padding: 22px; }

	.login-shell {
		min-height: calc(100svh - 44px);
		grid-template-columns: 0.9fr 1.1fr;
	}

	.brand-panel {
		min-height: 620px;
		padding: 32px;
	}

	.brand-text h1 {
		font-size: clamp(3rem, 6vw, 4.4rem);
	}

	.form-panel {
		padding: 40px clamp(28px, 5vw, 56px);
	}
}

@media (max-width: 700px) {
	body {
		display: block;
		padding: 14px;
	}

	.login-shell {
		width: min(520px, 100%);
		min-height: 0;
		margin: 0 auto;
		grid-template-columns: 1fr;
		border-radius: 13px;
	}

	.brand-panel {
		min-height: 320px;
		padding: 25px 26px 23px;
	}

	.brand-text h1 {
		max-width: 390px;
		font-size: clamp(2.8rem, 10vw, 4.2rem);
	}

	.brand-text p {
		max-width: 320px;
		margin-top: 15px;
		font-size: 0.86rem;
		line-height: 1.6;
	}

	.brand-footer {
		padding-top: 13px;
	}

	.form-panel {
		padding: 34px clamp(24px, 8vw, 44px) 38px;
	}

	.form-topline {
		margin-bottom: 30px;
	}

	.register-text {
		margin-top: 24px;
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

<!-- LOGIN SHELL -->
<main class="login-shell">

	<!-- ================================
	     BRAND PANEL (LEFT)
	================================ -->
	<section class="brand-panel" aria-label="Foody introduction">

		<div class="brand-top">
			<div class="brand-badge">Fresh &amp; Fast</div>
		</div>

		<div class="brand-text">
			<h1>
				Good food<br>
				<em>delivered daily</em>
			</h1>
			<p>
				Enjoy delicious meals from your favorite restaurants.
				Freshly cooked, quickly delivered, and always satisfying.
			</p>
		</div>

		<div class="brand-footer">
			<p>
				Trusted by thousands of food lovers across the city.
			</p>
			<span class="edition-mark">Est. 2026</span>
		</div>

	</section>

	<!-- ================================
	     FORM PANEL (RIGHT)
	================================ -->
	<section class="form-panel" aria-labelledby="login-title">

		<div class="form-box">

			<div class="form-topline">
				<a href="home" class="logo">Foody</a>
				<div class="mini-tag">Welcome back</div>
			</div>

			<div class="form-heading">
				<h2 id="login-title">Login</h2>
				<p class="subtitle">
					Sign in to continue your food journey
				</p>
			</div>

			<!-- NOTICES -->
			<%
				if (checkoutMessage != null) {
			%>

			<div class="notice checkout-message" role="status">
				<%= checkoutMessage %>
			</div>

			<%
				}
			%>

			<%
				if ("invalid".equals(error)) {
			%>

			<div class="notice error-message" role="alert">
				Invalid email or password.
			</div>

			<%
				}
			%>

			<!-- LOGIN FORM -->
			<form action="login" method="post">

				<div class="input-group">
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
						placeholder="Enter your password"
						required>
				</div>

				<div class="form-row">
					<label class="remember-label">
						<input type="checkbox" name="remember">
						<span>Remember me</span>
					</label>
					<a class="forgot-link" href="#">Forgot password?</a>
				</div>

				<button type="submit" class="login-btn">
					<span>Login</span>
					<span class="button-arrow" aria-hidden="true"></span>
				</button>

			</form>

			<!-- DIVIDER -->
			<div class="divider">or continue with</div>

			<!-- SOCIALS -->
			<div class="socials">
				<button type="button" class="social-btn">Google</button>
				<button type="button" class="social-btn">Apple</button>
			</div>

			<!-- REGISTER -->
			<p class="register-text">
				Don't have an account?
				<a href="register.jsp">Register</a>
			</p>

		</div>

	</section>

</main>

<!-- SCRIPT -->
<script>

/* =====================================================
   1. INPUT FOCUS ANIMATIONS (fallback for older browsers)
===================================================== */
document.addEventListener("DOMContentLoaded", function () {

	/* Add a subtle "focused" class on labels when the input
	   has content, so labels can visually stay highlighted. */
	var inputs = document.querySelectorAll(".input-group input");

	inputs.forEach(function (input) {
		input.addEventListener("input", function () {
			if (input.value.length > 0) {
				input.classList.add("has-value");
			} else {
				input.classList.remove("has-value");
			}
		});
	});

	/* If there's an error message, shake the form once */
	var err = document.querySelector(".error-message");

	if (err) {
		var form = document.querySelector("form");
		if (form) {
			form.animate(
				[
					{ transform: "translateX(0)" },
					{ transform: "translateX(-8px)" },
					{ transform: "translateX(8px)" },
					{ transform: "translateX(-5px)" },
					{ transform: "translateX(5px)" },
					{ transform: "translateX(0)" }
				],
				{ duration: 500, easing: "ease-in-out" }
			);
		}
	}

});

</script>

</body>

</html>