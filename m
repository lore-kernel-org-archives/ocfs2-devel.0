From: Coly Li <coly.li@suse.de>
Date: Wed, 23 Sep 2009 14:32:45 +0800
Subject: [Ocfs2-devel] questions of AST and BAST (was Re: dlm stress test
 hangs OCFS2)
In-Reply-To: <4AB0360B.4050602@oracle.com>
References: <4A8B0083.8030400@suse.de> <4A8B6C29.30802@oracle.com>
	<4A9EA759.5090906@suse.de> <4A9EEB26.2080204@oracle.com>
	<4A9FEDA8.3080108@suse.de> <4A9FEDAC.50704@oracle.com>
	<4AA80AE4.9090105@suse.de> <4AA82136.9000403@oracle.com>
	<4AA890ED.3040406@suse.de> <4AAAD5C6.4000800@oracle.com>
	<4AACFCEB.4060902@suse.de> <4AAE99DF.3030005@oracle.com>
	<4AAEA64C.3030607@suse.de> <4AAED882.9020601@oracle.com>
	<4AAF3E24.9050207@suse.de> <4AB0360B.4050602@oracle.com>
Message-ID: <4AB9C10D.8010209@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Sunil Mushran Wrote:
> 
> BAST:
> [368.807757] (2572,dlm_astd,0):ocfs2_blocking_ast:1025 BAST fired for
> lockres M0000000000000000085e0200000000, blocking 5, level 3 type Meta
> [368.807767] (2571,ocfs2dc,0):ocfs2_process_blocked_lock:3839 lockres
> M0000000000000000085e0200000000 blocked.
> [368.807774] (2571,ocfs2dc,0):ocfs2_prepare_downconvert:3232 lock
> M0000000000000000085e0200000000, new_level = 0, l_blocking = 5
> [368.807779] (2571,ocfs2dc,0):ocfs2_downconvert_lock:3252 lock
> M0000000000000000085e0200000000, level 3 => 0
> [368.807799] (2571,ocfs2dc,0):ocfs2_process_blocked_lock:3863 lockres
> M0000000000000000085e0200000000, requeue = no.
> 
> Downconvert AST:
> [368.807806] (2572,dlm_astd,0):ocfs2_locking_ast:1069 lock
> M0000000000000000085e0200000000, action 3, unlock 0
> 
> Upconvert AST:
> [369.007930] (2572,dlm_astd,0):ocfs2_locking_ast:1069 lock
> M0000000000000000085e0200000000, action 2, unlock 0
> 
> BAST:
> [369.007946] (2572,dlm_astd,0):ocfs2_blocking_ast:1025 BAST fired for
> lockres M0000000000000000085e0200000000, blocking 5, level 3 type Meta
> [369.007956] (2571,ocfs2dc,0):ocfs2_process_blocked_lock:3839 lockres
> M0000000000000000085e0200000000 blocked.
> [369.007962] (2571,ocfs2dc,0):ocfs2_prepare_downconvert:3232 lock
> M0000000000000000085e0200000000, new_level = 0, l_blocking = 5
> [369.007967] (2571,ocfs2dc,0):ocfs2_downconvert_lock:3252 lock
> M0000000000000000085e0200000000, level 3 => 0
> [369.007987] (2571,ocfs2dc,0):ocfs2_process_blocked_lock:3863 lockres
> M0000000000000000085e0200000000, requeue = no.
> 
> Downconvert AST:
> [369.007994] (2572,dlm_astd,0):ocfs2_locking_ast:1069 lock
> M0000000000000000085e0200000000, action 3, unlock 0
> 
> Upconvert AST:
> [369.208048] (2572,dlm_astd,0):ocfs2_locking_ast:1069 lock
> M0000000000000000085e0200000000, action 2, unlock 0

Hi Sunil,

It is still not very clear to me, for the conception of AST and BAST in ocfs2.

I guess in ocfs2, when downconvert or upconvert gets done, there will be a AST
popped. But it's not clear to me in which conditions the AST will happen, and
when a BAST will happen.

Can I get any hint ?  :-)

Thanks
-- 
Coly Li
SuSE Labs
