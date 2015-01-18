JUMP-LOVE
---------

A Minimalistic 2D Jumping Platformer
A Clone of [Matt Thorson's](http://www.mattmakesgames.com/) Jumper in Lua for the LÖVE Framework.

Currently A Work In Progress, so please don't be harsh.

You can send *constructive* critisism to dansecure1 (AT) gmail (DOT) com

Currently Runs on Windows, Mac OS X (untested), Linux, Android and the GCW-Zero


BUILDING (On Linux):
--------------------
git clone https://github.com/jedi453/JUMP-LOVE.git
cd JUMP-LOVE
mkdir .builds
/# Make the Love File:
make
/# Make OPK for GCW-Zero
make opk

REDISTRIBUTION:
---------------
See LICENSE Section Below, but also note that all LICENSE Files Should be Included


CONTROLS:
---------
####On Startup, a Menu Will Be Presented:
  * Press Left/Right to Go Back/Forward a Level
  * You May Only View/Select Levels You've Earned
  * Press JUMP Key to Start the Level
####On the Desktop:
  * Use Left/Right Arrow Keys on Keyboard to M
  * Up Key to JUMP
  * Press Escape to Quit When in the Menu, or to Return to the Menu from a Level
####On the Desktop With a Controller:
  * See GCW-Zero Below:
####On the GCW-Zero:
  * Use DPad to Move Left/Right
  * Press 'Y' to JUMP
  * Press Select to Quit When in the Menu, or to Return to the Menu from a Level
####On Android:
  * Onscreen Buttons Will Pop Up and Be labeled
  * Press The Back Button to Quit When in the Menu, or to Return to the Menu from a Level



Uses these Open Source Projects:
--------------------------------
* [LÖVE](https://love2d.org/) - An *Awesome* 2D Game Framework Using Lua
* Kikito's Awesome [bump.lua](https://github.com/kikito/bump.lua) - A 2D AABB Collision Detection Library for Lua
* Another of Kikito's Gems: [middleclass](https://github.com/kikito/middleclass) - Easy to Use OOP for Lua
* [love-android-sdl2](http://bitbucket.org/MartinFelis/love-android-sdl2) - An *Awesome* Android port for an *Awesome* Framework - zlib License


Special Thanks to the Following People/Projects:
------------------------------------------------
* [GCW-Zero](http://www.gcw-zero.com/) - A Very Cool Open Source Handheld with an *Awesome* Community Supporting it
* [Kikito](https://github.com/kikito) - An *Awesome* Asset to the LÖVE Community
* [Lua](http://www.lua.org/) - An *Awesome* Language with Many Very Cool Features
* [LuaJIT](http://luajit.org/) - An *Awesome* Implementation of Lua that Makes My Game actually Work at a Reasonable Speed
* pcercuei - An *Awesome* Developer Behind the GCW-Zero Who Ported LÖVE
* All the People Behind the GCW-Zero: Including Zear, JohnnyOnFlame, Nebuleon, and the Rest of the GCW-Zero Devs and those who Helped me Out in the IRC
* The Love Community - [forums](https://love2d.org/forums/) and [wiki](https://www.love2d.org/wiki/Main_Page)
* [BFXR](http://www.bfxr.net/) - This Game Wouldn't have Any Sound Without it.


LICENSE:
--------

If you find this useful or use any of this, Please drop me an Email at:
  dansecure1 (AT) gmail (DOT) com 


My Code is Released Under the MIT License ( Also Available in LICENSE.txt ):
```
JUMP-LOVE 2D Platformer - A Jumper Clone
Copyright (C) 2014-2015  Daniel Iacoviello

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

The Sound Files, Logos, Images, Map Files and Everything that Isn't Code are Released Under the [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/)


The bump.lua is by [Kikito](https://github.com/kikito) and Some Files Are Based off the bump.lua Demo, Kikito's Work was Released Under this License:
```
Copyright (c) 2012 Enrique García Cota

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

The middleclass.lua file is by Kikito, Released Under this License:
```
Copyright (c) 2011 Enrique García Cota

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```


The LÖVE Framework is Released Under the Following License:
```
Copyright © 2006-2012 LÖVE Development Team

This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
    2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
    3. This notice may not be removed or altered from any source distribution. 
```

###If your Package / Library / Work was used and not Mentioned, or you Noticed One Missing, Please Send a Message to dansecure1 (AT) gmail (DOT) com
