<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Click Rank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
    <style>
        :root {
            color-scheme: only dark;
        }

        .bar-container {
            width: 100%;
            max-width: 600px;
            margin: 0 auto;
        }

        .bar {
            height: 30px;
            background-color: #007bff;
            border-radius: 8px;
            color: white;
            text-align: right;
            padding-right: 10px;
            line-height: 30px;
            margin-bottom: 5px;
            position: relative;
            max-width: 100%; /* 確保橫條圖永遠不會超出容器 */
        }

        .bar-label {
            position: absolute;
            left: 0;
            padding-left: 10px;
            white-space: nowrap;
        }

        .highlight {
            background: radial-gradient(circle farthest-corner at left, #007bff, #5e008a) !important;
        }
    </style>
</head>

<body>
    <div class="container mt-5">
        <h1 class="text-center">點擊排行榜</h1>
        <div class="row">
            <!-- 畫面1: 請輸入你的名字 -->
            <div id="view1" class="col-md-6 offset-md-3">
                <div class="card">
                    <div class="card-body text-center">
                        <form>
                            <input type="text" id="username" class="form-control mb-3" placeholder="請輸入你的名字">
                            <button id="start-button" type="button" class="btn btn-primary">開始</button>
                        </form>
                    </div>
                </div>
            </div>
            <!-- 畫面2: 排行榜 -->
            <div id="view2" class="col-md-6 offset-md-3" style="display: none;">
                <div class="card">
                    <div class="card-body text-center">
                        <h2 id="click-count" class="mt-3">0</h2>
                        <button id="click-button" type="button" class="btn btn-primary">點擊我!</button>
                    </div>
                </div>
                <div class="mt-4">
                    <h3 class="text-center">排行榜</h3>
                    <div id="leaderboard" class="bar-container">
                        <!-- 動態的 bar 將被注入到這 -->
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const view1 = document.getElementById('view1');
            const view2 = document.getElementById('view2');
            const startButton = document.getElementById('start-button');
            const clickButton = document.getElementById('click-button');
            const clickCount = document.getElementById('click-count');
            const usernameInput = document.getElementById('username');
            const leaderboard = document.getElementById('leaderboard');

            let count = 0;
            let username = '';
            let leaderboardData = [
                { user: 'User1', clicks: 10 },
                { user: 'User2', clicks: 5 },
                { user: 'User3', clicks: 2 }
            ];

            startButton.addEventListener('click', function () {
                username = usernameInput.value.trim();
                if (username) {
                    view1.style.display = 'none';
                    view2.style.display = '';
                } else {
                    alert('請輸入你的名字');
                }
            });

            clickButton.addEventListener('click', function () {
                count++;
                clickCount.textContent = count;

                // 更新排行榜數據
                updateLeaderboard(username, count);
            });

            function updateLeaderboard(user, clicks) {
                if (!user) {
                    return;
                }
                // 更新參賽者點擊次數
                const userIndex = leaderboardData.findIndex(item => item.user === user);
                if (userIndex !== -1) {
                    leaderboardData[userIndex].clicks = clicks;
                } else {
                    leaderboardData.push({ user, clicks });
                }

                // 依照點擊次數排序
                leaderboardData.sort((a, b) => b.clicks - a.clicks);

                // 取得最大點擊次數
                const maxClicks = leaderboardData[0].clicks;

                // 使用DocumentFragment减少DOM操作
                const fragment = document.createDocumentFragment();
                leaderboardData.forEach(item => {
                    const barContainer = document.createElement('div');
                    barContainer.className = 'mb-2';

                    const bar = document.createElement('div');
                    bar.className = 'bar';
                    bar.style.width = `${(item.clicks / maxClicks) * 100}%`;

                    if (item.user === user) {
                        bar.classList.add('highlight');
                    }

                    const barLabel = document.createElement('span');
                    barLabel.className = 'bar-label';
                    barLabel.textContent = `${item.user} (${item.clicks})`;

                    bar.appendChild(barLabel);
                    barContainer.appendChild(bar);
                    fragment.appendChild(barContainer);
                });

                // 清空並重新渲染排行榜
                leaderboard.innerHTML = '';
                leaderboard.appendChild(fragment);
            }

            // 初始化排行榜
            updateLeaderboard();
        });
    </script>
</body>
</html>