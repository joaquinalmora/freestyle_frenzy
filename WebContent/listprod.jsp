<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLEncoder" %>
<%@ include file="header.jsp" %>
<style>
    .cart-container {
        max-width: 90%;
        margin: 0 auto;
        padding: 20px;
    }
    .cart-table {
        width: 100%;
        border-collapse: collapse;
        margin: 20px 0;
        background-color: white;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }
    .cart-table th, .cart-table td {
        padding: 15px 25px;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }
    .cart-table th {
        background-color: #f5f5f5;
        font-size: 1.1em;
    }
    .cart-table tr:hover {
        background-color: #f9f9f9;
    }
    .add-to-cart {
        background-color: #4CAF50;
        color: white;
        padding: 8px 15px;
        border: none;
        border-radius: 4px;
        text-decoration: none;
        display: inline-block;
    }
    .search-container {
        margin: 20px auto;
        text-align: center;
    }
</style>

<div class="cart-container">
    <div class="search-container">
        <form method="get" action="listprod.jsp">
            <input type="text" name="productName" placeholder="Product Name" size="50">
            <select name="category">
                <option value="">All Categories</option>
                <% 
                // Database connection details
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
    // Get the search parameter
    String name = request.getParameter("productName");
    String categoryId = request.getParameter("category");

    if (name == null) name = "";

    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        out.println("ClassNotFoundException: " + e);
    }

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        // Write query to retrieve all product information
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

        // Print table header
        %>
        <table class="cart-table">
            <tr>
                <th>Product Name</th>
                <th>Price</th>
                <th>Action</th>
            </tr>
        <%
        // Parse each product and display
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
