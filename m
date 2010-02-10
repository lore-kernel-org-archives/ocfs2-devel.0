From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 10 Feb 2010 12:21:48 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Ignore BASTs fired after an AST
	for a drop lock]
In-Reply-To: <20100210193540.GA5062@redhat.com>
References: <4B720386.7010301@oracle.com> <20100210193540.GA5062@redhat.com>
Message-ID: <4B73155C.2000602@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

David Teigland wrote:
> alternate got stuck just seconds after starting it:
>
> bull-01
> -------
>
> Lockres: M000000000000000003f00400000000 Mode: Protected Read
> Flags: Initialized Attached Busy
> RO Holders: 0 EX Holders: 0
> Pending Action: Convert Pending Unlock Action: None
> Requested Mode: Exclusive Blocking Mode: Exclusive
> PR > Gets: 2575540 Fails: 64 Waits (usec) Total: 2773756 Max: 80999
> EX > Gets: 100 Fails: 0 Waits (usec) Total: 1752760 Max: 84000
> Disk Refreshes: 0
>
> Resource len 31 "M000000000000000003f00400000000"
> Local 5
> Convert
> 02c50001 PR (EX) Master: 5 039c0001 time 0082740808117016 flags 
> 0000010c 00000000 bast 0 82740807882923
>
>
> bull-02
> -------
>
> Lockres: M000000000000000003f00400000000 Mode: No Lock
> Flags: Initialized Attached Busy
> RO Holders: 0 EX Holders: 0
> Pending Action: Convert Pending Unlock Action: None
> Requested Mode: Exclusive Blocking Mode: No Lock
> PR > Gets: 2257176 Fails: 74 Waits (usec) Total: 3262556 Max: 81000
> EX > Gets: 109 Fails: 0 Waits (usec) Total: 1467487 Max: 119758
> Disk Refreshes: 0
>
> Resource len 31 "M000000000000000003f00400000000"
> Local 5
> Convert
> 010b0001 NL (EX) Master: 5 03270002 time 0081230989423990 flags 
> 0000010c 00000000 bast 0 81230949140346
>
>
> bull-04
> -------
>
> Lockres: M000000000000000003f00400000000 Mode: No Lock
> Flags: Initialized Attached Busy
> RO Holders: 0 EX Holders: 0
> Pending Action: Convert Pending Unlock Action: None
> Requested Mode: Exclusive Blocking Mode: No Lock
> PR > Gets: 1726697 Fails: 38 Waits (usec) Total: 3383139 Max: 104976
> EX > Gets: 58 Fails: 0 Waits (usec) Total: 1687943 Max: 82998
> Disk Refreshes: 0
>
> Resource len 31 "M000000000000000003f00400000000"
> Local 5
> Convert
> 02490001 NL (EX) Master: 5 01af0001 time 0082748582618586 flags 
> 0000010c 00000000 bast 0 82748542349120
>
>
> bull-05
> -------
>
> Lockres: M000000000000000003f00400000000 Mode: Protected Read
> Flags: Initialized Attached Busy
> RO Holders: 0 EX Holders: 0
> Pending Action: Convert Pending Unlock Action: None
> Requested Mode: Exclusive Blocking Mode: No Lock
> PR > Gets: 1146114 Fails: 14132 Waits (usec) Total: 2320904 Max: 69345
> EX > Gets: 846 Fails: 0 Waits (usec) Total: 812936 Max: 45255
> Disk Refreshes: 0
>
> Resource len 31 "M000000000000000003f00400000000"
> Master
> LVB len 64 seq 125
> 05 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 12 dc c1 b2 ed 7a d1 
> b2 12 dc c1 b2 ed 7a d1 b2 12 dc c1 b2 ed 7a d1 b2 00 00 00 00 00 00 
> 10 00 81 a4 00 01 00 00 00 00 35 e4 a6 60 00 00 00 00
> Convert
> 00b40001 PR (EX) time 0081278451876703 flags 0000010c 00000000 bast 0 
> 81278448429585
> 039c0001 PR (EX) Remote: 1 02c50001 time 0081278488363626 flags 
> 0000010c 00010000 bast 5 81278488135960
> 01af0001 NL (EX) Remote: 4 02490001 time 0081278492150986 flags 
> 0000010c 00010000 bast 0 81278451886759
> 03270002 NL (EX) Remote: 2 010b0001 time 0081278529143524 flags 
> 0000010c 00010000 bast 0 81278451878099
>
>
>
> Feb 10 13:19:39 bull-01 kernel: 
> (7258,3,alternate):__ocfs2_cluster_lock:1426 lock 
> M000000000000000003f00400000000, convert from 0 to 3
> Feb 10 13:19:39 bull-01 kernel: 
> (7211,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres 
> M000000000000000003f00400000000, blocking 5, level 0 type Meta
> Feb 10 13:19:39 bull-01 kernel: 
> (7211,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres 
> M000000000000000003f00400000000, block 5, level 0, l_block 5, dwn 0
> Feb 10 13:19:39 bull-01 kernel: 
> (7211,0,dlm_astd):ocfs2_locking_ast:1106 lock 
> M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
> Feb 10 13:19:39 bull-01 kernel: 
> (7258,3,alternate):__ocfs2_cluster_lock:1426 lock 
> M000000000000000003f00400000000, convert from 3 to 5

So it requests NL => PR. It gets a BAST with blocking EX
before the AST for PR. The last patch added changed the
BAST handling to not schedule the downconvert thread if
the current lock level was compatible. In this case, because
the BAST is before the AST, the lock level is still NL.

One fix would be to take l_requested also into account.
As in, schedule the dc thread if the current or the requested
lock level is incompat.

But this should be a fsdlm bug. Why is it sending a BAST
before the AST? If we do look at the requested lock level and
do schedule the down convert thread, we are just buying a
little more time for the AST. That's it. The problem from the
glue side is that we are expected to handle multiple BASTs.
The last patch made it ignore a BAST that was sent after a
AST for a drop lock. I'm wondering whether we can sanely handle
this in glue.

Thoughts?
