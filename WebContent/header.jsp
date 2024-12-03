<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Jacob's Grocery</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
        }
        .header {
            background: linear-gradient(135deg, #FF7E00, #FF4500, #FFD700);
            padding: 15px;
            color: white;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .header h1 {
            text-align: center;
            margin: 0 0 15px 0;
            font-family: 'Arial Black', sans-serif;
            letter-spacing: 2px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
        }
        .nav-links {
            display: flex;
            gap: 20px;
            justify-content: center;
        }
        .nav-links a {
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 5px;
            background: rgba(255, 255, 255, 0.1);
            transition: background-color 0.3s ease, transform 0.2s ease;
            display: flex;
            align-items: center;
        }
        .nav-links a:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: scale(1.05);
        }
        .nav-links .cart-icon {
            font-size: 20px;
            margin-right: 8px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Freestyle Frenzy</h1>
        <div class="nav-links">
            <a href="listprod.jsp">Shop Products</a>
            <a href="listorder.jsp">List Orders</a>
            <a href="showcart.jsp">
                <span class="cart-icon">&#128722;</span>
            </a>
            <a href="index.jsp">Home</a>
        </div>
    </div>
</body>
</html>
