<%@ page import="java.sql.*" %>
<%
String productName = request.getParameter("productName");
String productPrice = request.getParameter("productPrice");
String productDesc = request.getParameter("productDesc");

if (productName == null || productName.trim().isEmpty() || 
    productPrice == null || productPrice.trim().isEmpty() || 
    productDesc == null || productDesc.trim().isEmpty()) {
    out.println("All fields are required.");
    return;
}

try {
    double parsedProductPrice = Double.parseDouble(productPrice);

    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    try (Connection con = DriverManager.getConnection(url, uid, pw);
        PreparedStatement pstmt = con.prepareStatement("INSERT INTO product (productName, productPrice, productDesc, categoryId) VALUES (?, ?, ?, 9)")) {
        pstmt.setString(1, productName);
        pstmt.setDouble(2, parsedProductPrice);
        pstmt.setString(3, productDesc);
        pstmt.executeUpdate();
        out.println("Product added successfully.");
    } catch (SQLException ex) {
        out.println("SQLException: " + ex.getMessage());
        return;
    }
} catch (NumberFormatException ex) {
    out.println("Product price invalid.");
}
%>