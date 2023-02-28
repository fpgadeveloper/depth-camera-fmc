# Depth Camera FMC example designs

This is (the very early stage of) an example design for a new FMC product that we are developing.
The card will have four independent 4-lane MIPI interfaces for connection to 
[Luxonis OAK-FFC camera modules](https://shop.luxonis.com/collections/oak-modules).
The main purpose of the design at the moment is to validate our product and it's compatibility
with the carriers that we intend to support.

At the moment, we intend to support the following boards:

* ZCU104 (LPC: 4x 4-lane Luxonis cameras)
* ZCU102 (HPC0: 4x 4-lane Luxonis cameras, HPC1: 2x 4-lane Luxonis cameras)
* ZCU106 (HPC0: 4x 4-lane Luxonis cameras)
* PYNQ-ZU (LPC: 2x 4-lane Luxonis cameras + 2x 2-lane Luxonis cameras)
* Genesys-ZU (LPC: 4x 4-lane Luxonis cameras)
* UltraZed EV carrier (HPC: 1x 4-lane Luxonis cameras + 3x 2-lane Luxonis cameras)

That list may grow, but may also shrink depending on any issues that we come across during
development.

### List of things to fix/complete

* The example design has run out of PL-to-PS interrupts, so we need to add the AXI Interrupt Controller.
  The main challenge for the moment is adapting the software application to AXI Intc.
* The four cameras feed an AXI Switch which selects which video source to display on the monitor.
  Instead we want to add an IP to combine all four sources into a single 1080p video to display
  on the monitor.
* Eventually we want to use the Xilinx ISP to do some processing on the input videos to make the
  demo interesting.
