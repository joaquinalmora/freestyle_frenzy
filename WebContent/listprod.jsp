<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.net.URLEncoder" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product List</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #fff8e1; /* Light background to match the index page */
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
            gap: 10px; /* Adds space between the text and the image */
        }
        .header h1 {
            margin: 0;
            font-family: 'Arial Black', sans-serif;
            letter-spacing: 2px;
            color: black;
        }
        .header img {
            height: 50px; /* Adjust image size */
            width: auto;
        }
        .buttons-container {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .user-info {
            font-size: 14px;
            color: #333;
            margin-left: 10px;
            font-weight: bold;
        }
        /* Button styling */
        button, .cart-button {
            --color: #000; /* Black color for buttons */
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
            background: var(--color); /* Default: black fill */
            border: 2px solid var(--color); /* Black border */
            border-radius: 6px;
            position: relative;
            text-align: center;
            transition: all 0.3s ease; /* Smooth transitions */
        }

        button:hover, .cart-button:hover {
            color: black; /* Text turns black */
            background: white; /* Button background turns white */
            border: 2px solid black; /* Border stays black */
        }

        .cart-button {
            display: flex;
            justify-content: center;
            align-items: center;
            text-decoration: none;
        }

        .cart-button span {
            font-size: 1.5em; /* Slightly larger icon size */
        }

        .cart-container {
            max-width: 90%;
            margin: 20px auto;
            padding: 20px;
            background: white;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }
        .cart-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        .cart-table th {
            background: white;
            color: black;
            font-weight: bold;
            text-align: left;
            padding: 15px;
            border-bottom: 2px solid black;
        }
        .cart-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .cart-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .cart-table tr:hover {
            background-color: #f0f0f0;
        }
        .add-to-cart {
            --color: #000;
            font-family: inherit;
            display: inline-block;
            width: 6em;
            height: 2.6em;
            line-height: 2.5em;
            overflow: hidden;
            cursor: pointer;
            font-size: 16px;
            z-index: 1;
            color: white;
            background: var(--color);
            border: 2px solid var(--color);
            border-radius: 6px;
            position: relative;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
        }
        .add-to-cart:hover {
            color: black;
            background: white;
            border: 2px solid black;
        }
        .search-container {
            margin: 20px auto;
            text-align: center;
            padding: 10px;
        }
        .search-container input[type="text"],
        .search-container select {
            padding: 10px;
            font-size: 16px;
            border: 2px solid black;
            border-radius: 4px;
            margin-right: 10px;
            outline: none;
            transition: border-color 0.3s ease;
        }
        .search-container input[type="text"]:focus,
        .search-container select:focus {
            border-color: #FF4500;
        }
        .search-container input[type="submit"] {
            --color: #000;
            font-family: inherit;
            display: inline-block;
            width: 8em;
            height: 2.6em;
            line-height: 2.5em;
            overflow: hidden;
            cursor: pointer;
            font-size: 16px;
            z-index: 1;
            color: white;
            background: var(--color);
            border: 2px solid var(--color);
            border-radius: 6px;
            position: relative;
            transition: all 0.3s ease;
        }
        .search-container input[type="submit"]:hover {
            color: black;
            background: white;
            border: 2px solid black;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-left">
            <h1>Freestyle Frenzy</h1>
            <img src="img/Freestyle.png" alt="Freestyle Logo">
        </div>
        <div class="buttons-container">
            <% 
                String currentUser = (String) session.getAttribute("authenticatedUser");
                Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");

                if (currentUser != null) { 
            %>
                <button onclick="location.href='listprod.jsp'">Shop</button>
                <button onclick="location.href='customer.jsp'">Profile</button>

                <% if (isAdmin != null && isAdmin) { %>
                    <button onclick="location.href='admin.jsp'">Admin</button>
                    <button onclick="location.href='listorder.jsp'">All Orders</button>
                <% } %>
                <button onclick="location.href='logout.jsp'">Log out</button>
            <% 
                } else { 
            %>
                <button onclick="location.href='login.jsp'">Login</button>
                <button onclick="location.href='listprod.jsp'">Shop</button>
            <% 
                } 
            %>
            <!-- Shopping cart button -->
            <a href="showcart.jsp" class="cart-button">
                <span>&#128722;</span>
            </a>
            <% if (currentUser != null) { %>
                <span class="user-info">Logged in as: <%= currentUser %></span>
            <% } %>
        </div>
    </div>

    <div class="cart-container">
        <div class="search-container">
            <form method="get" action="listprod.jsp">
                <input type="text" name="productName" placeholder="Product Name" size="50">
                <select name="category">
                    <option value="">All Categories</option>
                    <% 
                    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
                    String uid = "sa";
                    String pw = "304#sa#pw";

                    try {
                        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                        try (Connection con = DriverManager.getConnection(url, uid, pw)) {
                            Statement stmt = con.createStatement(); 
                            ResultSet rst = stmt.executeQuery("SELECT categoryId, categoryName FROM category");
                            while (rst.next()) {
                                String catId = rst.getString(1);
                                String catName = rst.getString(2);
                                %>
                                <option value="<%= catId %>" <%= request.getParameter("category") != null && request.getParameter("category").equals(catId) ? "selected" : "" %>><%= catName %></option>
                                <%
                            }
                        }
                    } catch (Exception e) {
                        out.println("Error: " + e);
                    }
                    %>
                </select>
                <label for="sort">Sort by:</label>
                <select name="sort" id="sort">
                    <option value="default" <%= "default".equals(request.getParameter("sort")) ? "selected" : "" %>>Default</option>
                    <option value="mostSold" <%= "mostSold".equals(request.getParameter("sort")) ? "selected" : "" %>>Most Sold</option>
                </select>
                <input type="submit" value="Search">
            </form>
        </div>

        <%
        String name = request.getParameter("productName");
        String categoryId = request.getParameter("category");
        String sort = request.getParameter("sort");
        if (name == null) name = "";
        if (sort == null) sort = "default";

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (java.lang.ClassNotFoundException e) {
            out.println("ClassNotFoundException: " + e);
        }

        try (Connection con = DriverManager.getConnection(url, uid, pw)) {
            String sql = "SELECT p.productId, p.productName, p.productPrice, SUM(op.quantity) AS totalSold " +
                         "FROM product p " +
                         "LEFT JOIN orderproduct op ON p.productId = op.productId";
            boolean hasWhere = false;

            if (!name.isEmpty() || (categoryId != null && !categoryId.isEmpty())) {
                sql += " WHERE ";
                hasWhere = true;
            }

            if (!name.isEmpty()) {
                sql += "p.productName LIKE ?";
            }

            if (categoryId != null && !categoryId.isEmpty()) {
                if (hasWhere && !name.isEmpty()) {
                    sql += " AND ";
                }
                sql += "p.categoryId = ?";
            }

            sql += " GROUP BY p.productId, p.productName, p.productPrice";

            if ("mostSold".equals(sort)) {
                sql += " ORDER BY totalSold DESC";
            }

            PreparedStatement pstmt = con.prepareStatement(sql);
            int paramIndex = 1;

            if (!name.isEmpty()) {
                pstmt.setString(paramIndex++, "%" + name + "%");
            }
            if (categoryId != null && !categoryId.isEmpty()) {
                pstmt.setString(paramIndex, categoryId);
            }

            ResultSet rst = pstmt.executeQuery();

            %>
            <table class="cart-table">
                <tr>
                    <th>Product Name</th>
                    <th>Price</th>
                    <th>Action</th>
                </tr>
            <%
            NumberFormat currFormat = NumberFormat.getCurrencyInstance();
            while (rst.next()) {
                int productId = rst.getInt("productId");
                String productName = rst.getString("productName");
                double price = rst.getDouble("productPrice");

                String addCartLink = "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + price;
                %>
                <tr>
                    <td><a href="product.jsp?id=<%= productId %>"><%= productName %></a></td>
                    <td><%= currFormat.format(price) %></td>
                    <td><a href="<%= addCartLink %>" class="add-to-cart">Add to Cart</a></td>
                </tr>
                <%
            }
            %>
            </table>
            <%
        } catch (Exception e) {
            out.println("Exception: " + e);
        }
        %>
    </div>
</body>
</html>