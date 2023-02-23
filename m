Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FEBAC64ED8
	for <ocfs2-devel@archiver.kernel.org>; Thu, 23 Feb 2023 21:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uIHgFgQm52PZ9DGZV491sE1DATQAq42+dPwTMhvMkOo=;
 b=h+EWIN0necCRvuHALS1PzQSH7seDjlcBl68cwvZYN02nzd3ZnmZpkphtv/8RF4auS0YcBLOTdRi5
   Vy3inAzr1cdqfHT3/XdLmpLyJODaFfhYfA+uYJPZKdzsB322u9D5rENDPdUKtvoFViFZDwqMD4pa
   yZU3jnQfnBTROBLmT3l1vSihrXQZFrHqfACKuGOgcbL+q1btNySrXIeLtu2GEQKiIj1c/TpRvzF2
   o+d5p+9O2wHNsVhuacZUMRAnSxvhugJf0ldAkc8A33Y14mIifo3sDh2SsR627VcNsOxvd38e+7Y3
   68hXk+8jsJIW7gko0wo7plqmJCY3g6kj1c9yQw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uIHgFgQm52PZ9DGZV491sE1DATQAq42+dPwTMhvMkOo=;
 b=iKLXLoEOVK3Ium5yhxmhDNXZ9wZT6kn88qVaBjLNAyWCk3v/MaInc/I/DbVnWVyDs1se4mCymR43
   gvnKHaSuvqvzJHHSC9oNzR8D12hc/sfKl9DMBXa8MAR143Xmiv7jDY0BD8Ln2kdC2mOKz5p823eX
   2ci4RXfVp7ocDqNYBOYUhMY8ILi55W8uaikE+qiM6+rR6tzX+j5qhs+DZEtjCsTl8w6oncd2iHBd
   uWnI/k0Lugw/o+cwpRgAlLC4MwF4FMtmm+EPrExCNrxgMoEGKskVrMP8dXmY3n7AWguqJ4jEr5+q
   NxGS7ihnwBbyBGp0rloJoVL2i2IlYsloY3ZDwQ==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQJ00COEXB8T0E0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 23 Feb 2023 21:06:44 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1677186386; bh=2+tTarYZdPsR9XrnsqJ4oM0JxxZzq9aRWCyVIhx9Xak=;
 h=Date:To:From:Subject:From;
 b=ZNvNfvtJKJ0AHmDGmjoqhtlruLfM0UgQNWokLpJK2V2EBvdDqTkc8rP03+a0Rln91
 HQW2RF8R+mlKvKmGEAfR8ZDicqYvlzpqWBRthkp5chDd2nJ+uPC53HkrnKdwKT5VJw
 dq3zRJ0L79M32PVjf9lw2FaYh0GjK89Vzz+AVK5Q=
Date: Thu, 23 Feb 2023 13:06:26 -0800
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, piaojun@huawei.com,
 mark@fasheh.com, junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
 jlbec@evilplan.org, heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20230223210626.B6F0FC433D2@smtp.kernel.org>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10630
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 impostorscore=0 phishscore=0 clxscore=182 spamscore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0 priorityscore=118
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302230174
Subject: [Ocfs2-devel] + ocfs2-fix-defrag-path-triggering-jbd2-assert.patch
	added to mm-hotfixes-unstable branch
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
From: Andrew Morton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Andrew Morton <akpm@linux-foundation.org>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: p-XtAJbDJ61kilsmpNVbVfiKMSSRqAf-
X-Proofpoint-ORIG-GUID: p-XtAJbDJ61kilsmpNVbVfiKMSSRqAf-
Reporting-Meta:
 AAHR2A8HUvJlcmdRFe82Fi3hjADx/9E+gx7ZxDPm2yl2WaTsvdhtRJ2kpMN3RIEP
 LsosRZJYIGJD3A9CLEbpcNFEY2nyS0d0HnHa1KNX8xkIaFIWpR+G/zX/EHXmlWQn
 Oi32Sr6MVD6iTbHjXlmb+N4yQt71MS9NoFLQqsRdap0SIhAe3lraMNJa7TLT8ND/
 Gv+MmoZkGOWN4LIxZjr9p3ZbgcxhijijuFTh17OAxQzt9ISJ91f8T53b3udam4/w
 KLDb6F8HhcCfyvs12d3q/j0L/tkL/c/ej2fCtGOjBKIIuDEuGt0oYwmYD4fjB3QN
 n9AFO8KC/OnaGk3k922YPPFKcUrShLIEpwisezOARHuKbfn/KVdGdboS2XNIr5T8
 lJXEXlYsiShmgBX+NnkCxVjgcHznp09jN4TDrgu2lc8vgbXKspA3SDhDTNKNA37k
 nfX7c/vQrOSe33arIlW3TMi5QjUdmqInPgVk3t0I/T6jnSJJAnvEpVpio0nhtlDe
 JRsRkPRH+g2aMA9T6pNmo+p1Z0EbR1yjbxtk7ggHNImw


The patch titled
     Subject: ocfs2: fix defrag path triggering jbd2 ASSERT
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-defrag-path-triggering-jbd2-assert.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-defrag-path-triggering-jbd2-assert.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: fix defrag path triggering jbd2 ASSERT
Date: Fri, 17 Feb 2023 08:37:17 +0800

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
---

 fs/ocfs2/move_extents.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/fs/ocfs2/move_extents.c~ocfs2-fix-defrag-path-triggering-jbd2-assert
+++ a/fs/ocfs2/move_extents.c
@@ -105,14 +105,6 @@ static int __ocfs2_move_extent(handle_t
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
@@ -121,8 +113,6 @@ static int __ocfs2_move_extent(handle_t
 		goto out;
 	}
 
-	ocfs2_journal_dirty(handle, context->et.et_root_bh);
-
 	context->new_phys_cpos = new_p_cpos;
 
 	/*
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are

ocfs2-fix-defrag-path-triggering-jbd2-assert.patch
ocfs2-fix-non-auto-defrag-path-not-working-issue.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
