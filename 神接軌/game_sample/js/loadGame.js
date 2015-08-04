//立即執行函式, 並封裝所有變數避免衝突
(function(){
    //動態依序載入JS
    //ref: http://blog.darkthread.net/blogs/darkthreadtw/archive/2009/01/15/4061.aspx
    var  importJS = function(jsConf, src, lookFor) {
        var headID = document.getElementsByTagName("head")[0]; 
        var newJs = document.createElement('script');
        newJs.type = 'text/javascript';
        newJs.src= jsConf[0].src; // "?" + Math.random();
        headID.appendChild(newJs);
        newJs.onload = function(){
            jsConf.splice(0, 1);
            if(jsConf.length > 0) {
                importJS(jsConf);
            }
        }
    }
    //陣列和載入JS檔的順序相同, lookFor為在要載入的檔案中, 
    //有用到的全域變數, importJS這個function, 會在找到lookFor的變數後
    //才會繼續loading下一個檔案, 如果沒有需要lookFor, 則以空字串代表
    var listScript = 
    [
    	{ src: 'game_sample/js/jquery.js' },
        { src: 'game_sample/js/define.js', lookFor: 'define' },
        { src: 'game_sample/js/html5_game.1.2.js', lookFor: 'Framework' },
		{ src: "game_sample/javascript/login.js", lookFor: 'Login'},
        { src: "game_sample/javascript/create_role.js"},
		{ src: "game_sample/javascript/base.js"},
		{ src: "game_sample/javascript/collection.js"},
		{ src: "game_sample/javascript/function.js"},
        { src: "game_sample/javascript/window/windowsManager.js"},
        { src: "game_sample/javascript/chat.js"},
        { src: "game_sample/javascript/keyManager.js"},
		{ src: "game_sample/javascript/game.js", lookFor: 'MyGame'},
		{ src: "game_sample/javascript/astar.js"},
        { src: "game_sample/javascript/animate.js"},
        { src: "game_sample/javascript/monster.js"},
        { src: "game_sample/javascript/sprite.js"},
        { src: "game_sample/javascript/sprite/job.js"},
        { src: "game_sample/javascript/sprite/monster.js"},
        { src: "game_sample/javascript/sprite/head.js"},
        { src: "game_sample/javascript/sprite/npc.js"},
        { src: "game_sample/javascript/map.js"},
        { src: "game_sample/javascript/item/ItemManager.js"},
        { src: "game_sample/javascript/window/baseWindow.js"},
		{ src: "game_sample/javascript/window/windows.js"},
        { src: "game_sample/javascript/window/object.js"},
        { src: "game_sample/javascript/mission/missionManager.js"},
		{ src: "game_sample/javascript/mission/quest.js"},
		{ src: "game_sample/javascript/mission/gather.js"},
		{ src: "game_sample/javascript/mission/tracing.js"},
		{ src: "game_sample/javascript/mission/mission.js"},
		{ src: "game_sample/javascript/role.js"},
		{ src: "game_sample/javascript/npc.js"},
		{ src: "game_sample/javascript/props.js"},
		{ src: "game_sample/javascript/props_list.js"},
		{ src: "game_sample/javascript/map/prontera.js"},
        { src: "game_sample/javascript/map/rock.js"},
        { src: "game_sample/javascript/skill.js"},
        { src: "game_sample/javascript/status.js"},
        { src: "game_sample/javascript/effect.js"},
        { src: "game_sample/javascript/npc_list.js"},
        { src: "game_sample/javascript/text.js"},
        { src: 'game_sample/js/mainGame.js'},
        { src: "game_sample/javascript/socket.js"},
    ]

    importJS(listScript);

})();