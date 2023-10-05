<%@ page import="java.util.Base64" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<nav class="navbar navbar-expand-lg navbar-light bg-secondary">
    <a class="navbar-brand" href="index.jsp">
        Shopzada
    </a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarNav">
        <form class="form-inline my-2 my-lg-0 mr-auto" action="${pageContext.request.contextPath}/ItemServlet" method="post" id="itemSearch">
            <input id="searchInput" class="form-control mr-sm-2 w-50" type="search" name="searchResult" placeholder="Search" aria-label="Search">
            <button class="btn btn-outline-light my-2 my-sm-0" type="submit" onclick="setSearchItemAttribute()">Search</button>
        </form>
        <c:if test="${not empty auth}">
        <ul class="navbar-nav ml-auto">
            <c:if test="${role eq 'admin'}">
                <li class="nav-item">
                <a class="nav-link" href="pendingSeller.jsp">
                    <i class="fa fa-user" style="position: relative; top: 5px; font-size: 24px;"></i>
                    <c:if test="${fn:length(pendingSellers) gt 0}">
                    <span class="badge badge-pill badge-danger cart-badge d-inline-block">${fn:length(pendingSellers)}</span>
                    </c:if>
                </a>
                </li>
                </c:if>
                <c:if test="${role eq 'seller'}">
                    <li class="nav-item">
                <a class="nav-link" href="shipment.jsp">
                    <i class="fas fa-shipping-fast" style="position: relative; top: 5px; font-size: 24px;"></i>
                    <c:if test="${fn:length(yetToShip) gt 0}">
                    <span class="badge badge-pill badge-danger cart-badge d-inline-block">${fn:length(yetToShip)}</span>
                    </c:if>
                </a>
                    </li>
                </c:if>
                <c:if test="${role eq 'customer'}">
                    <li class="nav-item">
                <a class="nav-link" href="cart.jsp">
                    <i class="fas fa-shopping-cart" style="position: relative; top: 5px; font-size: 24px;"></i>
                    <c:if test="${fn:length(cartList) gt 0}">
                    <span class="badge badge-pill badge-danger cart-badge d-inline-block">${fn:length(cartList)}</span>
                    </c:if>
                </a>
                    </li>
                </c:if>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLinkGuest1" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    <c:if test="${not empty user.getProfile_img()}">
                    <img src="${user.getProfile_img()}" width="30" height="30" class="rounded-circle d-inline-block align-top" alt="User Profile Picture">
                    </c:if>
                    <c:if test="${empty user.getProfile_img()}">
                    <img src="images/user.png" width="30" height="30" class="rounded-circle d-inline-block align-top" alt="User Profile Picture">
                    </c:if>
                </a>
                <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdownMenuLink">
                    <a class="dropdown-item" href="profile.jsp">My Account (<c:out value="${user.getUsername()}"/>)</a>
                    <c:if test="${role eq 'customer'}">
                        <a class="dropdown-item" href="order.jsp">My Orders</a>
                        <a class="dropdown-item" href="favourite_sellers.jsp">Sellers that I follow</a>
                    </c:if>
                    <c:if test="${role eq 'seller'}">
                        <a class="dropdown-item" href="order.jsp">Orders made to me</a>
                        <a class="dropdown-item" href="seller_dashboard.jsp?sellerId=${userDetail.getId()}">My seller dashboard</a>
                    </c:if>
                    <c:if test="${role eq 'admin'}">
                        <a class="dropdown-item" href="user_list.jsp">Manage Users</a>
                        <a class="dropdown-item" href="adminRegister.jsp">Register New Admin Staff</a>
                    </c:if>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/LogoutServlet">Log Out</a>
                </div>
            </li>
        </ul>
        </c:if>
        <c:if test="${empty auth}">
            <ul class="navbar-nav ml-auto">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLinkGuest1" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    <img src="images/user.png" width="30" height="30" class="rounded-circle d-inline-block align-top" alt="User Profile Picture">
                </a>
                <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdownMenuLink">
                    <a class="dropdown-item" href="login_and_register.jsp">Sign in</a>
                </div>
            </li>
        </ul>
        </c:if>
    </div>
</nav>
<style type="text/css">
    .navbar {
        background-color: #efefef;
    }

    .navbar-brand {
        margin-left: 50px; /* move the brand name to the right */
        font-family: 'Montserrat', sans-serif;
        font-weight: 700;
    }

    /* Set the font color of the navigation links */
    .navbar-dark .navbar-nav .nav-link {
        color: #444;
    }

    /* Add padding to the navigation links */
    .navbar-nav > li > a {
        padding: 10px;
    }

    /* Add a hover effect to the navigation links */
    .navbar-nav > li > a:hover,
    .navbar-nav > li > a:focus {
        color: #222;
        background-color: #f8f8f8;
    }

    /* Style the search form */
    .navbar-form {
        padding-right: 0;
    }

    .form-inline {
        flex: 1; /* make the search bar take up all available space */
        justify-content: center; /* center the search bar horizontally */
    }

    /* Style the search input */
    .navbar-form .form-control {
        border-radius: 0;
        border-color: #ccc;
    }

    .form-control {
        width: 300px; /* adjust the width as needed */
    }

    /* Style the search button */
    .navbar-form .btn {
        border-radius: 0;
        background-color: #eee;
        border-color: #ccc;
    }

    /* Add a hover effect to the search button */
    .navbar-form .btn:hover,
    .navbar-form .btn:focus {
        background-color: #f8f8f8;
    }

    .navbar .btn-outline-light my-2 my-sm-0 {
        color: #fff;
        border-color: #fff;
        background-color: #6c757d !important;
    }

    /* Style the cart button */
    .navbar-nav > .cart > a > i {
        font-size: 1.5rem;
        color: #444;
        transition: color 0.3s;
    }

    .cart-badge {
        top: -8px;
        right: -10px;
        font-size: 12px;
        font-weight: bold;
        padding: 5px 8px;
    }

    .navbar-nav .nav-item .nav-link i.fas.fa-shopping-cart {
        font-size: 24px;
    }

    .navbar-nav {
        margin-right: auto; /* push the cart and user profile to the left */
    }

    /* Add a hover effect to the cart button */
    .navbar-nav > .cart > a > i:hover,
    .navbar-nav > .cart > a > i:focus {
        color: #222;
    }

    /* Style the user profile picture */
    .navbar-nav > .dropdown > a > img {
        width: 30px;
        height: 30px;
        margin-right: 5px;
    }

    /* Style the dropdown menu */
    .dropdown-menu {
        margin-top: 5px;
        border-radius: 0;
        border: #1c1f23;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }

    /* Style the dropdown menu links */
    .dropdown-item {
        color: #444;
    }

    /* Add a hover effect to the dropdown menu links */
    .dropdown-item:hover,
    .dropdown-item:focus {
        color: #222;
        background-color: #f8f8f8;
    }

    .dropdown-menu a:hover {
        background-color: #333; /* Add a background color on hover */
        color: #fff; /* Change the link color on hover */
    }
</style>
<script>
    function setSearchItemAttribute() {
        const searchInput = document.getElementById('searchInput');
        const searchValue = searchInput.value;
        if (searchValue === '' || searchValue === null) {
            event.preventDefault();
            Swal.fire('Search input should not be empty!', '', 'error');
        } 
    }
</script>
