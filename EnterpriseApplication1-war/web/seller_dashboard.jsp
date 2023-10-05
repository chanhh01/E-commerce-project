<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 20/4/2023
  Time: 7:37 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>  
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
    <style>
        .backButton{
            position: absolute;
            top: -66px;
            left: 23px;
            width: 30px;
            height: 30px;
        }
        
        .text-decoration-line-through {
            text-decoration: line-through;
          }
          
         ul > li{margin-right:25px;font-weight:lighter;cursor:pointer}
        li.active{border-bottom:3px solid silver;}

        .item-photo{display:flex;justify-content:center;align-items:center;border-right:1px solid #f6f6f6;}
        .menu-items{list-style-type:none;font-size:11px;display:inline-flex;margin-bottom:0;margin-top:20px}
        .btn-success{width:100%;border-radius:0;}
        .btn-danger{width:100%;border-radius:0;}
        .section{width:100%;margin-left:-15px;padding:2px;padding-left:15px;padding-right:15px;background:#f8f9f9}
        .title-price{margin-top:30px;margin-bottom:0;color:black}
        .title-attr{margin-top:0;margin-bottom:0;color:black;}
        .btn-minus{cursor:pointer;font-size:7px;display:flex;align-items:center;padding:5px;padding-left:10px;padding-right:10px;border:1px solid gray;border-radius:2px;border-right:0;}
        .btn-plus{cursor:pointer;font-size:7px;display:flex;align-items:center;padding:5px;padding-left:10px;padding-right:10px;border:1px solid gray;border-radius:2px;border-left:0;}
        div.section > div {width:100%;display:inline-flex;}
        div.section > div > input {margin:0;padding-left:5px;font-size:10px;padding-right:5px;max-width:18%;text-align:center;}
        .attr,.attr2{cursor:pointer;margin-right:5px;height:20px;font-size:10px;padding:2px;border:1px solid gray;border-radius:2px;}
        .attr.active,.attr2.active{ border:1px solid orange;}
        .h3{margin-top: 5px;}
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
    </style>
</head>
<body>
    <c:if test="${not empty param.sellerId}">
        <c:set var="sellerDetail" value="${detail}"></c:set>
        <c:set var="sellerUserDetail" value="${userdetail}"></c:set>
        <c:set var="totalSales" value="${totalItemSales}"></c:set>
        <c:set var="totalEarned" value="${totalOrderEarnings}"></c:set>
    <c:if test="${empty detail && not empty param.sellerId}">
        <jsp:include page="/getDetails?sellerIdForSellerDetail=${param.sellerId}"></jsp:include>
    </c:if>
    </c:if>
    <c:if test="${not empty param.userId}">
        <c:set var="sellerDetail" value="${detail}"></c:set>
        <c:set var="sellerUserDetail" value="${userdetail}"></c:set>
        <c:set var="totalSales" value="${totalItemSales}"></c:set>
        <c:set var="totalEarned" value="${totalOrderEarnings}"></c:set>
    <c:if test="${empty detail && not empty param.userId}">
        <jsp:include page="/getDetails?userIdForSellerDetail=${param.userId}"></jsp:include>
    </c:if>
    </c:if>
    <div class="container">
        <div class="d-flex flex-row align-items-center"><a href="index.jsp"><i class="fa fa-long-arrow-left"></i><span class="ml-2">Back</span></a></div>
        <hr>
            <c:if test="${not empty sellerDetail}">
                <div class="row">
               <div class="col-xs-4 item-photo">
                   <c:if test="${not empty sellerUserDetail.getProfile_img()}">
                       <img style="max-width:100%;" name="productImg" src="${sellerUserDetail.getProfile_img()}" width="250" height="350">
                   </c:if>
                   <c:if test="${empty sellerUserDetail.getProfile_img()}">
                       <img style="max-width:100%;" name="productImg" src="images/user.png" width="250" height="350">
                   </c:if>
                </div>
                <div class="col-xs-5" style="border:0px solid gray">
                    <h3>${sellerUserDetail.getUsername()} · <small style="color:#337ab7">(${sellerDetail.getFollowers()} customers following)</small></h3>
                    
                    <h5 style="color:#5A5A5A">Credit points: ${sellerDetail.getCredit_points()}</h5>
                    <h5 style="color:#5A5A5A">Contact number: <p style="color:#337ab7">${sellerDetail.getContact_no()}</p></h5>
                    <h5 style="color:#5A5A5A">Address: <p id="stockQty" style="color:#337ab7">${sellerDetail.getAddress()}</p></h5>            
        
                    <div class="section" style="padding-bottom:20px;">
                        <c:if test="${role eq 'customer'}">
                            <c:if test="${not empty isFavo}">
                                <form action="${pageContext.request.contextPath}/follow" method="post">
                                    <input type="hidden" name="sellerId" value="${sellerDetail.getId()}" />
                                    <input type="hidden" name="action" value="unfollow" />
                                    <button class="btn btn-danger" type="submit"><span style="margin-right:20px" class="glyphicon glyphicon-thumbs-down" aria-hidden="true"></span>Unfollow seller</button>    
                                </form>
                            </c:if>
                            <c:if test="${empty isFavo}">
                                <form action="${pageContext.request.contextPath}/follow" method="post">
                                    <input type="hidden" name="sellerId" value="${sellerDetail.getId()}" />
                                    <input type="hidden" name="action" value="follow" />
                                    <button class="btn btn-success" type="submit"><span style="margin-right:20px" class="glyphicon glyphicon-thumbs-up" aria-hidden="true"></span>Follow seller</button>
                                </form> 
                            </c:if>
                        </c:if>
                        <c:if test="${role eq 'admin'}">
                            <div>
                                <h3>Total Items Sold: ${totalSales}</h3>
                            </div>
                            <div>
                                <h3>Total Earned: RM${totalEarned}</h3>
                            </div>
                            <button class="btn btn-success" onclick="window.location.href='profile.jsp?userid=${sellerUserDetail.getId()}&roleDetail=${sellerUserDetail.getRole()}';"><span style="margin-right:20px" class="glyphicon glyphicon-user" aria-hidden="true"></span>Go to seller user profile</button>
                        </c:if>
                        <c:if test="${role eq 'seller'}">
                            <div>
                                <h3>Total Items Sold: ${totalSales}</h3>
                            </div>
                            <div>
                                <h3>Total Earned: RM${totalEarned}</h3>
                            </div>
                        </c:if>
                    </div>                                    
                </div>                              
        
                    <div class="col-xs-9">
                        <ul class="menu-items">
                            <li id="descriptionLi" class="active">Seller Description</li>
                            <li id="itemLi">Seller Items</li>
                        </ul>
                        <div style="width:100%;border-top:1px solid silver" id="descriptionDiv">
                            <p style="padding:15px;">
                                <small>
                                ${sellerDetail.getDescription()}
                                </small>
                            </p>
                        </div>
                        <div style="width:100%;border-top:1px solid silver" id="itemDiv">
                            <div>
                                <jsp:include page="item_list.jsp?showSellerItems=${sellerItems}" />
                            </div>
                        </div>
                    </div>		
                </div>
            </c:if>
            <c:if test="${empty sellerDetail}">
                <div class="row">
                    <h3>Seller not found!</h3>
                </div>
            </c:if>  
        </div>
    </body>
    <script>
        document.getElementById("descriptionDiv").style.display = "block";
        document.getElementById("itemDiv").style.display = "none";

        function showAlert(title, text, type) {
                Swal.fire({
                    title: title,
                    text: text,
                    icon: type,
                    confirmButtonColor: '#3085d6',
                    confirmButtonText: 'OK'
                });
            }
        
           $(document).ready(function(){
            //-- Click on detail
            $("ul.menu-items > li").on("click",function(){
                $("ul.menu-items > li").removeClass("active");
                $(this).addClass("active");
                
                var liId = $(this).attr("id");
                
                if (liId === "descriptionLi"){
                    document.getElementById("descriptionDiv").style.display = "block";
                    document.getElementById("itemDiv").style.display = "none";
                } else if (liId === "itemLi"){
                    document.getElementById("itemDiv").style.display = "block";
                    document.getElementById("descriptionDiv").style.display = "none";
                }
            });

            $(".attr,.attr2").on("click",function(){
                var clase = $(this).attr("class");

                $("." + clase).removeClass("active");
                $(this).addClass("active");
            });

            //-- Click on QUANTITY
            $(".btn-minus").on("click",function(){
                var now = $(".section > div > input").val();
                if ($.isNumeric(now)){
                    if (parseInt(now) -1 > 0){ now--;}
                    $(".section > div > input").val(now);
                }else{
                    $(".section > div > input").val("1");
                }
            });            
            $(".btn-plus").on("click",function(){
                var now = $(".section > div > input").val();
                if ($.isNumeric(now)){
                    $(".section > div > input").val(parseInt(now)+1);
                }else{
                    $(".section > div > input").val("1");
                }
            });                        
        });
        
        <c:if test="${not empty followStat}">
                <c:if test="${not empty followStat && followStat eq 'fail'}">
                    <c:remove var="followStat" scope="request"></c:remove>
                    showAlert('Error!', 'Operation cancelled due to error', 'error');
                </c:if>
                <c:if test="${not empty followStat && followStat eq 'success'}">
                    <c:remove var="followStat" scope="request"></c:remove>
                    showAlert('Success!', 'You are now following this seller', 'success');
                </c:if>
                <c:if test="${not empty followStat && followStat eq 'unfollowSuccess'}">
                    <c:remove var="followStat" scope="request"></c:remove>
                    showAlert('Success!', 'You unfollowed this seller', 'success');
                </c:if>
        </c:if>  
    </script>
</html>
