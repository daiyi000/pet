<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Pet" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>首页</title>
    <link rel="stylesheet" type="text/css" href="css/user.css">
    <link rel="stylesheet" type="text/css" href="css/adopthome.css">
    <style>
        /* 模态框遮罩 */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0; top: 0;
            width: 100%; height: 100%;
            background-color: rgba(0,0,0,0.4);
        }
        .modal-content {
            background: #fff;
            margin: 15% auto;
            padding: 20px;
            width: 320px;
            border-radius: 5px;
            position: relative;
        }
        .close {
            position: absolute;
            right: 12px; top: 8px;
            font-size: 24px;
            cursor: pointer;
        }
        #foldersList {
            max-height: 240px;
            overflow-y: auto;
            margin-top: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .folder-item {
            padding: 10px;
            cursor: pointer;
            border-bottom: 1px solid #eee;
        }
        .folder-item:hover {
            background-color: #f5f5f5;
        }
        #cancelBtn {
            margin-top: 12px;
            padding: 8px 16px;
            background: #e0e0e0;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .pet-actions {
            display: flex;
            gap: 8px;
            margin-top: 10px;
        }
        .favorite-btn {
            background-color: #ff9800;
            color: #fff;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.2s;
        }
        .favorite-btn:hover {
            background-color: #f57c00;
        }
    </style>
</head>
<body>
    <header>
        <nav>
            <div id="logo">
                <a href="user_home.jsp">
                    <img src="image/logo1.png" alt="Logo" style="width:350px;">
                </a>
            </div>
            <ul id="nav">
                <li><a href="PetServlet?action=adopthome">首页</a></li>
                <li><a href="PetServlet?action=viewMyPets">我的宠物</a></li>
                <li><a href="pet_add.jsp">上传宠物信息</a></li>
                <li><a href="FavoriteServlet?action=viewFolders">我的收藏</a></li>
                <li><a href="#">公告</a></li>
                <li><a href="edit_profile.jsp">个人信息</a></li>
                <li><a href="UserServlet?action=logout">登出</a></li>
            </ul>
        </nav>
    </header>

    <%-- 提示信息 --%>
    <%
        String message = (String) request.getAttribute("message");
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (message != null) {
    %>
    <script>alert("<%= message %>");</script>
    <% } else if (errorMessage != null) { %>
    <script>alert("<%= errorMessage %>");</script>
    <% } %>

    <main>
        <h1>宠物信息</h1>
        <div class="pet-container">
            <%
                List<Pet> approvedPets = (List<Pet>) request.getAttribute("approvedPets");
                if (approvedPets != null && !approvedPets.isEmpty()) {
                    for (Pet pet : approvedPets) {
            %>
            <div class="pet-card">
                <% if (pet.getImage_url() != null && !pet.getImage_url().isEmpty()) { %>
                    <img src="<%= pet.getImage_url().split(",")[0] %>" 
                         alt="<%= pet.getName() %>">
                <% } %>
                <div class="pet-info">
                    <div class="pet-name"><%= pet.getName() %></div>
                    <div class="pet-meta">
                        <span class="pet-type"><%= pet.getType() %></span>
                        <span class="pet-age"><%= pet.getAge() %>岁</span>
                    </div>
                    <div class="pet-actions">
                        <a href="PetServlet?action=view&id=<%= pet.getId() %>" class="view-btn">
                            查看详情
                        </a>
                        <button class="favorite-btn" 
                                data-pet-id="<%= pet.getId() %>">
                            收藏
                        </button>
                    </div>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <p class="no-pets">目前没有符合条件的宠物。</p>
            <% } %>
        </div>

        <%-- 分页 --%>
        <div class="pagination">
            <%
                int currentPage = (Integer) request.getAttribute("currentPage");
                int totalPages  = (Integer) request.getAttribute("totalPages");
            %>
            <a href="PetServlet?action=getApprovedPets&page=<%= currentPage - 1 %>" 
               <%= currentPage == 1 ? "class='disabled'" : "" %>>
                上一页
            </a>
            <% for (int i = 1; i <= totalPages; i++) { %>
                <a href="PetServlet?action=getApprovedPets&page=<%= i %>" 
                   <%= i == currentPage ? "class='active'" : "" %>><%= i %></a>
            <% } %>
            <a href="PetServlet?action=getApprovedPets&page=<%= currentPage + 1 %>" 
               <%= currentPage == totalPages ? "class='disabled'" : "" %>>
                下一页
            </a>
        </div>
    </main>

    <%-- 收藏模态框 --%>
    <div id="favoriteModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h3>选择收藏夹</h3>
            <div id="foldersList"></div>
            <button id="cancelBtn">取消</button>
        </div>
    </div>

    <footer>
        <p>© 2024 宠物之家管理系统 | 所有权利保留</p>
    </footer>

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const modal = document.getElementById('favoriteModal');
        const closeEl = modal.querySelector('.close');
        const cancelBtn = document.getElementById('cancelBtn');
        let currentPetId = null;

        // 打开模态框，获取收藏夹
        document.querySelectorAll('.favorite-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                currentPetId = this.dataset.petId;
                console.log('当前 petId:', currentPetId);
                fetch('FavoriteServlet?action=getFolders')
                    .then(res => {
                        if (!res.ok) throw new Error('网络响应异常');
                        return res.json();
                    })
                    .then(folders => {
                        if (!folders || folders.length === 0) {
                            alert('请先创建收藏夹');
                            window.location.href = 'FavoriteServlet?action=viewFolders';
                            return;
                        }
                        renderFolders(folders);
                        modal.style.display = 'block';
                    })
                    .catch(err => {
                        console.error('获取收藏夹失败：', err);
                        alert('无法加载收藏夹');
                    });
            });
        });

        // 渲染文件夹列表并绑定点击事件
        function renderFolders(folders) {
            const container = document.getElementById('foldersList');
            container.innerHTML = folders.map(f =>
                `<div class="folder-item" data-folder-id="${f.id}">${f.folderName}</div>`
            ).join('');
            container.querySelectorAll('.folder-item').forEach(item => {
                item.addEventListener('click', function() {
                    const folderId = this.dataset.folderId;
                    console.log('点击 folderId:', folderId);
                    // 点击后调用 submitFavorite
                    submitFavorite(folderId, currentPetId);
                });
            });
        }

     // 修改submitFavorite函数
        function submitFavorite(folderId, petId) {
            // 创建FormData对象（更可靠的方式）
            const formData = new FormData();
            formData.append('action', 'addToFavorite');
            formData.append('folderId', folderId);
            formData.append('petId', petId);

            // 发送请求
            fetch('FavoriteServlet', {
                method: 'POST',
                body: new URLSearchParams(formData), // 自动处理编码
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            })
            .then(response => {
                console.log('响应状态:', response.status);
                return response.json();
            })
            .then(data => {
                console.log('响应数据:', JSON.stringify(data));
                alert(data.message);
                modal.style.display = 'none';
            })
            .catch(error => {
                console.error('完整错误信息:', error);
                alert('操作失败: ' + error.message);
            });
        }

        // 关闭模态框
        closeEl.addEventListener('click', () => modal.style.display = 'none');
        cancelBtn.addEventListener('click', () => modal.style.display = 'none');
        window.addEventListener('click', e => {
            if (e.target === modal) modal.style.display = 'none';
        });
    });
    </script>
</body>
</html>
