From: Xue jiufei <xuejiufei@huawei.com>
Date: Mon, 05 Nov 2012 16:45:24 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2:fix memory leak in
 dlm_add_migration_mle
In-Reply-To: <5093DE48.9090805@oracle.com>
References: <50938971.9010805@huawei.com> <5093DE48.9090805@oracle.com>
Message-ID: <50977CA4.1080603@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jeff
? 2012/11/2 22:52, Jeff Liu ??:
> Hi Jiefei,
> 
> On 11/02/2012 04:50 PM, Xue jiufei wrote:
>> After some parallel mount/umount test on ocfs2, we got this: slab error
>> in kmem_cache_destroy(): cache `o2dlm_mle': Can't free all objects.
>>
>> Then we found a memleak situation in dlm_add_migration_mle().
>> When a mle found, it will be removed from dlm->hlist. If there is no
>> pointer to it at that moment, the mle will become an ?orphan mle?
>> that no process can find and release.
>>
>> Signed-off-by: Xuejiufei <xuejiufei@huawei.com>
>> ---
>>  fs/ocfs2/dlm/dlmmaster.c |   11 ++++++++++-
>>  1 files changed, 10 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
>> index 005261c..20d2307 100644
>> --- a/fs/ocfs2/dlm/dlmmaster.c
>> +++ b/fs/ocfs2/dlm/dlmmaster.c
>> @@ -284,6 +284,7 @@ static void dlm_init_mle(struct dlm_master_list_entry *mle,
>>  	mle->master = O2NM_MAX_NODES;
>>  	mle->new_master = O2NM_MAX_NODES;
>>  	mle->inuse = 0;
>> +	mle->assert_master = 0;
>>  
>>  	BUG_ON(mle->type != DLM_MLE_BLOCK &&
>>  	       mle->type != DLM_MLE_MASTER &&
>> @@ -1743,6 +1744,7 @@ int dlm_assert_master_handler(struct o2net_msg *msg, u32 len, void *data,
>>  	u32 flags;
>>  	int master_request = 0, have_lockres_ref = 0;
>>  	int ret = 0;
>> +	int bit;
>>  
>>  	if (!dlm_grab(dlm))
>>  		return 0;
>> @@ -1770,7 +1772,11 @@ int dlm_assert_master_handler(struct o2net_msg *msg, u32 len, void *data,
>>  		     "MLE for it! (%.*s)\n", assert->node_idx,
>>  		     namelen, name);
>>  	} else {
> Looks good.
> I  am being really picky, looks there is no need to move bit variable to
> be function level, i.e.
> 
> 		int bit;
> 
> 		spin_lock(&mle->spinlock);
> 		mle->assert_master = 1;
> 		spin_unlock(&mle->spinlock);
> 		bit = find_next_bit(mle->maybe_map, O2NM_MAX_NODES, 0);
> 
> Thanks,
> -Jeff
>> -		int bit = find_next_bit (mle->maybe_map, O2NM_MAX_NODES, 0);
>> +		spin_lock(&mle->spinlock);
>> +		mle->assert_master = 1;
>> +		spin_unlock(&mle->spinlock);
>> +
>> +		bit = find_next_bit (mle->maybe_map, O2NM_MAX_NODES, 0);
>>  		if (bit >= O2NM_MAX_NODES) {
>>  			/* not necessarily an error, though less likely.
>>  			 * could be master just re-asserting. */
>> @@ -3081,6 +3087,8 @@ static int dlm_add_migration_mle(struct dlm_ctxt *dlm,
>>  			/* remove it so that only one mle will be found */
>>  			__dlm_unlink_mle(dlm, tmp);
>>  			__dlm_mle_detach_hb_events(dlm, tmp);
>> +			if (tmp->type == DLM_MLE_BLOCK && tmp->assert_master == 0)
>> +				__dlm_put_mle(tmp);
>>  			ret = DLM_MIGRATE_RESPONSE_MASTERY_REF;
>>  			mlog(0, "%s:%.*s: master=%u, newmaster=%u, "
>>  			    "telling master to get ref for cleared out mle "
>> @@ -3173,6 +3181,7 @@ static void dlm_clean_block_mle(struct dlm_ctxt *dlm,
>>  		wake_up(&mle->wq);
>>  
>>  		/* Do not need events any longer, so detach from heartbeat */
>> +		__dlm_unlink_mle(dlm, mle);
>>  		__dlm_mle_detach_hb_events(dlm, mle);
>>  		__dlm_put_mle(mle);
>>  	}
>>
> 
> .
> 

Thank you for the suggestion and I really agree with you. 
Here is the patch after modification:

Signed-off-by: Xuejiufei <xuejiufei@huawei.com 
---
 fs/ocfs2/dlm/dlmmaster.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 005261c..2458b29 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -284,6 +284,7 @@ static void dlm_init_mle(struct dlm_master_list_entry *mle,
 	mle->master = O2NM_MAX_NODES;
 	mle->new_master = O2NM_MAX_NODES;
 	mle->inuse = 0;
+	mle->assert_master = 0;
 
 	BUG_ON(mle->type != DLM_MLE_BLOCK &&
 	       mle->type != DLM_MLE_MASTER &&
@@ -1770,7 +1771,12 @@ int dlm_assert_master_handler(struct o2net_msg *msg, u32 len, void *data,
 		     "MLE for it! (%.*s)\n", assert->node_idx,
 		     namelen, name);
 	} else {
-		int bit = find_next_bit (mle->maybe_map, O2NM_MAX_NODES, 0);
+		int bit;
+		spin_lock(&mle->spinlock);
+		mle->assert_master = 1;
+		spin_unlock(&mle->spinlock);
+
+		bit = find_next_bit (mle->maybe_map, O2NM_MAX_NODES, 0);
 		if (bit >= O2NM_MAX_NODES) {
 			/* not necessarily an error, though less likely.
 			 * could be master just re-asserting. */
@@ -3081,6 +3087,8 @@ static int dlm_add_migration_mle(struct dlm_ctxt *dlm,
 			/* remove it so that only one mle will be found */
 			__dlm_unlink_mle(dlm, tmp);
 			__dlm_mle_detach_hb_events(dlm, tmp);
+			if (tmp->type == DLM_MLE_BLOCK && tmp->assert_master == 0)
+				__dlm_put_mle(tmp);
 			ret = DLM_MIGRATE_RESPONSE_MASTERY_REF;
 			mlog(0, "%s:%.*s: master=%u, newmaster=%u, "
 			    "telling master to get ref for cleared out mle "
@@ -3173,6 +3181,7 @@ static void dlm_clean_block_mle(struct dlm_ctxt *dlm,
 		wake_up(&mle->wq);
 
 		/* Do not need events any longer, so detach from heartbeat */
+		__dlm_unlink_mle(dlm, mle);
 		__dlm_mle_detach_hb_events(dlm, mle);
 		__dlm_put_mle(mle);
 	}
-- 
1.7.8.6
