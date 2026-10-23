package com.tap.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.tap.DaoImpl.MenuDaoImpl;
import com.tap.DaoImpl.OrderDaoImpl;
import com.tap.DaoImpl.OrderItemDaoImpl;
import com.tap.DaoImpl.RestaurantDaoImpl;
import com.tap.model.Menu;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.Restaurant;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orders")
public class OrdersServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrderDaoImpl orderDao;
    private OrderItemDaoImpl orderItemDao;
    private RestaurantDaoImpl restaurantDao;
    private MenuDaoImpl menuDao;

    @Override
    public void init() throws ServletException {

        orderDao = new OrderDaoImpl();
        orderItemDao = new OrderItemDaoImpl();
        restaurantDao = new RestaurantDaoImpl();
        menuDao = new MenuDaoImpl();
    }


    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");


        // User must be logged in
        if (user == null) {

            response.sendRedirect("login.jsp");

            return;
        }


        // Get all orders of logged-in user
        List<Order> orders =
                orderDao.getOrdersByUser(user.getUserId());


        /*
         * =====================================================
         * RESTAURANT NAMES
         * =====================================================
         *
         * Key   = restaurantId
         * Value = restaurant name
         */

        Map<Integer, String> restaurantNames =
                new HashMap<>();


        if (orders != null) {

            for (Order order : orders) {

                int restaurantId =
                        order.getRestaurantId();


                if (!restaurantNames.containsKey(restaurantId)) {

                    Restaurant restaurant =
                            restaurantDao.getRestaurant(restaurantId);


                    if (restaurant != null) {

                        restaurantNames.put(
                                restaurantId,
                                restaurant.getName()
                        );

                    } else {

                        restaurantNames.put(
                                restaurantId,
                                "Restaurant #" + restaurantId
                        );
                    }
                }
            }
        }


        /*
         * =====================================================
         * ORDER ITEMS
         * =====================================================
         *
         * Key   = orderId
         * Value = list of OrderItem
         */

        Map<Integer, List<OrderItem>> orderItemsMap =
                new HashMap<>();


        /*
         * =====================================================
         * MENU DETAILS
         * =====================================================
         *
         * Key   = menuId
         * Value = Menu object
         */

        Map<Integer, Menu> menuMap =
                new HashMap<>();


        if (orders != null) {

            for (Order order : orders) {

                int orderId =
                        order.getOrderId();


                List<OrderItem> orderItems =
                        orderItemDao.getOrderItemsByOrder(orderId);


                if (orderItems == null) {

                    orderItems =
                            new ArrayList<>();
                }


                orderItemsMap.put(
                        orderId,
                        orderItems
                );


                /*
                 * Load menu information for every
                 * ordered item.
                 */

                for (OrderItem orderItem : orderItems) {

                    int menuId =
                            orderItem.getMenuId();


                    if (!menuMap.containsKey(menuId)) {

                        Menu menu =
                                menuDao.getMenu(menuId);


                        if (menu != null) {

                            menuMap.put(
                                    menuId,
                                    menu
                            );
                        }
                    }
                }
            }
        }


        /*
         * =====================================================
         * SEND DATA TO JSP
         * =====================================================
         */

        request.setAttribute(
                "orders",
                orders
        );


        request.setAttribute(
                "restaurantNames",
                restaurantNames
        );


        request.setAttribute(
                "orderItemsMap",
                orderItemsMap
        );


        request.setAttribute(
                "menuMap",
                menuMap
        );


        request.getRequestDispatcher(
                "orders.jsp"
        ).forward(request, response);
    }
}