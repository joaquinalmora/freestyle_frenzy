<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ include file="header.jsp" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Admin Page</title>
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
    table {
        border-collapse: collapse;
        width: 80%;
        margin: 0 auto;
    }
    table, th, td {
        border: 1px solid black;
    }
    th, td {
        padding: 10px;
        text-align: center;
    }
</style>
</head>
<body>
    <header>
        <nav>
            <ul style="list-style-type: none; padding: 0;">
                <%
                String userName = (String) session.getAttribute("authenticatedUser");
                if (userName != null) {
                    out.println("<li class='message'>Logged in as: " + userName + "</li>");
                } else {
                    out.println("<li class='message error'>You must be logged in to access the administrator page.</li>");
                }
                %>
            </ul>
        </nav>
    </header>
    <%
    if (userName == null) {
    %>
    <a href='index.jsp' class='back-button'>Back</a>
    <%
    } else {
        NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);

        try {
            getConnection();

            String sql2 = "SELECT CAST(orderDate AS DATE) AS orderDay, SUM(totalAmount) AS totalSales " +
                          "FROM ordersummary " +
                          "GROUP BY CAST(orderDate AS DATE) " +
                          "ORDER BY orderDay";
            Statement stmt2 = con.createStatement();
            ResultSet rs2 = stmt2.executeQuery(sql2);

            out.println("<h2>Total Sales Report</h2>");
            out.println("<table>");
            out.println("<tr><th>Order Date</th><th>Total Order Amount</th></tr>");

            while (rs2.next()) {
                String orderDay = rs2.getString("orderDay");
                double totalSales = rs2.getDouble("totalSales");
                out.println("<tr><td>" + orderDay + "</td><td>" + currFormat.format(totalSales) + "</td></tr>");
            }

            out.println("</table>");

            rs2.close();
            stmt2.close();
            con.close();
        } catch (SQLException e) {
            out.println("<div class='message error'>Error retrieving total sales: " + e.getMessage() + "</div>");
        }
    }
    %>
</body>
</html>