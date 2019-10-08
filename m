From: sunnyZhang <sunny.s.zhang@oracle.com>
Date: Tue, 8 Oct 2019 13:00:08 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: move the mlog from the spinlock to
 outside
In-Reply-To: <d57531d2-9c0c-c29f-0491-7df2f0ce97ea@linux.alibaba.com>
References: <1569813459-8601-1-git-send-email-sunny.s.zhang@oracle.com>
	<20191007151121.c0acdfe0eda4a18e1c24e141@linux-foundation.org>
	<d57531d2-9c0c-c29f-0491-7df2f0ce97ea@linux.alibaba.com>
Message-ID: <52c5a267-0410-a522-eb0f-6c5b3e03c322@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


? 2019/10/8 ??9:14, Joseph Qi ??:
>
> On 19/10/8 06:11, Andrew Morton wrote:
>> On Mon, 30 Sep 2019 11:17:39 +0800 Shuning Zhang <sunny.s.zhang@oracle.com> wrote:
>>
>>> There is a potential task of deadlock. Because the mask
>>> is 0, the deadlock does not occur now. But There is a
>>> potential task. If someone change the mask of mlog, but
>>> forget to modify the order of the mlog and spin_unlock,
>>> There will be a potential deadlock.So I move the mlog
>>> from the spinlock to outsize.
>>>
>>> ...
>>>
>>> --- a/fs/ocfs2/dlmglue.c
>>> +++ b/fs/ocfs2/dlmglue.c
>>> @@ -2315,10 +2315,10 @@ static int ocfs2_inode_lock_update(struct inode *inode,
>>>   
>>>   	spin_lock(&oi->ip_lock);
>>>   	if (oi->ip_flags & OCFS2_INODE_DELETED) {
>>> +		spin_unlock(&oi->ip_lock);
>>>   		mlog(0, "Orphaned inode %llu was deleted while we "
>>>   		     "were waiting on a lock. ip_flags = 0x%x\n",
>>>   		     (unsigned long long)oi->ip_blkno, oi->ip_flags);
>>> -		spin_unlock(&oi->ip_lock);
>>>   		status = -ENOENT;
>>>   		goto bail;
>>>   	}
>> The patch is obviously OK but I don't see any deadlock.  mlog() doesn't
>> take any locks?
>>
> I guess Shuning refers the calling of printk with spin lock.

Yes, It is the calling of printk.

Sorry for the description is not clear enough. :)

>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
