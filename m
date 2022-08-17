Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F0BEC25B08
	for <ocfs2-devel@archiver.kernel.org>; Wed, 17 Aug 2022 21:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=UlMRTrhR4kbiG8Acz3JYp9XnpwESS+ikYPDEmu9xv34=;
 b=YznkDYbzMIOCfvD9mNW04X7knrEpikqGlnsP/EYrv+GJaJYjMtv5jEHZIuR4cDKsIo6eP6rC8BWy
   uwthci3IUQG/JM06TDHMCh9wNjGU+ibKI3aArBdhCIeEPBhC8kLMGccUbVAVqvZaQsSiMAQBHhze
   orWRVI8qWgUoytbRyMII2CA3kJmDsW+4SBf5dUsmNLlgLJkk+KCxFTdgpJl//N34P1GyDXEDhPWz
   SvaVYEs7azIn/qSHcFnBrQt8tWmEA/wQO62GURkVjjTe0fmbCYryByA180KwL5eEXeWLSNBqtkoT
   FuyjYtlIYb3EKgJDzLsbJoArDtmZUJjoU1I0JQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=UlMRTrhR4kbiG8Acz3JYp9XnpwESS+ikYPDEmu9xv34=;
 b=C3VQtUvZmIC04uEFqlhVEp2o8cCYdT0TQNQ5fRxcGBV5A31KWI8Ib6g50IDppLgdneHnasN05DHY
   bunSCptjIFV/5LZyonBnHN1iBJ9Ldh66H+YFJgKt/9EPtrnyYET6IAX5h4Lc/7YfnXKLmXdzQoAi
   0R3jgo6Sx41UpF8N3RF7Dcttnvr6Tt7/Ww893UyhfROa2kPnp2QzuQ2DNV5BOSYpavkjFu2fURXc
   Jqk/r3uWJebDJ4qGiKOCAZ0YHLEuR78JL3OT5nyQoABlgi5qFlDVBzroznKCm0voxNuvHS1laPXK
   maYldeemN8skUgmD48p6oeiKTlMeo37/eURXTg==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220805 64bit (built Aug  5
 2022))
 with ESMTPS id <0RGS008OX32I8Y80@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 17 Aug 2022 21:15:54 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1660761191; bh=h0aDeNAQk2+6XVbjV+tga/UUib0hGg7WqW+gjSy8Z/M=;
 h=Date:To:From:Subject:From;
 b=ysqkjskV8LDFylJkFkxrQj4bwFJpB2ZoVJI4r2x/kR6MEh8OYMMJvrD3W8pSN8asF
 gXRPrJ2aiN/Jm7FuLuMEooldRyCbk4VygZ7rvIL6RmggaexquQw5J387rVia1O95wW
 GRbPD7kE94p29tpauaNpKSnbiItJv60wYnrZkA7c=
Date: Wed, 17 Aug 2022 11:33:10 -0700
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, piaojun@huawei.com,
 mark@fasheh.com, junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
 jlbec@evilplan.org, heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20220817183311.1BFD8C433C1@smtp.kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10442
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 mlxscore=0 priorityscore=164 clxscore=199 impostorscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208170069
Subject: [Ocfs2-devel] +
	ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown.patch	added to
 mm-hotfixes-unstable branch
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
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: xGZjfAqdfatIQzNb0PI-dYQepU-Mt4T5
X-Proofpoint-GUID: xGZjfAqdfatIQzNb0PI-dYQepU-Mt4T5
Reporting-Meta:
 AAHcBu9Iq6gh9WwhKWIqqyFyzftdBgpfpKjP5xxiAsGzqCclfqSC2IbioI038gr4
 CyMsG/1C6TeJvdSAeamA/jdlzziopVoSFiBEfdCchSLBwULC+s3I9cDNRjQKUZs4
 hwVOiyrU++jmbZ5vKcWsoM8BYFux0czppxmdOQBUMI9kJzqgT046C87AXh4++YSZ
 52rvBrmC/PjgpRWdSZTlboN8mReCT9egBjWSEhM4AeeJHN7XVdiLKYiXDPx3Aucq
 6hYCmiD6Zux07xs1lbauVgxJP5mcA1sxYQ7xfL1pBTZ0Xf8h28o14CcWMNNv7T5S
 X5DourLdiatOOSYe6RL44Y1Q57THmZsrDmPHmhSwRNfrttYZxN3mSmFRNI8SROwv
 /wbK3NJT0pVCkNdUf4xY0PEBG45/EZrqaQkxNUi1Kw7943npdk8LOGi+7QCiJjGV
 EgQhGeYxv3VyX+iboI43CoqwUCQ/llHuPrvExPWlGQNu6hiMey7+AeyDuakcPIgv
 r/Aw137gZ3zf3y6149AXr7wuotZIVDirTyvdACqCsoRU


The patch titled
     Subject: ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown.patch

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
Subject: ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown
Date: Mon, 15 Aug 2022 16:57:54 +0800

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
---

 fs/ocfs2/dlmglue.c |    8 +++++---
 fs/ocfs2/super.c   |    3 +--
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/dlmglue.c~ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown
+++ a/fs/ocfs2/dlmglue.c
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
--- a/fs/ocfs2/super.c~ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown
+++ a/fs/ocfs2/super.c
@@ -1914,8 +1914,7 @@ static void ocfs2_dismount_volume(struct
 	    !ocfs2_is_hard_readonly(osb))
 		hangup_needed = 1;
 
-	if (osb->cconn)
-		ocfs2_dlm_shutdown(osb, hangup_needed);
+	ocfs2_dlm_shutdown(osb, hangup_needed);
 
 	ocfs2_blockcheck_stats_debugfs_remove(&osb->osb_ecc_stats);
 	debugfs_remove_recursive(osb->osb_debug_root);
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are

ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
