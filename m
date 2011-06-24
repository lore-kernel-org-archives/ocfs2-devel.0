From: Jan Kara <jack@suse.cz>
Date: Fri, 24 Jun 2011 23:44:28 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Avoid livelock in ocfs2_readpage()
In-Reply-To: <4E04F9C0.4060004@oracle.com>
References: <1308862307-15626-1-git-send-email-jack@suse.cz>
	<4E04F9C0.4060004@oracle.com>
Message-ID: <20110624214428.GA18902@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri 24-06-11 13:55:28, Sunil Mushran wrote:
> Looks reasonable. Was this something someone ran into or was
> this reproduced only via a test workload?
  One of our customers hit this when running installation in KVM whose
filesystem image was stored on OCFS2... Generally loading KVM guest with
IO seemed to trigger this fairly regulary.

								Honza
> On 06/23/2011 01:51 PM, Jan Kara wrote:
> >When someone writes to an inode, readers accessing the same inode via
> >ocfs2_readpage() just busyloop trying to get ip_alloc_sem because
> >do_generic_file_read() looks up the page again and retries ->readpage()
> >when previous attempt failed with AOP_TRUNCATED_PAGE. When there are enough
> >readers, they can occupy all CPUs and in non-preempt kernel the system is
> >deadlocked because writer holding ip_alloc_sem is never run to release the
> >semaphore. Fix the problem by making reader block on ip_alloc_sem to break
> >the busy loop.
> >
> >Signed-off-by: Jan Kara<jack@suse.cz>
> >---
> >  fs/ocfs2/aops.c |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> >
> >diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> >index ac97bca..0919e8f 100644
> >--- a/fs/ocfs2/aops.c
> >+++ b/fs/ocfs2/aops.c
> >@@ -290,7 +290,15 @@ static int ocfs2_readpage(struct file *file, struct page *page)
> >  	}
> >
> >  	if (down_read_trylock(&oi->ip_alloc_sem) == 0) {
> >+		/*
> >+		 * Unlock the page and cycle ip_alloc_sem so that we don't
> >+		 * busyloop waiting for ip_alloc_sem to unlock
> >+		 */
> >  		ret = AOP_TRUNCATED_PAGE;
> >+		unlock_page(page);
> >+		unlock = 0;
> >+		down_read(&oi->ip_alloc_sem);
> >+		up_read(&oi->ip_alloc_sem);
> >  		goto out_inode_unlock;
> >  	}
> >
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
