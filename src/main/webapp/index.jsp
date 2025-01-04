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
            border: 1px solid white;
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

            const socket = new WebSocket('ws://localhost:8080/click_rank/click');

            socket.onmessage = function (event) {
                const data = JSON.parse(event.data);
                updateLeaderboard(data);
            };

            startButton.addEventListener('click', function () {
                username = usernameInput.value.trim();
                if (username) {
                    view1.style.display = 'none';
                    view2.style.display = '';
                    socket.send(username + ':' + count);
                } else {
                    alert('請輸入你的名字');
                }
            });

            clickButton.addEventListener('click', function () {
                count++;
                clickCount.textContent = count;

                // Send click info to WebSocket server
                socket.send(username + ':' + count);
            });

            function updateLeaderboard(data) {
                const fragment = document.createDocumentFragment();
                // 取得最大點擊次數
                const maxClicks = data[0].score;
                data.forEach((item, index) => {
                    const barContainer = document.createElement('div');
                    barContainer.className = 'mb-2';

                    const bar = document.createElement('div');
                    bar.className = 'bar';
                    bar.style.width = `\${(item.score / maxClicks) * 100}%`;

                    if (item.username === username) {
                        bar.classList.add('highlight');
                    }

                    const barLabel = document.createElement('span');
                    barLabel.className = 'bar-label';
                    barLabel.textContent = `\${item.username} (\${item.score})`;

                    bar.appendChild(barLabel);
                    barContainer.appendChild(bar);
                    fragment.appendChild(barContainer);
                });

                // 清空並重新渲染排行榜
                leaderboard.innerHTML = '';
                leaderboard.appendChild(fragment);
            }
        });
    </script>
</body>
</html>