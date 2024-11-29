<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Jacob Grocery Order Processing</title>
</head>
<body>

<% 
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if valid customer id was entered
// Determine if there are products in the shopping cart
// If either are not true, display an error message

//Validate that the customer ID is a number and exists in the database
int customerId = -1;
try {
    customerId = Integer.parseInt(custId); // Check if customerId is numeric
} catch (NumberFormatException e) {
    out.println("<p>Error: Invalid customer ID format. Please enter a numeric customer ID.</p>");
    return;
}

if (productList == null || productList.isEmpty()) {
    out.println("<p>Error: Your shopping cart is empty. Please add items before placing an order.</p>");
    return;
}

// SQL Server connection information
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String username = "sa";
String password = "304#sa#pw";

try {
    // Establish database connection
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    try (Connection conn = DriverManager.getConnection(url, username, password)) {

        // Validate that the customer ID exists in the database
        String validateCustomerQuery = "SELECT COUNT(*) AS customerCount FROM customer WHERE customerId = ?";
        try (PreparedStatement custStmt = conn.prepareStatement(validateCustomerQuery)) {
            custStmt.setInt(1, customerId);
            try (ResultSet custResult = custStmt.executeQuery()) {
                custResult.next();
                int customerCount = custResult.getInt("customerCount");

                // If customer ID doesn't exist, display an error and stop further processing
                if (customerCount == 0) {
                    out.println("<p>Error: Customer ID does not exist. Please enter a valid customer ID.</p>");
                    return;
                }
            }
        }

        // Save order information to database

        // Insert into ordersummary table and retrieve auto-generated id
        String orderQuery = "INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (?, GETDATE(), 0)";
        PreparedStatement orderStmt = conn.prepareStatement(orderQuery, Statement.RETURN_GENERATED_KEYS);
        orderStmt.setInt(1, customerId);
        orderStmt.executeUpdate();
        ResultSet keys = orderStmt.getGeneratedKeys();
        keys.next();
        int orderId = keys.getInt(1);

        // Insert each item into OrderProduct table using OrderId from previous INSERT
        // Traverse list of products and store each ordered product in the orderproduct table
        String orderProductQuery = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
        PreparedStatement productStmt = conn.prepareStatement(orderProductQuery);
        double totalAmount = 0.0;
        for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
            ArrayList<Object> product = entry.getValue();
            int productId = Integer.parseInt((String) product.get(0));
            double price = Double.parseDouble((String) product.get(2));
            int quantity = (Integer) product.get(3);

            productStmt.setInt(1, orderId);
            productStmt.setInt(2, productId);
            productStmt.setInt(3, quantity);
            productStmt.setDouble(4, price);
            productStmt.executeUpdate();

            totalAmount += price * quantity;
        }

        // Update total amount for order record
        // Update total amount for the order in OrderSummary table
        String updateOrderTotal = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
        try (PreparedStatement updateStmt = conn.prepareStatement(updateOrderTotal)) {
            updateStmt.setDouble(1, totalAmount);
            updateStmt.setInt(2, orderId);
            updateStmt.executeUpdate();
        }

        // Print out order summary
        // Display order information including all ordered items
        out.println("<h2>Order Placed Successfully</h2>");
        out.println("<p>Order ID: " + orderId + "</p>");
        out.println("<p>Total Amount: " + NumberFormat.getCurrencyInstance().format(totalAmount) + "</p>");
        out.println("<table border='1'><tr><th>Product ID</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Total</th></tr>");
        for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
            ArrayList<Object> product = entry.getValue();
            int productId = Integer.parseInt((String) product.get(0));
            String productName = (String) product.get(1);
            double price = Double.parseDouble((String) product.get(2));
            int quantity = (Integer) product.get(3);
            double total = price * quantity;

            out.println("<tr><td>" + productId + "</td><td>" + productName + "</td><td>" + quantity + "</td><td>" +
                        NumberFormat.getCurrencyInstance().format(price) + "</td><td>" +
                        NumberFormat.getCurrencyInstance().format(total) + "</td></tr>");
        }
        out.println("</table>");

        // Clear cart if order placed successfully
        // Clear the shopping cart (sessional variable) after order has been successfully placed
        session.removeAttribute("productList");

    } // Connection is closed automatically
} catch (Exception e) {
    out.println("<p>Error: " + e.getMessage() + "</p>");
}
%>

</body>
</html>