<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Shipment Processing</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 20px;
        background-color: #f4f4f4;
    }
    .container {
        max-width: 800px;
        margin: 0 auto;
        background: #fff;
        padding: 20px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    h2 {
        color: #333;
    }
    .button-container {
        text-align: center;
        margin-top: 40px;
    }
    .button {
        display: inline-block;
        padding: 10px 20px;
        font-size: 1em;
        color: #fff;
        background-color: #007bff;
        text-decoration: none;
        border-radius: 5px;
        text-align: center;
    }
    .button:hover {
        background-color: #0056b3;
    }
</style>
</head>
<body>

<div class="container">
<%@ include file="header.jsp" %>

<%
    int orderID = Integer.parseInt(request.getParameter("orderId"));
    try
    {
        getConnection();
        String sql1 = "SELECT orderId FROM orderproduct";
        boolean isValid= false;
        Statement stmt = con.createStatement();
        ResultSet rst = stmt.executeQuery(sql1);
        while(rst.next()){
            if(orderID == rst.getInt(1)){
                isValid = true;
            }

        }
        if(!isValid){
            out.println("<h2>The Order ID DOES NOT EXIST.</h2>");
            return;
        }
        con.setAutoCommit(false);

        String sql = "SELECT orderId, O.productId, O.quantity, P.quantity FROM orderproduct O JOIN productinventory P ON O.productId = P.productId WHERE warehouseID = 1 AND orderID = ?";
        
        PreparedStatement psmt = con.prepareStatement(sql);
        
        psmt.setInt(1,orderID);
        
        ResultSet rst2 = psmt.executeQuery();

        boolean isSufficient = true;
        int insufficient;
        while(rst2.next()){
            int newInv = rst2.getInt(4)-rst2.getInt(3);
            if (newInv >= 0) {
                out.println("<br>Ordered Product: " + rst2.getInt(2));
                out.println("Previous Inventory: " + rst2.getInt(4));
                out.println("New Inventory: " + newInv);
                out.println();

            } else {
                isSufficient = false;
                insufficient  = rst2.getInt(2);
                out.println("<h2>Shipment not done. Insufficient inventory for product id: " + insufficient + "</h2>");
                out.println();
                con.rollback();
                return;
            }

        }

        if(isSufficient){
            String sql2 = "INSERT INTO shipment(shipmentId) VALUES(statement.RETURN_GENERATED_KEYS)";
            Statement stmt2 = con.createStatement();
            int rowcount = stmt2.executeUpdate(sql2);
            ResultSet autoKeys = stmt.getGeneratedKeys();			


            con.commit();

            rst2 = psmt.executeQuery();
            
            while(rst2.next()){
                
                int newInv = rst2.getInt(4) - rst2.getInt(3);
                sql = "UPDATE productinventory SET quantity = ? WHERE productId = ?";
                PreparedStatement pst2 = con.prepareStatement(sql);
                pst2.setInt(1, newInv);
                pst2.setInt(2, rst2.getInt(2));
                int rowcount2 = pst2.executeUpdate();
                con.commit();

                out.println("<br>Ordered Product: " + rst2.getInt(2) + "<br>");
                out.println("Previous Inventory: " + rst2.getInt(4) + "<br>");
                out.println("<br>New Inventory: " + newInv + "<br><br>");
                }
                out.println("Shipment successfully processed.<br>");
                }
                con.setAutoCommit(true);

            } catch (SQLException ex) {
            System.err.println("SQLException: " + ex);
            }

%>

<div class="button-container">
    <a href="index.jsp" class="button">Back to Main Page</a>
</div>
</div>

</body>
</html>