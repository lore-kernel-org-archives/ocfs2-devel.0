From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 16 Jun 2010 15:39:30 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: delay the migration when the
 lockres is in recovery
In-Reply-To: <4C18746A.90908@oracle.com>
References: <201005250801.o4P6iFtZ005833@acsinet15.oracle.com>
	<20100611102551.GA3990@laptop.us.oracle.com>
	<4C18746A.90908@oracle.com>
Message-ID: <20100616073930.GA3298@laptop.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-06-15 23:51, Srinivas Eeda wrote:
>patch looks good, it fixes the umount code path which prevents a lockres
>from migrating if it needs to be recovered. I have few comments on the
>scenario you described.
>
> On 10-05-25 15:59, Wengang Wang wrote:
>   
>> We shouldn't migrate a lockres in recovery state.
>> Otherwise, it has the following problem:
>>
>> 1) Recovery happened as recovery master on a node(node A) which is in
>> umount
>> migrating all lockres' it owned(master is node A) to other nodes, say
>> a node B.
>> 2) So node A wants to take over all the lockres' those are mastered
>> by the
>> crashed node C. 
>> 3) Receiving request_locks request from node A, node B send
>> mig_lockres
>> requests(for recovery) to node A for all lockres' that was mastered
>> by the
>> crashed node C. It can also send the request for a lockres(lockres A)
>> which is
>> not in node A's hashtable.
>>     
>why wouldn't lockres A be in node A's hashtable? if it's not in hash
>table, then it won't be migratable

In step 3), I am talking about the recovery process of node A(not the
migration for umount).
Before node C crashes, the master of lockres A is node B. Node C has a ref
on lockres A, but node A doesn't know anything about lockres A.
Now node C crashed, node A is requesting(from node B) all lockres' that's
owned by the crashed node(node C) and those which is in progress of migrating
with the crashed node. Here lockres A is such a lockres that is in progress of
migration from node B to node C when node C crashed. So node B can send lockres
A, which is not in node A's hashtable before, to node A.

see dlm_clean_master_list(). It's moving lockres A to recovery list.
mle->new_master == dead_node

Hope my description is clear :)

regards,
wengang.
