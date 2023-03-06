Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55909C678D4
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Mar 2023 13:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4njK5kGmXLmqaXSvFqToH/4fcePcguNm8UTP/8WmtDM=;
 b=r+SGGzsoxtkmaB6cbKoZ7J0WKmlM4jVlgaKP/UgxHfv6Ztxnsl79M/9LPNris0jbUlPnetLkHP6M
   fGzi+KAnuuWHBy38X7Snc5Ms+t5zfR5jfzqHnGjiCMjKz8a+C/tg2f9tK87bQ2D7YqpPYqfva6Gl
   EqLVkhUorb6aoYKL7YcbaKv4sPGkqE83TrdtSB2UuV0F869TgbIePNxRRwXgUcHzrhUZJfRtSIu1
   BHxZPoHCNYL5JuxW8itsdMzs79jFQTcQQwUzHPqZrcazGyRox+cFiCc0D3qFcxzYXzGXb+/GHMQB
   s/sjqpRE3gE+hiRokeRVwLCYSGk9Zsa6lpQxhw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4njK5kGmXLmqaXSvFqToH/4fcePcguNm8UTP/8WmtDM=;
 b=S3Hfu+XrEEwfRXk2Sp4oEiDKTX+pJex+XHPED19LauFyDvF5P2///WkNztVteQsd6T1R+Z8X91y1
   bhjF9rTGCa8FAfxdYHEz/eAyLpqtdnrbWAffnlcuLuQg+jYMJezL/mu9wWP0F0MVh3taRxoau2eJ
   w6ruu2oQEi5uFi8+vmqM+4f3tTaWy14j0rf1brJNxQOYlMMA8GH4YypmGYDKwAWhj4plATIe0uBn
   ZK3o0Rmdxhm4F5GmPtk+jH9ZkFzdThKK9i1Zvei1OTH+rio3PTCxoyzFn9wWker0+lYf9mlKhRwm
   hbffoKmbGtauQTK/W8JhO6IvGv4gCxCcdVil7Q==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR3008DIQDSBK80@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Mar 2023 13:49:04 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1678110531; bh=9RNCAoAJARxP0tdTq7QiwHP7fVVEjvGR0tgKsGcYAaI=;
 h=Subject:To:Cc:From:Date:From;
 b=aWNsnDTbDfeyIs5wMq8W5MZjr13sqZKVNrheYqRTuBK/wD2R9Qlq2K/0MYOs5oY1M
 U7oSrtnmQRSj06Zli3AB/Cimwv3gUn6rqV4iraTyvsfPXCyaTD9W9eFkSA6SJcPKt6
 BU8YNYtsXVOch1lUqqcAow2dACz+6gTGUBDoVXmo=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, heming.zhao@suse.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Mon, 06 Mar 2023 14:46:11 +0100
Message-id: <1678110371161118@kroah.com>
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10641
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 impostorscore=0 priorityscore=178 mlxlogscore=999 malwarescore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 clxscore=114 suspectscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303060122
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch "ocfs2: fix defrag path triggering jbd2 ASSERT"
	has been added to the 4.19-stable tree
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
X-Proofpoint-GUID: 099Bda7D6sgY1JF7ZsdgO23KgITGRojj
X-Proofpoint-ORIG-GUID: 099Bda7D6sgY1JF7ZsdgO23KgITGRojj
Reporting-Meta:
 AAFVT+if9YqCBSG3+vkPmGuyuIM2IFcgN1V7z6k2/hJWZFAxUU7zA/ec2LFU8nsc
 EoJzlkFtm8MvRqVhhnW9eluWCEQiIKyx2MFIA4KlnKhrCGRzjZqvJ0Pr9/d4mF6G
 4pZBix7lDrFp1mmQ0xwrcrx7krXzPFwOYYfhLmVHAd6napm205Ocl/fUiMCzeQPk
 VjR+4jRPwyUpbw2GmUMb7Lg7zL18cUk4ieeQD8lLA7YXWTYwTpfgQ00Vm7rBgB+4
 wFfHJEOQnj2NpivxXh9oBm32ARQtXEAjd47ezltjr4ms3DPjfptk+1TT2L6rqa13
 yl/YVxlzjKaZ3RNYyi1O52vE40ksfm9QSio2Xr2XlSQPeDH+bfb781fRgAqfFyAG
 zqkprfLFKLmfg7u2czD97xJR0NX3mx0XyqmgKvWWqxrjCkFatAUQzrTh+yMvgL6Z
 dUxfjrhnGQCQtw6OX48TfvS8pOXWh3xa5DbKquQrvCSYCdoL0U9VbF9tO2RPO83T
 n3GHnz0ycAKHKYJxIOwcd4K5CqP4DLytDf6oETd8BLBE


This is a note to let you know that I've just added the patch titled

    ocfs2: fix defrag path triggering jbd2 ASSERT

to the 4.19-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-defrag-path-triggering-jbd2-assert.patch
and it can be found in the queue-4.19 subdirectory.

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

queue-4.19/ocfs2-fix-non-auto-defrag-path-not-working-issue.patch
queue-4.19/ocfs2-fix-defrag-path-triggering-jbd2-assert.patch

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
