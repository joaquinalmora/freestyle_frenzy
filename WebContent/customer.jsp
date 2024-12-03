<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
<style>
    body {
        margin: 0;
        font-family: Arial, sans-serif;
        background-color: #fff8e1; /* Subtle warm background */
        color: #333;
    }
    .header {
        background: white;
        padding: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }
    .header-left {
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .header h1 {
        margin: 0;
        font-family: 'Arial Black', sans-serif;
        letter-spacing: 2px;
        color: black;
    }
    .header img {
        height: 50px;
        width: auto;
    }
    .buttons-container {
        display: flex;
        gap: 10px;
    }
    button {
        --color: #000;
        font-family: inherit;
        display: inline-block;
        width: 6em;
        height: 2.6em;
        line-height: 2.5em;
        overflow: hidden;
        cursor: pointer;
        margin: 0;
        font-size: 17px;
        z-index: 1;
        color: white;
        background: var(--color);
        border: 2px solid var(--color);
        border-radius: 6px;
        position: relative;
        transition: all 0.3s ease;
    }
    button:hover {
        color: black;
        background: white;
        border: 2px solid black;
    }
    .container {
        max-width: 800px;
        margin: 20px auto;
        background: #fff;
        padding: 20px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
        border-radius: 10px;
    }
    h3 {
        font-family: 'Arial Black', sans-serif;
        color: black;
    }
    .message {
        font-size: 1.2em;
        margin: 20px 0;
        text-align: center;
    }
    .error {
        color: red;
    }
    .back-button, .change-password-button {
        --color: #000;
        display: inline-block;
        width: 12em;
        height: 2.6em;
        line-height: 2.5em;
        text-align: center;
        text-decoration: none;
        font-size: 17px;
        color: white;
        background: var(--color);
        border: 2px solid var(--color);
        border-radius: 6px;
        transition: all 0.3s ease;
        margin: 10px;
    }
    .back-button:hover, .change-password-button:hover {
        color: black;
        background: white;
        border: 2px solid black;
    }
    table {
        margin: 20px auto;
        border-collapse: collapse;
        width: 100%;
        text-align: left;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }
    th, td {
        padding: 10px;
        border: 1px solid #ddd;
    }
    th {
        background-color: #fff;
        font-weight: bold;
    }
    td {
        background-color: #fff;
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
            <a href="EditAccount.jsp" class="change-password-button">Change Information</a>
            <a href="listorder.jsp" class="change-password-button">Order History</a>
        
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
