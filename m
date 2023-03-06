Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51579C61DA4
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Mar 2023 13:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=tl2NBZwCAxyZ4EDc5mg6A0GQhDkjNg+GO8+6YH4B0YU=;
 b=ZG9L5igq30f2nvEXQIVdRk8JUFc4thE99afF7jWtmI/uj9JLAJdiyZ8tqaZevVDFezDun0qmBnJm
   0uoPQvrcR4s+nj6jTieQd5PaFA+qQwmAXR8SJnCYkrk6C7RtC/xdiVaBzBZ2MNhgB4u/iOUqK/CK
   vadz+xwi8ra9tE04oaggG5cDqHm5kp4+fQ//wkDe1v3NHyJq7E/2GvYkD64YU1NSfT/KORTWB+9e
   iI6b0fBHpAlBz0uCMv91hw9cXwl2dhHblMOePlU/qxBGx49uMOUOC526zCV2VJd9ZF392vNn+hLA
   eXLQTP3SfUJdatFnYgkwUFQROAvuPiqZrm4lvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=tl2NBZwCAxyZ4EDc5mg6A0GQhDkjNg+GO8+6YH4B0YU=;
 b=Id1b7hJEPLlDdyr+bIR8vtbFGXC5G0NT8Vxc/uBc7+lEwq2X+v0LAU7+VOnwnZt1BQCJuYI1MG3r
   a4t38srlMiCoQh9oUVcLuse4dL9x4QSCV9EE7c9leAL+rFl1XAgwDgZdXRYDGoskpdZPd+/1DUWU
   wiYsBuLnnwF/fOvCHZ+RO1BYuqoMGc3RrG73imle9xvylr7Ia5NwEn+y77z3Q9cWwMq/wn48fmKr
   YBaMC1d6GNXVkaBGvN1KqwrkUK7GgaERZyYi4D4OCTepWErdNp3vqD7BNg/7sCjQBhUjRIK7VsEU
   8xJW5qzM4t62sk4tPO5oTFYwOF5r6pVdjKu5AQ==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR300M9HQDQWO30@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Mar 2023 13:49:02 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1678110523; bh=Q0BPchgFsCr709KdEEIyv7MvSzlZhhm5hekXEzfZVps=;
 h=Subject:To:Cc:From:Date:From;
 b=K1dkvZvsJesoF0urBHVayhDcTrnN8v0JY4JUsnYeLr6QTeyGU6Mad3zjtM0N36g31
 lx4UVATeo6AUsRsK6LC4nsSeCFc0+KIZeY0EdKQHW24F+EdYaurATn9CKpovpoSJia
 Ap7JHrYQ05Hwa636nrd1Ao/Z7cWyQ2AS203xHWSQ=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, heming.zhao@suse.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Mon, 06 Mar 2023 14:46:02 +0100
Message-id: <16781103626088@kroah.com>
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10631
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 malwarescore=0 clxscore=163
 priorityscore=191 spamscore=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303060122
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch "ocfs2: fix defrag path triggering jbd2 ASSERT"
	has been added to the 4.14-stable tree
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: gregkh--- via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: gregkh@linuxfoundation.org
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-stable: commit
X-Patchwork-Hint: ignore
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: pDL42ALNPgGThbUInAIfb1QXFpNLhR7T
X-Proofpoint-ORIG-GUID: pDL42ALNPgGThbUInAIfb1QXFpNLhR7T
Reporting-Meta:
 AAFOF+7bxq37MK1RlB3YOsRjrK2FZVbvKkuN6zc6Qk+Y63sNEyNuojwOu364X6qt
 wg3NlQhVcPxOi7hAEbonTMp3zrxxVIqlX4ASjvvKVfytS1LRWDAqI0J4zxAPKitP
 V9yphg8ATR6gkVEb9iOf/oLaGl/nNk/Iom6yUn4apqdO6Fv2GlvMSYc/i00k9KPT
 5OPDvmoBOXitE+zGXiQUqfjSThYcD1b/RrLDx4CZDsnlRjQnAbySqv3Rd5DxXV37
 /6o4NBheU8nGOgggfqefyaSombdi08kNMfQieJ9d/4Khsr6B16PekCnxkD/nda9j
 kjqpxrt9HCNg4QFdq67aN9l89I8+fms44CiZ1TQ2U4BjzuonfaoezjJiPxmDTrHX
 sfRcbXWAh5RHSGpU5RxTMWPiif41GgtZRHv+lYdvLEnXRfbLLRwbcHzN5ABISO/r
 6BxZer93EAvGFNaIdb3H1AWwJGJu1woBiw9ENtyt4DxDcf/V40GAxwTvAgMVAIKj
 ah5LSztdtyS7reX2KEEPiuF4HaklMPTDO+0qVdFvowc4

The message from this sender included one or more files
which could not be scanned for virus detection; do not
open these files unless you are certain of the sender's intent.

----------------------------------------------------------------------

This is a note to let you know that I've just added the patch titled

    ocfs2: fix defrag path triggering jbd2 ASSERT

to the 4.14-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-defrag-path-triggering-jbd2-assert.patch
and it can be found in the queue-4.14 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From 60eed1e3d45045623e46944ebc7c42c30a4350f0 Mon Sep 17 00:00:00 2001
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Date: Fri, 17 Feb 2023 08:37:17 +0800
Subject: ocfs2: fix defrag path triggering jbd2 ASSERT

From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>

commit 60eed1e3d45045623e46944ebc7c42c30a4350f0 upstream.

code path:

ocfs2_ioctl_move_extents
 ocfs2_move_extents
  ocfs2_defrag_extent
   __ocfs2_move_extent
    + ocfs2_journal_access_di
    + ocfs2_split_extent  //sub-paths call jbd2_journal_restart
    + ocfs2_journal_dirty //crash by jbs2 ASSERT

crash stacks:

PID: 11297  TASK: ffff974a676dcd00  CPU: 67  COMMAND: "defragfs.ocfs2"
 #0 [ffffb25d8dad3900] machine_kexec at ffffffff8386fe01
 #1 [ffffb25d8dad3958] __crash_kexec at ffffffff8395959d
 #2 [ffffb25d8dad3a20] crash_kexec at ffffffff8395a45d
 #3 [ffffb25d8dad3a38] oops_end at ffffffff83836d3f
 #4 [ffffb25d8dad3a58] do_trap at ffffffff83833205
 #5 [ffffb25d8dad3aa0] do_invalid_op at ffffffff83833aa6
 #6 [ffffb25d8dad3ac0] invalid_op at ffffffff84200d18
    [exception RIP: jbd2_journal_dirty_metadata+0x2ba]
    RIP: ffffffffc09ca54a  RSP: ffffb25d8dad3b70  RFLAGS: 00010207
    RAX: 0000000000000000  RBX: ffff9706eedc5248  RCX: 0000000000000000
    RDX: 0000000000000001  RSI: ffff97337029ea28  RDI: ffff9706eedc5250
    RBP: ffff9703c3520200   R8: 000000000f46b0b2   R9: 0000000000000000
    R10: 0000000000000001  R11: 00000001000000fe  R12: ffff97337029ea28
    R13: 0000000000000000  R14: ffff9703de59bf60  R15: ffff9706eedc5250
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #7 [ffffb25d8dad3ba8] ocfs2_journal_dirty at ffffffffc137fb95 [ocfs2]
 #8 [ffffb25d8dad3be8] __ocfs2_move_extent at ffffffffc139a950 [ocfs2]
 #9 [ffffb25d8dad3c80] ocfs2_defrag_extent at ffffffffc139b2d2 [ocfs2]

Analysis

This bug has the same root cause of 'commit 7f27ec978b0e ("ocfs2: call
ocfs2_journal_access_di() before ocfs2_journal_dirty() in
ocfs2_write_end_nolock()")'.  For this bug, jbd2_journal_restart() is
called by ocfs2_split_extent() during defragmenting.

How to fix

For ocfs2_split_extent() can handle journal operations totally by itself.
Caller doesn't need to call journal access/dirty pair, and caller only
needs to call journal start/stop pair.  The fix method is to remove
journal access/dirty from __ocfs2_move_extent().

The discussion for this patch:
https://oss.oracle.com/pipermail/ocfs2-devel/2023-February/000647.html

Link: https://lkml.kernel.org/r/20230217003717.32469-1-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/move_extents.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -115,14 +115,6 @@ static int __ocfs2_move_extent(handle_t
 	 */
 	replace_rec.e_flags = ext_flags & ~OCFS2_EXT_REFCOUNTED;
 
-	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode),
-				      context->et.et_root_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
 	ret = ocfs2_split_extent(handle, &context->et, path, index,
 				 &replace_rec, context->meta_ac,
 				 &context->dealloc);
@@ -131,8 +123,6 @@ static int __ocfs2_move_extent(handle_t
 		goto out;
 	}
 
-	ocfs2_journal_dirty(handle, context->et.et_root_bh);
-
 	context->new_phys_cpos = new_p_cpos;
 
 	/*


Patches currently in stable-queue which might be from ocfs2-devel@oss.oracle.com are

queue-4.14/ocfs2-fix-non-auto-defrag-path-not-working-issue.patch
queue-4.14/ocfs2-fix-defrag-path-triggering-jbd2-assert.patch

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
