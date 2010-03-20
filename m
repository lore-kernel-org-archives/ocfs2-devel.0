From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 19 Mar 2010 18:28:10 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Handle deletion of reflinked
 oprhan inodes correctly.
In-Reply-To: <1268961670-4712-2-git-send-email-tristan.ye@oracle.com>
References: <1268961670-4712-1-git-send-email-tristan.ye@oracle.com>
	<1268961670-4712-2-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100320012810.GK15539@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 19, 2010 at 09:21:10AM +0800, Tristan Ye wrote:
> Current rule of orphan dir is that all inodes in the orphan dir
> have ORPHANED_FL, otherwise we treated it as an ERROR. this rule
> works well except for some rare cases of reflink operation:
> 
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1215
> 
> The problem is introduced by the essense of how reflink and our
> orphan_scan thread were working:
> 
>  * Orphan_scan scan the orphan dir into a queue first, and run
>    queue in a later time, we only hold the orphan_dir's lock
>    during scanning.
> 
>  * Reflink create a oprhaned target in orphan_dir at the first
>    step, and remove the targets and unset the flag at the third
>    step, these two steps respectively hold the orphan_dir's lock
>    themselves.
> 
> Based on above semantics, there is a possibility that a reflink
> inode can be moved out of the orphan dir and have its ORPHANED_FL
> cleared before the queue is run, which leads to a ERROR in
> ocfs2_query_wipde_inode().
> 
> This patch helps to judge if a orphan inode to be wiped off, which
> has NO ORPHANED_FL, is a legal alive reflinked target or not.
> 
> The patch also works for failed reflinked targets from a crash or
> other failures during the reflink operation, they can be wiped off
> as desired since these failed reflinked inodes always has ORPHANED_FL
> set ondisk.
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>

	This patch has been added to the 'fixes' branch of ocfs2.git.

Joel

-- 

Life's Little Instruction Book #407

	"Every once in a while, take the scenic route."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
