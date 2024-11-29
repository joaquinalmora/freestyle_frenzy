BONUS 1 - Updating Cart:
We added 3 new variables in the `showcart.jsp` file to handle the update and delete actions: `updateAction`, `deleteId`, and `newQty`. Then added a form with the number input next to each itemm abd si when this number is changed and the update button is clicked, the new quantity is sent to the `showcart.jsp` file and updates the quantity of the item in the cart: // Handle quantity updates
if (updateAction != null && newQty != null) {
    ArrayList<Object> product = productList.get(updateAction);
    product.set(3, Integer.parseInt(newQty));
    if (Integer.parseInt(newQty) <= 0) {
        productList.remove(updateAction);
    }
}
 If the quantity is 0 or less, the item is removed from the cart. Also added a remove link next to each item that sends a delete request to the `showcart.jsp` file and removes the item from the cart: if (deleteId != null) {
    productList.remove(deleteId);
}

BONUS 3 - Style:

We made three major improvements to our grocery website. First, we created a header.jsp file that adds the same navigation menu to every page, making it easier for customers to move around the site. Second, we updated the product listing page (listprod.jsp) by adding category filters, so shoppers can now find items by selecting specific types of products like drinks or snacks. Finally, we gave the shopping cart page (showcart.jsp) a fresh look by making it less plain and adding useful buttons that help customers manage their purchases better.

