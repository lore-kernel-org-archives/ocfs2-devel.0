From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 19 Aug 2008 17:59:11 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix sleep-with-spinlock
	recovery	regression
In-Reply-To: <20080820005115.GF8070@wotan.suse.de>
References: <20080820002215.GE8070@wotan.suse.de>
	<20080820005115.GF8070@wotan.suse.de>
Message-ID: <20080820005910.GA27759@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Aug 19, 2008 at 05:51:15PM -0700, Mark Fasheh wrote:
> On Tue, Aug 19, 2008 at 05:22:15PM -0700, Mark Fasheh wrote:
> > This fixes a bug introduced with 539d8264093560b917ee3afe4c7f74e5da09d6a5:
> >     [PATCH 2/2] ocfs2: Fix race between mount and recovery
> 
> Ok, version 2 - with a bug fix.
> 
> From: Mark Fasheh <mfasheh@suse.com>
> 
> [PATCH] ocfs2: Fix sleep-with-spinlock recovery regression
> 
> This fixes a bug introduced with 539d8264093560b917ee3afe4c7f74e5da09d6a5:
>     [PATCH 2/2] ocfs2: Fix race between mount and recovery
> 
> ocfs2_mark_dead_nodes() was reading journal inodes while holding the
> spinlock protecting our in-memory recovery state. The fix is very simple -
> the disk state is protected by a cluster lock that's already held, so we
> just move the spinlock down past the read.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
Signed-off-by:  Joel Becker <joel.becker@oracle.com>


-- 

"We'd better get back, `cause it'll be dark soon,
 and they mostly come at night.  Mostly."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
