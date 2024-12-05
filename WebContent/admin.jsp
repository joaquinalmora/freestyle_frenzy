<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ include file="header.jsp" %>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #fff8e1;
            margin: 0;
            padding: 0;
            color: #333;
        }

        header {
            background-color: #fff8e1;
            color: white;
            padding: 10px 0;
            text-align: center;
        }

        header nav ul {
            list-style-type: none;
            padding: 0;
            margin: 0;
        }

        header nav ul li {
            font-size: 1.2em;
            margin: 10px 0;
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
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin: 20px auto;
            display: inline-block;
            text-align: center;
            transition: background-color 0.3s ease;
        }

        .back-button:hover {
            background-color: #5a6268;
        }

        h2 {
            text-align: center;
            margin: 20px 0;
            color: #333;
        }

        table {
            border-collapse: collapse;
            width: 90%;
            margin: 20px auto;
            background-color: white;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 5px;
            overflow: hidden;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 12px;
            text-align: center;
            font-size: 1em;
        }

        th {
            background-color: #000000;
            color: white;
            text-transform: uppercase;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .error-message {
            color: #d9534f;
            font-size: 1.2em;
            text-align: center;
            margin: 20px;
        }
    </style>
</head>
<body>
    <header>
        <nav>
            <ul>
                <%
                String userName = (String) session.getAttribute("authenticatedUser");
                if (userName == null) {
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
            out.println("<div class='error-message'>Error retrieving total sales: " + e.getMessage() + "</div>");
        }
    }
    %>
</body>
</html>
