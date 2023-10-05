<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 28/4/2023
  Time: 12:54 PM
  To change this template use File | Settings | File Templates.
--%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="Model.Items"%>
<%@page import="java.util.List"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>  
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap" rel="stylesheet">
<style>
        .itemContainer{
            display: grid;
            grid-template-columns: repeat(5,1fr);
            grid-row-gap:30px;
            grid-column-gap: 15px;
        }
        
    .product-card {
        width: 100%;
        border: 1px solid #e0e0e0;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        border-radius: 5px;
    }

    .product-price {
        font-weight: bold;
        color: #333;
        margin: 0.5rem 0;
        justify-content: flex-start;
    }

    .product-footer-card{
        display: flex;
        flex-direction: column;
        width: 100%;
        gap:20px;
    }

    .product-card:hover{
        color: white;
        background-color: #72a0f6;
    }

    .product-details-button-card{
        font-family: 'Inter';
        font-style: normal;
        font-weight: 500;
        font-size: 14.6058px;
        color: #5182d0;
        background-color: transparent;
        outline: none;
        cursor: pointer;
        border: 1px solid #9DC2FF;
        padding: 4px 10px;
        border-radius: 4.17308px;
        align-self: flex-end;
        transition: all 0.2s ease-in;
    }

    .product-rating-value-card{
        font-family: 'Inter';
        font-style: normal;
        font-weight: 400;
        font-size: 15px;
        color: rgba(63, 63, 63, 0.87);
    }

    .product-card-rating{
        display: flex;
        flex-direction: row;
        gap:8px;
        align-items: center;
        align-self: flex-start;
    }

    *{
        padding: 0;
        margin:0;
    }

    .product-content-card{
        display: flex;
        flex-direction: column;
        padding: 15px 32px 20px;
        justify-content: space-between;
        align-items: flex-start;
        height: 100%;
    }
    
    .red{
        background-color: #e03e3e;
        position: absolute;
        color: #fff;
        border-radius: 5px;
        right: 5px;
        top: 5px;
        font-size: 0.9rem;
    }

    .product-image-card-wrapper img{
        width: 100%;
        height: 100%;
        object-fit: contain;
    }

    .product-image-card-wrapper{
        height: 165px;
        width: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        border-bottom: 1px solid #F6F6F9;
    }

    .product-card{
        width: 100%;
        height: 350px;
        background: #FFFFFF;
        border: 0.5px solid #EAEAEF;
        box-shadow: 0px 1px 4px rgba(26, 26, 67, 0.1);
        border-radius: 7px;
        display: flex;
        flex-direction: column;
        align-items: center;
        overflow: hidden;
    }

    .product-title-card{
        display: -webkit-box;
        -webkit-box-orient: vertical;
        overflow: hidden;
        font-family: 'Inter', serif;
        font-style: normal;
        font-weight: 400;
        font-size: 16.6923px;
        color: #19191D;
        -webkit-line-clamp: 3;
        line-clamp: 3;
        max-height: 77px;
        text-overflow: ellipsis;
    }

    .product-price-card{
        font-family: 'Inter';
        font-style: normal;
        font-weight: 700;
        font-size: 25.0385px;
        color: rgba(0, 0, 0, 0.87);
        margin: 7px 0px 9px;
    }

    .product-description-card{
        display: -webkit-box;
        -webkit-box-orient: vertical;
        overflow: hidden;
        font-family: 'Inter';
        font-style: normal;
        font-weight: 400;
        font-size: 14.6058px;
        color: #787885;
        margin-bottom: 10px;
        -webkit-line-clamp: 7;
        line-clamp: 7;
    }
</style>
<div>
    <c:set var="items" scope="session" value="${itemList}"></c:set>
    <c:if test="${not empty param.resItemList}">
        <c:set var="items" scope="session" value="${resItemList}"></c:set>
    </c:if>
    <c:if test="${not empty param.showSellerItems}">
        <c:set var="items" scope="session" value="${sellerItems}"></c:set>
    </c:if>
    <c:if test="${not empty topThreeItemsBySales and not empty topThreeItemsByRating}">
        <c:if test="${not empty param.showSales}">
            <c:set var="items" scope="session" value="${topThreeItemsBySales}"></c:set>
        </c:if>
        <c:if test="${not empty param.showRatings}">
            <c:set var="items" scope="session" value="${topThreeItemsByRating}"></c:set>
        </c:if>
    </c:if>
    <%
        int category = 0;
        if (request.getParameter("categoryId") != null){
            String str = request.getParameter("categoryId").toString();
            category = Integer.parseInt(str);
        } 
    %>
        <c:set var="category" value="<%=category%>"></c:set>
        <c:set var="itemCount" scope="session" value="${items.size()}"></c:set>
        <c:if test="${not empty auth and role eq 'seller'}">
            <c:set var="seller_id"  value="${userDetail.getId()}"></c:set>
            <%
                List<Items> itemArr = (List<Items>) pageContext.findAttribute("items");
                Long seller_id = Long.parseLong(pageContext.findAttribute("seller_id").toString());
                List<Items> filteredItems = new ArrayList<Items>();
                for (Items item : itemArr){
                    if (item.getSeller_id() == seller_id){
                        filteredItems.add(item);
                    }
                }
                pageContext.setAttribute("items", filteredItems);
                pageContext.setAttribute("itemCount", filteredItems.size());
            %>
            <c:set var="items" scope="session" value="${pageContext.findAttribute('items')}"></c:set>
            <c:set var="itemCount" scope="session" value="${pageContext.findAttribute('itemCount')}"></c:set>
        </c:if>
        <div class="label-container">
            <span id="availableItemsLabel" style="font-family: 'Montserrat', sans-serif; font-weight: 700; margin: 20px 20px;">
                Available items (${items.size()})
            </span>
        </div>
        <div class="itemContainer">
            <c:if test="${fn:length(items) gt 0}">
                <c:if test="${category eq 0}">
                    <c:forEach items="${items}" var="item">
                        <div class="container">
                            <div class="row">
                                <div class="col-md-4" style="width: 100%">
                                    <a href="item.jsp?itemid=${item.getId()}">
                                        <div class="card product-card" id="item-id-${item.getId()}">
                                            <c:if test="${item.getDiscount_percentage() gt 0}">
                                                <div class="px-2 red text-uppercase"> ${item.getDiscount_percentage()}% off</div>
                                                </c:if>
                                        <c:if test="${not empty item.getItem_img()}">
                                            <div class="d-flex justify-content-center">
                                            <img src="${item.getItem_img()}" style="width:200px; height:200px; object-fit: contain;margin: 0 auto;" class="card-img-top" alt="Category Image">
                                            </div>
                                        </c:if>
                                        <c:if test="${empty item.getItem_img()}">
                                            <div class="d-flex justify-content-center">
                                            <img src="https://cdn5.vectorstock.com/i/1000x1000/80/64/mystery-box-icon-random-loot-box-flat-icon-vector-35858064.jpg" style="width:200px; height:200px; object-fit: contain;margin: 0 auto;" class="card-img-top" alt="Category Image">
                                            </div>
                                        </c:if>
                                            <div class="card-body">
                                                <p> ${item.getItem_name()} </p>
                                                <div class="d-flex align-items-center justify-content-start rating border-top border-bottom py-2">
                                                    <div class="text-muted text-uppercase px-2 border-right">
                                                        ${item.getSold_qty()} sold
                                                    </div>
                                                    <div class="px-lg-2 px-1">
                                                        Rating: ${item.getAvg_rating()}
                                                    </div>
                                                </div>
                                                <c:if test="${item.getDiscount_percentage() gt 0}">
                                                    <div class="d-flex align-items-center justify-content-start rating py-2">
                                                        <div class="text-muted text-uppercase px-2 border-right">
                                                            <p class="product-price">RM ${item.getDiscountedPrice(item)}</p>
                                                        </div>
                                                        <div class="px-lg-2 px-1">
                                                            <p class="product-price text-muted text-decoration-line-through">RM ${item.getPrice()}</p>
                                                        </div>
                                                    </div>
                                                </c:if>
                                                <c:if test="${item.getDiscount_percentage() eq 0}">
                                                    <p class="product-price">RM ${item.getPrice()}</p>
                                                </c:if>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>
                <c:if test="${category gt 0}">
                    <c:set var="currsize" value="0"></c:set>
                    <c:forEach items="${items}" var="item">
                        <c:if test="${item.getCategory() eq category}">
                                <c:set var="currsize" value="${currsize + 1}"></c:set>
                                <div class="container">
                                <div class="row">
                                    <div class="col-md-4" style="width: 100%">
                                        <a href="item.jsp?itemid=${item.getId()}">
                                            <div class="card product-card" id="item-id-${item.getId()}">
                                                <c:if test="${item.getDiscount_percentage() gt 0}">
                                                <div class="px-2 red text-uppercase"> ${item.getDiscount_percentage()}% off</div>
                                                </c:if>
                                            <c:if test="${not empty item.getItem_img()}">
                                                <div class="d-flex justify-content-center">
                                            <img src="${item.getItem_img()}" style="width:200px; height:200px; object-fit: contain;margin: 0 auto;" class="card-img-top" alt="Category Image">
                                            </div>
                                            </c:if>
                                            <c:if test="${empty item.getItem_img()}">
                                                <div class="d-flex justify-content-center">
                                            <img src="https://cdn5.vectorstock.com/i/1000x1000/80/64/mystery-box-icon-random-loot-box-flat-icon-vector-35858064.jpg" style="width:200px; height:200px; object-fit: contain;margin: 0 auto;" class="card-img-top" alt="Category Image">
                                            </div>
                                            </c:if>
                                                <div class="card-body">
                                                    <p> ${item.getItem_name()} </p>
                                                    <div class="d-flex align-items-center justify-content-start rating border-top border-bottom py-2">
                                                        <div class="text-muted text-uppercase px-2 border-right">
                                                            ${item.getSold_qty()} sold
                                                        </div>
                                                        <div class="px-lg-2 px-1">
                                                            Rating: ${item.getAvg_rating()}
                                                        </div>
                                                    </div>
                                                    <%-- <h5 class="card-title" style="align-items: center; text-align: center">${itemDisplay.getItem_name()}</h5> --%>
                                                    <c:if test="${item.getDiscount_percentage() gt 0}">
                                                    <div class="d-flex align-items-center justify-content-start rating py-2">
                                                        <div class="text-muted text-uppercase px-2 border-right">
                                                            <p class="product-price">RM ${item.getDiscountedPrice(item)}</p>
                                                        </div>
                                                        <div class="px-lg-2 px-1">
                                                            <p class="product-price text-muted text-decoration-line-through">RM ${item.getPrice()}</p>
                                                        </div>
                                                    </div>
                                                    </c:if>
                                                    <c:if test="${item.getDiscount_percentage() eq 0}">
                                                        <p class="product-price">RM ${item.getPrice()}</p>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                    <script>
                        $(document).ready(function() {
                            updateAvailableItemsLabel('${currsize}');
                        });
                    </script>
                </c:if>
            </c:if>
            <c:if test="${empty items or fn:length(items) eq 0}">
                <div>No items found.</div>
            </c:if>
        </div>
</div>
<script>
    function updateAvailableItemsLabel(currSize) {
      var label = document.getElementById('availableItemsLabel');
      label.innerHTML = 'Available items (' + currSize + ')';
    }
</script>
