From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue, 14 Feb 2006 12:19:46 -0800
Subject: [Ocfs2-devel] OCFS2 Filesystem inconsistency across nodes
In-Reply-To: <200602140616.11856.ctpm@rnl.ist.utl.pt>
References: <200602100536.02893.ctpm@rnl.ist.utl.pt>
	<200602110540.57573.ctpm@rnl.ist.utl.pt>
	<20060213222606.GC20175@ca-server1.us.oracle.com>
	<200602140616.11856.ctpm@rnl.ist.utl.pt>
Message-ID: <20060214201946.GD20175@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Claudio Martins <ctpm@rnl.ist.utl.pt>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, Jan Kara <jack@suse.cz>, Nohez <nohez@cmie.com>

On Tue, Feb 14, 2006 at 06:16:11AM +0000, Claudio Martins wrote:
>  This patch does indeed seem to fix this particular problem. Now creating and 
> deleting files/directories gives expected results across nodes.
Great!

>  The bad news is that it didn't last long. While doing some more tests I found 
> another problem, but judging from kernel messages I think this one is related 
> to the DLM code.
Not so great :/

We have some dlm fixes in our git tree which haven't made their way to Linus
yet (I wanted to run a few more tests). Would you be interested in patching
with them so we can see which bugs are left? The easiest way to get this is
to pull them out of 2.6.16-rc3-mm1:

http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.16-rc3/2.6.16-rc3-mm1/broken-out/git-ocfs2.patch

You'll also pull a performance fix in that patch. Of course, even easier
might be to just run 2.6.16-rc3-mm1 for now as it also contains the
checkpoint list split backout.

>  On node 0, tar exited with:
> tar: 
> build-AMD-linux-2.6.16-rc2-git3-jbdfix1/drivers/media/video/cx25840/cx25840-core.c: 
> Cannot stat: Invalid argument
> 
> On node 2, tar exited with a segmentation fault.
Could you load up debugfs.ocfs2 against your file system and run the
following command:

debugfs: locate <M0000000000000000d4a94b05ae097f>

It will tell me the path to the file which that metadata lock refers to.
The path may help us figure out what sort of access we're having problems on
here.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
