<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Jacob's Grocery</title>
    <style>
        .header {
            background-color: #333;
            padding: 15px;
            color: white;
            margin-bottom: 20px;
        }
        .nav-links {
            display: flex;
            gap: 20px;
            justify-content: center;
        }
        .nav-links a {
            color: white;
            text-decoration: none;
            padding: 5px 15px;
            border-radius: 3px;
        }
        .nav-links a:hover {
            background-color: #555;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1 style="text-align: center; margin-bottom: 15px;">Jacob's Grocery</h1>
        <div class="nav-links">
            <a href="listprod.jsp">Shop Products</a>
            <a href="listorder.jsp">List Orders</a>
            <a href="showcart.jsp">Shopping Cart</a>
            <a href="index.jsp">Home</a>
        </div>
    </div>
</body>
</html> 