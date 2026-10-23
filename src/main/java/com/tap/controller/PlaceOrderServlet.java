package com.tap.controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import com.tap.DaoImpl.OrderDaoImpl;
import com.tap.DaoImpl.OrderItemDaoImpl;
import com.tap.DaoImpl.RestaurantDaoImpl;
import com.tap.model.CartItem;
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

@WebServlet("/placeOrder")
public class PlaceOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrderDaoImpl orderDao;
    private OrderItemDaoImpl orderItemDao;
    private RestaurantDaoImpl restaurantDao;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDaoImpl();
        orderItemDao = new OrderItemDaoImpl();
        restaurantDao = new RestaurantDaoImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart =
                (Map<Integer, CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        String paymentMode = request.getParameter("paymentMode");
        String address = request.getParameter("address");

        if (paymentMode == null || paymentMode.trim().isEmpty()) {
            paymentMode = "Cash on Delivery";
        }

        if (address == null || address.trim().isEmpty()) {
            address = user.getAddress();
        }

        CartItem firstItem = cart.values().iterator().next();
        int restaurantId = firstItem.getMenu().getRestaurantId();

        double itemTotal = 0;
        for (CartItem item : cart.values()) {
            itemTotal += item.getTotalPrice();
        }

        Restaurant restaurant = restaurantDao.getRestaurant(restaurantId);

        int discountPercent = 0;
        if (restaurant != null) {
            discountPercent = restaurant.getDiscountPercent();
        }

        double discountAmount = itemTotal * discountPercent / 100.0;
        double discountedSubtotal = itemTotal - discountAmount;

        double deliveryFee;
        if (discountedSubtotal > 300) {
            deliveryFee = 0;
        } else {
            deliveryFee = 40;
        }

        double tax = discountedSubtotal * 0.05;
        double finalTotal = discountedSubtotal + deliveryFee + tax;

        Order order = new Order();

        order.setUserId(user.getUserId());
        order.setRestaurantId(restaurantId);
        order.setOrderDate(LocalDateTime.now());
        order.setTotalAmount(finalTotal);

        // ⭐ NEW: save the breakdown
        order.setSubtotal(itemTotal);
        order.setDiscountPercent(discountPercent);
        order.setDiscountAmount(discountAmount);
        order.setDeliveryFee(deliveryFee);
        order.setTax(tax);

        order.setStatus("PLACED");
        order.setPaymentMode(paymentMode);

        orderDao.addOrder(order);

        // Find latest order
        List<Order> userOrders = orderDao.getOrdersByUser(user.getUserId());

        Order latestOrder = null;
        for (Order currentOrder : userOrders) {
            if (latestOrder == null ||
                currentOrder.getOrderId() > latestOrder.getOrderId()) {
                latestOrder = currentOrder;
            }
        }

        if (latestOrder == null) {
            response.sendRedirect("cart");
            return;
        }

        int orderId = latestOrder.getOrderId();

        // Save order items
        for (CartItem item : cart.values()) {

            OrderItem orderItem = new OrderItem();

            orderItem.setOrderId(orderId);
            orderItem.setMenuId(item.getMenu().getMenuId());
            orderItem.setQuantity(item.getQuantity());
            orderItem.setTotalAmount(item.getTotalPrice());

            orderItemDao.addOrderItem(orderItem);
        }

        session.setAttribute("orderAddress", address);
        session.setAttribute("lastOrderId", orderId);
        session.removeAttribute("cart");

        response.sendRedirect("orderConfirmation.jsp");
    }
}