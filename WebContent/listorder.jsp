<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Your Shop Grocery Order List</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #fff8e1; /* Light background to complement the gradient header */
        }
        .header {
    background: linear-gradient(135deg, #FF7E00, #FF4500, #FFD700);
    padding: 15px;
    color: white;
    margin-bottom: 20px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    position: relative;
}
.header-content h1 {
    margin: 0;
    font-family: 'Arial Black', sans-serif;
    letter-spacing: 2px;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
    flex: 1; /* Ensures the title stays centered */
    text-align: center; /* Centers the title */
}
        .header h1 {
            text-align: center;
            margin: 0;
            font-family: 'Arial Black', sans-serif;
            letter-spacing: 2px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
        }
        h2 {
            color: #FF4500; /* Vibrant orange to align with the theme */
        }
        p {
            font-size: 16px;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            background: #fff;
        }
        th {
            background: linear-gradient(135deg, #FF7E00, #FF4500);
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
            background-color: #ffebcc; /* Highlight row on hover */
        }
        .error {
            color: red;
            font-weight: bold;
            text-align: center;
            margin: 20px 0;
        }
        .back-button {
    position: absolute;
    left: 15px; /* Aligns the button to the left */
    background: linear-gradient(135deg, #FF7E00, #FF4500);
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 5px;
    cursor: pointer;
    font-size: 16px;
    text-decoration: none;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    transition: background-color 0.3s ease, transform 0.2s ease;
}

.back-button:hover {
    background: #FF4500;
    transform: scale(1.05);
}

.header-content {
    display: flex;
    justify-content: center; /* Center the content in the header */
    align-items: center;    /* Vertically align items */
    position: relative;     /* Allows absolute positioning of the button */
}
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <a href="listprod.jsp" class="back-button">Back</a>
            <h1>Your Shops Order List</h1>
        </div>
    </div>
    
    

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
%>
    <div class="error">Error: <%= e.getMessage() %></div>
<%
    }
%>

</body>
</html>
