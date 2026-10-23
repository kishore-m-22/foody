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

@WebServlet("/updateProfile")
public class UpdateProfileServlet extends HttpServlet {

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

        // User must be logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get the currently logged-in user
        User sessionUser = (User) session.getAttribute("user");

        // Get updated profile details
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Update only editable fields
        sessionUser.setUsername(username);
        sessionUser.setEmail(email);
        sessionUser.setPhone(phone);
        sessionUser.setAddress(address);

        try {

            // Update database
            userDao.updateProfile(sessionUser);

            // Update session with latest user details
            session.setAttribute("user", sessionUser);

            // Success message
            session.setAttribute(
                "profileMessage",
                "Profile updated successfully!"
            );

            response.sendRedirect("profile.jsp");

        } catch (RuntimeException e) {

            // Keep the user on the profile page if update fails
            session.setAttribute(
                "profileError",
                "Unable to update profile. Please try again."
            );

            response.sendRedirect("profile.jsp");
        }
    }
}