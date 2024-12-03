<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.net.URLEncoder" %>
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

</style>

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
                            <option value="<%= catId %>"><%= catName %></option>
                            <%
                        }
                    }
                } catch (Exception e) {
                    out.println("Error: " + e);
                }
                %>
            </select>
            <input type="submit" value="Search">
        </form>
    </div>

    <%
    String name = request.getParameter("productName");
    String categoryId = request.getParameter("category");
    if (name == null) name = "";

    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        out.println("ClassNotFoundException: " + e);
    }

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        String sql = "SELECT productId, productName, productPrice FROM product";
        boolean hasWhere = false;

        if (!name.isEmpty() || (categoryId != null && !categoryId.isEmpty())) {
            sql += " WHERE ";
            hasWhere = true;
        }

        if (!name.isEmpty()) {
            sql += "productName LIKE ?";
        }

        if (categoryId != null && !categoryId.isEmpty()) {
            if (hasWhere && !name.isEmpty()) {
                sql += " AND ";
            }
            sql += "categoryId = ?";
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
