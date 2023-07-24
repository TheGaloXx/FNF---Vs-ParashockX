package;

import flixel.FlxG;

class GameOverSubstate extends MusicBeatSubstate
{
	private var dislike = new flixel.FlxSprite();
	public static var instance:GameOverSubstate;
	private var canStartDying:Bool = false; //lmao

	override function create()
	{
		instance = this;
		PlayState.instance.callOnLuas('onGameOverStart', []);

		super.create();
	}

	public function new(x:Float, y:Float, camX:Float, camY:Float)
	{
		super();

		PlayState.instance.setOnLuas('inGameOver', true);

		Conductor.songPosition = 0;

		//FlxG.camera.setPosition();
		dislike.frames = Paths.getSparrowAtlas('characters/gameOver', 'shared');
		dislike.animation.addByPrefix('idle', 'gameOver', 4);
		dislike.animation.play('idle');
		dislike.screenCenter();
		dislike.x += 200;
		dislike.y += 200;
		add(dislike);

		Conductor.changeBPM(100);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx'));
		new flixel.util.FlxTimer().start(0.6, function(_)
		{
			FlxG.sound.play(Paths.sound('bullshit'));
			new flixel.util.FlxTimer().start(1, function(_) coolStartDeath());
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		PlayState.instance.callOnLuas('onUpdate', [elapsed]);

		if (canStartDying)
		{
			if (controls.ACCEPT)
				endBullshit();
	
			if (controls.BACK)
			{
				FlxG.sound.music.stop();
				PlayState.deathCounter = 0;
				PlayState.seenCutscene = false;
				PlayState.chartingMode = false;
	
				WeekData.loadTheFirstEnabledMod();
					MusicBeatState.switchState(new MainMenuState());
	
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				PlayState.instance.callOnLuas('onGameOverConfirm', [false]);
			}
		}

		if (FlxG.sound.music.playing)
			Conductor.songPosition = FlxG.sound.music.time;

		PlayState.instance.callOnLuas('onUpdatePost', [elapsed]);
	}

	override function beatHit()
	{
		super.beatHit();

		//FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function coolStartDeath(?volume:Float = 1):Void
	{
		FlxG.sound.playMusic(Paths.music('gameOver'), volume);
		canStartDying = true;
	}

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			dislike.destroy();
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd'));
			new flixel.util.FlxTimer().start(0.7, function(_)
			{
				FlxG.camera.fade(flixel.util.FlxColor.BLACK, 2, false, function()
				{
					MusicBeatState.resetState();
				});
			});
			PlayState.instance.callOnLuas('onGameOverConfirm', [true]);
		}
	}
}
