Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BEC7C678D4
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Mar 2023 13:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WXU461T/P97FaWG7YcsT895Dr8qO65y0lNIrgnF7HP8=;
 b=R+cr0YJpLDgx/jDd5DV0EFdqkPJCtyaQ0qUS2RKN9vGEVVOOM7wEWZT5Eu8EoHIW1aCf9E00D48j
   0FYM2gkKYL2XLaC2HEtAiY4NA99UoV914/XH96Dixo/2wzCfUGO5rrplM5vIn56pf9C/wrHYIGEc
   TiPisEOBxyAUx0IkqG85gytFHmGTLIguiX7Hp/1mrezeX7alJm6kozKF8Vd+78iLAPWlaKxJasWb
   DQZGmi7Z+oWTxeLtUJexyy07/CTOdxGf+hipbYP0/K0Mvp67iMFvoc7Ynm9PpgCA8Q0AR8H24nDw
   P4t4Yp1uK7zb31/5JXHwQWgAvlNbvaI3u+H1lA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WXU461T/P97FaWG7YcsT895Dr8qO65y0lNIrgnF7HP8=;
 b=FZY/1AOas42dsY9Vpvc3DNXwQv6ETB0/8aVtUATNZUceiYSYF7iXONAyhABtQAQouzmUDkNSnI4I
   3NCb178Ydkw8yF2xI7E0JUu0eSSi7J630fXSoJMsOn5kQNeX2fp3ef5egYE4GtJHWFwq99UM1zBf
   wUpahOcq/Nuka2pBYWttncy1iCK0SIXgYTSK22ixuDh5GKPr+DS8daXk9N90IrgP6LMjwBhCCdJA
   1sfOKuI0lJo9F33o93+jpCMk39ROAm1wonPBDY1ia5xnkQ7QqYIIEJZw/hjcBJJtcYJYUlVy0eR4
   5P5Ciue2SvKlbKHqHm1wMMJWpdcvjF50aTMxDQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR3008KMQCQT190@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Mar 2023 13:48:26 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1678110494; bh=cdkLHmDqulKLAuH10SRv5nl1OhDzY8RNGAj57NsTHnE=;
 h=Subject:To:Cc:From:Date:From;
 b=hED2CNbPLov4x6jbFkjzCi716Len8LqO/unrLTlCzEa4/hac8N3AurLjPx/1MAIYr
 NoTyBcBqGs0qVtdyNH8MPpEVi4yYkBIn3LArjBxUcJxLA2RxAUCQj08MmjncI7a0/Q
 y0OHk2Jk2azbF5xhCz9HaTzz1h7uzd1BkHqgoOzU=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, heming.zhao@suse.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Mon, 06 Mar 2023 14:44:21 +0100
Message-id: <16781102615393@kroah.com>
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10641
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 priorityscore=178 malwarescore=0
 mlxlogscore=999 adultscore=0 clxscore=114 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303060122
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch "ocfs2: fix defrag path triggering jbd2 ASSERT"
	has been added to the 5.4-stable tree
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
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: D78hOZwFKYl3IVCz5bsNG2tgV85qiygJ
X-Proofpoint-ORIG-GUID: D78hOZwFKYl3IVCz5bsNG2tgV85qiygJ
Reporting-Meta:
 AAFVT+if9YqCBSG3+vkPmGuyuIM2IFcgN1V7z6k2/hJWZFAxUU7zA/ec2LFU8nsc
 EoJzlkFtm8MvRqVhhnWheluWCEQiIKyx2MEcZM+z0CHVSrNXHcKDHS5XVJ0kaeiy
 K+w3DiXyMaah7sotpF6fgbwpE9LveH6pr9QD1sOQbjCS+e17z3tMlSbdvQ2YSLgi
 KkxBk9GNHrv64BnEQAVe7hhgwOhU8wYdTCviTqijDD2tuZeZ4JwOVMVdWs2Hkpv5
 nyGN+HV7iMVIqWoFQuq0G/o1q9YCHGQ+pOxDSKX/95nHykQ0v3zz84KDIqtLAB3i
 ekY+Smgt4efrCDJBRih83LaIQNqAEJjn7qwoTSxHt0qnCIHJV0RHUEMwrbAa3I07
 i5eAi/drEOLbpJb+kOJXLto5WrNCmfHpHHD6rbYMr7z/PpWf/lRwVjFYjOzkUEy/
 Tw+9H4z9i9+44cbsJtCN88+V2lU9CaiSVZO7JcCJgtCE7fwVLwOI12Y8dbLhPjCR
 5x2P06Dnvk4ZTdGchyFIc9uV8yuG7HeSrgMBLB9H7ByS


This is a note to let you know that I've just added the patch titled

    ocfs2: fix defrag path triggering jbd2 ASSERT

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-defrag-path-triggering-jbd2-assert.patch
and it can be found in the queue-5.4 subdirectory.

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
@@ -107,14 +107,6 @@ static int __ocfs2_move_extent(handle_t
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
@@ -123,8 +115,6 @@ static int __ocfs2_move_extent(handle_t
 		goto out;
 	}
 
-	ocfs2_journal_dirty(handle, context->et.et_root_bh);
-
 	context->new_phys_cpos = new_p_cpos;
 
 	/*


Patches currently in stable-queue which might be from ocfs2-devel@oss.oracle.com are

queue-5.4/ocfs2-fix-non-auto-defrag-path-not-working-issue.patch
queue-5.4/ocfs2-fix-defrag-path-triggering-jbd2-assert.patch

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
