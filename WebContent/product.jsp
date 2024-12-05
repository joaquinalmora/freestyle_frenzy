<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Product Information</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        background-color: #fff8e1;
    }
    .container {
        max-width: 800px;
        margin: 20px auto;
        background: #fff;
        padding: 20px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
        border-radius: 10px;
        text-align: center;
    }
    h2, h4 {
        color: #FF4500;
        margin: 10px 0;
    }
    .product-image {
        margin: 20px 0;
    }
    .product-image img {
        max-height: 250px;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }
    .button {
        display: inline-block;
        padding: 10px 20px;
        font-size: 1em;
        color: #fff;
        background-color: #FF7E00;
        text-decoration: none;
        border-radius: 5px;
        text-align: center;
        margin: 10px 10px 20px;
        transition: background-color 0.3s ease, transform 0.2s ease;
    }
    .button:hover {
        background-color: #FF4500;
        transform: scale(1.05);
    }
    .not-found {
        font-size: 1.5em;
        color: #FF4500;
        margin: 20px 0;
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
        out.println("<div class='not-found'>Error: ClassNotFoundException: " + e + "</div>");
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
            out.println("<div class='product-image'><img src=\"" + imageUrl + "\" alt='Product Image'></div>");
        }

        // Display product details
        out.println("<h4><b>Product ID:</b> "+prodid+"</h4>");
        out.println("<h4><b>Price:</b> $"+rst.getString("productPrice")+"</h4>");

        // Add links to Add to Cart and Continue Shopping
        out.println("<a href=\"addcart.jsp?id=" + prodid + "&name=" + name + "&price=" + rst.getString("productPrice") + "&newqty=1\" class=\"button\">Add to Cart</a>");
        out.println("<a href='listprod.jsp' class=\"button\">Continue Shopping</a>");
    } else {
        out.println("<div class='not-found'>Product not found.</div>");
    }

    rst.close();
    pstmt.close();
    con.close();
%>
