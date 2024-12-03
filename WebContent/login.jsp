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
            background: linear-gradient(135deg, #FF7E00, #FF4500, #FFD700);
            padding: 20px;
            color: white;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 100%;
            position: absolute;
            top: 0;
            left: 0;
        }
        .header h1 {
            margin: 0;
            font-family: 'Arial Black', sans-serif;
            letter-spacing: 2px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
        }
        .content-container {
            background-color: white;
            border-radius: 8px;
            padding: 20px 40px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 100%;
            max-width: 400px;
        }
        .content-container h3 {
            color: #333;
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
            background: linear-gradient(135deg, #FF7E00, #FF4500);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
            width: 100%;
            margin-top: 10px;
            font-size: 16px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .submit:hover {
            background: #FF4500;
            transform: scale(1.05);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>
<body>

<div class="header">
    <h1>Login to System</h1>
</div>

<div class="content-container">
    <h3>Please Login to System</h3>

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
        <input class="submit" type="submit" name="Submit2" value="Log In">
    </form>
</div>

</body>
</html>
