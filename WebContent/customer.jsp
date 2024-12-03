<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        background: linear-gradient(135deg, #FF7E00, #FF4500, #FFD700);
        color: #333;
    }
    .container {
        max-width: 800px;
        margin: 20px auto;
        background: #fff;
        padding: 20px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
        border-radius: 10px;
        text-align: center;
    }
    h3 {
        color: #FF4500;
    }
    .message {
        font-size: 1.2em;
        margin: 20px 0;
        text-align: center;
    }
    .error {
        color: red;
    }
    .back-button {
        font-size: 1em;
        padding: 10px 20px;
        background-color: #FF7E00;
        color: white;
        text-decoration: none;
        border-radius: 5px;
        margin: 20px auto;
        display: inline-block;
        transition: background-color 0.3s ease, transform 0.2s ease;
    }
    .back-button:hover {
        background-color: #FF4500;
        transform: scale(1.05);
    }
    .customer-info {
        margin-top: 20px;
        font-size: 1.2em;
    }
    table {
        margin: 20px auto;
        border-collapse: collapse;
        width: 80%;
        text-align: left;
    }
    table, th, td {
        border: 1px solid #ddd;
    }
    th, td {
        padding: 10px;
    }
    th {
        background-color: #FFF7E5;
    }
    td {
        background-color: #FFF7E5;
    }
</style>
</head>
<body>
<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<div class="container">
    <%
    String userName = (String) session.getAttribute("authenticatedUser");
    if (userName == null) {
    %>
        <div class="message error">You must be logged in to access the customer page.</div>
        <a href='index.jsp' class='back-button'>Back to Home</a>
    <%
    } else {
        // Retrieve customer information by ID
        String sql = "SELECT * FROM customer WHERE userid = ?";
        try {
            getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, userName);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
    %>
        <div class="customer-info">
            <h3>Customer Information</h3>
            <table>
                <tr>
                    <th>UserID</th>
                    <td><%= rs.getString("userid") %></td>
                </tr>
                <tr>
                    <th>First Name</th>
                    <td><%= rs.getString("firstName") %></td>
                </tr>
                <tr>
                    <th>Last Name</th>
                    <td><%= rs.getString("lastName") %></td>
                </tr>
                <tr>
                    <th>Email</th>
                    <td><%= rs.getString("email") %></td>
                </tr>
                <tr>
                    <th>Phone</th>
                    <td><%= rs.getString("phonenum") %></td>
                </tr>
                <tr>
                    <th>Address</th>
                    <td><%= rs.getString("address") %></td>
                </tr>
                <tr>
                    <th>City</th>
                    <td><%= rs.getString("city") %></td>
                </tr>
                <tr>
                    <th>State</th>
                    <td><%= rs.getString("state") %></td>
                </tr>
                <tr>
                    <th>Postal Code</th>
                    <td><%= rs.getString("postalCode") %></td>
                </tr>
                <tr>
                    <th>Country</th>
                    <td><%= rs.getString("country") %></td>
                </tr>
            </table>
            <a href="index.jsp" class="back-button">Back to Products</a>
        </div>
    <%
            } else {
    %>
        <div class="message error">No customer information found for the logged-in user.</div>
        <a href="index.jsp" class="back-button">Back to Home</a>
    <%
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            out.println("<div class='message error'>Error retrieving customer information: " + e.getMessage() + "</div>");
        } finally {
            closeConnection();
        }
    }
    %>
</div>
</body>
</html>
