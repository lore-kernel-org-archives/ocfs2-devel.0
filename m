From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 15 Sep 2009 17:49:15 -0700
Subject: [Ocfs2-devel] dlm stress test hangs OCFS2
In-Reply-To: <4AAF3E24.9050207@suse.de>
References: <4A8B0083.8030400@suse.de> <4A8B6C29.30802@oracle.com>
	<4A9EA759.5090906@suse.de> <4A9EEB26.2080204@oracle.com>
	<4A9FEDA8.3080108@suse.de> <4A9FEDAC.50704@oracle.com>
	<4AA80AE4.9090105@suse.de> <4AA82136.9000403@oracle.com>
	<4AA890ED.3040406@suse.de> <4AAAD5C6.4000800@oracle.com>
	<4AACFCEB.4060902@suse.de> <4AAE99DF.3030005@oracle.com>
	<4AAEA64C.3030607@suse.de> <4AAED882.9020601@oracle.com>
	<4AAF3E24.9050207@suse.de>
Message-ID: <4AB0360B.4050602@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

So originally my thinking was that the dc thread was not getting kicked.
That is not the case. The lock is getting downconverted. But it is getting
upconverted shortly thereafter. This just could be the case in which dlmglue
is slow to increment the holders to block the dc thread from downconverting
the lock. The snippet shows that BAST is received 16 usecs after the 
upconvert.

Coly, I have another patch. Pop out the older patch before applying this 
one.
http://oss.oracle.com/~smushran/0001-ocfs2-Patch-to-debug-hang-in-dlmglue-when-running-d.patch

BAST:
[368.807757] (2572,dlm_astd,0):ocfs2_blocking_ast:1025 BAST fired for 
lockres M0000000000000000085e0200000000, blocking 5, level 3 type Meta
[368.807767] (2571,ocfs2dc,0):ocfs2_process_blocked_lock:3839 lockres 
M0000000000000000085e0200000000 blocked.
[368.807774] (2571,ocfs2dc,0):ocfs2_prepare_downconvert:3232 lock 
M0000000000000000085e0200000000, new_level = 0, l_blocking = 5
[368.807779] (2571,ocfs2dc,0):ocfs2_downconvert_lock:3252 lock 
M0000000000000000085e0200000000, level 3 => 0
[368.807799] (2571,ocfs2dc,0):ocfs2_process_blocked_lock:3863 lockres 
M0000000000000000085e0200000000, requeue = no.

Downconvert AST:
[368.807806] (2572,dlm_astd,0):ocfs2_locking_ast:1069 lock 
M0000000000000000085e0200000000, action 3, unlock 0

Upconvert AST:
[369.007930] (2572,dlm_astd,0):ocfs2_locking_ast:1069 lock 
M0000000000000000085e0200000000, action 2, unlock 0

BAST:
[369.007946] (2572,dlm_astd,0):ocfs2_blocking_ast:1025 BAST fired for 
lockres M0000000000000000085e0200000000, blocking 5, level 3 type Meta
[369.007956] (2571,ocfs2dc,0):ocfs2_process_blocked_lock:3839 lockres 
M0000000000000000085e0200000000 blocked.
[369.007962] (2571,ocfs2dc,0):ocfs2_prepare_downconvert:3232 lock 
M0000000000000000085e0200000000, new_level = 0, l_blocking = 5
[369.007967] (2571,ocfs2dc,0):ocfs2_downconvert_lock:3252 lock 
M0000000000000000085e0200000000, level 3 => 0
[369.007987] (2571,ocfs2dc,0):ocfs2_process_blocked_lock:3863 lockres 
M0000000000000000085e0200000000, requeue = no.

Downconvert AST:
[369.007994] (2572,dlm_astd,0):ocfs2_locking_ast:1069 lock 
M0000000000000000085e0200000000, action 3, unlock 0

Upconvert AST:
[369.208048] (2572,dlm_astd,0):ocfs2_locking_ast:1069 lock 
M0000000000000000085e0200000000, action 2, unlock 0


Coly Li wrote:
>
> Sunil Mushran Wrote:
>> The full trace is available here.
>> http://oss.oracle.com/~smushran/calltrace_x1
>>
>> So one sees the following block repeated. It shows that the lock is
>> being downconverted from EX to NL but also upconverted presumably to EX.
>>
>>
>> Coli, Can you map the pids to the process names.
>>
>
> Hi Sunil,
>
> In the attached trace info, I add current->comm after the pid.
>
> Here is the steps I reproduce the blocking,
> - This time I only run 1 make_panic process on each node.
> - I ran make_panic on x1 firstly, then on x2.
> - On node x1, after creating 3-4 files, I start the make_panic script on node x2.
> - On node x2, make_panic blocked immediately, no file created. On node x1, after
> creating 13 files, make_panic blocked too.
> - After waiting for several minutes, still blocked. I stop gathering trace info.
>
> Please check the attachment. Thank.
>
