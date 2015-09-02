From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Wed, 02 Sep 2015 08:51:13 -0700
Subject: [Ocfs2-devel] [patch 14/28] ocfs2: take inode lock in
	ocfs2_iop_set/get_acl()
In-Reply-To: <55E6551D.7080708@oracle.com>
References: <55de39ad.N03/N28MqAInBiTy%akpm@linux-foundation.org>
	<20150831194427.GT1145@wotan.suse.de> <55E6551D.7080708@oracle.com>
Message-ID: <55E71AF1.4010109@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 09/01/2015 06:47 PM, Tariq Saeed wrote:

>
>          if (lockres->l_flags & OCFS2_LOCK_BLOCKED &&
>              !ocfs2_may_continue_on_blocked_lock(lockres, level) ||
> !(arg_flags & (OCFS2_LOCK_RECURSIVE) ...
>

Sorry, typo. The '||' should be '&&' above.
Thanks,
-Tariq Saeed
