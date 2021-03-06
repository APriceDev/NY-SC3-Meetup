// SuperCollider meetup @ HackManhattan
// 4th February 2015
//=============================================

//#############################################################################
// INTRO
//#############################################################################

 /* This guide is intended to be the shortest possible intro to get you familiar
 with IDE navigation and aquainted with the most basic SC concepts for you
 to be able to run code and continue learning on your own.

 Supercollider has an extremely flexible architecture and very rich language
 which on the one hand allows for the design of very complex but elegant software,
 but on the other can be quite confusing for the beginner as the syntax and
 program structures may vary wildly from developer to developer.

 Besides that the language is under active development, thus certain functionality
 may be broken and repaired from release to release.
 All of this results in a rather steep learning curve for SC, but it's very well
 worth the effort as SC is by far the most flexible and best sounding computer
 music composition tool existing.
 Most sections of this intro have references to the excellent Eli Fieldsteel's
 video tutorials. */


//=============================================
// << 1 >> Supercollider IDE
//---------------------------------------------
// Eli Fieldsteel's video: http://youtu.be/ntL8QDOhhL8
//---------------------------------------------
//  1(a)  Basic keyboard shortcuts(mac):

// As SC is an interpreted language - code can be executed line-per-line.
// just put your cursor on the line you want to execute or select any portion of code
// and press "shift + enter"
"try me".postln

// try this as well
4 + 4

// Press "cmd + D" to search help index. Try looking up help for 'SinOsc' below:
SinOsc

/*
To be able to hear any sound - we first need to instantiate and boot the SC server.
Execute the following statements to do this.
*/
s = Server.local
s.boot

/* the text in the bottom-right corner of this window should turn green.

 We've just done 3 things:
 - we've made an instance of the Server object by sending it the '.local' message
 - we've assigned this instance to the variable 's' which will allow us to keep track
   of the server's status and communicate with it
 - we've booted the server by sending the '.boot' bessage to it.

 Because instantiating, botting and storing server instance in a variable is something
 you do pretty much every time you launch SC - there's also a shortcut for it.
 You can find it in the menu 'Language > Boot Server' or just press 'cmd + B'.
 The instance will be automatically stored in the 's' variable.

 Now that the server is running - we're almost ready to hear some sound.
 The only thing we need to know before that - is how to stop the sound.

 The shortcut for this is "cmd + ."

 Now execute the code below to hear the sine wave and then stop it with "cmd + ."
 The text editor window (where you are reading this) needs to be in focus for the shortcut to work.
*/

{SinOsc.ar}.play;

// The "cmd + ." is a shortcut for sending the .freeAll message to the server:
s.freeAll

// Try making some noise and stopping it with the .freeAll message
{WhiteNoise.ar(0.1)}.play
s.freeAll

/*
This command kills every sound-generating process on the server.
To be able to selectively turn sounds on and off - we need to keep
track of them using variables.

Execute the following code line-per-line. And observe post window and server status bar.
*/

a = {WhiteNoise.ar(0.1)}
b = {SinOsc.ar}

c = a.play
d = b.play

c.free
d.free


/*
You might have noticed that when executing the lines with 'a = ...' and 'b = ...' the
Post Window reported 'a Function'. SuperCollider syntax uses curly braces '{' and '}'
to denote functions. In our case we store two different functions using the variables
'a' and 'b'. To execute them however, we need to invoke their method  '.play'.

The words 'invoke a method' and 'pass a message' can be used almost interchangeably.

Another thing you might have noticed that when invoking 'a.play' and 'b.play' the server
status bar field '0s' has gone to '1s' then '2s' and back to 0 when the '.free' messages
were sent. This field tells us how many 'Synth' objects are instantiated on the server

The above syntax is often referred to as 'Convenience-style'.
Here is another way to do the same thing as above, this time - 'Object-style'.
*/

SynthDef(\test_sine, {Out.ar(0, SinOsc.ar)}).add
SynthDef(\test_noise, {Out.ar(0, WhiteNoise.ar(0.1))}).add

a = Synth(\test_sine)
b = Synth(\test_noise)

a.free
b.free


/*
This time we've wrapped our sound-generating functions into a SynthDef, short for
Synthesizer Definition. In fact, in this example we've explicitly written the code that
was conviniently generated for us by the language in the previous example.

The syntax in the previous example uses the so-called 'convinience methods'. They are very
usefull for trying out quick ideas on the fly, but once the ideas take shape it is
strongly recommended to structure them using SynthDefs.

Now that we have our SynthDefs conviniently located on the server (thanks to the '.add' message)
we can use yet another syntax to generate sound. This time - 'Messaging-style'
*/

a = s.nextNodeID
b = s.nextNodeID

s.sendMsg(\s_new, \test_sine, a, 0, 1)
s.sendMsg(\s_new, \test_noise, b, 0, 1)

s.sendMsg(\n_free, a)
s.sendMsg(\n_free, b)

/*
This time, instead of using the Synth object, we use plain Open Sound Control messages to instantiate
sound generating processes on the server. This syntax is mostly used when interfacing SC with
other applications.
*/

/*
Now that we are able to generate noise, it is important to ensure that our ears and PA's stay intact
for our future sonic experiments.
*/

//************************************************************************************
//************************************************************************************
// !!! WARNING !!!  when SC blows - it has NO RESPECT for your volume control settings
//************************************************************************************
//************************************************************************************
// EXECUTION OF THE FOLLOWING CODE
// MIGHT BE HARMFUL FOR YOUR HEARING AND/OR YOUR SOUND SYSTEM (though unlikely)
// put all your volume levels low and then run the code.
// Better yet - unplug all audio cables from your laptop and run it on the built-in speakers.

// compare this:
{HPF.ar(Saw.ar, 10000)}.play

// with this:
{HPF.ar(Saw.ar, -10000)}.play

// Hence. Working with closed headphones - A BIG NO-NO.
// If you absolutely have to - keep the headphones shifted from your ears when you execute code, and only
// move them over ears when code is already running


/*
Further work here:
- variables and namespaces
- server/language communication
- server architecture
- functions and arguments
- Quarks version control
*/