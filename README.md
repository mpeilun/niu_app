<img style="width:64px" src="https://user-images.githubusercontent.com/13403218/228755470-34ae31ec-eb1a-4c1c-9461-bdbaa04d9fef.png" />

# Niu App
> flutter version:3.3 Application For National Ilan University  

這是一個給宜大學生使用的APP，整合了大部分常使用到的功能， 包含數位學習園區、分數查詢、課表、活動報名、畢業門檻查詢、選課 並提供公動態查詢和Zuvio點名。


## 目錄
- [安裝](https://github.com/mpeilun/niu_app#安裝)
  - [Android Studio](https://github.com/mpeilun/niu_app#Android-studio)
  - [Android APK](https://github.com/mpeilun/niu_app#android-apk)
- [使用方式](https://github.com/mpeilun/niu_app#使用方式)
- [宜大學生 APP 開發前調查](https://github.com/mpeilun/niu_app#宜大學生-APP-開發前調查)
  - [調查結果](https://github.com/mpeilun/niu_app#調查結果)
    - [各平台網頁在手機上的體驗度](https://github.com/mpeilun/niu_app#各平台網頁在手機上的體驗度)
    - [使用宜大學生 APP 意願度調查](https://github.com/mpeilun/niu_app#使用宜大學生-APP-意願度調查)
- [功能](https://github.com/mpeilun/niu_app#功能)
- [問題](https://github.com/mpeilun/niu_app#問題)


## 安裝
### Android Studio
1. 安裝 [Flutter SDK](https://flutter.dev/docs/get-started/install)
2. 使用以下指令將 repo clone 到本地：
3. `git clone https://github.com/your_username/flutter-app.git`  
4. `flutter pub get`
5. `flutter run`

### Android APK
[- Release 安裝下載](https://github.com/mpeilun/niu_app/releases/tag/Android)

## 使用方式
1. 下載並安裝應用程式
2. 打開應用程式
3. 輸入宜蘭大學的帳號和密碼登錄
4. 在應用程式瀏覽不同的功能
> 請注意，必須先擁有宜蘭大學的帳號和密碼才能登錄此應用程序

## 宜大學生 APP 開發前調查
在開發這個「宜大學生 APP」之前，我們進行了問卷調查，  
收集到78份有效問卷，以了解學生對於手機瀏覽學校網頁的體驗和需求。  
調查內容主要針對**教務行政系統、數位學習園區和校園活動報名系統**三個主要網站，並且包含了以下內容：  

- 各平台網頁在手機上的體驗度
- 各平台之常用功能與使用率
- 使用宜大學生 APP 意願度調查

### 調查結果
1. #### 各平台網頁在手機上的體驗度
<img src="https://user-images.githubusercontent.com/86880683/226528526-bfdea917-42bb-4b10-aeed-1061edc2cf0a.png" width="640">

調查發現活動報名系統的體驗度最差，  
非常不方便和不方便的比例總和佔 **74.7%**。  
因此，我們完整地在手機 App 中實作了獨立的介面，  
完全取代了此網頁的功能，徹底解決學生的困擾。  

2. #### 各平台常見的功能及使用率
<img src="https://user-images.githubusercontent.com/86880683/227753722-678d1318-10ff-4b9a-b897-4b2360515292.png">

統計學生在教務行政系統中常用的功能，此系統包含學校所有行政手續會使用到的功能，  
由於功能種類繁多且系統複雜，因此只針對學生最常用的功能，如選課、成績查詢、畢業門檻等，開發手機介面以及網頁互動。

3. #### 使用宜大學生 APP 意願度調查
<img src="https://user-images.githubusercontent.com/86880683/227756860-3d96dc5a-1dc8-404e-9ac9-b36c70f17f66.png" width="300">

在問卷調查的最後，我們放上宜大學生 APP 的操作畫面，詢問學生的使用意願，  
從學生的回饋中，可知學生非常需要這樣的 APP，且期待實際上架後使用的感受。
所以我們開發了以下這些功能

## 功能
| 功能列表 | 功能概述                                          |
| -------- | ------------------------------------------------ |
| **數位學習園區** | 觀看上課教材、繳交作業                          |
| **成績查詢系統** | 查詢期中、學期成績以及期中預警                  |
| **當學期課表**   | 標示上課地點、時間、授課老師                    |
| **活動報名**     | 報名宜大活動必備功能                           |
| **校園公告**     | 查看校園公告                                   |
| **學校行事曆**   | 查看學校行事曆                                 |
| **畢業門檻**     | 詳細查詢畢業所需門檻                           |
| **選課系統**     | 在選課期間跳轉學校選課頁面                      |
| **Zuvio**       | 刪減原 APP 不常用功能，僅保留作業、簽到等常用功能 |
| **使用說明**     | 提供宜大 APP 使用說明                          |
| **公車查詢**     | 查詢公車即時動態資訊                           |
| **深色模式**     | 切換不同主題                                   |

<table>
  <tr>
    <th colspan="3"> 
        使用範例
    </th>
  </tr>
  <tr>
    <td colspan="3">
      <img src="https://user-images.githubusercontent.com/86880683/227759916-6b40d00c-698d-4945-b3d8-8f54d54cdf1b.gif" width="800">
    </td>
  </tr>
  <tr>
    <th> 
        登入頁面
    </th>
    <th> 
        行事曆表
    </th>
    <th> 
        公告系統
    </th>
  </tr>
  <tr>
    <td colspan="3">
      <img src="https://user-images.githubusercontent.com/86880683/227759925-5050a2f2-f5ba-4b8d-959a-671b01176cab.gif" width="800">    
    </td>
  </tr>
   <tr>
    <th> 
        畢業門檻
    </th>
    <th> 
        活動報名
    </th>
    <th> 
        成績查詢
    </th>
  </tr>
  <tr>
    <td colspan="3">
      <img src="https://user-images.githubusercontent.com/86880683/227759947-42506615-2781-442f-88ef-8c3e016dbcfc.gif" width="800">    
    </td>
  </tr>
   <tr>
    <th> 
        Zuvio
    </th>
    <th> 
        公車動態
    </th>
    <th> 
        課表查詢
    </th>
  </tr>
  <tr>
    <td colspan="3">
      <img src="https://user-images.githubusercontent.com/86880683/227760348-2283d79d-c226-4bd3-b644-e2b8c982da6d.gif" width="800">    
    </td>
  </tr>
   <tr>
    <th> 
        數位園區
    </th>
    <th> 
        使用說明
    </th>
    <th> 
        深色模式
    </th>
  </tr>
</table>

## 問題
1. 學校官網改版公告已失效
2. 數位園區即將廢棄改用數位園區M
