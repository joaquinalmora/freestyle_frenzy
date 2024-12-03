<!DOCTYPE html>
<html>
<head>
    <title>Register for an Account</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background: #fff8e1; /* Subtle warm background */
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            text-align: center;
        }
        .container {
            background: white;
            padding: 20px 40px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
            width: 400px;
        }
        h3 {
            font-family: 'Arial Black', sans-serif;
            color: #333;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            margin: 0 auto;
        }
        td {
            padding: 8px 0;
            text-align: left;
        }
        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: calc(100% - 10px);
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .submit {
            --color: #000;
            display: inline-block;
            width: 100%;
            height: 2.6em;
            line-height: 2.5em;
            font-size: 16px;
            font-family: inherit;
            text-align: center;
            color: white;
            background: var(--color);
            border: 2px solid var(--color);
            border-radius: 6px;
            cursor: pointer;
            margin-top: 20px;
            transition: all 0.3s ease;
        }
        .submit:hover {
            background: white;
            color: black;
        }
        .message {
            margin-top: 20px;
            color: red;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h3>Register for an Account</h3>
        <form name="AccountCreation" method="post" action="validateRegister.jsp">
            <table>
                <tr>
                    <td>First Name:</td>
                    <td><input type="text" name="firstName" maxlength="40" required></td>
                </tr>
                <tr>
                    <td>Last Name:</td>
                    <td><input type="text" name="lastName" maxlength="40" required></td>
                </tr>
                <tr>
                    <td>Email:</td>
                    <td><input type="email" name="email" maxlength="50" required></td>
                </tr>
                <tr>
                    <td>Phone Number:</td>
                    <td><input type="text" name="phonenum" maxlength="20" required></td>
                </tr>
                <tr>
                    <td>Address:</td>
                    <td><input type="text" name="address" maxlength="50" required></td>
                </tr>
                <tr>
                    <td>City:</td>
                    <td><input type="text" name="city" maxlength="40" required></td>
                </tr>
                <tr>
                    <td>State:</td>
                    <td><input type="text" name="state" maxlength="20" required></td>
                </tr>
                <tr>
                    <td>Postal Code:</td>
                    <td><input type="text" name="postalCode" maxlength="20" required></td>
                </tr>
                <tr>
                    <td>Country:</td>
                    <td><input type="text" name="country" maxlength="40" required></td>
                </tr>
                <tr>
                    <td>User ID:</td>
                    <td><input type="text" name="userid" maxlength="20" required></td>
                </tr>
                <tr>
                    <td>Password:</td>
                    <td><input type="password" name="password" maxlength="30" required></td>
                </tr>
            </table>
            <input class="submit" type="submit" value="Create Account">
        </form>
        <% 
            // Display registration error or success message if it exists
            if (session.getAttribute("registerMessage") != null) {
        %>
            <p class="message"><%= session.getAttribute("registerMessage") %></p>
        <% 
            session.removeAttribute("registerMessage"); 
            }
        %>
    </div>
</body>
</html>
