<!DOCTYPE html>
<html>
<head>
    <title>Login Screen</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #fff8e1; /* Subtle warm background */
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .header {
            background: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
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
        .content-container {
            background-color: white;
            border-radius: 8px;
            padding: 20px 40px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 100%;
            max-width: 400px;
            margin-top: 100px; /* Ensure it sits below the header */
        }
        h3 {
            color: #333;
            font-family: 'Arial Black', sans-serif;
            margin-bottom: 20px;
        }
        .error-message {
            color: red;
            font-size: 14px;
            margin-bottom: 10px;
        }
        table {
            margin: 0 auto;
            width: 100%;
        }
        td {
            padding: 8px;
            text-align: left;
            font-size: 14px;
            color: #333;
        }
        input[type="text"],
        input[type="password"] {
            width: calc(100% - 20px);
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .submit {
            --color: #000;
            font-family: inherit;
            display: inline-block;
            width: 100%;
            height: 2.6em;
            line-height: 2.5em;
            text-align: center;
            cursor: pointer;
            margin: 10px 0;
            font-size: 17px;
            z-index: 1;
            color: white;
            background: var(--color);
            border: 2px solid var(--color);
            border-radius: 6px;
            position: relative;
            transition: all 0.3s ease;
        }
        .submit:hover {
            color: black;
            background: white;
            border: 2px solid black;
        }
        .secondary-button {
            --color: #333;
            font-family: inherit;
            display: inline-block;
            width: 100%;
            height: 2.6em;
            line-height: 2.5em;
            text-align: center;
            cursor: pointer;
            margin: 10px 0;
            font-size: 17px;
            z-index: 1;
            color: white;
            background: var(--color);
            border: 2px solid var(--color);
            border-radius: 6px;
            position: relative;
            transition: all 0.3s ease;
        }
        .secondary-button:hover {
            color: black;
            background: white;
            border: 2px solid black;
        }
    </style>
</head>
<body>

<div class="header">
    <div class="header-left">
        <h1>Freestyle Frenzy</h1>
        <img src="img/Freestyle.png" alt="Freestyle Logo">
    </div>
</div>

<div class="content-container">
    <h3>Login to Your Account</h3>

    <% 
        // Print prior error login message if present
        if (session.getAttribute("loginMessage") != null) {
    %>
        <p class="error-message"><%= session.getAttribute("loginMessage").toString() %></p>
    <%
        session.removeAttribute("loginMessage"); // Remove the message after displaying it
        }
    %>

    <form name="MyForm" method="post" action="validateLogin.jsp">
        <table>
            <tr>
                <td>UserID:</td>
                <td><input type="text" name="username" maxlength="10"></td>
            </tr>
            <tr>
                <td>Password:</td>
                <td><input type="password" name="password" maxlength="10"></td>
            </tr>
        </table>
        <button class="submit" type="submit" name="Submit2">Log In</button>
    </form>

    <!-- Create New Account Button -->
    <button class="secondary-button" onclick="location.href='register.jsp'">Create New Account</button>
</div>

</body>
</html>
