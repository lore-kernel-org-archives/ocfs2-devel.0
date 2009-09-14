From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 14 Sep 2009 16:57:54 -0700
Subject: [Ocfs2-devel] dlm stress test hangs OCFS2
In-Reply-To: <4AAEA64C.3030607@suse.de>
References: <4A8B0083.8030400@suse.de> <4A8B6C29.30802@oracle.com>
	<4A9EA759.5090906@suse.de> <4A9EEB26.2080204@oracle.com>
	<4A9FEDA8.3080108@suse.de> <4A9FEDAC.50704@oracle.com>
	<4AA80AE4.9090105@suse.de> <4AA82136.9000403@oracle.com>
	<4AA890ED.3040406@suse.de> <4AAAD5C6.4000800@oracle.com>
	<4AACFCEB.4060902@suse.de> <4AAE99DF.3030005@oracle.com>
	<4AAEA64C.3030607@suse.de>
Message-ID: <4AAED882.9020601@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The full trace is available here.
http://oss.oracle.com/~smushran/calltrace_x1

So one sees the following block repeated. It shows that the lock is
being downconverted from EX to NL but also upconverted presumably to EX.

==============================================================
[412.378525] (12732,0):ocfs2_blocking_ast:1025 BAST fired for lockres 
M0000000000000000085e0200000000, blocking 5, level 5 type Meta
[412.378532] (12731,0):ocfs2_process_blocked_lock:3839 lockres 
M0000000000000000085e0200000000 blocked.
[412.378537] (12731,0):ocfs2_prepare_downconvert:3232 lock 
M0000000000000000085e0200000000, new_level = 0, l_blocking = 5
[412.378542] (12731,0):ocfs2_downconvert_lock:3252 lock 
M0000000000000000085e0200000000, level 5 => 0
[412.378554] (12731,0):__lockres_clear_pending:978 lock 
M0000000000000000085e0200000000 Clear; flg=0x557, lpg=268, gen=268
[412.378558] (12731,0):ocfs2_process_blocked_lock:3863 lockres 
M0000000000000000085e0200000000, requeue = no.
[412.378578] (12732,0):ocfs2_locking_ast:1069 lock 
M0000000000000000085e0200000000, action 3, unlock 0
[412.378584] (12732,0):__lockres_clear_pending:972 lock 
M0000000000000000085e0200000000 Abort; flg=0x51, lpg=269, gen=269
[412.378596] (9370,0):__lockres_clear_pending:978 lock 
M0000000000000000085e0200000000 Clear; flg=0x453, lpg=269, gen=269
[412.578719] (12732,0):ocfs2_locking_ast:1069 lock 
M0000000000000000085e0200000000, action 2, unlock 0
[412.578727] (12732,0):__lockres_clear_pending:972 lock 
M0000000000000000085e0200000000 Abort; flg=0x51, lpg=270, gen=270
==============================================================

The BAST
[412.378525] (12732,0):ocfs2_blocking_ast:1025 BAST fired for lockres 
M0000000000000000085e0200000000, blocking 5, level 5 type Meta
[412.378532] (12731,0):ocfs2_process_blocked_lock:3839 lockres 
M0000000000000000085e0200000000 blocked.

Lock is at EX (5) and new level is NL (0).
[412.378537] (12731,0):ocfs2_prepare_downconvert:3232 lock 
M0000000000000000085e0200000000, new_level = 0, l_blocking = 5
[412.378542] (12731,0):ocfs2_downconvert_lock:3252 lock 
M0000000000000000085e0200000000, level 5 => 0

Flags: 0x557 => PENDING QUEUED INITIALIZED NEEDS_REFRESH BLOCKED BUSY 
ATTACHED
[412.378554] (12731,0):__lockres_clear_pending:978 lock 
M0000000000000000085e0200000000 Clear; flg=0x557, lpg=268, gen=268

requeue no means there is no need to delay the downconvert
[412.378558] (12731,0):ocfs2_process_blocked_lock:3863 lockres 
M0000000000000000085e0200000000, requeue = no.

Action 3 means DOWNCONVERT
[412.378578] (12732,0):ocfs2_locking_ast:1069 lock 
M0000000000000000085e0200000000, action 3, unlock 0

Flags: 0x51 => INITIALIZED NEEDS_REFRESH ATTACHED
[412.378584] (12732,0):__lockres_clear_pending:972 lock 
M0000000000000000085e0200000000 Abort; flg=0x51, lpg=269, gen=269

Flags: 0x453 => PENDING INITIALIZED NEEDS_REFRESH BUSY ATTACHED
[412.378596] (9370,0):__lockres_clear_pending:978 lock 
M0000000000000000085e0200000000 Clear; flg=0x453, lpg=269, gen=269

Action 2 means CONVERT
[412.578719] (12732,0):ocfs2_locking_ast:1069 lock 
M0000000000000000085e0200000000, action 2, unlock 0
[412.578727] (12732,0):__lockres_clear_pending:972 lock 
M0000000000000000085e0200000000 Abort; flg=0x51, lpg=270, gen=270

A quick scan shows the CONVERT is consistently 200 usecs (??) after the 
DOWNCONVERT.

Coli, Can you map the pids to the process names.

Sunil

Coly Li wrote:
> Sunil Mushran Wrote:
>   
>> Thanks. Can you email me the _full_ trace log.
>>
>>     
> Hi Sunil,
>
> Here is the full trace log from boot to shutdown, on both nodes.
>
> On node x1, I run 2 make_panic process (the simplified bash script).
> On node x2, I run 1 make_panic process.
>
> The above operation can reproduce the blocking very fast. I wait for several
> minutes, when no any new file created on both nodes. Then I shut the nodes.
>
> Please check the attachment for trace log.
>
> Thanks.
>   
