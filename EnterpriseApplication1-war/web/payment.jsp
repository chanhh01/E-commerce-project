<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 20/4/2023
  Time: 9:13 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet">
    <script type="text/javascript" src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <style>
        .payment-info {
            background: blue;
            padding: 10px;
            border-radius: 6px;
            color: #fff;
            font-weight: bold;
          }

          .product-details {
            padding: 10px;
          }

          body {
            background: #eee;
          }

          .cart {
            background: #fff;
          }

          .p-about {
            font-size: 12px;
          }

          .table-shadow {
            -webkit-box-shadow: 5px 5px 15px -2px rgba(0,0,0,0.42);
            box-shadow: 5px 5px 15px -2px rgba(0,0,0,0.42);
          }

          .type {
            font-weight: 400;
            font-size: 10px;
          }

          label.radio {
            cursor: pointer;
          }

          label.radio input {
            position: absolute;
            top: 0;
            left: 0;
            visibility: hidden;
            pointer-events: none;
          }

          label.radio span {
            padding: 1px 12px;
            border: 2px solid #ada9a9;
            display: inline-block;
            color: #8f37aa;
            border-radius: 3px;
            text-transform: uppercase;
            font-size: 11px;
            font-weight: 300;
          }

          label.radio input:checked + span {
            border-color: #fff;
            background-color: blue;
            color: #fff;
          }

          .credit-inputs {
            background: rgb(102,102,221);
            color: #fff !important;
            border-color: rgb(102,102,221);
          }

          .credit-inputs::placeholder {
            color: #fff;
            font-size: 13px;
          }

          .credit-card-label {
            font-size: 9px;
            font-weight: 300;
          }

          .form-control.credit-inputs:focus {
            background: rgb(102,102,221);
            border: rgb(102,102,221);
          }

          .line {
            border-bottom: 1px solid rgb(102,102,221);
          }

          .information span {
            font-size: 12px;
            font-weight: 500;
          }

          .information {
            margin-bottom: 5px;
          }

          .items {
            -webkit-box-shadow: 5px 5px 4px -1px rgba(0,0,0,0.25);
            box-shadow: 5px 5px 4px -1px rgba(0, 0, 0, 0.08);
          }

          .spec {
            font-size: 11px;
          }
          
          .text-decoration-line-through {
            text-decoration: line-through;
          }
          
         ul > li{margin-right:25px;font-weight:lighter;cursor:pointer}
        li.active{border-bottom:3px solid silver;}

        .item-photo{display:flex;justify-content:center;align-items:center;border-right:1px solid #f6f6f6;}
        .menu-items{list-style-type:none;font-size:11px;display:inline-flex;margin-bottom:0;margin-top:20px}
        .btn-success{width:100%;border-radius:0;}
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
    <c:if test="${not empty param.itemId and param.itemId gt 0}">
        <c:set var="item" value="${product}"></c:set>
        <c:set var="seller" value="${sellerName}"></c:set>
        <c:set var="category" value="${productCategory}"></c:set>
        <c:if test="${empty product}">
            <jsp:include page="/getDetails?itemIdForItemDetail=${param.itemId}&toPayment=true&qty=${param.qty}"></jsp:include>
        </c:if>
    </c:if>
    <div class="container mt-5 p-3 rounded cart">
        <div class="row no-gutters">
            <div class="col-md-8">
                <div class="product-details mr-2">
                    <div class="d-flex flex-row align-items-center"><a href="item.jsp?itemid=${item.getId()}"><i class="fa fa-long-arrow-left"></i><span class="ml-2">Back</span></a></div>
                    <hr>
                    <h6 class="mb-0">Payment page</h6>
                    <hr>
                    <c:if test="${not empty param.itemId and param.itemId gt 0}">
                        <div class="container">
                            <div class="row">
                                <div class="col-xs-4 item-photo">
                                    <c:if test="${not empty item.getItem_img()}">
                                        <img style="max-width:100%;" name="productImg" src="${item.getItem_img()}" width="400" height="400"/>
                                    </c:if>
                                    <c:if test="${empty item.getItem_img()}">
                                        <img style="max-width:100%;" name="productImg" src="https://cdn5.vectorstock.com/i/1000x1000/80/64/mystery-box-icon-random-loot-box-flat-icon-vector-35858064.jpg" width="400" height="400"/>
                                    </c:if>
                                 </div>
                                 <div style="margin-left:20px;"></div>
                                 <div class="col-xs-5" style="border:0px solid gray">
                                     <h3>${item.getItem_name()}</h3>
                                     <h5 style="color:#5A5A5A">Seller: <a href="seller_dashboard.jsp?sellerId=${item.getSeller_id()}">${seller}</a></h5>
                                     <h5 style="color:#5A5A5A">Category: <small style="color:#337ab7">${category}</small></h5>
                                     <h5 style="color:#5A5A5A">Purchase amount: <p id="stockQty" style="color:#337ab7">${param.qty}</p></h5>
                                     <h6 class="title-price"><small>PRICE PER ITEM:</small></h6>
                                     <c:if test="${item.getDiscount_percentage() gt 0}">
                                         <h3 style="margin-top:0px; font-weight:bold;">RM ${item.getDiscountedPrice(item)}</h3>
                                         <p class="text-muted text-decoration-line-through">RM ${item.getPrice()}</p>
                                     </c:if>
                                     <c:if test="${item.getDiscount_percentage() eq 0}">
                                         <h3 style="margin-top:0px;">RM ${item.getPrice()}</h3>
                                     </c:if> 
                                 </div>                              
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${empty param.itemId or param.itemId eq 0}">
                        <div class="row">
                            <h3>Item not found!</h3>
                        </div>
                    </c:if>
                </div>
            </div>
            <c:if test="${not empty param.itemId and param.itemId gt 0}">
                <div class="col-md-4">
                <div class="payment-info">
                    <div class="d-flex justify-content-between align-items-center"><span>Card details</span><img class="rounded" src="${user.getProfile_img()}" width="30"></div><span class="type d-block mt-3 mb-1">Card type</span><label class="radio"> <input type="radio" name="card" value="payment" checked> <span><img width="30" src="https://img.icons8.com/color/48/000000/mastercard.png"/></span> </label>
                    <label class="radio"> <input type="radio" name="card" value="payment"> <span><img width="30" src="https://img.icons8.com/officel/48/000000/visa.png"/></span> </label>
                    <label class="radio"> <input type="radio" name="card" value="payment"> <span><img width="30" src="https://img.icons8.com/ultraviolet/48/000000/amex.png"/></span> </label>
                    <label class="radio"> <input type="radio" name="card" value="payment"> <span><img width="30" src="https://img.icons8.com/officel/48/000000/paypal.png"/></span> </label>
                    <div><label class="credit-card-label">Name on card</label><input type="text" class="form-control credit-inputs" placeholder="Name"></div>
                    <div><label class="credit-card-label">Card number</label><input type="text" class="form-control credit-inputs" placeholder="0000 0000 0000 0000"></div>
                    <div class="row">
                        <div class="col-md-6"><label class="credit-card-label">Date</label><input type="text" class="form-control credit-inputs" placeholder="12/24"></div>
                        <div class="col-md-6"><label class="credit-card-label">CVV</label><input type="text" class="form-control credit-inputs" placeholder="342"></div>
                    </div>
                    <hr class="line">
                    <form action="${pageContext.request.contextPath}/OrderServlet" method="post">
                        <input type="hidden" name="itemId" value="${param.itemId}" />
                        <input type="hidden" name="qty" value="${param.qty}" />
                        <input type="hidden" name="fromPayment" value="true" />
                        <button class="btn btn-primary btn-block d-flex justify-content-between mt-3" type="submit"><span>RM ${item.getDiscountedPrice(item) * param.qty}</span><span>Checkout<i class="fa fa-long-arrow-right ml-1"></i></span></button>
                    </form>
                </div>
            </div>
            </c:if>
        </div>
    </div>
</body>
<script>
    <c:if test="${not empty orderCreationStatus && orderCreationStatus eq 'fail'}">
        <c:remove var="orderCreationStatus" scope="request"></c:remove>
        showAlert('Error!', 'Order payment went wrong!', 'error');
    </c:if>
    
    function showAlert(title, text, type) {
                Swal.fire({
                    title: title,
                    text: text,
                    icon: type,
                    confirmButtonColor: '#3085d6',
                    confirmButtonText: 'OK'
                });
            }
            
</script>
</html>
