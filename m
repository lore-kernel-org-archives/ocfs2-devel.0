From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 23 Jun 2016 09:17:53 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: improve recovery performance
In-Reply-To: <5763C644.9060104@huawei.com>
References: <1466155682-24656-1-git-send-email-junxiao.bi@oracle.com>
	<5763C644.9060104@huawei.com>
Message-ID: <576B38C1.50002@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew,

Did you miss this patch to your tree?

Thanks,
Junxiao.

On 06/17/2016 05:43 PM, Joseph Qi wrote:
> On 2016/6/17 17:28, Junxiao Bi wrote:
>> Journal replay will be run when do recovery for a dead node,
>> to avoid the stale cache impact, all blocks of dead node's
>> journal inode were reload from disk. This hurts the performance,
>> check whether one block is cached before reload it can improve
>> a lot performance. In my test env, the time doing recovery was
>> improved from 120s to 1s.
>>
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> Looks good to me. And it indeed has performance improvement from my
> test.
> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
> 
>> ---
>>  fs/ocfs2/journal.c |   41 ++++++++++++++++++++++-------------------
>>  1 file changed, 22 insertions(+), 19 deletions(-)
>>
>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>> index e607419cdfa4..bc0e21e8a674 100644
>> --- a/fs/ocfs2/journal.c
>> +++ b/fs/ocfs2/journal.c
>> @@ -1159,10 +1159,8 @@ static int ocfs2_force_read_journal(struct inode *inode)
>>  	int status = 0;
>>  	int i;
>>  	u64 v_blkno, p_blkno, p_blocks, num_blocks;
>> -#define CONCURRENT_JOURNAL_FILL 32ULL
>> -	struct buffer_head *bhs[CONCURRENT_JOURNAL_FILL];
>> -
>> -	memset(bhs, 0, sizeof(struct buffer_head *) * CONCURRENT_JOURNAL_FILL);
>> +	struct buffer_head *bh = NULL;
>> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>>  
>>  	num_blocks = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
>>  	v_blkno = 0;
>> @@ -1174,29 +1172,34 @@ static int ocfs2_force_read_journal(struct inode *inode)
>>  			goto bail;
>>  		}
>>  
>> -		if (p_blocks > CONCURRENT_JOURNAL_FILL)
>> -			p_blocks = CONCURRENT_JOURNAL_FILL;
>> +		for (i = 0; i < p_blocks; i++) {
>> +			bh = __find_get_block(osb->sb->s_bdev, p_blkno,
>> +					osb->sb->s_blocksize);
>> +			/* block not cached. */
>> +			if (!bh) {
>> +				p_blkno++;
>> +				continue;
>> +			}
>>  
>> -		/* We are reading journal data which should not
>> -		 * be put in the uptodate cache */
>> -		status = ocfs2_read_blocks_sync(OCFS2_SB(inode->i_sb),
>> -						p_blkno, p_blocks, bhs);
>> -		if (status < 0) {
>> -			mlog_errno(status);
>> -			goto bail;
>> -		}
>> +			brelse(bh);
>> +			bh = NULL;
>> +			/* We are reading journal data which should not
>> +			 * be put in the uptodate cache.
>> +			 */
>> +			status = ocfs2_read_blocks_sync(osb, p_blkno, 1, &bh);
>> +			if (status < 0) {
>> +				mlog_errno(status);
>> +				goto bail;
>> +			}
>>  
>> -		for(i = 0; i < p_blocks; i++) {
>> -			brelse(bhs[i]);
>> -			bhs[i] = NULL;
>> +			brelse(bh);
>> +			bh = NULL;
>>  		}
>>  
>>  		v_blkno += p_blocks;
>>  	}
>>  
>>  bail:
>> -	for(i = 0; i < CONCURRENT_JOURNAL_FILL; i++)
>> -		brelse(bhs[i]);
>>  	return status;
>>  }
>>  
>>
> 
> 
