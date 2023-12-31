<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 20/4/2023
  Time: 9:12 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>  
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet">
    <script type="text/javascript" src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
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
    </style>
</head>
<body>
    <div class="container mt-5 p-3 rounded cart">
        <div class="row no-gutters">
            <div class="col-md-8">
                <div class="product-details mr-2">
                    <div class="d-flex flex-row align-items-center"><a href="index.jsp"><i class="fa fa-long-arrow-left"></i><span class="ml-2">Back</span></a></div>
                    <hr>
                    <h6 class="mb-0">Shopping cart</h6>
                    <div class="d-flex justify-content-between"><span>You have ${fn:length(cartList)} item(s) in your cart</span></div>
                    <c:if test="${not empty cartList and fn:length(cartList) gt 0}">
                        <c:set var="subtotal" value="${0}"></c:set>
                        <c:forEach items="${cartList}" var="cart">
                            <c:forEach items="${itemList}" var="item">
                                <c:if test="${item.getId() eq cart.getItem_id()}">
                                    <c:set var="itemDetail" value="${item}"></c:set>
                                </c:if>
                            </c:forEach>
                            <div class="d-flex justify-content-between align-items-center mt-3 p-2 items rounded">
                                <c:if test="${not empty itemDetail.getItem_img()}">
                                    <div class="d-flex flex-row"><img class="rounded" src="${itemDetail.getItem_img()}" width="40">
                                        <div class="ml-2"><a href="item.jsp?itemid=${itemDetail.getId()}"><span class="font-weight-bold d-block">${itemDetail.getItem_name()}</span></a></div>
                                    </div>
                                </c:if>
                                <c:if test="${empty itemDetail.getItem_img()}">
                                    <div class="d-flex flex-row"><img class="rounded" src="https://cdn5.vectorstock.com/i/1000x1000/80/64/mystery-box-icon-random-loot-box-flat-icon-vector-35858064.jpg" width="40">
                                        <div class="ml-2"><span class="font-weight-bold d-block">${itemDetail.getItem_name()}</span></div>
                                    </div>
                                </c:if>
                                <c:set var="cartFinalPrice" value="${cart.getQuantity() * cart.getPrice_per_item()}"></c:set>
                                <c:set var="subtotal" value="${subtotal + cartFinalPrice}"></c:set>
                                <div class="d-flex flex-row align-items-center">
                                    <span class="d-block">x${cart.getQuantity()} (RM${cart.getPrice_per_item()} per item)</span>
                                    <span class="d-block ml-5 font-weight-bold">RM${cartFinalPrice}</span>
                                    <form action="${pageContext.request.contextPath}/CartServlet" method="post">
                                        <input type="hidden" name="action" value="delete" />
                                        <input type="hidden" name="cartId" value="${cart.getId()}" />
                                        <button type="submit" class="fa fa-trash-o ml-3 text-black-50" onclick="deleteCart(${cart.getId()})"></button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </c:if>
                </div>
            </div>
            <c:if test="${not empty cartList and fn:length(cartList) gt 0}">
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
                        <input type="hidden" name="action" value="checkoutCarts" />
                        <button class="btn btn-primary btn-block d-flex justify-content-between mt-3" type="submit"><span>RM ${subtotal}</span><span>Checkout<i class="fa fa-long-arrow-right ml-1"></i></span></button>
                    </form>
                </div>
            </div>
            </c:if>
        </div>
    </div>
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
    
    <c:if test="${not empty addCart && addCart eq 'fail'}">
            <c:remove var="addCart" scope="request"></c:remove>
            showAlert('Cart not added!', '', 'error');
        </c:if>
            
        <c:if test="${not empty addCart && addCart eq 'success'}">
            <c:remove var="addCart" scope="request"></c:remove>
            showAlert('Cart added!', '', 'success');
        </c:if>
            
        <c:if test="${not empty addCart && addCart eq 'appended'}">
            <c:remove var="addCart" scope="request"></c:remove>
            showAlert('Cart updated!', 'You have existing card on this item, thus updated!', 'success');
        </c:if>
    
    <c:if test="${not empty deleteCart && deleteCart eq 'fail'}">
            <c:remove var="deleteCart" scope="request"></c:remove>
            showAlert('Cart deletion error!', 'Cart failed to delete!', 'error');
        </c:if>
        <c:if test="${not empty deleteCart && deleteCart eq 'success'}">
            <c:remove var="deleteCart" scope="request"></c:remove>
            showAlert('Cart deleted!', '', 'success');
        </c:if>
        
</script>
</html>
