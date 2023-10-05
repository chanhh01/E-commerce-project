<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 30/4/2023
  Time: 5:45 PM
  To change this template use File | Settings | File Templates.
--%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>  
<html>
<head>
    <title>Login and Registration</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500&display=swap" rel="stylesheet">
    <style type="text/css">
        .backButton{
            position: absolute;
            top: -66px;
            left: 23px;
            width: 30px;
            height: 30px;
        }
        
        .subButton{
            position: absolute;
            top: -66px;
            left: 23px;
            width: 30px;
            height: 30px;
        }

        body{
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            font-family: 'Jost', sans-serif;
            background: linear-gradient(to bottom, #0f0c29, #302b63, #24243e);
        }
        .main{
            width: 350px;
            height: 700px;
            background: red;
            overflow: hidden;
            background: url("https://doc-08-2c-docs.googleusercontent.com/docs/securesc/68c90smiglihng9534mvqmq1946dmis5/fo0picsp1nhiucmc0l25s29respgpr4j/1631524275000/03522360960922298374/03522360960922298374/1Sx0jhdpEpnNIydS4rnN4kHSJtU1EyWka?e=view&authuser=0&nonce=gcrocepgbb17m&user=03522360960922298374&hash=tfhgbs86ka6divo3llbvp93mg4csvb38") no-repeat center/ cover;
            border-radius: 10px;
            box-shadow: 5px 20px 50px #000;
        }
        #chk{
            display: none;
        }
        .newItem{
            position: relative;
            width:100%;
            height: 100%;
        }
        .label-upload-input{
            font-size: 16px;
            margin: 12px auto;
        }
        label{
            color: #fff;
            font-size: 2.3em;
            justify-content: center;
            display: flex;
            margin: 60px;
            font-weight: bold;
            cursor: pointer;
            transition: .5s ease-in-out;
        }
        input:not([type="file"]){
            width: 60%;
            height: 30px;
            background: #e0dede;
            justify-content: center;
            display: flex;
            margin: 20px auto;
            padding: 10px;
            border: none;
            outline: none;
            border-radius: 5px;
        }
        select {
            display: block;
            margin: 0 auto;
        }
        select {
            font-size: 13px;
            background: #e0dede;
            justify-content: center;
            padding: 8px 12px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            -webkit-appearance: none;
        }
        select:focus {
            outline: none;
            box-shadow: 0 0 4px rgba(0, 0, 0, 0.2);
            border-color: #5e9dd5;
            background: #e0dede;
            justify-content: center;
        }

        select option {
            font-family: Arial, sans-serif;
            font-size: 16px;
            color: #333;
            background: #e0dede;
            justify-content: center;
        }
        button{
            width: 60%;
            height: 40px;
            margin: 10px auto;
            justify-content: center;
            display: block;
            color: #fff;
            background: #573b8a;
            font-size: 1em;
            font-weight: bold;
            margin-top: 20px;
            outline: none;
            border: none;
            border-radius: 5px;
            transition: .2s ease-in;
            cursor: pointer;
        }
        button:hover{
            background: #6d44b8;
        }

    </style>
</head>
<body>
<div class="main">
    <input type="checkbox" id="chk" aria-hidden="true">
    <div class="newItem">
        <c:if test="${not empty param.id}">
            <c:set var="item" value="${product}"></c:set>
            <c:if test="${empty product}">
                <jsp:include page="/getDetails?itemIdForItemDetail=${param.id}&toEditItem=true"></jsp:include>
            </c:if>
            <button class="backButton" onclick="window.location.href='item.jsp?itemid=${item.getId()}';"> < </button>
            <form action="${pageContext.request.contextPath}/ItemServlet" method="post" id="itemEdit">
                <label for="chk" aria-hidden="true">Edit item</label>
                <input type="hidden" name="itemId" value="${item.getId()}" />
                <input type="text" name="itemName" placeholder="Item name" value="${item.getItem_name()}" required="">
                <label class="label-upload-input" for="uploadInput">Go to https://imgbb.com and upload the image then paste it here:</label>
                <input type="url" id="url" name="url" placeholder="Paste image link here" value="${item.getItem_img()}" required="">
                <input type="number" min="0" name="qty" placeholder="Item quantity" value="${item.getQuantity()}" required="">
                <input type="number" min="0" step="0.01" name="price" placeholder="Price (RM)" value="${item.getPrice()}" required="">
                <input type="number" min="0" step="0.01" name="discountPercentage" placeholder="Discount percentage (%)" value="${item.getDiscount_percentage()}" required="">
                <input type="text" name="description" placeholder="Item description" value="${item.getDescription()}" required="">
                <select id="categorySelect" name="category" required="">
                    <c:if test="${not empty categoryList and fn:length(categoryList) gt 0}">
                        <c:forEach items="${categoryList}" var="category">
                            <option value=${category.getId()}>${category.getName()}</option>
                        </c:forEach>
                    </c:if>
                    <c:if test="${empty categoryList or fn:length(categoryList) eq 0}">
                        <option value=1>None</option>
                    </c:if>
                </select>
                <button type="submit">Edit Item</button>
            </form>
        </c:if>
        <c:if test="${empty param.id}">
            <button class="backButton" onclick="window.location.href='item.jsp?itemid=${param.id}';"> < </button>
        </c:if>
    </div>
</div>
</body>
<script>

    <c:if test="${not empty editStatus}">
        <c:if test="${not empty editStatus && editStatus eq 'failed'}">
            <c:remove var="editStatus" scope="request"></c:remove>
            showAlert('Failed!', 'Something went wrong and item cannot be edited!', 'error');
        </c:if>
        <c:if test="${not empty editStatus && editStatus eq 'success'}">
            <c:remove var="editStatus" scope="request"></c:remove>
            showAlert('Success!', 'Item successfully edited!', 'success');
        </c:if>
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
