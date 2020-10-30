From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 30 Oct 2020 08:32:43 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: initialize ip_next_orphan
In-Reply-To: <be1af3a9-bf52-1eda-4724-1beb6e9d2269@linux.alibaba.com>
References: <20201029210455.15587-1-wen.gang.wang@oracle.com>
	<be1af3a9-bf52-1eda-4724-1beb6e9d2269@linux.alibaba.com>
Message-ID: <04a41689-835b-5a6f-a2bd-f5c8df7a8b32@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks for review Joseph,

Please see in lines:

On 10/29/20 10:55 PM, Joseph Qi wrote:
>
> On 2020/10/30 05:04, Wengang Wang wrote:
>> Though problem if found on a lower 4.1.12 kernel, I think upstream
>> has same issue.
>>
>> In one node in the cluster, there is the following callback trace:
>>
>> # cat /proc/21473/stack
>> [<ffffffffc09a2f06>] __ocfs2_cluster_lock.isra.36+0x336/0x9e0 [ocfs2]
>> [<ffffffffc09a4481>] ocfs2_inode_lock_full_nested+0x121/0x520 [ocfs2]
>> [<ffffffffc09b2ce2>] ocfs2_evict_inode+0x152/0x820 [ocfs2]
>> [<ffffffff8122b36e>] evict+0xae/0x1a0
>> [<ffffffff8122bd26>] iput+0x1c6/0x230
>> [<ffffffffc09b60ed>] ocfs2_orphan_filldir+0x5d/0x100 [ocfs2]
>> [<ffffffffc0992ae0>] ocfs2_dir_foreach_blk+0x490/0x4f0 [ocfs2]
>> [<ffffffffc099a1e9>] ocfs2_dir_foreach+0x29/0x30 [ocfs2]
>> [<ffffffffc09b7716>] ocfs2_recover_orphans+0x1b6/0x9a0 [ocfs2]
>> [<ffffffffc09b9b4e>] ocfs2_complete_recovery+0x1de/0x5c0 [ocfs2]
>> [<ffffffff810a1399>] process_one_work+0x169/0x4a0
>> [<ffffffff810a1bcb>] worker_thread+0x5b/0x560
>> [<ffffffff810a7a2b>] kthread+0xcb/0xf0
>> [<ffffffff816f5d21>] ret_from_fork+0x61/0x90
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> The above stack is not reasonable, the final iput shouldn't happen in
>> ocfs2_orphan_filldir() function. Looking at the code,
>>
>> 2067         /* Skip inodes which are already added to recover list, since dio may
>> 2068          * happen concurrently with unlink/rename */
>> 2069         if (OCFS2_I(iter)->ip_next_orphan) {
>> 2070                 iput(iter);
>> 2071                 return 0;
>> 2072         }
>> 2073
>>
>> The logic thinks the inode is already in recover list on seeing
>> ip_next_orphan is non-NULL, so it skip this inode after dropping a
>> reference which incremented in ocfs2_iget().
>>
>> While, if the inode is already in recover list, it should have another
>> reference and the iput() at line 2070 should not be the final iput
>> (dropping the last reference). So I don't think the inode is really
>> in the recover list (no vmcore to confirm).
>>
>> Note that ocfs2_queue_orphans(), though not shown up in the call back trace,
>> is holding cluster lock on the orphan directory when looking up for unlinked
>> inodes. The on disk inode eviction could involve a lot of IOs which may need
>> long time to finish. That means this node could hold the cluster lock for
>> very long time, that can lead to the lock requests (from other nodes) to the
>> orhpan directory hang for long time.
>>
>> Looking at more on ip_next_orphan, I found it's not initialized when
>> allocating a new ocfs2_inode_info structure.
> I don't see the internal relations.

If not initialized, ip_next_orphan could be any value. When it's an 
arbitrary value rather than zero (NULL), the problem would appear (at 
line 2069 and 2070).

But, what I am curious is that why this problem didn't raise much 
earlier? Hope I can find the answer here.

> And AFAIK, ip_next_orphan will be initialized during ocfs2_queue_orphans().
I am not seeing it's initialized in ocfs2_queue_orphans() in source code 
v5.10-rc1. Can you provide more details where it's initialized?

thanks,
wengang
