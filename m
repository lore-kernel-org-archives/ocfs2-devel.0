From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Mar 17 16:32:20 2004
Subject: [Ocfs2-devel] Crash in ocfs_volume_thread
In-Reply-To: <60C14C611F1DDD4198D53F2F43D8CA3B0EFC68@orsmsx410.jf.intel.com>
References: <60C14C611F1DDD4198D53F2F43D8CA3B0EFC68@orsmsx410.jf.intel.com>
Message-ID: <20040317223216.GL20057@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 17, 2004 at 01:42:12PM -0800, Villalovos, John L wrote:
> I am trying to debug an issue where I get a crash in the
> ocfs_volume_thread.
> 
> Here is the scenario.
> 
> This is all done under a 2.6.x kernel
> 
> I have a corrupted partition (I think).  
> 
> I created this corrupted partition by:
> 
> 1. Run mkfs.ocfs2
> 2. Mount the partition once.  This caused errors.
> 3. Reboot the system.
> 4. Try to mount the partition again and then it crashes in the
> ocfs_volume_thread.
Hmm, this particular scenario I don't believe has been considered very
much... (trying to mount a partition that failed the whole 1st mount
business)

> I get the following errors:
> 
> kernel: (17777) ERROR: status = -22, /root/ocfs/new-ocfs2/src/osb.c, 427
> kernel: (17777) ERROR: status = -22, /root/ocfs/new-ocfs2/src/super.c,
> 1063
> 
> Then the crash occurs because I have a NULL pointer in line 670 of io.c
> which seems to be called by ocfs_volume_thread.
> 
> The NULL pointer is in bh->b_bdev.  This being NULL causes a crash to
> occur later on when BH_GET_DEVICE(bh) is called and tries to do a
> bh->b_bdev->bd_dev.
> 
> 
> >From looking at the code in super.c it seems like it creates the thread
> but when the error occurs it doesn't take care of destroying the
> thread(s) that have been created.  Does this interpretation seem
> correct.
> 
> So should the threads get killed if the mount fails?
Definitely.

So then the fs is being cleaned up, but the nm thread obviously isn't. Are
any of the other threads still alive too? (Perhaps we haven't even gotten a
chance to start them yet actually).
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
