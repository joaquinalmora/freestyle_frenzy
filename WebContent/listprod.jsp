<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.io.*" %>

<style>
    body {
        margin: 0;
        font-family: Arial, sans-serif;
        background-color: #fff8e1; /* Light background to match the index page */
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

<%@ include file="header.jsp" %>

<div class="cart-container">
    <div class="search-container">
        <form method="get" action="listprod.jsp">
            <input type="text" name="productName" placeholder="Product Name" size="50" value="<%= request.getParameter("productName") != null ? request.getParameter("productName") : "" %>">
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

    <div class="product-cards-container">
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

            NumberFormat currFormat = NumberFormat.getCurrencyInstance();
            while (rst.next()) {
                int productId = rst.getInt("productId");
                String productName = rst.getString("productName");
                double price = rst.getDouble("productPrice");

                String addCartLink = "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + price;
                %>
                <div class="product-card">
                    <div class="product-image">
                        <img src="img/<%= productId %>.jpg" alt="<%= productName %>" />
                    </div>
                    <div class="product-details">
                        <a href="product.jsp?id=<%= productId %>" class="product-name"><%= productName %></a>
                        <p class="product-price"><%= currFormat.format(price) %></p>
                        <a href="<%= addCartLink %>" class="add-to-cart">Add to Cart</a>
                    </div>
                </div>
                <%
            }
        } catch (Exception e) {
            out.println("Exception: " + e);
        }
        %>
    </div>
</div>

<style>
    .product-cards-container {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
        gap: 20px;
        padding: 20px;
    }
    .product-card {
        background: white;
        border: 1px solid #ddd;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        text-align: center;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .product-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
    }
    .product-image img {
        width: 100%;
        height: auto;
    }
    .product-details {
        padding: 15px;
    }
    .product-name {
        font-size: 18px;
        font-weight: bold;
        text-decoration: none;
        color: black;
        display: block;
        margin-bottom: 10px;
    }
    .product-name:hover {
        color: #FF4500;
    }
    .product-price {
        font-size: 16px;
        margin-bottom: 10px;
    }
</style>