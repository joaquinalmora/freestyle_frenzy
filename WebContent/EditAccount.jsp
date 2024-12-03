<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Your Account</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #fff8e1; /* Subtle warm background */
            color: #333;
        }
        .container {
            max-width: 800px;
            margin: 50px auto;
            background: #fff;
            padding: 20px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
            border-radius: 10px;
        }
        h3 {
            font-family: 'Arial Black', sans-serif;
            color: black;
            text-align: center;
        }
        table {
            margin: 20px auto;
            border-collapse: collapse;
            width: 100%;
            text-align: left;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
        }
        td {
            background-color: #fff;
        }
        input[type="text"], input[type="email"], input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="submit"] {
         
            --color: #000;
            color: white;
            display: inline-block;
            text-decoration: none;
            font-size: 17px;
            color: white;
            background: var(--color);
            border: 2px solid var(--color);
            border-radius: 6px;
            padding: 10px 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        input[type="submit"]:hover {
            color: black;
            background: white;
            border: 2px solid black;
        }
        .message {
            font-size: 1.2em;
            margin: 20px 0;
            text-align: center;
        }
        .error {
            color: red;
        }
        .back-button {
            --color: #000;
            display: inline-block;
            text-decoration: none;
            font-size: 17px;
            color: white;
            background: var(--color);
            border: 2px solid var(--color);
            border-radius: 6px;
            padding: 10px 20px;
            text-align: center;
            transition: all 0.3s ease;
        }
        .back-button:hover {
            color: black;
            background: white;
            border: 2px solid black;
        }
    </style>
</head>
<body>
    <div class="container">
        <h3>Edit Your Account</h3>
        <form method="POST">
            <table>
                <tr>
                    <td>First Name:</td>
                    <td><input type="text" name="firstName" maxlength="40"></td>
                </tr>
                <tr>
                    <td>Last Name:</td>
                    <td><input type="text" name="lastName" maxlength="40"></td>
                </tr>
                <tr>
                    <td>Email:</td>
                    <td><input type="email" name="email" maxlength="50"></td>
                </tr>
                <tr>
                    <td>Phone Number:</td>
                    <td><input type="text" name="phonenum" maxlength="20"></td>
                </tr>
                <tr>
                    <td>Address:</td>
                    <td><input type="text" name="address" maxlength="50"></td>
                </tr>
                <tr>
                    <td>City:</td>
                    <td><input type="text" name="city" maxlength="40"></td>
                </tr>
                <tr>
                    <td>State:</td>
                    <td><input type="text" name="state" maxlength="20"></td>
                </tr>
                <tr>
                    <td>Postal Code:</td>
                    <td><input type="text" name="postalCode" maxlength="20"></td>
                </tr>
                <tr>
                    <td>Country:</td>
                    <td><input type="text" name="country" maxlength="40"></td>
                </tr>
                <tr>
                    <td>User ID:</td>
                    <td><input type="text" name="userid" maxlength="20"></td>
                </tr>
                <tr>
                    <td>Password:</td>
                    <td><input type="password" name="password" maxlength="30"></td>
                </tr>
            </table>
            <div style="text-align: center; margin-top: 20px;">
                <input type="submit" value="Submit Changes" class="back-button">
                <a href="customer.jsp" class="back-button">Back</a>
            </div>
        </form>
        <div class="message">
            <%
                if (request.getMethod().equalsIgnoreCase("POST")) {
                    String firstName = request.getParameter("firstName");
                    String lastName = request.getParameter("lastName");
                    String email = request.getParameter("email");
                    String phonenum = request.getParameter("phonenum");
                    String address = request.getParameter("address");
                    String city = request.getParameter("city");
                    String state = request.getParameter("state");
                    String postalCode = request.getParameter("postalCode");
                    String country = request.getParameter("country");
                    String userid = request.getParameter("userid");
                    String password = request.getParameter("password");

                    if (userid == null || userid.trim().isEmpty()) {
                        out.println("User ID is required.");
                    } else {
                        try {
                            getConnection();
                            String sql = "UPDATE customer SET firstName = ?, lastName = ?, email = ?, phonenum = ?, " +
                                         "address = ?, city = ?, state = ?, postalCode = ?, country = ?, password = ? " +
                                         "WHERE userid = ?";
                            PreparedStatement pstmt = con.prepareStatement(sql);
                            pstmt.setString(1, firstName);
                            pstmt.setString(2, lastName);
                            pstmt.setString(3, email);
                            pstmt.setString(4, phonenum);
                            pstmt.setString(5, address);
                            pstmt.setString(6, city);
                            pstmt.setString(7, state);
                            pstmt.setString(8, postalCode);
                            pstmt.setString(9, country);
                            pstmt.setString(10, password);
                            pstmt.setString(11, userid);

                            int rowsUpdated = pstmt.executeUpdate();
                            if (rowsUpdated > 0) {
                                out.println("<p style='color: green;'>Edits successfully saved!</p>");
                            } else {
                                out.println("No matching user found. Please check your User ID.");
                            }

                            pstmt.close();
                        } catch (SQLException ex) {
                            out.println("Database error: " + ex.getMessage());
                        } finally {
                            closeConnection();
                        }
                    }
                }
            %>
        </div>
    </div>
</body>
</html>
