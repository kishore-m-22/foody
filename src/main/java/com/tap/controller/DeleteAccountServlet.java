package com.tap.controller;

import java.io.IOException;

import com.tap.DaoImpl.UserDaoImpl;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/deleteAccount")
public class DeleteAccountServlet extends HttpServlet {

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

        HttpSession session = request.getSession(false);

        /*
         * User must be logged in.
         */
        if (session == null || session.getAttribute("user") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        int userId = user.getUserId();

        try {

            /*
             * Permanently delete the account.
             */
            userDao.deleteAccount(userId);

            /*
             * Remove the logged-in session.
             */
            session.invalidate();

            /*
             * Send user back to login page.
             */
            response.sendRedirect("login.jsp?deleted=success");

        } catch (RuntimeException e) {

            e.printStackTrace();

            /*
             * Keep the session if deletion failed.
             */
            HttpSession currentSession = request.getSession();

            currentSession.setAttribute(
                "profileError",
                "Unable to delete your account. Please try again."
            );

            response.sendRedirect("profile.jsp");
        }
    }
}