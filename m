From: Joseph Qi <jiangqi903@gmail.com>
Date: Tue, 26 Dec 2017 14:10:05 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: return -EROFS to upper if inode
	block is invalid
In-Reply-To: <5A41DFBD.5080704@huawei.com>
References: <5A41AFE2.5010506@huawei.com>
	<bfb98dd0-0957-2282-591d-7553d8ded263@gmail.com>
	<5A41DFBD.5080704@huawei.com>
Message-ID: <57d632e3-bb5b-3b5a-102f-d7d541f83587@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 17/12/26 13:35, piaojun wrote:
> Hi Joseph,
> 
> On 2017/12/26 11:05, Joseph Qi wrote:
>>
>>
>> On 17/12/26 10:11, piaojun wrote:
>>> If metadata is corrupted such as 'invalid inode block', we will get
>>> failed by calling 'mount()' as below:
>>>
>>> ocfs2_mount
>>>   ocfs2_initialize_super
>>>     ocfs2_init_global_system_inodes : return -EINVAL if inode is NULL
>>>       ocfs2_get_system_file_inode
>>>         _ocfs2_get_system_file_inode : return NULL if inode is errno
>> Do you mean inode is bad?
>>
> Here we have to face two abnormal cases:
> 1. inode is bad;
> 2. read inode from disk failed due to bad storage link.
>>>           ocfs2_iget
>>>             ocfs2_read_locked_inode
>>>               ocfs2_validate_inode_block
>>>
>>> In this situation we need return -EROFS to upper application, so that
>>> user can fix it by fsck. And then mount again.
>>>
>>> Signed-off-by: Jun Piao <piaojun@huawei.com>
>>> Reviewed-by: Alex Chen <alex.chen@huawei.com>
>>> ---
>>>  fs/ocfs2/super.c | 10 ++++++++--
>>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>>> index 040bbb6..dea21a7 100644
>>> --- a/fs/ocfs2/super.c
>>> +++ b/fs/ocfs2/super.c
>>> @@ -474,7 +474,10 @@ static int ocfs2_init_global_system_inodes(struct ocfs2_super *osb)
>>>  		new = ocfs2_get_system_file_inode(osb, i, osb->slot_num);
>>>  		if (!new) {
>>>  			ocfs2_release_system_inodes(osb);
>>> -			status = -EINVAL;
>>> +			if (ocfs2_is_soft_readonly(osb))
>> I'm afraid that having bad inode doesn't means ocfs2 is readonly.
>> And the calling application is mount.ocfs2. So do you mean mount.ocfs2
>> have to handle EROFS like printing corresponding error log?
>>
> I agree that 'bad inode' also means other abnormal cases like
> 'bad storage link' or 'no memory', but we can distinguish that by
> ocfs2_is_soft_readonly(). I found that 'mount.ocfs2' did not
> distinguish any error type and just return 1 for all error cases. I
> wonder if we should return the exact errno for users?
> Soft readonly is an in-memory status. The case you described is just
trying to read inode and then check if it is bad. So where to set the
status before?

> thanks,
> Jun
> 
>>> +				status = -EROFS;
>>> +			else
>>> +				status = -EINVAL;
>>>  			mlog_errno(status);
>>>  			/* FIXME: Should ERROR_RO_FS */
>>>  			mlog(ML_ERROR, "Unable to load system inode %d, "
>>> @@ -505,7 +508,10 @@ static int ocfs2_init_local_system_inodes(struct ocfs2_super *osb)
>>>  		new = ocfs2_get_system_file_inode(osb, i, osb->slot_num);
>>>  		if (!new) {
>>>  			ocfs2_release_system_inodes(osb);
>>> -			status = -EINVAL;
>>> +			if (ocfs2_is_soft_readonly(osb))
>>> +				status = -EROFS;
>>> +			else
>>> +				status = -EINVAL;
>>>  			mlog(ML_ERROR, "status=%d, sysfile=%d, slot=%d\n",
>>>  			     status, i, osb->slot_num);
>>>  			goto bail;
>>>
>> .
>>
