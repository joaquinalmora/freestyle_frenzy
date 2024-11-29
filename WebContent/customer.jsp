<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
<style>
    .message {
        font-size: 1.2em;
        margin: 20px 0;
        text-align: center;
    }
    .error {
        color: red;
    }
    .back-button {
        font-size: 1.2em;
        padding: 10px 20px;
        background-color: #333;
        color: white;
        text-decoration: none;
        border-radius: 5px;
        margin-top: 40px;
        display: block;
        text-align: center;
    }
    .customer-info {
        margin-top: 20px;
        font-size: 1.2em;
        text-align: center;
    }
    table {
        margin: 0 auto;
        border-collapse: collapse;
        width: 50%;
    }
    table, th, td {
        border: 1px solid black;
    }
    th, td {
        padding: 10px;
        text-align: left;
    }
</style>
</head>
<body>

<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
    String userName = (String) session.getAttribute("authenticatedUser");
    if (userName == null) {
%>
    <div class="message error">You must be logged in to access the customer page.</div>
    <a href='index.jsp' class='back-button'>Back</a>
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
    </div>
<%
            } else {
%>
    <div class="message error">No customer information found for the logged-in user.</div>
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

</body>
</html>