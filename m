From: Changwei Ge <ge.changwei@h3c.com>
Date: Wed, 24 Jan 2018 06:43:32 +0000
Subject: [Ocfs2-devel] OCFS2 encountered a hang issue when running on
 Multi-nodes RefcountBlock Group Test
References: <5A688EC1020000F9000A5FB8@prv-mh.provo.novell.com>
	<5A689724020000F9000A5FC3@prv-mh.provo.novell.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F2914239@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Gang,

Never met such a lockup issue so far with o2cb stack applied.
And I don't know how to debug this with fs/dlm.
What I suspect currently is that this lock resource was once QUEUED but fail to re-QUEUED since BLOCKED has been marked.

Thanks,
Changwei


On 2018/1/24 14:30, Gang He wrote:
> Hello Guys,
> 
> I met a ocfs2 hang issue when running on Multi-nodes Refcount Block Group Test on three nodes cluster, this hang issue can not reproduced each time, but it looks there is a bug in dlmglue layer.
> The bug symptom looks as below,
> Node1:
> ocfs2te+  2403  2372  2403  0    1 Jan18 ?        00:00:00 /usr/lib64/mpi/gcc/openmpi/bin/orted --hnp-topo-sig 0N:4S:0L3:4L2:4L1:4C:4H:x86_64 -mca ess env -mca orte_ess_jobid 174456832 -mca orte_es
> ocfs2te+  2404  2403  2404  0    2 Jan18 ?        00:00:06 /usr/local/ocfs2-test/bin/multi_reflink_test -i 1 -p 1000 -l 10485760 -n 100 -w /mnt/shared/ocfs2-discontig-bg-test-multi-nodes -s         <<== hang process
> ocfs2te+  2404  2403  2405  0    2 Jan18 ?        00:00:00 /usr/local/ocfs2-test/bin/multi_reflink_test -i 1 -p 1000 -l 10485760 -n 100 -w /mnt/shared/ocfs2-discontig-bg-test-multi-nodes -s
> sle15b4-nd1:/ # cat /proc/2404/stack
> [<ffffffffc06878e5>] __ocfs2_cluster_lock.isra.37+0x2a5/0x6d0 [ocfs2]
> [<ffffffffc0688918>] ocfs2_inode_lock_full_nested+0x1d8/0x930 [ocfs2]
> [<ffffffffc068912d>] ocfs2_inode_lock_tracker+0xbd/0x180 [ocfs2]
> [<ffffffffc068bfcc>] ocfs2_permission+0x3c/0xc0 [ocfs2]
> [<ffffffff8e23def9>] __inode_permission+0x69/0xc0
> [<ffffffff8e23ff9c>] link_path_walk+0x26c/0x4e0
> [<ffffffff8e241c93>] path_openat+0xd3/0x1570
> [<ffffffff8e24429c>] do_filp_open+0x8c/0xf0
> [<ffffffff8e231586>] do_sys_open+0x1a6/0x230
> [<ffffffff8e6acfb7>] entry_SYSCALL_64_fastpath+0x1a/0xa5
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Node2:
> ocfs2te+ 21312 28669 21312  0    2 Jan18 pts/2    00:00:00 /usr/lib64/mpi/gcc/openmpi/bin/mpirun -mca plm_rsh_agent ssh:rsh -mca btl tcp,self --host sle15b4-nd2,sle15b4-nd1,sle15b4-nd3 /usr/local/o
> ocfs2te+ 21312 28669 21313  0    2 Jan18 pts/2    00:00:00 /usr/lib64/mpi/gcc/openmpi/bin/mpirun -mca plm_rsh_agent ssh:rsh -mca btl tcp,self --host sle15b4-nd2,sle15b4-nd1,sle15b4-nd3 /usr/local/o
> ocfs2te+ 21314 21312 21314  0    1 Jan18 pts/2    00:00:00 /usr/bin/ssh -x sle15b4-nd1     PATH=/usr/lib64/mpi/gcc/openmpi/bin:$PATH ; export PATH ; LD_LIBRARY_PATH=/usr/lib64/mpi/gcc/openmpi/lib64
> ocfs2te+ 21315 21312 21315  0    1 Jan18 pts/2    00:00:00 /usr/bin/ssh -x sle15b4-nd3     PATH=/usr/lib64/mpi/gcc/openmpi/bin:$PATH ; export PATH ; LD_LIBRARY_PATH=/usr/lib64/mpi/gcc/openmpi/lib64
> ocfs2te+ 21316 21312 21316  0    2 Jan18 pts/2    00:00:07 /usr/local/ocfs2-test/bin/multi_reflink_test -i 1 -p 1000 -l 10485760 -n 100 -w /mnt/shared/ocfs2-discontig-bg-test-multi-nodes -s <<== hang process
> ocfs2te+ 21316 21312 21317  0    2 Jan18 pts/2    00:00:00 /usr/local/ocfs2-test/bin/multi_reflink_test -i 1 -p 1000 -l 10485760 -n 100 -w /mnt/shared/ocfs2-discontig-bg-test-multi-nodes -s
> sle15b4-nd2:/ # cat /proc/21316/stack
> [<ffffffffc06bc8e5>] __ocfs2_cluster_lock.isra.37+0x2a5/0x6d0 [ocfs2]
> [<ffffffffc06bd918>] ocfs2_inode_lock_full_nested+0x1d8/0x930 [ocfs2]
> [<ffffffffc06d6cd0>] ocfs2_mknod+0x1e0/0xeb0 [ocfs2]
> [<ffffffffc06d7af5>] ocfs2_create+0x35/0x120 [ocfs2]
> [<ffffffffa6242e41>] path_openat+0x1281/0x1570
> [<ffffffffa624429c>] do_filp_open+0x8c/0xf0
> [<ffffffffa6231586>] do_sys_open+0x1a6/0x230
> [<ffffffffa66acfb7>] entry_SYSCALL_64_fastpath+0x1a/0xa5
> [<ffffffffffffffff>] 0x
> 
> Node3:
> ocfs2te+ 13108 13079 13108  0    1 Jan18 ?        00:00:00 /usr/lib64/mpi/gcc/openmpi/bin/orted --hnp-topo-sig 0N:4S:0L3:4L2:4L1:4C:4H:x86_64 -mca ess env -mca orte_ess_jobid 174456832 -mca orte_es
> ocfs2te+ 13109 13108 13109  0    2 Jan18 ?        00:00:06 /usr/local/ocfs2-test/bin/multi_reflink_test -i 1 -p 1000 -l 10485760 -n 100 -w /mnt/shared/ocfs2-discontig-bg-test-multi-nodes -s <<== hang process
> ocfs2te+ 13109 13108 13110  0    2 Jan18 ?        00:00:00 /usr/local/ocfs2-test/bin/multi_reflink_test -i 1 -p 1000 -l 10485760 -n 100 -w /mnt/shared/ocfs2-discontig-bg-test-multi-nodes -s
> sle15b4-nd3:~ # cat /proc/13109/stack
> [<ffffffffc08b48e5>] __ocfs2_cluster_lock.isra.37+0x2a5/0x6d0 [ocfs2]
> [<ffffffffc08b5918>] ocfs2_inode_lock_full_nested+0x1d8/0x930 [ocfs2]
> [<ffffffffc08d2907>] ocfs2_mv_orphaned_inode_to_new+0x77/0x7b0 [ocfs2]
> [<ffffffffc08dd019>] ocfs2_reflink+0x309/0x430 [ocfs2]
> [<ffffffffc08dd866>] ocfs2_reflink_ioctl+0x2a6/0x330 [ocfs2]
> [<ffffffffc08c3537>] ocfs2_ioctl+0x237/0x640 [ocfs2]
> [<ffffffff81247b2d>] do_vfs_ioctl+0x8d/0x5d0
> [<ffffffff812480e4>] SyS_ioctl+0x74/0x80
> [<ffffffff816acfb7>] entry_SYSCALL_64_fastpath+0x1a/0xa5
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> These three processes in the cluster have been hanged for more than one days,
> The processes on Node1 and Node2 are hanged at getting meta-dlm-lock (from NL to PR or EX) of inode 20122639 (dentry is "ocfs2-discontig-bg-test-multi-nodes"),
> Node3 has hold this inode meta-dlm-lock with EX level, but the process on Node3 is trying to get meta-dlm-lock again and is hanged at waitting for lockres blocked flag clear.
> But this lockres is not queued on Node3, the memory dump looks like,
>   ip_inode_lockres = {
>      l_priv = 0xffff9edb6af75458,
>      l_ops = 0xffffffffc0952160 <ocfs2_inode_inode_lops>,
>      l_blocked_list = {
>        next = 0xffff9edb6af75160, <<= NOT in block lock list of super obj
>        prev = 0xffff9edb6af75160
>      },
>      l_mask_waiters = {
>        next = 0xffffb6e140453bd0,
>        prev = 0xffffb6e141bc3d10
>      },
>      l_holders = {
>        next = 0xffff9edb6af75180,
>        prev = 0xffff9edb6af75180
>      },
>      l_flags = 69,  <<== No OCFS2_LOCK_QUEUED flag
>      l_name = "M0000000000000001330c0f00000000",
>      l_ro_holders = 0,
>      l_ex_holders = 0,
>      l_level = 5 '\005',
>      l_requested = 0 '\000',
>      l_blocking = 5 '\005',
>      l_type = 0 '\000',
>      l_action = 0 '\000',
>      l_unlock_action = 0 '\000',
>      l_pending_gen = 4997,
> 
> In fact, OSB on Node 3 has a empty block lock list, that means this lockres will not be handled anymore.
>    dc_work_sequence = 174228,
>    blocked_lock_list = {   << == empty list
>      next = 0xffff9edb991e4660,
>      prev = 0xffff9edb991e4660
>    },
>    blocked_lock_count = 0,
>    dquot_drop_list = {
>      first = 0x0
>    },
>    dquot_drop_work = {
> 
> So, these processes on each node will be hanged forever, it looks there is a bug for queuing lockres.
> Did you meet this bug before I investigate it further?
> 
> Thanks a lot.
> Gang
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
