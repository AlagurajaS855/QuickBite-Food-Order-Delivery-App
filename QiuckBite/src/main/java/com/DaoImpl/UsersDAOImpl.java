package com.DaoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.DAO.UsersDAO;
import com.model.Users;
import com.util.DBConnection;

public class UsersDAOImpl implements UsersDAO {

    @Override
    public Users login(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password_hash = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Users user = new Users();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setPassword(rs.getString("password_hash"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean signup(Users user) {
        String sql = "INSERT INTO users (full_name, email, phone, password_hash) VALUES (?, ?, ?, ?)";
        
        System.out.println("=== FULL DAO DEBUG ===");
        System.out.println("1. SQL: " + sql);
        System.out.println("2. Name: '" + user.getName() + "'");
        System.out.println("3. Email: '" + user.getEmail() + "'");
        System.out.println("4. Phone: '" + user.getPhone() + "'");
        System.out.println("5. Password: '" + user.getPassword() + "'");
        
        try {
            Connection conn = DBConnection.getConnection();
            System.out.println("6. Connection OK");
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone() != null ? user.getPhone() : "");
            ps.setString(4, user.getPassword());
            
            System.out.println("7. About to execute...");
            int rows = ps.executeUpdate();
            System.out.println("8. ROWS INSERTED: " + rows);
            
            ps.close();
            conn.close();
            return rows > 0;
            
        } catch (SQLException e) {
            System.out.println("🚨 SQL ERROR: " + e.getMessage());
            System.out.println("🚨 Error Code: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        }
    }



    @Override
    public boolean isEmailExists(String email) {
        String sql = "SELECT user_id FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
