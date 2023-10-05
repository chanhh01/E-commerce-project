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
        <button class="backButton" onclick="window.location.href='index.jsp';"> < </button>
        <form action="${pageContext.request.contextPath}/ItemServlet" method="post" id="itemCreation">
            <label for="chk" aria-hidden="true">Add new item</label>
            <input type="hidden" name="sellerId" value="${userDetail.getId()}" />
            <input type="text" name="itemname" placeholder="Item name" required="">
            <label class="label-upload-input" for="uploadInput">Go to https://imgbb.com and upload the image then paste it here:</label>
            <input type="url" id="url" name="url" placeholder="Paste image link here" required="">
            <input type="number" min="0" name="qty" placeholder="Item quantity" required="">
            <input type="number" min="0" step="0.01" name="price" placeholder="Price (RM)" required="">
            <input type="number" min="0" step="0.01" name="discountPercentage" placeholder="Discount percentage (%)" required="">
            <input type="text" name="description" placeholder="Item description" required="">
            <select name="category" required="">
                <c:if test="${not empty categoryList and categoryList.size() > 0}">
                    <c:forEach items="${categoryList}" var="category">
                        <option value=${category.getId()}>${category.getName()}</option>
                    </c:forEach>
                </c:if>
                <c:if test="${empty categoryList or categoryList.size() eq 0}">
                    <option value=1>None</option>
                </c:if>
            </select>
            <button type="submit">Create Item</button>
        </form>
    </div>
</div>
</body>
<script>
    
            <c:if test="${not empty itemStatus}">
                <c:if test="${not empty itemStatus && itemStatus eq 'failed'}">
                    <c:remove var="itemStatus" scope="request"></c:remove>
                    showAlert('Failed!', 'Something went wrong and item cannot be created!', 'error');
                </c:if>
                <c:if test="${not empty itemStatus && itemStatus eq 'success'}">
                    <c:remove var="itemStatus" scope="request"></c:remove>
                    showAlert('Success!', 'Created new item!', 'success');
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
