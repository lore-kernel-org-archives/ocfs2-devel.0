Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80E37C678D4
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Mar 2023 13:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cO9YpS9/Q2QMLdbrU2sSOrtFQyQk9sKYqTHd/5Cyqn4=;
 b=c7aVuFHkli5oL+mupjiv8+T+fMqZP0KYdORs4gweWy2TqByMmHl15wB7Phhj/SVy4tcR1p+8/lSc
   WUQR/OJQS1jo3lKXoTFxBO8TG+ZZ+NCWAmbe+aMmIoWZ8OjzMlAwlonEiC80CNBYiKhwQJLgMzQ/
   qvwaQ/4KMdFLmxUKl7jbpZ4GoqvFcu1b3TtN3JTx/6GPUqJt56273zD5UXyz4biBdWc7UKMWjZ/R
   z0bZukSwA1fo3Tlvkc01O/kzcwQSpCcHc8/i7hqttJKnbXsWzRYFhtKPEekHs4E4yl4UdYQsXY/N
   V2wnCTWRH3kmcDlz/ZZyAV3cfgnxuLuM+EtQlw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cO9YpS9/Q2QMLdbrU2sSOrtFQyQk9sKYqTHd/5Cyqn4=;
 b=ZUEbYInTUH0STvZGsXEfce7/O48bfTKbyprPtJWzk9UXN5dRx6J/Xy2Z1N2uSEqKoWf17bMHU0qX
   aVSEYzSTTB8YdyU4xiepZ1JXmMxh7+CVm4vFmF/iBauQmdpr0h0l4jeLXhdhbYDlU4Uq2W1xLA4+
   RlAvF2HP7IDZ6qv/31xxr+GYGpUZvv7QAjf96+Y7912A6C/BBfCjS7jUEPptwP/8gwGyrJ2Oq0fD
   Ozu1ieXAedVCk6rSHDUiy9NjzzVpkxxoKp/1tAU+yUWcacG2evS2R1Fuc7aS0oobTzL5OL4e2bRa
   jo7G+LY2xe8aQSpzUKNXBQqFZ+xbrlHZVXUvVg==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR300C8FQ6NI1A0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Mar 2023 13:44:47 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1678110274; bh=Fo5v79GdtHmo8V+q0LY76wx9pv6IOb9A8x6/oriJziA=;
 h=Subject:To:Cc:From:Date:From;
 b=nsovT2akkLEhgJcMQSlx40vYmgLQp1dAaFnqR437CW69WGjUSvkkT1v+ZjSncZSX+
 ypMEI1sWJngyFlyZzdGP99MJZ0GAI/A2nA7cVRZhjYP1GsqIhDL3eVlb4uo0lNCQkA
 5n4x23n2xdrO2/RILzAK3F8SKdbqw34VJgguATLs=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, heming.zhao@suse.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Mon, 06 Mar 2023 14:43:38 +0100
Message-id: <167811021818220@kroah.com>
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10641
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=163
 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0 priorityscore=143
 adultscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303060121
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch "ocfs2: fix defrag path triggering jbd2 ASSERT"
	has been added to the 6.2-stable tree
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
X-Proofpoint-GUID: linxOX0p1Zh9eP3lxJWpew6cHkpiTesR
X-Proofpoint-ORIG-GUID: linxOX0p1Zh9eP3lxJWpew6cHkpiTesR
Reporting-Meta:
 AAHXuK6FPcznLxSGTWpzvKtxcJnMuFmqpSROIhLUNp58x5jXYBzmgckUN70YFRmd
 UwYIqgeMsDlx085OH/3jfnx5tLEhY6jGCCiEso6MpYghT8VSi/kpaCEAeQkSyATv
 rmfu5WM84gLFojKcqnJLFo2uE4Gn/eSmo/2VqKVCwe68K53JGoOILW4ftwtZ2Rlm
 oos6+PJs4HGfLov2lMrZH0NwLHxLP4FSJse2NZXcaT+IekElq4MQM7Nuj7KfkfNR
 W57W06DMKV7tDdzm/x8x3ABWOlwGRLnT2gfoPC8gnJdbYAdSi1Dq/MxIEhiZ3QCy
 X1D5zHV0XF6shIf5HxANW7hTVi6e12TA6iEcP/P8bb0tfeiipZNetGeK+lB4AO8u
 nZcEc57CFQqkU9KqmVzp7S5Ud7kArM0DpfH5WpuHoJNiDWCWENCRqkRKA/6OJ9Ve
 HyaIbNd3uIfOtjtaZMdlxxKfbnio9oNxwTR2YaGSN+fC6tUMPIGgaezjwpS/9Jvg
 +vgwviyFS8fsWh6mcmrPN/40OUf635lxqp6TyK9KKJcP


This is a note to let you know that I've just added the patch titled

    ocfs2: fix defrag path triggering jbd2 ASSERT

to the 6.2-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-defrag-path-triggering-jbd2-assert.patch
and it can be found in the queue-6.2 subdirectory.

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


Patches currently in stable-queue which might be from ocfs2-devel@oss.oracle.com are

queue-6.2/ocfs2-fix-non-auto-defrag-path-not-working-issue.patch
queue-6.2/ocfs2-fix-defrag-path-triggering-jbd2-assert.patch

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
