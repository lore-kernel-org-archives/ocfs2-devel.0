From: Joel Becker <jlbec@evilplan.org>
Date: Thu, 28 Jul 2011 02:08:26 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Avoid livelock in ocfs2_readpage()
In-Reply-To: <1308862307-15626-1-git-send-email-jack@suse.cz>
References: <1308862307-15626-1-git-send-email-jack@suse.cz>
Message-ID: <20110728090825.GC9495@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jun 23, 2011 at 10:51:47PM +0200, Jan Kara wrote:
> When someone writes to an inode, readers accessing the same inode via
> ocfs2_readpage() just busyloop trying to get ip_alloc_sem because
> do_generic_file_read() looks up the page again and retries ->readpage()
> when previous attempt failed with AOP_TRUNCATED_PAGE. When there are enough
> readers, they can occupy all CPUs and in non-preempt kernel the system is
> deadlocked because writer holding ip_alloc_sem is never run to release the
> semaphore. Fix the problem by making reader block on ip_alloc_sem to break
> the busy loop.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

Life's Little Instruction Book #30

	"Never buy a house without a fireplace."

			http://www.jlbec.org/
			jlbec at evilplan.org
