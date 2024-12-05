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
    <title>Jacob Grocery - Order Processing</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #fff8e1; /* Subtle warm background */
        }
        .header {
            background: linear-gradient(135deg, #FF7E00, #FF4500, #FFD700);
            padding: 20px;
            color: white;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .header h1 {
            margin: 0;
            font-family: 'Arial Black', sans-serif;
            letter-spacing: 2px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
        }
        .content-container {
            margin: 40px auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 90%;
            max-width: 800px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #ccc;
        }
        th, td {
            text-align: center;
            padding: 10px;
        }
        th {
            background-color: #FF7E00;
            color: white;
        }
        .button-container {
            text-align: center;
            margin-top: 20px;
        }
        .button {
            display: inline-block;
            font-size: 18px;
            text-decoration: none;
            color: white;
            background: linear-gradient(135deg, #FF7E00, #FF4500);
            padding: 10px 20px;
            border-radius: 5px;
            transition: background-color 0.3s ease, transform 0.2s ease;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            cursor: pointer;
        }
        .button:hover {
            background: #FF4500;
            transform: scale(1.05);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>
<body>

<div class="header">
    <h1>Order Processing</h1>
</div>

<div class="content-container">
<% 
// Processing code (same as provided)
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
int customerId = -1;
try {
    customerId = Integer.parseInt(custId);
} catch (NumberFormatException e) {
    out.println("<p>Error: Invalid customer ID format. Please enter a numeric customer ID.</p>");
    return;
}

if (productList == null || productList.isEmpty()) {
    out.println("<p>Error: Your shopping cart is empty. Please add items before placing an order.</p>");
    return;
}

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String username = "sa";
String password = "304#sa#pw";

try {
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    try (Connection conn = DriverManager.getConnection(url, username, password)) {
        String validateCustomerQuery = "SELECT COUNT(*) AS customerCount FROM customer WHERE customerId = ?";
        try (PreparedStatement custStmt = conn.prepareStatement(validateCustomerQuery)) {
            custStmt.setInt(1, customerId);
            try (ResultSet custResult = custStmt.executeQuery()) {
                custResult.next();
                int customerCount = custResult.getInt("customerCount");
                if (customerCount == 0) {
                    out.println("<p>Error: Customer ID does not exist. Please enter a valid customer ID.</p>");
                    return;
                }
            }
        }

        String orderQuery = "INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (?, GETDATE(), 0)";
        PreparedStatement orderStmt = conn.prepareStatement(orderQuery, Statement.RETURN_GENERATED_KEYS);
        orderStmt.setInt(1, customerId);
        orderStmt.executeUpdate();
        ResultSet keys = orderStmt.getGeneratedKeys();
        keys.next();
        int orderId = keys.getInt(1);

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

        String updateOrderTotal = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
        try (PreparedStatement updateStmt = conn.prepareStatement(updateOrderTotal)) {
            updateStmt.setDouble(1, totalAmount);
            updateStmt.setInt(2, orderId);
            updateStmt.executeUpdate();
        }

        out.println("<h2>Order Placed Successfully</h2>");
        out.println("<p>Order ID: " + orderId + "</p>");
        out.println("<p>Total Amount: " + NumberFormat.getCurrencyInstance().format(totalAmount) + "</p>");
        out.println("<table><tr><th>Product ID</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Total</th></tr>");
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
        session.removeAttribute("productList");
    }
} catch (Exception e) {
    out.println("<p>Error: " + e.getMessage() + "</p>");
}
%>
    <div class="button-container">
        <a href="index.jsp" class="button">Back to Menu</a>
    </div>
</div>

</body>
</html>