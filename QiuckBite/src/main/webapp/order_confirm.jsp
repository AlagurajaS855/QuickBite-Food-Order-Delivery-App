<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.math.BigDecimal,java.time.format.DateTimeFormatter" %>
<%@ page import="com.model.Order, com.model.OrderItem, com.model.Users" %>

<%
    String orderIdParam = request.getParameter("orderId");
    long orderId = 0;
    if (orderIdParam != null && !orderIdParam.isEmpty()) {
        orderId = Long.parseLong(orderIdParam);
    }

    com.DaoImpl.OrderDAOImpl orderDao = new com.DaoImpl.OrderDAOImpl();
    com.DaoImpl.OrderItemDAOImpl orderItemDao = new com.DaoImpl.OrderItemDAOImpl();

    Order order = null;
    List<OrderItem> items = Collections.emptyList();
    try {
        order = orderDao.getOrderById(orderId);
        items = orderItemDao.getOrderItemsByOrderId(orderId);
    } catch (Exception e) {
        e.printStackTrace();
    }

    Users user = (Users) session.getAttribute("users");

    BigDecimal itemsTotal = BigDecimal.ZERO;
    if (items != null) {
        for (OrderItem it : items) {
            if (it.getSubtotal() != null) {
                itemsTotal = itemsTotal.add(it.getSubtotal());
            }
        }
    }

    BigDecimal grandTotal = (order != null && order.getTotalAmount() != null)
            ? order.getTotalAmount()
            : itemsTotal;

    String statusText = (order != null && order.getStatus() != null)
            ? order.getStatus()
            : "Order Confirmed";

    String deliveryAddress = (order != null && order.getDeliveryAddress() != null)
            ? order.getDeliveryAddress()
            : "No address available";

    String paymentMethod = (order != null && order.getPaymentMethod() != null)
            ? order.getPaymentMethod()
            : "COD";

    String orderTime = "";
    if (order != null && order.getOrderDate() != null) {
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");
        orderTime = order.getOrderDate().format(fmt);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Confirmed - QuickBite</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        :root {
            --primary: #ff6b35;
            --primary-dark: #e55a2b;
            --accent-green: #16a34a;
            --bg: #f9fafb;
            --card: #ffffff;
            --border: #e5e7eb;
            --text-main: #111827;
            --text-muted: #6b7280;
            --radius-lg: 18px;
            --radius-md: 12px;
            --shadow: 0 18px 45px rgba(15,23,42,0.08);
        }
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: system-ui, -apple-system, BlinkMacSystemFont, "Inter", sans-serif;
        }
        body {
            background: var(--bg);
            color: var(--text-main);
            min-height: 100vh;
        }
        .page-shell {
            max-width: 1100px;
            margin: 0 auto;
            padding: 16px;
        }
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 4px 20px;
        }
        .brand-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .brand-icon {
            width: 40px;
            height: 40px;
            border-radius: 12px;
            background: linear-gradient(135deg, #ffedd5, #fdba74);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #7c2d12;
            font-weight: 800;
            font-size: 20px;
        }
        .brand-text span:first-child {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.14em;
            color: var(--text-muted);
        }
        .brand-text span:last-child {
            font-size: 22px;
            font-weight: 800;
        }
        .order-chip {
            padding: 6px 12px;
            border-radius: 999px;
            border: 1px solid var(--border);
            font-size: 13px;
            background: #f3f4f6;
        }

        .main-card {
            background: var(--card);
            border-radius: 24px;
            box-shadow: var(--shadow);
            padding: 20px;
            border: 1px solid #e5e7eb;
        }
        .main-grid {
            display: grid;
            grid-template-columns: 3fr 2fr;
            gap: 20px;
        }
        @media (max-width: 900px) {
            .main-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Left */
        .status-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 6px;
            gap: 10px;
        }
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 12px;
            border-radius: 999px;
            background: #ecfdf3;
            color: #166534;
            font-size: 12px;
            font-weight: 600;
        }
        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 999px;
            background: #22c55e;
        }
        .status-title {
            margin-top: 4px;
            font-size: clamp(22px, 3vw, 28px);
            font-weight: 800;
        }
        .status-sub {
            font-size: 14px;
            color: var(--text-muted);
            margin-top: 4px;
        }
        .pill-row {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 14px;
        }
        .pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 10px;
            border-radius: 999px;
            font-size: 12px;
            background: #f3f4f6;
            color: var(--text-muted);
        }
        .pill strong {
            color: var(--text-main);
        }

        .timeline-box {
            margin-top: 18px;
            padding: 12px 14px;
            border-radius: var(--radius-md);
            background: #f9fafb;
            border: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
        }
        .timeline-main {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .timeline-icon {
            width: 32px;
            height: 32px;
            border-radius: 10px;
            background: #fee2e2;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #b91c1c;
        }
        .timeline-text span:first-child {
            font-size: 12px;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.14em;
        }
        .timeline-text span:last-child {
            display: block;
            font-size: 13px;
            font-weight: 600;
        }
        .timeline-time {
            font-size: 12px;
            color: var(--text-muted);
        }

        .items-card {
            margin-top: 20px;
            padding: 14px 14px 10px;
            border-radius: var(--radius-md);
            border: 1px solid #e5e7eb;
            background: #ffffff;
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }
        .section-header h3 {
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.14em;
            color: var(--text-muted);
        }
        .section-header span {
            font-size: 12px;
            color: var(--text-muted);
        }
        .items-list {
            max-height: 220px;
            overflow-y: auto;
            padding-right: 4px;
        }
        .item-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            padding: 8px 0;
            border-bottom: 1px dashed #e5e7eb;
        }
        .item-row:last-child {
            border-bottom: none;
        }
        .item-main {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }
        .item-name {
            font-size: 14px;
            font-weight: 600;
        }
        .item-meta {
            font-size: 12px;
            color: var(--text-muted);
        }
        .item-right {
            text-align: right;
            font-size: 13px;
        }
        .item-price {
            font-weight: 600;
        }
        .item-qty {
            color: var(--text-muted);
        }
        .summary-block {
            border-top: 1px solid #e5e7eb;
            margin-top: 8px;
            padding-top: 8px;
            font-size: 13px;
        }
        .summary-line {
            display: flex;
            justify-content: space-between;
            margin-bottom: 3px;
        }
        .summary-line.total {
            margin-top: 4px;
            padding-top: 4px;
            border-top: 1px dashed #d1d5db;
            font-weight: 700;
        }

        /* Right panel */
        .side-panel {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }
        .info-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid #e5e7eb;
            padding: 14px 14px 10px;
        }
        .info-title {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.14em;
            color: var(--text-muted);
            margin-bottom: 6px;
        }
        .address-text {
            font-size: 13px;
            color: var(--text-main);
            line-height: 1.5;
        }
        .address-meta {
            margin-top: 6px;
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            font-size: 12px;
            color: var(--text-muted);
        }
        .address-pill {
            background: #f3f4f6;
            border-radius: 999px;
            padding: 4px 8px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .payment-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 4px;
        }
        .payment-main {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .payment-icon {
            width: 26px;
            height: 26px;
            border-radius: 999px;
            background: #fef3c7;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #92400e;
            font-size: 13px;
        }
        .payment-text {
            font-size: 13px;
        }
        .payment-sub {
            font-size: 11px;
            color: var(--text-muted);
        }
        .payment-amount {
            font-size: 16px;
            font-weight: 700;
        }

        .support-box {
            font-size: 12px;
            color: var(--text-muted);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 8px;
        }
        .support-link {
            padding: 6px 10px;
            border-radius: 999px;
            border: 1px solid #d1d5db;
            font-size: 12px;
            color: var(--text-main);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .cta-row {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 6px;
        }
        .btn-primary {
            flex: 1 1 120px;
            border: none;
            border-radius: 999px;
            padding: 10px 12px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: #ffffff;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        .btn-outline {
            flex: 1 1 120px;
            border-radius: 999px;
            padding: 10px 12px;
            border: 1px solid #d1d5db;
            background: #ffffff;
            color: var(--text-main);
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        @media (max-width: 600px) {
            .main-card {
                padding: 16px;
                border-radius: 18px;
            }
        }
    </style>
</head>
<body>
<div class="page-shell">
    <div class="top-bar">
        <div class="brand-left">
            <div class="brand-icon">Q</div>
            <div class="brand-text">
                <span>Order placed</span>
                <span>QuickBite</span>
            </div>
        </div>

        <!-- Order id + restaurant icon -->
        <div style="display:flex;align-items:center;gap:10px;">
            <div class="order-chip">
                Order ID: <strong>#<%= orderId %></strong>
            </div>
            <button type="button"
                    onclick="window.location.href='<%= request.getContextPath() %>/restaurant'">
                <img src="<%= request.getContextPath() %>/images/catering.gif"
                alt="Cart" style="width:50px;height:50px;object-fit:contain;border-radius: 20%">
                
            </button>
        </div>
    </div>

    <div class="main-card">
        <div class="main-grid">
            <!-- LEFT SIDE -->
            <div>
                <div class="status-row">
                    <div class="status-badge">
                        <span class="status-dot"></span>
                        <span>Order confirmed</span>
                    </div>
                    <span style="font-size:12px;color:var(--text-muted);">
                        <%= orderTime.isEmpty() ? "" : orderTime %>
                    </span>
                </div>
                <h1 class="status-title"><%= statusText %></h1>
                <p class="status-sub">
                    Your order is with the restaurant now. You will get updates as it moves to preparation and out for delivery.
                </p>

                <div class="pill-row">
                    <div class="pill">
                        <i class="fa-solid fa-location-dot" style="color:var(--primary);"></i>
                        <span>Delivering to&nbsp;<strong><%= user != null && user.getName() != null ? user.getName() : "You" %></strong></span>
                    </div>
                    <div class="pill">
                        <i class="fa-solid fa-utensils" style="color:#16a34a;"></i>
                        <span><strong><%= items != null ? items.size() : 0 %></strong>&nbsp;items</span>
                    </div>
                    <div class="pill">
                        <i class="fa-regular fa-clock" style="color:#2563eb;"></i>
                        <span>ETA&nbsp;<strong>30–40 mins</strong></span>
                    </div>
                </div>

                <div class="timeline-box">
                    <div class="timeline-main">
                        <div class="timeline-icon">
                            <i class="fa-solid fa-motorcycle"></i>
                        </div>
                        <div class="timeline-text">
                            <span>Live Status</span>
                            <span>Restaurant is confirming your order</span>
                        </div>
                    </div>
                    <div class="timeline-time">
                        Placed just now
                    </div>
                </div>

                <div class="items-card">
                    <div class="section-header">
                        <h3>Order summary</h3>
                        <span>#<%= orderId %></span>
                    </div>
                    <div class="items-list">
                        <%
                            if (items != null) {
                                for (OrderItem it : items) {
                        %>
                        <div class="item-row">
                            <div class="item-main">
                                <div class="item-name"><%= it.getName() %></div>
                                <div class="item-meta">₹ <%= it.getPrice() %> each</div>
                            </div>
                            <div class="item-right">
                                <div class="item-price">₹ <%= it.getSubtotal() %></div>
                                <div class="item-qty">x<%= it.getQuantity() %></div>
                            </div>
                        </div>
                        <%
                                }
                            }
                        %>
                    </div>
                    <div class="summary-block">
                        <div class="summary-line">
                            <span>Items total</span>
                            <span>₹ <%= itemsTotal %></span>
                        </div>
                        <div class="summary-line">
                            <span>Delivery fee</span>
                            <span>₹ 0</span>
                        </div>
                        <div class="summary-line total">
                            <span>Grand total</span>
                            <span>₹ <%= grandTotal %></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- RIGHT SIDE -->
            <div class="side-panel">
                <div class="info-card">
                    <div class="info-title">Delivery address</div>
                    <div class="address-text">
                        <%= deliveryAddress %>
                    </div>
                    <div class="address-meta">
                        <div class="address-pill">
                            <i class="fa-solid fa-user" style="font-size:11px;"></i>
                            <span><%= user != null && user.getName() != null ? user.getName() : "Guest" %></span>
                        </div>
                        <div class="address-pill">
                            <i class="fa-solid fa-phone" style="font-size:11px;"></i>
                            <span><%= user != null && user.getPhone() != null ? user.getPhone() : "—" %></span>
                        </div>
                    </div>
                </div>

                <div class="info-card">
                    <div class="info-title">Payment</div>
                    <div class="payment-row">
                        <div class="payment-main">
                            <div class="payment-icon">
                                <i class="fa-solid fa-indian-rupee-sign"></i>
                            </div>
                            <div class="payment-text">
                                <div><%= paymentMethod %></div>
                                <div class="payment-sub">Pay on delivery</div>
                            </div>
                        </div>
                        <div class="payment-amount">
                            ₹ <%= grandTotal %>
                        </div>
                    </div>
                </div>

                               <div class="info-card">
                    <div class="info-title">Actions</div>
                    <div style="display:flex;flex-direction:column;gap:8px;">
                        <a href="<%= request.getContextPath() %>/downloadInvoice?orderId=<%= orderId %>"
                           target="_blank"
                           style="padding:10px 12px;border-radius:999px;border:1px solid #d1d5db;background:#ffffff;color:var(--text-main);font-size:13px;font-weight:600;cursor:pointer;display:inline-flex;align-items:center;justify-content:center;gap:6px;text-decoration:none;">
                            <i class="fa-solid fa-file-pdf"></i>
                            Download Invoice
                        </a>
                        <a href="<%= request.getContextPath() %>/support.jsp"
                           style="padding:10px 12px;border-radius:999px;border:1px solid #d1d5db;background:#ffffff;color:var(--text-main);font-size:13px;font-weight:600;cursor:pointer;display:inline-flex;align-items:center;justify-content:center;gap:6px;text-decoration:none;">
                            <i class="fa-regular fa-message"></i>
                            Chat support
                        </a>
                    </div>
                </div>


                <div class="cta-row">
                    <button class="btn-primary"
                            onclick="window.location.href='<%= request.getContextPath() %>/orders'">
                        <i class="fa-solid fa-clock-rotate-left"></i>
                        View all orders
                    </button>
                    <button class="btn-outline"
                            onclick="window.location.href='<%= request.getContextPath() %>/menu?restaurantId=<%= (order != null ? order.getRestaurantId() : 0) %>'">
                        <i class="fa-solid fa-plus"></i>
                        Order again
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
