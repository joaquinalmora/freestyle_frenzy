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
        out.println("<span>Reviews</span>");
        out.println("</div>");
        out.println("<div class='testimonial-box-container'>");
        
        while (rst2.next()) {
            int outrating = rst2.getInt("reviewRating");
            String outreviewdate = rst2.getString("reviewDate");
            String outcustid = rst2.getString("firstName");
            String outcomment = rst2.getString("reviewComment");
        
            // Handle anonymous or guest users
            String authenticatedUser = (String) session.getAttribute("authenticatedUser");
            if (authenticatedUser == null) {
                outcustid = "Guest";
            }
        
            out.println("<div class='testimonial-box'>");
            out.println("<div class='box-top'>");
        
            // Profile details
            out.println("<div class='profile'>");
            out.println("<div class='profile-img'>");
            out.println("<img src='https://cdn3.iconfinder.com/data/icons/avatars-15/64/_Ninja-2-512.png' alt='Profile Picture'/>");
            out.println("</div>");
            out.println("<div class='name-user'>");
            out.println("<strong>" + (outcustid != null ? outcustid : "Anonymous") + "</strong>");
            out.println("</div>");
            out.println("</div>"); // Close profile
        
            // Star rating
            out.println("<div class='reviews'>");
            for (int i = 1; i <= 5; i++) {
                if (i <= outrating) {
                    out.println("<i class='fas fa-star'></i>");
                } else {
                    out.println("<i class='far fa-star'></i>");
                }
            }
            out.println("</div>"); // Close reviews
        
            out.println("</div>"); // Close box-top
        
            // Client comment
            out.println("<div class='client-comment'>");
            out.println("<p><strong>Rating: " + outrating + "/5</strong></p>");
            out.println("<p>" + outcomment + "</p>");
            out.println("</div>"); // Close client-comment
        
            out.println("</div>"); // Close testimonial-box
        }
        
        out.println("</div>"); // Close testimonial-box-container
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
<style>
/* General Styling for the Testimonials Section */
#testimonials {
  background-color: #f4f4f4;
  padding: 60px 20px;
  font-family: 'Arial', sans-serif;
  color: #000;
  text-align: center;
}

.testimonial-heading span {
  font-size: 2em;
  font-weight: bold;
  text-transform: uppercase;
  margin-bottom: 20px;
  display: inline-block;
  color: #000000;
}

.testimonial-box-container {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.testimonial-box {
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
  width: 300px;
  transition: all 0.3s ease;
  padding: 20px;
}

.testimonial-box:hover {
  transform: translateY(-10px);
  box-shadow: 0 12px 20px rgba(0, 0, 0, 0.2);
}

.box-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 15px;
}

.profile {
  display: flex;
  align-items: center;
}

.profile-img img {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid #ff6b6b;
}

.name-user {
  margin-left: 10px;
  text-align: left;
}

.name-user strong {
  font-size: 1.1em;
  color: #000;
}

.reviews {
  color: #000000;
  font-size: 1.2em;
}

.client-comment {
  margin-top: 15px;
  font-style: italic;
  color: #555;
}

.client-comment p {
  margin: 0;
  font-size: 0.9em;
  color: #000;
}

/* Add Review Form Styling */
h3 {
  font-size: 1.5em;
  color: #000000;
  margin-top: 40px;
  text-align: center;
}

form {
  max-width: 500px;
  margin: 0 auto;
  padding: 20px;
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
}

label {
  font-weight: bold;
  color: #000;
  display: block;
  margin: 10px 0 5px;
}

select, textarea {
  width: calc(100% - 10px);
  padding: 10px;
  margin-bottom: 10px;
  border-radius: 5px;
  border: 1px solid #ccc;
  font-size: 1em;
  font-family: 'Arial', sans-serif;
}

input[type="submit"] {
  background-color: #000;
  color: #fff;
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-size: 1em;
  transition: background-color 0.3s ease;
}

input[type="submit"]:hover {
  background-color: #333;
}

/* Media Queries */
@media (max-width: 768px) {
  .testimonial-box-container {
    flex-direction: column;
  }
  .testimonial-box {
    width: 90%;
  }
}

@media (max-width: 480px) {
  .testimonial-box {
    width: 100%;
  }
  form {
    width: 100%;
    box-shadow: none;
  }
}

    
</style>
