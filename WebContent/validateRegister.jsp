<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<%
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String phonenum = request.getParameter("phonenum");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postalCode = request.getParameter("postalCode");
    String country = request.getParameter("country");
    String userid = request.getParameter("userid");
    String password = request.getParameter("password");

    try {
        getConnection();
        String sql = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, firstName);
        pstmt.setString(2, lastName);
        pstmt.setString(3, email);
        pstmt.setString(4, phonenum);
        pstmt.setString(5, address);
        pstmt.setString(6, city);
        pstmt.setString(7, state);
        pstmt.setString(8, postalCode);
        pstmt.setString(9, country);
        pstmt.setString(10, userid);
        pstmt.setString(11, password);
        int rows = pstmt.executeUpdate();

        if (rows > 0) {
            session.setAttribute("registerMessage", "Account successfully created!");
            response.sendRedirect("login.jsp");
        } else {
            session.setAttribute("registerMessage", "Error creating account. Please try again.");
            response.sendRedirect("register.jsp");
        }
    } catch (SQLException e) {
        session.setAttribute("registerMessage", "Database error: " + e.getMessage());
        response.sendRedirect("register.jsp");
    } finally {
        closeConnection();
    }
%>
