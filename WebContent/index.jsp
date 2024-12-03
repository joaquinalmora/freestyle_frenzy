<!DOCTYPE html>
<html>
<head>
    <title>Jacob's Grocery Main Page</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #fff8e1; /* Subtle warm background */
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
        }

        /* Button styling */
        button {
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
            transition: all 0.3s ease; /* Smooth transitions */
        }

        button:hover {
            color: black; /* Text turns black */
            background: white; /* Button background turns white */
            border: 2px solid black; /* Border stays black */
        }

        .home-image {
            width: 100%;
            height: auto;
            display: block;
        }

        .user-info {
            text-align: center;
            font-size: 16px;
            margin-top: 20px;
            color: #333;
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
            if (currentUser != null) { 
        %>
            <button onclick="location.href='listprod.jsp'">Shop</button>
            <button onclick="location.href='listorder.jsp'">Orders</button>
            <button onclick="location.href='customer.jsp'">Profile</button>
            <button onclick="location.href='admin.jsp'">Admin</button>
            <button onclick="location.href='logout.jsp'">Log out</button>
        <% 
            } else { 
        %>
            <button onclick="location.href='login.jsp'">Login</button>
            <button onclick="location.href='listprod.jsp'">Shop</button>
        <% 
            } 
        %>
    </div>
</div>

<!-- Full-width image -->
<img src="img/Home2.jpg" alt="Welcome to Freestyle Frenzy" class="home-image">

<%
    if (currentUser != null) {
%>
    <div class="user-info">
        Logged in as: <%= currentUser %>
    </div>
<%
    }
%>
<%@ include file="listprod.jsp" %>

</body>
</html>
