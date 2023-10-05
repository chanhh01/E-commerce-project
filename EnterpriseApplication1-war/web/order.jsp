<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 26/4/2023
  Time: 9:29 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>  
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            margin: 0;
            font-family: Roboto,-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol","Noto Color Emoji";
            font-size: .8125rem;
            font-weight: 400;
            line-height: 1.5385;
            color: #333;
            text-align: left;
            background-color: #f5f5f5;
        }

        .mt-50{
            margin-top: 50px;
        }
        .mb-50{
            margin-bottom: 50px;
        }


        .bg-teal-400 { 
            background-color: #26a69a;
        }

        a{
            text-decoration: none !important;
        }


        .fa {
                color: red;
        }
    </style>
</head>
<body>
    <div class="container justify-content-center mt-50 mb-50">
        <div class="d-flex flex-row align-items-center"><a href="index.jsp"><i class="fa fa-long-arrow-left"></i><span class="ml-2">Back</span></a></div>
        <hr>
        <div class="row">
           <div class="col-md-10">
               <div><h4>Order Lists</h4></div>
               <hr>
               <c:if test="${not empty orderList and fn:length(orderList) gt 0}">
                   <c:forEach items="${orderList}" var="order">
                       <c:forEach items="${itemList}" var="item">
                           <c:if test="${item.getId() eq order.getItem_id()}">
                               <c:set var="itemDetail" value="${item}"></c:set>
                           </c:if>
                       </c:forEach>
                       <c:if test="${role eq 'customer'}">
                           <div class="card card-body mt-3">
                            <div class="media align-items-center align-items-lg-start text-center text-lg-left flex-column flex-lg-row">
                                <div class="mr-2 mb-3 mb-lg-0">
                                <c:if test="${not empty itemDetail.getItem_img()}">
                                    <img src="${itemDetail.getItem_img()}" width="150" height="150" alt="">
                                </c:if>
                                <c:if test="${empty itemDetail.getItem_img()}">
                                    <img src="https://cdn5.vectorstock.com/i/1000x1000/80/64/mystery-box-icon-random-loot-box-flat-icon-vector-35858064.jpg" width="150" height="150" alt="">
                                </c:if>
                                </div>

                                <div class="media-body">
                                    <h6 class="media-title font-weight-semibold">
                                        <a href="item.jsp?itemid=${itemDetail.getId()}" data-abc="true">${itemDetail.getItem_name()}</a>
                                    </h6>
                                    <ul class="list-inline list-inline-dotted mb-3 mb-lg-2">
                                        <li class="list-inline-item"><a href="searchItemList.jsp?categoryId=${itemDetail.getCategory()}" class="text-muted" data-abc="true">
                                            <c:forEach items="${categoryList}" var="category">
                                                <c:set var="categoryId" value="${category.getId()}"></c:set>
                                                <c:if test="${itemDetail.getCategory() eq categoryId}">
                                                    ${category.getName()}
                                                </c:if>
                                            </c:forEach>
                                            </a></li>
                                    </ul>
                                    <c:if test="${order.getStatus() eq 'to ship'}">
                                        <p class="mb-3">Status: Waiting for order item to be shipped by seller...</p>
                                    </c:if>
                                    <c:if test="${order.getStatus() eq 'to receive'}">
                                        <p class="mb-3">Status: Order item is shipped, waiting for customer to receive the shipment</p>
                                    </c:if>
                                    <c:if test="${order.getStatus() eq 'to rate'}">
                                        <p class="mb-3">Status: Order is received, yet to be rated</p>
                                    </c:if>
                                    <c:if test="${order.getStatus() eq 'completed'}">
                                        <p class="mb-3">Status: Order is completed and rated</p>
                                    </c:if>
                                    <c:if test="${order.getStatus() eq 'cancelled'}">
                                        <p class="mb-3">Status: Order is canceled by customer</p>
                                    </c:if>

                                    <ul class="list-inline list-inline-dotted mb-0">
                                    <c:forEach items="${sellerList}" var="seller">
                                        <c:if test="${seller.getId() eq itemDetail.getSeller_id()}">
                                            <c:forEach items="${userList}" var="userInfo">
                                                <c:if test="${userInfo.getId() eq seller.getUser_id()}">
                                                    <c:set var="sellerName" value="${userInfo.getUsername()}"></c:set>
                                                </c:if>
                                            </c:forEach>
                                            <li class="list-inline-item">Item from <a href="seller_dashboard.jsp?sellerId=${itemDetail.getSeller_id()}" data-abc="true">${sellerName}</a></li>
                                        </c:if>
                                    </c:forEach> 
                                    </ul>
                                </div>

                                <div class="mt-3 mt-lg-0 ml-lg-3 text-center">
                                    <h3 class="mb-0 font-weight-semibold">RM ${order.getTotal_price()}</h3>
                                    <div class="text-muted">(RM ${order.getItem_price()}) x ${order.getQuantity()}</div>
                                    <c:if test="${order.getStatus() eq 'to ship'}">
                                        <form action="${pageContext.request.contextPath}/OrderServlet" method="post">
                                            <input type="hidden" name="action" value="cancelOrder" />
                                            <input type="hidden" name="orderId" value="${order.getId()}" />
                                            <button type="submit" class="btn btn-warning mt-4 text-white"><i class="icon-cart-add mr-2"></i>Cancel order</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${order.getStatus() eq 'to receive'}">
                                        <form action="${pageContext.request.contextPath}/OrderServlet" method="post">
                                            <input type="hidden" name="action" value="receiveOrder" />
                                            <input type="hidden" name="orderId" value="${order.getId()}" />
                                            <button type="submit" class="btn btn-warning mt-4 text-white"><i class="icon-cart-add mr-2"></i>Receive shipment</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${order.getStatus() eq 'to rate'}">
                                        <button type="button" class="btn btn-warning mt-4 text-white" onclick="window.location.href='cust_review.jsp?orderId=${order.getId()}&itemId=${order.getItem_id()}'"><i class="icon-cart-add mr-2"></i>Rate purchase</button>
                                    </c:if>
                                    <c:if test="${order.getStatus() eq 'completed'}">
                                        <button type="button" class="btn btn-warning mt-4 text-white" onclick="window.location.href='payment.jsp?itemId=${order.getItem_id()}&qty=${order.getQuantity()}'"><i class="icon-cart-add mr-2"></i>Buy again</button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                       </c:if>
                       <c:if test="${role eq 'seller'}">
                           <div class="card card-body mt-3">
                            <div class="media align-items-center align-items-lg-start text-center text-lg-left flex-column flex-lg-row">
                                <div class="mr-2 mb-3 mb-lg-0">
                                <c:if test="${not empty itemDetail.getItem_img()}">
                                    <img src="${itemDetail.getItem_img()}" width="150" height="150" alt="">
                                </c:if>
                                <c:if test="${empty itemDetail.getItem_img()}">
                                    <img src="https://cdn5.vectorstock.com/i/1000x1000/80/64/mystery-box-icon-random-loot-box-flat-icon-vector-35858064.jpg" width="150" height="150" alt="">
                                </c:if>
                                </div>

                                <div class="media-body">
                                    <h6 class="media-title font-weight-semibold">
                                        <a href="item.jsp?itemid=${itemDetail.getId()}" data-abc="true">${itemDetail.getItem_name()}</a>
                                    </h6>
                                    <div class="list-inline list-inline-dotted mb-3 mb-lg-2">
                                        <div class="list-inline-item"><a href="searchItemList.jsp?categoryId=${itemDetail.getCategory()}" class="text-muted" data-abc="true">
                                            <c:forEach items="${categoryList}" var="category">
                                                <c:set var="categoryId" value="${category.getId()}"></c:set>
                                                <c:if test="${itemDetail.getCategory() eq categoryId}">
                                                    ${category.getName()}
                                                </c:if>
                                            </c:forEach>
                                            </a></div>
                                    </div>
                                    <c:if test="${order.getStatus() eq 'to ship'}">
                                        <p class="mb-3">Status: Waiting for order item to be shipped by seller...</p>
                                    </c:if>
                                    <c:if test="${order.getStatus() eq 'to receive'}">
                                        <p class="mb-3">Status: Order item is shipped, waiting for customer to receive the shipment</p>
                                    </c:if>
                                    <c:if test="${order.getStatus() eq 'to rate'}">
                                        <p class="mb-3">Status: Order is received, yet to be rated</p>
                                    </c:if>
                                    <c:if test="${order.getStatus() eq 'completed'}">
                                        <p class="mb-3">Status: Order is completed and rated</p>
                                    </c:if>
                                    
                                    <hr>
                                    <c:forEach items="${custList}" var="customer">
                                        <c:if test="${order.getCustomer_id() eq customer.getId()}">
                                            <c:forEach items="${userList}" var="userInfo">
                                                <c:if test="${userInfo.getId() eq customer.getUser_id()}">
                                                    <c:set var="customerName" value="${userInfo.getUsername()}"></c:set>
                                                </c:if>
                                            </c:forEach>
                                        </c:if>
                                    </c:forEach> 
                                    <p class="mb-3">Ordered by: ${customerName}</p>
                                </div>

                                <div class="mt-3 mt-lg-0 ml-lg-3 text-center">
                                    <h3 class="mb-0 font-weight-semibold">RM ${order.getTotal_price()}</h3>
                                    <div class="text-muted">(RM ${order.getItem_price()}) x ${order.getQuantity()}</div>
                                    <c:if test="${order.getStatus() eq 'to ship'}">
                                        <form action="${pageContext.request.contextPath}/OrderServlet" method="post">
                                            <input type="hidden" name="action" value="shipOrder" />
                                            <input type="hidden" name="orderId" value="${order.getId()}" />
                                            <input type="hidden" name="from" value="orderJsp" />
                                            <button type="submit" class="btn btn-warning mt-4 text-white"><i class="icon-cart-add mr-2"></i>Ship order</button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                       </c:if>
                   </c:forEach>
               </c:if>
               <c:if test="${empty orderList or fn:length(orderList) eq 0}">
                   <div class="card card-body mt-3">
                       <div><h3> The list is empty! </h3></div>
                    </div>
               </c:if>
        </div>                     
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
            
    <c:if test="${not empty orderCreationStatus && orderCreationStatus eq 'fail'}">
        <c:remove var="orderCreationStatus" scope="request"></c:remove>
        showAlert('Error!', 'Order creation from cart went wrong!', 'error');
    </c:if>
    <c:if test="${not empty orderCreationStatus && orderCreationStatus eq 'success'}">
        <c:remove var="orderCreationStatus" scope="request"></c:remove>
        showAlert('Success!', 'All items in cart has been purchased!', 'success');
    </c:if>
    <c:if test="${not empty orderCreationStatus && orderCreationStatus eq 'successPayment'}">
        <c:remove var="orderCreationStatus" scope="request"></c:remove>
        showAlert('Success!', 'This item is successfully purchased!', 'success');
    </c:if>
    <c:if test="${not empty updateOrder && updateOrder eq 'fail'}">
        <c:remove var="updateOrder" scope="request"></c:remove>
        showAlert('Error!', 'Something went wrong!', 'error');
    </c:if>
    <c:if test="${not empty updateOrder && updateOrder eq 'received'}">
        <c:remove var="updateOrder" scope="request"></c:remove>
        showAlert('Success!', 'Order has been received!', 'success');
    </c:if>
    <c:if test="${not empty updateOrder && updateOrder eq 'shipped'}">
        <c:remove var="updateOrder" scope="request"></c:remove>
        showAlert('Order shipped to customer!', '', 'success');
    </c:if>
    <c:if test="${not empty updateOrder && updateOrder eq 'cancelled'}">
        <c:remove var="updateOrder" scope="request"></c:remove>
        showAlert('Order cancelled!', '', 'info');
    </c:if>
    <c:if test="${not empty reviewStat && reviewStat eq 'success'}">
        <c:remove var="reviewStat" scope="request"></c:remove>
        showAlert('Review feedback added!', '', 'success');
    </c:if>
    <c:if test="${not empty reviewStat && reviewStat eq 'fail'}">
        <c:remove var="reviewStat" scope="request"></c:remove>
        showAlert('Error!', 'Something went wrong and feedback is not added', 'error');
    </c:if>
</script>
</html>
