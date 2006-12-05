From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Dec  5 11:45:28 2006
Subject: [Ocfs2-devel] [patch 1/1]OCFS2: allow the ocfs2 heartbeat thread
	to prioritize I/O
In-Reply-To: <4576135A02000004002629E9@lucius.provo.novell.com>
References: <4576135A02000004002629E9@lucius.provo.novell.com>
Message-ID: <20061205194523.GI19617@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Zhen,

On Tue, Dec 05, 2006 at 06:47:26AM -0700, Zhen Wei wrote:
> From: Zhen Wei <zwei@novell.com>
> Subject: allow the ocfs2 heartbeat thread to prioritize I/O
> Patch-mainline: 2.6.19
> 
> To prioritize ocfs2 heartbeat thread I/O may help cut down on spurious
> fencing, 
> so the patch sets the heartbeat thread to real time I/O priority after
> thread starting,
> user also can change the I/O priorities via configfs without knowing the
> thread pid, 
> but only cfq scheduler supports I/O priorities now.
> 
> Signed-off-by: Zhen Wei <zwei@novell.com>
Thanks for the patch, but I think you're taking the wrong approach here.
I think what we want to do is handle the majority of this in userspace. The
"ionice" program already exists to use the system calls in fs/ionice.c to
change the io priority of a running thread.

What I would do is look into modifying ocfs2_hb_ctl in ocfs2-tools to modify
the io priority of the running heartbeat thread. You can export the thread
pid via configfs if need be. The way to modify priority would be either to
fork and exec ionice (if it exists), or to call the system call directly.
Either way, you'll have to do work to detect whether you're on a system
which doesn't support sys_ioprio_set().
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
