From: Younger Liu <younger.liu@huawei.com>
Date: Sat, 29 Jun 2013 13:20:05 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix issue that ocfs2_setattr()
 does not deal with new_i_size==i_size
In-Reply-To: <51CD0BD3.2000306@oracle.com>
References: <51CBEFEA.3010308@huawei.com> <51CD0BD3.2000306@oracle.com>
Message-ID: <51CE6E85.4080208@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013/6/28 12:06, Jeff Liu wrote:
> Thanks for your patch, it indeed fixed a bug.  However, your description
> is not correct, please see my inline comments.
> 
> On 06/27/2013 03:55 PM, Younger Liu wrote:
> 
>> The issue scenario is as following:
>> 1. fallocate a large disk space(eg. 30G) with FALLOC_FL_KEEP_SIZE
>> for a file whose i_size and disk size are 512(or other size). 
>> After executing fallocate, i_size file is still 512, and the disk 
>> size became to 30G+512?
> 
> The file size won't be changed if FALLOC_FL_KEEP_SIZE is specified,
> Pls refer to the man page of fallocate(2) for detail.
> 
> Disk size should be changed to reflect this operation, why not?
> 
>> 2. ftruncate the file to new_i_size which equal to inode->i_size.
>> After executing ftruncate, disk space does not changes. 
> 
> This is a real bug that be fixed in this patch.
> 
>> In other words, i_size file is still 512, and disk size is
>> 30G+512. But we want disk size to be 512.
> 
> Ditto.
> 
>> This does not meet our expectations.
> 
> ...
> 
>>
>> In order to Solving the issue above, we modified ocfs2_setattr(), 
>> if attr->ia_size != i_size_read(inode), It calls 
>> ocfs2_truncate_file(), and truncate disk space to attr->ia_size.
> 
> Right.
> 
>>
>> Signed-off-by: Younger Liu <younger.liu@huawei.com>
>> ---
>>  fs/ocfs2/alloc.c |    2 +-
>>  fs/ocfs2/file.c  |    7 ++-----
>>  2 files changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index b8a9d87..19837d4 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -7126,7 +7126,7 @@ int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
>>  	if (end > i_size_read(inode))
>>  		end = i_size_read(inode);
>>  
>> -	BUG_ON(start >= end);
>> +	BUG_ON(start > end);
>>  
>>  	if (!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) ||
>>  	    !(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) ||
>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>> index 793c010..2e405e8 100644
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -476,9 +476,6 @@ static int ocfs2_truncate_file(struct inode *inode,
>>  
>>  	/* lets handle the simple truncate cases before doing any more
>>  	 * cluster locking. */
> 
> Above pointless comments should be removed with this change as well.
> 
>> -	if (new_i_size == le64_to_cpu(fe->i_size))
>> -		goto bail;
>> -
>>  	down_write(&OCFS2_I(inode)->ip_alloc_sem);
>>  
>>  	ocfs2_resv_discard(&osb->osb_la_resmap,
>> @@ -1150,14 +1147,14 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>>  		goto bail_unlock_rw;
>>  	}
>>  
>> -	if (size_change && attr->ia_size != i_size_read(inode)) {
>> +	if (size_change) {
>>  		status = inode_newsize_ok(inode, attr->ia_size);
>>  		if (status)
>>  			goto bail_unlock;
>>  
>>  		inode_dio_wait(inode);
>>  
>> -		if (i_size_read(inode) > attr->ia_size) {
>> +		if (i_size_read(inode) >= attr->ia_size) {
>>  			if (ocfs2_should_order_data(inode)) {
>>  				status = ocfs2_begin_ordered_truncate(inode,
>>  								      attr->ia_size);
> 
> 
> So I also run a quick test to verify this patch, it looks fine.
> 
> # dd if=/dev/zero of=/ocfs2/test bs=512 count=1
> 1+0 records in
> 1+0 records out
> 512 bytes (512 B) copied, 0.000150857 s, 3.4 MB/s
> 
> # xfs_io -c 'falloc -k 512 3G' /ocfs2/test
> # ls -l /ocfs2/test
> -rw-r--r-- 1 root root 512 Jun 28 11:47 /ocfs2/test
> # df -h
> Filesystem      Size  Used Avail Use% Mounted on
> ....
> /dev/sdb1       8.0G  3.4G  4.7G  42% /ocfs2
> 
> # xfs_io -c 'truncate 512' /ocfs2/test
> 
> # df -h
> Filesystem      Size  Used Avail Use% Mounted on
> .....
> /dev/sdb1       8.0G  363M  7.7G   5% /ocfs2
> 
> # ls -l /ocfs2/test
> -rw-r--r-- 1 root root 512 Jun 28 11:47 /ocfs2/test
> 
> 
> With above bug description problems were fixed, you can
> consider to add:
> Reviewed-by: Jie Liu <jeff.liu@oracle.com>
> Tested-by: Jie Liu <jeff.liu@oracle.com>
> 
> -Jeff
> 
> .
> 
Thanks, I will resent the patch in a moment.
					Younger
