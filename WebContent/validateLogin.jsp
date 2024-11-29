<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<%
String username = request.getParameter("username");
String password = request.getParameter("password");
String retStr = null;

if(username == null || password == null) {
    out.println("Username or password is null");
    return;
}
if((username.length() == 0) || (password.length() == 0)) {
    out.println("Username or password is empty");
    return;
}

try {
    getConnection();
    // Check if userId and password match some customer account. If so, set retStr to be the username.
    String SQL = "SELECT userid, password FROM customer WHERE userid=? AND password=?";
    PreparedStatement pstmt = con.prepareStatement(SQL);
    pstmt.setString(1, username);
    pstmt.setString(2, password);
    ResultSet rs = pstmt.executeQuery();
    if (rs.next()) {
        String userId = rs.getString("userid");
        retStr = userId;
    }
    rs.close();
    pstmt.close();
} catch (SQLException ex) {
    out.println(ex);
} finally {
    closeConnection();
}

if (retStr != null) {
    session.setAttribute("authenticatedUser", retStr);
    response.sendRedirect("index.jsp");
} else {
    out.println("Invalid username or password");
}
%>