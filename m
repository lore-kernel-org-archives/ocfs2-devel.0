From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 17 Jun 2016 16:32:40 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: improve recovery performance
In-Reply-To: <5763ABDC.6010609@oracle.com>
References: <1466143851-23471-1-git-send-email-junxiao.bi@oracle.com>
	<5763AA4C.1050606@huawei.com> <5763ABDC.6010609@oracle.com>
Message-ID: <5763B5A8.1060801@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2016/6/17 15:50, Junxiao Bi wrote:
> Hi Joseph,
> 
> On 06/17/2016 03:44 PM, Joseph Qi wrote:
>> Hi Junxiao,
>>
>> On 2016/6/17 14:10, Junxiao Bi wrote:
>>> Journal replay will be run when do recovery for a dead node,
>>> to avoid the stale cache impact, all blocks of dead node's
>>> journal inode were reload from disk. This hurts the performance,
>>> check whether one block is cached before reload it can improve
>>> a lot performance. In my test env, the time doing recovery was
>>> improved from 120s to 1s.
>>>
>>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>>> ---
>>>  fs/ocfs2/journal.c |   41 ++++++++++++++++++++++-------------------
>>>  1 file changed, 22 insertions(+), 19 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>>> index e607419cdfa4..8b808afd5f82 100644
>>> --- a/fs/ocfs2/journal.c
>>> +++ b/fs/ocfs2/journal.c
>>> @@ -1159,10 +1159,8 @@ static int ocfs2_force_read_journal(struct inode *inode)
>>>  	int status = 0;
>>>  	int i;
>>>  	u64 v_blkno, p_blkno, p_blocks, num_blocks;
>>> -#define CONCURRENT_JOURNAL_FILL 32ULL
>>> -	struct buffer_head *bhs[CONCURRENT_JOURNAL_FILL];
>>> -
>>> -	memset(bhs, 0, sizeof(struct buffer_head *) * CONCURRENT_JOURNAL_FILL);
>>> +	struct buffer_head *bhs[1] = {NULL};
>> Since now we do not need batch load, how about make the logic like:
>>
>> 	struct buffer_head *bh = NULL;
>> 	...
>> 	ocfs2_read_blocks_sync(osb, p_blkno, 1, &bh);
> This array is used because ocfs2_read_blocks_sync() needs it as last
> parameter.
IC, so we pass &bh like ocfs2_read_locked_inode.

Thanks,
Joseph

> 
> Thanks,
> Junxiao.
>>
>> Thanks,
>> Joseph
>>
>>> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>>>  
>>>  	num_blocks = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
>>>  	v_blkno = 0;
>>> @@ -1174,29 +1172,34 @@ static int ocfs2_force_read_journal(struct inode *inode)
>>>  			goto bail;
>>>  		}
>>>  
>>> -		if (p_blocks > CONCURRENT_JOURNAL_FILL)
>>> -			p_blocks = CONCURRENT_JOURNAL_FILL;
>>> +		for (i = 0; i < p_blocks; i++) {
>>> +			bhs[0] = __find_get_block(osb->sb->s_bdev, p_blkno,
>>> +					osb->sb->s_blocksize);
>>> +			/* block not cached. */
>>> +			if (!bhs[0]) {
>>> +				p_blkno++;
>>> +				continue;
>>> +			}
>>>  
>>> -		/* We are reading journal data which should not
>>> -		 * be put in the uptodate cache */
>>> -		status = ocfs2_read_blocks_sync(OCFS2_SB(inode->i_sb),
>>> -						p_blkno, p_blocks, bhs);
>>> -		if (status < 0) {
>>> -			mlog_errno(status);
>>> -			goto bail;
>>> -		}
>>> +			brelse(bhs[0]);
>>> +			bhs[0] = NULL;
>>> +			/* We are reading journal data which should not
>>> +			 * be put in the uptodate cache.
>>> +			 */
>>> +			status = ocfs2_read_blocks_sync(osb, p_blkno, 1, bhs);
>>> +			if (status < 0) {
>>> +				mlog_errno(status);
>>> +				goto bail;
>>> +			}
>>>  
>>> -		for(i = 0; i < p_blocks; i++) {
>>> -			brelse(bhs[i]);
>>> -			bhs[i] = NULL;
>>> +			brelse(bhs[0]);
>>> +			bhs[0] = NULL;
>>>  		}
>>>  
>>>  		v_blkno += p_blocks;
>>>  	}
>>>  
>>>  bail:
>>> -	for(i = 0; i < CONCURRENT_JOURNAL_FILL; i++)
>>> -		brelse(bhs[i]);
>>>  	return status;
>>>  }
>>>  
>>>
>>
>>
> 
> 
> .
> 
