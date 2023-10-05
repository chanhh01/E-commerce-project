<%-- 
    Document   : adminRegister
    Created on : May 6, 2023, 3:17:23 PM
    Author     : Chan01
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
    <title>Admin Registration</title>
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
            height: 600px;
            background: red;
            overflow: hidden;
            background: url("https://doc-08-2c-docs.googleusercontent.com/docs/securesc/68c90smiglihng9534mvqmq1946dmis5/fo0picsp1nhiucmc0l25s29respgpr4j/1631524275000/03522360960922298374/03522360960922298374/1Sx0jhdpEpnNIydS4rnN4kHSJtU1EyWka?e=view&authuser=0&nonce=gcrocepgbb17m&user=03522360960922298374&hash=tfhgbs86ka6divo3llbvp93mg4csvb38") no-repeat center/ cover;
            border-radius: 10px;
            box-shadow: 5px 20px 50px #000;
        }
        #chk{
            display: none;
        }
        .signup{
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

        .uploadInput{
            justify-content: center;
            margin: auto 57px;
            display: flex;
        }

        input[type="file"]::-webkit-file-upload-button {
            background-color: #0099FF;
            color: white;
            border-radius: 5px;
            padding: 10px;
            cursor: pointer;
            font-size: 16px;
        }

        input[type="file"]:hover::-webkit-file-upload-button {
            background-color: #0077CC;
        }

        input[type="file"]:focus::-webkit-file-upload-button {
            outline: none;
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

        #chk:checked ~ .signup label{
            transform: scale(.6);
        }

    </style>
    </head>
    <body>
        <div class="main">
    <input type="checkbox" id="chk" aria-hidden="true">
    <div class="signup">
        <button class="backButton" onclick="window.location.href='index.jsp';"> < </button>
        <form action="${pageContext.request.contextPath}/RegisterServlet" method="post" id="registrationForm" enctype="multipart/form-data">
            <label for="chk" aria-hidden="true">Register</label>
            <input type="text" name="username" placeholder="Admin name" required="">
            <label class="label-upload-input" for="uploadInput">Go to https://imgbb.com and upload the image then paste it here:</label>
            <input type="url" id="url" name="url" placeholder="Paste image link here (Optional)">
            <input type="email" name="email" placeholder="Admin Email" required="">
            <input type="password" name="pswd" placeholder="Admin Password" required="">
            <button type="submit" onclick="setRegistrationAttribute()">Register</button>
        </form>
        <script>
            function setRegistrationAttribute() {
                var form = document.getElementById("registrationForm");
                form.action += "?registerFrom=adminRegister";
            }
            
            <c:if test="${not empty registerStatus}">
                <c:if test="${not empty registerStatus && registerStatus eq 'duplicate-email'}">
                    <c:remove var="registerStatus" scope="request"></c:remove>
                    showAlert('Register Failed!', 'This email has been used by other user.', 'error');
                </c:if>
                <c:if test="${not empty registerStatus && registerStatus eq 'register-fail'}">
                    <c:remove var="registerStatus" scope="request"></c:remove>
                    showAlert('Register Failed!', 'Something went wrong!', 'error');
                </c:if>
                <c:if test="${not empty registerStatus && registerStatus eq 'admin-success'}">
                    <c:remove var="registerStatus" scope="request"></c:remove>
                    showAlert('Register Success!', 'New admin has been registered!', 'success');
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
    </div>
</div>
    </body>
</html>
