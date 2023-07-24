package;

class BGCharacter extends flixel.FlxSprite
{
	private var type:String;
    private var types = ['algo', 'platforms', 'shorts'];

	public function new() 
    {
		super(0, 0);

        type = types[flixel.FlxG.random.int(0, 2)];

		frames = Paths.getSparrowAtlas('bg_characters', 'shared');

        animation.addByPrefix('algo', 'algo', 24);
        animation.addByPrefix('platforms', 'platforms', 24);
        animation.addByPrefix('shorts', 'shorts', 24);

        centerOffsets();  
        
        getProperties();
	}

    private function getProperties():Void
    {
        //this is so it doesnt play the same character
        var curType = type; // save it
        types.remove(curType); //remove it from the list
        type = types[flixel.FlxG.random.int(0, types.length - 1)]; //get a new sprite
        types.push(curType); //then add it again

        flipX = flixel.FlxG.random.bool();

        switch (type)
        {
            case 'algo':
                y = 450;
                scrollFactor.set(0.6, 0.9);
                velocity.x = 100;
            case 'platforms':
                y = 250;
                scrollFactor.set(0.75, 0.9);
                velocity.x = 120;
            case 'shorts':
                y = 170;
                scrollFactor.set(0.5, 0.9);
                velocity.x = 350;
        }

        x = (flipX ? MAX_X : MIN_X);
        animation.play(type);
        velocity.x *= (flipX ? -1 : 1);
    }

    private var MIN_X = -750;
    private var MAX_X = 1700;

	override public function update(elapsed:Float)
    {
        try
        {
        if (x < MIN_X || x > MAX_X)
            getProperties();
        }
        catch (e)
        {
            trace('Error bitch: ${e.message}');
        }

        flixel.FlxG.watch.addQuick('BG Characters Pos:', getPosition());

        super.update(elapsed);
    }
}