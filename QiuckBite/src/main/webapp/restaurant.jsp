<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.util.List,com.model.Restaurant" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>QuickBite — Restaurants</title>

  <!-- Font & Icons -->
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="stylesheet"
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">

  <style>
    :root {
      --primary: #f97316;
      --primary-soft: #fff2e6;
      --primary-dark: #ea580c;
      --bg: #f4f4f5;
      --surface: #ffffff;
      --border: #e4e4e7;
      --text: #18181b;
      --muted: #71717a;
      --radius-lg: 16px;
      --radius-md: 12px;
      --shadow-soft: 0 4px 12px rgba(15, 23, 42, 0.08);
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    body {
      font-family: 'Inter', system-ui, -apple-system, "Segoe UI", Roboto, Arial, sans-serif;
      background: var(--bg);
      color: var(--text);
      overflow-x: hidden;
    }

    a {
      text-decoration: none;
      color: inherit;
    }

    /* Fixed Navbar - Optimized */
    header.top-bar {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      background: #fff;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
      padding: 20px 16px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 12px;
      z-index: 1000;
      backdrop-filter: blur(20px);
    }

    .brand {
      display: flex;
      align-items: center;
      gap: 8px;
      flex-shrink: 0;
    }

    .brand-logo {
      width: 36px;
      height: 36px;
      border-radius: 10px;
      overflow: hidden;
      background: #fff;
      border: 1px solid rgba(0,0,0,0.05);
    }

    .brand-logo img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    .brand-text {
      display: flex;
      flex-direction: column;
    }

    .brand-text span:first-child {
      font-size: 14px;
      font-weight: 600;
    }

    .brand-text span:last-child {
      font-size: 11px;
      color: var(--muted);
    }

    .top-actions {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .pill-btn {
      border-radius: 20px;
      border: 1px solid var(--border);
      background: #fff;
      padding: 8px 12px;
      font-size: 12px;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      cursor: pointer;
      transition: all 0.2s ease;
      font-weight: 500;
      will-change: transform;
    }

    .pill-btn i {
      font-size: 12px;
    }

    .pill-btn:hover {
      border-color: var(--primary);
      color: var(--primary);
      transform: translateY(-1px);
    }

    /* Optimized Search Bar */
    .search-filter-bar {
      flex-grow: 1;
      margin: 0 16px;
      position: relative;
      max-width: 500px;
    }

    .search-filter-bar .search-box {
      width: 100%;
      position: relative;
    }

    .search-filter-bar .search-input {
      width: 100%;
      padding: 12px 16px 12px 40px;
      border-radius: 25px;
      border: 2px solid #f0f0f0;
      background: #fff;
      font-size: 14px;
      outline: none;
      color: var(--text);
      transition: all 0.2s ease;
      will-change: border-color;
    }

    .search-filter-bar .search-input:focus {
      border-color: var(--primary);
      box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.1);
    }

    .search-filter-bar .search-box i {
      position: absolute;
      left: 16px;
      top: 50%;
      transform: translateY(-50%);
      color: var(--muted);
      font-size: 16px;
      pointer-events: none;
    }

    /* Optimized Main Container */
    .shell {
      max-width: 1200px;
      margin: 0 auto;
      padding: 100px 16px 40px;
    }

    /* Filter Chips - Optimized */
    .filter-row {
      display: flex;
      gap: 8px;
      justify-content: flex-start;
      flex-wrap: wrap;
      margin-bottom: 20px;
    }

    .chip {
      border-radius: 20px;
      border: 1px solid var(--border);
      background: #fff;
      padding: 8px 14px;
      font-size: 12px;
      color: var(--muted);
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      transition: all 0.15s ease;
      white-space: nowrap;
      user-select: none;
      font-weight: 500;
      will-change: transform;
    }

    .chip i {
      font-size: 12px;
    }

    .chip:hover {
      border-color: var(--primary);
      color: var(--primary);
      transform: translateY(-1px);
    }

    .chip--active {
      background: var(--primary-soft);
      border-color: var(--primary);
      color: var(--primary);
      font-weight: 600;
    }

    /* Section Header */
    .section-head {
      display: flex;
      align-items: baseline;
      justify-content: space-between;
      margin-bottom: 20px;
      padding-bottom: 12px;
      border-bottom: 1px solid #f0f0f0;
    }

    .section-head h2 {
      font-size: 24px;
      font-weight: 700;
      margin: 0;
    }

    .section-head span {
      font-size: 14px;
      color: var(--muted);
    }

    /* ULTRA FAST RESTAURANT GRID */
    .restaurant-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 24px;
      will-change: contents;
    }

    /* Optimized Card Link */
    .card-link {
      display: block;
      position: relative;
      transition: transform 0.12s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.12s ease;
      will-change: transform, box-shadow;
      transform: translateZ(0);
      backface-visibility: hidden;
    }

    .card-link:hover {
      transform: translateY(-6px);
      box-shadow: 0 20px 40px rgba(0,0,0,0.12);
    }

    .card {
      background: var(--surface);
      border-radius: var(--radius-lg);
      border: 1px solid rgba(0,0,0,0.05);
      overflow: hidden;
      display: flex;
      flex-direction: column;
      height: 100%;
      transition: box-shadow 0.12s ease;
      will-change: box-shadow;
      background: linear-gradient(145deg, #ffffff, #fafafa);
    }

    /* Optimized Card Image */
    .card-cover {
      position: relative;
      width: 100%;
      height: 160px;
      background: linear-gradient(45deg, #f8f9ff, #f0f4ff);
      overflow: hidden;
    }

    .card-cover img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 0.2s cubic-bezier(0.4, 0, 0.2, 1);
      will-change: transform;
    }

    .card-link:hover .card-cover img {
      transform: scale(1.03);
    }

    .badge-time {
      position: absolute;
      left: 12px;
      bottom: 12px;
      border-radius: 20px;
      background: rgba(0,0,0,0.75);
      color: #fff;
      padding: 6px 12px;
      font-size: 12px;
      display: inline-flex;
      align-items: center;
      gap: 4px;
      font-weight: 600;
      backdrop-filter: blur(10px);
    }

    .badge-time i {
      font-size: 11px;
    }

    .card-body {
      padding: 16px;
      display: flex;
      flex-direction: column;
      gap: 8px;
      flex: 1;
    }

    .card-top-row {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      gap: 10px;
    }

    .card-title {
      font-size: 16px;
      font-weight: 700;
      line-height: 1.3;
      color: var(--text);
      margin: 0;
      display: -webkit-box;
      -webkit-line-clamp: 1;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }

    .rating-pill {
      display: inline-flex;
      align-items: center;
      gap: 4px;
      padding: 6px 12px;
      border-radius: 20px;
      background: linear-gradient(135deg, #ecfdf5, #d1fae5);
      color: #059669;
      font-size: 12px;
      font-weight: 700;
    }

    .rating-pill i {
      font-size: 12px;
    }

    .card-meta {
      font-size: 13px;
      color: var(--muted);
      line-height: 1.4;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }

    .card-address {
      margin-top: 4px;
      font-size: 12px;
      color: var(--muted);
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .card-address i {
      font-size: 12px;
      color: var(--primary);
      width: 14px;
    }

    .card-footer-row {
      margin-top: auto;
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding-top: 12px;
      border-top: 1px solid rgba(0,0,0,0.05);
      font-size: 12px;
      color: var(--muted);
    }

    .pill-small {
      border-radius: 20px;
      padding: 4px 10px;
      background: rgba(249, 115, 22, 0.1);
      border: 1px solid rgba(249, 115, 22, 0.2);
      font-weight: 600;
      color: var(--primary);
      font-size: 11px;
    }

    /* Empty State */
    .empty {
      grid-column: 1 / -1;
      margin: 40px 0;
      padding: 40px 24px;
      text-align: center;
      background: linear-gradient(135deg, #fff, #f8fafc);
      border-radius: var(--radius-lg);
      border: 1px solid var(--border);
      color: var(--muted);
      font-size: 16px;
    }

    /* Responsive - Optimized */
    @media (max-width: 768px) {
      .restaurant-grid {
        grid-template-columns: repeat(auto-fill, minmax(100%, 1fr));
        gap: 16px;
      }
      
      header.top-bar {
        padding: 16px 12px;
        flex-direction: column;
        gap: 12px;
      }
      
      .search-filter-bar {
        order: 3;
        width: 100%;
        margin: 0;
      }
      
      .shell {
        padding: 140px 12px 32px;
      }
    }

    /* Performance boost */
    .restaurant-grid > * {
      contain: layout style;
    }
  </style>
</head>
<body>
  <header class="top-bar">
    <a href="index.jsp" class="brand">
      <div class="brand-logo">
        <img src="images/food-logo.jpeg" alt="QuickBite logo" loading="lazy" />
      </div>
      <div class="brand-text">
        <span>QuickBite</span>
        <span>Food delivery</span>
      </div>
    </a>

    <div class="search-filter-bar">
      <div class="search-box">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="search" class="search-input" placeholder="Search restaurants..." />
      </div>
    </div>

    <div class="top-actions">
      <button class="pill-btn" type="button" onclick="location.href='index.jsp'">
        <i class="fa-solid fa-house"></i> Home
      </button>
      <button class="pill-btn" type="button" onclick="location.href='<%= request.getContextPath() %>/cart.jsp'">
        <img src="<%= request.getContextPath() %>/images/shopping-cart.gif"
             alt="Cart" style="width:35px;height:35px;object-fit:contain;">
        Cart
      </button>
      <button class="pill-btn" type="button" onclick="location.href='<%= request.getContextPath() %>/orders'">
        <i class="fa-solid fa-clock-rotate-left"></i> Orders
      </button>
    </div>
  </header>

  <div class="shell">
    <div class="filter-row">
      <button class="chip chip--active">
        <i class="fa-solid fa-sliders"></i> All
      </button>
      <button class="chip">
        <i class="fa-solid fa-star"></i> Rating 4.0+
      </button>
      <button class="chip">
        <i class="fa-solid fa-bolt"></i> Fast Delivery
      </button>
      <button class="chip">
        <i class="fa-solid fa-indian-rupee-sign"></i> Budget
      </button>
    </div>

    <section class="section-head">
      <h2>Restaurants near you</h2>
      <span>Tap to order</span>
    </section>

    <section class="restaurant-grid">
      <%
        List<Restaurant> allRestaurants =
          (List<Restaurant>) request.getAttribute("allRestaurants");

        if (allRestaurants != null && !allRestaurants.isEmpty()) {
          for (Restaurant restaurant : allRestaurants) {
      %>

      <a href="<%= request.getContextPath() %>/menu?restaurantId=<%= restaurant.getRestaurantId() %>"
         class="card-link">
        <article class="card">
          <div class="card-cover">
            <img src="<%= restaurant.getImageUrl() %>" alt="<%= restaurant.getName() %>" loading="lazy">
            <div class="badge-time">
              <i class="fa-regular fa-clock"></i>
              <span>25-35 min</span>
            </div>
          </div>

          <div class="card-body">
            <div class="card-top-row">
              <h3 class="card-title"><%= restaurant.getName() %></h3>
              <span class="rating-pill">
                <i class="fa-solid fa-star"></i>
                <%= restaurant.getRating() %>
              </span>
            </div>

            <p class="card-meta"><%= restaurant.getDescription() %></p>

            <p class="card-address">
              <i class="fa-solid fa-location-dot"></i>
              <%= restaurant.getAddress() %>
            </p>

            <div class="card-footer-row">
              <span class="pill-small">₹₹ • 2.5 km</span>
              <span>Free delivery</span>
            </div>
          </div>
        </article>
      </a>

      <%
          }
        } else {
      %>
      <div class="empty">
        <i class="fa-solid fa-store-slash" style="font-size: 48px; color: #d1d5db; margin-bottom: 16px; display: block;"></i>
        No restaurants available right now.
      </div>
      <% } %>
    </section>
  </div>
</body>
</html>
