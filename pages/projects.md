---
title: Our Projects
pagetitle: Projects
---

The Club mantains a series of programming projects to encourage learning and help students gain experience working in terms to create real software.
Organised from the bottom up, these projects are a way to apply skills and concepts from classes as well as knowledge gained outside university in a friendly and supportive environment.
We aim to design projects that are accessible for people of varying skill levels and abilities.

We only accept contributions to our projects from members so if you are interested but are not one yet, then please visit our Rubric page to become one.
Additionally, any contributions made to our projects must include a copyright assignment to the Club. We plan to formalise this project in future to make it easy to do for first time contributors.

<!-- TODO: Fix or hide dropdowns with no js -->
<!-- TODO: Support carousels with no js? -->
[Toggle all example dropdowns](#){role="button" data-bs-toggle="collapse" data-bs-target=".multi-collapse" aria-expanded="true" aria-controls="textAdventureExamples discordBotExamples minecraftExamples"}

### Untitled Text Adventure
A yet unnamed classic text adventure that started development in early 2024 in C but is currently being rewritten in [Haxe](https://haxe.org/), a blend of Java and Python used mostly for game development which we hope will make the game more approachable to work on.
Like similar text adventures from the 80s and 90s, the game features password based saving rather than modern save files, this forces us to be creative when introducing new features as to avoid bloating the password and so making it hard to use.  

A key focus of this project is having it be compatible with a wide variety of unusual targets including Discord, our Website and the [Pimoroni PicoVision](https://shop.pimoroni.com/products/picovision), an embedded Raspberry PI RP2040 based computer with an HDMI output.
We started in C for it's near universal adoption on both new and old devices going back decades, but it turns out that Haxe fits this niche even better as it can be converted into a number of other languages including C++, JavaScript and Python making it easy to use almost anywhere.
Once the rewrite is done, we have plans to develop a map editor and possibly make use on other Tassie made projects like [Yarn Spinner](https://www.yarnspinner.dev/) for narrative and progression management since a partial [Haxe port](https://github.com/cxsquared/hxyarn) already exists.

[Toggle game example screens](#textAdventureExamples){role="button" data-bs-toggle="collapse" data-bs-target="#textAdventureExamples" aria-expanded="true" aria-controls="textAdventureExamples"}

::: {id="textAdventureExamples" class="carousel slide multi-collapse show"}
:::: carousel-indicators
<button type="button" data-bs-target="#textAdventureExamples" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
<button type="button" data-bs-target="#textAdventureExamples" data-bs-slide-to="1" aria-label="Slide 2"></button>
<button type="button" data-bs-target="#textAdventureExamples" data-bs-slide-to="2" aria-label="Slide 3"></button>
::::
:::: carousel-inner
::::: {class="carousel-item active"}
```
Untitled text adventure game
----------------------------
By the UTAS Programming Club

Currently unimplemented :(

Use the numbers below to make a selection.
1. Start Game
2. Load Game
3. Quit Game
```
:::::
::::: carousel-item
```
You find yourself surrounded.

You attacked enemy 2 with your sword.
Enemy 1 attacked you with their sword but your armour absorbed the impact.
Enemy 2 attacked you with their sword but your armour absorbed the impact.
Enemy 3 launched a fireball at you but your armour absorbed the impact.

Your Health:  ███████    :  64%
Your Stamina: ██████████ : 100%

Physical enemy 1 health: ██████████ :  95%
Physical enemy 2 health: ████       :  33%
 Magical enemy 3 health: ██████████ : 100%

Combat log:
⬤ Enemy 3 did 0 magic damage to you
⬤ Enemy 2 did 0 physical damage to you
⬤ Enemy 1 did 0 physical damage to you
⬤ You did 67 physical damage to enemy 2
⬤ Enemy 3 did 10 magic damage to you
⬤ Enemy 2 did 13 physical damage to you
⬤ Enemy 1 did 13 physical damage to you
⬤ You did 5 physical damage to enemy 1

Use the numbers below to make a selection.
1. Attack Enemy 1
2. Attack Enemy 2
3. Attack Enemy 3
4. Check Player Stats
5. Flee
```
:::::
::::: carousel-item
```
Player Equipment

Health:                    ██████████ : 100
Stamina:                   ██████████ : 100
Primary Physical Attack:   ███        :  25
Primary Magic Attack:      █          :   4
Secondary Physical Attack: ███        :  25
Secondary Magic Attack:    █          :   4
Physical Defence:          █████████  :  90
Magic Defence:             █          :  10

Helmet: Leather Helmet
Chest: Rags
Gloves: Spiked Gloves
Pants: Rags
Boots: Old Leather Boots
Primary Weapon: Fist
Secondary Weapon: Fist


Use the numbers below to make a selection.
1. Swap Equipment 1
2. Swap Equipment 2
3. Swap Equipment 3
4. Swap Equipment 4
5. Swap Equipment 5
6. Swap Equipment 6
7. Swap Equipment 7
8. Return to Game
```
:::::
::::
<button class="carousel-control-prev" type="button" data-bs-target="#textAdventureExamples" data-bs-slide="prev">
  []{class="carousel-control-prev-icon" aria-hidden="true"}
  [Previous]{class="visually-hidden"}
</button>
<button class="carousel-control-next" type="button" data-bs-target="#textAdventureExamples" data-bs-slide="next">
  []{class="carousel-control-next-icon" aria-hidden="true"}
  [Next]{class="visually-hidden"}
</button>
:::

[Links:]{class="list-heading"}

 * [Original game's source code](https://github.com/UTAS-Programming-Club/UntitledTextAdventure)
 * [Haxe rewrite's source code](https://github.com/UTAS-Programming-Club/UntitledTextAdventure/tree/haxe-rewrite)
 * [Some ideas and a partial development history](https://github.com/UTAS-Programming-Club/UntitledTextAdventure/wiki)
 * [Discord bot plugin to use original game](https://github.com/UTAS-Programming-Club/DiscordBot/blob/main/PCBot/plugins/textadventure.py)
 * [Discord bot plugin to use haxe rewrite](https://github.com/UTAS-Programming-Club/DiscordBot/blob/main/PCBot/plugins/textadventurenew.py)
 * [Web build for haxe rewrite](https://programmingclub.com.au/game/webfrontend.html), note that this is on our old website

### Discord Bot
Developed for our Discord server, the Club's own Discord bot comes with a variety of minigames supporting both singleplayer and multiplayer including tictactoe and minesweeper.
The bot is written in Python using [hikari](https://github.com/hikari-py/hikari), [hikari-crescent](https://github.com/hikari-crescent/hikari-crescent), and [hikari-miru](https://github.com/hypergonial/hikari-miru) to handle communication with Discord, basic user interaction and button menus respectively.
On top of this, we have developed custom methods of reloading and debugging plugins during development with plans to improve these features even further to allow people to work on the bot simulatiously without risking impacting each other.

We have previously included partial support for hangman and classic DECtalk based TTS.
If anyone is interested in these features and would like to help finish support for them or for anything else, then please let us know.
Recently, we used the bot to list scores from our private Advent of Code 2024 leaderboard to make it easy to compare scores with other members.

[Toggle bot example commands](#discordBotExamples){role="button" data-bs-toggle="collapse" data-bs-target="#discordBotExamples" aria-expanded="true" aria-controls="discordBotExamples"}

::: {id="discordBotExamples" class="carousel slide multi-collapse show"}
:::: carousel-indicators
<button type="button" data-bs-target="#discordBotExamples" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
<button type="button" data-bs-target="#discordBotExamples" data-bs-slide-to="1" aria-label="Slide 2"></button>
<button type="button" data-bs-target="#discordBotExamples" data-bs-slide-to="2" aria-label="Slide 3"></button>
::::
:::: carousel-inner
::::: {class="carousel-item active"}
<picture>
  <source srcset="assets/2023-2024/discord-minesweeper.avif" type="image/avif">
  <source srcset="assets/2023-2024/discord-minesweeper.webp" type="image/webp">
  ![Example of minesweeper commmand](assets/2023-2024/discord-minesweeper.png){class="d-block m-auto w-auto"}
</picture>
:::::
::::: carousel-item
<picture>
  <source srcset="assets/2023-2024/discord-hangman.avif" type="image/avif">
  <source srcset="assets/2023-2024/discord-hangman.webp" type="image/webp">
  ![Example of hangman commmand](assets/2023-2024/discord-hangman.png){class="d-block m-auto w-auto"}
</picture>
:::::
::::: carousel-item
<picture>
  <source srcset="assets/2024-2025/discord-aoc.avif" type="image/avif">
  <source srcset="assets/2024-2025/discord-aoc.webp" type="image/webp">
  ![Example of advent of code leaderboard commmand](assets/2024-2025/discord-aoc.png){class="d-block m-auto w-auto"}
</picture>
:::::
::::
<button class="carousel-control-prev" type="button" data-bs-target="#discordBotExamples" data-bs-slide="prev">
  []{class="carousel-control-prev-icon" aria-hidden="true"}
  [Previous]{class="visually-hidden"}
</button>
<button class="carousel-control-next" type="button" data-bs-target="#discordBotExamples" data-bs-slide="next">
  []{class="carousel-control-next-icon" aria-hidden="true"}
  [Next]{class="visually-hidden"}
</button>
:::

[Links:]{class="list-heading"}

 * [Our bot's source code](https://github.com/UTAS-Programming-Club/DiscordBot)

### Minecraft Mod/Server
Mid last year we soft launched our new modded Minecraft server with [Terralith](https://modrinth.com/mod/terralith) for more interesting terrain generation and [CC: Tweaked](https://modrinth.com/mod/cc-tweaked) i.e updated Computer Craft so we can program with Lua inside the game.
Shortly after starting the server, we began to further mod the game with changes of our own design. 
Currently, our mod just adds explosion proof glass but we welcome suggestions for more features.

If there is interest, we plan to get back into playing during the holidays before semester 1 starts.

[Toggle server example screenshots](#minecraftExamples){role="button" data-bs-toggle="collapse" data-bs-target="#minecraftExamples" aria-expanded="true" aria-controls="minecraftExamples"}

::: {id="minecraftExamples" class="carousel slide multi-collapse show"}
:::: carousel-indicators
<button type="button" data-bs-target="#minecraftExamples" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
<button type="button" data-bs-target="#minecraftExamples" data-bs-slide-to="1" aria-label="Slide 2"></button>
<button type="button" data-bs-target="#minecraftExamples" data-bs-slide-to="2" aria-label="Slide 3"></button>
<button type="button" data-bs-target="#minecraftExamples" data-bs-slide-to="3" aria-label="Slide 4"></button>
::::
:::: carousel-inner
::::: {class="carousel-item active"}
<picture>
  <source srcset="assets/minecraft-1.avif" type="image/avif">
  <source srcset="assets/minecraft-1.webp" type="image/webp">
  ![Example of Terralith terrain on our Minecraft Server](assets/minecraft-1.png){class="d-block m-auto w-auto"}
</picture>
:::::
::::: carousel-item
<picture>
  <source srcset="assets/minecraft-2.avif" type="image/avif">
  <source srcset="assets/minecraft-2.webp" type="image/webp">
  ![Example of player bases on our Minecraft Server](assets/minecraft-2.png){class="d-block m-auto w-auto"}
</picture>
:::::
::::: carousel-item
<picture>
  <source srcset="assets/minecraft-3.avif" type="image/avif">
  <source srcset="assets/minecraft-3.webp" type="image/webp">
  ![Example of development work on our mod for our Minecraft Server](assets/minecraft-3.png){class="d-block m-auto w-auto"}
</picture>
:::::
::::: carousel-item
<picture>
  <source srcset="assets/minecraft-4.avif" type="image/avif">
  <source srcset="assets/minecraft-4.webp" type="image/webp">
  ![Example of modded blocks and player structures on our Minecraft Server](assets/minecraft-4.png){class="d-block m-auto w-auto"}
</picture>
:::::
::::
<button class="carousel-control-prev" type="button" data-bs-target="#minecraftExamples" data-bs-slide="prev">
  []{class="carousel-control-prev-icon" aria-hidden="true"}
  [Previous]{class="visually-hidden"}
</button>
<button class="carousel-control-next" type="button" data-bs-target="#minecraftExamples" data-bs-slide="next">
  []{class="carousel-control-next-icon" aria-hidden="true"}
  [Next]{class="visually-hidden"}
</button>
:::

[Links:]{class="list-heading"}

 * [Our mod's source code](https://github.com/UTAS-Programming-Club/HardenedGlass)

### This Website
What you are seeing now is a a major redesign of our original website.
Both are static websites hosted on GitHub but the updated site allows us to write pages in Markdown and then convert to HTML using [Pandoc](https://pandoc.org/) which should be much easier to maintain.
Additionally, major sections of the site like the top nav bar are generated entirely automatically to avoid having to modify every page whenever something changes.
We also used the opportunity to rewrite most pages to cover way more of what we do and how students can get involved as well as add cool new features like dark mode.

Check out the info page with the button in the bottom right to see some more infomation about the website and how it is designed and mantained.
We have plans to add even more content, improve the integration with the text adventure and possibly add alternate themes.
Let us know what you would like to see!

[Links:]{class="list-heading"}

 * [Our updated website's source code](https://github.com/UTAS-Programming-Club/testwebsite)
 * [Our legacy website's source code](https://github.com/UTAS-Programming-Club/UTAS-Programming-Club.github.io), while it still exists
