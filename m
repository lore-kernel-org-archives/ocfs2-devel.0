From: Changwei Ge <ge.changwei@h3c.com>
Date: Thu, 29 Mar 2018 06:27:22 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: don't evaluate buffer head to NULL
 managed by caller
References: <1522289162-31693-1-git-send-email-ge.changwei@h3c.com>
	<32e9201b-a307-7bd3-1a26-478f152610f5@suse.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F29546B1@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Larry,

On 2018/3/29 11:37, Larry Chen wrote:
> Hi Changwei,
> 
> I found that your patch call put_bh function only if new_bh==1,
> Will it cause buffer_head use count inconsistent??

We don't have to worry about that since sb_getblk() should never be invoked in 
that case.

Thanks,
Changwei

> 
> Thanks
> Larry
> 
> 
> On 03/29/2018 10:06 AM, Changwei Ge wrote:
>> ocfs2_read_blocks() is used to read several blocks from disk.
>> Currently, the input argument *bhs* can be NULL or NOT. It depends on
>> the caller's behavior. If the function fails in reading blocks from
>> disk, the corresponding bh will be assigned to NULL and put.
>>
>> Obviously, above process for non-NULL input bh is not appropriate.
>> Because the caller doesn't even know its bhs are put and re-assigned.
>>
>> If buffer head is managed by caller, ocfs2_read_blocks should not
>> evaluate it to NULL. It will cause caller accessing illegal memory,
>> thus crash.
>>
>> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
>> ---
>>    fs/ocfs2/buffer_head_io.c | 31 +++++++++++++++++++++++++------
>>    1 file changed, 25 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
>> index d9ebe11..17329b6 100644
>> --- a/fs/ocfs2/buffer_head_io.c
>> +++ b/fs/ocfs2/buffer_head_io.c
>> @@ -188,6 +188,7 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>>    	int i, ignore_cache = 0;
>>    	struct buffer_head *bh;
>>    	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
>> +	int new_bh = 0;
>>    
>>    	trace_ocfs2_read_blocks_begin(ci, (unsigned long long)block, nr, flags);
>>    
>> @@ -213,6 +214,18 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>>    		goto bail;
>>    	}
>>    
>> +	/* Use below trick to check if all bhs are NULL or assigned.
>> +	 * Basically, we hope all bhs are consistent so that we can
>> +	 * handle exception easily.
>> +	 */
>> +	new_bh = (bhs[0] == NULL);
>> +	for (i = 1 ; i < nr ; i++) {
>> +		if ((new_bh && bhs[i]) || (!new_bh && !bhs[i])) {
>> +			WARN(1, "Not all bhs are consistent\n");
>> +			break;
>> +		}
>> +	}
>> +
>>    	ocfs2_metadata_cache_io_lock(ci);
>>    	for (i = 0 ; i < nr ; i++) {
>>    		if (bhs[i] == NULL) {
>> @@ -324,8 +337,10 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>>    		if (!(flags & OCFS2_BH_READAHEAD)) {
>>    			if (status) {
>>    				/* Clear the rest of the buffers on error */
>> -				put_bh(bh);
>> -				bhs[i] = NULL;
>> +				if (new_bh) {
>> +					put_bh(bh);
>> +					bhs[i] = NULL;
>> +				}
>>    				continue;
>>    			}
>>    			/* We know this can't have changed as we hold the
>> @@ -342,8 +357,10 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>>    				 * for this bh as it's not marked locally
>>    				 * uptodate. */
>>    				status = -EIO;
>> -				put_bh(bh);
>> -				bhs[i] = NULL;
>> +				if (new_bh) {
>> +					put_bh(bh);
>> +					bhs[i] = NULL;
>> +				}
>>    				continue;
>>    			}
>>    
>> @@ -355,8 +372,10 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>>    				clear_buffer_needs_validate(bh);
>>    				status = validate(sb, bh);
>>    				if (status) {
>> -					put_bh(bh);
>> -					bhs[i] = NULL;
>> +					if (new_bh) {
>> +						put_bh(bh);
>> +						bhs[i] = NULL;
>> +					}
>>    					continue;
>>    				}
>>    			}
> 
> 
