From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 16 Dec 2008 16:40:17 -0800
Subject: [Ocfs2-devel] [PATCH 9/9] ocfs2/dlm: Fix race during lockres
 mastery
In-Reply-To: <20081217002516.GZ8791@wotan.suse.de>
References: <1229471363-15887-1-git-send-email-sunil.mushran@oracle.com>
	<1229471363-15887-10-git-send-email-sunil.mushran@oracle.com>
	<20081217002516.GZ8791@wotan.suse.de>
Message-ID: <49484A71.2030100@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Tue, Dec 16, 2008 at 03:49:23PM -0800, Sunil Mushran wrote:
>   
>> dlm_get_lock_resource() is supposed to return a lock resource with a proper
>> master. If multiple concurrent threads attempt to lookup the lockres for the
>> same lockid while the lock mastery in underway, one or more threads are likely
>> to return a lockres without a proper master.
>>
>> This patch makes the threads wait in dlm_get_lock_resource() while the mastery
>> is underway, ensuring all threads return the lockres with a proper master.
>>
>> This issue is known to be limited to users using the flock() syscall. For all
>> other fs operations, the ocfs2 dlmglue layer serializes the dlm op for each
>> lockid.
>>
>> Patch fixes Novell bz#425491
>> https://bugzilla.novell.com/show_bug.cgi?id=425491
>>
>> Users encountering this bug will see flock() return EINVAL and dmesg have the
>> following error:
>> ERROR: Dlm error "DLM_BADARGS" while calling dlmlock on resource <LOCKID>: bad api args
>>
>> Reported-by: Coly Li <coyli@suse.de>
>> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
>> ---
>>  fs/ocfs2/dlm/dlmmaster.c |    9 ++++++++-
>>  1 files changed, 8 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
>> index cbf3abe..54e182a 100644
>> --- a/fs/ocfs2/dlm/dlmmaster.c
>> +++ b/fs/ocfs2/dlm/dlmmaster.c
>> @@ -732,14 +732,21 @@ lookup:
>>  	if (tmpres) {
>>  		int dropping_ref = 0;
>>  
>> +		spin_unlock(&dlm->spinlock);
>> +
>>  		spin_lock(&tmpres->spinlock);
>> +		/* We wait for the other thread that is mastering the resource */
>> +		if (tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
>> +			__dlm_wait_on_lockres(tmpres);
>> +			BUG_ON(tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN);
>> +		}
>>     
>
> Do we have a ref on tmpres here, when we decide to wait on it? Could it get
> destroyed during mastery (for example, due to mastery ending in error) and
> we wake up with a bad pointer?
>   
Yes. __dlm_lookup_lockres_full() takes a reference.
