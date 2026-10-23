package com.tap.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.tap.DaoImpl.RestaurantDaoImpl;
import com.tap.model.Restaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private RestaurantDaoImpl restaurantDao;

    @Override
    public void init() throws ServletException {
        restaurantDao = new RestaurantDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<Restaurant> allRestaurants =
                restaurantDao.getAllRestaurants();

        List<Restaurant> discountedRestaurants =
                new ArrayList<>();

        for (Restaurant restaurant : allRestaurants) {

            if (restaurant.getDiscountPercent() > 0) {
                discountedRestaurants.add(restaurant);
            }
        }

        System.out.println(
            "Discounted restaurants found: "
            + discountedRestaurants.size()
        );

        request.setAttribute(
                "discountedRestaurants",
                discountedRestaurants
        );

        request.getRequestDispatcher("home.jsp")
               .forward(request, response);
    }
}