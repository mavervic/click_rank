# Click Rand

Click Rand 是一個透過內部網路進行滑鼠點擊速率的小遊戲，並支援了多人競賽

這款遊戲的特點或使用技術有:

* Redis
    * 排名的方式是使用 redis 的 sorted sets 來達成
* Java
    * 使用 WebSocket 連線技術
    * 使用 `JSP` 作為前端渲染模板
    * 僅有使用原生 JavaScript API
    * CSS 使用了 Bootstrap 5 來簡化開發

# Click Rand

Click Rand is a small game that measures mouse click speed over an internal network and supports multiplayer competition.

## Features and Technologies

* **Redis**
    * The ranking is achieved using Redis sorted sets.
* **Java**
    * Uses WebSocket for real-time communication.
    * Uses `JSP` as the front-end rendering template.
    * Only uses native JavaScript API.
    * CSS is simplified using Bootstrap 5.