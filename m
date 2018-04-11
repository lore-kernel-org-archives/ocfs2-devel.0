From: Changwei Ge <ge.changwei@h3c.com>
Date: Wed, 11 Apr 2018 01:49:30 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: don't put and assign null to bh
 allocated outside
References: <1523360121-10761-1-git-send-email-ge.changwei@h3c.com>
	<5ACD594A.7030703@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373F295F7F9@H3CMLB12-EX.srv.huawei-3com.com>
	<5ACD67EB.6010309@huawei.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F295F873@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jun,

On 2018/4/11 9:43, piaojun wrote:
> Hi Changwei,
> 
> On 2018/4/11 9:14, Changwei Ge wrote:
>> Hi Jun,
>>
>> Thanks for your review.
>>
>> On 2018/4/11 8:40, piaojun wrote:
>>> Hi Changwei,
>>>
>>> On 2018/4/10 19:35, Changwei Ge wrote:
>>>> ocfs2_read_blocks() and ocfs2_read_blocks_sync() are both used to read
>>>> several blocks from disk. Currently, the input argument *bhs* can be
>>>> NULL or NOT. It depends on the caller's behavior. If the function fails
>>>> in reading blocks from disk, the corresponding bh will be assigned to
>>>> NULL and put.
>>>>
>>>> Obviously, above process for non-NULL input bh is not appropriate.
>>>> Because the caller doesn't even know its bhs are put and re-assigned.
>>>>
>>>> If buffer head is managed by caller, ocfs2_read_blocks and
>>>> ocfs2_read_blocks_sync()  should not evaluate it to NULL. It will
>>>> cause caller accessing illegal memory, thus crash.
>>>>
>>>> Also, we should put bhs which have succeeded in reading before current
>>>> read failure.
>>>>
>>>> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
>>>> ---
>>>>    fs/ocfs2/buffer_head_io.c | 77 ++++++++++++++++++++++++++++++++++++-----------
>>>>    1 file changed, 59 insertions(+), 18 deletions(-)
>>>>
>>>> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
>>>> index d9ebe11..7ae4147 100644
>>>> --- a/fs/ocfs2/buffer_head_io.c
>>>> +++ b/fs/ocfs2/buffer_head_io.c
>>>> @@ -99,25 +99,34 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
>>>>    	return ret;
>>>>    }
>>>>    
>>>> +/* Caller must provide a bhs[] with all NULL or non-NULL entries, so it
>>>> + * will be easier to handle read failure.
>>>> + */
>>>>    int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
>>>>    			   unsigned int nr, struct buffer_head *bhs[])
>>>>    {
>>>>    	int status = 0;
>>>>    	unsigned int i;
>>>>    	struct buffer_head *bh;
>>>> +	int new_bh = 0;
>>>>    
>>>>    	trace_ocfs2_read_blocks_sync((unsigned long long)block, nr);
>>>>    
>>>>    	if (!nr)
>>>>    		goto bail;
>>>>    
>>>> +	/* Don't put buffer head and re-assign it to NULL if it is allocated
>>>> +	 * outside since the call can't be aware of this alternation!
>>>> +	 */
>>>> +	new_bh = (bhs[0] == NULL);
>>>
>>> 'new_bh' just means the first bh is NULL, what if the middle bh is NULL?
>>
>> I am afraid we have to assume that if the first bh is NULL, others must to be
>> NULL as well. Otherwise this function's exception handling will be rather
>> complicated and messy. So I add a comment before this function to remind the
>> caller should pass appropriate arguments in.
>> And I checked the callers to this function, they behave like my assumption.
>>
>> Moreover, who would pass a so strange bh array in?
> 
> What about restricting the outside caller's behaviour rather than handling
> it in ocfs2_read_blocks_sync()? Will it be easier to do this?

No, it can't be easier than fix it inside ocfs2_read_blocks_sync().
Because some callers don't want to put bh until it has to.
Others will put shortly after it obtains it wants from disk.
So it's hard to restrict callers' behavior.
And that way will change long-lived logic a lot.

Thanks,
Changwei

> 
> thanks,
> Jum
> 
>>
>>>
>>>> +
>>>>    	for (i = 0 ; i < nr ; i++) {
>>>>    		if (bhs[i] == NULL) {
>>>>    			bhs[i] = sb_getblk(osb->sb, block++);
>>>>    			if (bhs[i] == NULL) {
>>>>    				status = -ENOMEM;
>>>>    				mlog_errno(status);
>>>> -				goto bail;
>>>> +				break;
>>>>    			}
>>>>    		}
>>>>    		bh = bhs[i];
>>>> @@ -158,9 +167,26 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
>>>>    		submit_bh(REQ_OP_READ, 0, bh);
>>>>    	}
>>>>    
>>>> +read_failure:
>>>
>>> This looks weird that 'read_failure' include the normal branch.
>>
>> Sounds reasonable.
>> How about if_read_failure or may_read_failure?
>>
>> Thanks,
>> Changwei
>>
>>>
>>>>    	for (i = nr; i > 0; i--) {
>>>>    		bh = bhs[i - 1];
>>>>    
>>>> +		if (unlikely(status)) {
>>>> +			if (new_bh && !bh) {
>>>> +				/* If middle bh fails, let previous bh
>>>> +				 * finish its read and then put it to
>>>> +				 * aovoid bh leak
>>>> +				 */
>>>> +				if (!buffer_jbd(bh))
>>>> +					wait_on_buffer(bh);
>>>> +				put_bh(bh);
>>>> +				bhs[i - 1] = NULL;
>>>> +			} else if (buffer_uptodate(bh)) {
>>>> +				clear_buffer_uptodate(bh);
>>>> +			}
>>>> +			continue;
>>>> +		}
>>>> +
>>>>    		/* No need to wait on the buffer if it's managed by JBD. */
>>>>    		if (!buffer_jbd(bh))
>>>>    			wait_on_buffer(bh);
>>>> @@ -170,8 +196,7 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
>>>>    			 * so we can safely record this and loop back
>>>>    			 * to cleanup the other buffers. */
>>>>    			status = -EIO;
>>>> -			put_bh(bh);
>>>> -			bhs[i - 1] = NULL;
>>>> +			goto read_failure;
>>>>    		}
>>>>    	}
>>>>    
>>>> @@ -179,6 +204,9 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
>>>>    	return status;
>>>>    }
>>>>    
>>>> +/* Caller must provide a bhs[] with all NULL or non-NULL entries, so it
>>>> + * will be easier to handle read failure.
>>>> + */
>>>>    int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>>>>    		      struct buffer_head *bhs[], int flags,
>>>>    		      int (*validate)(struct super_block *sb,
>>>> @@ -188,6 +216,7 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>>>>    	int i, ignore_cache = 0;
>>>>    	struct buffer_head *bh;
>>>>    	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
>>>> +	int new_bh = 0;
>>>>    
>>>>    	trace_ocfs2_read_blocks_begin(ci, (unsigned long long)block, nr, flags);
>>>>    
>>>> @@ -213,6 +242,11 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>>>>    		goto bail;
>>>>    	}
>>>>    
>>>> +	/* Don't put buffer head and re-assign it to NULL if it is allocated
>>>> +	 * outside since the call can't be aware of this alternation!
>>>> +	 */
>>>> +	new_bh = (bhs[0] == NULL);
>>>> +
>>>>    	ocfs2_metadata_cache_io_lock(ci);
>>>>    	for (i = 0 ; i < nr ; i++) {
>>>>    		if (bhs[i] == NULL) {
>>>> @@ -221,7 +255,8 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>>>>    				ocfs2_metadata_cache_io_unlock(ci);
>>>>    				status = -ENOMEM;
>>>>    				mlog_errno(status);
>>>> -				goto bail;
>>>> +				/* Don't forget to put previous bh! */
>>>> +				break;
>>>>    			}
>>>>    		}
>>>>    		bh = bhs[i];
>>>> @@ -316,16 +351,27 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>>>>    		}
>>>>    	}
>>>>    
>>>> -	status = 0;
>>>> -
>>>> +read_failure:
>>>>    	for (i = (nr - 1); i >= 0; i--) {
>>>>    		bh = bhs[i];
>>>>    
>>>>    		if (!(flags & OCFS2_BH_READAHEAD)) {
>>>> -			if (status) {
>>>> -				/* Clear the rest of the buffers on error */
>>>> -				put_bh(bh);
>>>> -				bhs[i] = NULL;
>>>> +			if (unlikely(status)) {
>>>> +				/* Clear the buffers on error including those
>>>> +				 * ever succeeded in reading
>>>> +				 */
>>>> +				if (new_bh && !bh) {
>>>> +					/* If middle bh fails, let previous bh
>>>> +					 * finish its read and then put it to
>>>> +					 * aovoid bh leak
>>>> +					 */
>>>> +					if (!buffer_jbd(bh))
>>>> +						wait_on_buffer(bh);
>>>> +					put_bh(bh);
>>>> +					bhs[i] = NULL;
>>>> +				} else if (buffer_uptodate(bh)) {
>>>> +					clear_buffer_uptodate(bh);
>>>> +				}
>>>>    				continue;
>>>>    			}
>>>>    			/* We know this can't have changed as we hold the
>>>> @@ -342,9 +388,7 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>>>>    				 * for this bh as it's not marked locally
>>>>    				 * uptodate. */
>>>>    				status = -EIO;
>>>> -				put_bh(bh);
>>>> -				bhs[i] = NULL;
>>>> -				continue;
>>>> +				goto read_failure;
>>>>    			}
>>>>    
>>>>    			if (buffer_needs_validate(bh)) {
>>>> @@ -354,11 +398,8 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>>>>    				BUG_ON(buffer_jbd(bh));
>>>>    				clear_buffer_needs_validate(bh);
>>>>    				status = validate(sb, bh);
>>>> -				if (status) {
>>>> -					put_bh(bh);
>>>> -					bhs[i] = NULL;
>>>> -					continue;
>>>> -				}
>>>> +				if (status)
>>>> +					goto read_failure;
>>>>    			}
>>>>    		}
>>>>    
>>>>
>>>
>> .
>>
> 
