From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Wed Mar 17 17:12:15 2004
Subject: [Ocfs2-devel] Crash in ocfs_volume_thread
In-Reply-To: <20040317223216.GL20057@ca-server1.us.oracle.com>
References: <60C14C611F1DDD4198D53F2F43D8CA3B0EFC68@orsmsx410.jf.intel.com>
	<20040317223216.GL20057@ca-server1.us.oracle.com>
Message-ID: <20040317231157.GA22672@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 17, 2004 at 02:32:16PM -0800, Mark Fasheh wrote:
> On Wed, Mar 17, 2004 at 01:42:12PM -0800, Villalovos, John L wrote:
> > I am trying to debug an issue where I get a crash in the
> > ocfs_volume_thread.
> > 
> > Here is the scenario.
> > 
> > This is all done under a 2.6.x kernel
> > 
> > I have a corrupted partition (I think).  
> > 
> > I created this corrupted partition by:
> > 
> > 1. Run mkfs.ocfs2
> > 2. Mount the partition once.  This caused errors.
> > 3. Reboot the system.
> > 4. Try to mount the partition again and then it crashes in the
> > ocfs_volume_thread.
> Hmm, this particular scenario I don't believe has been considered very
> much... (trying to mount a partition that failed the whole 1st mount
> business)

I currently get around this bug by making sure my first mount of a
partition is from a 2.4 build.  Maybe the fix for this is to just
go ahead and rip out the first mount logic and place it in mkfs.ocfs
like has mentioned before.
