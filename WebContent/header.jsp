<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    /* General header styles */
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
        gap: 10px;
    }

    .header h1 {
        margin: 0;
        font-family: 'Arial Black', sans-serif;
        letter-spacing: 2px;
        color: black;
    }

    .header img {
        height: 50px;
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

    button, .cart-button {
        --color: #000;
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
        background: var(--color);
        border: 2px solid var(--color);
        border-radius: 6px;
        position: relative;
        text-align: center;
        transition: all 0.3s ease;
    }

    button:hover, .cart-button:hover {
        color: black;
        background: white;
        border: 2px solid black;
    }

    .cart-button {
        display: flex;
        justify-content: center;
        align-items: center;
        text-decoration: none;
    }

    .cart-button span {
        font-size: 1.5em;
    }
</style>

<div class="header">
    <div class="header-left">
        <h1>Freestyle Frenzy</h1>
        <img src="img/Freestyle.png" alt="Freestyle Logo">
    </div>
    <div class="buttons-container">
        <%
            // Avoid duplicate declarations by checking if session variables are already defined
            HttpSession localSession = request.getSession(false);
            String localCurrentUser = (localSession != null) ? (String) localSession.getAttribute("authenticatedUser") : null;
            Boolean localIsAdmin = (localSession != null) ? (Boolean) localSession.getAttribute("isAdmin") : false;
        %>

        <% if (localCurrentUser != null) { %>
            <button onclick="location.href='listprod.jsp'">Shop</button>
            <button onclick="location.href='customer.jsp'">Profile</button>

            <% if (localIsAdmin != null && localIsAdmin) { %>
                <button onclick="location.href='admin.jsp'">Admin</button>
                <button onclick="location.href='listorder.jsp'">All Orders</button>
            <% } %>
            <button onclick="location.href='logout.jsp'">Log out</button>
        <% } else { %>
            <button onclick="location.href='login.jsp'">Login</button>
            <button onclick="location.href='listprod.jsp'">Shop</button>
        <% } %>

        <!-- Shopping cart button -->
        <a href="showcart.jsp" class="cart-button">
            <span>&#128722;</span>
        </a>
        <% if (localCurrentUser != null) { %>
            <span class="user-info">Logged in as: <%= localCurrentUser %></span>
        <% } %>
    </div>
</div>
