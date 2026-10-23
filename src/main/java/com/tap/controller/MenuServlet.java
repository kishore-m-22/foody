package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.DaoImpl.MenuDaoImpl;
import com.tap.DaoImpl.RestaurantDaoImpl;
import com.tap.model.Menu;
import com.tap.model.Restaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private MenuDaoImpl menuDao;
    private RestaurantDaoImpl restaurantDao;

    @Override
    public void init() throws ServletException {

        menuDao = new MenuDaoImpl();
        restaurantDao = new RestaurantDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String restaurantIdParameter =
                request.getParameter("restaurantId");

        if (restaurantIdParameter == null
                || restaurantIdParameter.isEmpty()) {

            response.sendRedirect("restaurants");
            return;
        }

        int restaurantId;

        try {

            restaurantId =
                    Integer.parseInt(restaurantIdParameter);

        } catch (NumberFormatException e) {

            response.sendRedirect("restaurants");
            return;
        }

        // Get restaurant
        Restaurant restaurant =
                restaurantDao.getRestaurant(restaurantId);

        if (restaurant == null) {

            response.sendRedirect("restaurants");
            return;
        }

        // Get menu
        List<Menu> menus =
                menuDao.getMenusByRestaurant(restaurantId);

        request.setAttribute(
                "restaurant",
                restaurant
        );

        request.setAttribute(
                "menus",
                menus
        );

        request.setAttribute(
                "restaurantId",
                restaurantId
        );

        request.getRequestDispatcher(
                "menu.jsp"
        ).forward(
                request,
                response
        );
    }
}