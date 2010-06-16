From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue, 15 Jun 2010 23:51:22 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: delay the migration when the
 lockres is in recovery
In-Reply-To: <20100611102551.GA3990@laptop.us.oracle.com>
References: <201005250801.o4P6iFtZ005833@acsinet15.oracle.com>
	<20100611102551.GA3990@laptop.us.oracle.com>
Message-ID: <4C18746A.90908@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

patch looks good, it fixes the umount code path which prevents a lockres 
from migrating if it needs to be recovered. I have few comments on the 
scenario you described.

On 6/11/2010 3:25 AM, Wengang Wang wrote:
> Any comment on this patch?
>
> regards,
> wengang.
> On 10-05-25 15:59, Wengang Wang wrote:
>   
>> We shouldn't migrate a lockres in recovery state.
>> Otherwise, it has the following problem:
>>
>> 1) Recovery happened as recovery master on a node(node A) which is in umount
>> migrating all lockres' it owned(master is node A) to other nodes, say a node B.
>> 2) So node A wants to take over all the lockres' those are mastered by the
>> crashed node C. 
>> 3) Receiving request_locks request from node A, node B send mig_lockres
>> requests(for recovery) to node A for all lockres' that was mastered by the
>> crashed node C. It can also send the request for a lockres(lockres A) which is
>> not in node A's hashtable.
>>     
why wouldn't lockres A be in node A's hashtable? if it's not in hash 
table, then it won't be migratable
>> 4) Receiving the mig_lockres request for lockres A from node B, a new lockres
>> object lockres A', with INRECOVERING flag set, is created and inserted to hash
>> table.
>> 5) The recovery for lockres A' is going on on node A, it finally mastered the
>> lockres A'. And now, RECOVERING flag is not cleared from lockres A' nor from
>> lockres A on node B.
>> 6) The migration for lockres A' goes since now node A mastered lockres A' already.
>> the mig_lockres request(for migration) is sent to node B.
>> 7) Node B responsed with -EFAULT because now lockres A is still in recovery state.
>> 8) Node A BUG() on the -EFAULT.
>>
>> fix:
>> The recovery state is cleared on node A(recovery master) after it's cleared on
>> node B. We wait until the in recovery state is cleared from node A and migrate
>> it to node B. 
>>
>> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
>> ---
>>  fs/ocfs2/dlm/dlmmaster.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
>> index 9289b43..de9c128 100644
>> --- a/fs/ocfs2/dlm/dlmmaster.c
>> +++ b/fs/ocfs2/dlm/dlmmaster.c
>> @@ -2371,6 +2371,9 @@ static int dlm_is_lockres_migrateable(struct dlm_ctxt *dlm,
>>  		goto leave;
>>  	}
>>  
>> +	if (unlikely(res->state & DLM_LOCK_RES_RECOVERING))
>> +		goto leave;
>> +
>>  	ret = 0;
>>  	queue = &res->granted;
>>  	for (i = 0; i < 3; i++) {
>> -- 
>> 1.6.6.1
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>     
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>   
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20100615/3a7a0ef6/attachment.html 
