From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue, 19 May 2009 21:16:48 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: timer to queue scan of all
 orphan slots
In-Reply-To: <20090519235815.GF25521@mail.oracle.com>
References: <1242775578-16885-1-git-send-email-srinivas.eeda@oracle.com>
	<20090519235815.GF25521@mail.oracle.com>
Message-ID: <4A138430.2060004@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel,
thanks for your comments. My responses are in-line :)

Joel Becker wrote:
>> +void ocfs2_stuff_meta_lvb_mtime(struct timespec *spec,
>> +				struct ocfs2_lock_res *lockres)
>> +{
>> +	struct ocfs2_meta_lvb *lvb;
>> +	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
>> +	lvb->lvb_imtime_packed =
>> +		cpu_to_be64(ocfs2_pack_timespec(spec));
>> +}
>> +
>> +void ocfs2_get_meta_lvb_mtime(struct timespec *spec,
>> +			      struct ocfs2_lock_res *lockres)
>> +{
>> +	struct ocfs2_meta_lvb *lvb;
>> + 
>> +	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
>> +	ocfs2_unpack_timespec(spec, be64_to_cpu(lvb->lvb_imtime_packed));
>> +}
>>     
>
> 	Why not just fold these into the lock code?
>
> ocfs2_orphan_scan_lock(osb, ex, &scan_time);
> /* Do work */
> scan_time = CURRENT_TIME;
> ocfs2_orphan_scan_unlock(osb, ex, &scan_time);
>   
ok, I'll move the lvb stuff/get to orphan_orphan_scan_lock/unlock routines.
>> +/*
>> + * ocfs2_queue_delayed_orphan_scan, gets an EX lock on ds_lockres and checks
>> + * LVB for recent scan time. If scanned recently than timeout, new scans are
>> + * not queued, otherwise it queues recovery of all orphan slots and updates
>> + * LVB with CURRENT_TIME
>> + * What if the times are not in sync between nodes???
>>     
>
> 	We don't care if the times aren't in sync.  So a node is off,
> maybe we have two scans within a given timeout.  Not the end of the
> world.
>
>   
>> + */ 
>> +void ocfs2_queue_delayed_orphan_scan(struct ocfs2_super *osb)
>> +{
>> +	struct ocfs2_delayed_orphan_scan *ds;
>> +	int level = DLM_LOCK_EX;
>> +	struct timespec scan_time, now;
>> +	int status, i;
>> +
>> +	ds = osb->osb_delayed_orphan_scan;
>> +	if (!ds)
>> +		return;
>> +
>> +	status = ocfs2_orphan_scan_lock(osb, level);
>> +	if (status < 0) {
>> +		if (status != -EAGAIN)
>> +			mlog_errno(status);
>> +		goto out;
>> +	}
>> +
>> +	ocfs2_get_meta_lvb_mtime(&scan_time, &ds->ds_lockres);
>> +	if (ds->ds_time.tv_sec != scan_time.tv_sec) {
>> +		ds->ds_time = scan_time;
>> +		goto unlock;
>> +	}
>>     
>
> 	I don't get this check.  It seems to say "only run the scan if
> ds_time.tv_sec is equal to the scan_time.tv_sec in the LVB".  Is this
> saying that "after the last scan I see, I want to sleep 60s, and then
> when I wake up, I'll run the scan only if my time is still in the LVB"?
> That's not what you want.  Each node will come set their own value in
> the LVB, and they'll all never run the scan.
>   
This value is stored in node local structure not in lvb. The timer is 
fired twice within timeout(once every 15 minutes), on first time, the 
times doesn't match so the node saves the scan time and skips the scan 
and on the next time if the times match(means no node did the scan) this 
node does the scan or else it skips.

This logic allows successive scan to be done by another node and also 
avoid any race of both nodes trying at the same time.
> 	What you want is something like:
>
> 	now = CURRENT_TIME;
> 	if ((scan_time.tv_sec + SCAN_TIMEOUT) > now.tv_sec) {
> 		time_to_sleep = (scan_time + SCAN_TIMEOUT) - now;
> 		goto unlock;
>         } 
>
> This returns 'time_to_sleep' to the caller, who uses it to sleep until
> the appropriate timeout.
>   
When you say sleep, you mean schedule_delayed_work(work, time_to_sleep)?
>> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
>> index 1386281..236e80d 100644
>> --- a/fs/ocfs2/ocfs2.h
>> +++ b/fs/ocfs2/ocfs2.h
>> @@ -212,6 +212,7 @@ struct ocfs2_recovery_map;
>>  struct ocfs2_replay_map;
>>  struct ocfs2_quota_recovery;
>>  struct ocfs2_dentry_lock;
>> +struct ocfs2_delayed_orphan_scan;
>>  struct ocfs2_super
>>  {
>>  	struct task_struct *commit_task;
>> @@ -340,6 +341,7 @@ struct ocfs2_super
>>  	struct ocfs2_node_map		osb_recovering_orphan_dirs;
>>  	unsigned int			*osb_orphan_wipes;
>>  	wait_queue_head_t		osb_wipe_event;
>> +	struct ocfs2_delayed_orphan_scan *osb_delayed_orphan_scan;
>>     
>
> 	Why is this an allocated structure when it can just be part of
> ocfs2_super?
>   
I just tried to be in consistent with rest of the code, like 
ocfs2_recovery_map. But yes, I can move this to ocfs2_super.
>> @@ -104,6 +108,7 @@ static char *ocfs2_lock_type_strings[] = {
>>  	[OCFS2_LOCK_TYPE_OPEN] = "Open",
>>  	[OCFS2_LOCK_TYPE_FLOCK] = "Flock",
>>  	[OCFS2_LOCK_TYPE_QINFO] = "Quota",
>> +	[OCFS2_LOCK_TYPE_ORPHAN_SCAN] = "Orphan",
>>     
>
> 	Call it "OphanScan", you never know when we'll have a lock on
> orphans directly :-)
>   
ok, will do :)
> Joel
>   
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090519/fe98ed30/attachment.html 
