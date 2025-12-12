package com.Servlet;

import java.io.IOException;

import com.DaoImpl.UsersDAOImpl;
import com.model.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        UsersDAOImpl userDao = new UsersDAOImpl();
        Users user = userDao.login(email, password);

        if (user != null) {
            // Login success - store user in session
            HttpSession session = req.getSession();
            session.setAttribute("users", user);
            
            // Redirect to home page
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
        } else {
            // Login failed - redirect back with error
            resp.sendRedirect(req.getContextPath() + "/index.jsp?error=invalid");
        }
    }
}
