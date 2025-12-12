package com.Servlet;

import java.io.IOException;
import java.util.List;

import com.DaoImpl.MenuDAOImpl;
import com.model.Menu;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    private MenuDAOImpl menuDAOImpl;

    @Override
    public void init() throws ServletException {
        menuDAOImpl = new MenuDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
        	
        	 String ridParam = req.getParameter("restaurantId");
             if (ridParam == null || ridParam.isEmpty()) {
                 resp.sendRedirect(req.getContextPath() + "/index.jsp");
                 return;
             }
             
            HttpSession session = req.getSession();

            long restaurantId = Long.parseLong(ridParam);
            
            // Set both session attributes for backward compatibility
            session.setAttribute("restaurantId", restaurantId);
            session.setAttribute("rid", restaurantId);  // Add this line

            // Get menu items only for that restaurant
            List<Menu> allMenuByRestaurant = menuDAOImpl.getAllMenuByRestaurant(restaurantId);

            // Attach list to JSP
            req.setAttribute("allMenuByRestaurant", allMenuByRestaurant);

            // Forward to JSP
            RequestDispatcher rd = req.getRequestDispatcher("menu.jsp");
            rd.forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
