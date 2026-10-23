package com.tap.controller;

import java.io.IOException;
import org.mindrot.jbcrypt.BCrypt;

import com.tap.DaoImpl.UserDaoImpl;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDaoImpl userDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDao.getUserByEmail(email);

        if (user != null && BCrypt.checkpw(password, user.getPassword())) {

            HttpSession session = request.getSession();

            // Store logged-in user
            session.setAttribute("user", user);

            /*
             * Check whether the user came to login
             * because they wanted to checkout.
             */
            String checkoutMessage =
                    (String) session.getAttribute("checkoutMessage");

            if (checkoutMessage != null) {

                // Remove the temporary message
                session.removeAttribute("checkoutMessage");

                // Continue to checkout
                response.sendRedirect("checkout");

            } else {

                // Normal login
                response.sendRedirect("home");

            }

        } else {

            response.sendRedirect("login.jsp?error=invalid");
        }
    }
}