From: David Teigland <teigland@redhat.com>
Date: Wed, 10 Feb 2010 13:35:40 -0600
Subject: [Ocfs2-devel] [PATCH] ocfs2: Ignore BASTs fired after an AST
	for a drop lock]
In-Reply-To: <4B720386.7010301@oracle.com>
References: <4B720386.7010301@oracle.com>
Message-ID: <20100210193540.GA5062@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 09, 2010 at 04:53:26PM -0800, Sunil Mushran wrote:
> David, Apply this atop the debug patch you have. Just in case
> we run into another issue.

> dlmglue should ignore BASTs fired after an AST for a drop lock.

alternate got stuck just seconds after starting it:

bull-01
-------

Lockres: M000000000000000003f00400000000  Mode: Protected Read
Flags: Initialized Attached Busy
RO Holders: 0  EX Holders: 0
Pending Action: Convert  Pending Unlock Action: None
Requested Mode: Exclusive  Blocking Mode: Exclusive
PR > Gets: 2575540  Fails: 64    Waits (usec) Total: 2773756  Max: 80999
EX > Gets: 100  Fails: 0    Waits (usec) Total: 1752760  Max: 84000
Disk Refreshes: 0

Resource len 31  "M000000000000000003f00400000000"
Local 5          
Convert
02c50001 PR (EX) Master:   5 039c0001          time 0082740808117016 flags 0000010c 00000000 bast 0 82740807882923


bull-02
-------

Lockres: M000000000000000003f00400000000  Mode: No Lock
Flags: Initialized Attached Busy
RO Holders: 0  EX Holders: 0
Pending Action: Convert  Pending Unlock Action: None
Requested Mode: Exclusive  Blocking Mode: No Lock
PR > Gets: 2257176  Fails: 74    Waits (usec) Total: 3262556  Max: 81000
EX > Gets: 109  Fails: 0    Waits (usec) Total: 1467487  Max: 119758
Disk Refreshes: 0

Resource len 31  "M000000000000000003f00400000000"
Local 5          
Convert
010b0001 NL (EX) Master:   5 03270002          time 0081230989423990 flags 0000010c 00000000 bast 0 81230949140346


bull-04
-------

Lockres: M000000000000000003f00400000000  Mode: No Lock
Flags: Initialized Attached Busy
RO Holders: 0  EX Holders: 0
Pending Action: Convert  Pending Unlock Action: None
Requested Mode: Exclusive  Blocking Mode: No Lock
PR > Gets: 1726697  Fails: 38    Waits (usec) Total: 3383139  Max: 104976
EX > Gets: 58  Fails: 0    Waits (usec) Total: 1687943  Max: 82998
Disk Refreshes: 0

Resource len 31  "M000000000000000003f00400000000"
Local 5          
Convert
02490001 NL (EX) Master:   5 01af0001          time 0082748582618586 flags 0000010c 00000000 bast 0 82748542349120


bull-05
-------

Lockres: M000000000000000003f00400000000  Mode: Protected Read
Flags: Initialized Attached Busy
RO Holders: 0  EX Holders: 0
Pending Action: Convert  Pending Unlock Action: None
Requested Mode: Exclusive  Blocking Mode: No Lock
PR > Gets: 1146114  Fails: 14132    Waits (usec) Total: 2320904  Max: 69345
EX > Gets: 846  Fails: 0    Waits (usec) Total: 812936  Max: 45255
Disk Refreshes: 0

Resource len 31  "M000000000000000003f00400000000"
Master           
LVB len 64 seq 125
05 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 12 dc c1 b2 ed 7a d1 b2 12 dc c1 b2 ed 7a d1 b2 12 dc c1 b2 ed 7a d1 b2 00 00 00 00 00 00 10 00 81 a4 00 01 00 00 00 00 35 e4 a6 60 00 00 00 00
Convert
00b40001 PR (EX)                               time 0081278451876703 flags 0000010c 00000000 bast 0 81278448429585
039c0001 PR (EX) Remote:   1 02c50001          time 0081278488363626 flags 0000010c 00010000 bast 5 81278488135960
01af0001 NL (EX) Remote:   4 02490001          time 0081278492150986 flags 0000010c 00010000 bast 0 81278451886759
03270002 NL (EX) Remote:   2 010b0001          time 0081278529143524 flags 0000010c 00010000 bast 0 81278451878099



Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 3, l_blocking = 3
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 5 => 3
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 5, newlevel 3
Feb 10 13:19:39 bull-01 kernel: (7258,3,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 3 to 5
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_prepare_cancel_convert:3354 lock M000000000000000003f00400000000
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_cancel_convert:3394 lock M000000000000000003f00400000000 return from ocfs2_dlm_unlock
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = yes.
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_unlock_ast:3077 UNLOCK AST called on lock M000000000000000003f00400000000, action = 1
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-01 kernel: (7258,3,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 5
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 5
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 3, level 5 type Meta
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 3, level 5, l_block 3, dwn 1
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_unblock_lock:3507 lock M000000000000000003f00400000000, ReQ: EX Holders
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = yes.
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 3, l_blocking = 3
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 5 => 3
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 5, newlevel 3
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres W000000000000000003f00435e4a660, blocking 5, level 5 type Write/Read
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres W000000000000000003f00435e4a660, block 5, level 5, l_block 5, dwn 1
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres W000000000000000003f00435e4a660 blocked.
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock W000000000000000003f00435e4a660, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock W000000000000000003f00435e4a660, level 5 => 0
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres W000000000000000003f00435e4a660, requeue = no.
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_locking_ast:1106 lock W000000000000000003f00435e4a660, action 3, unlock 0, level 5, newlevel 0
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-01 kernel: (7258,3,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 3
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-01 kernel: (7258,3,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 3
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-01 kernel: (7258,3,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 3
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-01 kernel: (7238,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-01 kernel: (7258,3,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 3
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 0 type Meta
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 0, l_block 5, dwn 0
Feb 10 13:19:39 bull-01 kernel: (7211,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb 10 13:19:39 bull-01 kernel: (7258,3,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 3 to 5

Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-02 kernel: (7239,1,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 3
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb 10 13:19:39 bull-02 kernel: (7239,0,alternate):__ocfs2_cluster_lock:1426 lock W000000000000000003f00435e4a660, convert from 0 to 5
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_locking_ast:1106 lock W000000000000000003f00435e4a660, action 2, unlock 0, level 0, newlevel 5
Feb 10 13:19:39 bull-02 kernel: (7239,0,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 3 to 5
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 3, newlevel 5
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 3, level 5 type Meta
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 3, level 5, l_block 3, dwn 1
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_unblock_lock:3525 lock M000000000000000003f00400000000, ReQ: Checkpointing
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = yes.
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_unblock_lock:3525 lock M000000000000000003f00400000000, ReQ: Checkpointing
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = yes.
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 3, l_blocking = 3
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 5 => 3
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 5, newlevel 3
Feb 10 13:19:39 bull-02 kernel: (7239,0,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 3 to 5
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_prepare_cancel_convert:3354 lock M000000000000000003f00400000000
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_cancel_convert:3394 lock M000000000000000003f00400000000 return from ocfs2_dlm_unlock
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = yes.
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_unlock_ast:3077 UNLOCK AST called on lock M000000000000000003f00400000000, action = 1
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-02 kernel: (7239,0,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 5
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 5
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 3, level 5 type Meta
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 3, level 5, l_block 3, dwn 1
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = yes.
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 3, l_blocking = 3
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 5 => 3
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 5, newlevel 3
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres W000000000000000003f00435e4a660, blocking 5, level 5 type Write/Read
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres W000000000000000003f00435e4a660, block 5, level 5, l_block 5, dwn 1
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres W000000000000000003f00435e4a660 blocked.
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock W000000000000000003f00435e4a660, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock W000000000000000003f00435e4a660, level 5 => 0
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres W000000000000000003f00435e4a660, requeue = no.
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_locking_ast:1106 lock W000000000000000003f00435e4a660, action 3, unlock 0, level 5, newlevel 0
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-02 kernel: (7239,0,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 3
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = yes.
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-02 kernel: (7223,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-02 kernel: (7197,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-02 kernel: (7239,0,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 5

Feb 10 13:19:39 bull-04 kernel: (7243,0,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 3
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-04 kernel: (7243,0,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 3
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = yes.
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-04 kernel: (7243,0,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 3
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-04 kernel: (7243,0,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 3
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = yes.
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-04 kernel: (7243,0,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 3
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb 10 13:19:39 bull-04 kernel: (7243,0,alternate):__ocfs2_cluster_lock:1426 lock W000000000000000003f00435e4a660, convert from 0 to 5
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_locking_ast:1106 lock W000000000000000003f00435e4a660, action 2, unlock 0, level 0, newlevel 5
Feb 10 13:19:39 bull-04 kernel: (7243,0,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 3 to 5
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 3, newlevel 5
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 3, level 5 type Meta
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 3, level 5, l_block 3, dwn 1
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_unblock_lock:3507 lock M000000000000000003f00400000000, ReQ: EX Holders
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = yes.
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_unblock_lock:3525 lock M000000000000000003f00400000000, ReQ: Checkpointing
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = yes.
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_unblock_lock:3525 lock M000000000000000003f00400000000, ReQ: Checkpointing
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = yes.
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 3, l_blocking = 3
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 5 => 3
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 5, newlevel 3
Feb 10 13:19:39 bull-04 kernel: (7243,0,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 3 to 5
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_prepare_cancel_convert:3354 lock M000000000000000003f00400000000
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_cancel_convert:3394 lock M000000000000000003f00400000000 return from ocfs2_dlm_unlock
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = yes.
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_unlock_ast:3077 UNLOCK AST called on lock M000000000000000003f00400000000, action = 1
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-04 kernel: (7228,0,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-04 kernel: (7202,0,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-04 kernel: (7243,0,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 5

Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = yes.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-05 kernel: (7268,1,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 3
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = yes.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-05 kernel: (7268,1,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 3
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = yes.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-05 kernel: (7268,1,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 3
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = yes.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-05 kernel: (7268,1,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 3
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = yes.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-05 kernel: (7268,1,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 3
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = yes.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-05 kernel: (7268,1,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 3
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres M000000000000000003f00400000000, blocking 5, level 3 type Meta
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_generic_handle_bast:934 lockres M000000000000000003f00400000000, block 5, level 3, l_block 5, dwn 1
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = yes.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4007 lockres M000000000000000003f00400000000 blocked.
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_prepare_downconvert:3302 lock M000000000000000003f00400000000, new_level = 0, l_blocking = 5
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_downconvert_lock:3322 lock M000000000000000003f00400000000, level 3 => 0
Feb 10 13:19:39 bull-05 kernel: (7252,1,ocfs2dc):ocfs2_process_blocked_lock:4031 lockres M000000000000000003f00400000000, requeue = no.
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 3, unlock 0, level 3, newlevel 0
Feb 10 13:19:39 bull-05 kernel: (7268,1,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 0 to 3
Feb 10 13:19:39 bull-05 kernel: (7226,1,dlm_astd):ocfs2_locking_ast:1106 lock M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
Feb 10 13:19:39 bull-05 kernel: (7268,1,alternate):__ocfs2_cluster_lock:1426 lock M000000000000000003f00400000000, convert from 3 to 5
