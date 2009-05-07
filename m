From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 7 May 2009 12:08:18 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2_cluster_lock: code cleanup
	for	redundant assignment
In-Reply-To: <4A0328DC.6050702@suse.de>
References: <4A0328DC.6050702@suse.de>
Message-ID: <20090507190818.GA15816@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, May 08, 2009 at 02:30:52AM +0800, Coly Li wrote:
> In fs/ocfs2/dlmglue.c:ocfs2_cluster_lock(), after label 'out:' the code is:
> 
> 1373         if (wait && arg_flags & OCFS2_LOCK_NONBLOCK &&
> 1374             mw.mw_mask & (OCFS2_LOCK_BUSY|OCFS2_LOCK_BLOCKED)) {
> 1375                 wait = 0;
> 1376                 if (lockres_remove_mask_waiter(lockres, &mw))
> 1377                         ret = -EAGAIN;
> 1378                 else
> 1379                         goto again;
> 1380         }
> 
> On L1375 variable 'wait' is assigned to 0. But if execution path goes to L1379
> and jumps to label 'again:' on L1262, there is already an assignment to 'wait'
> on L1263:
> 
> 1262 again:
> 1263         wait = 0;
> 1264
> 
> The previous 'wait = 0' on L1375 is redundant in this case. This patch removes
> such a redundant variable assignment.

	NAK.  You're correct that the assignment is redundant, but the
compiler is smart enough to figure it out.  The current code is more
readable - it's obvious right there that NONBLOCk &&
BLOCKED|BUSY means we shouldn't wait.  With your change, it's not
obvious - someone has to go down through the code to discover that wait
is cleared at again:.  Even if they find that wait is cleared, they
don't have an obvious clue as to the reason.

Joel

-- 

"I always thought the hardest questions were those I could not answer.
 Now I know they are the ones I can never ask."
			- Charlie Watkins

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
