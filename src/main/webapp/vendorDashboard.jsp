<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, java.util.*, javax.servlet.*, javax.servlet.http.*"%>
<%
  // Check if session exists and vendor is logged in
  session = request.getSession(false);
  if (session == null || session.getAttribute("username") == null) {
    // No session or vendor is not logged in, redirect to loginOptions.jsp
    response.sendRedirect("loginOptions.jsp");
    return;
  }

  // Get the vendor name from the session attribute
  String vendorName = (String) session.getAttribute("vendorName");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Vendor Dashboard | FreshCart</title>
  <!-- Google Font for professional look -->
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="vendorDashboard.css">
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
  <div class="logo">
    <div class="logo-box">
      <span class="fresh">Fresh</span><span class="cart">Cart</span>
    </div>
  </div>
  <ul>
    <li><a href="#dashboard">Dashboard Home</a></li>
    <li><a href="#products">Manage Products</a></li>
    <li><a href="#orders">Manage Orders</a></li>
    <li><a href="logout.jsp">Logout</a></li>
  </ul>
</div>

<!-- Main Content -->
<div class="main-content">
  <!-- Dashboard Overview Section -->
  <section id="dashboard" class="section">
    <h1>Hello, <%= vendorName %> 👋</h1><br><br>
    <h1>Welcome to your Vendor Dashboard</h1>
  </section>

  <%
    int productCount = 0;

    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/freshcart", "root", "root");

      String sql = "SELECT COUNT(*) FROM products";
      PreparedStatement stmt = conn.prepareStatement(sql);
      ResultSet rs = stmt.executeQuery();

      if (rs.next()) {
        productCount = rs.getInt(1);
      }

      rs.close();
      stmt.close();
      conn.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
  %>

  <!-- Manage Products Section -->
  <section id="products" class="section">
    <h2>Manage Products</h2>
    <br>

    <div class="stat-card">
      <h3>Total Products</h3>
      <p><%= productCount %></p>
    </div>

    <br>

    <div class="actions">
      <button onclick="toggleProductForm()">Add New Product</button>
    </div>

    <br>

    <%
      String errorMessage = (String) request.getAttribute("errorMessage");
      if (errorMessage != null) {
    %>
    <div id="errormsg" style="color: red; font-weight: bold;"><%= errorMessage %></div>
    <%
      }
    %>


    <script>
      // Hide the error message after 5 seconds
      setTimeout(function() {
        var errorMessage = document.getElementById("errormsg");
        if (errorMessage) {
          errorMessage.style.display = 'none';
        }
      }, 5000); // 5000 milliseconds = 5 seconds
    </script>

    <br>

    <div class="product-scroll-container">

      <%
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
          Class.forName("com.mysql.cj.jdbc.Driver");
          conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/freshcart", "root", "root");

          String sql = "SELECT * FROM products ORDER BY created_at DESC";
          stmt = conn.prepareStatement(sql);
          rs = stmt.executeQuery();

          while (rs.next()) {
            String productId = rs.getString("product_id");
            String name = rs.getString("product_name");
            String type = rs.getString("product_type");
            int stock = rs.getInt("available_stock");
            String desc = rs.getString("description");
            double price = rs.getDouble("price");
            String image = rs.getString("image_url");
      %>

      <div class="product-card" onclick="showProductDetails('<%= name %>', '<%= type %>', <%= stock %>, '<%= desc.replace("'", "\\'") %>', <%= price %>, '<%= image %>', '<%= productId.replace("'", "\\'") %>')">
      <img src="<%= image %>" alt="Product Image">
        <h3><%= name %></h3>
        <p>LKR <%= price %></p>
      </div>

      <%
          }
        } catch (Exception e) {
          out.println("<p>Error loading products: " + e.getMessage() + "</p>");
          e.printStackTrace(); // This prints full details to server logs
        }
        finally {
          try { if (rs != null) rs.close(); } catch (Exception e) {}
          try { if (stmt != null) stmt.close(); } catch (Exception e) {}
          try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
      %>
    </div>

  </section>

  <!-- Modal Background Overlay -->
  <div id="overlay" class="overlay" style="display: none;"></div>

  <!-- Product Modal -->
  <div id="productModal" class="modal" style="display: none;">
    <div class="modal-content">
      <span class="close-btn" onclick="toggleProductForm()">&times;</span>
      <h2>Add New Product</h2>

      <form action="AddProduct" method="post" enctype="multipart/form-data">
        <label for="product_name"></label><input type="text" id="product_name" name="product_name" placeholder="Product Name" required>
        <select id="type" name="type" required>
          <option value="Fresh Fruits">Fresh Fruits</option>
          <option value="Vegetables">Vegetables</option>
          <option value="Dairy Products">Dairy Products</option>
          <option value="Meat & Poultry">Meat & Poultry</option>
          <option value="Snacks & Beverages">Snacks & Beverages</option>
          <option value="Bakery Items">Bakery Items</option>
          <option value="Seafood">Seafood</option>
          <option value="Frozen Foods">Frozen Foods</option>
        </select>
        <input type="number" min="0" name="available_stock" placeholder="Available Stock" required>
        <textarea name="description" placeholder="Product Description" required></textarea>
        <input type="number" step="0.01" min="0" name="price" placeholder="Price (LKR)" required>
        <label for="image">Upload Image</label>
        <input type="file" id="image" name="image_url" accept="image/*" required>
        <button type="submit">Submit Product</button>
      </form>
    </div>
  </div>

  <script>
    function toggleProductForm() {
      const modal = document.getElementById("productModal");
      const overlay = document.getElementById("overlay");

      const isVisible = modal.style.display === "block";
      modal.style.display = isVisible ? "none" : "block";
      overlay.style.display = isVisible ? "none" : "block";
    }
  </script>

  <!-- Product Detail Modal -->
  <div id="productDetailModal" class="modalforproduct" style="display: none;">
    <div class="modalforproduct-content">
      <span class="close-btn" onclick="closeProductDetails()">&times;</span>
      <img id="detailImage" src="" alt="Product Image">
      <h2 id="detailName"></h2>
      <p><strong>Type:</strong> <span id="detailType"></span></p><br>
      <p><strong>Available Stock:</strong> <span id="detailStock"></span></p><br>
      <p><strong>Description:</strong> <span id="detailDesc"></span></p><br>
      <p><strong>Price:</strong> LKR <span id="detailPrice"></span></p><br>

      <!-- Product Modal Buttons (View/Edit) -->
      <div class="product-modal-buttons">
        <button class="edit-btn" onclick="openEditForm()">Edit</button><br><br>
        <button class="delete-btn" onclick="deleteProduct()">Delete</button>
      </div>
    </div>
  </div>

  <!-- Edit Product Form Modal (New Popup) -->
  <div id="editProductModal" class="modal" style="display: none;">
    <div class="modal-content">
      <span class="close-btn" onclick="closeEditForm()">&times;</span>
      <h2>Edit Product</h2>
      <form action="EditProduct" method="POST" enctype="multipart/form-data">
        <input type="hidden" id="editProductId" name="product_id">
        <input type="text" id="editProductName" name="product_name" required>
        <select id="editProductType" name="product_type" required>
          <option value="Fresh Fruits">Fresh Fruits</option>
          <option value="Vegetables">Vegetables</option>
          <option value="Dairy Products">Dairy Products</option>
          <option value="Meat & Poultry">Meat & Poultry</option>
          <option value="Snacks & Beverages">Snacks & Beverages</option>
          <option value="Bakery Items">Bakery Items</option>
          <option value="Seafood">Seafood</option>
          <option value="Frozen Foods">Frozen Foods</option>
        </select>
        <input type="number" id="editAvailableStock" name="available_stock" min="0" required>
        <textarea id="editDescription" name="description" required></textarea>
        <input type="number" id="editPrice" name="price" step="0.01" min="0" required>
        <label for="editImage">Upload Image</label>
        <input type="file" id="editImage" name="image_url" accept="image/*">
        <button type="submit">Update Product</button>
        <button type="button" class="cancel-btn" onclick="closeEditForm()">Cancel</button>
      </form>
    </div>
  </div>


  <!-- Password Confirmation Modal -->
  <div id="confirmDeleteModal" class="modal" style="display: none;">
    <div class="modal-content">
      <span class="close-btn" onclick="closeConfirmDeleteModal()">&times;</span>
      <h2>Confirm Deletion</h2>
      <p>Please enter your password to delete this product:</p>
      <form id="confirmDeleteForm" method="post" action="DeleteProduct">
        <input type="hidden" name="product_id" id="deleteProductId">
        <input type="password" name="password" placeholder="Enter your password" required>
        <button type="submit">Confirm Delete</button>
        <button type="button" class="cancel-btn" onclick="closeConfirmDeleteModal()">Cancel</button>
      </form>
    </div>
  </div>

  <script>
    // Function to open the Edit Product modal and pre-fill form with current product details
    function openEditForm() {
      // Hide the view-only product details
      document.getElementById("productDetailModal").style.display = "none";

      // Show the Edit Product modal
      document.getElementById("editProductModal").style.display = "block";

      // DEBUG: log product info
      console.log("Editing Product ID:", currentProduct.productId);

      // Populate the Edit Form with the current product details
      document.getElementById("editProductId").setAttribute("value", currentProduct.productId);
      document.getElementById("editProductName").value = currentProduct.productName;
      document.getElementById("editProductType").value = currentProduct.productType;
      document.getElementById("editAvailableStock").value = currentProduct.stock;
      document.getElementById("editDescription").value = currentProduct.description;
      document.getElementById("editPrice").value = currentProduct.price;
    }

    // Function to close the Edit Product modal without saving
    function closeEditForm() {
      // Hide the Edit Product modal
      document.getElementById("editProductModal").style.display = "none";

      // Show the original product detail modal
      document.getElementById("productDetailModal").style.display = "block";
    }

    // Store the current product details globally when a product is clicked for viewing
    let currentProduct = {};


    function showProductDetails(name, type, stock, description, price, imageUrl, productId) {
      // Store the current product details
      currentProduct = {
        productId: productId,  // Ensure productId is stored here
        productName: name,
        productType: type,
        stock: stock,
        description: description,
        price: price,
        imageUrl: imageUrl
      };

      document.getElementById("detailName").innerText = name;
      document.getElementById("detailType").innerText = type;
      document.getElementById("detailStock").innerText = stock;
      document.getElementById("detailDesc").innerText = description;
      document.getElementById("detailPrice").innerText = price.toFixed(2);
      document.getElementById("detailImage").src = imageUrl;

      // Open the product detail modal
      document.getElementById("productDetailModal").style.display = "block";
      document.getElementById("overlay").style.display = "block";
    }

    function closeProductDetails() {
      document.getElementById("productDetailModal").style.display = "none";
      document.getElementById("overlay").style.display = "none";
    }

    function deleteProduct() {
      document.getElementById("deleteProductId").value = currentProduct.productId;
      document.getElementById("confirmDeleteModal").style.display = "block";
      document.getElementById("productDetailModal").style.display = "none";
    }

    function closeConfirmDeleteModal() {
      document.getElementById("confirmDeleteModal").style.display = "none";
      document.getElementById("overlay").style.display = "none";
    }

  </script>

  <!-- Manage Orders Section -->
  <section id="orders" class="section">
    <h2>Pending Orders</h2>

    <div class="order-details">
      <br>
      <table>
        <tr>
          <th>Order ID</th>
          <th>Customer</th>
          <th>Product</th>
          <th>Status</th>
          <th>Action</th>
        </tr>
        <!-- Sample Pending Order -->
        <tr>
          <td>1001</td>
          <td>John Doe</td>
          <td>Fresh Apples</td>
          <td>Pending</td>
          <td><button>Update Status</button></td>
        </tr>
        <tr>
          <td>1002</td>
          <td>Jane Smith</td>
          <td>Organic Bananas</td>
          <td>Pending</td>
          <td><button>Update Status</button></td>
        </tr>
      </table>
    </div>
  </section>
</div>

</body>
</html>
