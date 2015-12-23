From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Wed, 23 Dec 2015 11:20:43 -0800
Subject: [Ocfs2-devel] [PATCH] NFS hangs in __ocfs2_cluster_lock due to
 race with ocfs2_unblock_lock
In-Reply-To: <567A69E9.7090804@huawei.com>
References: <1440536130-29622-1-git-send-email-tariq.x.saeed@oracle.com>
	<567A69E9.7090804@huawei.com>
Message-ID: <567AF40B.4040103@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph,
Many threads doing this:
PID: 6352   TASK: ffff8801a0a30100  CPU: 3   COMMAND: "nfsd"//blocked on 
same lock as 6323 , gen 0
  #0 [ffff8801a0a338d0] __schedule at ffffffff8150a954
  #1 [ffff8801a0a33978] schedule at ffffffff8150b0ef
  #2 [ffff8801a0a33988] schedule_timeout at ffffffff8150b59d
  #3 [ffff8801a0a33a38] wait_for_common at ffffffff8150af7a
  #4 [ffff8801a0a33ad8] wait_for_completion at ffffffff8150b0ad
  #5 [ffff8801a0a33ae8] __ocfs2_cluster_lock at ffffffffa03febd8 [ocfs2]
  #6 [ffff8801a0a33c48] ocfs2_inode_lock_full_nested at ffffffffa0404086 
[ocfs2]
  #7 [ffff8801a0a33cc8] ocfs2_statfs at ffffffffa045462e [ocfs2] <<<< 
does not take mutex of global bit map taken.
  #8 [ffff8801a0a33d28] statfs_by_dentry at ffffffff81199b29
  #9 [ffff8801a0a33d48] vfs_statfs at ffffffff81199b6b
#10 [ffff8801a0a33d68] nfsd_statfs at ffffffffa036bd73 [nfsd]
#11 [ffff8801a0a33da8] nfsd3_proc_fsstat at ffffffffa0374f0d [nfsd]
#12 [ffff8801a0a33dd8] nfsd_dispatch at ffffffffa036743e [nfsd]
#13 [ffff8801a0a33e18] svc_process_common at ffffffffa0278324 [sunrpc]
#14 [ffff8801a0a33e98] svc_process at ffffffffa0278970 [sunrpc]
#15 [ffff8801a0a33eb8] nfsd at ffffffffa0367b92 [nfsd]
#16 [ffff8801a0a33ee8] kthread at ffffffff81090ec6
#17 [ffff8801a0a33f48] kernel_thread_helper at ffffffff815166c4

and the one doing alloc w

PID: 6323   TASK: ffff8801a7054640  CPU: 0   COMMAND: "nfsd"
  #0 [ffff8801a7056f10] __schedule at ffffffff8150a954
  #1 [ffff8801a7056fb8] schedule at ffffffff8150b0ef
  #2 [ffff8801a7056fc8] schedule_timeout at ffffffff8150b59d
  #3 [ffff8801a7057078] wait_for_common at ffffffff8150af7a
  #4 [ffff8801a7057118] wait_for_completion at ffffffff8150b0ad
  #5 [ffff8801a7057128] __ocfs2_cluster_lock at ffffffffa03febd8 [ocfs2]
  #6 [ffff8801a7057288] ocfs2_inode_lock_full_nested at ffffffffa0404086 
[ocfs2]
  #7 [ffff8801a7057308] ocfs2_reserve_suballoc_bits at ffffffffa043f199 
[ocfs2]  <<<< takes global bit map mutex
  #8 [ffff8801a7057388] ocfs2_reserve_cluster_bitmap_bits at 
ffffffffa043f5f5 [ocfs2]
  #9 [ffff8801a70573b8] ocfs2_local_alloc_reserve_for_window at 
ffffffffa04198a4 [ocfs2]
#10 [ffff8801a7057418] ocfs2_local_alloc_slide_window at 
ffffffffa041b5a0 [ocfs2]
#11 [ffff8801a7057498] ocfs2_reserve_local_alloc_bits at 
ffffffffa041bc67 [ocfs2]
#12 [ffff8801a70574f8] ocfs2_reserve_clusters_with_limit at 
ffffffffa043e8c5 [ocfs2]
#13 [ffff8801a7057548] ocfs2_reserve_clusters at ffffffffa043f7f8 [ocfs2]
#14 [ffff8801a7057558] ocfs2_lock_allocators at ffffffffa044021e [ocfs2]
#15 [ffff8801a70575b8] ocfs2_write_begin_nolock at ffffffffa03ed713 [ocfs2]
#16 [ffff8801a7057758] ocfs2_write_begin at ffffffffa03ee0c6 [ocfs2]
#17 [ffff8801a70577e8] generic_perform_write at ffffffff8110ffc3
#18 [ffff8801a7057888] generic_file_buffered_write_iter at ffffffff811100eb
#19 [ffff8801a70578b8] ocfs2_file_write_iter at ffffffffa040a837 [ocfs2]
#20 [ffff8801a70579c8] ocfs2_file_aio_write at ffffffffa040af28 [ocfs2]
#21 [ffff8801a7057a38] do_sync_readv_writev at ffffffff8116cf7b
#22 [ffff8801a7057b48] do_readv_writev at ffffffff8116ddf4
#23 [ffff8801a7057c28] vfs_writev at ffffffff8116df46
#24 [ffff8801a7057c38] nfsd_vfs_write at ffffffffa036c7f3 [nfsd]
#25 [ffff8801a7057d08] nfsd_write at ffffffffa036de77 [nfsd]
#26 [ffff8801a7057d68] nfsd3_proc_write at ffffffffa03762ff [nfsd]
#27 [ffff8801a7057dd8] nfsd_dispatch at ffffffffa036743e [nfsd]
#28 [ffff8801a7057e18] svc_process_common at ffffffffa0278324 [sunrpc]
#29 [ffff8801a7057e98] svc_process at ffffffffa0278970 [sunrpc]
#30 [ffff8801a7057eb8] nfsd at ffffffffa0367b92 [nfsd]
#31 [ffff8801a7057ee8] kthread at ffffffff81090ec6
#32 [ffff8801a7057f48] kernel_thread_helper@ffffffff815166c4

Thanks
-Tariq

On 12/23/2015 01:31 AM, Joseph Qi wrote:
> Hi Tariq,
> As I know, global bitmap inode mutex will be held when doing allocation.
> So how can it happen that EX and PR requests come concurrently int the
> same node?
>
> Thanks,
> Joseph
>
> On 2015/8/26 4:55, Tariq Saeed wrote:
>> Orabug: 20933419
>>
>> NFS on a 2 node ocfs2 cluster each node exporting dir. The lock causing
>> the hang is the global bit map inode lock.  Node 1 is master, has
>> the lock granted in PR mode; Node 2 is in the converting list (PR ->
>> EX). There are no holders of the lock on the master node so it should
>> downconvert to NL and grant EX to node 2 but that does not happen.
>> BLOCKED + QUEUED in lock res are set and it is on osb blocked list.
>> Threads are waiting in __ocfs2_cluster_lock on BLOCKED.  One thread wants
>> EX, rest want PR. So it is as though the downconvert thread needs to be
>> kicked to complete the conv.
>>
>> The hang is caused by an EX req coming into  __ocfs2_cluster_lock on
>> the heels of a PR req after it sets BUSY (drops l_lock, releasing EX
>> thread), forcing the incoming EX to wait on BUSY without doing anything.
>> PR has called ocfs2_dlm_lock, which  sets the node 1 lock from NL ->
>> PR, queues ast.
>>
>> At this time, upconvert (PR ->EX) arrives from node 2, finds conflict with
>> node 1 lock in PR, so the lock res is put on dlm thread's dirty listt.
>>
>> After ret from ocf2_dlm_lock, PR thread now waits behind EX on BUSY till
>> awoken by ast.
>>
>> Now it is dlm_thread that serially runs dlm_shuffle_lists, ast,  bast,
>> in that order.  dlm_shuffle_lists ques a bast on behalf of node 2
>> (which will be run by dlm_thread right after the ast).  ast does its
>> part, sets UPCONVERT_FINISHING, clears BUSY and wakes its waiters. Next,
>> dlm_thread runs  bast. It sets BLOCKED and kicks dc thread.  dc thread
>> runs ocfs2_unblock_lock, but since UPCONVERT_FINISHING set, skips doing
>> anything and reques.
>>
>> Inside of __ocfs2_cluster_lock, since EX has been waiting on BUSY ahead
>> of PR, it wakes up first, finds BLOCKED set and skips doing anything
>> but clearing UPCONVERT_FINISHING (which was actually "meant" for the
>> PR thread), and this time waits on BLOCKED.  Next, the PR thread comes
>> out of wait but since UPCONVERT_FINISHING is not set, it skips updating
>> the l_ro_holders and goes straight to wait on BLOCKED. So there, we
>> have a hang! Threads in __ocfs2_cluster_lock wait on BLOCKED, lock
>> res in osb blocked list. Only when dc thread is awoken, it will run
>> ocfs2_unblock_lock and things will unhang.
>>
>> One way to fix this is to wake the dc thread on the flag after clearing
>> UPCONVERT_FINISHING
>>
>> Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
>> Reviewed-by: Wengang Wang <wen.gang.wang@oracle.com>
>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
>> ---
>>   fs/ocfs2/dlmglue.c |    6 ++++++
>>   1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>> index 8b23aa2..313c816 100644
>> --- a/fs/ocfs2/dlmglue.c
>> +++ b/fs/ocfs2/dlmglue.c
>> @@ -1390,6 +1390,7 @@ static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
>>   	unsigned int gen;
>>   	int noqueue_attempted = 0;
>>   	int dlm_locked = 0;
>> +	int kick_dc = 0;
>>   
>>   	if (!(lockres->l_flags & OCFS2_LOCK_INITIALIZED)) {
>>   		mlog_errno(-EINVAL);
>> @@ -1524,7 +1525,12 @@ update_holders:
>>   unlock:
>>   	lockres_clear_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING);
>>   
>> +	/* ocfs2_unblock_lock reques on seeing OCFS2_LOCK_UPCONVERT_FINISHING */
>> +	kick_dc = (lockres->l_flags & OCFS2_LOCK_BLOCKED);
>> +
>>   	spin_unlock_irqrestore(&lockres->l_lock, flags);
>> +	if (kick_dc)
>> +		ocfs2_wake_downconvert_thread(osb);
>>   out:
>>   	/*
>>   	 * This is helping work around a lock inversion between the page lock
>>
>
