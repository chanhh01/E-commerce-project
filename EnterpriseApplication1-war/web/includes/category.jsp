<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 28/4/2023
  Time: 2:05 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.util.Base64" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>  
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="category-container">
    <c:if test="${not empty categoryList and categoryList.size() > 0}">
        <c:forEach items="${categoryList}" var="category">
            <div class="container">
                <div class="row">
                    <div class="col-md-4" style="width: 100%">
                        <a href="searchItemList.jsp?categoryId=${category.getId()}">
                            <div class="category-container-box" id=<c:out value="category-id-${category.getId()}"/>>
                            <c:if test="${not empty category.getImage()}">
                                <img src="${category.getImage()}" style="width:80px; height:80px; object-fit: contain;margin: 0 auto;" class="card-img-top" alt="Category Image">
                            </c:if>
                            <c:if test="${empty category.getImage()}">
                                <img src="https://cdn5.vectorstock.com/i/1000x1000/80/64/mystery-box-icon-random-loot-box-flat-icon-vector-35858064.jpg" style="width:80px; height:80px; object-fit: contain;margin: 0 auto;" class="card-img-top" alt="Category Image">
                            </c:if>
                            <p>${category.getName()}</p>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </c:if>
    <c:if test="${empty categoryList or categoryList.size() eq 0}">
        <div>There are no categories available.</div>
    </c:if>
</div>
<style>
    .category-container{
        display: grid;
        grid-template-columns: repeat(10,1fr);
        grid-row-gap: 8px;
        grid-column-gap: -10px;
    }
    
    .row{
        margin: 0 auto;
    }

    .category-container-box{
        width: fit-content;
        padding: 10px 20px;
        border: 1px solid #e0e0e0;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        border-radius: 5px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
    }

    .category-container-box p {
        font-weight: bold;
        font-size: 12px;
        color: #333;
        margin: 0.5rem 0;
    }
</style>