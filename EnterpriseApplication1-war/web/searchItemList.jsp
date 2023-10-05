<%-- 
    Document   : searchItemList
    Created on : May 7, 2023, 5:11:13 PM
    Author     : Chan01
--%>

<%@page import="java.util.stream.Collectors"%>
<%@page import="Model.Items"%>
<%@page import="java.util.List"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/includes/header.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
    </head>
    <body>
        <jsp:include page="/includes/navbar.jsp" />
        <div class="d-flex flex-row align-items-center"><a href="index.jsp"><i class="fa fa-long-arrow-left"></i><span class="ml-2">Back</span></a></div>
        <br>
        <div>
            <c:if test="${not empty resItemList}">
                <jsp:include page="item_list.jsp">
                    <jsp:param name="resItemList" value="${resItemList}" />
                    <jsp:param name="categoryId" value="${not empty param.categoryId ? param.categoryId : 0}" />
                </jsp:include>
            </c:if>
            <c:if test="${empty resItemList}">
                <jsp:include page="item_list.jsp">
                    <jsp:param name="categoryId" value="${not empty param.categoryId ? param.categoryId : 0}" />
                </jsp:include>
            </c:if>
        </div>
    </body>
</html>
