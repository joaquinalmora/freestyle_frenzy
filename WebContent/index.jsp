<!DOCTYPE html>
<html>
<head>
        <title>Jacob's Grocery Main Page</title>
</head>
<body>
<h1 align="center">Welcome to Jacob's Grocery</h1>

<h2 align="center"><a href="login.jsp">Login</a></h2>

<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

<h2 align="center"><a href="admin.jsp">Administrators</a></h2>

<h2 align="center"><a href="logout.jsp">Log out</a></h2>


<%
	// Display the current user
	String currentUser = (String) session.getAttribute("authenticatedUser");
	if (currentUser != null) {
		out.println("<p>Logged in as: " + currentUser + "</p>");
	}
%>

</body>
</head>


