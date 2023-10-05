<%-- 
    Document   : user_list
    Created on : May 8, 2023, 9:04:31 PM
    Author     : Chan01
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>  
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap" rel="stylesheet">
        <style>
            ul > li{margin-right:25px;font-weight:bold;cursor:pointer}
            li.active{border-bottom:3px solid silver;}
            @media (max-width: 426px) {
            .container {margin-top:0px !important;}
            .container > .row{padding:0 !important;}
            .container > .row > .col-xs-12.col-sm-5{
                padding-right:0 ;    
            }
            .container > .row > .col-xs-12.col-sm-9 > div > p{
                padding-left:0 !important;
                padding-right:0 !important;
            }
            .container > .row > .col-xs-12.col-sm-9 > div > ul{
                padding-left:10px !important;

            }            
            .section{width:104%;}
            .menu-items{padding-left:0;}
        }
        
        .menu-items{list-style-type:none;font-size:11px;display:inline-flex;margin-bottom:0;margin-top:20px;justify-content:center;align-items:center;}
        
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
        <div class="main">
            <div class="d-flex flex-row align-items-center"><a href="index.jsp"><i class="fa fa-long-arrow-left"></i><span class="ml-2">Back</span></a></div>
            <hr>
            <div class="label-container">
                        <ul class="menu-items">
                            <li id="usersLi" class="active">All Users</li>
                            <li id="adminsLi">Admins</li>
                            <li id="sellersLi">Sellers</li>
                            <li id="custLi">Customers</li>
                            <li id="suspendLi">Suspended users</li>
                        </ul>
            </div> 
            <div id="usersDiv" class="userContainer" style="display:grid;">
                <c:forEach items="${userList}" var="targetUser">
                    <c:if test="${targetUser.getId() ne user.getId()}">
                        <c:if test="${targetUser.getRole() ne 'pending'}">
                            <div class="container">
                                <div class="row">
                                    <div class="col-md-4" style="width: 100%">
                                        <a href="profile.jsp?userid=${targetUser.getId()}&roleDetail=${targetUser.getRole()}">
                                            <div class="card product-card" id="user-id-${targetUser.getId()}">
                                            <c:if test="${not empty targetUser.getProfile_img()}">
                                                <div class="d-flex justify-content-center">
                                                <img src="${targetUser.getProfile_img()}" style="width:200px; height:200px; object-fit: contain;margin: 0 auto;" class="card-img-top" alt="Category Image">
                                                </div>
                                            </c:if>
                                            <c:if test="${empty targetUser.getProfile_img()}">
                                                <div class="d-flex justify-content-center">
                                                <img src="images/user.png" style="width:200px; height:200px; object-fit: contain;margin: 0 auto;" class="card-img-top" alt="Category Image">
                                                </div>
                                            </c:if>
                                                <div class="card-body">
                                                    <p> ${targetUser.getUsername()} </p>
                                                    <div class="d-flex align-items-center justify-content-start rating border-top border-bottom py-2">
                                                        <p>Email: ${targetUser.getEmail()}</p>
                                                    </div>
                                                    <div class="d-flex align-items-center justify-content-start rating border-top border-bottom py-2">
                                                        <p>Role: ${targetUser.getRole()}</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:if>
                </c:forEach>
            </div>
            <div class="userContainer" id="adminsDiv" style="display:none">
                <c:forEach items="${userList}" var="targetAdmin">
                    <c:if test="${targetAdmin.getId() ne user.getId()}">
                        <c:if test="${targetAdmin.getRole() eq 'admin'}">
                            <div class="container">
                                <div class="row">
                                    <div class="col-md-4" style="width: 100%">
                                        <a href="profile.jsp?userid=${targetAdmin.getId()}&roleDetail=${targetAdmin.getRole()}">
                                            <div class="card product-card" id="user-id-${targetAdmin.getId()}">
                                            <c:if test="${not empty targetAdmin.getProfile_img()}">
                                                <div class="d-flex justify-content-center">
                                                <img src="${targetAdmin.getProfile_img()}" style="width:200px; height:200px; object-fit: contain;margin: 0 auto;" class="card-img-top" alt="Category Image">
                                                </div>
                                            </c:if>
                                            <c:if test="${empty targetAdmin.getProfile_img()}">
                                                <div class="d-flex justify-content-center">
                                                <img src="images/user.png" style="width:200px; height:200px; object-fit: contain;margin: 0 auto;" class="card-img-top" alt="Category Image">
                                                </div>
                                            </c:if>
                                                <div class="card-body">
                                                    <p> ${targetAdmin.getUsername()} </p>
                                                    <div class="d-flex align-items-center justify-content-start rating border-top border-bottom py-2">
                                                        <p>Email: ${targetAdmin.getEmail()}</p>
                                                    </div>
                                                    <div class="d-flex align-items-center justify-content-start rating border-top border-bottom py-2">
                                                        <p>Role: ${targetAdmin.getRole()}</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:if>
                </c:forEach>
            </div>
            <div class="userContainer" id="sellersDiv" style="display:none">
                <c:forEach items="${userList}" var="targetSeller">
                    <c:if test="${targetSeller.getRole() eq 'seller'}">
                        <div class="container">
                            <div class="row">
                                <div class="col-md-4" style="width: 100%">
                                    <a href="seller_dashboard.jsp?userId=${targetSeller.getId()}">
                                        <div class="card product-card" id="user-id-${targetSeller.getId()}">
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
                    </c:if>
                </c:forEach>
            </div>
            <div class="userContainer" id="custsDiv" style="display:none">
                <c:forEach items="${userList}" var="targetCust">
                    <c:if test="${targetCust.getRole() eq 'customer'}">
                        <div class="container">
                            <div class="row">
                                <div class="col-md-4" style="width: 100%">
                                    <a href="profile.jsp?userid=${targetCust.getId()}&roleDetail=${targetCust.getRole()}">
                                        <div class="card product-card" id="user-id-${targetUser.getId()}">
                                        <c:if test="${not empty targetCust.getProfile_img()}">
                                            <div class="d-flex justify-content-center">
                                            <img src="${targetCust.getProfile_img()}" style="width:200px; height:200px; object-fit: contain;margin: 0 auto;" class="card-img-top" alt="Category Image">
                                            </div>
                                        </c:if>
                                        <c:if test="${empty targetCust.getProfile_img()}">
                                            <div class="d-flex justify-content-center">
                                            <img src="images/user.png" style="width:200px; height:200px; object-fit: contain;margin: 0 auto;" class="card-img-top" alt="Category Image">
                                            </div>
                                        </c:if>
                                            <div class="card-body">
                                                <p> ${targetCust.getUsername()} </p>
                                                <div class="d-flex align-items-center justify-content-start rating border-top border-bottom py-2">
                                                    <p>Email: ${targetCust.getEmail()}</p>
                                                </div>
                                                <div class="d-flex align-items-center justify-content-start rating border-top border-bottom py-2">
                                                    <p>Role: ${targetCust.getRole()}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
            <div class="userContainer" id="suspendDiv" style="display:none">
                <c:forEach items="${userList}" var="targetSus">
                    <c:if test="${targetSus.getRole() eq 'suspendedCust' or targetSus.getRole() eq 'suspendedSeller'}">
                        <div class="container">
                            <div class="row">
                                <div class="col-md-4" style="width: 100%">
                                    <a href="profile.jsp?userid=${targetSus.getId()}&roleDetail=${targetSus.getRole()}">
                                        <div class="card product-card" id="user-id-${targetSus.getId()}">
                                        <c:if test="${not empty targetSus.getProfile_img()}">
                                            <div class="d-flex justify-content-center">
                                            <img src="${targetSus.getProfile_img()}" style="width:200px; height:200px; object-fit: contain;margin: 0 auto;" class="card-img-top" alt="Category Image">
                                            </div>
                                        </c:if>
                                        <c:if test="${empty targetSus.getProfile_img()}">
                                            <div class="d-flex justify-content-center">
                                            <img src="images/user.png" style="width:200px; height:200px; object-fit: contain;margin: 0 auto;" class="card-img-top" alt="Category Image">
                                            </div>
                                        </c:if>
                                            <div class="card-body">
                                                <p> ${targetSus.getUsername()} </p>
                                                <div class="d-flex align-items-center justify-content-start rating border-top border-bottom py-2">
                                                    <p>Email: ${targetSus.getEmail()}</p>
                                                </div>
                                                <div class="d-flex align-items-center justify-content-start rating border-top border-bottom py-2">
                                                    <p>Role: ${targetSus.getRole()}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>
    </body>
    <script>
        document.getElementById("usersDiv").style.display = "grid";
        document.getElementById("adminsDiv").style.display = "none";
        document.getElementById("sellersDiv").style.display = "none";
        document.getElementById("custsDiv").style.display = "none";
        document.getElementById("suspendDiv").style.display = "none";
        
        $(document).ready(function(){
            //-- Click on detail
            $("ul.menu-items > li").on("click",function(){
                $("ul.menu-items > li").removeClass("active");
                $(this).addClass("active");
                
                var liId = $(this).attr("id");
                
                if (liId === "usersLi"){
                    document.getElementById("usersDiv").style.display = "grid";
                    document.getElementById("adminsDiv").style.display = "none";
                    document.getElementById("sellersDiv").style.display = "none";
                    document.getElementById("custsDiv").style.display = "none";
                    document.getElementById("suspendDiv").style.display = "none";
                } else if (liId === "adminsLi"){
                    document.getElementById("usersDiv").style.display = "none";
                    document.getElementById("adminsDiv").style.display = "grid";
                    document.getElementById("sellersDiv").style.display = "none";
                    document.getElementById("custsDiv").style.display = "none";
                    document.getElementById("suspendDiv").style.display = "none";
                } else if (liId === "sellersLi"){
                    document.getElementById("usersDiv").style.display = "none";
                    document.getElementById("adminsDiv").style.display = "none";
                    document.getElementById("sellersDiv").style.display = "grid";
                    document.getElementById("custsDiv").style.display = "none";
                    document.getElementById("suspendDiv").style.display = "none";
                } else if (liId === "custLi"){
                    document.getElementById("usersDiv").style.display = "none";
                    document.getElementById("adminsDiv").style.display = "none";
                    document.getElementById("sellersDiv").style.display = "none";
                    document.getElementById("custsDiv").style.display = "grid";
                    document.getElementById("suspendDiv").style.display = "none";
                } else if (liId === "suspendLi"){
                    document.getElementById("usersDiv").style.display = "none";
                    document.getElementById("adminsDiv").style.display = "none";
                    document.getElementById("sellersDiv").style.display = "none";
                    document.getElementById("custsDiv").style.display = "none";
                    document.getElementById("suspendDiv").style.display = "grid";
                }
            });                      
        });
        
        function showAlert(title, text, type) {
            Swal.fire({
                title: title,
                text: text,
                icon: type,
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            });
        }
        
        <c:if test="${not empty adminEdit && adminEdit eq 'suspendSuccess'}">
            <c:remove var="adminEdit" scope="request"></c:remove>
            showAlert('Success!', 'This user has been suspended!', 'success');
        </c:if>
        <c:if test="${not empty adminEdit && adminEdit eq 'unsuspendSuccess'}">
            <c:remove var="adminEdit" scope="request"></c:remove>
            showAlert('Success!', 'This user is now active again!', 'success');
        </c:if>
        <c:if test="${not empty adminEdit && adminEdit eq 'approveSuccess'}">
            <c:remove var="adminEdit" scope="request"></c:remove>
            showAlert('Success!', 'This seller has been approved', 'success');
        </c:if>
            <c:if test="${not empty adminEdit && adminEdit eq 'rejectSuccess'}">
            <c:remove var="adminEdit" scope="request"></c:remove>
            showAlert('Success!', 'This pending seller has been rejected.', 'success');
        </c:if>
        <c:if test="${not empty adminEdit && adminEdit eq 'fail'}">
            <c:remove var="adminEdit" scope="request"></c:remove>
            showAlert('Error!', 'Something went wrong!', 'error');
        </c:if>
    </script>
</html>
