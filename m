From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Tue, 01 Sep 2015 18:47:09 -0700
Subject: [Ocfs2-devel] [patch 14/28] ocfs2: take inode lock in
	ocfs2_iop_set/get_acl()
In-Reply-To: <20150831194427.GT1145@wotan.suse.de>
References: <55de39ad.N03/N28MqAInBiTy%akpm@linux-foundation.org>
	<20150831194427.GT1145@wotan.suse.de>
Message-ID: <55E6551D.7080708@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 08/31/2015 12:44 PM, Mark Fasheh wrote:
> On Wed, Aug 26, 2015 at 03:11:57PM -0700, Andrew Morton wrote:
>> From: Tariq Saeed <tariq.x.saeed@oracle.com>
>> Subject: ocfs2: take inode lock in ocfs2_iop_set/get_acl()
>>
>> Orabug: 20189959
>>
>> This bug in mainline code is pointed out by Mark Fasheh.  When
>> ocfs2_iop_set_acl() and ocfs2_iop_get_acl() are entered from VFS layer,
>> inode lock is not held.  This seems to be regression from older kernels.
>> The patch is to fix that.
>>
>> Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
>> Cc: Mark Fasheh <mfasheh@suse.com>
>> Cc: Joel Becker <jlbec@evilplan.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Thank you for fixing this Tariq,
>
> Reviewed-by: Mark Fasheh <mfasheh@suse.de>
>
> --
> Mark Fasheh
Hi Mark,
I realized that taking inode lock at vfs entry points opens up a self 
deadlock window
if a remote conversion req  to EX is blocked. The reason is this code path.
fchmod|fchmodat
   -> chmod_common
     -> notify_change
       -> ocfs2_setattr (takes inode lock EX) <<====
        -> posix_acl_chmod
         -> get_acl
           -> ocfs2_iop_get_acl (inode lock PR blocks behind remote EX 
conv) *
           -> ocfs2_iop_set_acl (inode lock EX blocks behind remote EX 
conv) *

* - self deadlock

I think this can be solved by introducing a flag OCFS2_LOCK_RECURSIVE 
to  ocfs2_cluster_lock().
The meaning of this flag is this. If the requesting level is <= 
lockres->l_level, in that case ignore
OCFS2_LOCK_BLOCKED and just inc the holder count. This will work for all 
req levels if l_level is EX.

         if (lockres->l_flags & OCFS2_LOCK_BLOCKED &&
             !ocfs2_may_continue_on_blocked_lock(lockres, level) || 
!(arg_flags & (OCFS2_LOCK_RECURSIVE) ...

ocfs2_iop_get|set_acl() will pass OCFS2_LOCK_RECURSIVE to 
ocfs2_cluster_lock().

I am looking for suggestions.

Thanks
-Tariq Saeed
