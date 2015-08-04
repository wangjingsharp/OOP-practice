//當有要加關卡時, 可以使用addNewLevel
//第一個被加進來的Level就是啟動點, 所以一開始遊戲就進入MyMenu
if (window.isOnline == 1)
	Framework.Game.addNewLevel({menu: window.login});
Framework.Game.addNewLevel({level1: window.game});
Framework.Game.addNewLevel({signUp: window.createRole});

//讓Game開始運行
Framework.Game.start();