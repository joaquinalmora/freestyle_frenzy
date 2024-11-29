<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Product Information</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 20px;
        background-color: #f4f4f4;
        text-align: center;
    }
    .container {
        max-width: 800px;
        margin: 0 auto;
        background: #fff;
        padding: 20px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    h2, h4 {
        color: #333;
    }
    .button {
        display: inline-block;
        padding: 10px 20px;
        font-size: 1em;
        color: #fff;
        background-color: #007bff;
        text-decoration: none;
        border-radius: 5px;
        text-align: center;
        margin-top: 20px;
    }
    .button:hover {
        background-color: #0056b3;
    }
</style>
</head>
<body>
<%@ include file="header.jsp" %>
<div class="container">
    <%
    // Get product ID to search for
    String prodid = request.getParameter("id");

    // Load driver class
    try {   
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        out.println("ClassNotFoundException: " +e);
    }

    // Make the connection
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True;";
    String uid = "sa";
    String pw = "304#sa#pw"; 
    Connection con = DriverManager.getConnection(url, uid, pw);

    String sql = "SELECT productName, productImageURL, productImage, productPrice FROM Product P WHERE productId = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setInt(1, Integer.parseInt(prodid));
    ResultSet rst = pstmt.executeQuery();
    
    if(rst.next()) {
        // Display product name
        String name = rst.getString("productName");
        out.println("<h2>"+name+"</h2>");

        // If there is a productImageURL, display using IMG tag
        String imageUrl = rst.getString("productImageURL");
        if(imageUrl != null && !imageUrl.isEmpty()) {
            out.println("<p><img height=250px src=\"" + imageUrl + "\"></p>");
        }

        // Display product details
        out.println("<h4><b>Product ID:</b> "+prodid+"</h4>");
        out.println("<h4><b>Price:</b> $"+rst.getString("productPrice")+"</h4>");

        // Add links to Add to Cart and Continue Shopping
        out.println("<a href=\"addcart.jsp?id=" + prodid + "&name=" + name + "&price=" + rst.getString("productPrice") + "&newqty=1" + "\" class=\"button\">Add to cart</a>");
        out.println("<a href='listprod.jsp' class=\"button\">Continue Shopping</a>");
    } else {
        out.println("<h2>Product not found.</h2>");
    }

    rst.close();
    pstmt.close();
    con.close();
    %>
</div>
</body>
</html>