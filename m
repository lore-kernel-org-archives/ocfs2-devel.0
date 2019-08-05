From: Changwei Ge <chge@linux.alibaba.com>
Date: Mon, 5 Aug 2019 10:17:04 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] fs: ocfs2: Fix a possible
 null-pointer dereference in ocfs2_info_scan_inode_alloc()
In-Reply-To: <3db34626-a87f-9de8-6f9c-e4a35f863cd6@linux.alibaba.com>
References: <20190726033717.32359-1-baijiaju1990@gmail.com>
	<3db34626-a87f-9de8-6f9c-e4a35f863cd6@linux.alibaba.com>
Message-ID: <b7e74003-48e0-aed9-2167-bd2a3dc3ffcd@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jia-Ju and Joseph,


Busy with a training session last week, so late for reviewing this patch.

I think this patch might not be necessary and a little violates original 
logic.

Please check out my comments inline.


On 2019/7/26 5:39 ??, Joseph Qi wrote:
>
> On 19/7/26 11:37, Jia-Ju Bai wrote:
>> In ocfs2_info_scan_inode_alloc(), there is an if statement on line 283
>> to check whether inode_alloc is NULL:
>>      if (inode_alloc)
>>
>> When inode_alloc is NULL, it is used on line 287:
>>      ocfs2_inode_lock(inode_alloc, &bh, 0);
>>          ocfs2_inode_lock_full_nested(inode, ...)
>>              struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>>
>> Thus, a possible null-pointer dereference may occur.
>>
>> To fix this bug, inode_alloc is checked on line 286.
>>
>> This bug is found by a static analysis tool STCheck written by us.
>>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> Looks good.
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> ---
>>   fs/ocfs2/ioctl.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
>> index d6f7b299eb23..efeea208fdeb 100644
>> --- a/fs/ocfs2/ioctl.c
>> +++ b/fs/ocfs2/ioctl.c
>> @@ -283,7 +283,7 @@ static int ocfs2_info_scan_inode_alloc(struct ocfs2_super *osb,
>>   	if (inode_alloc)
>>   		inode_lock(inode_alloc);
>>   
>> -	if (o2info_coherent(&fi->ifi_req)) {
>> +	if (inode_alloc && o2info_coherent(&fi->ifi_req)) {


If caller is asking for strict coherency but *inode_alloc* is NULL, we 
fallback to non-coherency branch?

I think this is destroying the file semantics. Returning error to caller 
is better?


On the other hand, from the code path:

ocfs2_info_handle_freeinode()

 ??? if o2info_coherent() then inode_alloc = 
ocfs2_get_system_file_inode() ---> here we can ensure that being passed 
*inode_alloc* can't be NULL

 ??? ocfs2_info_scan_inode_alloc()


Thanks,

Changwei


>>   		status = ocfs2_inode_lock(inode_alloc, &bh, 0);
>>   		if (status < 0) {
>>   			mlog_errno(status);
>>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
