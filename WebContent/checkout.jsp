<!DOCTYPE html>
<html>
<head>
    <title>Ray's Grocery - Checkout</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #fff8e1; /* Subtle warm background */
        }
        .header {
            background: linear-gradient(135deg, #FF7E00, #FF4500, #FFD700);
            padding: 20px;
            color: white;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .header h1 {
            margin: 0;
            font-family: 'Arial Black', sans-serif;
            letter-spacing: 2px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
        }
        .form-container {
            margin: 40px auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 90%;
            max-width: 500px;
        }
        .form-container h1 {
            margin-bottom: 20px;
            text-align: center;
            font-size: 24px;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        td {
            padding: 10px;
        }
        td:first-child {
            text-align: right;
            font-weight: bold;
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
        input[type="submit"],
        input[type="reset"] {
            background: linear-gradient(135deg, #FF7E00, #FF4500);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
            width: 100%;
            margin: 5px 0;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        input[type="submit"]:hover,
        input[type="reset"]:hover {
            background: #FF4500;
            transform: scale(1.05);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>
<body>

<div class="header">
    <h1>Checkout</h1>
</div>

<div class="form-container">
    <h1>Complete Your Transaction</h1>
    <form method="get" action="order.jsp">
        <table>
            <tr>
                <td>Customer ID:</td>
                <td><input type="text" name="customerId" size="20"></td>
            </tr>
            <tr>
                <td>Password:</td>
                <td><input type="password" name="password" size="20"></td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="submit" value="Submit">
                    <input type="reset" value="Reset">
                </td>
            </tr>
        </table>
    </form>
</div>

</body>
</html>
