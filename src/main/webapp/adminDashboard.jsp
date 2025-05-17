<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("loginOptions.jsp");
        return;
    }

    String adminName = (String) session.getAttribute("adminName");
    if (adminName == null) {
        adminName = "Admin";  // Fallback if no name is set
    }
    // Proceed with rendering the dashboard using the correct admin name

    String firstName = null;
    int vendorCount = 0;
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/freshcart", "root", "root");

        String sql = "SELECT COUNT(*) AS vendor_count FROM vendors";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();

        if (rs.next()) {
            vendorCount = rs.getInt("vendor_count");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
        } catch (Exception e) {
        }
        try {
            if (stmt != null) stmt.close();
        } catch (Exception e) {
        }
        try {
            if (conn != null) conn.close();
        } catch (Exception e) {
        }
    }

    if (adminName != null && adminName.contains(" ")) {
        firstName = adminName.split(" ")[0];
    } else {
        firstName = adminName;
    }

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | FreshCart</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&family=Roboto:wght@400;500&display=swap"
          rel="stylesheet">
    <link rel="stylesheet" href="adminDashboard.css">
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <div class="sidebar-header">
        <div class="logo-box">
            <span class="fresh">Fresh</span><span class="cart">Cart</span>
        </div>
    </div>
    <ul class="sidebar-menu">
        <li><a href="#dashboard">Dashboard</a></li>
        <li><a href="#vendors">Vendors</a></li>
        <li><a href="#products">Products</a></li>
        <li><a href="logout.jsp">Logout</a></li>
    </ul>
</div>

<!-- Main Content -->
<div class="main-content">
    <header>
        <h1>Hello <%= firstName != null ? firstName : "Admin" %> 👋</h1>
        <br>
        <h2>Welcome to your Admin Dashboard</h2>
    </header>


    <%
        int productCount = 0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/freshcart", "root", "root");

            String sql = "SELECT COUNT(*) FROM products";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

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

    <section id="dashboard" class="section">
        <h2>Dashboard Overview</h2>
        <div class="dashboard-stats">
            <div class="stat-card">
                <h3>Total Vendors</h3>
                <p><%= vendorCount %>
                </p>
            </div>
            <div class="stat-card">
                <h3>Total Products</h3>
                <p><%= productCount %>
                </p>
            </div>
        </div>
    </section>

    <section id="vendors" class="section">
        <h2>Vendors</h2>

        <div class="actions">

            <button class="btn btn-primary" onclick="openModal()">Add New Vendor</button>
        </div>

        <br>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>

        <div id="errorMessage" class="error-message" style="color: red; font-weight: bold; margin-bottom: 15px;">
            <%= error %>
        </div>

        <script>
            // Hide the error message after 5 seconds
            setTimeout(function () {
                var errorMessage = document.getElementById("errorMessage");
                if (errorMessage) {
                    errorMessage.style.display = 'none';
                }
            }, 5000); // 5000 milliseconds = 5 seconds
        </script>
        <% } %>

        <%
            java.util.List<String[]> vendorList = new java.util.ArrayList<>();
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/freshcart", "root", "root");

                String query = "SELECT v.username, e.first_name, e.employee_id, v.password " +
                        "FROM vendors v JOIN employees e ON v.employee_id = e.employee_id";
                stmt = conn.prepareStatement(query);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    String usernameV = rs.getString("username");
                    String firstNameV = rs.getString("first_name");
                    String empId = rs.getString("employee_id");
                    String passwordV = rs.getString("password");
                    vendorList.add(new String[]{usernameV, firstNameV, empId, passwordV});
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) rs.close();
                } catch (Exception e) {
                }
                try {
                    if (stmt != null) stmt.close();
                } catch (Exception e) {
                }
                try {
                    if (conn != null) conn.close();
                } catch (Exception e) {
                }
            }
        %>

        <br><br>

        <div class="vendor-list-wrapper <%= vendorList.size() > 15 ? "scrollable-vendor-list" : "" %>">
            <% for (String[] vendor : vendorList) { %>
            <div class="vendor-card"
                 onclick="openEditModal('<%= vendor[2] %>', '<%= vendor[0] %>', '<%= vendor[3] %>')">
                <h4><%= vendor[1] %>
                </h4>
                <p><strong>Employee ID:</strong> <%= vendor[2] %>
                </p>
                <p><strong>Username:</strong> <%= vendor[0] %>
                </p>
            </div>
            <% } %>
        </div>

        <!-- Modal Structure -->
        <div id="addVendorModal" class="modal" style="display: none">
            <div class="add-vendor-modal-content">
                <h2>Add New Vendor</h2>

                <form action="vendorAddition" method="post" class="admin-register-form">
                    <!-- Admin Name -->
                    <label for="EmployeeID" class="add-vendor-label">Employee ID</label>
                    <input type="text" id="EmployeeID" name="EmployeeID" class="add-vendor-input"
                           placeholder="Enter your Employee ID" required>

                    <!-- Admin Username -->
                    <label for="username" class="add-vendor-label">Username</label>
                    <input type="text" id="username" name="username" class="add-vendor-input"
                           placeholder="Choose a username" required>

                    <!-- Admin Password -->
                    <label for="password" class="add-vendor-label">Password</label>
                    <input type="password" id="password" name="password" class="add-vendor-input"
                           placeholder="Enter password" required>

                    <!-- Confirm Password -->
                    <label for="confirm-password" class="add-vendor-label">Confirm Password</label>
                    <input type="password" id="confirm-password" name="confirm-password" class="add-vendor-input"
                           placeholder="Confirm password" required>

                    <br><br>
                    <button type="submit" class="add-vendor-submit-btn">Add New Vendor</button>
                    <br><br>
                    <button type="button" class="add-vendor-cancel-btn" onclick="closeModal()">Cancel</button>
                </form>
            </div>
        </div>

        <!-- Edit Vendor Modal -->
        <div id="editVendorModal" class="modal" style="display: none;">
            <div class="add-vendor-modal-content">
                <h2>Edit Vendor</h2>
                <br>

                <form action="editVendor" method="post" class="admin-register-form">
                    <label for="editEmployeeID" class="add-vendor-label">Employee ID</label>
                    <input type="text" id="editEmployeeID" name="EmployeeID" class="add-vendor-input" readonly
                           placeholder="Employee ID">

                    <label for="editUsername" class="add-vendor-label">Username</label>
                    <input type="text" id="editUsername" name="username" class="add-vendor-input" required>

                    <!-- Current Password -->
                    <label for="currentPassword" class="add-vendor-label">Current Password</label>
                    <div class="password-container">
                        <input type="password" id="currentPassword" name="currentPassword" class="add-vendor-input"
                               readonly placeholder="Current Password">
                        <span class="eye-icon" onclick="togglePasswordVisibility('currentPassword')">👁️</span>
                    </div>

                    <!-- New Password (Enter new password) -->
                    <label for="editPassword" class="add-vendor-label">Enter new Password</label>
                    <div class="password-container">
                        <input type="password" id="editPassword" name="password" class="add-vendor-input"
                               placeholder="Enter new password"
                               oninput="toggleEyeIcon('editPassword')" onfocus="handleInputFocus('editPassword')">
                        <span class="eye-icon" onclick="togglePasswordVisibility('editPassword')"
                              style="display: none;">👁️</span>
                    </div>

                    <br><br>
                    <button type="submit" class="add-vendor-submit-btn">Save Changes</button>
                    <br><br>
                    <button type="button" class="add-vendor-cancel-btn" onclick="closeEditModal()">Cancel</button>

                    <br><br>

                    <button type="button" id="deleteEmployeeID" name="vendor_Id"
                            class="add-vendor-cancel-btn delete-btn" onclick="openDeleteModal()" style="width: 100%">
                        Delete Vendor
                    </button>

                </form>

            </div>
        </div>

        <!-- Delete Vendor Confirmation Modal -->
        <div id="deleteVendorModal" class="modal" style="display: none;">
            <div class="delete-vendor-modal-content">
                <h2>Confirm Deletion</h2>
                <p>Are you sure you want to delete this vendor?</p>

                <form action="deleteVendor" method="post" class="admin-delete-form">

                    <input type="hidden" name="vendor_id" id="vendor_id">
                    <!-- Admin Password -->
                    <label for="adminPassword" class="add-vendor-label">Enter Your Admin Password</label>
                    <input type="password" id="adminPassword" name="adminPassword" class="add-vendor-input"
                           placeholder="Enter your admin password" required>

                    <br>
                    <button type="submit" class="delete-vendor-submit-btn">Delete Vendor</button>

                    <button type="button" class="delete-vendor-cancel-btn" onclick="closeDeleteModal()">Cancel</button>
                </form>
            </div>
        </div>

    </section>

    <section id="products" class="section">
        <h2>Products</h2>
        <div class="actions">
            <button class="btn btn-primary" onclick="toggleProductForm()">Add New Product</button>
        </div>

        <br>

        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
        <div id="errormsg" style="color: red; font-weight: bold;"><%= errorMessage %>
        </div>
        <%
            }
        %>

        <script>
            // Hide the error message after 5 seconds
            setTimeout(function () {
                var errorMessage = document.getElementById("errormsg");
                if (errorMessage) {
                    errorMessage.style.display = 'none';
                }
            }, 5000); // 5000 milliseconds = 5 seconds
        </script>

        <br><br>

        <div class="product-scroll-container">
            <%
                conn = null;
                stmt = null;
                rs = null;

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

            <div class="product-card"
                 onclick="showProductDetails('<%= name %>', '<%= type %>', <%= stock %>, '<%= desc.replace("'", "\\'") %>', <%= price %>, '<%= image %>', '<%= productId%>>')">
                <img src="<%= image %>" alt="Product Image">
                <h3><%= name %>
                </h3>
                <p>LKR <%= price %>
                </p>
            </div>

            <%
                    }
                } catch (Exception e) {
                    out.println("<p>Error loading products: " + e.getMessage() + "</p>");
                    e.printStackTrace(); // This prints full details to server logs
                } finally {
                    try {
                        if (rs != null) rs.close();
                    } catch (Exception e) {
                    }
                    try {
                        if (stmt != null) stmt.close();
                    } catch (Exception e) {
                    }
                    try {
                        if (conn != null) conn.close();
                    } catch (Exception e) {
                    }
                }
            %>
        </div>

    </section>
</div>

<!-- Modal Background Overlay -->
<div id="overlay" class="productmodel-overlay" style="display: none;"></div>

<!-- Product Modal -->
<div id="productModal" class="productmodel-modal" style="display: none;">
    <div class="productmodel-modal-content">
        <span class="close-btn" onclick="toggleProductForm()">&times;</span>
        <h2>Add New Product</h2>

        <form action="AddProductFromAdmin" method="post" enctype="multipart/form-data">
            <input type="text" id="product_name" name="product_name" placeholder="Product Name" required>
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
            <button class="edit-btn" onclick="openEditForm()">Edit</button>
            <br><br>
            <button class="delete-btn" onclick="deleteProduct()">Delete</button>
        </div>
    </div>
</div>

<!-- Edit Product Form Modal (New Popup) -->
<div id="editProductModal" class="editfromadminmodal" style="display: none;">
    <div class="editfromadminmodal-content">
        <span class="close-btn" onclick="closeEditForm()">&times;</span>
        <h2>Edit Product</h2>
        <form action="EditProductFromAdmin" method="post" enctype="multipart/form-data">
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
        <form id="confirmDeleteForm" method="post" action="DeleteProductFromAdmin">
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

        console.log("Deleting product ID:", currentProduct.productId);

    }

    function closeConfirmDeleteModal() {
        document.getElementById("confirmDeleteModal").style.display = "none";
        document.getElementById("overlay").style.display = "none";
    }

</script>


<!-- Footer -->
<footer class="footer">
    <p>&copy; 2025 FreshCart. Internal Use Only. All Rights Reserved.</p>
</footer>

<script>
    // Open the modal
    function openModal() {
        document.getElementById("addVendorModal").style.display = "flex";
        document.body.classList.add("modal-open");
    }

    // Close the modal
    function closeModal() {
        document.getElementById("addVendorModal").style.display = "none";
        document.body.classList.remove("modal-open");
    }

    // Close modal if clicking outside the modal content
    window.onclick = function (event) {
        const modal = document.getElementById("addVendorModal");
        if (event.target === modal) {
            closeModal();
        }
    }
</script>

<script>
    function openEditModal(employeeId, username, currentPassword) {
        // Set the form fields
        document.getElementById("editEmployeeID").value = employeeId;
        document.getElementById("editUsername").value = username;
        document.getElementById("deleteEmployeeID").value = employeeId;

        // Set the current password field (readonly)
        document.getElementById("currentPassword").value = currentPassword;

        // Display the modal
        document.getElementById("editVendorModal").style.display = "flex";
        document.body.classList.add("modal-open");
    }


    function closeEditModal() {
        document.getElementById("editVendorModal").style.display = "none";
        document.body.classList.remove("modal-open");
    }

    // Optional: close modal if clicked outside
    window.onclick = function (event) {
        const editModal = document.getElementById("editVendorModal");
        if (event.target === editModal) {
            closeEditModal();
        }

        const addModal = document.getElementById("addVendorModal");
        if (event.target === addModal) {
            closeModal();
        }
    }

    // This function toggles password visibility and changes the eye icon.
    function togglePasswordVisibility(inputId) {
        const passwordField = document.getElementById(inputId);
        const eyeIcon = passwordField.nextElementSibling;

        // Toggle the password field visibility and icon when clicked
        if (passwordField.type === "password") {
            passwordField.type = "text";
            eyeIcon.textContent = "🙈";  // Change eye icon to indicate password is visible
        } else {
            passwordField.type = "password";
            eyeIcon.textContent = "👁️";  // Change eye icon to indicate password is hidden
        }
    }

    // This function controls the visibility of the eye icon based on the input content.
    function toggleEyeIcon(inputId) {
        const passwordField = document.getElementById(inputId);
        const eyeIcon = passwordField.nextElementSibling;

        // Show the eye icon only if the field has some value
        if (passwordField.value.length > 0) {
            eyeIcon.style.display = 'inline';  // Show the eye icon when there's text
        } else {
            eyeIcon.style.display = 'none';   // Hide the eye icon when the field is empty
            passwordField.type = "password";  // Ensure the password is hidden when cleared
            eyeIcon.textContent = "👁️";      // Reset icon to "👁️" when empty
        }

        // Ensure that the eye icon is toggled correctly
        if (passwordField.type === "password") {
            eyeIcon.textContent = "👁️";  // Set default icon for hidden password
        } else {
            eyeIcon.textContent = "🙈";  // Set icon for visible password
        }
    }

    // This function will handle when content is typed and control the visibility of the eye icon
    function handleInputFocus(inputId) {
        const passwordField = document.getElementById(inputId);
        const eyeIcon = passwordField.nextElementSibling;

        // Only show the eye icon if there's text typed in the input field
        if (passwordField.value.length > 0) {
            eyeIcon.style.display = 'inline';  // Show the eye icon if there's text
        } else {
            eyeIcon.style.display = 'none';   // Hide the eye icon if the field is empty
        }
    }

    // Ensure that the eye icon is hidden on page load.
    window.onload = function () {
        // Initially hide the eye icon for the "Enter new Password" field
        const editPasswordField = document.getElementById('editPassword');
        const editPasswordEyeIcon = editPasswordField.nextElementSibling;
        editPasswordEyeIcon.style.display = 'none';
    };

    function openDeleteModal() {
        // Set the vendor ID into the hidden input field in the form
        // document.getElementById("editEmployeeID").value = vendor_Id
        let emp_Id;
        emp_Id = document.getElementById('editEmployeeID').value;
        document.getElementById('vendor_id').value = emp_Id;


        // Show the modal
        document.getElementById('deleteVendorModal').style.display = 'flex';
    }

    // Close the delete modal
    function closeDeleteModal() {
        document.getElementById("deleteVendorModal").style.display = "none";
        document.body.classList.remove("modal-open");
    }

</script>

</body>
</html>
