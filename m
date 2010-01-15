From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 15 Jan 2010 10:26:28 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2:freeze-thaw: initialization	and
	cleanup
In-Reply-To: <4B4FCA90.1090601@oracle.com>
References: <201001091802.o09I2ZlW017091@acsinet15.oracle.com>
	<4B4FCA90.1090601@oracle.com>
Message-ID: <20100115022628.GB3760@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

On 10-01-14 17:53, Sunil Mushran wrote:
> Wengang Wang wrote:
>> this patch does some initialization and cleanup for freeze/thaw.
>
> Please capitalize the first letter of a sentence. ;)

Ok. :)
>
>> Authored-by: Tiger Yang <tiger.yang@oracle.com>
>> Authored-by: Wengang Wang <wen.gang.wang@oracle.com>
>> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
>> ---
>>  fs/ocfs2/dlm/dlmapi.h  |    1 +
>>  fs/ocfs2/dlm/dlmlock.c |   12 ++++++++++++
>>  fs/ocfs2/dlmglue.c     |   24 ++++++++++++++++++++++++
>>  fs/ocfs2/super.c       |   21 +++++++++++++++++++++
>>  4 files changed, 58 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlm/dlmapi.h b/fs/ocfs2/dlm/dlmapi.h
>> index b5786a7..489c599 100644
>> --- a/fs/ocfs2/dlm/dlmapi.h
>> +++ b/fs/ocfs2/dlm/dlmapi.h
>> @@ -217,4 +217,5 @@ void dlm_register_eviction_cb(struct dlm_ctxt *dlm,
>>  			      struct dlm_eviction_cb *cb);
>>  void dlm_unregister_eviction_cb(struct dlm_eviction_cb *cb);
>>  +int dlm_freeze_lock_supported(struct dlm_ctxt *dlm);
>>  #endif /* DLMAPI_H */
>> diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
>> index 437698e..ad15a66 100644
>> --- a/fs/ocfs2/dlm/dlmlock.c
>> +++ b/fs/ocfs2/dlm/dlmlock.c
>> @@ -764,3 +764,15 @@ error:
>>  	return status;
>>  }
>>  EXPORT_SYMBOL_GPL(dlmlock);
>> +
>> +int dlm_freeze_lock_supported(struct dlm_ctxt *dlm)
>> +{
>> +	if (dlm->dlm_locking_proto.pv_major == 1)
>> +		return (dlm->dlm_locking_proto.pv_minor >= 1);
>> +
>> +	if (dlm->dlm_locking_proto.pv_major > 1)
>> +		return 1;
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(dlm_freeze_lock_supported);
>>   
>
> Change the fs protocol. We shouldn't need to export any symbols.

yes, as you said.
>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>> index 0caa69e..cf88af2 100644
>> --- a/fs/ocfs2/dlmglue.c
>> +++ b/fs/ocfs2/dlmglue.c
>> @@ -115,6 +115,8 @@ static int ocfs2_check_refcount_downconvert(struct ocfs2_lock_res *lockres,
>>  					    int new_level);
>>  static int ocfs2_refcount_convert_worker(struct ocfs2_lock_res *lockres,
>>  					 int blocking);
>> +static int ocfs2_check_freeze_downconvert(struct ocfs2_lock_res *lockres,
>> +					  int new_level);
>>   #define mlog_meta_lvb(__level, __lockres) 
>> ocfs2_dump_meta_lvb_info(__level, __PRETTY_FUNCTION__, __LINE__, 
>> __lockres)
>>  @@ -290,6 +292,11 @@ static struct ocfs2_lock_res_ops 
>> ocfs2_refcount_block_lops = {
>>  	.flags		= 0,
>>  };
>>  +static struct ocfs2_lock_res_ops ocfs2_freeze_lops = {
>> +	.check_downconvert = ocfs2_check_freeze_downconvert,
>> +	.flags		= 0,
>> +};
>> +
>>  static inline int ocfs2_is_inode_lock(struct ocfs2_lock_res *lockres)
>>  {
>>  	return lockres->l_type == OCFS2_LOCK_TYPE_META ||
>> @@ -722,6 +729,15 @@ void ocfs2_refcount_lock_res_init(struct ocfs2_lock_res *lockres,
>>  				   &ocfs2_refcount_block_lops, osb);
>>  }
>>  +static void ocfs2_freeze_lock_res_init(struct ocfs2_lock_res *res,
>> +				       struct ocfs2_super *osb)
>> +{
>> +	ocfs2_lock_res_init_once(res);
>> +	ocfs2_build_lock_name(OCFS2_LOCK_TYPE_FREEZE, 0, 0, res->l_name);
>> +	ocfs2_lock_res_init_common(osb, res, OCFS2_LOCK_TYPE_FREEZE,
>> +				   &ocfs2_freeze_lops, osb);
>> +}
>> +
>>  void ocfs2_lock_res_free(struct ocfs2_lock_res *res)
>>  {
>>  	mlog_entry_void();
>> @@ -3006,6 +3022,7 @@ local:
>>  	ocfs2_rename_lock_res_init(&osb->osb_rename_lockres, osb);
>>  	ocfs2_nfs_sync_lock_res_init(&osb->osb_nfs_sync_lockres, osb);
>>  	ocfs2_orphan_scan_lock_res_init(&osb->osb_orphan_scan.os_lockres, osb);
>> +	ocfs2_freeze_lock_res_init(&osb->osb_freeze_lockres, osb);
>>   	osb->cconn = conn;
>>  @@ -3043,6 +3060,7 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
>>  	ocfs2_lock_res_free(&osb->osb_rename_lockres);
>>  	ocfs2_lock_res_free(&osb->osb_nfs_sync_lockres);
>>  	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
>> +	ocfs2_lock_res_free(&osb->osb_freeze_lockres);
>>   	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
>>  	osb->cconn = NULL;
>> @@ -3228,6 +3246,7 @@ static void ocfs2_drop_osb_locks(struct ocfs2_super *osb)
>>  	ocfs2_simple_drop_lockres(osb, &osb->osb_rename_lockres);
>>  	ocfs2_simple_drop_lockres(osb, &osb->osb_nfs_sync_lockres);
>>  	ocfs2_simple_drop_lockres(osb, &osb->osb_orphan_scan.os_lockres);
>> +	ocfs2_simple_drop_lockres(osb, &osb->osb_freeze_lockres);
>>  }
>>   int ocfs2_drop_inode_locks(struct inode *inode)
>> @@ -3909,6 +3928,11 @@ void ocfs2_set_locking_protocol(void)
>>  	ocfs2_stack_glue_set_locking_protocol(&lproto);
>>  }
>>  +static int ocfs2_check_freeze_downconvert(struct ocfs2_lock_res 
>> *lockres,
>> +					  int new_level)
>> +{
>> +	return 1; //change me
>> +}
>>   
>
> If it's going to return 1 always, then we don't need it.

yes. it's changed in patch 3.
to separate big patch into sub ones, it's so written.
and until here, ocfs2_check_freeze_downconvert() shouldn't effect
anything since we don't support freeze/thaw so far to the patch.

>
>>   static void ocfs2_process_blocked_lock(struct ocfs2_super *osb,
>>  				       struct ocfs2_lock_res *lockres)
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index 14f47d2..9127760 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -134,6 +134,7 @@ static void ocfs2_destroy_inode(struct inode *inode);
>>  static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend);
>>  static int ocfs2_enable_quotas(struct ocfs2_super *osb);
>>  static void ocfs2_disable_quotas(struct ocfs2_super *osb);
>> +static int ocfs2_freeze_lock_supported(struct ocfs2_super *osb);
>>   static const struct super_operations ocfs2_sops = {
>>  	.statfs		= ocfs2_statfs,
>> @@ -1772,10 +1773,18 @@ static int ocfs2_get_sector(struct super_block *sb,
>>  	return 0;
>>  }
>>  +static int ocfs2_freeze_lock_supported(struct ocfs2_super *osb)
>> +{
>> +	if (!osb->cconn || !osb->cconn->cc_lockspace)
>> +		return 0;
>> +	return dlm_freeze_lock_supported(osb->cconn->cc_lockspace);
>> +}
>> +
>>  static int ocfs2_mount_volume(struct super_block *sb)
>>  {
>>  	int status = 0;
>>  	int unlock_super = 0;
>> +	int unlock_freeze = 0;
>>  	struct ocfs2_super *osb = OCFS2_SB(sb);
>>   	mlog_entry_void();
>> @@ -1796,6 +1805,15 @@ static int ocfs2_mount_volume(struct super_block *sb)
>>  	}
>>  	unlock_super = 1;
>>  +	if (ocfs2_freeze_lock_supported(osb)) {
>> +		status = ocfs2_freeze_lock(osb, 0);
>> +		if (status < 0) {
>> +			mlog_errno(status);
>> +			goto leave;
>> +		}
>> +		unlock_freeze = 1;
>> +	}
>> +
>>  	/* This will load up the node map and add ourselves to it. */
>>  	status = ocfs2_find_slot(osb);
>>  	if (status < 0) {
>> @@ -1821,6 +1839,9 @@ static int ocfs2_mount_volume(struct super_block *sb)
>>  		mlog_errno(status);
>>   leave:
>> +	if (ocfs2_freeze_lock_supported(osb) && unlock_freeze)
>> +		ocfs2_freeze_unlock(osb, 0);
>> +
>>  	if (unlock_super)
>>  		ocfs2_super_unlock(osb, 1);
>>   
>
> What about cleanup in umount?

if you meant ocfs2_freeze_unlock() in ocfs2_umount_volume() instead of
at the end of ocfs2_mount_volume(), it's NG.
if cleanup when umount, then we always have a ro_holder, freeze/thaw
doesn't work.

and we dont need to clean it up in umount if we already cleanup it in
mount_volume. this is because the lock/unlock is used in pairs.

regards,
wengang.
>
>>    
>
