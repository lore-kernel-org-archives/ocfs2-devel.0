From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Feb 26 19:15:10 2004
Subject: [Ocfs2-devel] Plans for completing the 2.6 port
Message-ID: <200402270114.i1R1EuST007250@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I thought it would good to put down in words my plans for finishing
the 2.6 port of ocfs2.  The target I am shooting for is acceptance in 
the up and coming SuSE release that is based on a 2.6 kernel.

This basically means we need to have a code drop ready by the end of
the month, which is at the end of the week.  If it is ok for the first 
code drop to have some major functional problems then this might be
doable.

So far I have approached a 2.6 port as:
* fix build system
* fix a bunch of compile errors just trying to get
  to the point where a module is created that actually
  loads
* dive into bug fixing for 2.6 specific problems

Building against a 2.6 kernel with the current automake infrastructure:
-----------------------------------------------------------------------

I have basically punted on this, creating my own cheesy Makefile that uses
the kernel build system.  John is working on a better way to do this (at least
something good enough to check-in to the tree and useful for a SLES9 spec
file.)

If anyone is trying to build against a 2.6 tree before John is able to submit
a patch to Manish, my own hard coded version of a makefile can be found at 
http://www.stinkycat.com/ocfs2/Makefile.

Ability to do a clean compile:
------------------------------

Up until now, I have really just been working towards a clean compile.  A 
large part of this is pretty simple, with little tweaks here and there for 
small changes in various kernel structures (like changes in prototypes
for the various vfs hooks.)  

However there are a lot of changes that more in the realm of crossing my 
fingers and hoping for the best, where I am copying what other file systems
do without fully understanding why.  I am certain that there are plenty
of gross errors that will become all to obvious as I attempt to actually
use ocfs2 in a 2.6 kernel.

I still have random fixes that I need to submit patches for, and then other
areas I have patches for but are broken.  To get a clean compile you can
use the following large patch will apply to svn version 36:

http://www.stinkycat.com/ocfs2/massive_2_6_port.r36.patch

Beware!!! The above patch will allow you to build a 2.6 module,
load the module, and even mount the file system, BUT...  shame on 
you if you try to actually read from the file system. :->

Usable ocfs2 on a 2.6 system:
-----------------------------

As mentioned above, this is really the next major step.  With any luck
the process of getting my patches into the svn repository will expose the
some gross conceptual errors that exist in my current tree.

This is where I will be enlisting the help of John and another colleague of 
mine, Sonic Zhang, who is working out of Shanghai.
