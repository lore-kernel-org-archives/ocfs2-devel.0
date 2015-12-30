From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Wed, 30 Dec 2015 12:35:59 -0600
Subject: [Ocfs2-devel] [PATCH] ocfs2: Do not lock/unlock() inode DLM lock
In-Reply-To: <5683B274020000F900023B30@suse.com>
References: <1451413209-26406-1-git-send-email-rgoldwyn@suse.de>
	<5683B274020000F900023B30@suse.com>
Message-ID: <5684240F.2040403@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 12/29/2015 08:31 PM, Gang He wrote:
> Hello Goldwyn,
>
> When read path can't get the DLM lock immediately (NONBLOCK way), next get the lock with BLOCK way, this behavior will cost some time (several msecs).
> It looks make sense to delete that two line code.
> But why there are two line code existed? I just worry about, if we delete two line code, when read path can't get the DLM lock with NONBLOCK way, read path will retry to get this DLM lock repeatedly, this will lead to cost too much CPU (Not waiting in sleep).
> I just worry about this possibility, Eric will test this case, and give a feedback.
>

If DLM cannot grant a lock, it simply queues it in the order it 
received, irrespective of lock type request.
Imagine a case of continuous contention of a PR with a EX lock (a 
typical ping pong):
If we request a blocking PR lock and an EX request follows. We will be 
waiting and getting the PR lock but the lock immediately granted after 
we unlock PR will be the EX lock. So, the nonblocking PR lock will be 
starved when we actually require it to perform useful work.

I assume this is antebellum code which probably existed when DLM locks 
were disk-based. I may be wrong though.


> Thanks
> Gang
>
>
>>>>
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
>> DLM does not cache locks. So, blocking lock and unlock
>> will only make the performance worse where contention over
>> the locks is high.
>>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> ---
>>   fs/ocfs2/dlmglue.c | 8 --------
>>   1 file changed, 8 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>> index 20276e3..f92612e 100644
>> --- a/fs/ocfs2/dlmglue.c
>> +++ b/fs/ocfs2/dlmglue.c
>> @@ -2432,12 +2432,6 @@ bail:
>>    * done this we have to return AOP_TRUNCATED_PAGE so the aop method
>>    * that called us can bubble that back up into the VFS who will then
>>    * immediately retry the aop call.
>> - *
>> - * We do a blocking lock and immediate unlock before returning, though, so
>> that
>> - * the lock has a great chance of being cached on this node by the time the
>> VFS
>> - * calls back to retry the aop.    This has a potential to livelock as nodes
>> - * ping locks back and forth, but that's a risk we're willing to take to
>> avoid
>> - * the lock inversion simply.
>>    */
>>   int ocfs2_inode_lock_with_page(struct inode *inode,
>>   			      struct buffer_head **ret_bh,
>> @@ -2449,8 +2443,6 @@ int ocfs2_inode_lock_with_page(struct inode *inode,
>>   	ret = ocfs2_inode_lock_full(inode, ret_bh, ex, OCFS2_LOCK_NONBLOCK);
>>   	if (ret == -EAGAIN) {
>>   		unlock_page(page);
>> -		if (ocfs2_inode_lock(inode, ret_bh, ex) == 0)
>> -			ocfs2_inode_unlock(inode, ex);
>>   		ret = AOP_TRUNCATED_PAGE;
>>   	}
>>
>> --
>> 2.6.2

-- 
Goldwyn
