From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 09 Jun 2009 16:47:14 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: timer to queue scan of all
 orphan slots
In-Reply-To: <1244097623-1826-2-git-send-email-srinivas.eeda@oracle.com>
References: <1244097623-1826-1-git-send-email-srinivas.eeda@oracle.com>
	<1244097623-1826-2-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <4A2EF482.2080202@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Srini,

I was re-reviewing these patches as part of 1.4 merge and something
caught my eye. Specifically that this may slowdown umount unnecessarily.

Consider the case if scan_work() is fired a tick before scan_stop().
Currently, scan_stop() will cancel the newly queued scan_work() but do
nothing to the tasks queued by the earlier fire. umount thread will have
to wait for all those tasks to complete.

One solution is to add a flag, atomic_t os_stop_scan, in struct
ocfs2_orphan_scan. Call atomic_set() at the top of ocfs2_orphan_scan_stop().
In ocfs2_queue_orphan_scan(), check if the flag is set before and after
ocfs2_orphan_scan_lock(). If set, exit without queuing the tasks.

Secondly, call scan_stop() earlier in umount. Definitely before truncatelog
shutdown. Actually make it even before localalloc shutdown.

Make the patch atop what is in Joel's git tree already.

Thanks
Sunil

Srinivas Eeda wrote:
> +void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
> +{
> +	struct ocfs2_orphan_scan *os;
> +	int status, i;
> +	u32 seqno = 0;
> +
> +	os = &osb->osb_orphan_scan;
> +
> +	status = ocfs2_orphan_scan_lock(osb, &seqno, LKM_EXMODE);
> +	if (status < 0) {
> +		if (status != -EAGAIN)
> +			mlog_errno(status);
> +		goto out;
> +	}
> +
> +	if (os->os_seqno != seqno) {
> +		os->os_seqno = seqno;
> +		goto unlock;
> +	}
> +
> +	for (i = 0; i < osb->max_slots; i++)
> +		ocfs2_queue_recovery_completion(osb->journal, i, NULL, NULL);
> +
> +	/*
> +	 * We queued a recovery on orphan slots, increment the sequence
> +	 * number and update LVB so other node will skip the scan for a while
> +	 */
> +	seqno++;
> +unlock:
> +	ocfs2_orphan_scan_unlock(osb, seqno, LKM_EXMODE);
> +out:
> +	return;
> +}
> +
> +/* Worker task that gets fired every ORPHAN_SCAN_SCHEDULE_TIMEOUT millsec */
> +void ocfs2_orphan_scan_work(kapi_work_struct_t *work)
> +{
> +	struct ocfs2_orphan_scan *os;
> +	struct ocfs2_super *osb;
> +
> +	os = work_to_object(work, struct ocfs2_orphan_scan,
> +			  os_orphan_scan_work.work);
> +	osb = os->os_osb;
> +
> +	mutex_lock(&os->os_lock);
> +	ocfs2_queue_orphan_scan(osb);
> +	schedule_delayed_work(&os->os_orphan_scan_work,
> +			      ocfs2_orphan_scan_timeout());
> +	mutex_unlock(&os->os_lock);
> +}
> +
> +void ocfs2_orphan_scan_stop(struct ocfs2_super *osb)
> +{
> +	struct ocfs2_orphan_scan *os;
> +
> +	os = &osb->osb_orphan_scan;
> +	mutex_lock(&os->os_lock);
> +	cancel_delayed_work(&os->os_orphan_scan_work);
> +	mutex_unlock(&os->os_lock);
> +}
> +
> +int ocfs2_orphan_scan_init(struct ocfs2_super *osb)
> +{
> +	struct ocfs2_orphan_scan *os;
> +
> +	os = &osb->osb_orphan_scan;
> +	os->os_osb = osb;
> +	mutex_init(&os->os_lock);
> +
> +	KAPI_INIT_DELAYED_WORK(&os->os_orphan_scan_work,
> +			  ocfs2_orphan_scan_work, os);
> +	schedule_delayed_work(&os->os_orphan_scan_work,
> +			      ocfs2_orphan_scan_timeout());
> +	return 0;
> +}
> +
>   




> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index e84185d..7989966 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -145,6 +145,14 @@ struct ocfs2_lock_res {
>  #endif
>  };
>  
> +struct ocfs2_orphan_scan {
> +	struct mutex 		os_lock;
> +	struct ocfs2_super 	*os_osb;
> +	struct ocfs2_lock_res 	os_lockres;     /* lock to synchronize scans */
> +	struct delayed_work 	os_orphan_scan_work;
> +	u32                     os_seqno;       /* incremented on every scan */
> +};
> +
>   







> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index a421e7d..cd66b4d 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1495,6 +1495,8 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
>  
>  	ocfs2_truncate_log_shutdown(osb);
>  
> +	ocfs2_orphan_scan_stop(osb);
> +
>  	/* disable any new recovery threads and wait for any currently
>  	 * running ones to exit. Do this before setting the vol_state. */
>  	mutex_lock(&osb->recovery_lock);
> @@ -1640,6 +1642,13 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	osb->disable_recovery = 0;
>  	osb->recovery_thread_task = NULL;
>  
> +	status = ocfs2_orphan_scan_init(osb);
> +	if (status) {
> +		mlog(ML_ERROR, "Unable to initialize delayed orphan scan\n");
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +
>  	init_waitqueue_head(&osb->checkpoint_event);
>  	atomic_set(&osb->needs_checkpoint, 0); 
>   
