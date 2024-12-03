<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<%
String username = request.getParameter("username");
String password = request.getParameter("password");
String retStr = null;

// Error message to display
String loginMessage = null;

// Validate input
if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
    loginMessage = "Username and password cannot be empty.";
} else {
    try {
        getConnection();
        String SQL = "SELECT userid, password FROM customer WHERE userid=? AND password=?";
        PreparedStatement pstmt = con.prepareStatement(SQL);
        pstmt.setString(1, username);
        pstmt.setString(2, password);
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            retStr = rs.getString("userid");
        }
        rs.close();
        pstmt.close();
    } catch (SQLException ex) {
        loginMessage = "Database error occurred. Please try again.";
    } finally {
        closeConnection();
    }
}

if (retStr != null) {
    // Successful login
    session.setAttribute("authenticatedUser", retStr);
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
