<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 26/4/2023
  Time: 9:30 PM
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
               <div><h4>Pending sellers awaiting approval</h4></div>
               <hr>
               <c:if test="${not empty pendingSellers and fn:length(pendingSellers) gt 0}">
                   <c:forEach items="${pendingSellers}" var="pending">
                        <div class="card card-body mt-3">
                         <div class="media align-items-center align-items-lg-start text-center text-lg-left flex-column flex-lg-row">
                             <div class="mr-2 mb-3 mb-lg-0">
                             <c:if test="${not empty pending.getProfile_img()}">
                                 <img src="${pending.getProfile_img()}" width="150" height="150" alt="">
                             </c:if>
                             <c:if test="${empty pending.getProfile_img()}">
                                 <img src="https://cdn5.vectorstock.com/i/1000x1000/80/64/mystery-box-icon-random-loot-box-flat-icon-vector-35858064.jpg" width="150" height="150" alt="">
                             </c:if>
                             </div>

                             <div class="media-body">
                                 <h6 class="media-title font-weight-semibold">
                                     <a href="profile.jsp?userid=${pending.getId()}&roleDetail=pending" data-abc="true">${pending.getUsername()} (Click here to browse profile)</a>
                                 </h6>
                             </div>

                             <div class="mt-3 mt-lg-0 ml-lg-3 text-center">
                                 <form action="${pageContext.request.contextPath}/ProfileServlet" method="post">
                                    <input type="hidden" name="userId" value="${pending.getId()}" />
                                    <input type="hidden" name="action" value="approve" />
                                    <input type="hidden" name="fromPending" value="true" />
                                    <button type="submit" class="btn btn-warning mt-4 text-white" type="submit"><i class="icon-cart-add mr-2"></i>Approve Seller</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/ProfileServlet" method="post">
                                    <input type="hidden" name="userId" value="${pending.getId()}" />
                                    <input type="hidden" name="action" value="reject" />
                                    <input type="hidden" name="fromPending" value="true" />
                                    <button type="submit" class="btn btn-warning mt-4 text-white" type="submit"><i class="icon-cart-add mr-2"></i>Reject Seller</button>
                                </form>  
                             </div>
                         </div>
                     </div>
                   </c:forEach>
               </c:if>
               <c:if test="${empty pendingSellers or fn:length(pendingSellers) eq 0}">
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
