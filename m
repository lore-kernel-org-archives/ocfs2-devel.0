Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 032B5C7619A
	for <ocfs2-devel@archiver.kernel.org>; Wed, 12 Apr 2023 08:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=kVUCTG6DjmH3qeOVRt6ZK27pKRDw1ZkMFbNySCxC1wc=;
 b=fxD9FTdFodOEHBUo1vu/zksWC0g1JNX4WlxSayW7ku6KqVjSxj//EwC1ft9O6ezs+gvZKrqhDvwM
   yHxOsYj2tXfbKMzF1wP9CAVkLcHAr38aPLzQ6hVcCXb6yj601Wg5Zqr/FiQFpVhbsQOm//m552nN
   BfObpYglfk4PGyGaqGdnrkXnjU7PtzYFxm21tUCQUSrfu7TWlqMx7BhXFCcYssTpdxxqaFdB8/Bl
   dZw6lb1CWoLqTplGUIlZfI+UBLS3mJhrIeevF8xd1Q+BS6ozR+ZEt4YhfaEX0AdZii5xZtA6Q/1a
   7Rw3m3u4Ai9ri0PAhvouxVCD1swpHQ78+ZSjeA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=kVUCTG6DjmH3qeOVRt6ZK27pKRDw1ZkMFbNySCxC1wc=;
 b=GI5ERWJxjjKFJ/riRRDwydefTGuHluhKdTlVHfF9+Wik/f2FyPftNulItfw0neIyBJB5euvf6b+0
   oWTnPTmGqbgAQaItIwfnXssoaBK+GW/YUWNzkYqAWKhLqpupOUPo6IUi/fopf0GSaekngVe4aUyd
   ap8WPMDPfybkg72cxN8N69Jwi6lE3cSsulvw6XmLGn8tOErd+W3g7SSaBvVgAu4sFAUfgBejhe6I
   MgKwOJYCnXgs2k6DJajGICLIKzq1xwp33aILqwGYXswdfnkTQVPjwoLSowRsGz0U1XT14YGLn+Wd
   4OeqNinG8MgqRQJVpfnUnPyLxXbcVoSta2DHRw==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSZ005EHVEXIZ60@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 12 Apr 2023 08:54:33 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1681289661; bh=TAeL5rMf4kKMKA7+0HklAkQRcVysiNbxHZAWmLTWVyM=;
 h=Subject:To:Cc:From:Date:From;
 b=Nr6GTd6V9iy/IM4qG1YJe2RZuNnI5J98k62mNHPXcOrKceVzjmNFFgs6FKAbJrgcg
 KzZ2OkWKugvoJgGwicOBa58y4EdHnqiZXo4poDG4G6KvuSgf4MgOvmP6qnpXTtYRiW
 t+gXPL/RLJubviiUAqY/G9/Lo7uo6PPeBFKPIIn0=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, heming.zhao@suse.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Wed, 12 Apr 2023 10:48:03 +0200
Message-id: <2023041202-tricycle-twelve-8822@gregkh>
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10677
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=223
 lowpriorityscore=0 impostorscore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 suspectscore=0 priorityscore=278 malwarescore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120080 domainage_hfrom=7764
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch
 "ocfs2: fix freeing uninitialized resource on	ocfs2_dlm_shutdown" has been
 added to the 5.15-stable tree
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
X-Proofpoint-ORIG-GUID: GUnuMl0mEHgV6-hdeq-lVLB8ywtt2Vi7
X-Proofpoint-GUID: GUnuMl0mEHgV6-hdeq-lVLB8ywtt2Vi7
Reporting-Meta:
 AAG2dpFEazkhj5LjtcqhiYZRvFfLNTf7+hTbOVrcMdrNENyqwr3B+Cq9Z/N92vhO
 hGFINSUyU4b0sK5/hdzW1PDLaC2NYAohDFZQLak2voHkLO3V/UGGid4zHr5bJ2LK
 WXq/frKBH5e/pPZtS+MTox4QJaT3/PK+mLKJmQgUkgnNj4I99T/obwDEbPXZykkD
 DDo70yCAMRV+Ij5HOtETu5AC244Gf75CICrjKN0V8qdU6y63onZUgctIEYGened6
 kf2Yd+SLOwv68Zh+WpKsGD6m7DvnzuCaybHBJqvaepF0CWPe/Ju/W3MGrnp6E5R2
 3eIy9ZLk1U51NyPqk3HBVGAcwBHaLlWNwD5yST4PdaSwvdrRICO9ChLSmkIhL2+o
 9385hJom+Hz3bgg9Ms+fYBNTXb7wBTl3jVytwqoO+DSgOlMVlEHUdUOu3Jh9cP/8
 0cj0rtdhDjHmAj0Ev7Fr112s1QCd4csFXIYyOxFfnrFIXHWUX5LiOAmHoQDPu0uP
 joeSe1RDKAOr6FQWFsnKxC0gSilR69xIFn9kCAkggeJOiQ==


This is a note to let you know that I've just added the patch titled

    ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From 550842cc60987b269e31b222283ade3e1b6c7fc8 Mon Sep 17 00:00:00 2001
From: Heming Zhao <ocfs2-devel@oss.oracle.com>
Date: Mon, 15 Aug 2022 16:57:54 +0800
Subject: ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown

From: Heming Zhao <ocfs2-devel@oss.oracle.com>

commit 550842cc60987b269e31b222283ade3e1b6c7fc8 upstream.

After commit 0737e01de9c4 ("ocfs2: ocfs2_mount_volume does cleanup job
before return error"), any procedure after ocfs2_dlm_init() fails will
trigger crash when calling ocfs2_dlm_shutdown().

ie: On local mount mode, no dlm resource is initialized.  If
ocfs2_mount_volume() fails in ocfs2_find_slot(), error handling will call
ocfs2_dlm_shutdown(), then does dlm resource cleanup job, which will
trigger kernel crash.

This solution should bypass uninitialized resources in
ocfs2_dlm_shutdown().

Link: https://lkml.kernel.org/r/20220815085754.20417-1-heming.zhao@suse.com
Fixes: 0737e01de9c4 ("ocfs2: ocfs2_mount_volume does cleanup job before return error")
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
 fs/ocfs2/dlmglue.c |    8 +++++---
 fs/ocfs2/super.c   |    3 +--
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3403,10 +3403,12 @@ void ocfs2_dlm_shutdown(struct ocfs2_sup
 	ocfs2_lock_res_free(&osb->osb_nfs_sync_lockres);
 	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
 
-	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
-	osb->cconn = NULL;
+	if (osb->cconn) {
+		ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
+		osb->cconn = NULL;
 
-	ocfs2_dlm_shutdown_debug(osb);
+		ocfs2_dlm_shutdown_debug(osb);
+	}
 }
 
 static int ocfs2_drop_lock(struct ocfs2_super *osb,
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1918,8 +1918,7 @@ static void ocfs2_dismount_volume(struct
 	    !ocfs2_is_hard_readonly(osb))
 		hangup_needed = 1;
 
-	if (osb->cconn)
-		ocfs2_dlm_shutdown(osb, hangup_needed);
+	ocfs2_dlm_shutdown(osb, hangup_needed);
 
 	ocfs2_blockcheck_stats_debugfs_remove(&osb->osb_ecc_stats);
 	debugfs_remove_recursive(osb->osb_debug_root);


Patches currently in stable-queue which might be from ocfs2-devel@oss.oracle.com are

queue-5.15/ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch
queue-5.15/ocfs2-ocfs2_mount_volume-does-cleanup-job-before-ret.patch
queue-5.15/ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown.patch
queue-5.15/ocfs2-fix-memory-leak-in-ocfs2_mount_volume.patch

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
