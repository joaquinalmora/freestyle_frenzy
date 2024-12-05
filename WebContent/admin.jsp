<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<style>
body{
    background: url("img/textured.png");
    position: absolute; 
    background-size: cover;
    background-repeat: repeat; 
    top: 0; 
    left: 0;  
    z-index: -1; 
    object-fit: cover; 
	margin-top: 100px; 
	width: 100%; 
}
.graph1{
	display: flex;
	height: fit-content;  
	padding: 0 auto;
	margin: 0 auto; 
}
</style>
<body>
<%@ include file="header.jsp" %>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>

<div class = "admin-container" style="width: 100%; display: flex; padding: 0 auto; margin: 0 auto; background-color: white; height: fit-content; margin: 0 auto; border: 2px solid black;">
		<div class = "item-70" style="display: block; width: 82%">
			<div class = "tables" style="display: flex; flex-direction: row; justify-content: space-evenly; width: 100%; ">
				<div class = "table1" style="width: 20%; display: block; padding: 10px; ">
					<h3>Administrator Sales Report by Day</h3>
<%
String sql = "SELECT CAST(orderDate AS DATE) as OrderDate, SUM(totalAmount) as TotalOrderAmount FROM ordersummary GROUP BY CAST(orderDate AS DATE) ORDER BY OrderDate;";
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";
try ( Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();){
	PreparedStatement pstmt = con.prepareStatement("SELECT customerId, firstName, lastName, email, phoneNum, address, city, state, postalCode, country, userid FROM customer WHERE userid = ?;");
	ResultSet rst = stmt.executeQuery(sql); 
    out.println("<table class='table' border='1'><tr><th>Order Date</th><th>Total Order Amount</th>");
	while (rst.next()){
        out.println("<tr><td>" + rst.getString(1) + "</td><td>" + rst.getString(2) + "</td></tr>");
    }
    out.println("</table>");
	out.println("</div>");

	rst.close();
	stmt.close();
	con.close(); 
} catch (SQLException ex) {
	out.println("SQLException: " + ex);
}
//List all customers
out.println("<div class = 'table2' style='width: 85%; display: block; padding: 10px; '>");
out.println("<h3>Administrator Customer List</h3>");
try ( Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();){
	PreparedStatement pstmt = con.prepareStatement("SELECT customerId, firstName, lastName, email, phoneNum, address, city, state, postalCode, country, userid FROM customer WHERE userid = ?;");
	ResultSet rst = stmt.executeQuery("SELECT customerId, firstName, lastName, email, phoneNum, address, city, state, postalCode, country, userid FROM customer;"); 
	out.println("<table class='table' border='1'><tr><th>Customer ID</th><th> Name</th><th>Email</th><th>Phone Number</th><th>Address</th><th>City</th><th>State</th><th>Postal Code</th><th>Country</th><th>User ID</th>");
	while (rst.next()){
		out.println("<tr><td>" + rst.getString(1) + "</td><td>" + rst.getString(2) + " " + rst.getString(3) + "</td><td>" 
		+ rst.getString(4) + "</td><td>" + rst.getString(5) + "</td><td>" + rst.getString(6) + "</td><td>" + rst.getString(7) + "</td><td>" 
		+ rst.getString(8) + "</td><td>" + rst.getString(9) + "</td><td>" + rst.getString(10) + "</td><td>" + rst.getString(11) + "</td></tr>");
	}
	out.println("</table>");
	rst.close();
	stmt.close();
	con.close(); 
} catch (SQLException ex) {
	out.println("SQLException: " + ex);
}
out.println("</div></div><br>");
out.println("<div class = 'graph' style='display: flex; width: 100%; flex-direction: column; justify-content: space-evenly;'>");
//Show the Administrator Sales Report by Day with a graph
	out.println("<h3>Administrator Sales Report by Day with Graph</h3><br><div class = 'graph1'>");
	out.println("<script type='text/javascript' src='https://www.gstatic.com/charts/loader.js'></script>");
	out.println("<script type=\"text/javascript\">");
	out.println("google.charts.load('current', {'packages':['corechart']});");
	out.println("google.charts.setOnLoadCallback(drawChart);");
	out.println("function drawChart() {");
	out.println("var data = google.visualization.arrayToDataTable([");
	out.println("['Order Date', 'Total Order Amount'],");
try ( Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();){
	PreparedStatement pstmt = con.prepareStatement("SELECT CAST(orderDate AS DATE) as OrderDate, SUM(totalAmount) as TotalOrderAmount FROM ordersummary GROUP BY CAST(orderDate AS DATE) ORDER BY OrderDate;");
	ResultSet rst = stmt.executeQuery("SELECT CAST(orderDate AS DATE) as OrderDate, SUM(totalAmount) as TotalOrderAmount FROM ordersummary GROUP BY CAST(orderDate AS DATE) ORDER BY OrderDate;"); 
	while (rst.next()){
		out.println("['" + rst.getString(1) + "'," + rst.getString(2) + "],");
	}
	rst.close();
	stmt.close();
	con.close(); 
} catch (SQLException ex) {
	out.println("SQLException: " + ex);
}
out.println("]);");
out.println("var options = {");
out.println("title: 'Sales Report by Day',");
out.println("curveType: 'function',");
out.println("legend: { position: 'bottom' }");
out.println("};");
out.println("var chart = new google.visualization.LineChart(document.getElementById('curve_chart'));");
out.println("chart.draw(data, options);");
out.println("}");
out.println("</script>");
out.println("<div id='curve_chart' style='width: 900px; height: 500px'></div>");
out.println("</div></div></div>");

%>
<style>
.item-30 .product .task{
	margin-left: 10px; 
	margin-right: 10px; 
}
.task input[type="submit"]{
  background-color: #2ea44f;
  border: 1px solid rgba(27, 31, 35, .15);
  border-radius: 6px;
  box-shadow: rgba(27, 31, 35, .1) 0 1px 0;
  box-sizing: border-box;
  color: #fff;
  cursor: pointer;
  display: inline-block;
  font-size: 18px;
  line-height: 20px;
  padding: 6px 24px;
  position: relative;
  text-align: center;
  text-decoration: none;
}
.task input[type="submit"]:hover {
  background-color: white;
}
.task input[type="text"], textarea {
  background-color: white;
}

</style>
		<div class = "item-30" style="display: flex; width: fit-content; margin-left: 10px; border-left: 2px solid black; ">
			<div class = "product" style="display: flex; flex-direction: column; margin: 0 auto; padding: 0 auto; justify-content: space-between; width: 100%;">
				<div class = "task">
					<h3>Add a Product</h3>
					<form method="post" action="addproduct.jsp">
						<label for="productName">Product Name:</label><br>
						<input type="text" id="productName" name="productName" required ><br>
						<label for="productPrice">Product Price:</label><br>
						<input type="text" id="productPrice" name="productPrice" required ><br>
						<label for="productDesc">Product Description:</label><br>
						<textarea id="productDesc" name="productDesc" required ></textarea><br>
						<input type="submit" value="Submit">
					</form>
				</div>
				<div class = "task">
					<h3>Update a Product</h3>
					<form method="post" action="updateproduct.jsp">
						<label for="productId">Product ID:</label><br>
						<input type="text" id="productId" name="productId" required><br>
						<label for="productName">Product Name:</label><br>
						<input type="text" id="productName" name="productName" required><br>
						<label for="productPrice">Product Price:</label><br>
						<input type="text" id="productPrice" name="productPrice" required><br>
						<label for="productDesc">Product Description:</label><br>
						<textarea id="productDesc" name="productDesc" required></textarea><br>
						<input type="submit" value="Update">
					</form>

				</div>
				<div class="task">
                    <h3>Delete a Product</h3>
                    <form method="post" action="deleteproduct.jsp">
                        <label for="productId">Product ID:</label><br>
                        <input type="text" id="productId" name="productId" required><br><br>
                        <input type="submit" value="Delete">
                    </form>
                    <br>
                </div>
                </div>
                </div>
                </div>
                <style>
                .back button {
                    padding: 3px 20px;
                }
                </style>
                
                </body>
                </html>