<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.model.*,java.math.BigDecimal" %>

<%
    // Cart items stored in session
    Cart cartObj = (Cart) session.getAttribute("cart");
    Collection<CartItem> items = null;
    if(cartObj != null){
        items = cartObj.getItems();  // Collection<CartItem>
    }
    
    BigDecimal totalPrice = BigDecimal.ZERO;
    if (items != null) {
        for (CartItem item : items) {
           totalPrice = totalPrice.add(item.getSubtotal());
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - QuickBite</title>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    
    <style>
        :root {
            --primary: #ff6b35;
            --primary-dark: #e55a2b;
            --primary-light: #ff8a5f;
            --secondary: #1a1a2e;
            --accent: #16213e;
            --bg-primary: #f8fafc;
            --bg-secondary: #ffffff;
            --bg-tertiary: #f1f5f9;
            --text-primary: #0f172a;
            --text-secondary: #64748b;
            --text-light: #94a3b8;
            --border: #e2e8f0;
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            --radius-sm: 8px;
            --radius-md: 12px;
            --radius-lg: 16px;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            line-height: 1.6;
            min-height: 100vh;
        }

        .checkout-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 24px;
        }

        /* Progress Steps */
        .progress-steps {
            display: flex;
            justify-content: center;
            margin-bottom: 40px;
            gap: 24px;
            position: relative;
        }

        .progress-step {
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            z-index: 2;
        }

        .step-number {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--bg-secondary);
            border: 3px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 14px;
            color: var(--text-primary);
            margin-bottom: 8px;
            transition: all 0.3s ease;
        }

        .step-number.active {
            background: var(--primary);
            border-color: var(--primary);
            color: white;
            box-shadow: 0 0 0 4px rgba(255, 107, 53, 0.2);
        }

        .step-label {
            font-size: 14px;
            font-weight: 500;
            color: var(--text-secondary);
        }

        .step-line {
            position: absolute;
            top: 20px;
            left: 60px;
            right: 60px;
            height: 4px;
            background: var(--border);
            z-index: 1;
        }

        .step-line.completed {
            background: var(--primary-light);
        }

        /* Main Content Grid */
        .checkout-grid {
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 32px;
            align-items: start;
        }

        /* Order Summary Card */
        .order-summary-card {
            background: var(--bg-secondary);
            border-radius: var(--radius-lg);
            padding: 32px;
            box-shadow: var(--shadow-lg);
            position: sticky;
            top: 32px;
            height: fit-content;
        }

        .summary-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 2px solid var(--border);
        }

        .summary-icon {
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
        }

        .summary-title {
            font-size: 20px;
            font-weight: 700;
            color: var(--text-primary);
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid var(--border);
        }

        .summary-item:last-child {
            border-bottom: none;
            padding-top: 16px;
            margin-top: 16px;
            font-weight: 700;
            font-size: 24px;
            color: var(--primary-dark);
        }

        .summary-item-name {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
        }

        .summary-item-qty {
            background: var(--bg-tertiary);
            border-radius: 999px;
            padding: 2px 8px;
            font-size: 12px;
            font-weight: 600;
            color: var(--text-secondary);
        }

        /* Items List */
        .items-list {
            max-height: 300px;
            overflow-y: auto;
            margin-bottom: 24px;
        }

        .item-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 0;
            border-bottom: 1px solid var(--border);
        }

        .item-info {
            display: flex;
            align-items: center;
            gap: 12px;
            flex: 1;
        }

        .item-image {
            width: 48px;
            height: 48px;
            border-radius: var(--radius-sm);
            object-fit: cover;
            background: var(--bg-tertiary);
            border: 1px solid var(--border);
        }

        /* Main Form Card */
        .checkout-form-card {
            background: var(--bg-secondary);
            border-radius: var(--radius-lg);
            padding: 40px;
            box-shadow: var(--shadow-lg);
        }

        .form-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .form-title {
            font-size: 32px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 8px;
        }

        .form-subtitle {
            color: var(--text-secondary);
            font-size: 16px;
        }

        /* Form Sections */
        .form-section {
            margin-bottom: 32px;
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
            font-size: 20px;
            font-weight: 600;
            color: var(--text-primary);
        }

        .section-icon {
            width: 44px;
            height: 44px;
            border-radius: var(--radius-md);
            background: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
        }

        /* Form Groups */
        .form-group {
            margin-bottom: 24px;
        }

        .form-label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--text-primary);
            font-size: 15px;
        }

        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid var(--border);
            border-radius: var(--radius-md);
            font-size: 16px;
            font-family: inherit;
            background: var(--bg-secondary);
            transition: all 0.2s ease;
            color: var(--text-primary);
        }

        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(255, 107, 53, 0.1);
        }

        .form-textarea {
            resize: vertical;
            min-height: 120px;
            font-family: inherit;
        }

        /* Payment Options */
        .payment-option {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 20px;
            border: 2px solid var(--border);
            border-radius: var(--radius-md);
            margin-bottom: 16px;
            cursor: pointer;
            transition: all 0.2s ease;
            background: var(--bg-secondary);
        }

        .payment-option:hover {
            border-color: var(--primary);
        }

        .payment-option.selected {
            border-color: var(--primary);
            background: rgba(255, 107, 53, 0.05);
        }

        .payment-radio {
            width: 20px;
            height: 20px;
            accent-color: var(--primary);
        }

        .payment-info {
            flex: 1;
        }

        .payment-title {
            font-weight: 600;
            margin-bottom: 4px;
        }

        /* CTA Button */
        .cta-button {
            width: 100%;
            padding: 20px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            border: none;
            border-radius: var(--radius-lg);
            font-size: 18px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            box-shadow: 0 10px 25px rgba(255, 107, 53, 0.3);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .cta-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 35px rgba(255, 107, 53, 0.4);
        }

        .cta-button:active {
            transform: translateY(0);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 80px 40px;
            color: var(--text-secondary);
        }

        .empty-icon {
            font-size: 64px;
            color: var(--text-light);
            margin-bottom: 24px;
        }

        /* Responsive Design */
        @media (max-width: 1024px) {
            .checkout-grid {
                grid-template-columns: 1fr;
                gap: 24px;
            }
            
            .order-summary-card {
                position: static;
            }
        }

        @media (max-width: 768px) {
            .checkout-container {
                padding: 16px;
            }
            
            .checkout-form-card {
                padding: 24px;
            }
            
            .form-title {
                font-size: 24px;
            }
            
            .progress-steps {
                gap: 16px;
            }
            
            .step-number {
                width: 32px;
                height: 32px;
                font-size: 12px;
            }
            
            .step-line {
                left: 48px;
                right: 48px;
            }
        }

        @media (max-width: 480px) {
            .summary-item:last-child {
                font-size: 20px;
            }
            
            .order-summary-card,
            .checkout-form-card {
                padding: 20px;
            }
        }
    </style>
</head>

<body>
    <div class="checkout-container">
    <div class="back-header" style="margin-bottom: 24px; display: flex; align-items: center; gap: 12px;">
    <a href="<%= request.getContextPath() %>/cart.jsp" class="back-button" style="
        display: flex; 
        align-items: center; 
        gap: 8px; 
        color: var(--text-primary); 
        text-decoration: none; 
        font-weight: 600; 
        font-size: 16px; 
        padding: 12px 16px; 
        border-radius: var(--radius-md); 
        background: rgba(255,255,255,0.7); 
        backdrop-filter: blur(10px); 
        box-shadow: var(--shadow-sm); 
        transition: all 0.2s ease;
        border: 1px solid var(--border);
     " onmouseover="this.style.background='rgba(255,107,53,0.1)'; this.style.borderColor='var(--primary)'" 
       onmouseout="this.style.background='rgba(255,255,255,0.7)'; this.style.borderColor='var(--border)'">
        <i class="fas fa-arrow-left" style="font-size: 14px;"></i>
        Back to Cart
    </a>
</div>
    
        <!-- Progress Steps -->
        <div class="progress-steps">
            <div class="step-line completed"></div>
            <div class="progress-step">
                <div class="step-number active">1</div>
                <div class="step-label">Cart</div>
            </div>
            <div class="progress-step">
                <div class="step-number active">2</div>
                <div class="step-label">Checkout</div>
            </div>
            <div class="progress-step">
                <div class="step-number">3</div>
                <div class="step-label">Payment</div>
            </div>
            <div class="progress-step">
                <div class="step-number">4</div>
                <div class="step-label">Delivery</div>
            </div>
        </div>

        <% if (items == null || items.size() == 0) { %>
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <h3 style="font-size: 24px; margin-bottom: 16px; color: var(--text-primary);">Your cart is empty</h3>
                <p>Add some delicious items to get started with your order!</p>
            </div>
        <% } else { %>
        
        <div class="checkout-grid">
            <!-- Main Checkout Form -->
            <div class="checkout-form-card">
                <div class="form-header">
                    <h1 class="form-title">Complete Your Order</h1>
                    <p class="form-subtitle">Fill in your details to place the order</p>
                </div>

                <form action="<%= request.getContextPath() %>/checkout" method="post">
                    <input type="hidden" name="restaurantId" value="<%= session.getAttribute("restaurantId") %>">
                    
                    <!-- Delivery Address Section -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-map-marker-alt"></i>
                            </div>
                            <span>Delivery Address</span>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="address">Where should we deliver?</label>
                            <textarea 
                                id="address"
                                name="address" 
                                class="form-textarea" 
                                placeholder="Enter your full address (street, city, pincode, landmark)"
                                required></textarea>
                        </div>
                    </div>

                    <!-- Payment Method Section -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-credit-card"></i>
                            </div>
                            <span>Payment Method</span>
                        </div>
                        
                        <div class="payment-option selected">
                            <input type="radio" id="cod" name="paymentMethod" value="COD" class="payment-radio" checked required>
                            <div class="payment-info">
                                <div class="payment-title">Cash on Delivery</div>
                                <div style="font-size: 14px; color: var(--text-secondary);">Pay when your food arrives</div>
                            </div>
                        </div>
                        
                        <div class="payment-option">
                            <input type="radio" id="upi" name="paymentMethod" value="UPI" class="payment-radio" required>
                            <div class="payment-info">
                                <div class="payment-title">UPI</div>
                                <div style="font-size: 14px; color: var(--text-secondary);">Pay using PhonePe, Google Pay, Paytm</div>
                            </div>
                        </div>
                        
                        <div class="payment-option">
                            <input type="radio" id="card" name="paymentMethod" value="CARD" class="payment-radio" required>
                            <div class="payment-info">
                                <div class="payment-title">Credit/Debit Card</div>
                                <div style="font-size: 14px; color: var(--text-secondary);">Visa, Mastercard, Rupay</div>
                            </div>
                        </div>
                    </div>

                    <!-- CTA Button -->
                    
                    <button type="submit" class="cta-button">
                        <i class="fas fa-arrow-right"></i>
                        Place Order - ₹ <%= totalPrice %>
                    </button>
                </form>
            </div>

            <!-- Order Summary -->
            <div class="order-summary-card">
                <div class="summary-header">
                    <div class="summary-icon">
                        <i class="fas fa-receipt"></i>
                    </div>
                    <div class="summary-title">Order Summary</div>
                </div>

                <div class="items-list">
                    <% for (CartItem item : items) { %>
                        <div class="item-row">
                            <div class="item-info">
                                <div class="item-image" style="background-image: url('<%= item.getImage() %>'); background-size: cover; background-position: center;"></div>
                                <div>
                                    <div style="font-weight: 600; margin-bottom: 4px;"><%= item.getName() %></div>
                                    <div style="font-size: 14px; color: var(--text-secondary);">₹ <%= item.getPrice() %></div>
                                </div>
                            </div>
                            <div style="text-align: right;">
                                <div style="font-weight: 600;">₹ <%= item.getSubtotal() %></div>
                                <span class="summary-item-qty">x<%= item.getQuantity() %></span>
                            </div>
                        </div>
                    <% } %>
                </div>

                <div class="summary-item">
                    <span>Total</span>
                    <span>₹ <%= totalPrice %></span>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</body>
</html>
