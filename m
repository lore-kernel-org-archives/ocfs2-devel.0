From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Jan 23 17:02:39 2008
Subject: [Ocfs2-devel] Re: [PATCH 03/30] ocfs2: Remove mount/unmount votes
In-Reply-To: <20080123140509.4db5fb47.akpm@linux-foundation.org>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
	<1200609356-17788-4-git-send-email-mark.fasheh@oracle.com>
	<20080123140509.4db5fb47.akpm@linux-foundation.org>
Message-ID: <20080124010222.GN23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Andrew, thanks for the review.

On Wed, Jan 23, 2008 at 02:05:09PM -0800, Andrew Morton wrote:
> > On Thu, 17 Jan 2008 14:35:29 -0800 Mark Fasheh <mark.fasheh@oracle.com> wrote:
> > The node maps that are set/unset by these votes are no longer relevant, thus
> > we can remove the mount and umount votes. Since those are the last two
> > remaining votes, we can also remove the entire vote infrastructure.
> > 
> > The vote thread has been renamed to the downconvert thread, and the small
> > amount of functionality related to managing it has been moved into
> > fs/ocfs2/dlmglue.c. All references to votes have been removed or updated.
> > 
> 
> Locking looks fishy.

Btw, the downconvert code is functionally identical from what was in vote.c
for years now. It just got moved into dlmglue.c and renamed.


> > +static void ocfs2_downconvert_thread_do_work(struct ocfs2_super *osb)
> > +{
> > +	unsigned long processed;
> > +	struct ocfs2_lock_res *lockres;
> > +
> > +	mlog_entry_void();
> > +
> > +	spin_lock(&osb->dc_task_lock);
> > +	/* grab this early so we know to try again if a state change and
> > +	 * wake happens part-way through our work  */
> > +	osb->dc_work_sequence = osb->dc_wake_sequence;
> > +
> > +	processed = osb->blocked_lock_count;
> > +	while (processed) {
> > +		BUG_ON(list_empty(&osb->blocked_lock_list));
> > +
> > +		lockres = list_entry(osb->blocked_lock_list.next,
> > +				     struct ocfs2_lock_res, l_blocked_list);
> > +		list_del_init(&lockres->l_blocked_list);
> > +		osb->blocked_lock_count--;
> > +		spin_unlock(&osb->dc_task_lock);
> > +
> > +		BUG_ON(!processed);
> > +		processed--;
> > +
> > +		ocfs2_process_blocked_lock(osb, lockres);
> > +
> > +		spin_lock(&osb->dc_task_lock);
> > +	}
> > +	spin_unlock(&osb->dc_task_lock);
> 
> Once the lock has been dropped there is (apparently) nothing to prevent
> alteration of the list and of ->blocked_lock_count.  If this happens,
> either items will be missed or we go BUG.

The rule is that only the downconvert thread is allowed to remove locks from
that list. Everyone else just decides a lock needs downconverting and queues
it.

Attached to this e-mail is a patch to better document this.


> > +	mlog_exit_void();
> > +}
> > +
> > +static int ocfs2_downconvert_thread_lists_empty(struct ocfs2_super *osb)
> > +{
> > +	int empty = 0;
> > +
> > +	spin_lock(&osb->dc_task_lock);
> > +	if (list_empty(&osb->blocked_lock_list))
> > +		empty = 1;
> > +
> > +	spin_unlock(&osb->dc_task_lock);
> > +	return empty;
> > +}
> 
> This function appears to be returning a value which is unreliable once the
> lock was dropped.

In this case that's ok. It's only used during dlmglue shutdown when no new
locks should ever be queued.


> > +static int ocfs2_downconvert_thread_should_wake(struct ocfs2_super *osb)
> > +{
> > +	int should_wake = 0;
> > +
> > +	spin_lock(&osb->dc_task_lock);
> > +	if (osb->dc_work_sequence != osb->dc_wake_sequence)
> > +		should_wake = 1;
> > +	spin_unlock(&osb->dc_task_lock);
> > +
> > +	return should_wake;
> > +}
> 
> Ditto.

Another case where it's ok :)

 
> > +int ocfs2_downconvert_thread(void *arg)
> > +{
> > +	int status = 0;
> > +	struct ocfs2_super *osb = arg;
> > +
> > +	/* only quit once we've been asked to stop and there is no more
> > +	 * work available */
> > +	while (!(kthread_should_stop() &&
> > +		 ocfs2_downconvert_thread_lists_empty(osb))) {
> 
> Extra whitespace

Ok, a cleanup of this and the other whitespace problems you pointed out (in
resize.c) have been commited to the tree.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com

From: Mark Fasheh <mark.fasheh@oracle.com>

ocfs2: document access rules for blocked_lock_list

ocfs2_super->blocked_lock_list and ocfs2_super->blocked_lock_count have some
usage restrictions which aren't immediately obvious to anyone reading the
code. It's a good idea to document this so that we avoid making costly
mistakes in the future.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/ocfs2.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 22e334d..d084805 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -262,6 +262,12 @@ struct ocfs2_super
 	unsigned long dc_wake_sequence;
 	unsigned long dc_work_sequence;
 
+	/*
+	 * Any thread can add locks to the list, but the downconvert
+	 * thread is the only one allowed to remove locks. Any change
+	 * to this rule requires updating
+	 * ocfs2_downconvert_thread_do_work().
+	 */
 	struct list_head blocked_lock_list;
 	unsigned long blocked_lock_count;
 
-- 
1.5.3.6
