package com.tap.controller;

import java.io.IOException;
import java.util.Map;

import com.tap.model.CartItem;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check whether user is logged in
        User user = (User) session.getAttribute("user");

        if (user == null) {

            // Remember that the user was trying to checkout
            session.setAttribute(
                    "checkoutMessage",
                    "Please log in to proceed further."
            );

            // Send user to login page
            response.sendRedirect("login.jsp");

            return;
        }


        // Get cart
        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart =
                (Map<Integer, CartItem>)
                session.getAttribute("cart");


        // Check whether cart is empty
        if (cart == null || cart.isEmpty()) {

            response.sendRedirect("cart");

            return;
        }


        // Cart exists and user is logged in
        request.setAttribute("cart", cart);

        request.getRequestDispatcher("checkout.jsp")
               .forward(request, response);
    }
}