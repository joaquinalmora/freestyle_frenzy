<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%
String prodid = request.getParameter("id");
String rate = request.getParameter("rating");
String comment = request.getParameter("comment");

Connection con = null;
PreparedStatement pstmt2 = null;
PreparedStatement pstmt3 = null;
ResultSet rst2 = null;

try {
    // Establish the connection
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True;";
    String uid = "sa";
    String pw = "304#sa#pw"; 
    con = DriverManager.getConnection(url, uid, pw);

    if (rate != null && comment != null && prodid != null) {
        String SQL = "INSERT INTO review(reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?,?,?,?,?)";
        pstmt2 = con.prepareStatement(SQL);
        pstmt2.setInt(1, Integer.parseInt(rate));
        pstmt2.setTimestamp(2, new java.sql.Timestamp(new Date().getTime()));
        pstmt2.setInt(3, 1); // Use 1 for anonymous customerId
        pstmt2.setInt(4, Integer.parseInt(prodid));
        pstmt2.setString(5, comment);
        pstmt2.executeUpdate();
    }

    String sql2 = "SELECT reviewRating, reviewDate, firstName, productId, reviewComment FROM review LEFT JOIN customer ON review.customerId = customer.customerId WHERE productId = ?";
    pstmt3 = con.prepareStatement(sql2);
    pstmt3.setInt(1, Integer.parseInt(prodid));
    rst2 = pstmt3.executeQuery();

    out.println("<section id='testimonials'>");
    out.println("<div class='testimonial-heading'>");
    out.println("<span>Comments</span>");
    out.println("<h4>Clients Say</h4>");
    out.println("</div>");
    out.println("<div class='testimonial-box-container'>");

    while (rst2.next()) {
        int outrating = rst2.getInt("reviewRating");
        String outreviewdate = rst2.getString("reviewDate");
        String outcustid = rst2.getString("firstName");
        String outcomment = rst2.getString("reviewComment");

        // Check if the user is logged in
        String authenticatedUser = (String) session.getAttribute("authenticatedUser");
        if (authenticatedUser == null) {
            outcustid = "Guest";
        }

        out.println("<div class='testimonial-box'>");
        out.println("<div class='box-top'>");
        out.println("<div class='profile'>");
        out.println("<div class='profile-img'>");
        out.println("<img src='https://cdn3.iconfinder.com/data/icons/avatars-15/64/_Ninja-2-512.png' />");
        out.println("</div>");
        out.println("<div class='name-user'>");
        out.println("<strong>" + (outcustid != null ? outcustid : "Anonymous") + "</strong>");
        out.println("</div>");
        out.println("</div>");
        out.println("<div class='reviews'>");

        for (int i = 1; i <= 5; i++) {
            if (i <= outrating) {
                out.println("<i class='fas fa-star'></i>");
            } else {
                out.println("<i class='far fa-star'></i>");
            }
        }

        out.println("</div>");
        out.println("<div class='client-comment'>");
        out.println("<p><strong>Rating: " + outrating + "/5</strong></p>");
        out.println("<p>" + outcomment + "</p>");
        out.println("</div>");
        out.println("</div>");
    }

    out.println("</div>");
    out.println("</section>");

} catch (SQLException ex) {
    out.println("<div class='not-found'>Error: " + ex.getMessage() + "</div>");
} finally {
    if (rst2 != null) try { rst2.close(); } catch (SQLException ignore) {}
    if (pstmt2 != null) try { pstmt2.close(); } catch (SQLException ignore) {}
    if (pstmt3 != null) try { pstmt3.close(); } catch (SQLException ignore) {}
    if (con != null) try { con.close(); } catch (SQLException ignore) {}
}
%>

<h3>Add a Review:</h3>
<form method="post" action="product.jsp">
    <input type="hidden" name="id" value="<%= prodid %>">
    <label for="rating">Rating:</label>
    <select name="rating" id="rating">
        <option value="1">1</option>
        <option value="2">2</option>
        <option value="3">3</option>
        <option value="4">4</option>
        <option value="5">5</option>
    </select>
    <br>
    <label for="comment">Comment:</label>
    <textarea name="comment" id="comment" rows="4" cols="50"></textarea>
    <br>
    <input type="submit" value="Submit Review">
</form>