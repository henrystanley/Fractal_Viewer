Fractal Viewer
==============

This is a simple zoomable fractal renderer. The main program is written in Processing, however fractal rendering is handled by a small GLSL pixel shader (this means a fairly beefy gpu is required for usable framerates). It currently only supports the Mandelbrot, Julia set, and Burning Ship fractals, but is quite extendable.

Usage
=====

Right mouse to zoom in, left mouse to zoom out.  
Arrow Keys to change Julia set parameters.  
Menu in top left to change fractal.