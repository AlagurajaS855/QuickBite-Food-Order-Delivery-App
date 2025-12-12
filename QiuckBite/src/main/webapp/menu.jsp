<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List,com.model.Menu,com.model.Cart" %>
<%
    Cart cart = (Cart) session.getAttribute("cart");
%>
<%
    Long restaurantId = (Long) request.getAttribute("restaurantId");
    if (restaurantId == null) {
        String rid = request.getParameter("restaurantId");
        if (rid != null) {
            try { restaurantId = Long.parseLong(rid); } catch(Exception ex){}
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu | QuickBite</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #ff6b35;
            --primary-dark: #e55a2b;
            --secondary: #2ec4b6;
            --bg: #f8fafc;
            --card-bg: #ffffff;
            --text: #0f172a;
            --text-muted: #6b7280;
            --border: #e5e7eb;
            --shadow: 0 14px 40px rgba(15,23,42,0.10);
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--bg);
            color: var(--text);
            line-height: 1.6;
        }

        /* Navbar */
        .navbar {
            position: fixed;
            top: 0; left: 0; right: 0;
            background: rgba(255,255,255,0.98);
            backdrop-filter: blur(16px);
            z-index: 1000;
            padding: 10px 20px;
            box-shadow: 0 2px 18px rgba(15,23,42,0.06);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .nav-left { display: flex; align-items: center; gap: 12px; }
        .back-btn {
            width: 42px; height: 42px;
            border-radius: 12px;
            background: var(--card-bg);
            border: 1px solid var(--border);
            display: flex; align-items: center; justify-content: center;
            color: var(--text-muted);
            font-size: 18px;
            cursor: pointer;
            transition: all 0.15s ease;
        }
        .back-btn:hover {
            background: #fff7ed;
            color: var(--primary);
            transform: translateY(-1px);
        }
        .cart-icon {
            position: relative;
            width: 42px; height: 42px;
            border-radius: 12px;
            background: var(--card-bg);
            border: 2px solid var(--primary);
            display: flex; align-items: center; justify-content: center;
            color: var(--primary);
            font-size: 18px;
            cursor: pointer;
            transition: all 0.15s ease;
        }
        .cart-icon:hover {
            background: var(--primary);
            color: #ffffff;
            transform: scale(1.03);
        }
        .cart-badge {
            position: absolute;
            top: -4px; right: -4px;
            background: var(--secondary);
            color: #ffffff;
            border-radius: 999px;
            min-width: 20px; height: 20px;
            font-size: 11px;
            font-weight: 700;
            display: flex; align-items: center; justify-content: center;
            padding: 0 4px;
        }

        /* Header */
        .restaurant-header {
            background: linear-gradient(135deg, #fee2e2, #ffedd5);
            padding: 90px 24px 40px;
            text-align: center;
            margin-top: 54px;
            box-shadow: 0 10px 28px rgba(15,23,42,0.08);
        }
        .restaurant-info {
            max-width: 820px;
            margin: 0 auto;
        }
        .restaurant-name {
            font-size: clamp(26px, 4vw, 32px);
            font-weight: 800;
            letter-spacing: -0.02em;
            color: #111827;
        }
        .restaurant-meta {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 14px;
            margin-top: 16px;
            font-size: 13px;
        }
        .meta-item {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 14px;
            border-radius: 999px;
            background: rgba(255,255,255,0.8);
            border: 1px solid rgba(148,163,184,0.4);
            color: var(--text-muted);
        }

        /* Main */
        .main-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 30px 20px 40px;
        }

        /* Category tabs */
        .category-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 24px;
            overflow-x: auto;
            padding-bottom: 6px;
        }
        .tab {
            padding: 8px 18px;
            border-radius: 999px;
            border: 1px solid var(--border);
            background: #ffffff;
            font-size: 13px;
            font-weight: 500;
            color: var(--text-muted);
            white-space: nowrap;
            cursor: pointer;
            transition: all 0.15s ease;
            flex-shrink: 0;
        }
        .tab.active {
            background: var(--primary);
            border-color: var(--primary);
            color: #ffffff;
        }
        .tab:hover {
            border-color: var(--primary);
            color: var(--primary);
        }

        /* Grid */
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0,1fr));
            gap: 20px;
        }
        @media (max-width: 1200px) {
            .menu-grid { grid-template-columns: repeat(3, minmax(0,1fr)); }
        }
        @media (max-width: 900px) {
            .menu-grid { grid-template-columns: repeat(2, minmax(0,1fr)); }
        }
        @media (max-width: 600px) {
            .menu-grid { grid-template-columns: minmax(0,1fr); }
        }

        /* Card */
        .menu-card {
            background: var(--card-bg);
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 8px 24px rgba(15,23,42,0.06);
            display: flex;
            flex-direction: column;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .menu-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 40px rgba(15,23,42,0.12);
        }
        .menu-image {
            position: relative;
            width: 100%;
            height: 150px;
            overflow: hidden;
        }
        .menu-image img {
            width: 100%; height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
        }
        .menu-card:hover .menu-image img {
            transform: scale(1.05);
        }
        .menu-overlay {
            position: absolute;
            inset: auto 0 0 0;
            padding: 14px 16px 12px;
            background: linear-gradient(to top, rgba(0,0,0,0.7), transparent);
            color: #ffffff;
        }
        .menu-name {
            font-size: 15px;
            font-weight: 700;
        }
        .menu-desc {
            font-size: 12px;
            opacity: 0.85;
            margin-top: 2px;
        }

        .menu-content {
            padding: 14px 16px 12px;
            display: flex;
            flex-direction: column;
            gap: 8px;
            flex: 1;
        }
        .menu-price-rating {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .price {
            font-size: 18px;
            font-weight: 800;
            color: var(--primary);
        }
        .rating-badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 4px 10px;
            border-radius: 999px;
            background: #fef3c7;
            font-size: 12px;
            color: #92400e;
        }

        .quantity-selector {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 6px;
        }
        .qty-btn {
            width: 36px; height: 36px;
            border-radius: 12px;
            border: 1px solid var(--border);
            background: #ffffff;
            display: flex; align-items: center; justify-content: center;
            font-size: 18px;
            color: var(--text-muted);
            cursor: pointer;
            transition: all 0.15s ease;
        }
        .qty-btn:hover {
            border-color: var(--primary);
            color: var(--primary);
        }
        .qty-input {
            width: 56px; height: 36px;
            border-radius: 12px;
            border: 1px solid var(--border);
            text-align: center;
            font-size: 14px;
            font-weight: 600;
        }

        .add-to-cart {
            margin-top: 8px;
            padding: 8px 14px;
            border-radius: 999px;
            border: none;
            background: var(--primary);
            color: #ffffff;
            font-size: 13px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            cursor: pointer;
            transition: background-color 0.15s ease, transform 0.15s ease;
        }
        .add-to-cart:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
        }

        .empty-state {
            grid-column: 1 / -1;
            text-align: center;
            padding: 60px 20px;
            background: #ffffff;
            border-radius: 20px;
            border: 2px dashed var(--border);
        }
    </style>
</head>

<body>
<nav class="navbar">
    <div class="nav-left">
        <div class="back-btn"
             onclick="window.location.href='<%= request.getContextPath() %>/restaurant'">
            <i class="fas fa-arrow-left"></i>
        </div>
    </div>
    <div class="cart-icon" onclick="window.location.href='<%= request.getContextPath() %>/cart.jsp'">
        <i class="fas fa-shopping-cart"></i>
        <div class="cart-badge" id="cart-count"><%= cart != null ? cart.getItems().size() : 0 %></div>
    </div>
</nav>

<header class="restaurant-header">
    <div class="restaurant-info">
        <h1 class="restaurant-name">🍽️ Spicy Delights</h1>
        <div class="restaurant-meta">
            <div class="meta-item">
                <i class="fas fa-star"></i><span>4.5 (2.3k)</span>
            </div>
            <div class="meta-item">
                <i class="fas fa-clock"></i><span>25–35 min</span>
            </div>
            <div class="meta-item">
                <i class="fas fa-rupee-sign"></i><span>₹50 delivery</span>
            </div>
        </div>
    </div>
</header>

<main class="main-content">
    <div class="category-tabs">
        <div class="tab active">Recommended</div>
        <div class="tab">Mains</div>
        <div class="tab">Starters</div>
        <div class="tab">Desserts</div>
        <div class="tab">Drinks</div>
    </div>

    <section class="menu-grid">
        <%
            List<Menu> allMenuByRestaurant = (List<Menu>)request.getAttribute("allMenuByRestaurant");
            if (allMenuByRestaurant != null && !allMenuByRestaurant.isEmpty()) {
                for (Menu menu : allMenuByRestaurant) {
        %>
        <article class="menu-card">
            <div class="menu-image">
                <img src="<%= menu.getImage_url() %>" alt="<%= menu.getName1() %>">
                <div class="menu-overlay">
                    <div class="menu-name"><%= menu.getName1() %></div>
                    <div class="menu-desc"><%= menu.getDescription() %></div>
                </div>
            </div>
            <div class="menu-content">
                <div class="menu-price-rating">
                    <div class="price">₹<%= menu.getPrice() %></div>
                    <div class="rating-badge">
                        <i class="fas fa-star"></i>
                        <span><%= menu.getRating() %></span>
                    </div>
                </div>

                <div class="quantity-selector">
                    <button type="button" class="qty-btn qty-minus">-</button>
                    <input type="number" class="qty-input" value="1" min="1" max="10">
                    <button type="button" class="qty-btn qty-plus">+</button>
                </div>

                <form action="<%= request.getContextPath() %>/CartServlet" method="post" class="add-to-cart-form">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="id" value="<%= menu.getId() %>">
                    <input type="hidden" name="name" value="<%= menu.getName1() %>">
                    <input type="hidden" name="price" value="<%= menu.getPrice() %>">
                    <input type="hidden" name="image" value="<%= menu.getImage_url() %>">
                    <input type="hidden" name="restaurantId" value="<%= restaurantId != null ? restaurantId : menu.getRestaurant_id() %>">
                    <input type="hidden" name="quantity" value="1" class="hidden-qty">

                    <button type="submit" class="add-to-cart">
                        <i class="fas fa-cart-plus"></i>
                        Add to Cart
                    </button>
                </form>
            </div>
        </article>
        <%
                }
            } else {
        %>
        <div class="empty-state">
            <i class="fas fa-utensils" style="font-size: 3.5rem; color: var(--text-muted); margin-bottom: 16px;"></i>
            <h3 style="font-size: 1.4rem; margin-bottom: 6px;">No menu items available</h3>
            <p style="color: var(--text-muted); font-size: 0.95rem;">Check back later for delicious food!</p>
        </div>
        <% } %>
    </section>
</main>

<script>
document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.menu-card').forEach(function(card) {
        const minusBtn  = card.querySelector('.qty-minus');
        const plusBtn   = card.querySelector('.qty-plus');
        const qtyInput  = card.querySelector('.qty-input');
        const hiddenQty = card.querySelector('.hidden-qty');

        if (!minusBtn || !plusBtn || !qtyInput || !hiddenQty) return;

        function syncHidden() { hiddenQty.value = qtyInput.value; }

        minusBtn.addEventListener('click', function () {
            let current = parseInt(qtyInput.value || '1', 10);
            const min = parseInt(qtyInput.min || '1', 10);
            if (current > min) {
                qtyInput.value = --current;
                syncHidden();
            }
        });

        plusBtn.addEventListener('click', function () {
            let current = parseInt(qtyInput.value || '1', 10);
            const max = parseInt(qtyInput.max || '10', 10);
            if (current < max) {
                qtyInput.value = ++current;
                syncHidden();
            }
        });

        syncHidden();
    });

    const cartCountEl = document.getElementById('cart-count');
    if (cartCountEl) {
        document.querySelectorAll('.add-to-cart-form').forEach(function(form) {
            form.addEventListener('submit', function () {
                const qty = parseInt(form.querySelector('.hidden-qty').value || '1', 10);
                let current = parseInt(cartCountEl.textContent || '0', 10);
                cartCountEl.textContent = current + qty;
            });
        });
    }
});
</script>
</body>
</html>
