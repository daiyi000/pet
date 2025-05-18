<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Pet" %>
<%@ page import="model.FavoriteFolder" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>收藏夹内容</title>
    <link rel="stylesheet" type="text/css" href="css/user.css">
    <link rel="stylesheet" type="text/css" href="css/favorite.css">
</head>
<body>
    <header>
        <!-- 导航栏 -->
        <nav>
            <div id="logo">
                <a href="user_home.jsp">
                    <img src="image/logo1.png" alt="Logo" style="width: 350px; height: auto;">
                </a>
            </div>
            <ul id="nav">
                <li><a href="PetServlet?action=adopthome">首页</a></li>  
                <li><a href="PetServlet?action=viewMyPets">我的宠物</a></li>
                <li><a href="pet_add.jsp">上传宠物信息</a></li>
                <li><a href="#">公告</a></li>
                <li><a href="FavoriteServlet?action=viewFolders">我的收藏</a></li>
                <li><a href="edit_profile.jsp">个人信息</a></li>
                <li><a href="UserServlet?action=logout">登出</a></li>
            </ul>
        </nav>
    </header>

    <main>
        <div class="folder-header">
            <h1><%= ((FavoriteFolder)request.getAttribute("folder")).getFolderName() %></h1>
            <a href="FavoriteServlet?action=viewFolders" class="back-btn">返回收藏夹列表</a>
        </div>

        <div class="pet-container">
            <% 
                List<Pet> pets = (List<Pet>) request.getAttribute("pets");
                if (pets != null && !pets.isEmpty()) {
                    for (Pet pet : pets) {
            %>
                <div class="pet-card">
                    <% if (pet.getImage_url() != null && !pet.getImage_url().isEmpty()) { %>
                        <img src="<%= pet.getImage_url().split(",")[0] %>" alt="<%= pet.getName() %>">
                    <% } %>
                    <div class="pet-name"><%= pet.getName() %></div>
                    <div class="pet-type"><%= pet.getType() %></div>
                    <div class="pet-age"><%= pet.getAge() %>岁</div>
                    <a href="PetServlet?action=view&id=<%= pet.getId() %>" class="view-btn">查看详情</a>
                </div>
            <% 
                    }
                } else {
            %>
                <p>该收藏夹暂无收藏的宠物</p>
            <% 
                }
            %>
        </div>
    </main>
</body>
</html>