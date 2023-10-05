<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Base64" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/includes/header.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        .btn-outline-light my-2 my-sm-0 {
            color: #fff;
            border-color: #fff;
            background-color: #6c757d !important;
        }
        
        .itemContainer{
            display: grid;
            grid-template-columns: repeat(5,1fr);
            grid-row-gap:30px;
            grid-column-gap: 15px;
        }
        
        .userContainer{
        display: grid;
        grid-template-columns: repeat(5,1fr);
        grid-row-gap:30px;
        grid-column-gap: 15px;
    }
        
    .product-card {
        width: 100%;
        border: 1px solid #e0e0e0;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        border-radius: 5px;
    }

    .product-price {
        font-weight: bold;
        color: #333;
        margin: 0.5rem 0;
        justify-content: flex-start;
    }

    .product-footer-card{
        display: flex;
        flex-direction: column;
        width: 100%;
        gap:20px;
    }

    .product-card:hover{
        color: white;
        background-color: #72a0f6;
    }

    .product-details-button-card{
        font-family: 'Inter';
        font-style: normal;
        font-weight: 500;
        font-size: 14.6058px;
        color: #5182d0;
        background-color: transparent;
        outline: none;
        cursor: pointer;
        border: 1px solid #9DC2FF;
        padding: 4px 10px;
        border-radius: 4.17308px;
        align-self: flex-end;
        transition: all 0.2s ease-in;
    }

    .product-rating-value-card{
        font-family: 'Inter';
        font-style: normal;
        font-weight: 400;
        font-size: 15px;
        color: rgba(63, 63, 63, 0.87);
    }

    .product-card-rating{
        display: flex;
        flex-direction: row;
        gap:8px;
        align-items: center;
        align-self: flex-start;
    }

    *{
        padding: 0;
        margin:0;
    }

    .product-content-card{
        display: flex;
        flex-direction: column;
        padding: 15px 32px 20px;
        justify-content: space-between;
        align-items: flex-start;
        height: 100%;
    }
    
    .red{
        background-color: #e03e3e;
        position: absolute;
        color: #fff;
        border-radius: 5px;
        right: 5px;
        top: 5px;
        font-size: 0.9rem;
    }

    .product-image-card-wrapper img{
        width: 100%;
        height: 100%;
        object-fit: contain;
    }

    .product-image-card-wrapper{
        height: 165px;
        width: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        border-bottom: 1px solid #F6F6F9;
    }

    .product-card{
        width: 100%;
        height: 350px;
        background: #FFFFFF;
        border: 0.5px solid #EAEAEF;
        box-shadow: 0px 1px 4px rgba(26, 26, 67, 0.1);
        border-radius: 7px;
        display: flex;
        flex-direction: column;
        align-items: center;
        overflow: hidden;
    }

    .product-title-card{
        display: -webkit-box;
        -webkit-box-orient: vertical;
        overflow: hidden;
        font-family: 'Inter', serif;
        font-style: normal;
        font-weight: 400;
        font-size: 16.6923px;
        color: #19191D;
        -webkit-line-clamp: 3;
        line-clamp: 3;
        max-height: 77px;
        text-overflow: ellipsis;
    }

    .product-price-card{
        font-family: 'Inter';
        font-style: normal;
        font-weight: 700;
        font-size: 25.0385px;
        color: rgba(0, 0, 0, 0.87);
        margin: 7px 0px 9px;
    }

    .product-description-card{
        display: -webkit-box;
        -webkit-box-orient: vertical;
        overflow: hidden;
        font-family: 'Inter';
        font-style: normal;
        font-weight: 400;
        font-size: 14.6058px;
        color: #787885;
        margin-bottom: 10px;
        -webkit-line-clamp: 7;
        line-clamp: 7;
    }
    </style>
</head>
<body>
    <jsp:include page="/includes/navbar.jsp" />
    <c:if test="${not empty auth}">
        <c:if test="${role eq 'admin'}">
    <div class="label-container">
        <label style="font-family: 'Montserrat', sans-serif; font-weight: 700; margin: 20px 20px;">
            Reporting Dashboard
        </label>
    </div>
    <hr>
    <div id="platformStats" style="display:column; margin-left: 30px;">
        <p>Top 3 sellers with highest credit</p>
        <div style="display:flex; margin-left: 30px;">
            <c:if test="${fn:length(topThreeSellers) gt 0}">
            <div class="userContainer" id="sellersDiv" style="display:grid">
                <c:forEach items="${topThreeSellers}" var="targetSeller" varStatus="status">
                    <div class="container">
                            <div class="row">
                                <div class="col-md-4" style="width: 100%">
                                    <a href="seller_dashboard.jsp?userId=${targetSeller.getId()}">
                                        <div class="card product-card" id="user-id-${targetSeller.getId()}">
                                            <div class="px-2 red text-uppercase"> Top ${status.index + 1} seller</div>
                                        <c:if test="${not empty targetSeller.getProfile_img()}">
                                            <div class="d-flex justify-content-center">
                                            <img src="${targetSeller.getProfile_img()}" style="width:200px; height:200px; object-fit: contain;margin: 0 auto;" class="card-img-top" alt="Category Image">
                                            </div>
                                        </c:if>
                                        <c:if test="${empty targetSeller.getProfile_img()}">
                                            <div class="d-flex justify-content-center">
                                            <img src="images/user.png" style="width:200px; height:200px; object-fit: contain;margin: 0 auto;" class="card-img-top" alt="Category Image">
                                            </div>
                                        </c:if>
                                            <div class="card-body">
                                                <p> ${targetSeller.getUsername()} </p>
                                                <div class="d-flex align-items-center justify-content-start rating border-top border-bottom py-2">
                                                    <p>Email: ${targetSeller.getEmail()}</p>
                                                </div>
                                                <div class="d-flex align-items-center justify-content-start rating border-top border-bottom py-2">
                                                    <p>Role: ${targetSeller.getRole()}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        </div>
                </c:forEach>
            </div>
            </c:if>
            <c:if test="${fn:length(topThreeSelers) eq 0}">
            <div class="userContainer" id="sellersDiv" style="display:none">
                <p> Nothing found. </p>
            </div>
            </c:if>
        </div>
        <hr>
        <p>Top 3 items with highest sales</p>
        <div style="display:flex; margin-left: 30px;">
            <c:if test="${fn:length(topThreeItemsBySales) gt 0}">
                <jsp:include page="item_list.jsp?showSales=true" />
            </c:if>
            <c:if test="${fn:length(topThreeItemsBySales) eq 0}">
                <div class="userContainer" id="sellersDiv" style="display:none">
                    <p> Nothing found. </p>
                </div>
            </c:if>
        </div>
        <hr>
        <p>Top 3 items with highest ratings</p>
        <div style="display:flex; margin-left: 30px;">
            <c:if test="${fn:length(topThreeItemsByRating) gt 0}">
                <jsp:include page="item_list.jsp?showRatings=true" />
            </c:if>
            <c:if test="${fn:length(topThreeItemsByRating) eq 0}">
            <div class="userContainer" id="sellersDiv" style="display:none">
                <p> Nothing found. </p>
            </div>
            </c:if>
        </div>
        <hr>
    </div>
        </c:if>
        <c:if test="${role eq 'seller'}">
        <div class="label-container">
        </div>    
        <div style="margin-left: 10px; margin-top: 10px;">
            <button class="btn btn-outline-dark my-2 my-sm-0" onclick="location.href='new_item.jsp'">Create new item for sale</button>
        </div>
        <hr>
        <jsp:include page="item_list.jsp" />
        </c:if>
        <c:if test="${role eq 'customer'}">
    <div class="label-container">
        <label style="font-family: 'Montserrat', sans-serif; font-weight: 700; margin: 20px 20px;">
            Product Categories
        </label>
    </div>
    <jsp:include page="/includes/category.jsp" />
    <jsp:include page="item_list.jsp?categoryId=0" />
    </c:if>
    </c:if>
    <c:if test="${empty auth}">
    <div class="label-container">
        <label style="font-family: 'Montserrat', sans-serif; font-weight: 700; margin: 20px 20px;">
            Product Categories
        </label>
    </div>
    <jsp:include page="/includes/category.jsp" />
    <jsp:include page="item_list.jsp?categoryId=0" />
    </c:if>
    <br/>
    <br/>
    <jsp:include page="/includes/footer.jsp" />
</body>
<script>
    function showAlert(title, text, type) {
        Swal.fire({
            title: title,
            text: text,
            icon: type,
            confirmButtonColor: '#3085d6',
            confirmButtonText: 'OK'
        });
    }
                
    function showPlatformStats(){
        document.getElementById("platformStats").style.display = "block";
        document.getElementById("sellerStats").style.display = "none";
        document.getElementById("itemStats").style.display = "none";
    }

    function showSellerStats(){
        document.getElementById("platformStats").style.display = "none";
        document.getElementById("sellerStats").style.display = "block";
        document.getElementById("itemStats").style.display = "none";
    }

    function showItemStats(){
        document.getElementById("platformStats").style.display = "none";
        document.getElementById("sellerStats").style.display = "none";
        document.getElementById("itemStats").style.display = "block";
    }
    
    <c:if test="${not empty loginStatus && loginStatus eq 'yes'}">
        <c:remove var="loginStatus" scope="request"></c:remove>
        showAlert('Login successful!', 'Welcome back, ${user.getUsername()}!', 'success');
    </c:if>
    <c:if test="${role eq 'seller' && not empty deleteStatus && deleteStatus eq 'success'}">
        <c:remove var="deleteStatus" scope="request"></c:remove>
        showAlert('Item deleted!', 'Correspondent orders are also deleted', 'success');
    </c:if>
    <c:if test="${role eq 'seller' && not empty deleteStatus && deleteStatus eq 'fail'}">
        <c:remove var="deleteStatus" scope="request"></c:remove>
        showAlert('Item is not deleted!', 'Something went wrong!', 'error');
    </c:if>
    <c:if test="${role eq 'seller' && not empty deleteStatus && deleteStatus eq 'haveYetToShip'}">
        <c:remove var="deleteStatus" scope="request"></c:remove>
        showAlert('Item is not deleted!', 'This item still has orders that are yet to ship!', 'error');
    </c:if>
    <c:if test="${role eq 'seller' && not empty deleteStatus && deleteStatus eq 'haveYetToReceive'}">
        <c:remove var="deleteStatus" scope="request"></c:remove>
        showAlert('Item is not deleted!', 'This item still has orders that are yet be received by users!', 'error');
    </c:if>
</script>
</html>