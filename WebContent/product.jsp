<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ include file="header.jsp" %>
<%@ include file="jdbc.jsp" %>
<html>
<head>
<title>Product Information</title>
<style>
    body {
        font-family: 'Poppins', sans-serif;
        margin: 0;
        padding: 0;
        background-color: #f2f2f2;
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
        color: #000000;
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
        margin: 10px 5px;
        background-color: #000000;
        color: white;
        text-decoration: none;
        border-radius: 5px;
    }

    #testimonials {
        padding: 50px 0;
        text-align: center;
    }

    .testimonial-heading span {
        font-size: 20px;
        color: #555;
    }

    .testimonial-heading h4 {
        font-size: 36px;
        margin: 10px 0;
        color: #333;
    }

    .testimonial-box-container {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        gap: 20px;
        margin-top: 30px;
    }

    .testimonial-box {
        background-color: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        max-width: 300px;
        flex: 1;
    }

    .box-top {
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .profile {
        display: flex;
        align-items: center;
    }

    .profile-img img {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        object-fit: cover;
    }

    .name-user {
        margin-left: 10px;
    }

    .name-user strong {
        display: block;
        color: #333;
    }

    .name-user span {
        font-size: 14px;
        color: #777;
    }

    .reviews i {
        color: #f39c12;
    }

    .client-comment {
        margin-top: 10px;
    }

    .client-comment p {
        font-size: 14px;
        color: #555;
        line-height: 1.6;
    }
</style>
</head>
<body>
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
    
    String sql = "SELECT productName, productImageURL, productImage, productPrice, productDesc FROM Product P WHERE productId = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setInt(1, Integer.parseInt(prodid));
    ResultSet rst = pstmt.executeQuery();
    
    if (rst.next()) {
        // Display product name
        String name = rst.getString("productName");
        out.println("<h2>" + name + "</h2>");
    
        // If there is a productImageURL, display using IMG tag
        String imageUrl = rst.getString("productImageURL");
        if (imageUrl != null && !imageUrl.isEmpty()) {
            out.println("<div class='product-image'><img src=\"" + imageUrl + "\" alt='Product Image'></div>");
        }

        // Display product details
        out.println("<h4><b>Product ID:</b> " + prodid + "</h4>");
        out.println("<h4><b>Price:</b> $" + rst.getString("productPrice") + "</h4>");

        // Add product description
        String productDesc = rst.getString("productDesc");
        if (productDesc != null && !productDesc.isEmpty()) {
            out.println("<p><b>Description:</b> " + productDesc + "</p>");
        }

        // Add links to Add to Cart and Continue Shopping
        out.println("<a href=\"addcart.jsp?id=" + prodid + "&name=" + name + "&price=" + rst.getString("productPrice") + "&newqty=1\" class=\"button\">Add to Cart</a>");
        out.println("<a href='listprod.jsp' class=\"button\">Continue Shopping</a>");
    } else {
        out.println("<div class='not-found'>Product not found.</div>");
    }
    %>

    <jsp:include page="reviews.jsp" />

</div>

<link rel="stylesheet" href="styles.css">
<script src='https://kit.fontawesome.com/c8e4d183c2.js'></script>
</body>
</html>