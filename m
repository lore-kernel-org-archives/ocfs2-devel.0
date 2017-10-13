From: Joseph Qi <jiangqi903@gmail.com>
Date: Fri, 13 Oct 2017 09:27:40 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fstrim: Fix start offset of first
 cluster group during fstrim
In-Reply-To: <8a0ead0f-7390-b3be-ea5b-847b943a81e2@oracle.com>
References: <1507835579-7308-1-git-send-email-ashish.samant@oracle.com>
	<8a0ead0f-7390-b3be-ea5b-847b943a81e2@oracle.com>
Message-ID: <f204ac03-610d-a3c6-a4c5-7c9252cce2ae@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Junxiao Bi <junxiao.bi@oracle.com>, Ashish Samant <ashish.samant@oracle.com>, ocfs2-devel@oss.oracle.com
Cc: stable@vger.kernel.org



On 17/10/13 08:45, Junxiao Bi wrote:
> On 10/13/2017 03:12 AM, Ashish Samant wrote:
>> The first cluster group descriptor is not stored at the start of the group
>> but at an offset from the start. We need to take this into account while
>> doing fstrim on the first cluster group. Otherwise we will wrongly start
>> fstrim a few blocks after the desired start block and the range can cross
>> over into the next cluster group and zero out the group descriptor there.
>> This can cause filesytem corruption that cannot be fixed by fsck.
>>
>> Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
>> Cc: stable at vger.kernel.org
> Looks good.
> 
> Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
> 
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
>> ---
>>  fs/ocfs2/alloc.c | 24 ++++++++++++++++++------
>>  1 file changed, 18 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index a177eae..addd7c5 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -7304,13 +7304,24 @@ int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
>>  
>>  static int ocfs2_trim_extent(struct super_block *sb,
>>  			     struct ocfs2_group_desc *gd,
>> -			     u32 start, u32 count)
>> +			     u64 group, u32 start, u32 count)
>>  {
>>  	u64 discard, bcount;
>> +	struct ocfs2_super *osb = OCFS2_SB(sb);
>>  
>>  	bcount = ocfs2_clusters_to_blocks(sb, count);
>> -	discard = le64_to_cpu(gd->bg_blkno) +
>> -			ocfs2_clusters_to_blocks(sb, start);
>> +	discard = ocfs2_clusters_to_blocks(sb, start);
>> +
>> +	/*
>> +	 * For the first cluster group, the gd->bg_blkno is not at the start
>> +	 * of the group, but at an offset from the start. If we add it while
>> +	 * calculating discard for first group, we will wrongly start fstrim a
>> +	 * few blocks after the desried start block and the range can cross
>> +	 * over into the next cluster group. So, add it only if this is not
>> +	 * the first cluster group.
>> +	 */
>> +	if (group != osb->first_cluster_group_blkno)
>> +		discard += le64_to_cpu(gd->bg_blkno);
>>  
>>  	trace_ocfs2_trim_extent(sb, (unsigned long long)discard, bcount);
>>  
>> @@ -7318,7 +7329,7 @@ static int ocfs2_trim_extent(struct super_block *sb,
>>  }
>>  
>>  static int ocfs2_trim_group(struct super_block *sb,
>> -			    struct ocfs2_group_desc *gd,
>> +			    struct ocfs2_group_desc *gd, u64 group,
>>  			    u32 start, u32 max, u32 minbits)
>>  {
>>  	int ret = 0, count = 0, next;
>> @@ -7337,7 +7348,7 @@ static int ocfs2_trim_group(struct super_block *sb,
>>  		next = ocfs2_find_next_bit(bitmap, max, start);
>>  
>>  		if ((next - start) >= minbits) {
>> -			ret = ocfs2_trim_extent(sb, gd,
>> +			ret = ocfs2_trim_extent(sb, gd, group,
>>  						start, next - start);
>>  			if (ret < 0) {
>>  				mlog_errno(ret);
>> @@ -7435,7 +7446,8 @@ int ocfs2_trim_fs(struct super_block *sb, struct fstrim_range *range)
>>  		}
>>  
>>  		gd = (struct ocfs2_group_desc *)gd_bh->b_data;
>> -		cnt = ocfs2_trim_group(sb, gd, first_bit, last_bit, minlen);
>> +		cnt = ocfs2_trim_group(sb, gd, group,
>> +				       first_bit, last_bit, minlen);
>>  		brelse(gd_bh);
>>  		gd_bh = NULL;
>>  		if (cnt < 0) {
>>
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
