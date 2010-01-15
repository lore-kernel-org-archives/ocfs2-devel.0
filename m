From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 15 Jan 2010 10:28:17 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2:freeze-thaw: add freeze	cluster
	lock
In-Reply-To: <4B4FC948.7020800@oracle.com>
References: <201001091802.o09I2Z1v013097@rcsinet13.oracle.com>
	<4B4FC948.7020800@oracle.com>
Message-ID: <20100115022817.GC3760@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

On 10-01-14 17:47, Sunil Mushran wrote:
> Wengang Wang wrote:
>> add cluster lock for freeze/thaw.
>> change dlm version from 1.0 to 1.1
>>
>> Authored-by: Tiger Yang <tiger.yang@oracle.com>
>> Authored-by: Wengang Wang <wen.gang.wang@oracle.com>
>> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
>>   
>
> Removed Authored by tags. Just note that these patches
> were originally authored by Tiger.

Ok, sure.
>
>> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
>> index 0334000..6e8bcb6 100644
>> --- a/fs/ocfs2/dlm/dlmdomain.c
>> +++ b/fs/ocfs2/dlm/dlmdomain.c
>> @@ -128,10 +128,14 @@ static DECLARE_WAIT_QUEUE_HEAD(dlm_domain_events);
>>   * will have a negotiated version with the same major number and a minor
>>   * number equal or smaller.  The dlm_ctxt->dlm_locking_proto field should
>>   * be used to determine what a running domain is actually using.
>> + *
>> + * dlm protocal history:
>> + * 1.0:	base
>> + * 1.1:	freeze lock support added
>>   */
>>  static const struct dlm_protocol_version dlm_protocol = {
>>  	.pv_major = 1,
>> -	.pv_minor = 0,
>> +	.pv_minor = 1,
>>  };
>>   
>
> Sorry. I told you to change the dlm protocol. But it should
> be the fs protocol as we are adding a new lock type. We would
> change the dlm protocol if were were adding a new dlm message
> type, etc.
>
> Same change. Up the minor by one.

Ok.
>>   #define DLM_DOMAIN_BACKOFF_MS 200
>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>> index c5e4a49..0caa69e 100644
>> --- a/fs/ocfs2/dlmglue.c
>> +++ b/fs/ocfs2/dlmglue.c
>> @@ -2894,6 +2894,34 @@ static const struct file_operations ocfs2_dlm_debug_fops = {
>>  	.llseek =	seq_lseek,
>>  };
>>  +int ocfs2_freeze_lock(struct ocfs2_super *osb, int ex)
>> +{
>> +	int ret;
>> +	int level = ex ? LKM_EXMODE : LKM_PRMODE;
>> +	struct ocfs2_lock_res *lockres = &osb->osb_freeze_lockres;
>> +
>> +	if (ocfs2_is_hard_readonly(osb))
>> +		return -EROFS;
>> +
>> +	if (ocfs2_mount_local(osb))
>> +		return 0;
>> +
>> +	ret = ocfs2_cluster_lock(osb, lockres, level, 0, 0);
>> +	if (ret < 0)
>> +		mlog_errno(ret);
>> +
>> +	return ret;
>> +}
>> +
>> +void ocfs2_freeze_unlock(struct ocfs2_super *osb, int ex)
>> +{
>> +	int level = ex ? LKM_EXMODE : LKM_PRMODE;
>> +	struct ocfs2_lock_res *lockres = &osb->osb_freeze_lockres;
>> +
>> +	if (!ocfs2_mount_local(osb))
>> +		ocfs2_cluster_unlock(osb, lockres, level);
>> +}
>> +
>>  static int ocfs2_dlm_init_debug(struct ocfs2_super *osb)
>>  {
>>  	int ret = 0;
>> diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
>> index d1ce48e..8687b81 100644
>> --- a/fs/ocfs2/dlmglue.h
>> +++ b/fs/ocfs2/dlmglue.h
>> @@ -155,6 +155,8 @@ struct ocfs2_refcount_tree;
>>  int ocfs2_refcount_lock(struct ocfs2_refcount_tree *ref_tree, int ex);
>>  void ocfs2_refcount_unlock(struct ocfs2_refcount_tree *ref_tree, int ex);
>>  +int ocfs2_freeze_lock(struct ocfs2_super *osb, int ex);
>> +void ocfs2_freeze_unlock(struct ocfs2_super *osb, int ex);
>>   void ocfs2_mark_lockres_freeing(struct ocfs2_lock_res *lockres);
>>  void ocfs2_simple_drop_lockres(struct ocfs2_super *osb,
>> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
>> index d963d86..bf66978 100644
>> --- a/fs/ocfs2/ocfs2.h
>> +++ b/fs/ocfs2/ocfs2.h
>> @@ -355,6 +355,7 @@ struct ocfs2_super
>>  	struct ocfs2_lock_res osb_super_lockres;
>>  	struct ocfs2_lock_res osb_rename_lockres;
>>  	struct ocfs2_lock_res osb_nfs_sync_lockres;
>> +	struct ocfs2_lock_res osb_freeze_lockres;
>>  	struct ocfs2_dlm_debug *osb_dlm_debug;
>>   	struct dentry *osb_debug_root;
>> diff --git a/fs/ocfs2/ocfs2_lockid.h b/fs/ocfs2/ocfs2_lockid.h
>> index d277aab..3c29924 100644
>> --- a/fs/ocfs2/ocfs2_lockid.h
>> +++ b/fs/ocfs2/ocfs2_lockid.h
>> @@ -50,6 +50,7 @@ enum ocfs2_lock_type {
>>  	OCFS2_LOCK_TYPE_NFS_SYNC,
>>  	OCFS2_LOCK_TYPE_ORPHAN_SCAN,
>>  	OCFS2_LOCK_TYPE_REFCOUNT,
>> +	OCFS2_LOCK_TYPE_FREEZE,
>>  	OCFS2_NUM_LOCK_TYPES
>>  };
>>   
>
> OCFS2_LOCK_TYPE_FREEZEFS sounds better.

Ok.
>> @@ -93,6 +94,9 @@ static inline char ocfs2_lock_type_char(enum ocfs2_lock_type type)
>>  		case OCFS2_LOCK_TYPE_REFCOUNT:
>>  			c = 'T';
>>  			break;
>> +		case OCFS2_LOCK_TYPE_FREEZE:
>> +			c = 'Z';
>> +			break;
>>  		default:
>>  			c = '\0';
>>  	}
>> @@ -115,6 +119,7 @@ static char *ocfs2_lock_type_strings[] = {
>>  	[OCFS2_LOCK_TYPE_NFS_SYNC] = "NFSSync",
>>  	[OCFS2_LOCK_TYPE_ORPHAN_SCAN] = "OrphanScan",
>>  	[OCFS2_LOCK_TYPE_REFCOUNT] = "Refcount",
>> +	[OCFS2_LOCK_TYPE_FREEZE] = "Freeze",
>>  };
>>   static inline const char *ocfs2_lock_type_string(enum ocfs2_lock_type 
>> type)
>>   
>

I will post the version 2 after all v1 patches commented.

regards,
wengang.
