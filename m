From: piaojun <piaojun@huawei.com>
Date: Tue, 26 Dec 2017 13:41:43 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: return -EROFS to upper if inode
 block is invalid
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373F2908DEE@H3CMLB12-EX.srv.huawei-3com.com>
References: <5A41AFE2.5010506@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373F2908DEE@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <5A41E117.4030800@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

I just want to return exact errno to users so that they can fix
read-only problem rather than doing meaningless retry.

thanks,
Jun

On 2017/12/26 11:34, Changwei Ge wrote:
> Hi Jun,
> 
> What I concern is if we don't return -EROFS to mount.ocfs2, what bad result will come?
> This patch is a bug fix or something else?
> Can you elaborate your intention of this patch?
> 
> Thanks,
> Changwei
> 
> On 2017/12/26 10:14, piaojun wrote:
>> If metadata is corrupted such as 'invalid inode block', we will get
>> failed by calling 'mount()' as below:
>>
>> ocfs2_mount
>>    ocfs2_initialize_super
>>      ocfs2_init_global_system_inodes : return -EINVAL if inode is NULL
>>        ocfs2_get_system_file_inode
>>          _ocfs2_get_system_file_inode : return NULL if inode is errno
>>            ocfs2_iget
>>              ocfs2_read_locked_inode
>>                ocfs2_validate_inode_block
>>
>> In this situation we need return -EROFS to upper application, so that
>> user can fix it by fsck. And then mount again.
>>
>> Signed-off-by: Jun Piao <piaojun@huawei.com>
>> Reviewed-by: Alex Chen <alex.chen@huawei.com>
>> ---
>>   fs/ocfs2/super.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index 040bbb6..dea21a7 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -474,7 +474,10 @@ static int ocfs2_init_global_system_inodes(struct ocfs2_super *osb)
>>   		new = ocfs2_get_system_file_inode(osb, i, osb->slot_num);
>>   		if (!new) {
>>   			ocfs2_release_system_inodes(osb);
>> -			status = -EINVAL;
>> +			if (ocfs2_is_soft_readonly(osb))
>> +				status = -EROFS;
>> +			else
>> +				status = -EINVAL;
>>   			mlog_errno(status);
>>   			/* FIXME: Should ERROR_RO_FS */
>>   			mlog(ML_ERROR, "Unable to load system inode %d, "
>> @@ -505,7 +508,10 @@ static int ocfs2_init_local_system_inodes(struct ocfs2_super *osb)
>>   		new = ocfs2_get_system_file_inode(osb, i, osb->slot_num);
>>   		if (!new) {
>>   			ocfs2_release_system_inodes(osb);
>> -			status = -EINVAL;
>> +			if (ocfs2_is_soft_readonly(osb))
>> +				status = -EROFS;
>> +			else
>> +				status = -EINVAL;
>>   			mlog(ML_ERROR, "status=%d, sysfile=%d, slot=%d\n",
>>   			     status, i, osb->slot_num);
>>   			goto bail;
>>
> 
> .
> 
