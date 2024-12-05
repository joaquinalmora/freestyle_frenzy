<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Freestyle Frenzy Order List</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #fff8e1; /* Subtle warm background */
        }
        .header {
            background: white;
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: center; /* Center content by default */
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            position: relative; /* Enable absolute positioning for child elements */
        }
        .header-content h1 {
            margin: 0;
            font-family: 'Arial Black', sans-serif;
            letter-spacing: 2px;
            color: black;
            text-align: center;
            flex-grow: 1; /* Allows the title to occupy available space */
        }
        .back-button {
            position: absolute;
            left: 20px; /* Adjust for padding consistency */
            top: 50%; /* Center vertically */
            transform: translateY(-50%); /* Adjust for vertical alignment */
            font-family: inherit;
            display: inline-block;
            width: 6em;
            height: 2.6em;
            line-height: 2.5em;
            text-align: center;
            cursor: pointer;
            font-size: 17px;
            color: white;
            background: #000;
            border: 2px solid #000;
            border-radius: 6px;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .back-button:hover {
            color: black;
            background: white;
            border: 2px solid black;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            background: white;
        }
        th {
            background: black;
            color: white;
            font-weight: bold;
            text-align: left;
            padding: 10px;
        }
        td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        tr:nth-child(even) {
            background-color: #fff8e1; /* Subtle alternation for better readability */
        }
        tr:hover {
            background-color: #f4f4f9; /* Highlight row on hover */
        }
        h2 {
            color: black;
            font-family: 'Arial Black', sans-serif;
        }
        .user-info {
            text-align: center;
            font-size: 16px;
            margin-top: 20px;
            color: #333;
        }
    </style>
</head>
<body>
    <div class="header">
        <a href="customer.jsp" class="back-button">Back</a>
        <h1>Your Freestyle Frenzy's Order List</h1>
    </div>

<%
    // Retrieve session attributes
    String currentUser = (String) session.getAttribute("authenticatedUser");
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");

    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String dbUsername = "sa";
    String dbPassword = "304#sa#pw";

    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        try (Connection conn = DriverManager.getConnection(url, dbUsername, dbPassword)) {
            // Determine the SQL query based on the user's role
            String orderQuery;
            if (isAdmin != null && isAdmin) {
                orderQuery = "SELECT os.OrderID, c.firstName + ' ' + c.lastName AS CustomerName, os.OrderDate, os.TotalAmount " +
                             "FROM ordersummary os JOIN customer c ON os.customerId = c.customerId";
            } else {
                orderQuery = "SELECT os.OrderID, c.firstName + ' ' + c.lastName AS CustomerName, os.OrderDate, os.TotalAmount " +
                             "FROM ordersummary os JOIN customer c ON os.customerId = c.customerId WHERE c.userid = ?";
            }

            try (PreparedStatement pstmt = conn.prepareStatement(orderQuery)) {
                if (!(isAdmin != null && isAdmin)) {
                    pstmt.setString(1, currentUser);
                }

                try (ResultSet orders = pstmt.executeQuery()) {
                    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

                    while (orders.next()) {
                        int orderId = orders.getInt("OrderID");
                        String customerName = orders.getString("CustomerName");
                        Date orderDate = orders.getDate("OrderDate");
                        double totalAmount = orders.getDouble("TotalAmount");

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
                        String productQuery = "SELECT p.productName AS ProductName, op.Quantity, op.Price " +
                                              "FROM orderproduct op JOIN product p ON op.productId = p.productId " +
                                              "WHERE op.OrderID = ?";
                        try (PreparedStatement productStmt = conn.prepareStatement(productQuery)) {
                            productStmt.setInt(1, orderId);

                            try (ResultSet products = productStmt.executeQuery()) {
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
                                }
                            }
                        }
%>
                        </table>
                        <br>
<%
                    }
                }
            }
        }
    } catch (Exception e) {
%>
    <div class="error">Error: <%= e.getMessage() %></div>
<%
    }
%>

</body>
</html>
