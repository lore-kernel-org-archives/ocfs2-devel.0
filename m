From: David Teigland <teigland@redhat.com>
Date: Wed, 15 Apr 2009 11:57:17 -0500
Subject: [Ocfs2-devel] hang with fsdlm
Message-ID: <20090415165717.GD22705@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Using fsdlm/ocfs2_controld.cman, I've rerun the test I've been having problems
with on 2.6.30-rc1.  After running for several minutes in the same directory
on three nodes, the test hangs, and I collect the following information:


bull-01
-------

 3053 S<   [ocfs2dc]                   ocfs2_downconvert_thread
 3054 S<   [dlm_astd]                  dlm_astd
 3055 S<   [dlm_scand]                 dlm_scand
 3056 S<   [dlm_recv/0]                worker_thread
 3057 S<   [dlm_recv/1]                worker_thread
 3058 S<   [dlm_recv/2]                worker_thread
 3059 S<   [dlm_recv/3]                worker_thread
 3060 S<   [dlm_send]                  worker_thread
 3061 S<   [dlm_recoverd]              dlm_recoverd
 3067 S<   [kjournald2]                kjournald2
 3068 S<   [ocfs2cmt]                  ocfs2_commit_thread
 3082 D+   /usr/bin/perl /root/make_pa ocfs2_cluster_lock

make_panic    D 0000000000000002     0  3082   3021
 ffff8801360f1a38 0000000000000046 ffffffffa0240b08 ffff88013703ea40
 ffff88013eb877f8 0000000000004000 00000000001d0a80 000000000000cb10
 0000000000000000 ffffffffa0240af0 ffff88013703ea40 ffff88007ffee340
Call Trace:
 [<ffffffffa022bdbf>] ? dlm_put_lockspace+0x18/0x2b [dlm]
 [<ffffffff804f13e4>] schedule+0x9/0x1d
 [<ffffffff804f171d>] schedule_timeout+0x24/0x15e
 [<ffffffff804f1559>] ? wait_for_common+0x3c/0x123
 [<ffffffff804f15ec>] wait_for_common+0xcf/0x123
 [<ffffffff8023616f>] ? default_wake_function+0x0/0xf
 [<ffffffff804f16ca>] wait_for_completion+0x18/0x1a
 [<ffffffffa02d3755>] ocfs2_cluster_lock+0x91f/0x93e [ocfs2]
 [<ffffffff804f387f>] ? _spin_unlock+0x26/0x2a
 [<ffffffffa02e59fb>] ? ocfs2_recovery_completed+0x34/0x3c [ocfs2]
 [<ffffffffa02d750c>] ocfs2_inode_lock_full+0x180/0xccb [ocfs2]
 [<ffffffff8025d97f>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffffa02f0210>] ocfs2_unlink+0x1a3/0xa6e [ocfs2]
 [<ffffffff802c3686>] ? vfs_unlink+0x95/0x110
 [<ffffffff802c36af>] vfs_unlink+0xbe/0x110
 [<ffffffff802c5d46>] do_unlinkat+0xcd/0x15d
 [<ffffffff802be708>] ? sys_newlstat+0x31/0x3c
 [<ffffffff804f34fc>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff802c5de7>] sys_unlink+0x11/0x13
 [<ffffffff8020baeb>] system_call_fastpath+0x16/0x1b

    Device => Id: 253,2  Uuid: 8A77044F9D98416FAB240B44B1843EDA  Gen: 0x7622CA50
  Label: 
    Volume => State: 2  Flags: 0x0
     Sizes => Block: 4096  Cluster: 4096
  Features => Compat: 0x3  Incompat: 0x1D0  ROcompat: 0x1
     Mount => Opts: 0x0  AtimeQuanta: 60
   Cluster => Stack: cman  Name: 8A77044F9D98416FAB240B44B1843EDA  Version: 1.0
  DownCnvt => Pid: 3053  Count: 0  WakeSeq: 55892  WorkSeq: 55892
  Recovery => Pid: -1  Nodes: None
    Commit => Pid: 3068  Interval: 0  Needs: 1
   Journal => State: 1  NumTxns: 2  TxnId: 1136
     Stats => GlobalAllocs: 3  LocalAllocs: 915  SubAllocs: 2938  LAWinMoves: 1 
 SAExtends: 2
LocalAlloc => State: 1  Descriptor: 2032128  Size: 2048 bits  Default: 2048 bits
     Steal => Slot: -1  NumStolen: 0
     Slots => Num     RecoGen
            *   0           3
                1           3
                2           3
                3           3

Lockres: M0000000000000000046e2a00000000  Mode: Protected Read
Flags: Initialized Attached Busy
RO Holders: 0  EX Holders: 0
Pending Action: Convert  Pending Unlock Action: None
Requested Mode: Exclusive  Blocking Mode: No Lock
PR > Gets: 982  Fails: 0    Waits (usec) Total: 637775  Max: 79972
EX > Gets: 69  Fails: 0    Waits (usec) Total: 723745  Max: 40985
Disk Refreshes: 0

Resource len 31  "M0000000000000000046e2a00000000"
Master           
LVB len 64 seq 123
05 00 00 00 00 00 00 02 00 00 00 00 00 00 00 00 
12 75 a1 17 e0 68 d0 10 12 79 39 dd b8 79 ee b4 
12 79 39 dd b8 79 ee b4 00 00 00 00 00 00 20 00 
41 ed 00 02 00 00 00 00 82 92 d2 7a 00 00 00 00
Granted
01ce0003 PR      Remote:   4 03d80001          
014a0002 PR      Remote:   2 00d70001          
Convert
038f0001 PR (EX)                               


bull-02
-------

 2759 S<   [ocfs2dc]                   ocfs2_downconvert_thread
 2760 S<   [dlm_astd]                  dlm_astd
 2761 S<   [dlm_scand]                 dlm_scand
 2762 S<   [dlm_recv/0]                worker_thread
 2763 S<   [dlm_recv/1]                worker_thread
 2764 S<   [dlm_recv/2]                worker_thread
 2765 S<   [dlm_recv/3]                worker_thread
 2766 S<   [dlm_send]                  worker_thread
 2767 S<   [dlm_recoverd]              dlm_recoverd
 2779 S<   [kjournald2]                kjournald2
 2780 S<   [ocfs2cmt]                  ocfs2_commit_thread
 2783 D+   /usr/bin/perl /root/make_pa ocfs2_cluster_lock

make_panic    D 0000000000000002     0  2783   2727
 ffff88013f497958 0000000000000046 ffffffffa024ab08 ffff88013ed6e540
 ffff88007e9557f8 0000000000004000 00000000001d0a80 000000000000cb10
 0000000000000000 ffffffffa024aaf0 ffff88013ed6e540 ffff88007fffe440
Call Trace:
 [<ffffffffa0235dbf>] ? dlm_put_lockspace+0x18/0x2b [dlm]
 [<ffffffff804f13e4>] schedule+0x9/0x1d
 [<ffffffff804f171d>] schedule_timeout+0x24/0x15e
 [<ffffffff804f1559>] ? wait_for_common+0x3c/0x123
 [<ffffffff804f15ec>] wait_for_common+0xcf/0x123
 [<ffffffff8023616f>] ? default_wake_function+0x0/0xf
 [<ffffffff804f16ca>] wait_for_completion+0x18/0x1a
 [<ffffffffa02dd755>] ocfs2_cluster_lock+0x91f/0x93e [ocfs2]
 [<ffffffff8025d97f>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff804f387f>] ? _spin_unlock+0x26/0x2a
 [<ffffffffa02ef9fb>] ? ocfs2_recovery_completed+0x34/0x3c [ocfs2]
 [<ffffffffa02e150c>] ocfs2_inode_lock_full+0x180/0xccb [ocfs2]
 [<ffffffffa02d0198>] ? ocfs2_dentry_revalidate+0x194/0x268 [ocfs2]
 [<ffffffffa02e7b97>] ocfs2_permission+0x70/0x167 [ocfs2]
 [<ffffffff802c285f>] inode_permission+0x69/0x97
 [<ffffffff802c4752>] __link_path_walk+0x134/0xdea
 [<ffffffff802c560e>] path_walk+0x69/0xd4
 [<ffffffff802c58a7>] do_path_lookup+0x187/0x1df
 [<ffffffff802bc094>] ? get_empty_filp+0xfc/0x188
 [<ffffffff802c59bd>] path_lookup_open+0x5a/0x9b
 [<ffffffff802c6588>] do_filp_open+0xb6/0x899
 [<ffffffff802cf62e>] ? alloc_fd+0x3a/0x12e
 [<ffffffff802cf711>] ? alloc_fd+0x11d/0x12e
 [<ffffffff802b92aa>] do_sys_open+0x53/0xd3
 [<ffffffff802b9353>] sys_open+0x1b/0x1d
 [<ffffffff8020baeb>] system_call_fastpath+0x16/0x1b

    Device => Id: 253,2  Uuid: 8A77044F9D98416FAB240B44B1843EDA  Gen: 0x7622CA50  Label: 
    Volume => State: 2  Flags: 0x0
     Sizes => Block: 4096  Cluster: 4096
  Features => Compat: 0x3  Incompat: 0x1D0  ROcompat: 0x1
     Mount => Opts: 0x0  AtimeQuanta: 60
   Cluster => Stack: cman  Name: 8A77044F9D98416FAB240B44B1843EDA  Version: 1.0
  DownCnvt => Pid: 2759  Count: 1  WakeSeq: 14838  WorkSeq: 14838
  Recovery => Pid: -1  Nodes: None
    Commit => Pid: 2780  Interval: 0  Needs: 1
   Journal => State: 1  NumTxns: 8  TxnId: 928
     Stats => GlobalAllocs: 3  LocalAllocs: 513  SubAllocs: 1556  LAWinMoves: 1  SAExtends: 2
LocalAlloc => State: 1  Descriptor: 2064384  Size: 2048 bits  Default: 2048 bits
     Steal => Slot: -1  NumStolen: 0
     Slots => Num     RecoGen
                0           3
            *   1           3
                2           3
                3           3

Lockres: M0000000000000000046e2a00000000  Mode: Protected Read
Flags: Initialized Attached Blocked Needs Refresh Queued
RO Holders: 0  EX Holders: 0
Pending Action: None  Pending Unlock Action: None
Requested Mode: Protected Read  Blocking Mode: Exclusive
PR > Gets: 463  Fails: 0    Waits (usec) Total: 1052625  Max: 41985
EX > Gets: 37  Fails: 0    Waits (usec) Total: 990652  Max: 79971
Disk Refreshes: 0

Resource len 31  "M0000000000000000046e2a00000000"
Local 1          
Granted
00d70001 PR      Master:   1 014a0002          

dlm: 8A77044F9D98416FAB240B44B1843EDA: addwait d70001 cur 2 overlap 4 count 2 f 100000
dlm: 8A77044F9D98416FAB240B44B1843EDA: remwait d70001 convert_reply zap overlap_cancel
dlm: 8A77044F9D98416FAB240B44B1843EDA: remwait d70001 cancel_reply wait_type 0

messages mean a cancel operation occurs while a remote convert is in progress,
then the convert reply comes back indicating that the convert was successful,
so the cancel is a moot point and being ignored.


bull-04
-------

 4114 S<   [ocfs2dc]                   ocfs2_downconvert_thread
 4115 S<   [dlm_astd]                  dlm_astd
 4116 S<   [dlm_scand]                 dlm_scand
 4117 S<   [dlm_recv/0]                worker_thread
 4118 S<   [dlm_recv/1]                worker_thread
 4119 S<   [dlm_recv/2]                worker_thread
 4120 S<   [dlm_recv/3]                worker_thread
 4121 S<   [dlm_send]                  worker_thread
 4122 S<   [dlm_recoverd]              dlm_recoverd
 4136 S<   [kjournald2]                kjournald2
 4137 S<   [ocfs2cmt]                  ocfs2_commit_thread
 4142 D+   /usr/bin/perl /root/make_pa ocfs2_wait_for_mask

make_panic    D 0000000000000002     0  4142   4086
 ffff88013147b998 0000000000000046 ffff88013147b938 ffffffff8025aea3
 0000000000000000 ffff88013142acc0 ffff88007ffee340 ffff88013142b078
 0000000100078e31 0000000000000246 0000000000000292 ffffffffa02b102b
Call Trace:
 [<ffffffff8025aea3>] ? print_lock_contention_bug+0x1b/0xe1
 [<ffffffffa02b102b>] ? dlm_put_lockspace+0x18/0x2b [dlm]
 [<ffffffff804e6cfd>] schedule+0x9/0x1d
 [<ffffffff804e702f>] schedule_timeout+0x28/0x176
 [<ffffffff804e6dce>] ? wait_for_common+0x3d/0x11e
 [<ffffffff804e6e57>] wait_for_common+0xc6/0x11e
 [<ffffffff80232c89>] ? default_wake_function+0x0/0xf
 [<ffffffffa03457be>] ? ocfs2_cluster_lock+0xf2/0x8e9 [ocfs2]
 [<ffffffff804e6f39>] wait_for_completion+0x18/0x1a
 [<ffffffffa0345563>] ocfs2_wait_for_mask+0x15/0x23 [ocfs2]
 [<ffffffffa0345f90>] ocfs2_cluster_lock+0x8c4/0x8e9 [ocfs2]
 [<ffffffff8025aea3>] ? print_lock_contention_bug+0x1b/0xe1
 [<ffffffff804e9001>] ? _spin_unlock+0x26/0x2a
 [<ffffffffa03592b8>] ? ocfs2_recovery_completed+0x34/0x3c [ocfs2]
 [<ffffffffa03479d0>] ocfs2_inode_lock_full+0x181/0xcbc [ocfs2]
 [<ffffffff804e9001>] ? _spin_unlock+0x26/0x2a
 [<ffffffffa033a3c7>] ? ocfs2_dentry_revalidate+0x194/0x26c [ocfs2]
 [<ffffffffa03522a0>] ocfs2_permission+0x70/0x166 [ocfs2]
 [<ffffffff802bdec4>] inode_permission+0x69/0x97
 [<ffffffff802bfe9e>] __link_path_walk+0x13f/0xced
 [<ffffffff8025aea3>] ? print_lock_contention_bug+0x1b/0xe1
 [<ffffffff802c0a9a>] path_walk+0x4e/0x97
 [<ffffffff802c0c84>] do_path_lookup+0x118/0x175
 [<ffffffff802c1aff>] do_filp_open+0xde/0x819
 [<ffffffff8025aea3>] ? print_lock_contention_bug+0x1b/0xe1
 [<ffffffff802bfae7>] ? getname+0x26/0x1ac
 [<ffffffff802ca4f2>] ? alloc_fd+0x33/0x11e
 [<ffffffff804e9001>] ? _spin_unlock+0x26/0x2a
 [<ffffffff802ca5ce>] ? alloc_fd+0x10f/0x11e
 [<ffffffff802b4a30>] do_sys_open+0x53/0xd3
 [<ffffffff802b4ad9>] sys_open+0x1b/0x1d
 [<ffffffff8020baab>] system_call_fastpath+0x16/0x1b

    Device => Id: 253,2  Uuid: 8A77044F9D98416FAB240B44B1843EDA  Gen: 0x7622CA50  Label: 
    Volume => State: 2  Flags: 0x0
     Sizes => Block: 4096  Cluster: 4096
  Features => Compat: 0x3  Incompat: 0x1D0  ROcompat: 0x1
     Mount => Opts: 0x0  AtimeQuanta: 60
   Cluster => Stack: cman  Name: 8A77044F9D98416FAB240B44B1843EDA  Version: 1.0
  DownCnvt => Pid: 4114  Count: 1  WakeSeq: 14213  WorkSeq: 14213
  Recovery => Pid: -1  Nodes: None
    Commit => Pid: 4137  Interval: 0  Needs: 1
   Journal => State: 1  NumTxns: 4  TxnId: 851
     Stats => GlobalAllocs: 2  LocalAllocs: 414  SubAllocs: 1396  LAWinMoves: 1  SAExtends: 1
LocalAlloc => State: 1  Descriptor: 2096640  Size: 2048 bits  Default: 2048 bits
     Steal => Slot: -1  NumStolen: 0
     Slots => Num     RecoGen
                0           3
                1           3
                2           3
            *   3           3

no M0000000000000000046e2a00000000 exists in locking_state

Resource len 31  "M0000000000000000046e2a00000000"
Local 1          
Granted
03d80001 PR      Master:   1 01ce0003          

dlm: 8A77044F9D98416FAB240B44B1843EDA: validate_unlock_args -16 3d80001 0 10c 2 0 M0000000000000000046e2a00000000

message means the lock is granted, i.e. the convert being canceled already
completed, so the cancel operation is being ignored.
