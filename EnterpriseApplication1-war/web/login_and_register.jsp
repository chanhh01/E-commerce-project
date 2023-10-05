<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 20/4/2023
  Time: 9:12 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Login and Registration</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500&display=swap" rel="stylesheet">
    <style type="text/css">
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
        .login{
            height: 560px;
            background: #eee;
            border-radius: 60% / 10%;
            transform: translateY(-180px);
            transition: .8s ease-in-out;
        }
        .login label{
            color: #573b8a;
            transform: scale(.6);
        }

        #chk:checked ~ .login{
            transform: translateY(-600px);
        }
        #chk:checked ~ .login label{
            transform: scale(1);
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
        <form action="${pageContext.request.contextPath}/RegisterServlet" method="post" id="registrationForm" enctype="multipart/form-data">
            <label for="chk" aria-hidden="true">Register</label>
            <input type="text" name="username" placeholder="User name" required="">
            <label class="label-upload-input" for="uploadInput">Go to https://imgbb.com and upload the image then paste it here:</label>
            <input type="url" id="url" name="url" placeholder="Paste image link here (Optional)">
            <input type="email" name="email" placeholder="Email" required="">
            <input type="password" name="pswd" placeholder="Password" required="">
            <select name="role" onchange="showUserFields()">
                <option value="None">None</option>
                <option value="Customer">Customer</option>
                <option value="Seller">Seller</option>
            </select>
            <div id="customerFields" style="display:none">
                <input type="text" name="contactCust" placeholder="Contact_no">
                <input type="text" name="billing" placeholder="Billing Address">
                <input type="text" name="shipping" placeholder="Shipping address">
                <input type="date" name="dob" placeholder="Date of birth">
            </div>
            <div id="sellerFields" style="display:none">
                <input type="text" name="contactSeller" placeholder="Contact_no">
                <input type="text" name="address" placeholder="Address">
                <input type="text" name="description" placeholder="Description">
            </div>
            <button type="submit" onclick="setRegistrationAttribute()">Register</button>
        </form>
        <script>
            function setRegistrationAttribute() {
                var form = document.getElementById("registrationForm");
                form.action += "?registerFrom=registration";
            }
            function showUserFields() {
                const role = document.getElementsByName("role")[0].value;
                if (role === "Customer") {
                    document.getElementById("sellerFields").style.display = "none";
                    document.getElementById("customerFields").style.display = "block";
                    const main = document.querySelector('.main');
                    main.style.height = '790px';
                    const loginpad = document.querySelector('.login');
                    loginpad.style.height = '710px';
                    const selectElement = document.querySelector('select');
                    const options = selectElement.options;
                    if (options.length === 3){
                        selectElement.removeChild(selectElement.options[0]);
                    }
                    const checkbox = document.querySelector('#chk');
                    checkbox.addEventListener('change', function() {
                        if (this.checked) {
                            loginpad.style.transform = 'translateY(-800px)';
                        } else {
                            loginpad.style.transform = 'translateY(-180px)';
                        }
                    });
                    setRequiredAttribute(document.getElementsByName("contactCust"), true);
                    setRequiredAttribute(document.getElementsByName("billing"), true);
                    setRequiredAttribute(document.getElementsByName("shipping"), true);
                    setRequiredAttribute(document.getElementsByName("dob"), true);
                    setRequiredAttribute(document.getElementsByName("contactSeller"), false);
                    setRequiredAttribute(document.getElementsByName("address"), false);
                    setRequiredAttribute(document.getElementsByName("description"), false);
                } else if (role === "Seller") {
                    document.getElementById("customerFields").style.display = "none";
                    document.getElementById("sellerFields").style.display = "block";
                    const main = document.querySelector('.main');
                    main.style.height = '740px';
                    const loginpad = document.querySelector('.login');
                    loginpad.style.height = '690px';
                    const selectElement = document.querySelector('select');
                    const options = selectElement.options;
                    if (options.length === 3){
                        selectElement.removeChild(selectElement.options[0]);
                    }
                    const checkbox = document.querySelector('#chk');
                    checkbox.addEventListener('change', function() {
                        if (this.checked) {
                            loginpad.style.transform = 'translateY(-750px)';
                        } else {
                            loginpad.style.transform = 'translateY(-180px)';
                        }
                    });
                    setRequiredAttribute(document.getElementsByName("contactCust"), false);
                    setRequiredAttribute(document.getElementsByName("billing"), false);
                    setRequiredAttribute(document.getElementsByName("shipping"), false);
                    setRequiredAttribute(document.getElementsByName("dob"), false);
                    setRequiredAttribute(document.getElementsByName("contactSeller"), true);
                    setRequiredAttribute(document.getElementsByName("address"), true);
                    setRequiredAttribute(document.getElementsByName("description"), true);
                }
            }
            
            <c:if test="${not empty registerStatus}">
                <c:if test="${not empty registerStatus && registerStatus eq 'duplicate-email'}">
                    <c:remove var="registerStatus" scope="request"></c:remove>
                    showAlert('Register Failed!', 'This email has been used by other user.', 'error');
                </c:if>
                <c:if test="${not empty registerStatus && registerStatus eq 'no-role'}">
                    <c:remove var="registerStatus" scope="request"></c:remove>
                    showAlert('Register Failed!', 'Please select a role for registration!', 'error');
                </c:if>
                <c:if test="${not empty registerStatus && registerStatus eq 'customer-success'}">
                    <c:remove var="registerStatus" scope="request"></c:remove>
                    showAlert('Register Success!', 'Registered as new customer!', 'success');
                </c:if>
                <c:if test="${not empty registerStatus && registerStatus eq 'seller-success'}">
                    <c:remove var="registerStatus" scope="request"></c:remove>
                    showAlert('Register Success!', 'Registered as new seller!', 'success');
                </c:if>
                <c:if test="${not empty registerStatus && registerStatus eq 'register-fail'}">
                    <c:remove var="registerStatus" scope="request"></c:remove>
                    showAlert('Register Failed!', 'Something went wrong!', 'error');
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

    <div class="login">
        <form action="${pageContext.request.contextPath}/Login" method="post">
            <label for="chk" aria-hidden="true">Login</label>
            <input type="email" name="email" placeholder="Email" required="">
            <input type="password" name="pswd" placeholder="Password" required="">
            <button type="submit">Login</button>
        </form>
            <script>
            <c:if test="${not empty loginStatus}">
                <c:if test="${not empty loginStatus && loginStatus eq 'pending'}">
                     <c:remove var="loginStatus" scope="request"></c:remove>
                    showAlert('Oops!', 'Your seller account is yet to be approved by admins, please be patient.', 'warning');
                </c:if>
                <c:if test="${not empty loginStatus && loginStatus eq 'suspended'}">
                     <c:remove var="loginStatus" scope="request"></c:remove>
                    showAlert('Oops!', 'It looks like your account has been suspended! Please contact admin for more info.', 'warning');
                </c:if>
                <c:if test="${not empty loginStatus && loginStatus eq 'no'}">
                     <c:remove var="loginStatus" scope="request"></c:remove>
                    showAlert('Login Failed!', 'Something went wrong.', 'error');
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
