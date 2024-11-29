<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="header.jsp" %>
<style>
    .cart-container {
        max-width: 90%;
        margin: 0 auto;
        padding: 20px;
    }
    .cart-table {
        width: 100%;
        border-collapse: collapse;
        margin: 20px 0;
        background-color: white;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }
    .cart-table th, .cart-table td {
        padding: 15px 25px;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }
    .cart-table th {
        background-color: #f5f5f5;
        font-size: 1.1em;
    }
    .cart-table tr:hover {
        background-color: #f9f9f9;
    }
    .quantity-input {
        width: 80px;
        padding: 8px;
        margin-right: 10px;
        border: 1px solid #ddd;
        border-radius: 4px;
    }
    .update-btn {
        background-color: #4CAF50;
        color: white;
        padding: 8px 15px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }
    .remove-btn {
        background-color: #f44336;
        color: white;
        padding: 8px 15px;
        border: none;
        border-radius: 4px;
        text-decoration: none;
        display: inline-block;
    }
    .cart-total {
        text-align: right;
        font-size: 1.2em;
        margin-top: 20px;
        padding: 20px;
        background-color: white;
        border-radius: 4px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }
    .navigation-buttons {
        margin-top: 20px;
        display: flex;
        gap: 10px;
        justify-content: flex-end;
    }
    .nav-button {
        background-color: #4CAF50;
        color: white;
        padding: 10px 20px;
        text-decoration: none;
        border-radius: 4px;
    }
</style>

<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Handle updates and deletes
String updateId = request.getParameter("update");
String deleteId = request.getParameter("delete");
String newQty = request.getParameter("newqty");

// Update quantity if specified
if (updateId != null && newQty != null && productList != null) {
    ArrayList<Object> product = productList.get(updateId);
    if (product != null) {
        try {
            int qty = Integer.parseInt(newQty);
            if (qty > 0) {
                product.set(3, qty);  // Update quantity
            } else {
                productList.remove(updateId);  // Remove if quantity <= 0
            }
            session.setAttribute("productList", productList);  // Save back to session
        } catch (NumberFormatException e) {
            out.println("<h2>Invalid quantity format.</h2>");
        }
    }
}

// Handle deletions
if (deleteId != null && productList != null) {
    productList.remove(deleteId);
    session.setAttribute("productList", productList);
}
%>

<div class="cart-container">
    <h1>Your Shopping Cart</h1>
    
    <%
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    double total = 0;
    
    if (productList == null || productList.isEmpty()) {
    %>
        <p>Your shopping cart is empty.</p>
    <% } else { %>
        <table class="cart-table">
            <tr>
                <th>Product</th>
                <th>Quantity</th>
                <th>Price</th>
                <th>Subtotal</th>
                <th>Actions</th>
            </tr>
            <%
            for (String id : productList.keySet()) {
                ArrayList<Object> product = productList.get(id);
                double pr = Double.parseDouble((String) product.get(2));
                int qty = ((Integer) product.get(3)).intValue();
                double subtotal = pr * qty;
                total += subtotal;
            %>
                <tr>
                    <td><%= product.get(1) %></td>
                    <td>
                        <form method="get" action="showcart.jsp" style="display:inline;">
                            <input type="hidden" name="update" value="<%= product.get(0) %>">
                            <input type="number" name="newqty" value="<%= qty %>" min="0" class="quantity-input">
                            <input type="submit" value="Update" class="update-btn">
                        </form>
                    </td>
                    <td><%= currFormat.format(pr) %></td>
                    <td><%= currFormat.format(subtotal) %></td>
                    <td>
                        <a href="showcart.jsp?delete=<%= product.get(0) %>" class="remove-btn">Remove</a>
                    </td>
                </tr>
            <% } %>
            <tr>
                <td colspan="3" align="right"><b>Order Total</b></td>
                <td><%= currFormat.format(total) %></td>
                <td></td>
            </tr>
        </table>
    <% } %>

    <div style="margin-top: 20px;">
        <a href="listprod.jsp" class="update-btn" style="text-decoration: none; margin-right: 10px;">Continue Shopping</a>
        <a href="checkout.jsp" class="update-btn" style="text-decoration: none;">Check Out</a>
    </div>
</div>

</body>
</html> 

