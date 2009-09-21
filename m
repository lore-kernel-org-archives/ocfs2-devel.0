From: Coly Li <coly.li@suse.de>
Date: Tue, 22 Sep 2009 01:25:53 +0800
Subject: [Ocfs2-devel] dlm stress test hangs OCFS2
In-Reply-To: <4AB0360B.4050602@oracle.com>
References: <4A8B0083.8030400@suse.de> <4A8B6C29.30802@oracle.com>
	<4A9EA759.5090906@suse.de> <4A9EEB26.2080204@oracle.com>
	<4A9FEDA8.3080108@suse.de> <4A9FEDAC.50704@oracle.com>
	<4AA80AE4.9090105@suse.de> <4AA82136.9000403@oracle.com>
	<4AA890ED.3040406@suse.de> <4AAAD5C6.4000800@oracle.com>
	<4AACFCEB.4060902@suse.de> <4AAE99DF.3030005@oracle.com>
	<4AAEA64C.3030607@suse.de> <4AAED882.9020601@oracle.com>
	<4AAF3E24.9050207@suse.de> <4AB0360B.4050602@oracle.com>
Message-ID: <4AB7B721.6060307@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

I tried this patch, on 2 nodes cluster, it works. No blocking observed so far.
Then I run it on a 4 nodes cluster, run make_panic on each node simultaneously,
and BUG inside ocfs2_prepare_downconvert() triggered (in line 3224) on one of
the nodes (I observed the oops on node x4),

3214 static unsigned int ocfs2_prepare_downconvert(struct ocfs2_lock_res *lockres,
3215                                               int new_level)
3216 {
3217         assert_spin_locked(&lockres->l_lock);
3218
3219         BUG_ON(lockres->l_blocking <= DLM_LOCK_NL);
3220
3221         if (lockres->l_level <= new_level) {
3222                 mlog(ML_ERROR, "lockres->l_level (%d) <= new_level (%d)\n",
3223                      lockres->l_level, new_level);
3224                 BUG();
3225         }
3226
3227         mlog(ML_NOTICE, "lock %s, new_level = %d, l_blocking = %d\n",
3228              lockres->l_name, new_level, lockres->l_blocking);
3229
3230         lockres->l_action = OCFS2_AST_DOWNCONVERT;
3231         lockres->l_requested = new_level;
3232         lockres_or_flags(lockres, OCFS2_LOCK_BUSY);
3233         return lockres_set_pending(lockres);
3234 }

I am trying to understand what you did now :-)

Sunil Mushran Wrote:
> So originally my thinking was that the dc thread was not getting kicked.
> That is not the case. The lock is getting downconverted. But it is getting
> upconverted shortly thereafter. This just could be the case in which
> dlmglue
> is slow to increment the holders to block the dc thread from downconverting
> the lock. The snippet shows that BAST is received 16 usecs after the
> upconvert.
> 
> Coly, I have another patch. Pop out the older patch before applying this
> one.
> http://oss.oracle.com/~smushran/0001-ocfs2-Patch-to-debug-hang-in-dlmglue-when-running-d.patch
> 
-- 
Coly Li
SuSE Labs
