<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.Cart, com.model.CartItem, java.util.*" %>
<%
    Cart cart = (Cart) session.getAttribute("cart");
%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Your Cart - QuickBite</title>

    <!-- Font Awesome for icons (trash, credit card, etc.) -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        :root {
            --primary: #ff6b35;
            --primary-dark: #e55a2b;
            --bg: #f8f9fa;
            --surface: #fff;
            --text-main: #1a1a2e;
            --text-muted: #777;
            --border-gray: #dee2e6;
            --radius-md: 12px;
            --shadow-light: 0 4px 20px rgba(0,0,0,0.05);
        }
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Inter', sans-serif;
        }
        body {
            background: var(--bg);
            color: var(--text-main);
            min-height: 100vh;
        }
        /* Fixed Top Cart Header */
        .cart-header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background: var(--surface);
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
            padding: 20px 24px;
            z-index: 100;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .cart-title {
            font-weight: 800;
            font-size: 1.8rem;
            color: var(--text-main);
        }
        
        main.container {
            max-width: 960px;
            margin: 0 auto;
            padding: 140px 20px 40px;
        }
        a {
            text-decoration: none;
            color: var(--primary);
            font-weight: 600;
        }
        a:hover {
            text-decoration: underline;
        }
        table.cart-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 16px;
            margin-bottom: 24px;
        }
        table.cart-table thead th {
            border-bottom: 2px solid var(--border-gray);
            padding-bottom: 12px;
            font-weight: 700;
            color: var(--text-main);
            text-align: left;
            font-size: 1.1rem;
        }
        table.cart-table tbody tr {
            background: var(--surface);
            box-shadow: var(--shadow-light);
            border-radius: var(--radius-md);
            transition: box-shadow 0.3s ease;
        }
        table.cart-table tbody tr:hover {
            box-shadow: 0 8px 24px rgba(255, 107, 53, 0.25);
        }
        table.cart-table td {
            padding: 20px 16px;
            vertical-align: middle;
            font-size: 1rem;
            color: var(--text-main);
        }
        td.item-img-name {
            display: flex;
            align-items: center;
            gap: 16px;
        }
        td.item-img-name img {
            width: 90px;
            height: 60px;
            border-radius: var(--radius-md);
            object-fit: cover;
            box-shadow: 0 2px 8px rgba(0,0,0,0.12);
            transition: transform 0.3s ease;
        }
        td.item-img-name img:hover {
            transform: scale(1.05);
        }
        td.item-img-name strong {
            font-weight: 700;
            font-size: 1.15rem;
        }
        td.price, td.subtotal {
            color: var(--primary);
            font-weight: 700;
            font-size: 1.1rem;
            white-space: nowrap;
        }
        td.qty-form input[type="number"] {
            width: 60px;
            padding: 8px 10px;
            border-radius: 8px;
            border: 1.5px solid var(--border-gray);
            font-size: 1rem;
            color: var(--text-main);
            text-align: center;
            transition: border-color 0.25s;
        }
        td.qty-form input[type="number"]:focus {
            border-color: var(--primary);
            outline: none;
        }
        td.qty-form button {
            margin-left: 12px;
            background: var(--primary);
            border: none;
            color: white;
            font-weight: 700;
            padding: 8px 16px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 0.95rem;
            transition: background 0.3s ease;
        }
        td.qty-form button:hover {
            background: var(--primary-dark);
        }
        td.action-form button {
            background: transparent;
            border: none;
            color: #e63946;
            font-weight: 700;
            font-size: 1.3rem;
            cursor: pointer;
            transition: color 0.3s ease;
            padding: 4px;
        }
        td.action-form button:hover {
            color: #b71c1c;
        }
        
        .th-qty,.th-price{
        text-align: center;       
        padding-left: 24px; 
        }
        /* + Add More Items - simple text link under items */
        .add-more-items {
            display: inline-block;
            margin: 24px 0 32px 16px;
            font-weight: 700;
            font-size: 1.15rem;
            color: var(--primary);
            cursor: pointer;
            transition: color 0.3s ease;
        }
        .add-more-items:hover {
            color: var(--primary-dark);
        }
        /* Simple Total line - right aligned under items */
        .total-line {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 12px;
            margin: 32px 0 24px;
            font-size: 1.5rem;
            font-weight: 900;
            color: var(--primary-dark);
        }
        .total-label {
            font-size: 1.3rem;
        }
        .total-amount {
            font-size: 1.8rem;
            color: var(--primary);
        }
        .checkout-container {
            text-align: center;
            margin-top: 24px;
            margin-left:520px;
        }
        .checkout-container form button {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            border: none;
            border-radius: var(--radius-md);
            color: white;
            font-size: 1.10rem;
            font-weight: 500;
            padding: 15px 30px;
            cursor: pointer;
            box-shadow: 0 12px 32px rgba(255,107,53,0.5);
            transition: all 0.3s ease;
            width: 100%;
            max-width: 400px;
        }
        .checkout-container form button:hover {
            transform: translateY(-3px);
            box-shadow: 0 18px 42px rgba(255,107,53,0.7);
        }
        .empty-state {
            text-align: center;
            padding: 80px 40px;
            color: var(--text-muted);
            font-size: 1.2rem;
        }
        /* Responsive */
        @media (max-width: 768px) {
            .cart-header {
                padding: 16px 20px;
            }
            .cart-title {
                font-size: 1.5rem;
            }
            main.container {
                padding: 120px 16px 32px;
            }
            td.item-img-name {
                flex-direction: column;
                align-items: flex-start;
                gap: 12px;
            }
            td.item-img-name img {
                width: 100%;
                max-width: 80px;
                height: 55px;
            }
            td.qty-form input[type="number"] {
                width: 50px;
            }
            td.qty-form button {
                padding: 6px 12px;
                font-size: 0.9rem;
            }
            .total-line {
                flex-direction: column;
                gap: 8px;
                text-align: center;
            }
        }
    </style>
</head>
<body>

<header class="cart-header">
    <div class="cart-title">Your Cart</div>
</header>

<main class="container">

<% if (cart == null || cart.isEmpty()) { %>
    <div class="empty-state">
        Your cart is empty. <a href="<%= request.getContextPath() %>/menu?restaurantId=<%= session.getAttribute("rid") %>">+ Add More Items</a>
    </div>
<% } else { %>

    <table class="cart-table" role="grid" aria-label="Shopping cart items">
        <thead>
            <tr>
                <th scope="col">Item</th>
                <th scope="col" class="th-price">Price</th>
                <th scope="col" class="th-qty">Qty</th>
                <th scope="col">Subtotal</th>
                <th scope="col">Action</th>
            </tr>
        </thead>
        <tbody>
        <% for (CartItem item : cart.getItems()) { %>
            <tr>
                <td class="item-img-name">
                    <img src="<%= item.getImage() %>" alt="<%= item.getName() %>" />
                    <strong><%= item.getName() %></strong>
                </td>
                <td class="price">₹ <%= item.getPrice() %></td>
                <td class="qty-form">
                    <form action="<%= request.getContextPath() %>/CartServlet" method="post" style="display:inline-flex; align-items:center;">
                        <input type="hidden" name="action" value="update" />
                        <input type="hidden" name="id" value="<%= item.getItemId() %>" />
                        <input type="number" name="quantity" value="<%= item.getQuantity() %>" min="1" aria-label="Quantity for <%= item.getName() %>"/>
                        <button type="submit" aria-label="Update quantity for <%= item.getName() %>">Update</button>
                    </form>
                </td>
                <td class="subtotal">₹ <%= item.getSubtotal() %></td>
                <td class="action-form">
                    <form action="<%= request.getContextPath() %>/CartServlet" method="post" onsubmit="return confirm('Remove item?');" aria-label="Remove <%= item.getName() %> from cart">
                        <input type="hidden" name="action" value="delete" />
                        <input type="hidden" name="id" value="<%= item.getItemId() %>" />
                        <button type="submit" title="Remove">
                            <i class="fas fa-trash-alt" aria-hidden="true"></i>
                        </button>
                    </form>
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>

    <a href="<%= request.getContextPath() %>/menu?restaurantId=<%= session.getAttribute("rid") %>" class="add-more-items">+ Add More Items</a>

    <div class="total-line" role="region" aria-label="Cart total">
        <span class="total-label">Total:</span>
        <span class="total-amount">₹ <%= cart.getTotalPrice() %></span>
    </div>

    <div class="checkout-container">
        <form action="checkout.jsp" method="get">
            <button type="submit" aria-label="Proceed to checkout">
                Proceed to Checkout <i class="fas fa-credit-card"></i>
            </button>
        </form>
    </div>

<% } %>
</main>

</body>
</html>
