package com.Servlet;

import com.model.Cart;
import com.model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "add":
                doAdd(req, resp);
                break;
            case "update":
                doUpdate(req, resp);
                break;
            case "delete":
                doDelete(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/menu");
        }
    }

    private Cart getCart(HttpSession session) {
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    // ADD ITEM TO CART
    private void doAdd(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        Cart cart = getCart(session);

        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String name = req.getParameter("name");
            BigDecimal price = new BigDecimal(req.getParameter("price"));
            String image = req.getParameter("image");
            int qty = Integer.parseInt(req.getParameter("quantity"));
            if (qty < 1) qty = 1;

            // CartItem(id, name, price, quantity, image)
            CartItem item = new CartItem(id, name, price, qty, image);
            cart.addItem(item);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Keep restaurantId in session for checkout
        String restaurantId = req.getParameter("restaurantId");
        if (restaurantId != null && !restaurantId.trim().isEmpty()) {
            try {
                session.setAttribute("restaurantId", Long.parseLong(restaurantId));
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/menu?restaurantId=" + restaurantId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/menu.jsp");
        }
    }

    // UPDATE QUANTITY
    private void doUpdate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/cart.jsp");
            return;
        }

        Cart cart = getCart(session);
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            int qty = Integer.parseInt(req.getParameter("quantity"));
            cart.updateQuantity(id, qty);
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/cart.jsp");
    }

    // DELETE ITEM
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/cart.jsp");
            return;
        }

        Cart cart = getCart(session);
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            cart.removeItem(id);
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/cart.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Direct hit on /CartServlet → show cart page
        resp.sendRedirect(req.getContextPath() + "/cart.jsp");
    }
}
