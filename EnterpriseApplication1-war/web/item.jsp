<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 20/4/2023
  Time: 7:37 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>  
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
    <style>
        
        .backButton{
            position: absolute;
            top: -66px;
            left: 23px;
            width: 30px;
            height: 30px;
        }
        
        html,
        body {
            height: 100%
        }

        .card {
             position: relative;
             display: flex;
             width: 100%;
             padding:20px;
             flex-direction: column;
             min-width: 0;
             word-wrap: break-word;
             background-color: #fff;
             background-clip: border-box;
             border: 1px solid #d2d2dc;
             border-radius: 11px;
             -webkit-box-shadow: 0px 0px 5px 0px rgb(249, 249, 250);
             -moz-box-shadow: 0px 0px 5px 0px rgba(212, 182, 212, 1);
             box-shadow: 0px 0px 5px 0px rgb(161, 163, 164)
         }

        .media img{

            width: 60px;
            height: 60px;
        }


        .reply a {

            text-decoration: none;
        }
        
        .text-decoration-line-through {
            text-decoration: line-through;
          }
          
         ul > li{margin-right:25px;font-weight:lighter;cursor:pointer}
        li.active{border-bottom:3px solid silver;}

        .item-photo{display:flex;justify-content:center;align-items:center;border-right:1px solid #f6f6f6;}
        .menu-items{list-style-type:none;font-size:11px;display:inline-flex;margin-bottom:0;margin-top:20px}
        .btn-success{width:100%;border-radius:0;}
        .section{width:100%;margin-left:-15px;padding:2px;padding-left:15px;padding-right:15px;background:#f8f9f9}
        .title-price{margin-top:30px;margin-bottom:0;color:black}
        .title-attr{margin-top:0;margin-bottom:0;color:black;}
        .btn-minus{cursor:pointer;font-size:7px;display:flex;align-items:center;padding:5px;padding-left:10px;padding-right:10px;border:1px solid gray;border-radius:2px;border-right:0;}
        .btn-plus{cursor:pointer;font-size:7px;display:flex;align-items:center;padding:5px;padding-left:10px;padding-right:10px;border:1px solid gray;border-radius:2px;border-left:0;}
        div.section > div {width:100%;display:inline-flex;}
        div.section > div > input {margin:0;padding-left:5px;font-size:10px;padding-right:5px;max-width:18%;text-align:center;}
        .attr,.attr2{cursor:pointer;margin-right:5px;height:20px;font-size:10px;padding:2px;border:1px solid gray;border-radius:2px;}
        .attr.active,.attr2.active{ border:1px solid orange;}
        .h3{margin-top: 5px;}
        @media (max-width: 426px) {
            .container {margin-top:0px !important;}
            .container > .row{padding:0 !important;}
            .container > .row > .col-xs-12.col-sm-5{
                padding-right:0 ;    
            }
            .container > .row > .col-xs-12.col-sm-9 > div > p{
                padding-left:0 !important;
                padding-right:0 !important;
            }
            .container > .row > .col-xs-12.col-sm-9 > div > ul{
                padding-left:10px !important;

            }            
            .section{width:104%;}
            .menu-items{padding-left:0;}
        }
    </style>
</head>
<body>
    <c:if test="${not empty param.itemid}">
        <c:set var="item" value="${product}"></c:set>
        <c:set var="seller" value="${sellerName}"></c:set>
        <c:set var="category" value="${productCategory}"></c:set>
        <c:set var="reviews" value="${reviewForItem}"></c:set>
        <c:set var="stat" value="${sellerStatus}"></c:set>
    <c:if test="${empty product}">
        <jsp:include page="/getDetails?itemIdForItemDetail=${param.itemid}"></jsp:include>
    </c:if>
    </c:if>
    <div class="container">
        <div class="d-flex flex-row align-items-center"><a href="index.jsp"><i class="fa fa-long-arrow-left"></i><span class="ml-2">Back</span></a></div>
        <hr>
        <c:if test="${not empty auth && (role eq 'seller' or role eq 'admin')}">
            <c:if test="${not empty param.itemid and param.itemid gt 0}"> 
                <div class="row">
               <div class="col-xs-4 item-photo">
                   <c:if test="${not empty item.getItem_img()}">
                       <img style="max-width:100%;" name="productImg" src="${item.getItem_img()}" />
                   </c:if>
                   <c:if test="${empty item.getItem_img()}">
                       <img style="max-width:100%;" name="productImg" src="https://cdn5.vectorstock.com/i/1000x1000/80/64/mystery-box-icon-random-loot-box-flat-icon-vector-35858064.jpg" />
                   </c:if>
                </div>
                <div class="col-xs-5" style="border:0px solid gray">
                    <h3>${item.getItem_name()}</h3>
                    <c:if test="${role eq 'admin'}">
                        <h5 style="color:#5A5A5A">Seller: <a href="seller_dashboard.jsp?sellerId=${item.getSeller_id()}">${seller}</a> · <p style="color:#337ab7">(${item.getSold_qty()} sold)</p></h5>
                    </c:if>
                    <c:if test="${role eq 'seller'}">
                        <p style="color:#5A5A5A">(${item.getSold_qty()} sold)</p>
                    </c:if> 
                    <h5 style="color:#5A5A5A">Category: <small style="color:#337ab7">${category}</small></h5>
                    <c:if test="${item.getQuantity() gt 0}">
                        <h5 style="color:#5A5A5A">Stock: <p id="stockQty" style="color:#337ab7">${item.getQuantity()}</p></h5>
                    </c:if>
                    <c:if test="${item.getQuantity() eq 0}">
                        <h5 style="color:#5A5A5A"> OUT OF STOCK! </h5>
                    </c:if>
                    <h6 class="title-price"><small>PRICE:</small></h6>
                    <c:if test="${item.getDiscount_percentage() gt 0}">
                        <h3 style="margin-top:0px; font-weight:bold;">RM ${item.getDiscountedPrice(item)}</h3>
                        <p class="text-muted text-decoration-line-through">RM ${item.getPrice()}</p>
                    </c:if>
                    <c:if test="${item.getDiscount_percentage() eq 0}">
                        <h3 style="margin-top:0px;">RM ${item.getPrice()}</h3>
                    </c:if>        
                    
                    <c:if test="${role eq 'seller'}">
                        <div class="section" style="padding-bottom:20px;">
                            <button class="btn btn-success" onclick="window.location.href='edit_item.jsp?id=${item.getId()}'"><span style="margin-right:20px" class="glyphicon glyphicon-edit" aria-hidden="true"></span>Edit item</button>
                            
                            <form action="${pageContext.request.contextPath}/ItemServlet" method="post" id="cartForm">
                                <input type="hidden" name="itemId" value="${item.getId()}" />
                                <input type="hidden" name="action" value="deleteItem" />
                                <button class="btn btn-success" type="submit"><span style="margin-right:20px" class="glyphicon glyphicon-edit" aria-hidden="true"></span>Delete item</button>
                            </form>
                        </div>
                    </c:if>                                     
                </div>                              
        
                    <div class="col-xs-9">
                        <ul class="menu-items">
                            <li id="descriptionLi" class="active">Description</li>
                            <li id="reviewsLi">Reviews</li>
                        </ul>
                        <div style="width:100%;border-top:1px solid silver" id="descriptionDiv">
                            <p style="padding:15px;">
                                ${item.getDescription()}
                            </p>
                        </div>
                        <div style="width:100%;border-top:1px solid silver" id="reviewDiv">
                            <div class="card">
                                <div class="row">
                                    <div class="col-md-12">
                                        <c:if test="${not empty reviews and fn:length(reviews) gt 0}">
                                            <c:forEach items="${reviews}" var="review">
                                                <div class="media mt-4">
                                                <c:if test="${not empty review.getUserImg()}">
                                                    <img class="mr-3 rounded-circle" alt="Bootstrap Media Preview" src="${review.getUserImg()}" width="40" height="40"/>
                                                </c:if>
                                                <c:if test="${empty review.getUserImg()}">
                                                    <img class="mr-3 rounded-circle" alt="Bootstrap Media Preview" src="images/user.png" width="40" height="40"/>
                                                </c:if>
                                                <div class="media-body">
                                                    <div class="row">
                                                        <div class="col-8 d-flex">
                                                        <h5>${review.getUsername()} (Customer)</h5>
                                                        <span>-- Rating: ${review.getRating()}</span>
                                                        </div>

                                                        <div class="col-4">
                                                            <div class="pull-right reply">
                                                                <a href="cust_review.jsp?reviewId=${review.getId()}&itemid=${review.getItem_id()}"><span><i class="fa fa-reply"></i> Reply</span></a>
                                                            </div>
                                                        </div>
                                                    </div>		

                                                    ${review.getComment()}

                                                    <c:if test="${not empty replyList && fn:length(replyList) gt 0}">
                                                        <c:forEach items="${replyList}" var="reply">
                                                            <c:if test="${reply.getReview_id() eq review.getId()}">
                                                                <div class="media mt-3">
                                                                    <c:if test="${not empty reply.getUserImg()}">
                                                                        <img class="mr-3 rounded-circle" alt="Bootstrap Media Preview" src="${reply.getUserImg()}" width="40" height="40"/>
                                                                    </c:if>
                                                                    <c:if test="${empty reply.getUserImg()}">
                                                                        <img class="mr-3 rounded-circle" alt="Bootstrap Media Preview" src="images/user.png" width="40" height="40"/>
                                                                    </c:if>
                                                                    <div class="media-body">
                                                                        <div class="row">
                                                                            <div class="col-12 d-flex">
                                                                                <h5>${reply.getUsername()} (${reply.getUserRole()})</h5>
                                                                            </div>
                                                                        </div>
                                                                        ${reply.getComment()}
                                                                    </div>
                                                                </div>
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:if>
                                                </div>
                                            </div>
                                            </c:forEach>
                                        </c:if>
                                        <c:if test="${empty reviews or fn:length(reviews) eq 0}">
                                            <h3> No reviews found for this item. </h3>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>		
                </div>
            </c:if>
            <c:if test="${empty param.itemid or param.itemid eq 0}">
                <div class="row">
                    <h3>Item not found!</h3>
                </div>
            </c:if>  
        </c:if>
        <c:if test="${(not empty auth && role eq 'customer') or empty auth}">
            <c:if test="${not empty param.itemid}">
                <div class="row">
               <div class="col-xs-4 item-photo">
                   <c:if test="${not empty item.getItem_img()}">
                       <img style="max-width:100%;" name="productImg" src="${item.getItem_img()}" />
                   </c:if>
                   <c:if test="${empty item.getItem_img()}">
                       <img style="max-width:100%;" name="productImg" src="https://cdn5.vectorstock.com/i/1000x1000/80/64/mystery-box-icon-random-loot-box-flat-icon-vector-35858064.jpg" />
                   </c:if>
                </div>
                <div class="col-xs-5" style="border:0px solid gray">
                    <h3>${item.getItem_name()} · <small style="color:#337ab7">(${item.getSold_qty()} sold)</small></h3>
                    
                    <h5 style="color:#5A5A5A">Seller: <a href="seller_dashboard.jsp?sellerId=${item.getSeller_id()}">${seller}</a></h5>
                    <h5 style="color:#5A5A5A">Category: <p style="color:#337ab7">${category}</p></h5>
                    <c:if test="${item.getQuantity() gt 0}">
                        <h5 style="color:#5A5A5A">Stock: <p id="stockQty" style="color:#337ab7">${item.getQuantity()}</p></h5>
                    </c:if>
                    <c:if test="${item.getQuantity() eq 0}">
                        <h5 style="color:#5A5A5A"> OUT OF STOCK! </h5>
                    </c:if>
                    <h6 class="title-price"><small>PRICE:</small></h6>
                    <c:if test="${item.getDiscount_percentage() gt 0}">
                        <h3 style="margin-top:0px;">RM ${item.getDiscountedPrice(item)}</h3>
                        <p class="text-muted text-decoration-line-through">RM ${item.getPrice()}</p>
                    </c:if>
                    <c:if test="${item.getDiscount_percentage() eq 0}">
                        <h3 style="margin-top:0px;">RM ${item.getPrice()}</h3>
                    </c:if>
                    
                <form action="${pageContext.request.contextPath}/CartServlet" method="post" id="cartForm">
                    <div class="section" style="padding-bottom:20px;">
                        <h6 class="title-attr"><p>Select Quantity</p></h6>                    
                        <div>
                            <div class="btn-minus" ><span class="glyphicon glyphicon-minus"></span></div>
                            <input id="qty${item.getId()}" name="qty" value="1" />
                            <div class="btn-plus" ><span class="glyphicon glyphicon-plus"></span></div>
                        </div>
                    </div>                
        
                    <div class="section" style="padding-bottom:20px;">
                        <c:if test="${stat eq 'seller'}">
                            <input type="hidden" name="itemId" value="${item.getId()}" />
                            <button class="btn btn-success" type="submit"><span style="margin-right:20px" class="glyphicon glyphicon-shopping-cart" aria-hidden="true"></span> Add to Cart</button>
                            <button class="btn btn-success" type="button" onclick="setOrder(${item.getId()})"><span style="margin-right:20px" class="glyphicon glyphicon-usd" aria-hidden="true"></span> Purchase Item</button>
                        </c:if>
                        <c:if test="${stat eq 'suspendedSeller'}">
                            <h3> This seller is currently suspended, thus item transaction is not allowed at the moment. </h3>
                        </c:if>
                    </div>
                  </form>
                </div>                              
        
                    <div class="col-xs-9">
                        <ul class="menu-items">
                            <li id="descriptionLi" class="active">Description</li>
                            <li id="reviewsLi">Reviews</li>
                        </ul>
                        <div style="width:100%;border-top:1px solid silver" id="descriptionDiv" style="display:block;">
                            <p style="padding:15px;">
                                ${item.getDescription()}
                            </p>
                        </div>
                        <div style="width:100%;border-top:1px solid silver" id="reviewDiv" style="display:none;">
                            <div class="card">
                                <div class="row">
                                    <div class="col-md-12">
                                        <c:if test="${not empty reviews and fn:length(reviews) gt 0}">
                                            <c:forEach items="${reviews}" var="review">
                                                <div class="media mt-4">
                                                <c:if test="${not empty review.getUserImg()}">
                                                    <img class="mr-3 rounded-circle" alt="Bootstrap Media Preview" src="${review.getUserImg()}" width="40" height="40"/>
                                                </c:if>
                                                <c:if test="${empty review.getUserImg()}">
                                                    <img class="mr-3 rounded-circle" alt="Bootstrap Media Preview" src="images/user.png" width="40" height="40"/>
                                                </c:if>
                                                <div class="media-body">
                                                    <div class="row">
                                                        <div class="col-8 d-flex">
                                                        <h5>${review.getUsername()} (Customer)</h5>
                                                        <span>  ---- Rating: ${review.getRating()}</span>
                                                        </div>

                                                        <div class="col-4">
                                                            <div class="pull-right reply">
                                                                <a href="cust_review.jsp?reviewId=${review.getId()}&itemid=${review.getItem_id()}"><span><i class="fa fa-reply"></i> Reply</span></a>
                                                            </div>
                                                        </div>
                                                    </div>		

                                                    ${review.getComment()}

                                                    <c:if test="${not empty replyList && fn:length(replyList) gt 0}">
                                                        <c:forEach items="${replyList}" var="reply">
                                                            <c:if test="${reply.getReview_id() eq review.getId()}">
                                                                <div class="media mt-3">
                                                                    <c:if test="${not empty reply.getUserImg()}">
                                                                        <img class="mr-3 rounded-circle" alt="Bootstrap Media Preview" src="${reply.getUserImg()}" width="40" height="40"/>
                                                                    </c:if>
                                                                    <c:if test="${empty reply.getUserImg()}">
                                                                        <img class="mr-3 rounded-circle" alt="Bootstrap Media Preview" src="images/user.png" width="40" height="40"/>
                                                                    </c:if>
                                                                    <div class="media-body">
                                                                        <div class="row">
                                                                            <div class="col-12 d-flex">
                                                                                <h5>${reply.getUsername()} (${reply.getUserRole()})</h5>
                                                                            </div>
                                                                        </div>
                                                                        ${reply.getComment()}
                                                                    </div>
                                                                </div>
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:if>
                                                </div>
                                            </div>
                                            </c:forEach>
                                        </c:if>
                                        <c:if test="${empty reviews or fn:length(reviews) eq 0}">
                                            <h3> No reviews found for this item. </h3>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>		
                </div>
            </c:if>
            <c:if test="${empty param.itemid}">
                <div class="row">
                    <h3>Item not found!</h3>
                </div>
            </c:if>  
        </div>
        </c:if>      
    </body>
    <script>
        window.onload = function() {
            document.getElementById("descriptionDiv").style.display = "block";
            document.getElementById("reviewDiv").style.display = "none";
        };
        

        function setOrder(value1){
            var itemId = value1;
            var targetQty = document.getElementById("qty"+value1).value;
            
            if (${item.getQuantity()} === 0){
                showAlert('Failed!', 'This item is out of stock!', 'error');
            } else {
                if (targetQty <= ${item.getQuantity()}){
                    window.location.href = 'payment.jsp?itemId=' + encodeURIComponent(itemId) + '&qty=' + encodeURIComponent(targetQty);
                } else {
                    showAlert('Failed!', 'Your target quantity exceeds the stock quantity for this item!', 'error');
                }
            }
        }
        
        async function replyReview(){
            event.preventDefault();
            const { value: text } = await Swal.fire({
                input: 'textarea',
                inputLabel: 'Feedback reply',
                inputPlaceholder: 'Type your reply here....',
                inputAttributes: {
                  'aria-label': 'Type your message here'
                },
                showCancelButton: true
              });

              if (text) {
                var form = document.getElementById("replyForm");
                form.action += "?comment=" + encodeURIComponent(text);
                form.submit();
              } else {
                showAlert('Error', 'Cannot submit blank reply', 'error');
              }
        }
        
        function showAlert(title, text, type) {
                Swal.fire({
                    title: title,
                    text: text,
                    icon: type,
                    confirmButtonColor: '#3085d6',
                    confirmButtonText: 'OK'
                });
            }
        
           $(document).ready(function(){
            //-- Click on detail
            $("ul.menu-items > li").on("click",function(){
                $("ul.menu-items > li").removeClass("active");
                $(this).addClass("active");
                
                var liId = $(this).attr("id");
                
                if (liId === "descriptionLi"){
                    document.getElementById("descriptionDiv").style.display = "block";
                    document.getElementById("reviewDiv").style.display = "none";
                } else if (liId === "reviewsLi"){
                    document.getElementById("reviewDiv").style.display = "flex";
                    document.getElementById("descriptionDiv").style.display = "none";
                }
            });

            $(".attr,.attr2").on("click",function(){
                var clase = $(this).attr("class");

                $("." + clase).removeClass("active");
                $(this).addClass("active");
            });

            //-- Click on QUANTITY
            $(".btn-minus").on("click",function(){
                var now = $(".section > div > input").val();
                if ($.isNumeric(now)){
                    if (parseInt(now) -1 > 0){ now--;}
                    $(".section > div > input").val(now);
                }else{
                    $(".section > div > input").val("1");
                }
            });            
            $(".btn-plus").on("click",function(){
                var now = $(".section > div > input").val();
                if ($.isNumeric(now)){
                    $(".section > div > input").val(parseInt(now)+1);
                }else{
                    $(".section > div > input").val("1");
                }
            });                        
        });

        <c:if test="${not empty orderCreationStatus}">
            <c:if test="${not empty orderCreationStatus && orderCreationStatus eq 'failPayment'}">
                <c:remove var="orderCreationStatus" scope="request"></c:remove>
                showAlert('Order not added!', '', 'error');
            </c:if>
        </c:if>
            
        <c:if test="${not empty replyStat && replyStat eq 'success'}">
            <c:remove var="addCart" scope="request"></c:remove>
            showAlert('Reply added!', '', 'success');
        </c:if>
        <c:if test="${not empty replyStat && replyStat eq 'fail'}">
            <c:remove var="addCart" scope="request"></c:remove>
            showAlert('Error!', 'Something went wrong and reply not added!', 'success');
        </c:if>
    </script>
</html>
