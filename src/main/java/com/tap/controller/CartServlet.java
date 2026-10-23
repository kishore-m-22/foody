package com.tap.controller;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

import com.tap.DaoImpl.MenuDaoImpl;
import com.tap.model.CartItem;
import com.tap.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private MenuDaoImpl menuDao;

    @Override
    public void init() throws ServletException {
        menuDao = new MenuDaoImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        HttpSession session = request.getSession();

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart =
                (Map<Integer, CartItem>) session.getAttribute("cart");

        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute("cart", cart);
        }

        // =====================================================
        // ADD TO CART
        // =====================================================

        if ("add".equals(action)) {

            int menuId = Integer.parseInt(
                    request.getParameter("menuId")
            );

            Menu menu = menuDao.getMenu(menuId);

            if (menu == null) {
                response.sendRedirect("restaurants");
                return;
            }

            /*
             * Check whether another restaurant's item
             * already exists in the cart.
             */
            if (!cart.isEmpty()) {

                CartItem firstItem =
                        cart.values().iterator().next();

                int existingRestaurantId =
                        firstItem.getMenu().getRestaurantId();

                int newRestaurantId =
                        menu.getRestaurantId();

                if (existingRestaurantId != newRestaurantId) {

                    session.setAttribute(
                            "pendingMenuId",
                            menuId
                    );

                    session.setAttribute(
                            "pendingRestaurantId",
                            newRestaurantId
                    );

                    response.sendRedirect(
                            "menu?restaurantId="
                                    + newRestaurantId
                                    + "&cartConflict=true"
                    );

                    return;
                }
            }

            /*
             * If item already exists,
             * increase quantity.
             */
            if (cart.containsKey(menuId)) {

                CartItem cartItem =
                        cart.get(menuId);

                cartItem.setQuantity(
                        cartItem.getQuantity() + 1
                );

            } else {

                /*
                 * First time adding the item.
                 */
                CartItem cartItem =
                        new CartItem(menu, 1);

                cart.put(menuId, cartItem);
            }

            session.setAttribute(
                    "cart",
                    cart
            );

            // =================================================
            // CART POPUP
            // =================================================
            //
            // Calculate current cart subtotal after
            // successfully adding the item.
            //
            // Free delivery is unlocked when the subtotal
            // is above ₹300.
            // =================================================

            double cartSubtotal = 0;

            for (CartItem item : cart.values()) {
                cartSubtotal += item.getTotalPrice();
            }

            if (cartSubtotal > 300) {

                session.setAttribute(
                        "cartPopup",
                        "🎉 Free delivery unlocked! Your order qualifies for free delivery."
                );

            } else {

                double amountRemaining = 300 - cartSubtotal;

                session.setAttribute(
                        "cartPopup",
                        "Add ₹"
                                + String.format("%.2f", amountRemaining)
                                + " more to your order to unlock FREE delivery."
                );
            }

            /*
             * After adding from menu,
             * stay on the menu page.
             */
            redirectToSourcePage(
                    request,
                    response,
                    menu.getRestaurantId()
            );

            return;
        }

        // =====================================================
        // CONFIRM CHANGE RESTAURANT
        // =====================================================

        if ("confirmReplace".equals(action)) {

            Integer pendingMenuId =
                    (Integer) session.getAttribute(
                            "pendingMenuId"
                    );

            if (pendingMenuId != null) {

                Menu menu =
                        menuDao.getMenu(
                                pendingMenuId
                        );

                if (menu != null) {

                    cart.clear();

                    cart.put(
                            menu.getMenuId(),
                            new CartItem(menu, 1)
                    );

                    session.setAttribute(
                            "cart",
                            cart
                    );

                    session.removeAttribute(
                            "pendingMenuId"
                    );

                    session.removeAttribute(
                            "pendingRestaurantId"
                    );

                    /*
                     * Stay on the new restaurant's menu.
                     */
                    response.sendRedirect(
                            "menu?restaurantId="
                                    + menu.getRestaurantId()
                    );

                    return;
                }
            }

            session.removeAttribute(
                    "pendingMenuId"
            );

            session.removeAttribute(
                    "pendingRestaurantId"
            );

            response.sendRedirect("restaurants");

            return;
        }

        // =====================================================
        // CANCEL CHANGE RESTAURANT
        // =====================================================

        if ("cancelReplace".equals(action)) {

            Integer pendingRestaurantId =
                    (Integer) session.getAttribute(
                            "pendingRestaurantId"
                    );

            session.removeAttribute(
                    "pendingMenuId"
            );

            session.removeAttribute(
                    "pendingRestaurantId"
            );

            if (pendingRestaurantId != null) {

                response.sendRedirect(
                        "menu?restaurantId="
                                + pendingRestaurantId
                );

            } else {

                response.sendRedirect(
                        "restaurants"
                );
            }

            return;
        }

        // =====================================================
        // INCREASE QUANTITY
        // =====================================================

        if ("increase".equals(action)) {

            int menuId = Integer.parseInt(
                    request.getParameter("menuId")
            );

            if (cart.containsKey(menuId)) {

                CartItem cartItem =
                        cart.get(menuId);

                cartItem.setQuantity(
                        cartItem.getQuantity() + 1
                );

                session.setAttribute(
                        "cart",
                        cart
                );

                /*
                 * IMPORTANT:
                 * If increase is done from cart.jsp,
                 * stay on the cart page.
                 */
                String returnPage =
                        request.getParameter("returnPage");

                if ("cart".equals(returnPage)) {

                    response.sendRedirect("cart");

                } else {

                    int restaurantId =
                            cartItem.getMenu()
                                    .getRestaurantId();

                    response.sendRedirect(
                            "menu?restaurantId="
                                    + restaurantId
                    );
                }

                return;
            }

            response.sendRedirect("cart");
            return;
        }

        // =====================================================
        // DECREASE QUANTITY
        // =====================================================

        if ("decrease".equals(action)) {

            int menuId = Integer.parseInt(
                    request.getParameter("menuId")
            );

            if (cart.containsKey(menuId)) {

                CartItem cartItem =
                        cart.get(menuId);

                int restaurantId =
                        cartItem.getMenu()
                                .getRestaurantId();

                int newQuantity =
                        cartItem.getQuantity() - 1;

                /*
                 * Remove item completely
                 * when quantity reaches zero.
                 */
                if (newQuantity <= 0) {

                    cart.remove(menuId);

                } else {

                    cartItem.setQuantity(
                            newQuantity
                    );
                }

                session.setAttribute(
                        "cart",
                        cart
                );

                /*
                 * IMPORTANT:
                 * If decrease is done from cart.jsp,
                 * stay on the cart page.
                 */
                String returnPage =
                        request.getParameter("returnPage");

                if ("cart".equals(returnPage)) {

                    response.sendRedirect("cart");

                } else {

                    response.sendRedirect(
                            "menu?restaurantId="
                                    + restaurantId
                    );
                }

                return;
            }

            response.sendRedirect("cart");
            return;
        }

        // =====================================================
        // UPDATE QUANTITY
        // =====================================================

        if ("update".equals(action)) {

            int menuId = Integer.parseInt(
                    request.getParameter("menuId")
            );

            int quantity = Integer.parseInt(
                    request.getParameter("quantity")
            );

            if (cart.containsKey(menuId)) {

                CartItem cartItem =
                        cart.get(menuId);

                int restaurantId =
                        cartItem.getMenu()
                                .getRestaurantId();

                if (quantity <= 0) {

                    cart.remove(menuId);

                } else {

                    cartItem.setQuantity(
                            quantity
                    );
                }

                session.setAttribute(
                        "cart",
                        cart
                );

                /*
                 * IMPORTANT:
                 * If update is done from cart.jsp,
                 * stay on the cart page.
                 */
                String returnPage =
                        request.getParameter("returnPage");

                if ("cart".equals(returnPage)) {

                    response.sendRedirect("cart");

                } else {

                    response.sendRedirect(
                            "menu?restaurantId="
                                    + restaurantId
                    );
                }

                return;
            }

            response.sendRedirect("cart");
            return;
        }

        // =====================================================
        // REMOVE ITEM
        // =====================================================

        if ("remove".equals(action)) {

            int menuId = Integer.parseInt(
                    request.getParameter("menuId")
            );

            int restaurantId = 0;

            if (cart.containsKey(menuId)) {

                restaurantId =
                        cart.get(menuId)
                                .getMenu()
                                .getRestaurantId();

                cart.remove(menuId);
            }

            session.setAttribute(
                    "cart",
                    cart
            );

            redirectToSourcePage(
                    request,
                    response,
                    restaurantId
            );

            return;
        }

        // =====================================================
        // CLEAR CART
        // =====================================================

        if ("clear".equals(action)) {

            cart.clear();

            session.setAttribute(
                    "cart",
                    cart
            );

            response.sendRedirect("cart");

            return;
        }

        // =====================================================
        // UNKNOWN ACTION
        // =====================================================

        response.sendRedirect("restaurants");
    }

    // =========================================================
    // REDIRECT TO SOURCE PAGE
    // =========================================================

    private void redirectToSourcePage(
            HttpServletRequest request,
            HttpServletResponse response,
            int restaurantId)
            throws IOException {

        String returnPage =
                request.getParameter("returnPage");

        if (!"cart".equals(returnPage)
                && !"menu".equals(returnPage)) {

            String referer =
                    request.getHeader("Referer");

            if (referer != null) {

                int queryIndex =
                        referer.indexOf('?');

                String refererPath =
                        queryIndex >= 0
                                ? referer.substring(
                                        0,
                                        queryIndex
                                )
                                : referer;

                if (refererPath.endsWith("/cart")
                        || refererPath.endsWith("/cart.jsp")) {

                    returnPage = "cart";

                } else if (
                        refererPath.endsWith("/menu")
                        || refererPath.endsWith("/menu.jsp")) {

                    returnPage = "menu";
                }
            }
        }

        String redirectPath =
                switch (
                        returnPage == null
                                ? ""
                                : returnPage
                ) {

                    case "cart" ->
                            "cart";

                    case "menu" ->
                            restaurantId > 0
                                    ? "menu?restaurantId="
                                            + restaurantId
                                    : "restaurants";

                    default ->
                            restaurantId > 0
                                    ? "menu?restaurantId="
                                            + restaurantId
                                    : "restaurants";
                };

        response.sendRedirect(
                redirectPath
        );
    }

    // =========================================================
    // OPEN CART PAGE
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession();

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart =
                (Map<Integer, CartItem>)
                        session.getAttribute("cart");

        if (cart == null) {

            cart = new LinkedHashMap<>();

            session.setAttribute(
                    "cart",
                    cart
            );
        }

        request.setAttribute(
                "cart",
                cart
        );

        /*
         * GET /cart opens cart.jsp.
         */
        request.getRequestDispatcher(
                "cart.jsp"
        ).forward(
                request,
                response
        );
    }
}