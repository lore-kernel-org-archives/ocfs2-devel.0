From: Changwei Ge <ge.changwei@h3c.com>
Date: Tue, 26 Dec 2017 09:20:16 +0000
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: fall back to buffer IO when
 append dio is disabled with file hole existing
References: <63ADC13FD55D6546B7DECE290D39E373F2908F5C@H3CMLB12-EX.srv.huawei-3com.com>
	<5A42062C.1020804@huawei.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F2909081@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Alex

On 2017/12/26 16:20, alex chen wrote:
> Hi Changwei,
> 
> On 2017/12/26 15:03, Changwei Ge wrote:
>> The intention of this patch is to provide an option to ocfs2 users whether
>> to allocate disk space while doing dio write.
>>
>> Whether to make ocfs2 fall back to buffer io is up to ocfs2 users through
>> toggling append-dio feature. It rather makes ocfs2 configurable and
>> flexible.
>>
> It is too strange to make ocfs2 fall back to buffer io by toggling append-dio feature.

It might be.
But as my changelog said, I think, append-dio is key to whether to allocate
space with dio writing. So filling hole and appending file should have the same reflection.

Besides, in the early days, ocfs2 truly falls back to buffer io when append-dio is disabled and file hole is encountered.

Thanks,
Changwei

> 
>> So if something bad happens to dio write with space allocation, we can
>> still make ocfs2 fall back to buffer io. It's an option not a mandatory
>> action.:)
> Now the ocfs2 supports fill holes during direct io whether or not supporting append-dio feature
> and we can directly fix the problem.
> I think it is meaningless to provide an temporary option to turn off it.

IMO, this patch is NOT a temporary solution.
Instead, it provides an extra option to ocfs2 users. And append-dio is enabled while making fs by *default*.

Thanks,
Changwei  

> 
>>
>> Besides, append-dio feature is key to whether to allocate space with dio
>> writing. So writing to file hole and enlarging file(appending file) should
>> have the same reflection to append-dio feature.
>>
>> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
>> ---
>>    fs/ocfs2/aops.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++---
>>    1 file changed, 50 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index d151632..32e60c0 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -2414,12 +2414,52 @@ static int ocfs2_dio_end_io(struct kiocb *iocb,
>>    	return ret;
>>    }
>>    
>> +/*
>> + * Will look for holes and unwritten extents in the range starting at
>> + * pos for count bytes (inclusive).
>> + * Return value 1 indicates hole exists, 0 not exists, others indicate error.
>> + */
>> +static int ocfs2_range_has_holes(struct inode *inode, loff_t pos,
>> +				 size_t count)
>> +{
>> +	int ret = 0;
>> +	unsigned int extent_flags;
>> +	u32 cpos, clusters, extent_len, phys_cpos;
>> +	struct super_block *sb = inode->i_sb;
>> +
>> +	cpos = pos >> OCFS2_SB(sb)->s_clustersize_bits;
>> +	clusters = ocfs2_clusters_for_bytes(sb, pos + count) - cpos;
>> +
>> +	while (clusters) {
>> +		ret = ocfs2_get_clusters(inode, cpos, &phys_cpos, &extent_len,
>> +					 &extent_flags);
>> +		if (ret < 0) {
>> +			mlog_errno(ret);
>> +			goto out;
>> +		}
>> +
>> +		if (phys_cpos == 0) {
>> +			ret = 1;
>> +			goto out;
>> +		}
>> +
>> +		if (extent_len > clusters)
>> +			extent_len = clusters;
>> +
>> +		clusters -= extent_len;
>> +		cpos += extent_len;
>> +	}
>> +out:
>> +	return ret;
>> +}
>> +
>>    static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>>    {
>>    	struct file *file = iocb->ki_filp;
>>    	struct inode *inode = file->f_mapping->host;
>>    	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>>    	get_block_t *get_block;
>> +	int ret;
>>    
>>    	/*
>>    	 * Fallback to buffered I/O if we see an inode without
>> @@ -2429,9 +2469,16 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>>    		return 0;
>>    
>>    	/* Fallback to buffered I/O if we do not support append dio. */
>> -	if (iocb->ki_pos + iter->count > i_size_read(inode) &&
>> -	    !ocfs2_supports_append_dio(osb))
>> -		return 0;
>> +	if (!ocfs2_supports_append_dio(osb)) {
>> +		if (iocb->ki_pos + iter->count > i_size_read(inode))
>> +			return 0;
>> +
>> +		ret = ocfs2_range_has_holes(inode, iocb->ki_pos, iter->count);
>> +		if (ret == 1)
>> +			return 0;
>> +		else if (ret < 0)
>> +			return ret;
>> +	}
>>    
>>    	if (iov_iter_rw(iter) == READ)
>>    		get_block = ocfs2_lock_get_block;
>>
> 
> 
