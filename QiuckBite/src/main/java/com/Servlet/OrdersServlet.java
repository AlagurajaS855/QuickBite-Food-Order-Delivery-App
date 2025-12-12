package com.Servlet;

import java.io.IOException;
import java.util.List;

import com.DaoImpl.OrderDAOImpl;
import com.model.Order;
import com.model.Order;
import com.model.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orders")
public class OrdersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Users user = (Users) session.getAttribute("users");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        try {
            OrderDAOImpl orderDao = new OrderDAOImpl();
            // Assume you have a method: List<Order> getOrdersByUserId(long userId)
            List<Order> userOrders = orderDao.getOrdersByUserId(user.getUserId());

            req.setAttribute("userOrders", userOrders);
            req.getRequestDispatcher("orders.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
        }
    }
}
