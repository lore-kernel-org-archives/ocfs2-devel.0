From: alex chen <alex.chen@huawei.com>
Date: Mon, 23 Oct 2017 10:39:15 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: the ip_alloc_sem should be taken
 in ocfs2_get_block()
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373CED6F4FD@H3CMLB14-EX.srv.huawei-3com.com>
References: <59E9BBEF.1060601@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373CED6F4FD@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <59ED5653.7090705@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

On 2017/10/20 17:23, Changwei Ge wrote:
> Hi Alex,
> 
> Are you able to provide a way to reproduce this issue?
> I'm very interested in it.
> 

You can reproduce the BUG in the following steps:
1. touch "/mnt/ocfs2/test";
2. fallocate -l 1G "/mnt/ocfs2/test";
3. write the file "/mnt/ocfs2/test" using the io_submit();
4. at the same time, creating another process to read this file from
   a random location;

> Thanks,
> Changwei.
> 
> On 2017/10/20 17:08, alex chen wrote:
>> The ip_alloc_sem should be taken in ocfs2_get_block() when reading file
>> in DIRECT mode to prevent concurrent access to extent tree with
>> ocfs2_dio_end_io_write(), which may cause BUGON in
>> ocfs2_get_clusters_nocache()->BUG_ON(v_cluster < le32_to_cpu(rec->e_cpos))
>>
>> Signed-off-by: Alex Chen <alex.chen@huawei.com>
>> Reviewed-by: Jun Piao <piaojun@huawei.com>
>>
>> ---
>>   fs/ocfs2/aops.c | 21 +++++++++++++++------
>>   1 file changed, 15 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index 88a31e9..5cb939f 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -134,6 +134,19 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
>>   	return err;
>>   }
>>
>> +static int ocfs2_get_block_lock(struct inode *inode, sector_t iblock,
>> +		    struct buffer_head *bh_result, int create)
>> +{
>> +	int ret;
>> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>> +
>> +	down_read(&oi->ip_alloc_sem);
>> +	ret = ocfs2_get_block(inode, iblock, bh_result, create);
>> +	up_read(&oi->ip_alloc_sem);
>> +
>> +	return ret;
>> +}
>> +
>>   int ocfs2_get_block(struct inode *inode, sector_t iblock,
>>   		    struct buffer_head *bh_result, int create)
>>   {
>> @@ -2154,12 +2167,8 @@ static int ocfs2_dio_get_block(struct inode *inode, sector_t iblock,
>>   	 * while file size will be changed.
>>   	 */
>>   	if (pos + total_len <= i_size_read(inode)) {
>> -		down_read(&oi->ip_alloc_sem);
>>   		/* This is the fast path for re-write. */
>> -		ret = ocfs2_get_block(inode, iblock, bh_result, create);
>> -
>> -		up_read(&oi->ip_alloc_sem);
>> -
>> +		ret = ocfs2_get_block_lock(inode, iblock, bh_result, create);
>>   		if (buffer_mapped(bh_result) &&
>>   		    !buffer_new(bh_result) &&
>>   		    ret == 0)
>> @@ -2424,7 +2433,7 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>>   		return 0;
>>
>>   	if (iov_iter_rw(iter) == READ)
>> -		get_block = ocfs2_get_block;
>> +		get_block = ocfs2_get_block_lock;
>>   	else
>>   		get_block = ocfs2_dio_get_block;
>>
>> -- 1.9.5.msysgit.1
>>
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
> 
> 
> .
> 
