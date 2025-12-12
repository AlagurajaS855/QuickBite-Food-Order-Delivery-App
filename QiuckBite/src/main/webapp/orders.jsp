<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.time.format.DateTimeFormatter" %>
<%@ page import="com.model.Order, com.model.Users" %>

<%
    List<Order> userOrders = (List<Order>) request.getAttribute("userOrders");
    Users user = (Users) session.getAttribute("users");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders | QuickBite</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
          rel="stylesheet">

    <style>
        :root {
            --primary: #ff6b35;
            --primary-dark: #e55a2b;
            --accent-green: #16a34a;
            --bg: #f8fafc;
            --card: #ffffff;
            --border: #e5e7eb;
            --text-main: #111827;
            --text-muted: #6b7280;
            --radius-lg: 18px;
            --radius-md: 12px;
            --shadow: 0 10px 28px rgba(15,23,42,0.08);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--bg);
            color: var(--text-main);
            line-height: 1.6;
        }

        /* Navbar */
        .navbar {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background: rgba(255,255,255,0.98);
            backdrop-filter: blur(16px);
            z-index: 1000;
            padding: 12px 24px;
            box-shadow: 0 2px 16px rgba(15,23,42,0.06);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .back-btn {
            width: 40px;
            height: 40px;
            border-radius: 12px;
            background: #f3f4f6;
            border: none;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-muted);
            font-size: 18px;
            cursor: pointer;
            transition: all 0.15s ease;
        }

        .back-btn:hover {
            background: #fff7ed;
            color: var(--primary);
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .brand-icon {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            background: linear-gradient(135deg, #ffedd5, #fdba74);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #7c2d12;
            font-weight: 800;
            font-size: 18px;
        }

        .brand-text span:first-child {
            font-size: 12px;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.12em;
        }

        .brand-text span:last-child {
            font-size: 18px;
            font-weight: 800;
        }

        .navbar-right {
            display: flex;
            gap: 10px;
        }

        .nav-btn {
            border-radius: 999px;
            border: 1px solid var(--border);
            background: var(--card);
            padding: 6px 12px;
            font-size: 12px;
            color: var(--text-muted);
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.15s ease;
        }

        .nav-btn:hover {
            border-color: var(--primary);
            color: var(--primary);
        }

        /* Main */
        .shell {
            max-width: 1100px;
            margin: 0 auto;
            padding: 80px 20px 40px;
        }

        .header {
            margin-bottom: 32px;
        }

        .header h1 {
            font-size: clamp(26px, 4vw, 32px);
            font-weight: 800;
            margin-bottom: 8px;
        }

        .header p {
            font-size: 14px;
            color: var(--text-muted);
        }

        .filter-row {
            display: flex;
            gap: 10px;
            margin-bottom: 24px;
            flex-wrap: wrap;
        }

        .filter-chip {
            padding: 8px 16px;
            border-radius: 999px;
            border: 1px solid var(--border);
            background: var(--card);
            font-size: 13px;
            color: var(--text-muted);
            font-weight: 500;
            cursor: pointer;
            transition: all 0.15s ease;
        }

        .filter-chip:hover,
        .filter-chip.active {
            border-color: var(--primary);
            background: #fff7ed;
            color: var(--primary);
        }

        /* Orders Grid */
        .orders-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(360px, 1fr));
            gap: 20px;
        }

        .order-card {
            background: var(--card);
            border-radius: var(--radius-lg);
            border: 1px solid var(--border);
            padding: 18px;
            box-shadow: 0 4px 12px rgba(15,23,42,0.06);
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .order-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 28px rgba(15,23,42,0.12);
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 10px;
            margin-bottom: 14px;
        }

        .order-id-date {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .order-id {
            font-size: 14px;
            font-weight: 700;
            color: var(--text-main);
        }

        .order-date {
            font-size: 12px;
            color: var(--text-muted);
        }

        .order-status {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .status-confirmed {
            background: #ecfdf3;
            color: #166534;
        }

        .status-preparing {
            background: #fef3c7;
            color: #92400e;
        }

        .status-on-the-way {
            background: #dbeafe;
            color: #1e40af;
        }

        .status-delivered {
            background: #dcfce7;
            color: #15803d;
        }

        .order-divider {
            height: 1px;
            background: var(--border);
            margin: 12px 0;
        }

        .order-summary {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }

        .order-restaurant {
            font-size: 14px;
            font-weight: 600;
        }

        .order-items-count {
            font-size: 12px;
            color: var(--text-muted);
            background: #f3f4f6;
            padding: 4px 10px;
            border-radius: 999px;
        }

        .order-price {
            font-size: 16px;
            font-weight: 800;
            color: var(--primary);
        }

        .order-address {
            font-size: 12px;
            color: var(--text-muted);
            display: flex;
            align-items: flex-start;
            gap: 6px;
            margin-bottom: 12px;
        }

        .order-address i {
            margin-top: 2px;
            flex-shrink: 0;
        }

        .order-actions {
            display: flex;
            gap: 8px;
            margin-top: 12px;
        }

        .action-btn {
            flex: 1;
            padding: 10px 12px;
            border-radius: 999px;
            border: none;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            transition: all 0.15s ease;
        }

        .btn-primary {
            background: var(--primary);
            color: #ffffff;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
        }

        .btn-outline {
            background: #f3f4f6;
            color: var(--text-main);
            border: 1px solid var(--border);
        }

        .btn-outline:hover {
            background: #fff7ed;
            border-color: var(--primary);
            color: var(--primary);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: var(--card);
            border-radius: var(--radius-lg);
            border: 2px dashed var(--border);
        }

        .empty-icon {
            font-size: 4rem;
            color: #d1d5db;
            margin-bottom: 16px;
        }

        .empty-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .empty-text {
            font-size: 14px;
            color: var(--text-muted);
            margin-bottom: 20px;
        }

        .empty-btn {
            padding: 10px 20px;
            border-radius: 999px;
            border: none;
            background: var(--primary);
            color: #ffffff;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .orders-container {
                grid-template-columns: 1fr;
            }

            .navbar {
                padding: 10px 16px;
            }

            .shell {
                padding: 70px 12px 32px;
            }

            .header h1 {
                font-size: 24px;
            }
        }
    </style>
</head>

<body>
<nav class="navbar">
    <div class="navbar-left">
        <button class="back-btn" onclick="window.location.href='<%= request.getContextPath() %>/index.jsp'">
            <i class="fa-solid fa-arrow-left"></i>
        </button>
        <div class="navbar-brand">
            <div class="brand-icon">Q</div>
            <div class="brand-text">
                <span>Food delivery</span>
                <span>QuickBite</span>
            </div>
        </div>
    </div>

    <div class="navbar-right">
        <button class="nav-btn" onclick="window.location.href='<%= request.getContextPath() %>/cart.jsp'">
            <i class="fa-solid fa-shopping-cart"></i>
            Cart
        </button>
        <button class="nav-btn" onclick="window.location.href='<%= request.getContextPath() %>/profile.jsp'">
            <i class="fa-solid fa-user"></i>
            Profile
        </button>
    </div>
</nav>

<div class="shell">
    <div class="header">
        <h1>My Orders</h1>
        <p>Track and manage all your food orders</p>
    </div>

    <div class="filter-row">
        <button class="filter-chip active">All orders</button>
        <button class="filter-chip">Recent</button>
        <button class="filter-chip">Delivered</button>
        <button class="filter-chip">Cancelled</button>
    </div>

    <%
        if (userOrders != null && !userOrders.isEmpty()) {
    %>

    <div class="orders-container">
        <%
            for (Order order : userOrders) {
                String orderDate = "";
                if (order.getOrderDate() != null) {
                    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");
                    orderDate = order.getOrderDate().format(fmt);
                }

                String statusClass = "status-confirmed";
                String statusLabel = order.getStatus();
                if (statusLabel != null) {
                    if (statusLabel.contains("Delivered")) statusClass = "status-delivered";
                    else if (statusLabel.contains("On the way")) statusClass = "status-on-the-way";
                    else if (statusLabel.contains("Preparing")) statusClass = "status-preparing";
                }
        %>

        <div class="order-card">
            <div class="order-header">
                <div class="order-id-date">
                    <div class="order-id">Order #<%= order.getOrderId() %></div>
                    <div class="order-date"><%= orderDate %></div>
                </div>
                <span class="order-status <%= statusClass %>">
                    <i class="fa-solid fa-circle"></i>
                    <%= statusLabel %>
                </span>
            </div>

            <div class="order-divider"></div>

            <div class="order-summary">
                <div class="order-restaurant">Restaurant Order</div>
                <div class="order-items-count"><%= 1 %> items</div>
            </div>

            <div class="order-price">₹ <%= order.getTotalAmount() %></div>

            <div class="order-address">
                <i class="fa-solid fa-location-dot"></i>
                <span><%= order.getDeliveryAddress() != null ? order.getDeliveryAddress() : "Address not available" %></span>
            </div>

            <div class="order-actions">
                <button class="action-btn btn-primary"
                        onclick="window.location.href='<%= request.getContextPath() %>/order_confirm.jsp?orderId=<%= order.getOrderId() %>'">
                    <i class="fa-solid fa-eye"></i>
                    View details
                </button>
                <button class="action-btn btn-outline"
                        onclick="window.location.href='<%= request.getContextPath() %>/menu?restaurantId=<%= order.getRestaurantId() %>'">
                    <i class="fa-solid fa-redo"></i>
                    Reorder
                </button>
            </div>
        </div>

        <%
            }
        %>
    </div>

    <%
        } else {
    %>

    <div class="empty-state">
        <div class="empty-icon">
            <i class="fa-solid fa-box-open"></i>
        </div>
        <h3 class="empty-title">No orders yet</h3>
        <p class="empty-text">You haven't placed any orders. Start exploring and order your favorite food now!</p>
        <button class="empty-btn" onclick="window.location.href='<%= request.getContextPath() %>/restaurant'">
            <i class="fa-solid fa-utensils"></i>
            Browse Restaurants
        </button>
    </div>

    <%
        }
    %>
</div>

</body>
</html>
