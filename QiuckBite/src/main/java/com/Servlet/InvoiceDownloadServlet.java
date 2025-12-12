package com.Servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.format.DateTimeFormatter;
import java.util.List;

import com.DaoImpl.OrderDAOImpl;
import com.DaoImpl.OrderItemDAOImpl;
import com.model.Order;
import com.model.OrderItem;
import com.model.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/downloadInvoice")
public class InvoiceDownloadServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Users user = (Users) session.getAttribute("users");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String orderIdParam = req.getParameter("orderId");
        if (orderIdParam == null || orderIdParam.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order ID required");
            return;
        }

        long orderId = Long.parseLong(orderIdParam);

        try {
            OrderDAOImpl orderDao = new OrderDAOImpl();
            OrderItemDAOImpl itemDao = new OrderItemDAOImpl();

            Order order = orderDao.getOrderById(orderId);
            List<OrderItem> items = itemDao.getOrderItemsByOrderId(orderId);

            if (order == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                return;
            }

            resp.setContentType("text/html;charset=UTF-8");
            resp.setHeader("Content-Disposition", "inline; filename=\"QuickBite_Invoice_" + orderId + ".html\"");

            String html = generateHTML(order, items, user, orderId);
            resp.getWriter().write(html);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String generateHTML(Order order, List<OrderItem> items, Users user, long orderId) {
        BigDecimal itemsTotal = BigDecimal.ZERO;
        StringBuilder itemRows = new StringBuilder();

        if (items != null) {
            for (OrderItem item : items) {
                itemRows.append("<tr>")
                        .append("<td>").append(item.getName()).append("</td>")
                        .append("<td style='text-align:center;'>").append(item.getQuantity()).append("</td>")
                        .append("<td style='text-align:right;'>₹ ").append(item.getPrice()).append("</td>")
                        .append("<td style='text-align:right;'>₹ ").append(item.getSubtotal()).append("</td>")
                        .append("</tr>");
                itemsTotal = itemsTotal.add(item.getSubtotal());
            }
        }

        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "<title>QuickBite Invoice #" + orderId + "</title>" +
                "<style>" +
                "* { margin: 0; padding: 0; box-sizing: border-box; }" +
                "body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; padding: 20px; }" +
                ".invoice-container { background: white; max-width: 900px; margin: 0 auto; padding: 40px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }" +
                ".header { text-align: center; border-bottom: 3px solid #ff6b35; padding-bottom: 20px; margin-bottom: 30px; }" +
                ".header h1 { color: #ff6b35; font-size: 28px; margin-bottom: 5px; }" +
                ".header p { color: #666; font-size: 14px; }" +
                ".section { margin-bottom: 30px; }" +
                ".section h3 { color: #ff6b35; font-size: 14px; text-transform: uppercase; margin-bottom: 12px; border-bottom: 2px solid #fff7ed; padding-bottom: 8px; }" +
                ".info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }" +
                ".info-item { margin-bottom: 8px; }" +
                ".info-item strong { color: #333; display: block; font-size: 11px; text-transform: uppercase; margin-bottom: 3px; }" +
                ".info-item p { color: #666; font-size: 13px; }" +
                ".address-block { background: #f9f9f9; padding: 15px; border-radius: 6px; border-left: 4px solid #ff6b35; }" +
                "table { width: 100%; border-collapse: collapse; margin-top: 10px; }" +
                "th { background: #fff7ed; color: #ff6b35; font-weight: 600; padding: 12px; text-align: left; font-size: 12px; text-transform: uppercase; }" +
                "td { padding: 12px; border-bottom: 1px solid #eee; font-size: 13px; color: #333; }" +
                "tr:last-child td { border-bottom: none; }" +
                ".summary-table { margin-top: 20px; border-top: 2px solid #eee; padding-top: 15px; }" +
                ".summary-row { display: flex; justify-content: space-between; padding: 8px 0; font-size: 13px; }" +
                ".summary-row.total { font-size: 16px; font-weight: bold; color: #ff6b35; border-top: 2px solid #ff6b35; padding-top: 12px; }" +
                ".footer { text-align: center; margin-top: 40px; padding-top: 20px; border-top: 1px solid #eee; color: #999; font-size: 12px; }" +
                ".print-button { text-align: center; margin-bottom: 20px; }" +
                ".print-button button { background: #ff6b35; color: white; border: none; padding: 12px 24px; border-radius: 6px; font-size: 14px; cursor: pointer; }" +
                ".print-button button:hover { background: #e55a2b; }" +
                "@media print { body { background: white; } .print-button { display: none; } .invoice-container { box-shadow: none; } }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='print-button'>" +
                "<button onclick='window.print()'>🖨️ Print / Save as PDF</button>" +
                "</div>" +
                "<div class='invoice-container'>" +
                "<div class='header'>" +
                "<h1>QUICKBITE</h1>" +
                "<p>Order Invoice #" + orderId + "</p>" +
                "</div>" +
                "<div class='section'>" +
                "<h3>Order Information</h3>" +
                "<div class='info-grid'>" +
                "<div class='info-item'><strong>Order ID</strong><p>#" + orderId + "</p></div>" +
                "<div class='info-item'><strong>Order Date</strong><p>" + formatDate(order.getOrderDate()) + "</p></div>" +
                "<div class='info-item'><strong>Status</strong><p>" + order.getStatus() + "</p></div>" +
                "<div class='info-item'><strong>Payment</strong><p>" + (order.getPaymentMethod() != null ? order.getPaymentMethod() : "COD") + "</p></div>" +
                "</div>" +
                "</div>" +
                "<div class='section'>" +
                "<h3>Customer Details</h3>" +
                "<div class='info-grid'>" +
                "<div class='info-item'><strong>Name</strong><p>" + (user.getName() != null ? user.getName() : "Guest") + "</p></div>" +
                "<div class='info-item'><strong>Phone</strong><p>" + (user.getPhone() != null ? user.getPhone() : "—") + "</p></div>" +
                "<div class='info-item' style='grid-column: 1 / -1;'><strong>Email</strong><p>" + (user.getEmail() != null ? user.getEmail() : "—") + "</p></div>" +
                "</div>" +
                "</div>" +
                "<div class='section'>" +
                "<h3>Delivery Address</h3>" +
                "<div class='address-block'>" +
                "<p>" + (order.getDeliveryAddress() != null ? order.getDeliveryAddress() : "—") + "</p>" +
                "</div>" +
                "</div>" +
                "<div class='section'>" +
                "<h3>Order Items</h3>" +
                "<table>" +
                "<tr><th>Item Name</th><th>Qty</th><th>Price</th><th>Subtotal</th></tr>" +
                itemRows.toString() +
                "</table>" +
                "</div>" +
                "<div class='section'>" +
                "<h3>Billing Summary</h3>" +
                "<div class='summary-table'>" +
                "<div class='summary-row'><span>Items Total</span><span>₹ " + itemsTotal + "</span></div>" +
                "<div class='summary-row'><span>Delivery Fee</span><span>₹ 0</span></div>" +
                "<div class='summary-row'><span>Taxes</span><span>₹ 0</span></div>" +
                "<div class='summary-row total'><span>Grand Total</span><span>₹ " + order.getTotalAmount() + "</span></div>" +
                "</div>" +
                "</div>" +
                "<div class='footer'>" +
                "<p>Thank you for ordering with QuickBite! 🍔</p>" +
                "<p>For support, contact us at support@quickbite.com</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }

    private String formatDate(java.time.LocalDateTime dateTime) {
        if (dateTime == null) return "—";
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");
        return dateTime.format(fmt);
    }
}
