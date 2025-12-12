<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.Users" %>
<%
    // Check if user is logged in
    Users loggedInUser = (Users) session.getAttribute("users");
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QuickBite - Order Your Favorite Food</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Poppins', sans-serif;
    background-color: #f5f5f5;
}

/* Navigation Bar */
.navbar {
    position: fixed;
    top: 0;
    width: 100%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 50px;
    background: rgba(0, 0, 0, 0.8);
    backdrop-filter: blur(10px);
    z-index: 1000;
}

.logo {
    display: flex;
    align-items: center;
    gap: 10px;
    color: #ff6b35;
    font-size: 24px;
    font-weight: 700;
}

.logo i {
    font-size: 28px;
}

.nav-links {
    display: flex;
    gap: 30px;
}

.nav-links a {
    color: #fff;
    text-decoration: none;
    font-weight: 500;
    transition: color 0.3s ease;
}

.nav-links a:hover {
    color: #ff6b35;
}

.auth-buttons {
    display: flex;
    gap: 15px;
    align-items: center;
}

.btn {
    padding: 10px 25px;
    border: none;
    border-radius: 25px;
    cursor: pointer;
    font-weight: 600;
    transition: all 0.3s ease;
}

.btn-login {
    background: transparent;
    color: #fff;
    border: 2px solid #ff6b35;
}

.btn-login:hover {
    background: #ff6b35;
}

.btn-signup {
    background: #ff6b35;
    color: #fff;
}

.btn-signup:hover {
    background: #e55a2b;
    transform: translateY(-2px);
}

/* User Profile Button (when logged in) */
.user-profile {
    display: flex;
    align-items: center;
    gap: 10px;
    color: #fff;
    font-weight: 500;
}

.user-profile i {
    font-size: 24px;
    color: #ff6b35;
}

.btn-logout {
    background: transparent;
    color: #fff;
    border: 2px solid #e63946;
    padding: 8px 20px;
}

.btn-logout:hover {
    background: #e63946;
}

.hamburger {
    display: none;
    color: #fff;
    font-size: 24px;
    cursor: pointer;
}

/* Hero Section */
.hero {
    height: 100vh;
    background: url('https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80') center/cover no-repeat;
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
}

.hero-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: linear-gradient(135deg, rgba(0, 0, 0, 0.7) 0%, rgba(0, 0, 0, 0.4) 100%);
}

.hero-content {
    position: relative;
    z-index: 1;
    text-align: center;
    color: #fff;
    max-width: 900px;
    padding: 20px;
}

.hero-content h1 {
    font-size: 48px;
    font-weight: 700;
    margin-bottom: 20px;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
}

.hero-content p {
    font-size: 20px;
    margin-bottom: 40px;
    opacity: 0.9;
}

/* Search Container */
.search-container {
    display: flex;
    flex-wrap: wrap;
    gap: 15px;
    justify-content: center;
    background: rgba(255, 255, 255, 0.95);
    padding: 20px;
    border-radius: 50px;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
}

.search-box {
    display: flex;
    align-items: center;
    background: #f5f5f5;
    padding: 12px 20px;
    border-radius: 30px;
    min-width: 250px;
}

.search-box i {
    color: #ff6b35;
    margin-right: 10px;
}

.search-box input {
    border: none;
    background: transparent;
    outline: none;
    font-size: 14px;
    width: 100%;
}

.btn-search {
    background: linear-gradient(135deg, #ff6b35, #f7931e);
    color: #fff;
    padding: 15px 40px;
    font-size: 16px;
    text-decoration: none;
}

.btn-search:hover {
    transform: translateY(-3px);
    box-shadow: 0 5px 20px rgba(255, 107, 53, 0.4);
}

/* Features Section */
.features {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 30px;
    padding: 80px 50px;
    background: #fff;
}

.feature-card {
    text-align: center;
    padding: 40px 20px;
    border-radius: 15px;
    transition: all 0.3s ease;
    background: #f9f9f9;
}

.feature-card:hover {
    transform: translateY(-10px);
    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
}

.feature-card i {
    font-size: 50px;
    color: #ff6b35;
    margin-bottom: 20px;
}

.feature-card h3 {
    font-size: 20px;
    margin-bottom: 10px;
    color: #333;
}

.feature-card p {
    color: #666;
    font-size: 14px;
}

/* Modal Styles */
.modal {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.7);
    justify-content: center;
    align-items: center;
    z-index: 2000;
}

.modal-content {
    background: #fff;
    padding: 40px;
    border-radius: 20px;
    width: 90%;
    max-width: 450px;
    position: relative;
    animation: slideIn 0.3s ease;
}

@keyframes slideIn {
    from {
        transform: translateY(-50px);
        opacity: 0;
    }
    to {
        transform: translateY(0);
        opacity: 1;
    }
}

.close {
    position: absolute;
    top: 15px;
    right: 20px;
    font-size: 28px;
    cursor: pointer;
    color: #999;
}

.close:hover {
    color: #ff6b35;
}

.modal-content h2 {
    text-align: center;
    margin-bottom: 30px;
    color: #333;
}

.modal-content h2 i {
    color: #ff6b35;
    margin-right: 10px;
}

.form-group {
    margin-bottom: 20px;
}

.form-group label {
    display: block;
    margin-bottom: 8px;
    color: #333;
    font-weight: 500;
}

.form-group input {
    width: 100%;
    padding: 12px 15px;
    border: 2px solid #e0e0e0;
    border-radius: 10px;
    font-size: 14px;
    transition: border-color 0.3s ease;
}

.form-group input:focus {
    outline: none;
    border-color: #ff6b35;
}

.form-options {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    font-size: 14px;
}

.form-options a {
    color: #ff6b35;
    text-decoration: none;
}

.btn-submit {
    width: 100%;
    background: linear-gradient(135deg, #ff6b35, #f7931e);
    color: #fff;
    padding: 15px;
    font-size: 16px;
}

.btn-submit:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 20px rgba(255, 107, 53, 0.4);
}

.switch-form {
    text-align: center;
    margin-top: 20px;
    color: #666;
}

.switch-form a {
    color: #ff6b35;
    text-decoration: none;
    font-weight: 600;
}

/* Error/Success Messages */
.alert {
    padding: 12px 20px;
    border-radius: 8px;
    margin-bottom: 20px;
    text-align: center;
    font-weight: 500;
}

.alert-error {
    background: #ffe6e6;
    color: #d63031;
    border: 1px solid #fab1a0;
}

.alert-success {
    background: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
}

/* Footer */
footer {
    background: #1a1a2e;
    color: #fff;
    padding: 60px 50px 20px;
}

.footer-content {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 40px;
    margin-bottom: 40px;
}

.footer-section h3 {
    color: #ff6b35;
    margin-bottom: 20px;
}

.footer-section h4 {
    margin-bottom: 20px;
}

.footer-section p {
    color: #888;
}

.footer-section a {
    display: block;
    color: #888;
    text-decoration: none;
    margin-bottom: 10px;
    transition: color 0.3s ease;
}

.footer-section a:hover {
    color: #ff6b35;
}

.social-icons {
    display: flex;
    gap: 15px;
}

.social-icons a {
    width: 40px;
    height: 40px;
    background: #333;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s ease;
}

.social-icons a:hover {
    background: #ff6b35;
}

.footer-bottom {
    text-align: center;
    padding-top: 20px;
    border-top: 1px solid #333;
    color: #666;
}

/* Responsive Design */
@media (max-width: 1024px) {
    .features {
        grid-template-columns: repeat(2, 1fr);
    }
    .footer-content {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width: 768px) {
    .navbar {
        padding: 15px 20px;
    }
    .nav-links, .auth-buttons {
        display: none;
    }
    .hamburger {
        display: block;
    }
    .hero-content h1 {
        font-size: 32px;
    }
    .search-container {
        flex-direction: column;
        border-radius: 20px;
    }
    .search-box {
        width: 100%;
    }
    .features {
        grid-template-columns: 1fr;
        padding: 40px 20px;
    }
    .footer-content {
        grid-template-columns: 1fr;
        text-align: center;
    }
    .social-icons {
        justify-content: center;
    }
}
</style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="logo">
            <a href="index.jsp" style="display: flex; align-items: center; gap: 10px; text-decoration: none; color: #ff6b35;">
                <i class="fas fa-utensils"></i>
                <span>QuickBite</span>
            </a>
        </div>
        <div class="nav-links">
            <a href="index.jsp" class="active">Home</a>
            <a href="<%= request.getContextPath() %>/restaurant">Restaurants</a>
            <a href="#menu">Menu</a>
            <a href="#offers">Offers</a>
            <a href="#contact">Contact</a>
        </div>
        
        <div class="auth-buttons">
            <% if (loggedInUser != null) { %>
                <!-- LOGGED IN: Show user name and logout -->
                <div class="user-profile">
                    <i class="fas fa-user-circle"></i>
                    <span>Hi, <%= (loggedInUser != null) ? loggedInUser.getName() : "Guest" %></span>
                </div>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-logout">Logout</a>
            <% } else { %>
                <!-- NOT LOGGED IN: Show login/signup buttons -->
                <button class="btn btn-login" onclick="openModal('loginModal')">Login</button>
                <button class="btn btn-signup" onclick="openModal('signupModal')">Sign Up</button>
            <% } %>
        </div>
        
        <div class="hamburger" onclick="toggleMobileMenu()">
            <i class="fas fa-bars"></i>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero" id="home">
        <div class="hero-overlay"></div>
        <div class="hero-content">
            <% if (loggedInUser != null) { %>
                <h1>Welcome back, <%= loggedInUser.getName() %>!</h1>
            <% } else { %>
                <h1>Delicious Food Delivered To Your Doorstep</h1>
            <% } %>
            <p>Discover the best restaurants and cuisines in your city</p>

            <div class="search-container">
                <div class="search-box">
                    <i class="fas fa-map-marker-alt"></i>
                    <input type="text" placeholder="Enter your delivery address">
                </div>
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" placeholder="Search restaurants or dishes">
                </div>
                <a href="<%= request.getContextPath() %>/restaurant" class="btn btn-search">Find Food</a>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features">
        <div class="feature-card">
            <i class="fas fa-motorcycle"></i>
            <h3>Fast Delivery</h3>
            <p>Get your food delivered in 30 minutes or less</p>
        </div>
        <div class="feature-card">
            <i class="fas fa-store"></i>
            <h3>500+ Restaurants</h3>
            <p>Choose from hundreds of restaurants near you</p>
        </div>
        <div class="feature-card">
            <i class="fas fa-percent"></i>
            <h3>Best Offers</h3>
            <p>Enjoy exclusive deals and discounts daily</p>
        </div>
        <div class="feature-card">
            <i class="fas fa-headset"></i>
            <h3>24/7 Support</h3>
            <p>We're here to help you anytime</p>
        </div>
    </section>

    <!-- ✅ LOGIN MODAL - CONNECTED TO SERVLET -->
    <div id="loginModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal('loginModal')">&times;</span>
            <h2><i class="fas fa-user-circle"></i> Login</h2>
            
            <!-- Error Message -->
            <% if ("invalid".equals(error)) { %>
                <div class="alert alert-error">Invalid email or password!</div>
            <% } %>
            
            <!-- ✅ FORM SUBMITS TO SERVLET -->
            <form action="<%= request.getContextPath() %>/login" method="post">
                <div class="form-group">
                    <label for="loginEmail">Email</label>
                    <input type="email" name="email" id="loginEmail" placeholder="Enter your email" required>
                </div>
                <div class="form-group">
                    <label for="loginPassword">Password</label>
                    <input type="password" name="password" id="loginPassword" placeholder="Enter your password" required>
                </div>
                <div class="form-options">
                    <label><input type="checkbox" name="rememberMe"> Remember me</label>
                    <a href="#">Forgot Password?</a>
                </div>
                <button type="submit" class="btn btn-submit">Login</button>
                <p class="switch-form">Don't have an account? <a href="#" onclick="switchModal('loginModal', 'signupModal')">Sign Up</a></p>
            </form>
        </div>
    </div>

    <!-- ✅ SIGNUP MODAL - CONNECTED TO SERVLET -->
    <div id="signupModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal('signupModal')">&times;</span>
            <h2><i class="fas fa-user-plus"></i> Sign Up</h2>
            
            <!-- Error/Success Messages -->
            <% if ("emailexists".equals(error)) { %>
                <div class="alert alert-error">Email already registered!</div>
            <% } %>
            <% if ("signupfailed".equals(error)) { %>
                <div class="alert alert-error">Signup failed. Please try again!</div>
            <% } %>
            <% if ("registered".equals(success)) { %>
                <div class="alert alert-success">Account created successfully!</div>
            <% } %>
            
            <!-- ✅ FORM SUBMITS TO SERVLET -->
            <form action="<%= request.getContextPath() %>/signup" method="post" onsubmit="return validateSignup()">
                <div class="form-group">
                    <label for="signupName">Full Name</label>
                    <input type="text" name="name" id="signupName" placeholder="Enter your full name" required>
                </div>
                <div class="form-group">
                    <label for="signupEmail">Email</label>
                    <input type="email" name="email" id="signupEmail" placeholder="Enter your email" required>
                </div>
                <div class="form-group">
                    <label for="signupPhone">Phone Number</label>
                    <input type="tel" name="phone" id="signupPhone" placeholder="Enter your phone number" required>
                </div>
                <div class="form-group">
                    <label for="signupPassword">Password</label>
                    <input type="password" name="password" id="signupPassword" placeholder="Create a password" required>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" placeholder="Confirm your password" required>
                </div>
                <button type="submit" class="btn btn-submit">Create Account</button>
                <p class="switch-form">Already have an account? <a href="#" onclick="switchModal('signupModal', 'loginModal')">Login</a></p>
            </form>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <div class="footer-content">
            <div class="footer-section">
                <h3><i class="fas fa-utensils"></i> QuickBite</h3>
                <p>Your favorite food delivery partner</p>
            </div>
            <div class="footer-section">
                <h4>Quick Links</h4>
                <a href="index.jsp">Home</a>
                <a href="<%= request.getContextPath() %>/restaurant">Restaurants</a>
                <a href="#">Partner with Us</a>
            </div>
            <div class="footer-section">
                <h4>Support</h4>
                <a href="#">Help Center</a>
                <a href="#">Terms of Service</a>
                <a href="#">Privacy Policy</a>
            </div>
            <div class="footer-section">
                <h4>Follow Us</h4>
                <div class="social-icons">
                    <a href="#"><i class="fab fa-facebook"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2025 QuickBite. All rights reserved.</p>
        </div>
    </footer>

    <script>
        // Modal Functions
        function openModal(modalId) {
            document.getElementById(modalId).style.display = 'flex';
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }

        function switchModal(closeId, openId) {
            closeModal(closeId);
            openModal(openId);
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                event.target.style.display = 'none';
            }
        }

        // ✅ Password validation only (form submits to servlet)
        function validateSignup() {
            const password = document.getElementById('signupPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            if (password !== confirmPassword) {
                alert('Passwords do not match!');
                return false; // Stop form submission
            }
            return true; // Allow form submission to servlet
        }

        // Auto-open modal if there's an error
        <% if ("invalid".equals(error)) { %>
            openModal('loginModal');
        <% } %>
        <% if ("emailexists".equals(error) || "signupfailed".equals(error)) { %>
            openModal('signupModal');
        <% } %>
    </script>
</body>
</html>
