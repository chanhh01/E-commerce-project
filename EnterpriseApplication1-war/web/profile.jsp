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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
    <style>
        body {
            background: rgb(99, 39, 120)
        }
        
        .form-control:focus {
            box-shadow: none;
            border-color: #BA68C8
        }

        .profile-button {
            background: rgb(99, 39, 120);
            box-shadow: none;
            border: none
        }

        .profile-button:hover {
            background: #682773
        }

        .profile-button:focus {
            background: #682773;
            box-shadow: none
        }

        .profile-button:active {
            background: #682773;
            box-shadow: none
        }

        .back:hover {
            color: #682773;
            cursor: pointer
        }

        .labels {
            font-size: 11px
        }
        
        .backButton{
            position: absolute;
            top: 38px;
            left: 310px;
            width: 30px;
            height: 30px;
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

        .form-control:focus {
            box-shadow: none;
            border-color: #BA68C8
        }

        .profile-button {
            background: rgb(99, 39, 120);
            box-shadow: none;
            border: none
        }

        .profile-button:hover {
            background: #682773
        }

        .profile-button:focus {
            background: #682773;
            box-shadow: none
        }

        .profile-button:active {
            background: #682773;
            box-shadow: none
        }

        .back:hover {
            color: #682773;
            cursor: pointer
        }

        .labels {
            font-size: 11px
        }

        .add-experience:hover {
            background: #BA68C8;
            color: #fff;
            cursor: pointer;
            border: solid 1px #BA68C8
        }
    </style>    
</head>
<body>
<div class="container rounded bg-white mt-5 mb-5">
    
    <div class="row">
        <c:if test="${not empty param.roleDetail}">
            <c:forEach items="${userList}" var="targetDetail">
                <c:if test="${targetDetail.getId() eq param.userid}">
                    <c:set var="targetUser" value="${targetDetail}"></c:set>
                    <c:if test="${param.roleDetail eq 'customer' or param.roleDetail eq 'suspendedCust'}" >
                        <c:forEach items="${custList}" var="customer">
                            <c:if test="${customer.getUser_id() eq param.userid}">
                                <c:set var="detail" value="${customer}"></c:set>
                            </c:if>
                        </c:forEach>
                    </c:if>
                    <c:if test="${param.roleDetail eq 'seller' or param.roleDetail eq 'pending' or param.roleDetail eq 'suspendedSeller'}" >
                        <c:forEach items="${sellerList}" var="seller">
                            <c:if test="${seller.getUser_id() eq param.userid}">
                                <c:set var="detail" value="${seller}"></c:set>
                            </c:if>
                        </c:forEach>
                    </c:if>
                </c:if>
            </c:forEach>
            
            <div class="col-md-3 border-right">
                <button class="backButton" onclick="window.location.href='user_list.jsp';"> < </button>
            <c:if test="${not empty targetUser.getProfile_img()}">
            <div class="d-flex flex-column align-items-center text-center p-3 py-5"><img class="rounded-circle mt-5" width="150px" src="${targetUser.getProfile_img()}"><span class="font-weight-bold">${targetUser.getUsername()}</span><span class="text-black-50">${targetUser.getEmail()}</span><span> </span></div>
            </c:if>
            <c:if test="${empty targetUser.getProfile_img()}">
            <div class="d-flex flex-column align-items-center text-center p-3 py-5"><img class="rounded-circle mt-5" width="150px" src="images/user.png"><span class="font-weight-bold">${targetUser.getUsername()}</span><span class="text-black-50">${targetUser.getEmail()}</span><span> </span></div>
            </c:if>
            </div>
            <div class="col-md-5 border-right">
            <div class="p-3 py-5" style="float:left;">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="text-right">Profile Settings</h4>
                </div>
                <div>
                    <form action="${pageContext.request.contextPath}/ProfileServlet" method="post" id="adminEditProfile">
                        <input type="hidden" name="currUserId" value="${targetUser.getId()}">
                        <input type="hidden" name="editFor" value="adminEditProfile">
                        <div class="row mt-2">
                            <div class="col-md-12"><label class="labels">Username</label><input type="text" class="form-control" name="username" placeholder="first name" value="${targetUser.getUsername()}"></div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-md-12"><label class="labels">Profile Image Link</label><input type="url" class="form-control" name="imgUrl" placeholder="Paste link here" value="${targetUser.getProfile_img()}"></div>
                            <div class="col-md-12"><label class="labels">Email ID</label><input type="text" class="form-control" name="email" placeholder="enter email id" value="${targetUser.getEmail()}"></div>
                            <c:if test="${param.roleDetail eq 'customer' or param.roleDetail eq 'suspendedCustomer'}">
                                <div class="col-md-12"><label class="labels">Contact Number</label><input type="text" class="form-control" name="contactCust" placeholder="Contact_no" value="${detail.getContact_no()}"></div>
                                <div class="col-md-12"><label class="labels">Billing Address</label><input type="text" class="form-control" name="billing" placeholder="Billing Address" value="${detail.getBilling_address()}"></div>
                                <div class="col-md-12"><label class="labels">Shipping Address</label><input type="text" class="form-control" name="shipping" placeholder="Shipping address" value="${detail.getShipping_address()}"></div>
                                <div class="col-md-12"><label class="labels">Date of birth</label><input type="date" class="form-control" name="dob" placeholder="Date of birth" value="${detail.getDate_of_birth()}"></div>
                            </c:if>
                            <c:if test="${param.roleDetail eq 'seller' or param.roleDetail eq 'pending' or param.roleDetail eq 'suspendedSeller'}">
                                <div class="col-md-12"><label class="labels">Contact Number</label><input type="text" class="form-control" name="contactSeller" placeholder="Contact_no" value="${detail.getContact_no()}"></div>
                                <div class="col-md-12"><label class="labels">Address</label><input type="text" class="form-control" name="address" placeholder="Address" value="${detail.getAddress()}"></div>
                                <div class="col-md-12"><label class="labels">Description</label><input type="text" class="form-control" name="description" placeholder="Description" value="${detail.getDescription()}"></div>
                            </c:if>
                        </div>
                            <div class="mt-5 text-center"><button class="btn btn-primary profile-button" type="submit" onclick="setAdminEditProfile(${targetUser.getId()})">Save Profile</button></div>
                    </form>
                    <script>
                        function setAdminEditProfile(value1){
                            var userid = value1;
                            var form = document.getElementById("adminEditProfile");
                            form.action += "?editFor=adminEditProfile&currUserId=" + encodeURIComponent(userid);
                        }
                    </script>
                </div>
            </div>
          </div>
        </c:if>
        <c:if test="${empty param.roleDetail}">
            <div class="col-md-3 border-right">
                <button class="backButton" onclick="window.location.href='index.jsp';"> < </button>
            <c:if test="${not empty user.getProfile_img()}">
            <div class="d-flex flex-column align-items-center text-center p-3 py-5"><img class="rounded-circle mt-5" width="150px" src="${user.getProfile_img()}"><span class="font-weight-bold">${user.getUsername()}</span><span class="text-black-50">${user.getEmail()}</span><span> </span></div>
            </c:if>
            <c:if test="${empty user.getProfile_img()}">
            <div class="d-flex flex-column align-items-center text-center p-3 py-5"><img class="rounded-circle mt-5" width="150px" src="images/user.png"><span class="font-weight-bold">${user.getUsername()}</span><span class="text-black-50">${user.getEmail()}</span><span> </span></div>
            </c:if>
            </div>
        <div class="col-md-5 border-right">
            <div class="p-3 py-5" style="float:left;">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="text-right">Profile Settings</h4>
                </div>
                <div>
                    <form action="${pageContext.request.contextPath}/ProfileServlet" method="post" id="editProfile">
                        <div class="row mt-2">
                            <div class="col-md-12"><label class="labels">Username</label><input type="text" class="form-control" name="username" placeholder="first name" value="${user.getUsername()}"></div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-md-12"><label class="labels">Profile Image Link</label><input type="url" class="form-control" name="imgUrl" placeholder="Paste link here" value="${user.getProfile_img()}"></div>
                            <div class="col-md-12"><label class="labels">Email ID</label><input type="text" class="form-control" name="email" placeholder="enter email id" value="${user.getEmail()}"></div>
                            <c:if test="${role eq 'customer'}">
                                <div class="col-md-12"><label class="labels">Contact Number</label><input type="text" class="form-control" name="contactCust" placeholder="Contact_no" value="${userDetail.getContact_no()}"></div>
                                <div class="col-md-12"><label class="labels">Billing Address</label><input type="text" class="form-control" name="billing" placeholder="Billing Address" value="${userDetail.getBilling_address()}"></div>
                                <div class="col-md-12"><label class="labels">Shipping Address</label><input type="text" class="form-control" name="shipping" placeholder="Shipping address" value="${userDetail.getShipping_address()}"></div>
                                <div class="col-md-12"><label class="labels">Date of birth</label><input type="date" class="form-control" name="dob" placeholder="Date of birth" value="${userDetail.getDate_of_birth()}"></div>
                            </c:if>
                            <c:if test="${role eq 'seller'}">
                                <div class="col-md-12"><label class="labels">Contact Number</label><input type="text" class="form-control" name="contactSeller" placeholder="Contact_no" value="${userDetail.getContact_no()}"></div>
                                <div class="col-md-12"><label class="labels">Address</label><input type="text" class="form-control" name="address" placeholder="Address" value="${userDetail.getAddress()}"></div>
                                <div class="col-md-12"><label class="labels">Description</label><input type="text" class="form-control" name="description" placeholder="Description" value="${userDetail.getDescription()}"></div>
                            </c:if>
                        </div>
                        <div class="mt-5 text-center"><button class="btn btn-primary profile-button" type="submit" onclick="setEditOwnProfile('${role}')">Save Profile</button></div>
                    </form>
                    <script>
                        function setEditOwnProfile(value1){
                            var role = value1;
                            var form = document.getElementById("editProfile");
                            
                            if(role === 'admin'){
                                form.action += "?editFor=adminEditOwnProfile";
                            } else {
                                form.action += "?editFor=editOwnProfile";
                            }
                        }
                    </script>
                </div>  
            </div>
        </div>
        </c:if>
        <c:if test="${empty param.roleDetail}">
        <div class="col-md-4" style="float:right;">
            <form action="${pageContext.request.contextPath}/ProfileServlet" method="post" id="resetPassword">
                <div class="p-3 py-5">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h4 class="text-right">Reset Password</h4>
                    </div>
                    <div class="col-md-12"><label class="labels">Old Password</label><input type="password" class="form-control" name="oldPass" id="currPass" value=""></div> <br>
                    <div class="col-md-12"><label class="labels">New Password</label><input type="password" class="form-control" name="newPass" value=""></div>
                </div>
                <div class="mt-5 text-center"><button class="btn btn-primary profile-button" type="submit" onclick="setEditPassword()">Reset Password</button></div>
            </form>
            <script>
                function setEditPassword(){
                    var form = document.getElementById("resetPassword");
                    form.action += "?editFor=editPassword";
                }
            </script>
        </div>
        </c:if>
        <c:if test="${not empty param.roleDetail}">
            <c:if test="${param.roleDetail eq 'suspendedCust' or param.roleDetail eq 'suspendedSeller'}">
                <div class="col-md-4" style="float:right;">
                    <div class="p-3 py-5">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h4 class="text-right">This user is currently suspended, you can unsuspend the user after contacting the user.</h4>
                        </div>
                    </div>
                    <form action="${pageContext.request.contextPath}/ProfileServlet" method="post">
                        <input type="hidden" name="userId" value="${targetUser.getId()}" />
                        <input type="hidden" name="action" value="unsuspend" />
                        <div class="mt-5 text-center"><button class="btn btn-primary profile-button" type="submit">Reactive User</button></div>
                    </form>
                </div>
            </c:if>
            <c:if test="${param.roleDetail eq 'pending'}">
                <div class="col-md-4" style="float:right;">
                    <div class="p-3 py-5">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h4 class="text-right">This seller is still pending approval.</h4>
                        </div>
                    </div>
                    <form action="${pageContext.request.contextPath}/ProfileServlet" method="post">
                        <input type="hidden" name="userId" value="${targetUser.getId()}" />
                        <input type="hidden" name="action" value="approve" />
                        <div class="mt-5 text-center"><button class="btn btn-primary profile-button" type="submit">Approve Seller</button></div>
                    </form>
                    <form action="${pageContext.request.contextPath}/ProfileServlet" method="post">
                        <input type="hidden" name="userId" value="${targetUser.getId()}" />
                        <input type="hidden" name="action" value="reject" />
                        <div class="mt-5 text-center"><button class="btn btn-primary profile-button" type="submit">Reject Seller</button></div>
                    </form>
                </div>
            </c:if>
            <c:if test="${param.roleDetail eq 'customer' or param.roleDetail eq 'seller'}">
                <div class="col-md-4" style="float:right;">
                    <div class="p-3 py-5">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h4 class="text-right">Before suspending a user, kindly notify them the reason before doing so.</h4>
                        </div>
                    </div>
                    <form action="${pageContext.request.contextPath}/ProfileServlet" method="post">
                        <input type="hidden" name="userId" value="${targetUser.getId()}" />
                        <input type="hidden" name="action" value="suspend" />
                        <div class="mt-5 text-center"><button class="btn btn-primary profile-button" type="submit">Suspend user</button></div>
                    </form>
                </div>
            </c:if>
        </c:if>
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
    
    <c:if test="${not empty editStatus}">
        <c:if test="${not empty editStatus && editStatus eq 'duplicateEmail'}">
            <c:remove var="editStatus" scope="request"></c:remove>
            showAlert('Edit Failed!', 'The target email has been used by other user.', 'error');
        </c:if>
        <c:if test="${not empty editStatus && editStatus eq 'editSuccess'}">
            <c:remove var="editStatus" scope="request"></c:remove>
            showAlert('Edit successful!', 'Profile has been updated!', 'success');
        </c:if>
        <c:if test="${not empty editStatus && editStatus eq 'editFailed'}">
            <c:remove var="editStatus" scope="request"></c:remove>
            showAlert('Edit Failed!', 'Something went wrong and edit failed!', 'error');
        </c:if>
    </c:if>
 
    <c:if test="${not empty passStatus}">
        <c:if test="${not empty passStatus && passStatus eq 'editSuccess'}">
            <c:remove var="passStatus" scope="request"></c:remove>
            showAlert('Edit successful!', 'Your password has been updated!', 'success');
        </c:if>
        <c:if test="${not empty passStatus && passStatus eq 'editFailed'}">
            <c:remove var="passStatus" scope="request"></c:remove>
            showAlert('Edit Failed!', 'Something went wrong and edit password failed!', 'error');
        </c:if>
        <c:if test="${not empty passStatus && passStatus eq 'wrongPass'}">
            <c:remove var="passStatus" scope="request"></c:remove>
            showAlert('Edit Failed!', 'The current password you key in is wrong!', 'error');
        </c:if>
    </c:if>
</script>
</html>
