From: Gang He <ghe@suse.com>
Date: Wed, 10 Jan 2018 01:40:34 -0700
Subject: [Ocfs2-devel] [PATCH v2 1/2] ocfs2: add trimfs dlm lock resource
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373F290E6DD@H3CMLB12-EX.srv.huawei-3com.com>
References: <1513228484-2084-1-git-send-email-ghe@suse.com>
	<63ADC13FD55D6546B7DECE290D39E373F290E6DD@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <5A564202020000F9000A2900@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jlbec@evilplan.org, ge.changwei@h3c.com, mfasheh@versity.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Hi Changwei,


>>> 
> Hi Gang,
> 
> On 2017/12/14 13:16, Gang He wrote:
>> Introduce a new dlm lock resource, which will be used to
>> communicate during fstrim a ocfs2 device from cluster nodes.
>> 
>> Signed-off-by: Gang He <ghe@suse.com>
>> ---
>>   fs/ocfs2/dlmglue.c      | 86 
> +++++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/ocfs2/dlmglue.h      | 29 +++++++++++++++++
>>   fs/ocfs2/ocfs2.h        |  1 +
>>   fs/ocfs2/ocfs2_lockid.h |  5 +++
>>   4 files changed, 121 insertions(+)
>> 
>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>> index 4689940..5615747 100644
>> --- a/fs/ocfs2/dlmglue.c
>> +++ b/fs/ocfs2/dlmglue.c
>> @@ -259,6 +259,10 @@ struct ocfs2_lock_res_ops {
>>   	.flags		= 0,
>>   };
>>   
>> +static struct ocfs2_lock_res_ops ocfs2_trim_fs_lops = {
>> +	.flags		= LOCK_TYPE_REQUIRES_REFRESH|LOCK_TYPE_USES_LVB,
> 
> Um, I don't think it is proper to add flag LOCK_TYPE_REQUIRES_REFRESH.
> Because it seems that trimfs procedure doesn't have to persist stuff into 
> disk.
I just copy for the ocfs2_orphan_scan_lops code, maybe the flag is not necessary,
I will look at the related code, then give a feedback.

Thanks
Gang 

> 
> Thanks,
> Changwei
> 
>> +};
>> +
>>   static struct ocfs2_lock_res_ops ocfs2_orphan_scan_lops = {
>>   	.flags		= LOCK_TYPE_REQUIRES_REFRESH|LOCK_TYPE_USES_LVB,
>>   };
>> @@ -676,6 +680,24 @@ static void ocfs2_nfs_sync_lock_res_init(struct 
> ocfs2_lock_res *res,
>>   				   &ocfs2_nfs_sync_lops, osb);
>>   }
>>   
>> +void ocfs2_trim_fs_lock_res_init(struct ocfs2_super *osb)
>> +{
>> +	struct ocfs2_lock_res *lockres = &osb->osb_trim_fs_lockres;
>> +
>> +	ocfs2_lock_res_init_once(lockres);
>> +	ocfs2_build_lock_name(OCFS2_LOCK_TYPE_TRIM_FS, 0, 0, lockres->l_name);
>> +	ocfs2_lock_res_init_common(osb, lockres, OCFS2_LOCK_TYPE_TRIM_FS,
>> +				   &ocfs2_trim_fs_lops, osb);
>> +}
>> +
>> +void ocfs2_trim_fs_lock_res_uninit(struct ocfs2_super *osb)
>> +{
>> +	struct ocfs2_lock_res *lockres = &osb->osb_trim_fs_lockres;
>> +
>> +	ocfs2_simple_drop_lockres(osb, lockres);
>> +	ocfs2_lock_res_free(lockres);
>> +}
>> +
>>   static void ocfs2_orphan_scan_lock_res_init(struct ocfs2_lock_res *res,
>>   					    struct ocfs2_super *osb)
>>   {
>> @@ -2745,6 +2767,70 @@ void ocfs2_nfs_sync_unlock(struct ocfs2_super *osb, 
> int ex)
>>   				     ex ? LKM_EXMODE : LKM_PRMODE);
>>   }
>>   
>> +int ocfs2_trim_fs_lock(struct ocfs2_super *osb,
>> +		       struct ocfs2_trim_fs_info *info, int trylock)
>> +{
>> +	int status;
>> +	struct ocfs2_trim_fs_lvb *lvb;
>> +	struct ocfs2_lock_res *lockres = &osb->osb_trim_fs_lockres;
>> +
>> +	if (info)
>> +		info->tf_valid = 0;
>> +
>> +	if (ocfs2_is_hard_readonly(osb))
>> +		return -EROFS;
>> +
>> +	if (ocfs2_mount_local(osb))
>> +		return 0;
>> +
>> +	status = ocfs2_cluster_lock(osb, lockres, DLM_LOCK_EX,
>> +				    trylock ? DLM_LKF_NOQUEUE : 0, 0);
>> +	if (status < 0) {
>> +		if (status != -EAGAIN)
>> +			mlog_errno(status);
>> +		return status;
>> +	}
>> +
>> +	if (info) {
>> +		lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
>> +		if (ocfs2_dlm_lvb_valid(&lockres->l_lksb) &&
>> +		    lvb->lvb_version == OCFS2_TRIMFS_LVB_VERSION) {
>> +			info->tf_valid = 1;
>> +			info->tf_success = lvb->lvb_success;
>> +			info->tf_nodenum = be32_to_cpu(lvb->lvb_nodenum);
>> +			info->tf_start = be64_to_cpu(lvb->lvb_start);
>> +			info->tf_len = be64_to_cpu(lvb->lvb_len);
>> +			info->tf_minlen = be64_to_cpu(lvb->lvb_minlen);
>> +			info->tf_trimlen = be64_to_cpu(lvb->lvb_trimlen);
>> +		}
>> +	}
>> +
>> +	return status;
>> +}
>> +
>> +void ocfs2_trim_fs_unlock(struct ocfs2_super *osb,
>> +			  struct ocfs2_trim_fs_info *info)
>> +{
>> +	struct ocfs2_trim_fs_lvb *lvb;
>> +	struct ocfs2_lock_res *lockres = &osb->osb_trim_fs_lockres;
>> +
>> +	if (ocfs2_mount_local(osb))
>> +		return;
>> +
>> +	if (info) {
>> +		lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
>> +		lvb->lvb_version = OCFS2_TRIMFS_LVB_VERSION;
>> +		lvb->lvb_success = info->tf_success;
>> +		lvb->lvb_nodenum = cpu_to_be32(info->tf_nodenum);
>> +		lvb->lvb_start = cpu_to_be64(info->tf_start);
>> +		lvb->lvb_len = cpu_to_be64(info->tf_len);
>> +		lvb->lvb_minlen = cpu_to_be64(info->tf_minlen);
>> +		lvb->lvb_trimlen = cpu_to_be64(info->tf_trimlen);
>> +	}
>> +
>> +	ocfs2_cluster_unlock(osb, lockres, DLM_LOCK_EX);
>> +}
>> +
>>   int ocfs2_dentry_lock(struct dentry *dentry, int ex)
>>   {
>>   	int ret;
>> diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
>> index a7fc18b..2253688 100644
>> --- a/fs/ocfs2/dlmglue.h
>> +++ b/fs/ocfs2/dlmglue.h
>> @@ -70,6 +70,29 @@ struct ocfs2_orphan_scan_lvb {
>>   	__be32	lvb_os_seqno;
>>   };
>>   
>> +#define OCFS2_TRIMFS_LVB_VERSION 1
>> +
>> +struct ocfs2_trim_fs_lvb {
>> +	__u8	lvb_version;
>> +	__u8	lvb_success;
>> +	__u8	lvb_reserved[2];
>> +	__be32	lvb_nodenum;
>> +	__be64	lvb_start;
>> +	__be64	lvb_len;
>> +	__be64	lvb_minlen;
>> +	__be64	lvb_trimlen;
>> +};
>> +
>> +struct ocfs2_trim_fs_info {
>> +	u8	tf_valid;	/* lvb is valid, or not */
>> +	u8	tf_success;	/* trim is successful, or not */
>> +	u32	tf_nodenum;	/* osb node number */
>> +	u64	tf_start;	/* trim start offset in clusters */
>> +	u64	tf_len;		/* trim end offset in clusters */
>> +	u64	tf_minlen;	/* trim minimum contiguous free clusters */
>> +	u64	tf_trimlen;	/* trimmed length in bytes */
>> +};
>> +
>>   struct ocfs2_lock_holder {
>>   	struct list_head oh_list;
>>   	struct pid *oh_owner_pid;
>> @@ -153,6 +176,12 @@ void ocfs2_super_unlock(struct ocfs2_super *osb,
>>   void ocfs2_rename_unlock(struct ocfs2_super *osb);
>>   int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex);
>>   void ocfs2_nfs_sync_unlock(struct ocfs2_super *osb, int ex);
>> +void ocfs2_trim_fs_lock_res_init(struct ocfs2_super *osb);
>> +void ocfs2_trim_fs_lock_res_uninit(struct ocfs2_super *osb);
>> +int ocfs2_trim_fs_lock(struct ocfs2_super *osb,
>> +		       struct ocfs2_trim_fs_info *info, int trylock);
>> +void ocfs2_trim_fs_unlock(struct ocfs2_super *osb,
>> +			  struct ocfs2_trim_fs_info *info);
>>   int ocfs2_dentry_lock(struct dentry *dentry, int ex);
>>   void ocfs2_dentry_unlock(struct dentry *dentry, int ex);
>>   int ocfs2_file_lock(struct file *file, int ex, int trylock);
>> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
>> index 9a50f22..6867eef 100644
>> --- a/fs/ocfs2/ocfs2.h
>> +++ b/fs/ocfs2/ocfs2.h
>> @@ -404,6 +404,7 @@ struct ocfs2_super
>>   	struct ocfs2_lock_res osb_super_lockres;
>>   	struct ocfs2_lock_res osb_rename_lockres;
>>   	struct ocfs2_lock_res osb_nfs_sync_lockres;
>> +	struct ocfs2_lock_res osb_trim_fs_lockres;
>>   	struct ocfs2_dlm_debug *osb_dlm_debug;
>>   
>>   	struct dentry *osb_debug_root;
>> diff --git a/fs/ocfs2/ocfs2_lockid.h b/fs/ocfs2/ocfs2_lockid.h
>> index d277aab..7051b99 100644
>> --- a/fs/ocfs2/ocfs2_lockid.h
>> +++ b/fs/ocfs2/ocfs2_lockid.h
>> @@ -50,6 +50,7 @@ enum ocfs2_lock_type {
>>   	OCFS2_LOCK_TYPE_NFS_SYNC,
>>   	OCFS2_LOCK_TYPE_ORPHAN_SCAN,
>>   	OCFS2_LOCK_TYPE_REFCOUNT,
>> +	OCFS2_LOCK_TYPE_TRIM_FS,
>>   	OCFS2_NUM_LOCK_TYPES
>>   };
>>   
>> @@ -93,6 +94,9 @@ static inline char ocfs2_lock_type_char(enum 
> ocfs2_lock_type type)
>>   		case OCFS2_LOCK_TYPE_REFCOUNT:
>>   			c = 'T';
>>   			break;
>> +		case OCFS2_LOCK_TYPE_TRIM_FS:
>> +			c = 'I';
>> +			break;
>>   		default:
>>   			c = '\0';
>>   	}
>> @@ -115,6 +119,7 @@ static inline char ocfs2_lock_type_char(enum 
> ocfs2_lock_type type)
>>   	[OCFS2_LOCK_TYPE_NFS_SYNC] = "NFSSync",
>>   	[OCFS2_LOCK_TYPE_ORPHAN_SCAN] = "OrphanScan",
>>   	[OCFS2_LOCK_TYPE_REFCOUNT] = "Refcount",
>> +	[OCFS2_LOCK_TYPE_TRIM_FS] = "TrimFs",
>>   };
>>   
>>   static inline const char *ocfs2_lock_type_string(enum ocfs2_lock_type 
> type)
>> 
