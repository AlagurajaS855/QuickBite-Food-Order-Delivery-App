package com.Servlet;

import java.io.IOException;
import com.DaoImpl.UsersDAOImpl;
import com.model.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // STEP 1: Print ALL incoming data
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        
        System.out.println("=== SIGNUP DEBUG ===");
        System.out.println("Name: " + name);
        System.out.println("Email: " + email);
        System.out.println("Phone: " + phone);
        System.out.println("Password: " + password);
        
        if (name == null || email == null || password == null) {
            System.out.println("ERROR: Missing form fields!");
            resp.sendRedirect(req.getContextPath() + "/index.jsp?error=missingfields");
            return;
        }
        
        UsersDAOImpl userDao = new UsersDAOImpl();
        
        // STEP 2: Test email exists
        boolean emailExists = userDao.isEmailExists(email);
        System.out.println("Email exists: " + emailExists);
        
        if (emailExists) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp?error=emailexists");
            return;
        }
        
        // STEP 3: Create & test signup
        Users newUser = new Users();
        newUser.setName(name);
        newUser.setEmail(email);
        newUser.setPhone(phone);
        newUser.setPassword(password);
        
        System.out.println("Calling signup()...");
        boolean success = userDao.signup(newUser);
        System.out.println("Signup result: " + success);
        
        if (success) {
            System.out.println("SUCCESS! Auto-login...");
            Users loggedInUser = userDao.login(email, password);
            HttpSession session = req.getSession();
            session.setAttribute("users", loggedInUser);
            resp.sendRedirect(req.getContextPath() + "/index.jsp?success=registered");
        } else {
            System.out.println("FAILED! Check DB connection/table");
            resp.sendRedirect(req.getContextPath() + "/index.jsp?error=signupfailed");
        }
    }
}
