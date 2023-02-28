Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE1EC64ED6
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Feb 2023 01:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9ZqIXIXFHJjPJlHuEiA1VmaY3WD57qX8JsMFcckvkfs=;
 b=efqWWcc8NXyCSr9OZohzUJJ3myfrk7bydVxmnQ2ghMDNKm3LTrvSjqmltACcHXkEbDyALgsNo/Bj
   FaMpdhqOY9gr4EffHbZrj6TfHZJVmjQzOU1YCCDvIiQDNcz2mc1QiBk5OuYXcEMcUY90NJ+JZcVY
   4BT4ALZ8Wlk69rN1fdh6QfOWKZeLxKfsTWuwH18UTQJUK0mc1/dUUDI5VUoqlFQInlMpeQOSapi0
   zYTrUKXa/CZUy5mv76FOyBZQyyXY/381WuHWw8bNfJqodRM1GCI7+Nux5v4yPARUE4d19Pe74xtb
   aI+vel18MsgyAcf7YTyDL3B+ms1CQGpoz+ytWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9ZqIXIXFHJjPJlHuEiA1VmaY3WD57qX8JsMFcckvkfs=;
 b=q4BSmIsecQfBOv/WpavG/OmfQJpJPM+i7yJsjc1V7SKw/H8AtA6hQKkzJmUjOiZarGlkJvKsq1jD
   OGG/6DBwR/nzXd6lSwRQ+/SxMFUPIwFMUxAc3oXIhc/fr4U70mziHAyS4owRV/Bo/aUlXd8uN14z
   z10km3ohoG9+9ZXxhOvtDM0D8x8wU9pkgesPr3tVJbqbjlFSV7xFh/uNt5L9IXDI5NOaW3n5ufzA
   aUG/ZMOZLT8KbqhdEAbK75T+ht3WFrNWj0i2JqRydbvHPkZbLMhIeVdA337b9Y0ylSQjxrB+IEU7
   90rbGlzZgucqmjPtDvXABHc1nsOAqRcSl9NnLw==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RQR00GPJMTZPM70@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 28 Feb 2023 01:01:11 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1677546054; bh=hk6Isp83fVhMZHhaEpepdIuZyFnv0MOxbnz2+DM1gCg=;
 h=Date:To:From:Subject:From;
 b=b0W0JzGoDRtmVrAmHzBy6WXoTxHzjWKu3RYp0BP6cSS2W2Au4Q63jB58YdQqR1OC6
 RCemlaj9IHDwBlnzz0kT9nETlGiqCpJ+84Cslf/wG0m77KosSS5PQa+kCW50MyMd/6
 zq5QnDYbJjn84LHegnt18OFz30bXc8ldtjrB7FGs=
Date: Mon, 27 Feb 2023 17:00:53 -0800
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, piaojun@huawei.com,
 mark@fasheh.com, junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
 jlbec@evilplan.org, heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20230228010054.52960C4339C@smtp.kernel.org>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10634
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=30 phishscore=0
 clxscore=217 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302280006
Subject: [Ocfs2-devel] [merged mm-hotfixes-stable]
	ocfs2-fix-defrag-path-triggering-jbd2-assert.patch removed	from -mm tree
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
X-Proofpoint-GUID: VtXbjN5CkzL25xJtkWW6mTv409MA-lwt
X-Proofpoint-ORIG-GUID: VtXbjN5CkzL25xJtkWW6mTv409MA-lwt
Reporting-Meta:
 AAGGQ1WlxxoYwrOb4F1HanqS9bKwJPuGF1Me1c9gFzv+1RMUyOe1NUTj3PCsXF3p
 gJEakVq3nZrVPxOEPCsRJsIk0SPbBkC5Ne+OSiCXb2GDirMefOP+zyk+0EJHOZUr
 2W7ZpQPHNXwOxOHlZpOWafMD3U2cuqotZArt3wN0jGsErS9aUrKuAHR/aV2XOKTw
 Xt3EdJilDW+/vB9kw8XpE1rqHRdTckKRdtjgBJfSk/zcr9Y7RCUA4+YjPSge2hNn
 rFX3ZMzT0Oe+zIM3YBO5/XEjtKDg+s/om8TqOIhhU7CKx9bh1WN35h9h3AvTHWvz
 aZHc90b+Wy1lVd4q7VuaYMnC1kIPxr9sR4K96SQCS8elCBfvWWzwl796bRekgp5X
 8xEFYOYFzbbpmco+Lfo0YBXDF9Wn3iAc1thBaigFQBeorPVdi6aLR1HfV4wx7Xsc
 rv3gyF5QhKJuzJZr9QXKt3bkgYZxCzGD5U3/fgRTrIlQPg17lfpU7sTHDGNNVpfl
 nZ6Ns1TG96ahARL5wZCvruor8AarQiKWsAJYAgfhNnU=


The quilt patch titled
     Subject: ocfs2: fix defrag path triggering jbd2 ASSERT
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-defrag-path-triggering-jbd2-assert.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
