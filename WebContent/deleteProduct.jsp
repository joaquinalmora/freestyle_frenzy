<%@ page import="java.sql.*" %>
<%
String productId = request.getParameter("productId");

if (productId == null || productId.trim().isEmpty()) {
    out.println("Product ID is required.");
    return;
}

try {
    int parsedProductId = Integer.parseInt(productId);

    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        // First, delete all rows in orderproduct, incart and productinventory that reference the product
        try (PreparedStatement pstmt = con.prepareStatement("DELETE FROM orderproduct WHERE productId = ?")) {
            pstmt.setInt(1, parsedProductId);
            pstmt.executeUpdate();
        }
        try (PreparedStatement pstmt = con.prepareStatement("DELETE FROM incart WHERE productId = ?")) {
            pstmt.setInt(1, parsedProductId);
            pstmt.executeUpdate();
        }
        try (PreparedStatement pstmt = con.prepareStatement("DELETE FROM productinventory WHERE productId = ?")) {
            pstmt.setInt(1, parsedProductId);
            pstmt.executeUpdate();
        }

        // Then, delete the product
        try (PreparedStatement pstmt = con.prepareStatement("DELETE FROM product WHERE productId = ?")) {
            pstmt.setInt(1, parsedProductId);
            pstmt.executeUpdate();
        }
        out.println("Product deleted successfully.");
    } catch (SQLException ex) {
        out.println("SQLException: " + ex.getMessage());
        return;
    }
} catch (NumberFormatException ex) {
    out.println("Product ID is invalid.");
}
%>