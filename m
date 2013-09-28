From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Sat, 28 Sep 2013 09:40:58 -0500
Subject: [Ocfs2-devel] [PATCH 7/7] Don't allow cluster_stack changes if
 FS are mounted
In-Reply-To: <20130927190414.GG26517@localhost>
References: <20130927171007.GA11746@shrek.lan>
	<20130927190414.GG26517@localhost>
Message-ID: <5246EA7A.2080005@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 09/27/2013 02:04 PM, Joel Becker wrote:
> I thought we already prevented this.  Why a new mechanism?
>

Yes, we don't require this. Somehow I misread the code. :(

> Joel
>
> On Fri, Sep 27, 2013 at 12:10:11PM -0500, Goldwyn Rodrigues wrote:
>> ---
>>   fs/ocfs2/dlmglue.c   |  3 ++-
>>   fs/ocfs2/stackglue.c | 18 ++++++++++++++++++
>>   fs/ocfs2/stackglue.h |  3 +++
>>   3 files changed, 23 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>> index f2d48c8..65b4280 100644
>> --- a/fs/ocfs2/dlmglue.c
>> +++ b/fs/ocfs2/dlmglue.c
>> @@ -3023,7 +3023,7 @@ local:
>>   	ocfs2_orphan_scan_lock_res_init(&osb->osb_orphan_scan.os_lockres, osb);
>>
>>   	osb->cconn = conn;
>> -
>> +	ocfs2_inc_mount_count();
>>   	status = 0;
>>   bail:
>>   	if (status < 0) {
>> @@ -3058,6 +3058,7 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
>>
>>   	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
>>   	osb->cconn = NULL;
>> +	ocfs2_dec_mount_count();
>>
>>   	ocfs2_dlm_shutdown_debug(osb);
>>   }
>> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
>> index 4dd732b..e352a2e 100644
>> --- a/fs/ocfs2/stackglue.c
>> +++ b/fs/ocfs2/stackglue.c
>> @@ -41,6 +41,7 @@ static DEFINE_SPINLOCK(ocfs2_stack_lock);
>>   static LIST_HEAD(ocfs2_stack_list);
>>   static char cluster_stack_name[OCFS2_STACK_LABEL_LEN + 1];
>>   static char ocfs2_hb_ctl_path[OCFS2_MAX_HB_CTL_PATH] = "/sbin/ocfs2_hb_ctl";
>> +static atomic_t mount_count = ATOMIC_INIT(0);
>>
>>   /*
>>    * The stack currently in use.  If not null, active_stack->sp_count > 0,
>> @@ -417,6 +418,18 @@ int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn,
>>   }
>>   EXPORT_SYMBOL_GPL(ocfs2_cluster_disconnect);
>>
>> +void ocfs2_inc_mount_count()
>> +{
>> +	atomic_inc(&mount_count);
>> +}
>> +EXPORT_SYMBOL_GPL(ocfs2_inc_mount_count);
>> +
>> +void ocfs2_dec_mount_count()
>> +{
>> +	atomic_dec(&mount_count);
>> +}
>> +EXPORT_SYMBOL_GPL(ocfs2_dec_mount_count);
>> +
>>   /*
>>    * Leave the group for this filesystem.  This is executed by a userspace
>>    * program (stored in ocfs2_hb_ctl_path).
>> @@ -569,6 +582,11 @@ static ssize_t ocfs2_cluster_stack_store(struct kobject *kobj,
>>   	size_t len = count;
>>   	ssize_t ret;
>>
>> +	if (atomic_read(&mount_count) > 0) {
>> +		printk(KERN_NOTICE "ocfs2_stackglue: Cannot set cluster_stack when filesystems are mounted.\n");
>> +		return -EINVAL;
>> +	}
>> +
>>   	if (len == 0)
>>   		return len;
>>
>> diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
>> index d3a54df..da4a913 100644
>> --- a/fs/ocfs2/stackglue.h
>> +++ b/fs/ocfs2/stackglue.h
>> @@ -293,6 +293,9 @@ int ocfs2_plock(struct ocfs2_cluster_connection *conn, u64 ino,
>>
>>   void ocfs2_stack_glue_set_max_proto_version(struct ocfs2_protocol_version *max_proto);
>>
>> +void ocfs2_inc_mount_count(void);
>> +void ocfs2_dec_mount_count(void);
>> +
>>
>>   /* Used by stack plugins */
>>   int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin);
>> --
>> 1.8.1.4
>>
>>
>> --
>> Goldwyn
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>


-- 
Goldwyn
