From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 24 May 2019 12:52:41 -0700
Subject: [Ocfs2-devel] [PATCH V3 2/2] ocfs2: add locking filter debugfs
 file
In-Reply-To: <5CE753AB020000F900067E5D@prv1-mh.provo.novell.com>
References: <20190523104047.14794-1-ghe@suse.com>
	<20190523104047.14794-2-ghe@suse.com>
	<da93442d-3333-5bd6-ce0a-edb66a58109d@oracle.com>
	<5CE753AB020000F900067E5D@prv1-mh.provo.novell.com>
Message-ID: <bcdefc65-7173-8911-3ba1-197b064b5fa5@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>
Cc: jlbec@evilplan.org, mark@fasheh.com, jiangqi903@gmail.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Hi Gang,

OK, I was thinking you are dumping the new last access time field too.

thanks,
wengang

On 2019/5/23 19:15, Gang He wrote:
> Hello Wengang,
>
> This patch is used to add a filter attribute(the default value is 0), the kernel module can use this attribute value to filter the lock resources dumping.
> By default(the value is 0), the kernel module does not filter any lock resources dumping, the behavior is like before.
> If the user set a value(N) of this attribute, the kernel module will only dump the latest N seconds active lock resources, this will avoid dumping lots of inactive lock resources.
>
> Thanks
> Gang
>
>>>> On 2019/5/24 at 0:43, in message
> <da93442d-3333-5bd6-ce0a-edb66a58109d@oracle.com>, Wengang
> <wen.gang.wang@oracle.com> wrote:
>> Hi Gang,
>>
>> Could you paste an example of outputs before patch VS that after patch?
>> I think that would directly show what the patch does.
>>
>> thanks,
>> wengang
>>
>> On 05/23/2019 03:40 AM, Gang He wrote:
>>> Add locking filter debugfs file, which is used to filter lock
>>> resources dump from locking_state debugfs file.
>>> We use d_filter_secs field to filter lock resources dump,
>>> the default d_filter_secs(0) value filters nothing,
>>> otherwise, only dump the last N seconds active lock resources.
>>> This enhancement can avoid dumping lots of old records.
>>> The d_filter_secs value can be changed via locking_filter file.
>>>
>>> Compared with v2, ocfs2_dlm_init_debug() returns directly with
>>> error when creating locking filter debugfs file is failed, since
>>> ocfs2_dlm_shutdown_debug() will handle this failure perfectly.
>>> Compared with v1, the main change is to add CONFIG_OCFS2_FS_STATS
>>> macro definition judgment.
>>>
>>> Signed-off-by: Gang He <ghe@suse.com>
>>> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>>> ---
>>>    fs/ocfs2/dlmglue.c | 36 ++++++++++++++++++++++++++++++++++++
>>>    fs/ocfs2/ocfs2.h   |  2 ++
>>>    2 files changed, 38 insertions(+)
>>>
>>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>>> index dccf4136f8c1..fbe4562cf4fe 100644
>>> --- a/fs/ocfs2/dlmglue.c
>>> +++ b/fs/ocfs2/dlmglue.c
>>> @@ -3006,6 +3006,8 @@ struct ocfs2_dlm_debug *ocfs2_new_dlm_debug(void)
>>>    	kref_init(&dlm_debug->d_refcnt);
>>>    	INIT_LIST_HEAD(&dlm_debug->d_lockres_tracking);
>>>    	dlm_debug->d_locking_state = NULL;
>>> +	dlm_debug->d_locking_filter = NULL;
>>> +	dlm_debug->d_filter_secs = 0;
>>>    out:
>>>    	return dlm_debug;
>>>    }
>>> @@ -3104,11 +3106,33 @@ static int ocfs2_dlm_seq_show(struct seq_file *m,
>> void *v)
>>>    {
>>>    	int i;
>>>    	char *lvb;
>>> +	u32 now, last = 0;
>>>    	struct ocfs2_lock_res *lockres = v;
>>> +	struct ocfs2_dlm_debug *dlm_debug =
>>> +			((struct ocfs2_dlm_seq_priv *)m->private)->p_dlm_debug;
>>>    
>>>    	if (!lockres)
>>>    		return -EINVAL;
>>>    
>>> +	if (dlm_debug->d_filter_secs) {
>>> +		now = ktime_to_timespec(ktime_get()).tv_sec;
>>> +#ifdef CONFIG_OCFS2_FS_STATS
>>> +		if (lockres->l_lock_prmode.ls_last >
>>> +		    lockres->l_lock_exmode.ls_last)
>>> +			last = lockres->l_lock_prmode.ls_last;
>>> +		else
>>> +			last = lockres->l_lock_exmode.ls_last;
>>> +#endif
>>> +		/*
>>> +		 * Use d_filter_secs field to filter lock resources dump,
>>> +		 * the default d_filter_secs(0) value filters nothing,
>>> +		 * otherwise, only dump the last N seconds active lock
>>> +		 * resources.
>>> +		 */
>>> +		if ((now - last) > dlm_debug->d_filter_secs)
>>> +			return 0;
>>> +	}
>>> +
>>>    	seq_printf(m, "0x%x\t", OCFS2_DLM_DEBUG_STR_VERSION);
>>>    
>>>    	if (lockres->l_type == OCFS2_LOCK_TYPE_DENTRY)
>>> @@ -3258,6 +3282,17 @@ static int ocfs2_dlm_init_debug(struct ocfs2_super
>> *osb)
>>>    		goto out;
>>>    	}
>>>    
>>> +	dlm_debug->d_locking_filter = debugfs_create_u32("locking_filter",
>>> +						0600,
>>> +						osb->osb_debug_root,
>>> +						&dlm_debug->d_filter_secs);
>>> +	if (!dlm_debug->d_locking_filter) {
>>> +		ret = -EINVAL;
>>> +		mlog(ML_ERROR,
>>> +		     "Unable to create locking filter debugfs file.\n");
>>> +		goto out;
>>> +	}
>>> +
>>>    	ocfs2_get_dlm_debug(dlm_debug);
>>>    out:
>>>    	return ret;
>>> @@ -3269,6 +3304,7 @@ static void ocfs2_dlm_shutdown_debug(struct
>> ocfs2_super *osb)
>>>    
>>>    	if (dlm_debug) {
>>>    		debugfs_remove(dlm_debug->d_locking_state);
>>> +		debugfs_remove(dlm_debug->d_locking_filter);
>>>    		ocfs2_put_dlm_debug(dlm_debug);
>>>    	}
>>>    }
>>> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
>>> index 8efa022684f4..f4da51099889 100644
>>> --- a/fs/ocfs2/ocfs2.h
>>> +++ b/fs/ocfs2/ocfs2.h
>>> @@ -237,6 +237,8 @@ struct ocfs2_orphan_scan {
>>>    struct ocfs2_dlm_debug {
>>>    	struct kref d_refcnt;
>>>    	struct dentry *d_locking_state;
>>> +	struct dentry *d_locking_filter;
>>> +	u32 d_filter_secs;
>>>    	struct list_head d_lockres_tracking;
>>>    };
>>>    
