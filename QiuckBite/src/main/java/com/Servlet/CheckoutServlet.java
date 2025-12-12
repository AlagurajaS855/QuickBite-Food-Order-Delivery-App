package com.Servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.DaoImpl.OrderDAOImpl;
import com.DaoImpl.OrderItemDAOImpl;
import com.model.Cart;
import com.model.CartItem;
import com.model.Order;
import com.model.OrderItem;
import com.model.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    
    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        
        Cart cart = (Cart) session.getAttribute("cart");
        Long restaurantId = (Long) session.getAttribute("restaurantId"); 
        Users user = (Users) session.getAttribute("users");
        
        // ================= DEBUG START =================
        System.out.println("==== DEBUG CheckoutServlet ====");
        System.out.println("cart = " + cart);
        if (cart != null) {
            System.out.println("cart items size = " + cart.getItems().size());
        }
        System.out.println("restaurantId = " + restaurantId);
        System.out.println("user = " + user);
        System.out.println("address param = " + req.getParameter("address"));
        System.out.println("paymentMethod param = " + req.getParameter("paymentMethod"));
        System.out.println("================================");
        // ================= DEBUG END ===================
        
        // user must be logged in
        if (user == null) {
            System.out.println("DEBUG: user is null → redirect to index.jsp");
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }
        
        // cart must exist and have items
        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            System.out.println("DEBUG: cart is null or empty → redirect to cart.jsp");
            resp.sendRedirect("cart.jsp");
            return;
        }
        
        // restaurantId must not be null
        if (restaurantId == null) {
            System.out.println("DEBUG: restaurantId is null → redirect to cart.jsp");
            resp.sendRedirect("cart.jsp");
            return;
        }
        
        String address = req.getParameter("address");
        String paymentMethod = req.getParameter("paymentMethod");
        
        try {
            Order order = new Order();
            order.setRestaurantId(restaurantId.intValue());
            order.setDeliveryAddress(address);
            order.setPaymentMethod(paymentMethod);
            order.setOrderDate(LocalDateTime.now());
            order.setStatus("Pending");
            order.setUserId(user.getUserId());
            
            BigDecimal totalAmount = cart.getTotalPrice();
            order.setTotalAmount(totalAmount);
            
            OrderDAOImpl orderImpl = new OrderDAOImpl();
            long orderId = orderImpl.saveOrder(order);
            order.setOrderId(orderId);
            
            OrderItemDAOImpl orderItemImpl = new OrderItemDAOImpl();
            for (CartItem cartItem : cart.getItems()) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderId(orderId);
                orderItem.setMenuItemId(cartItem.getItemId());
                orderItem.setName(cartItem.getName());
                orderItem.setPrice(cartItem.getPrice());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setSubtotal(cartItem.getSubtotal());
                
                orderItemImpl.saveOrderItem(orderId, orderItem);
            }
            
            session.removeAttribute("cart");
            System.out.println("DEBUG: Order placed successfully → redirect to order_confirm.jsp");
            resp.sendRedirect(req.getContextPath() + "/order_confirm.jsp?orderId=" + orderId);
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG: Exception while placing order → redirect to cart.jsp");
            session.setAttribute("error", "Order placement failed.");
            resp.sendRedirect("cart.jsp");
        }
    }
}
