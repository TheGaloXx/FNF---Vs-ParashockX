class OutroState extends MusicBeatState
{
    override public function create()
    {
        var bg = new flixel.FlxSprite().loadGraphic(Paths.image('outro', 'shared'));
        bg.screenCenter();
        bg.active = false;
        bg.scrollFactor.set();
        add(bg);

        var warnText = new flixel.text.FlxText(0, 0, flixel.FlxG.width,
			"Thanks for playing!\n\nMod made by TheGalo X\n\n\n\nSpecial thanks:\n\nRelgaoh\nHelped me with the music\n\nAndyDavinci\nMade the chromatic scales\n\n\n\nlove u Para",
			32);
        warnText.autoSize = false;
		warnText.setFormat("VCR OSD Mono", 40, flixel.util.FlxColor.WHITE, CENTER, OUTLINE, flixel.util.FlxColor.BLACK);
		warnText.screenCenter(Y);
        warnText.borderSize = 4;
		add(warnText);

        flixel.FlxG.sound.music.onComplete = function()
        {
            flixel.FlxG.sound.playMusic(Paths.music('freakyMenu'));
            MusicBeatState.switchState(new MainMenuState());
        }

        super.create();
    }
}