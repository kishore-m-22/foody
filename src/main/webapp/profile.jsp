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

    String profileMessage = (String) session.getAttribute("profileMessage");
    String profileError = (String) session.getAttribute("profileError");

    session.removeAttribute("profileMessage");
    session.removeAttribute("profileError");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Profile - Foody</title>

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

/* PAGE */
.profile-page {
	position: relative;
	z-index: 1;
	width: min(850px, calc(100% - 64px));
	margin: 48px auto 72px;
}

/* HEADING */
.profile-heading {
	margin-bottom: 28px;
	padding-bottom: 22px;
	border-bottom: 1px solid var(--line);
	position: relative;
	opacity: 0;
	animation: titleFadeIn 1s .1s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes titleFadeIn {
	from { opacity: 0; transform: translateY(30px); }
	to   { opacity: 1; transform: translateY(0); }
}

.profile-heading::after {
	content: "";
	position: absolute;
	left: 0;
	bottom: -1px;
	height: 2px;
	width: 0;
	background: linear-gradient(90deg, var(--tomato), transparent);
	animation: headerLineGrow 1.6s .4s cubic-bezier(.2, .75, .25, 1) forwards;
}

@keyframes headerLineGrow {
	to { width: 100%; }
}

.profile-heading h1 {
	margin-bottom: 8px;
	color: var(--ink);
	font: 500 clamp(2.2rem, 5vw, 3rem) / 1.1 var(--serif);
	display: inline-block;
}

.profile-heading p {
	color: var(--muted);
	font-size: 0.92rem;
	line-height: 1.55;
	animation: subtitleSlide 1.2s .5s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes subtitleSlide {
	from { opacity: 0; transform: translateX(-20px); }
	to   { opacity: 1; transform: translateX(0); }
}

/* PROFILE CARD */
.profile-card {
	background: var(--surface);
	border: 1px solid rgba(32, 40, 33, 0.07);
	border-radius: 14px;
	padding: 38px;
	box-shadow: 0 7px 22px rgba(32, 40, 33, 0.055);
	animation: cardRise 1s .25s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes cardRise {
	from { opacity: 0; transform: translateY(40px) scale(.98); }
	to   { opacity: 1; transform: translateY(0) scale(1); }
}

/* PROFILE INTRO */
.profile-intro {
	display: flex;
	align-items: center;
	gap: 18px;
	padding-bottom: 30px;
	margin-bottom: 30px;
	border-bottom: 1px solid #eee8e1;
	opacity: 0;
	animation: introSlide 1s .4s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes introSlide {
	from { opacity: 0; transform: translateY(20px); }
	to   { opacity: 1; transform: translateY(0); }
}

.profile-avatar {
	width: 72px;
	height: 72px;
	border-radius: 50%;
	background: linear-gradient(135deg, #f1dfd8, #e8cfc4);
	color: var(--tomato);
	display: flex;
	align-items: center;
	justify-content: center;
	font-family: var(--serif);
	font-size: 1.7rem;
	font-weight: 700;
	flex-shrink: 0;
	box-shadow: 0 4px 14px rgba(185, 75, 51, 0.15);
	animation:
		avatarZoom 1s .55s cubic-bezier(.2, 1.3, .4, 1) both,
		avatarPulse 3s ease-in-out 1.6s infinite;
}

@keyframes avatarZoom {
	from { opacity: 0; transform: scale(.4) rotate(-20deg); }
	to   { opacity: 1; transform: scale(1) rotate(0); }
}

@keyframes avatarPulse {
	0%, 100% { box-shadow: 0 4px 14px rgba(185, 75, 51, 0.15), 0 0 0 0 rgba(185, 75, 51, 0.15); }
	50%      { box-shadow: 0 4px 14px rgba(185, 75, 51, 0.25), 0 0 0 10px rgba(185, 75, 51, 0); }
}

.profile-intro-text h2 {
	font-size: 1.35rem;
	font-weight: 700;
	margin-bottom: 4px;
	color: var(--ink);
	font-family: var(--serif);
}

.profile-intro-text p {
	color: var(--muted);
	font-size: 0.9rem;
}

/* MESSAGES */
.message {
	padding: 13px 16px;
	border-radius: 9px;
	margin-bottom: 22px;
	font-size: 0.88rem;
	line-height: 1.5;
	opacity: 0;
	animation: messageSlide 0.7s .6s cubic-bezier(.2, .75, .25, 1) both;
}

@keyframes messageSlide {
	from { opacity: 0; transform: translateY(-10px); }
	to   { opacity: 1; transform: translateY(0); }
}

.success-message {
	background: #edf7ef;
	color: #31713a;
	border: 1px solid #cde8d1;
}

.error-message {
	background: #fff0ed;
	color: #a43d2b;
	border: 1px solid #f0c9c0;
	animation:
		messageSlide 0.7s .6s cubic-bezier(.2, .75, .25, 1) both,
		shake 0.55s ease-in-out;
}

@keyframes shake {
	0%, 100% { transform: translateX(0); }
	20%      { transform: translateX(-8px); }
	40%      { transform: translateX(8px); }
	60%      { transform: translateX(-6px); }
	80%      { transform: translateX(6px); }
}

/* FORM */
.profile-form {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 24px 22px;
}

.form-group {
	display: flex;
	flex-direction: column;
	opacity: 0;
	animation: fieldSlide 0.8s cubic-bezier(.2, .75, .25, 1) both;
}

.form-group:nth-of-type(1) { animation-delay: 0.7s; }
.form-group:nth-of-type(2) { animation-delay: 0.8s; }
.form-group:nth-of-type(3) { animation-delay: 0.9s; }
.form-group:nth-of-type(4) { animation-delay: 1.0s; }

@keyframes fieldSlide {
	from { opacity: 0; transform: translateY(22px); }
	to   { opacity: 1; transform: translateY(0); }
}

.form-group.full-width {
	grid-column: span 2;
}

.form-group label {
	font-size: 0.85rem;
	font-weight: 700;
	color: #3b3b3b;
	margin-bottom: 8px;
}

.form-group input {
	width: 100%;
	height: 50px;
	padding: 0 15px;
	border: 1px solid #ddd6ce;
	border-radius: 9px;
	background: #fff;
	color: var(--ink);
	font-family: var(--sans);
	font-size: 0.92rem;
	outline: none;
	transition:
		border-color .35s ease,
		box-shadow .35s ease,
		background-color .35s ease,
		transform .35s ease;
}

.form-group input::placeholder {
	color: #aaa;
}

.form-group input:hover {
	border-color: #c4beb4;
}

.form-group input:focus {
	border-color: var(--tomato);
	background: #fff;
	box-shadow: 0 0 0 4px rgba(185, 75, 51, 0.09);
	transform: translateY(-2px);
}

/* ACTIONS */
.profile-actions {
	grid-column: span 2;
	display: flex;
	justify-content: center;
	align-items: center;
	gap: 12px;
	margin-top: 34px;
	padding-top: 28px;
	border-top: 1px solid #eee8e1;
	opacity: 0;
	animation: fieldSlide 0.8s 1.1s cubic-bezier(.2, .75, .25, 1) both;
}

.return-button,
.save-button {
	position: relative;
	height: 46px;
	padding: 0 26px;

	border-radius: 8px;

	font-family: var(--sans);
	font-size: 0.9rem;
	font-weight: 700;

	cursor: pointer;

	display: inline-flex;
	align-items: center;
	justify-content: center;

	overflow: hidden;
	z-index: 0;

	transition:
		transform .35s cubic-bezier(.2, .75, .25, 1),
		background-color .35s ease,
		color .35s ease,
		box-shadow .35s ease,
		border-color .35s ease;
}

.return-button::before,
.save-button::before {
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

.return-button:hover::before,
.save-button:hover::before {
	left: 100%;
}

.return-button {
	background: #fff;
	color: #555;
	border: 1px solid #ddd6ce;
}

.return-button:hover {
	background: #f7f4f0;
	border-color: #cfc7bd;
	transform: translateY(-3px);
}

.save-button {
	background: var(--tomato);
	color: white;
	border: 1px solid var(--tomato);
	box-shadow: 0 6px 16px rgba(185, 75, 51, 0.18);
}

.save-button:hover {
	background: var(--tomato-dark);
	border-color: var(--tomato-dark);
	transform: translateY(-4px);
	box-shadow: 0 12px 24px rgba(185, 75, 51, 0.3);
}

.save-button:active,
.return-button:active {
	transform: scale(0.96);
}

/* DANGER ZONE */
.danger-zone {
	margin-top: 35px;
	padding-top: 30px;
	border-top: 1px solid #eee8e1;
	opacity: 0;
	animation: fieldSlide 0.8s 1.2s cubic-bezier(.2, .75, .25, 1) both;
}

.danger-zone h3 {
	font-size: 1rem;
	font-weight: 700;
	color: #a52f24;
	margin-bottom: 7px;
	font-family: var(--serif);
}

.danger-zone p {
	color: var(--muted);
	font-size: 0.86rem;
	line-height: 1.6;
	margin-bottom: 18px;
}

.delete-account-button {
	position: relative;
	height: 44px;
	padding: 0 22px;

	background: #fff;
	color: #b42318;

	border: 1px solid #e0aaa4;
	border-radius: 8px;

	font-family: var(--sans);
	font-size: 0.88rem;
	font-weight: 700;

	cursor: pointer;

	overflow: hidden;

	animation: dangerPulse 3s ease-in-out infinite;

	transition:
		transform .35s cubic-bezier(.2, .75, .25, 1),
		background-color .35s ease,
		border-color .35s ease,
		color .35s ease,
		box-shadow .35s ease;
}

.delete-account-button:hover {
	background: #fff1ef;
	border-color: #c94a3d;
	color: #a51f15;
	transform: translateY(-3px);
	box-shadow: 0 8px 18px rgba(180, 35, 24, 0.22);
}

.delete-account-button:active {
	transform: scale(0.96);
}

@keyframes dangerPulse {
	0%, 100% { box-shadow: 0 0 0 0 rgba(180, 35, 24, 0.2); }
	50%      { box-shadow: 0 0 0 10px rgba(180, 35, 24, 0); }
}

/* MODAL */
.delete-modal {
	display: none;
	position: fixed;
	z-index: 9999;
	inset: 0;
	background: rgba(25, 25, 25, 0.58);
	backdrop-filter: blur(7px);
	-webkit-backdrop-filter: blur(7px);
	align-items: center;
	justify-content: center;
	padding: 20px;
	animation: fadeIn .35s ease both;
}

.delete-modal.show {
	display: flex;
}

@keyframes fadeIn {
	from { opacity: 0; }
	to   { opacity: 1; }
}

.delete-modal-content {
	width: 100%;
	max-width: 440px;
	padding: 32px;
	background: var(--surface);
	border: 1px solid rgba(32, 40, 33, 0.08);
	border-radius: 14px;
	box-shadow: 0 20px 60px rgba(0, 0, 0, 0.22);
	text-align: center;
	animation: modalPop .5s cubic-bezier(.2, 1.3, .4, 1) both;
}

@keyframes modalPop {
	from { opacity: 0; transform: scale(.85) translateY(30px); }
	to   { opacity: 1; transform: scale(1) translateY(0); }
}

.delete-modal-icon {
	width: 62px;
	height: 62px;
	margin: 0 auto 18px;
	border-radius: 50%;
	background: #fff0ed;
	color: #b42318;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1.6rem;
	font-weight: 700;
	animation: iconWobble 3s ease-in-out infinite;
}

@keyframes iconWobble {
	0%, 100% { transform: rotate(0deg); }
	25%      { transform: rotate(-6deg); }
	75%      { transform: rotate(6deg); }
}

.delete-modal-content h2 {
	font-family: var(--serif);
	font-size: 1.55rem;
	color: var(--ink);
	font-weight: 600;
	margin-bottom: 10px;
}

.delete-modal-content p {
	color: var(--muted);
	font-size: 0.88rem;
	line-height: 1.6;
	margin-bottom: 25px;
}

.delete-modal-actions {
	display: flex;
	justify-content: center;
	gap: 10px;
}

.keep-account-button,
.confirm-delete-button {
	height: 44px;
	padding: 0 22px;
	border-radius: 8px;
	font-family: var(--sans);
	font-size: 0.86rem;
	font-weight: 700;
	cursor: pointer;
	transition:
		transform .35s cubic-bezier(.2, .75, .25, 1),
		background-color .3s ease,
		border-color .3s ease,
		box-shadow .3s ease;
}

.keep-account-button {
	background: #fff;
	color: #555;
	border: 1px solid #ddd6ce;
}

.keep-account-button:hover {
	background: #f7f4f0;
	transform: translateY(-3px);
}

.confirm-delete-button {
	background: #b42318;
	color: #fff;
	border: 1px solid #b42318;
	box-shadow: 0 6px 16px rgba(180, 35, 24, 0.22);
	animation: confirmPulse 2s ease-in-out infinite;
}

.confirm-delete-button:hover {
	background: #961b12;
	border-color: #961b12;
	transform: translateY(-3px);
	box-shadow: 0 12px 22px rgba(180, 35, 24, 0.3);
}

@keyframes confirmPulse {
	0%, 100% { box-shadow: 0 6px 16px rgba(180, 35, 24, 0.22), 0 0 0 0 rgba(180, 35, 24, 0.3); }
	50%      { box-shadow: 0 6px 16px rgba(180, 35, 24, 0.22), 0 0 0 10px rgba(180, 35, 24, 0); }
}

.confirm-delete-button:active,
.keep-account-button:active {
	transform: scale(0.95);
}

/* RESPONSIVE */
@media (max-width: 700px) {
	.profile-page {
		width: calc(100% - 36px);
		margin: 34px auto 50px;
	}

	.profile-heading h1 { font-size: 2rem; }

	.profile-card {
		padding: 24px 20px;
		border-radius: 12px;
	}

	.profile-form {
		grid-template-columns: 1fr;
		gap: 20px;
	}

	.form-group.full-width { grid-column: span 1; }

	.profile-actions {
		grid-column: span 1;
		flex-direction: column-reverse;
		align-items: center;
	}

	.return-button,
	.save-button {
		width: 100%;
		max-width: 260px;
	}

	.delete-account-button { width: 100%; }

	.delete-modal-content { padding: 24px 20px; }

	.delete-modal-actions { flex-direction: column-reverse; }

	.keep-account-button,
	.confirm-delete-button {
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
<!-- SCROLL PROGRESS -->
<div class="scroll-progress" id="scrollProgress"></div>

<!-- HEADER -->
<jsp:include page="/include/header.jsp" />

<!-- MAIN -->
<main class="profile-page">

	<!-- PAGE HEADING -->
	<div class="profile-heading">

		<h1>Edit Profile</h1>

		<p>
			Update your personal information and keep your Foody account up to date.
		</p>

	</div>

	<!-- PROFILE CARD -->
	<div class="profile-card">

		<!-- PROFILE INTRO -->
		<div class="profile-intro">

			<div class="profile-avatar">
				<%= user.getUsername().substring(0, 1).toUpperCase() %>
			</div>

			<div class="profile-intro-text">

				<h2><%= user.getUsername() %></h2>

				<p>Manage your account information</p>

			</div>

		</div>

		<!-- SUCCESS MESSAGE -->
		<%
			if (profileMessage != null) {
		%>

		<div class="message success-message">
			<%= profileMessage %>
		</div>

		<%
			}
		%>

		<!-- ERROR MESSAGE -->
		<%
			if (profileError != null) {
		%>

		<div class="message error-message">
			<%= profileError %>
		</div>

		<%
			}
		%>

		<!-- PROFILE FORM -->
		<form action="updateProfile"
		      method="post"
		      class="profile-form">

			<!-- USERNAME -->
			<div class="form-group">

				<label for="username">Username</label>

				<input
					type="text"
					id="username"
					name="username"
					value="<%= user.getUsername() %>"
					required>

			</div>

			<!-- EMAIL -->
			<div class="form-group">

				<label for="email">Email</label>

				<input
					type="email"
					id="email"
					name="email"
					value="<%= user.getEmail() %>"
					required>

			</div>

			<!-- PHONE -->
			<div class="form-group">

				<label for="phone">Phone</label>

				<input
					type="text"
					id="phone"
					name="phone"
					value="<%= user.getPhone() != null ? user.getPhone() : "" %>"
					placeholder="Enter your phone number">

			</div>

			<!-- ADDRESS -->
			<div class="form-group full-width">

				<label for="address">Address</label>

				<input
					type="text"
					id="address"
					name="address"
					value="<%= user.getAddress() != null ? user.getAddress() : "" %>"
					placeholder="Enter your delivery address">

			</div>

			<!-- PROFILE ACTIONS -->
			<div class="profile-actions">

				<a href="home" class="return-button">
					Return
				</a>

				<button type="submit" class="save-button">
					Save Changes
				</button>

			</div>

		</form>

		<!-- DANGER ZONE -->
		<div class="danger-zone">

			<h3>Delete Account</h3>

			<p>
				Permanently delete your Foody account and all associated
				order history. This action cannot be undone.
			</p>

			<button
				type="button"
				class="delete-account-button"
				onclick="openDeleteModal()">

				Delete Account

			</button>

		</div>

	</div>

</main>

<!-- DELETE CONFIRMATION MODAL -->
<div id="deleteModal" class="delete-modal">

	<div class="delete-modal-content">

		<div class="delete-modal-icon">!</div>

		<h2>Delete your account?</h2>

		<p>
			This will permanently delete your Foody account,
			orders, and order items. This action cannot be undone.
		</p>

		<div class="delete-modal-actions">

			<button
				type="button"
				class="keep-account-button"
				onclick="closeDeleteModal()">

				Keep Account

			</button>

			<form action="deleteAccount"
			      method="post"
			      style="margin: 0;">

				<button
					type="submit"
					class="confirm-delete-button">

					Yes, Delete Account

				</button>

			</form>

		</div>

	</div>

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
   2. DELETE MODAL OPEN / CLOSE
===================================================== */
function openDeleteModal() {
	var modal = document.getElementById("deleteModal");

	if (modal) {
		modal.classList.add("show");
	}
}

function closeDeleteModal() {
	var modal = document.getElementById("deleteModal");

	if (modal) {
		modal.classList.remove("show");
	}
}

/* Click outside to close */
(function () {
	var modal = document.getElementById("deleteModal");

	if (!modal) return;

	modal.addEventListener("click", function (event) {
		if (event.target === modal) {
			closeDeleteModal();
		}
	});
})();

/* Escape key to close */
document.addEventListener("keydown", function (event) {
	if (event.key === "Escape") {
		closeDeleteModal();
	}
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
   4. INPUT "HAS-VALUE" STATE (optional enhancement)
===================================================== */
document.addEventListener("DOMContentLoaded", function () {

	var inputs = document.querySelectorAll(".form-group input");

	inputs.forEach(function (input) {

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

</script>

</body>

</html>