<!DOCTYPE html>
<html>
<head>
    <title>Freestyle Frenzy Main Page</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #fff8e1; 
        }
        .header {
            background: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .header-left {
            display: flex;
            align-items: center;
            gap: 10px; 
        }
        .header h1 {
            margin: 0;
            font-family: 'Arial Black', sans-serif;
            letter-spacing: 2px;
            color: black;
        }
        .header img {
            height: 50px; /* Adjust image size */
            width: auto;
        }
        .buttons-container {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .user-info {
            font-size: 14px;
            color: #333;
            margin-left: 10px;
            font-weight: bold;
        }
        /* Button styling */
        button, .cart-button {
            --color: #000; /* Black color for buttons */
            font-family: inherit;
            display: inline-block;
            width: 6em;
            height: 2.6em;
            line-height: 2.5em;
            overflow: hidden;
            cursor: pointer;
            margin: 0;
            font-size: 17px;
            z-index: 1;
            color: white;
            background: var(--color); /* Default: black fill */
            border: 2px solid var(--color); /* Black border */
            border-radius: 6px;
            position: relative;
            text-align: center;
            transition: all 0.3s ease; /* Smooth transitions */
        }

        button:hover, .cart-button:hover {
            color: black; /* Text turns black */
            background: white; /* Button background turns white */
            border: 2px solid black; /* Border stays black */
        }

        .cart-button {
            display: flex;
            justify-content: center;
            align-items: center;
            text-decoration: none;
        }

        .cart-button span {
            font-size: 1.5em; /* Slightly larger icon size */
        }

        .home-image {
            width: 100%;
            height: auto;
            display: block;
            position: relative;
        }
        .text-overlay {
    position: absolute;
    top: 5%;
    left: 2%;
    color: white;
    font-size: 30px; /* Responsive font size */
    font-weight: bold;
    width: 40%;
    max-width: 600px; /* Limit max width for better readability */
    
    padding: 30px; /* Increased padding */
    border-radius: 15px; /* More rounded corners */
    
    line-height: 1.8; /* Increase line spacing */
}
    </style>
</head>
<body>

<jsp:include page="header.jsp"/>

<!-- Full-width image with text overlay -->
<div style="position: relative;">
    <img src="img/Home2.jpg" alt="Welcome to Freestyle Frenzy" class="home-image">
    <div class="text-overlay">
        Having the best gear isn't just about looking good its about trusting every turn, 
        every jump, and every landing. When you're out there pushing limits, your gear is 
        your partner, and you  want the best partner you can get.
    </div>
</div>

<%@ include file="listprod.jsp" %>

</body>
</html>