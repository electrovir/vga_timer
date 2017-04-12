# vga_timer
VHDL controller for vga timing for 640x480 screen.

Very basic but totally functional controller for handling the timing required for a 640x480 screen using the VGA standard.


This code is not optimized at all and has several ports on the sub-entities that aren't used at all.  You'll probably get warnings when synthesizing it because of that, but it'll still work fine.  I hoepfully strip out those sometime and add more explanation on how to use this.

I made this with barely any knowledge on how to use VHDL, so pardon me for any bad practices or sloppy code. Use at your own discretion, I don't promise this won't break everything, but it shouldn't (and I'm not sure how it would). Improvements are welcome!
