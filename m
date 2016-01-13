From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 13 Jan 2016 10:15:43 +0800
Subject: [Ocfs2-devel] [PATCH] revert to using ocfs2_acl_chmod to avoid
 inode cluster lock hang
In-Reply-To: <56931EB2.9070403@oracle.com>
References: <1452047231-30569-1-git-send-email-tariq.x.saeed@oracle.com>
	<20160107225507.GB819@wotan.suse.de> <568EF987.9080904@oracle.com>
	<56931EB2.9070403@oracle.com>
Message-ID: <5695B34F.5000608@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

On 01/11/2016 11:17 AM, Junxiao Bi wrote:
> On 01/08/2016 07:49 AM, Tariq Saeed wrote:
>>
>> On 01/07/2016 02:55 PM, Mark Fasheh wrote:
>>> So you could replace that last paragraph with something like this:
>>>
>>> The deleted version of ocfs2_acl_chmod() calls __posix_acl_chmod() which
>>> does not call back into the filesystem. Therefore, we restore
>>> ocfs2_acl_chmod() and use that instead.
>> Thanks for reviewing. I have two more code paths to fix.
>>
>> 1. ocfs2_mknod()->posix_acl_create()->ocfs2_iop_get_acl()
>> 2. ocfs2_reflink ->  ocfs2_init_security_and_acl -> ocfs2_iop_set_acl
> Caught one more.
> 
> ocfs2_orphan_filldir()->ocfs2_iget()->ocfs2_read_locked_inode(), inode
> open lock was locked. Later ocfs2_query_inode_wipe() locked the same
> open lock again!
What's your idea about fixing the above recursive locking?
It is recursive locking, but no deadlock since second one is using try
locking.

Thanks,
Junxiao.
> 
> See detailed call trace(change my original recursive locking support
> patch a little to catch recursive locking):
> 
> [240869.116872] (kworker/u30:1,1436,0):__ocfs2_cluster_lock:1563 ERROR:
> recursive locking rejected!
> [240869.122725] CPU: 0 PID: 1436 Comm: kworker/u30:1 Tainted: G
>   O    4.4.0-rc8-next-20160105 #1
> [240869.137262] Hardware name: Xen HVM domU, BIOS 4.3.1OVM 05/14/2014
> [240869.148014] Workqueue: ocfs2_wq ocfs2_complete_recovery [ocfs2]
> [240869.159213]  0000000000000000 ffff88004b94f568 ffffffff81346cc4
> 0000000000000000
> [240869.173066]  1000000000000800 ffff88003afe1b60 ffff88001b1bbc98
> ffff88004b94f6d8
> [240869.191668]  ffffffffa00f78bc ffff88004b94f588 ffffffffa0104bed
> ffff88004b94f598
> [240869.207480] Call Trace:
> [240869.212521]  [<ffffffff81346cc4>] dump_stack+0x48/0x64
> [240869.222182]  [<ffffffffa00f78bc>] __ocfs2_cluster_lock+0x4ac/0x970
> [ocfs2]
> [240869.235512]  [<ffffffffa0104bed>] ?
> ocfs2_inode_cache_io_unlock+0xd/0x10 [ocfs2]
> [240869.249301]  [<ffffffffa0143b24>] ?
> ocfs2_metadata_cache_io_unlock+0x14/0x30 [ocfs2]
> [240869.265103]  [<ffffffffa00ebaae>] ? ocfs2_read_blocks+0x3be/0x5e0
> [ocfs2]
> [240869.277703]  [<ffffffff810a158e>] ? __wake_up+0x4e/0x70
> [240869.287446]  [<ffffffffa00f9c5e>] ocfs2_try_open_lock+0xfe/0x110 [ocfs2]
> [240869.300877]  [<ffffffffa0106737>] ?
> ocfs2_query_inode_wipe+0xe7/0x250 [ocfs2]
> [240869.316895]  [<ffffffffa0106737>] ocfs2_query_inode_wipe+0xe7/0x250
> [ocfs2]
> [240869.329955]  [<ffffffffa0107d7f>] ? ocfs2_evict_inode+0x13f/0x350
> [ocfs2]
> [240869.342520]  [<ffffffffa0107da5>] ocfs2_evict_inode+0x165/0x350 [ocfs2]
> [240869.354518]  [<ffffffff810a11a0>] ? wake_atomic_t_function+0x30/0x30
> [240869.366326]  [<ffffffff811af043>] evict+0xd3/0x1c0
> [240869.373057]  [<ffffffffa0106f8f>] ? ocfs2_drop_inode+0x6f/0x100 [ocfs2]
> [240869.382059]  [<ffffffff81346c50>] ? _atomic_dec_and_lock+0x50/0x70
> [240869.390458]  [<ffffffff811af39d>] iput+0x19d/0x210
> [240869.397095]  [<ffffffffa0109c2a>] ocfs2_orphan_filldir+0x9a/0x140
> [ocfs2]
> [240869.409187]  [<ffffffffa00f1866>] ocfs2_dir_foreach_blk+0x1b6/0x4d0
> [ocfs2]
> [240869.423581]  [<ffffffffa00f1ba4>] ocfs2_dir_foreach+0x24/0x30 [ocfs2]
> [240869.436807]  [<ffffffffa0109a70>] ocfs2_queue_orphans+0x90/0x1b0 [ocfs2]
> [240869.450569]  [<ffffffffa0109b90>] ? ocfs2_queue_orphans+0x1b0/0x1b0
> [ocfs2]
> [240869.467103]  [<ffffffffa010c099>] ocfs2_recover_orphans+0x49/0x420
> [ocfs2]
> [240869.485250]  [<ffffffff8108131f>] ? __queue_delayed_work+0x8f/0x190
> [240869.497945]  [<ffffffffa010c674>]
> ocfs2_complete_recovery+0x204/0x440 [ocfs2]
> [240869.512787]  [<ffffffff8108105b>] ? pwq_dec_nr_in_flight+0x4b/0xa0
> [240869.525181]  [<ffffffff810819d8>] process_one_work+0x168/0x4c0
> [240869.534732]  [<ffffffff810c2244>] ? internal_add_timer+0x34/0x90
> [240869.545003]  [<ffffffff810c40d6>] ? mod_timer+0xf6/0x1b0
> [240869.555854]  [<ffffffff8191e6ab>] ? schedule+0x3b/0xa0
> [240869.566496]  [<ffffffff8191e671>] ? schedule+0x1/0xa0
> [240869.576832]  [<ffffffff810827b9>] worker_thread+0x159/0x6d0
> [240869.588197]  [<ffffffff8109b7c1>] ? put_prev_task_fair+0x21/0x40
> [240869.600286]  [<ffffffff8191df6f>] ? __schedule+0x38f/0x980
> [240869.611697]  [<ffffffff8108f41d>] ? default_wake_function+0xd/0x10
> [240869.622461]  [<ffffffff810a1031>] ? __wake_up_common+0x51/0x80
> [240869.629365]  [<ffffffff81082660>] ? create_worker+0x190/0x190
> [240869.635999]  [<ffffffff8191e6ab>] ? schedule+0x3b/0xa0
> [240869.641966]  [<ffffffff81082660>] ? create_worker+0x190/0x190
> [240869.648574]  [<ffffffff81086f37>] kthread+0xc7/0xe0
> [240869.653436]  [<ffffffff8108e8f9>] ? schedule_tail+0x19/0xb0
> [240869.661235]  [<ffffffff81086e70>] ?
> kthread_freezable_should_stop+0x70/0x70
> [240869.675121]  [<ffffffff8192224f>] ret_from_fork+0x3f/0x70
> [240869.685850]  [<ffffffff81086e70>] ?
> kthread_freezable_should_stop+0x70/0x70
> [240869.700005] (kworker/u30:1,1436,0):ocfs2_query_inode_wipe:984 ERROR:
> status = -1
> [240869.714660] (kworker/u30:1,1436,0):ocfs2_delete_inode:1085 ERROR:
> status = -1
> 
> Thanks,
> Junxiao.
>>
>> I will make your suggested change and submit again
>> a 3-part patch, including the above two.
>> -Tariq
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
> 
