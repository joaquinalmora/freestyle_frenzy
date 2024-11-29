<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Your Shop Grocery Order List</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>

<h1>Order List</h1>

<%
    // Database connection variables (use the Docker container alias and credentials from docker-compose.yml)
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String username = "sa";
    String password = "304#sa#pw"; // SQL Server SA password

    try {
        // Load SQL Server driver
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

        // Connect to the database
        try (Connection conn = DriverManager.getConnection(url, username, password)) {

            // SQL query to retrieve order summary with customer name
            String orderQuery = "SELECT os.OrderID, c.firstName + ' ' + c.lastName AS CustomerName, os.OrderDate, os.TotalAmount " +
                                "FROM ordersummary os " +
                                "JOIN customer c ON os.customerId = c.customerId";

            try (Statement stmt = conn.createStatement(); ResultSet orders = stmt.executeQuery(orderQuery)) {

                // Initialize currency formatter
                NumberFormat currFormat = NumberFormat.getCurrencyInstance();

                // Iterate over each order in the result set
                while (orders.next()) {
                    int orderId = orders.getInt("OrderID");
                    String customerName = orders.getString("CustomerName");
                    Date orderDate = orders.getDate("OrderDate");
                    double totalAmount = orders.getDouble("TotalAmount");

                    // Display order summary information in a table format
%>
                    <h2>Order ID: <%= orderId %> - Customer: <%= customerName %> - Date: <%= orderDate %></h2>
                    <p>Total Amount: <%= currFormat.format(totalAmount) %></p>

                    <table>
                        <tr>
                            <th>Product Name</th>
                            <th>Quantity</th>
                            <th>Price</th>
                            <th>Total</th>
                        </tr>
<%
                    // SQL query to retrieve products in each order using PreparedStatement
                    String productQuery = "SELECT p.productName AS ProductName, op.Quantity, op.Price " +
                                          "FROM orderproduct op " +
                                          "JOIN product p ON op.productId = p.productId " +
                                          "WHERE op.OrderID = ?";

                    try (PreparedStatement pstmt = conn.prepareStatement(productQuery)) {
                        pstmt.setInt(1, orderId);
                        try (ResultSet products = pstmt.executeQuery()) {

                            // Iterate over each product in the current order
                            while (products.next()) {
                                String productName = products.getString("ProductName");
                                int quantity = products.getInt("Quantity");
                                double price = products.getDouble("Price");
                                double productTotal = quantity * price;
%>
                        <tr>
                            <td><%= productName %></td>
                            <td><%= quantity %></td>
                            <td><%= currFormat.format(price) %></td>
                            <td><%= currFormat.format(productTotal) %></td>
                        </tr>
<%
                            } // End of products loop
                        }
                    }
%>
                    </table>
                    <br>
<%
                } // End of orders loop
            }
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

</body>
</html>
