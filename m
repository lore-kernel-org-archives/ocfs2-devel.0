From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 23 Jan 2008 22:05:21 -0000
Subject: [Ocfs2-devel] [PATCH 03/30] ocfs2: Remove mount/unmount votes
In-Reply-To: <1200609356-17788-4-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
	<1200609356-17788-4-git-send-email-mark.fasheh@oracle.com>
Message-ID: <20080123140509.4db5fb47.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

> On Thu, 17 Jan 2008 14:35:29 -0800 Mark Fasheh <mark.fasheh@oracle.com> wrote:
> The node maps that are set/unset by these votes are no longer relevant, thus
> we can remove the mount and umount votes. Since those are the last two
> remaining votes, we can also remove the entire vote infrastructure.
> 
> The vote thread has been renamed to the downconvert thread, and the small
> amount of functionality related to managing it has been moved into
> fs/ocfs2/dlmglue.c. All references to votes have been removed or updated.
> 

Locking looks fishy.

>
>...
>
> +static void ocfs2_downconvert_thread_do_work(struct ocfs2_super *osb)
> +{
> +	unsigned long processed;
> +	struct ocfs2_lock_res *lockres;
> +
> +	mlog_entry_void();
> +
> +	spin_lock(&osb->dc_task_lock);
> +	/* grab this early so we know to try again if a state change and
> +	 * wake happens part-way through our work  */
> +	osb->dc_work_sequence = osb->dc_wake_sequence;
> +
> +	processed = osb->blocked_lock_count;
> +	while (processed) {
> +		BUG_ON(list_empty(&osb->blocked_lock_list));
> +
> +		lockres = list_entry(osb->blocked_lock_list.next,
> +				     struct ocfs2_lock_res, l_blocked_list);
> +		list_del_init(&lockres->l_blocked_list);
> +		osb->blocked_lock_count--;
> +		spin_unlock(&osb->dc_task_lock);
> +
> +		BUG_ON(!processed);
> +		processed--;
> +
> +		ocfs2_process_blocked_lock(osb, lockres);
> +
> +		spin_lock(&osb->dc_task_lock);
> +	}
> +	spin_unlock(&osb->dc_task_lock);

Once the lock has been dropped there is (apparently) nothing to prevent
alteration of the list and of ->blocked_lock_count.  If this happens,
either items will be missed or we go BUG.

> +	mlog_exit_void();
> +}
> +
> +static int ocfs2_downconvert_thread_lists_empty(struct ocfs2_super *osb)
> +{
> +	int empty = 0;
> +
> +	spin_lock(&osb->dc_task_lock);
> +	if (list_empty(&osb->blocked_lock_list))
> +		empty = 1;
> +
> +	spin_unlock(&osb->dc_task_lock);
> +	return empty;
> +}

This function appears to be returning a value which is unreliable once the
lock was dropped.

> +static int ocfs2_downconvert_thread_should_wake(struct ocfs2_super *osb)
> +{
> +	int should_wake = 0;
> +
> +	spin_lock(&osb->dc_task_lock);
> +	if (osb->dc_work_sequence != osb->dc_wake_sequence)
> +		should_wake = 1;
> +	spin_unlock(&osb->dc_task_lock);
> +
> +	return should_wake;
> +}

Ditto.

> +int ocfs2_downconvert_thread(void *arg)
> +{
> +	int status = 0;
> +	struct ocfs2_super *osb = arg;
> +
> +	/* only quit once we've been asked to stop and there is no more
> +	 * work available */
> +	while (!(kthread_should_stop() &&
> +		 ocfs2_downconvert_thread_lists_empty(osb))) {

Extra whitespace

> +		wait_event_interruptible(osb->dc_event,
> +					 ocfs2_downconvert_thread_should_wake(osb) ||
> +					 kthread_should_stop());
> +
> +		mlog(0, "downconvert_thread: awoken\n");
> +
> +		ocfs2_downconvert_thread_do_work(osb);
> +	}
> +
> +	osb->dc_task = NULL;
> +	return status;
> +}
> +
