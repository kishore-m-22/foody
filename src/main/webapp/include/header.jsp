<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.Map" %>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.CartItem" %>

<%
    User headerUser =
        (User) session.getAttribute("user");

    @SuppressWarnings("unchecked")
    Map<Integer, CartItem> headerCart =
        (Map<Integer, CartItem>) session.getAttribute("cart");

    int headerCartCount = 0;

    if (headerCart != null) {
        for (CartItem item : headerCart.values()) {
            headerCartCount += item.getQuantity();
        }
    }
%>

<style>

    /* ================================
       HEADER
       ================================ */

    .foody-header {
        position: sticky;
        top: 0;
        z-index: 1000;

        height: 76px;

        display: flex;
        align-items: center;
        justify-content: space-between;

        padding: 0 7%;

        background: #fffefa;

        border-bottom: 1px solid rgba(32, 40, 33, 0.08);

        box-shadow: 0 3px 16px rgba(32, 40, 33, 0.04);

        box-sizing: border-box;
    }


    /* ================================
       LOGO
       ================================ */

    .foody-logo {
        color: #b94b33;

        font-family: "Playfair Display", Georgia, serif;

        font-size: 1.8rem;
        font-weight: 600;

        letter-spacing: -0.5px;

        text-decoration: none;

        transition: opacity 350ms ease;
    }

    .foody-logo:hover {
        opacity: 0.78;
    }


    /* ================================
       NAVIGATION
       ================================ */

    .foody-nav {
        display: flex;
        align-items: center;

        gap: 28px;

        font-family: "DM Sans", "Segoe UI", sans-serif;
    }


    .foody-nav-link {
        position: relative;

        color: #454c43;

        font-size: 0.88rem;
        font-weight: 600;

        text-decoration: none;

        transition: color 350ms ease;
    }

    .foody-nav-link:hover {
        color: #b94b33;
    }


    /* ================================
       NAVIGATION HOVER
       ================================ */

    .foody-nav-link:not(.foody-cart-link)::after {
        content: "";

        position: absolute;

        left: 0;
        right: 0;
        bottom: -7px;

        height: 1px;

        background: #b94b33;

        transform: scaleX(0);

        transform-origin: left;

        transition: transform 380ms ease;
    }

    .foody-nav-link:not(.foody-cart-link):hover::after {
        transform: scaleX(1);
    }


    /* ================================
       CART
       ================================ */

    .foody-cart-link {
        position: relative;
    }


    .foody-cart-badge {
        position: absolute;

        top: -11px;
        right: -15px;

        min-width: 18px;
        height: 18px;

        padding: 0 5px;

        display: flex;
        align-items: center;
        justify-content: center;

        background: #b94b33;

        color: #ffffff;

        border-radius: 50px;

        font-size: 10px;
        font-weight: 700;

        box-sizing: border-box;
    }


    /* ================================
       LOGIN
       ================================ */

    .foody-login {
        color: #b94b33;
    }


    /* ================================
       REGISTER
       ================================ */

    .foody-register {
        padding: 10px 18px;

        border-radius: 7px;

        background: #485c46;

        color: #ffffff;

        font-size: 0.88rem;
        font-weight: 600;

        text-decoration: none;

        transition:
            background 350ms ease,
            transform 350ms ease;
    }

    .foody-register:hover {
        background: #344733;

        transform: translateY(-4px);
    }


    /* ================================
       USER DROPDOWN
       ================================ */

    .foody-user-dropdown {
        position: relative;

        display: flex;
        align-items: center;
    }


    .foody-user-button {
        display: flex;
        align-items: center;

        gap: 8px;

        padding: 7px 13px 7px 9px;

        border: none;

        border-radius: 22px;

        background: #fff1f0;

        color: #b94b33;

        font-family: "DM Sans", "Segoe UI", sans-serif;

        font-size: 0.88rem;
        font-weight: 600;

        cursor: pointer;

        transition:
            background 350ms ease,
            transform 350ms ease;
    }

    .foody-user-button:hover {
        background: #fde8e6;

        transform: translateY(-4px);
    }


    /* ================================
       USER ICON
       ================================ */

    .foody-user-icon {
        width: 27px;
        height: 27px;

        display: flex;
        align-items: center;
        justify-content: center;

        border-radius: 50%;

        background: #f3e7ff;

        color: #6d3fa9;

        flex-shrink: 0;
    }


    .foody-user-icon::before {
        content: "";

        width: 7px;
        height: 7px;

        position: absolute;

        margin-top: -9px;

        border-radius: 50%;

        background: #6d3fa9;
    }


    .foody-user-icon::after {
        content: "";

        width: 12px;
        height: 8px;

        position: absolute;

        margin-top: 8px;

        border-radius: 8px 8px 4px 4px;

        background: #6d3fa9;
    }


    /* ================================
       USERNAME
       ================================ */

    .foody-username {
        text-transform: capitalize;

        color: #b94b33;
    }


    /* ================================
       ARROW
       ================================ */

    .foody-user-arrow {
        width: 6px;
        height: 6px;

        border-right: 1.5px solid currentColor;
        border-bottom: 1.5px solid currentColor;

        transform: rotate(45deg);

        margin-top: -3px;

        transition: transform 350ms ease;
    }


    .foody-user-dropdown:hover .foody-user-arrow {
        transform: rotate(225deg);

        margin-top: 3px;
    }


    /* ================================
       USER MENU
       ================================ */

    .foody-user-menu {
        position: absolute;

        top: calc(100% + 15px);

        right: 0;

        min-width: 155px;

        padding: 6px;

        background: #fffefa;

        border: 1px solid rgba(32, 40, 33, 0.08);

        border-radius: 8px;

        box-shadow:
            0 12px 30px rgba(32, 40, 33, 0.12);

        opacity: 0;

        visibility: hidden;

        transform: translateY(-18px);

        transition:
            opacity 350ms ease,
            visibility 350ms ease,
            transform 350ms ease;
    }


    .foody-user-dropdown:hover .foody-user-menu,
    .foody-user-dropdown:focus-within .foody-user-menu {

        opacity: 1;

        visibility: visible;

        transform: translateY(0);
    }


    /* ================================
       DROPDOWN ARROW TIP
       ================================ */

    .foody-user-menu::before {
        content: "";

        position: absolute;

        top: -5px;
        right: 18px;

        width: 9px;
        height: 9px;

        background: #fffefa;

        border-left: 1px solid rgba(32, 40, 33, 0.08);
        border-top: 1px solid rgba(32, 40, 33, 0.08);

        transform: rotate(45deg);
    }


    /* ================================
       EDIT PROFILE
       ================================ */

    .foody-profile {
        display: block;

        width: 100%;

        padding: 9px 11px;

        border-radius: 6px;

        color: #454c43;

        font-family: "DM Sans", "Segoe UI", sans-serif;

        font-size: 0.83rem;
        font-weight: 600;

        text-decoration: none;

        box-sizing: border-box;

        transition:
            background 320ms ease,
            color 320ms ease;
    }


    .foody-profile:hover {
        background: #f7e9e4;

        color: #b94b33;
    }


    /* ================================
       LOGOUT
       ================================ */

    .foody-logout {
        display: block;

        width: 100%;

        padding: 9px 11px;

        border-radius: 6px;

        color: #454c43;

        font-family: "DM Sans", "Segoe UI", sans-serif;

        font-size: 0.83rem;
        font-weight: 600;

        text-decoration: none;

        box-sizing: border-box;

        transition:
            background 320ms ease,
            color 320ms ease;
    }


    .foody-logout:hover {
        background: #f7e9e4;

        color: #b94b33;
    }


    /* ================================
       MOBILE
       ================================ */

    @media (max-width: 700px) {

        .foody-header {
            height: auto;

            min-height: 72px;

            padding: 14px 5%;

            flex-wrap: wrap;

            gap: 14px;
        }


        .foody-nav {
            width: 100%;

            justify-content: center;

            flex-wrap: wrap;

            gap: 16px;
        }


        .foody-nav-link,
        .foody-user-button {
            font-size: 0.82rem;
        }

    }

</style>


<header class="foody-header">

    <!-- FOODY LOGO -->

    <a href="home" class="foody-logo">
        Foody
    </a>


    <!-- NAVIGATION -->

    <nav class="foody-nav">

        <a href="home" class="foody-nav-link">
            Home
        </a>


        <a href="restaurants" class="foody-nav-link">
            Restaurants
        </a>


        <!-- CART -->

        <a href="cart"
           class="foody-nav-link foody-cart-link">

            Cart

            <% if (headerCartCount > 0) { %>

                <span class="foody-cart-badge">
                    <%= headerCartCount %>
                </span>

            <% } %>

        </a>


        <% if (headerUser == null) { %>

            <!-- ==============================
                 NOT LOGGED IN
                 ============================== -->

            <a href="login.jsp"
               class="foody-nav-link foody-login">

                Login

            </a>


            <a href="register.jsp"
               class="foody-register">

                Register

            </a>


        <% } else { %>

            <!-- ==============================
                 LOGGED IN
                 ============================== -->

            <a href="orders"
               class="foody-nav-link">

                Orders

            </a>


            <!-- ==============================
                 USER DROPDOWN
                 ============================== -->

            <div class="foody-user-dropdown">

                <button type="button"
                        class="foody-user-button">

                    <span class="foody-user-icon"></span>

                    <span class="foody-username">
                        <%= headerUser.getUsername() %>
                    </span>

                    <span class="foody-user-arrow"></span>

                </button>


                <!-- USER MENU -->

                <div class="foody-user-menu">

                    <!-- EDIT PROFILE -->

                    <a href="profile.jsp"
                       class="foody-profile">

                        Edit Profile

                    </a>


                    <!-- LOGOUT -->

                    <a href="logout"
                       class="foody-logout">

                        Logout

                    </a>

                </div>

            </div>

        <% } %>

    </nav>

</header>