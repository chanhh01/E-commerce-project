<%-- 
    Document   : cust_review
    Created on : May 10, 2023, 8:24:09 PM
    Author     : Chan01
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <style>

            html,
            body {
                height: 100%
            }

            body {
                display: grid;
               place-items: center;
                font-family: 'Manrope', sans-serif;
               background: red;

            }

            .card {
                position: relative;
                display: flex;
                flex-direction: column;
                min-width: 0;
                padding: 20px;
                width: 450px;
                word-wrap: break-word;
                background-color: #fff;
                background-clip: border-box;
                border-radius: 6px;
                -moz-box-shadow: 0px 0px 5px 0px rgba(212, 182, 212, 1)
            }

            .comment-box{

                padding:5px;
            }



            .comment-area textarea{
               resize: none; 
                    border: 1px solid #ad9f9f;
            }


            .form-control:focus {
                color: #495057;
                background-color: #fff;
                border-color: #ffffff;
                outline: 0;
                box-shadow: 0 0 0 1px rgb(255, 0, 0) !important;
            }

            .send {
                color: #fff;
                background-color: #ff0000;
                border-color: #ff0000;
            }

            .send:hover {
                color: #fff;
                background-color: #f50202;
                border-color: #f50202;
            }


            .rating {
             display: flex;
                    margin-top: -10px;
                flex-direction: row-reverse;
                margin-left: -4px;
                    float: left;
            }

            .rating>input {
                display: none
            }

            .rating>label {
                    position: relative;
                width: 19px;
                font-size: 25px;
                color: #ff0000;
                cursor: pointer;
            }

            .rating>label::before {
                content: "\2605";
                position: absolute;
                opacity: 0
            }

            .rating>label:hover:before,
            .rating>label:hover~label:before {
                opacity: 1 !important
            }

            .rating>input:checked~label:before {
                opacity: 1
            }

            .rating:hover>input:checked~label:before {
                opacity: 0.4
            }
            
        </style>
    </head>
    <body>
        <div class="card">
            <c:if test="${not empty param.reviewId and not empty param.itemid}">
                <div class="row">
                  <div class="col-2">
                      <c:if test="${not empty user.getProfile_img()}">
                          <img src="${user.getProfile_img()}" width="70" class="rounded-circle mt-2">
                      </c:if>
                      <c:if test="${empty user.getProfile_img()}">
                          <img src="images/user.png" width="70" class="rounded-circle mt-2">
                      </c:if>
                  </div>
                  
                  <div class="col-10">
                      <div class="comment-box ml-2">
                          <h4>Submit your reply!</h4>
                          <form action="${pageContext.request.contextPath}/review" method="post" id="reviewForm">
                            <div class="comment-area">
                                <textarea class="form-control" placeholder="Your reply here" rows="4" id="feedbackInput" name="reply"></textarea>
                            </div>

                            <div class="comment-btns mt-2">
                                <div class="row">            
                                    <div class="col-6">                      
                                        <div class="pull-left">      
                                        <button class="btn btn-success btn-sm" onclick="goBack(${param.itemid})">Cancel</button>            
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <div class="pull-right">
                                            <input type="hidden" name="reviewId" value="${param.reviewId}" />
                                        <button class="btn btn-success send btn-sm" type="submit">Send <i class="fa fa-long-arrow-right ml-1"></i></button>      
                                        </div>
                                    </div>
                                </div>
                            </div>
                          </form>
                      </div>
                  </div>
              </div>
            </c:if>
            <c:if test="${not empty param.orderId and not empty param.itemId}">
                <div class="row">
                  <div class="col-2">
                      <c:if test="${not empty user.getProfile_img()}">
                          <img src="${user.getProfile_img()}" width="70" class="rounded-circle mt-2">
                      </c:if>
                      <c:if test="${empty user.getProfile_img()}">
                          <img src="images/user.png" width="70" class="rounded-circle mt-2">
                      </c:if>
                  </div>
                  
                  <div class="col-10">
                      <div class="comment-box ml-2">
                          <h4>Submit your feedback!</h4>
                          <form action="${pageContext.request.contextPath}/review" method="post" id="reviewForm">
                              <div class="rating"> 
                                <input type="radio" name="rating" value="5" id="5"><label for="5">☆</label>
                                <input type="radio" name="rating" value="4" id="4"><label for="4">☆</label> 
                                <input type="radio" name="rating" value="3" id="3"><label for="3">☆</label>
                                <input type="radio" name="rating" value="2" id="2"><label for="2">☆</label>
                                <input type="radio" name="rating" value="1" id="1"><label for="1">☆</label>
                            </div>
                          
                            <div class="comment-area">
                                <textarea class="form-control" placeholder="Your feedback here" rows="4" id="feedbackInput" name="feedback"></textarea>
                            </div>

                            <div class="comment-btns mt-2">
                                <div class="row">            
                                    <div class="col-6">                      
                                        <div class="pull-left">      
                                        <button class="btn btn-success btn-sm" onclick="window.location.href='order.jsp';">Cancel</button>            
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <div class="pull-right">
                                            <input type="hidden" name="orderId" value="${param.orderId}" />
                                        <button class="btn btn-success send btn-sm" type="submit" onclick="postReview()">Send <i class="fa fa-long-arrow-right ml-1"></i></button>      
                                        </div>
                                    </div>
                                </div>
                            </div>
                          </form>
                      </div>
                  </div>
              </div>
            </c:if>
            <c:if test="${(empty param.orderId or empty param.itemId) and (empty param.reviewId or empty param.itemid)}">
                <div class="row">
                    Something went wrong.
                </div>
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
        
        function goBack(value1){
            event.preventDefault();
            var itemid = value1;
            window.location.href='item.jsp?itemid=' + encodeURIComponent(itemid);
        }
        
        
        function postReview(){
            var ratingRadios = document.getElementsByName('rating');
            var selectedRating = null;
            for (var i = 0; i < ratingRadios.length; i++) {
              if (ratingRadios[i].checked) {
                selectedRating = ratingRadios[i].value;
                break;
              }
            }
            
            if (selectedRating !== null) {
                var feedbackText = document.getElementById("feedbackInput").value;
                if (feedbackText !== "") {
                    var form = document.getElementById("reviewForm");
                    form.action += "?finalRating=" + encodeURIComponent(selectedRating);
                    form.submit();
                  } else {
                    event.preventDefault();
                    showAlert('Error!', 'Kindly provide your feedback before submitting feedback!', 'error');
                  }
              } else {
               event.preventDefault();
                showAlert('Error!', 'Kindly provide your rating before submitting feedback!', 'error');
              }
        }
    </script>
</html>
