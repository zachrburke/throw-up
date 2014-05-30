Lua was intended to be used as an embedded language.  It's gotten a lot of use in games like [garry's mod](http://www.garrysmod.com/) and in the World of Warcraft in [add-on api](http://www.wowwiki.com/Lua).  For the sake of demonstration I wrote a small game in .NET using MonoGame that allows you to manipulate certain aspects of the game through lua code.  The game itself is a very simple simulation of gravity being applied to a ball tossed into the air.

![Screenshot 1](/content/images/screenshots/ball-screen1.gif)

The above screenshot is how the game would look without writing any lua.  The game exposes a lua api that allows you to modify behaviour in the simulation by writing lua code.  With the appropriate lua script, we can get the following:

![Screenshot 2](/content/images/screenshots/ball-screen2.gif)

This is a achieved with the following lua code

    local color = { r = 0, g = 100, b = 100 }
    local trajectory = { x = 0, y = 0 }

    function incrementor(start, inc)
        local value = start

        return function()
            value = value + inc
            return value
        end
    end

    local theta = incrementor(0, 0.50)

    function Run (ticks)
        ChangeTrajectory(trajectory.x, trajectory.y)
        trajectory.y = math.sin(theta())
    end

    SetClearColor(color.r, color.g, color.b)
    SetBallColor(255, 255, 255)

The methods SetClearColor, SetBallColor and ChangeTrajectory are actually implemented in .NET and are being called in lua.  The Run() method is being kept after running the lua script then called every frame.  I am using a .NET library called [DynamicLua](https://github.com/nrother/dynamiclua) to achieve this, However I would recommend looking into [NLua](https://github.com/NLua/NLua) for more involved projects.  Here is the code used to actually embed the lua script shown above. 

    public ClientAPI(string scriptPath)
    {
        ClearColor = Color.SkyBlue;
        BallColor = Color.White;
        Trajectory = Vector2.Zero;

        _lua = new DynamicLua.DynamicLua();
        _lua.SetBallColor = new Action<double, double, double>(SetBallColor);
        _lua.SetClearColor = new Action<double, double, double>(SetClearcolor);
        _lua.ChangeTrajectory = new Action<double, double>(ChangeTrajectory);

        _lua.DoFile(scriptPath);
    }

    private void SetBallColor(double red, double green, double blue)
    {
        BallColor = new Color((int)red, (int)green, (int)blue);
    }

    private void SetClearcolor(double red, double green, double blue)
    {
        ClearColor = new Color((int)red, (int)green, (int)blue);
    }

    private void ChangeTrajectory(double x, double y)
    {
        Trajectory = new Vector2((float) x, (float) y);
    }

    public void Run(double ticks)
    {
        if (_lua.Run != null)
            _lua.Run(ticks);
    }

DynamicLua provides a dynamic object that you can assign methods to.  Doing this will expose those methods in your lua context, so when DoFile is run, those functions will be available to the script passed to that method.  Any methods or variables stored globally in the lua script are also stored in the dynamic after the file has been ran.  This makes it possible to run methods that are implemented in lua, like the Run method.

You can view the full source on github [here](https://github.com/zach-binary/aluminumball)