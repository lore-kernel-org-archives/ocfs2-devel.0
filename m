From: Changwei Ge <ge.changwei@h3c.com>
Date: Thu, 30 Nov 2017 03:01:13 +0000
Subject: [Ocfs2-devel] [PATCH v2 1/3] ocfs2: add ocfs2_try_rw_lock and
 ocfs2_try_inode_lock
References: <1511944612-9629-1-git-send-email-ghe@suse.com>
	<1511944612-9629-2-git-send-email-ghe@suse.com>
	<63ADC13FD55D6546B7DECE290D39E373F147CA86@H3CMLB14-EX.srv.huawei-3com.com>
	<5A1FE111020000F90009B606@prv-mh.provo.novell.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F1483A9C@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>, "jlbec@evilplan.org" <jlbec@evilplan.org>, "hch@lst.de" <hch@lst.de>, Goldwyn Rodrigues <RGoldwyn@suse.com>, "mfasheh@versity.com" <mfasheh@versity.com>
Cc: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi Gang,

On 2017/11/30 10:45, Gang He wrote:
> Hello Changwei,
> 
> 
>>>>
>> On 2017/11/29 16:38, Gang He wrote:
>>> Add ocfs2_try_rw_lock and ocfs2_try_inode_lock functions, which
>>> will be used in non-block IO scenarios.
>>>
>>> Signed-off-by: Gang He <ghe@suse.com>
>>> ---
>>>    fs/ocfs2/dlmglue.c | 21 +++++++++++++++++++++
>>>    fs/ocfs2/dlmglue.h |  4 ++++
>>>    2 files changed, 25 insertions(+)
>>>
>>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>>> index 4689940..a68efa3 100644
>>> --- a/fs/ocfs2/dlmglue.c
>>> +++ b/fs/ocfs2/dlmglue.c
>>> @@ -1742,6 +1742,27 @@ int ocfs2_rw_lock(struct inode *inode, int write)
>>>    	return status;
>>>    }
>>>    
>>> +int ocfs2_try_rw_lock(struct inode *inode, int write)
>>> +{
>>> +	int status, level;
>>> +	struct ocfs2_lock_res *lockres;
>>> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>>> +
>>> +	mlog(0, "inode %llu try to take %s RW lock\n",
>>> +	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
>>> +	     write ? "EXMODE" : "PRMODE");
>>> +
>>> +	if (ocfs2_mount_local(osb))
>>> +		return 0;
>>> +
>>> +	lockres = &OCFS2_I(inode)->ip_rw_lockres;
>>> +
>>> +	level = write ? DLM_LOCK_EX : DLM_LOCK_PR;
>>> +
>>> +	status = ocfs2_cluster_lock(osb, lockres, level, DLM_LKF_NOQUEUE, 0);
>>
>> Hi Gang,
>> Should we consider about passing a flag - OCFS2_LOCK_NONBLOCK to
>> ocfs2_cluster_lock. Otherwise a cluster locking progress may be waiting
>> for accomplishment of DC, which I think violates _NO_WAIT_ semantics.
> 
> If ocfs2 is a local file system, we should not wait for any condition, but for a cluster file system,
> we cannot avoid this totally according to the current DLM lock design, we need to wait for a little to get lock for the first time.
> Why do we not use OCFS2_LOCK_NONBLOCK flag to get a lock?
> since this flag is not stable to get a lock no matter this lock is occupied by other nodes, or not.
I suppose local node must be granted under the condition that it is 
marked with *OCFS2_LOCK_BLOCKED*. And the control flag 
_OCFS2_LOCK_NONBLOCK_ will make lock progress directly return -EAGAIN 
without any waiting.

> If you use OCFS2_LOCK_NONBLOCK flag to get a fresh lock, you possibly fail or success, depends on when the lock acquisition callback happens.
> So, I think DLM_LKF_NOQUEUE flag should be more matched to _NO_WAIT_ semantics.

I thinks OCFS2_LOCK_NONBLOCK doesn't conflict DLM_LKF_NOQUEUE, they are 
the forth and fifth argument respectively.

> we always get a fresh lock successfully, always failed if the lock is/was occupied by other nodes.

What do you mean by a fresh lock? A lock that is never granted or 
acquired? If a lock is marked with OCFS2_LOCK_BLOCKED, local node must 
has acquired it.

Thanks,
Changwei

> This flag can give us a consistent locking behavior.
> 
> Thanks
> Gang
> 
> 
> 
>>
>> Thanks,
>> Changwei.
>>
>>> +	return status;
>>> +}
>>> +
>>>    void ocfs2_rw_unlock(struct inode *inode, int write)
>>>    {
>>>    	int level = write ? DLM_LOCK_EX : DLM_LOCK_PR;
>>> diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
>>> index a7fc18b..05910fc 100644
>>> --- a/fs/ocfs2/dlmglue.h
>>> +++ b/fs/ocfs2/dlmglue.h
>>> @@ -116,6 +116,7 @@ void ocfs2_refcount_lock_res_init(struct ocfs2_lock_res
>> *lockres,
>>>    int ocfs2_create_new_inode_locks(struct inode *inode);
>>>    int ocfs2_drop_inode_locks(struct inode *inode);
>>>    int ocfs2_rw_lock(struct inode *inode, int write);
>>> +int ocfs2_try_rw_lock(struct inode *inode, int write);
>>>    void ocfs2_rw_unlock(struct inode *inode, int write);
>>>    int ocfs2_open_lock(struct inode *inode);
>>>    int ocfs2_try_open_lock(struct inode *inode, int write);
>>> @@ -140,6 +141,9 @@ int ocfs2_inode_lock_with_page(struct inode *inode,
>>>    /* 99% of the time we don't want to supply any additional flags --
>>>     * those are for very specific cases only. */
>>>    #define ocfs2_inode_lock(i, b, e) ocfs2_inode_lock_full_nested(i, b, e, 0,
>> OI_LS_NORMAL)
>>> +#define ocfs2_try_inode_lock(i, b, e)\
>>> +		ocfs2_inode_lock_full_nested(i, b, e, OCFS2_META_LOCK_NOQUEUE,\
>>> +		OI_LS_NORMAL)
>>>    void ocfs2_inode_unlock(struct inode *inode,
>>>    		       int ex);
>>>    int ocfs2_super_lock(struct ocfs2_super *osb,
>>>
> 
> 
