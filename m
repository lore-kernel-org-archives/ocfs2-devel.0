From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Dec 10 14:58:34 2007
Subject: [Ocfs2-devel] [PATCH 3/7] ocfs2: Change the recovery map to an
	array of node numbers.
In-Reply-To: <1197004787-15344-4-git-send-email-joel.becker@oracle.com>
References: <1197004787-15344-1-git-send-email-joel.becker@oracle.com>
	<1197004787-15344-4-git-send-email-joel.becker@oracle.com>
Message-ID: <20071210225635.GX28607@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 06, 2007 at 09:19:43PM -0800, Joel Becker wrote:
> The old recovery map was a bitmap of node numbers.  This was sufficient
> for the maximum node number of 254.  Going forward, we want node numbers
> to be UINT32.  Thus, we need a new recovery map.
> 
> Note that we can't keep track of slots here.  We must write down the
> node number to recovery *before* we get the locks needed to convert a
> node number into a slot number.
> 
> The recovery map is now an array of unsigned ints, max_slots in size.
> It moves to journal.c with the rest of recovery.
> 
> Because it needs to be initialized, we move all of recovery initialization
> into a new function, ocfs2_recovery_init().  This actually cleans up
> ocfs2_initialize_super() a little as well.  Following on, recovery cleaup
> becomes part of ocfs2_recovery_exit().
> 
> A number of node map functions are rendered obsolete and are removed.
> 
> Finally, waiting on recovery is wrapped in a function rather than naked
> checks on the recovery_event.  This is a cleanup from Mark.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
