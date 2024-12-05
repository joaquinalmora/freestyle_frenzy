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
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
            color: #333;
        }

        header {
            background-color: #333;
            color: white;
            padding: 10px 0;
            text-align: center;
        }

        .container {
            width: 90%;
            margin: 20px auto;
            display: flex;
            gap: 20px;
        }

        .main-content {
            flex: 3; /* Main content takes 3/4 of the space */
        }

        .sidebar {
            flex: 1; /* Sidebar takes 1/4 of the space */
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .section {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        h2, h3 {
            text-align: center;
            color: #333;
            margin-bottom: 15px;
        }

        .chart-container {
            margin-bottom: 20px;
        }

        #curve_chart {
            width: 100%;
            height: 500px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 10px;
            text-align: center;
        }

        th {
            background-color: #333;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
        }

        input[type="text"], textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        input[type="submit"] {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #218838;
        }

    </style>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script>
    function addProduct() {
        var productName = document.getElementById("productName").value;
        var productPrice = document.getElementById("productPrice").value;
        var productDesc = document.getElementById("productDesc").value;

        var xhr = new XMLHttpRequest();
        xhr.open("POST", "addproduct.jsp", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                document.getElementById("addResult").innerHTML = xhr.responseText;
            }
        };

        xhr.send("productName=" + encodeURIComponent(productName) + "&productPrice=" + encodeURIComponent(productPrice) + "&productDesc=" + encodeURIComponent(productDesc));
    }

    function updateProduct() {
        var productId = document.getElementById("updateProductId").value;
        var productName = document.getElementById("updateProductName").value;
        var productPrice = document.getElementById("updateProductPrice").value;
        var productDesc = document.getElementById("updateProductDesc").value;

        var xhr = new XMLHttpRequest();
        xhr.open("POST", "updateproduct.jsp", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                document.getElementById("updateResult").innerHTML = xhr.responseText;
            }
        };

        xhr.send("productId=" + encodeURIComponent(productId) + "&productName=" + encodeURIComponent(productName) + "&productPrice=" + encodeURIComponent(productPrice) + "&productDesc=" + encodeURIComponent(productDesc));
    }

    function deleteProduct() {
        var productId = document.getElementById("deleteProductId").value;

        var xhr = new XMLHttpRequest();
        xhr.open("POST", "deleteproduct.jsp", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                document.getElementById("deleteResult").innerHTML = xhr.responseText;
            }
        };

        xhr.send("productId=" + encodeURIComponent(productId));
    }
    </script>
</head>
<body>
    <header>
        <h1>Administrator Dashboard</h1>
    </header>
    <div class="container">
        <!-- Main Content -->
        <div class="main-content">
            <!-- Sales Report Section -->
            <div class="section">
                <h2>Total Sales Report</h2>
                <div class="chart-container">
                    <% 
                    out.println("<script type='text/javascript'>");
                    out.println("google.charts.load('current', {'packages':['corechart']});");
                    out.println("google.charts.setOnLoadCallback(drawChart);");
                    out.println("function drawChart() {");
                    out.println("var data = google.visualization.arrayToDataTable([");
                    out.println("['Order Date', 'Total Sales'],");
                    try {
                        getConnection();
                        String sql = "SELECT CAST(orderDate AS DATE) AS orderDay, SUM(totalAmount) AS totalSales " +
                                     "FROM ordersummary GROUP BY CAST(orderDate AS DATE) ORDER BY orderDay";
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);
                        while (rs.next()) {
                            out.println("['" + rs.getString("orderDay") + "', " + rs.getDouble("totalSales") + "],");
                        }
                        rs.close();
                        stmt.close();
                    } catch (SQLException e) {
                        out.println("['Error', 0]");
                    }
                    out.println("]);");
                    out.println("var options = {");
                    out.println("title: 'Sales Report by Day',");
                    out.println("curveType: 'function',");
                    out.println("legend: { position: 'bottom' }");
                    out.println("};");
                    out.println("var chart = new google.visualization.LineChart(document.getElementById('curve_chart'));");
                    out.println("chart.draw(data, options);");
                    out.println("}");
                    out.println("</script>");
                    %>
                    <div id="curve_chart"></div>
                </div>
                <div class="table-container">
                    <% 
                    NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);
                    try {
                        getConnection();
                        String sql2 = "SELECT CAST(orderDate AS DATE) AS orderDay, SUM(totalAmount) AS totalSales " +
                                      "FROM ordersummary " +
                                      "GROUP BY CAST(orderDate AS DATE) " +
                                      "ORDER BY orderDay";
                        Statement stmt2 = con.createStatement();
                        ResultSet rs2 = stmt2.executeQuery(sql2);

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
                        out.println("<p>Error generating sales report: " + e.getMessage() + "</p>");
                    }
                    %>
                </div>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="sidebar">
            <h3>Manage Products</h3>
            <!-- Add Product -->
            <form onsubmit="event.preventDefault(); addProduct();">
                <label for="productName">Product Name:</label>
                <input type="text" id="productName" name="productName" required>

                <label for="productPrice">Product Price:</label>
                <input type="text" id="productPrice" name="productPrice" required>

                <label for="productDesc">Product Description:</label>
                <textarea id="productDesc" name="productDesc" required></textarea>

                <input type="submit" value="Add Product">
            </form>
            <div id="addResult"></div>

            <!-- Update Product -->
            <form onsubmit="event.preventDefault(); updateProduct();">
                <label for="updateProductId">Product ID:</label>
                <input type="text" id="updateProductId" name="productId" required>

                <label for="updateProductName">Product Name:</label>
                <input type="text" id="updateProductName" name="productName">

                <label for="updateProductPrice">Product Price:</label>
                <input type="text" id="updateProductPrice" name="productPrice">

                <label for="updateProductDesc">Product Description:</label>
                <textarea id="updateProductDesc" name="productDesc"></textarea>

                <input type="submit" value="Update Product">
            </form>
            <div id="updateResult"></div>

            <!-- Delete Product -->
            <form onsubmit="event.preventDefault(); deleteProduct();">
                <label for="deleteProductId">Product ID:</label>
                <input type="text" id="deleteProductId" name="productId" required>

                <input type="submit" value="Delete Product">
            </form>
            <div id="deleteResult"></div>
        </div>
    </div>
</body>
</html>