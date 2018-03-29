From: Changwei Ge <ge.changwei@h3c.com>
Date: Thu, 29 Mar 2018 06:25:48 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: don't evaluate buffer head to NULL
 managed by caller
References: <1522289162-31693-1-git-send-email-ge.changwei@h3c.com>
	<5ABCC171020000F9000B262A@prv-mh.provo.novell.com>
	<63ADC13FD55D6546B7DECE290D39E373F2954558@H3CMLB12-EX.srv.huawei-3com.com>
	<5ABCCC4D020000F9000B2652@prv-mh.provo.novell.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F2954698@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Gang,

On 2018/3/29 11:22, Gang He wrote:
> Hi Changwei,
> 
> 
>>>>
>> Hi Gang,
>>
>> On 2018/3/29 10:36, Gang He wrote:
>>> Hello Changwei,
>>>
>>>
>>> Do you have the related crash backtrace?
>> This patch has been pending in my tree for quite a long time and sadly I
>> can't
>> find the back trace right now. But we can still find the risk by reviewing
>> related code. :)
>>
>>> Maybe I feel that new adding check is not necessary.
>>
>> Very true, but the check I add is for debug purpose.
>> We can see that there are many places calling ocfs2_read_blocks(), some of
>> them
>> are passing only one bh while others are not.
>> In order to handle potential exception easily, it's better for callers to
>> pass
>> bhs which are all null or assigned. So I add that trick to tell if some
>> callers
>> are doing stupid things.
>>
>> Thanks,
>> Changwei
>>
>>> since the below code has make sure all buffer head is NOT NULL before
>> reading block.
>>> 216         ocfs2_metadata_cache_io_lock(ci);
>>> 217         for (i = 0 ; i < nr ; i++) {
>>> 218                 if (bhs[i] == NULL) {
>>> 219                         bhs[i] = sb_getblk(sb, block++);   <<= here
>>> 220                         if (bhs[i] == NULL) {
>>> 221                                 ocfs2_metadata_cache_io_unlock(ci);
>>> 222                                 status = -ENOMEM;
>>> 223                                 mlog_errno(status);
>>> 224                                 goto bail;
>>> 225                         }
>>> 226                 }
>>> 227                 bh = bhs[i];
>>>
>>>
>>> Thanks
>>> Gang
>>>
>>>
>>>>>>
>>>> ocfs2_read_blocks() is used to read several blocks from disk.
>>>> Currently, the input argument *bhs* can be NULL or NOT. It depends on
>>>> the caller's behavior. If the function fails in reading blocks from
>>>> disk, the corresponding bh will be assigned to NULL and put.
>>>>
>>>> Obviously, above process for non-NULL input bh is not appropriate.
>>>> Because the caller doesn't even know its bhs are put and re-assigned.
>>>>
>>>> If buffer head is managed by caller, ocfs2_read_blocks should not
>>>> evaluate it to NULL. It will cause caller accessing illegal memory,
>>>> thus crash.
>>>>
>>>> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
>>>> ---
>>>>    fs/ocfs2/buffer_head_io.c | 31 +++++++++++++++++++++++++------
>>>>    1 file changed, 25 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
>>>> index d9ebe11..17329b6 100644
>>>> --- a/fs/ocfs2/buffer_head_io.c
>>>> +++ b/fs/ocfs2/buffer_head_io.c
>>>> @@ -188,6 +188,7 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64
>>>> block, int nr,
>>>>    	int i, ignore_cache = 0;
>>>>    	struct buffer_head *bh;
>>>>    	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
>>>> +	int new_bh = 0;
>>>>    
>>>>    	trace_ocfs2_read_blocks_begin(ci, (unsigned long long)block, nr, flags);
>>>>    
>>>> @@ -213,6 +214,18 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64
>>>> block, int nr,
>>>>    		goto bail;
>>>>    	}
>>>>    
>>>> +	/* Use below trick to check if all bhs are NULL or assigned.
>>>> +	 * Basically, we hope all bhs are consistent so that we can
>>>> +	 * handle exception easily.
>>>> +	 */
>>>> +	new_bh = (bhs[0] == NULL);
>>>> +	for (i = 1 ; i < nr ; i++) {
>>>> +		if ((new_bh && bhs[i]) || (!new_bh && !bhs[i])) {
>>>> +			WARN(1, "Not all bhs are consistent\n");
>>>> +			break;
>>>> +		}
>>>> +	}
> Maybe just adding a buffer head array check is OK?
> If not consistent, give a warning.
> why do we need the below code change?
> since all head buffers are always NOT NULL.

Thanks for your review.
I will elaborate my intention and the reason doing so further.

There are *two* kinds of customers of ocfs2_read_blocks().

One kind like _slot map_ uses this function with *buffer head* allocated in 
advance. For this type, ocfs2_read_blocks() will not allocate *buffer head* via 
sb_getblk(). Because _slot map_ has reserved some buffer heads during its 
initialization. In other words, the input argument *bhs* should be an array with 
all entries assigned to non-NULL.
You can refer to code path:
ocfs2_refresh_slot_info -> ocfs2_read_blocks

The other kind doesn't reserve buffer head in advance, it relies on 
ocfs2_read_blocks() to allocate buffer head for following read from disk. This 
is why ocfs2_read_blocks() checks if bhs[i] is NULL.

For the first type, if ocfs2_read_blocks fails in reading from disk.
Current code will assign bhs[i] to NULL and put it, which my patch wants to fix.
Because the customer doesn't know what ocfs2_read_blocks() did to its bhs.
The customer like _slot map_ will still try to reference those bhs.

Thanks,
Changwei

> 
> Thanks
> Gang
> 
>>>> +
>>>>    	ocfs2_metadata_cache_io_lock(ci);
>>>>    	for (i = 0 ; i < nr ; i++) {
>>>>    		if (bhs[i] == NULL) {
>>>> @@ -324,8 +337,10 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64
>>>> block, int nr,
>>>>    		if (!(flags & OCFS2_BH_READAHEAD)) {
>>>>    			if (status) {
>>>>    				/* Clear the rest of the buffers on error */
>>>> -				put_bh(bh);
>>>> -				bhs[i] = NULL;
>>>> +				if (new_bh) {
>>>> +					put_bh(bh);
>>>> +					bhs[i] = NULL;
>>>> +				}
>>>>    				continue;
>>>>    			}
>>>>    			/* We know this can't have changed as we hold the
>>>> @@ -342,8 +357,10 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64
>>>> block, int nr,
>>>>    				 * for this bh as it's not marked locally
>>>>    				 * uptodate. */
>>>>    				status = -EIO;
>>>> -				put_bh(bh);
>>>> -				bhs[i] = NULL;
>>>> +				if (new_bh) {
>>>> +					put_bh(bh);
>>>> +					bhs[i] = NULL;
>>>> +				}
>>>>    				continue;
>>>>    			}
>>>>    
>>>> @@ -355,8 +372,10 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64
>>>> block, int nr,
>>>>    				clear_buffer_needs_validate(bh);
>>>>    				status = validate(sb, bh);
>>>>    				if (status) {
>>>> -					put_bh(bh);
>>>> -					bhs[i] = NULL;
>>>> +					if (new_bh) {
>>>> +						put_bh(bh);
>>>> +						bhs[i] = NULL;
>>>> +					}
>>>>    					continue;
>>>>    				}
>>>>    			}
>>>> -- 
>>>> 2.7.4
>>>>
>>>>
>>>> _______________________________________________
>>>> Ocfs2-devel mailing list
>>>> Ocfs2-devel at oss.oracle.com
>>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>>
>>>
> 
