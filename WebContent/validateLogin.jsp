<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<%
String username = request.getParameter("username");
String password = request.getParameter("password");
String retStr = null;
boolean isAdmin = false; // Track if the user is an admin
String loginMessage = null;

// Validate input
if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
    loginMessage = "Username and password cannot be empty.";
} else {
    try {
        getConnection();

        // Check if the user is an admin
        String adminSQL = "SELECT username FROM admin WHERE username = ? AND password = ?";
        PreparedStatement adminStmt = con.prepareStatement(adminSQL);
        adminStmt.setString(1, username);
        adminStmt.setString(2, password);
        ResultSet adminRs = adminStmt.executeQuery();

        if (adminRs.next()) {
            // Admin login successful
            retStr = adminRs.getString("username");
            isAdmin = true;
        } else {
            // Check for regular customer
            String customerSQL = "SELECT userid FROM customer WHERE userid = ? AND password = ?";
            PreparedStatement customerStmt = con.prepareStatement(customerSQL);
            customerStmt.setString(1, username);
            customerStmt.setString(2, password);
            ResultSet customerRs = customerStmt.executeQuery();

            if (customerRs.next()) {
                // Customer login successful
                retStr = customerRs.getString("userid");
            }
            customerRs.close();
            customerStmt.close();
        }

        adminRs.close();
        adminStmt.close();
    } catch (SQLException ex) {
        loginMessage = "Database error occurred. Please try again.";
    } finally {
        closeConnection();
    }
}

if (retStr != null) {
    // Successful login
    session.setAttribute("authenticatedUser", retStr);
    session.setAttribute("isAdmin", isAdmin); // Store admin status in the session
    response.sendRedirect("index.jsp");
} else {
    // Failed login
    if (loginMessage == null) {
        loginMessage = "Invalid username or password.";
    }
    session.setAttribute("loginMessage", loginMessage);
    request.getRequestDispatcher("login.jsp").forward(request, response);
}
%>
