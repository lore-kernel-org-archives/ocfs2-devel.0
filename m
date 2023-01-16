Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 338CBC677F1
	for <ocfs2-devel@archiver.kernel.org>; Mon, 16 Jan 2023 15:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=a+ByKWeaTpRDL/5jT2+A27XGX2XtpDPlx/4krz2dMJA=;
 b=CLbUk8TqOn4+sVQQ0JBLPtVtv9m19ADb6cALT7niTrgT3MisxuJRYDtoIMeSlj2tF3uw/Y5W6+lY
   dSE1dneAcHiG1PR2jk4Igcy7kHtNuN2nfPXy/z6hIym7Hny80joJoUZvVGrWI2rhswzSdwBIzUnD
   0b5PnOa55S0t3VKd9iDJW0A1TBVIXlR9oBuNjf5tBgNdWpWeWNCMj+ogNK47oDuTdGRkpoGR77B+
   +aHqwZ07o6BCo0AIXx8QVSaiEXJgSFZN/GtPUJAo8vPKSqt3oHUIvKvIzULu4KvJEgidyii3RIFM
   mkG4NstJWxRD2Ft5e1+w1r+O3WtpMeJvFHW/yA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=a+ByKWeaTpRDL/5jT2+A27XGX2XtpDPlx/4krz2dMJA=;
 b=NLG2CrNOg62uTPKgwunlgyvUJ810IPof5F9F2n/C0ruOZNg2HT/hInZrApz95OZ90iAIqRS4i+KY
   uteSBQJB09whTBWwirz9JOZr5cD0qFa8gk3/VfWEIPKPEuUKyrBb5QTG2XwNyZYGYwI7TJK1uGnZ
   WAMCZ1iOMB3CNqiSonTzcKs6E6Dw8uexzXtxlqcgzUlnUGgjTvf+NdSneNLAj+PCa6LbsAF5VtkY
   +hKFJYAguc6i5NK5pXjRvSr4mfEIh20z2UkFsuQl5U352rcyAM7EHetm8jR5jQVkyMh0Vv/GiTmB
   nI0qy7AvsPhqGLHJxxekRh9lZtLv+bM5sSQMzg==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROL001ZH40PXZ90@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 16 Jan 2023 15:22:01 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1673882505; bh=p/lUi0dYSuLPQOjtFZrzMeu+ey4z0ARLVxj4E7Ma94Y=;
 h=Subject:To:Cc:From:Date:From;
 b=EaHs5YGDs9EVqEMuniFNv5hG6ZKlJ5+FytFlM+B1mt1OtybDTG+oChwX8Q1PdWA1/
 5ZSLzOa1/O9eGVRH9OIAo6B0+e2tys3ZKaOy67SqxA3+wTcseFnj5rbBP+qGb/hBjn
 jOnGaCqzNUTqLNVptMfMR/7VeDGoQNvl+99buMdw=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, heming.zhao@suse.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Mon, 16 Jan 2023 16:21:42 +0100
Message-id: <16738825026091@kroah.com>
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10592
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 priorityscore=205 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=173 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160115
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch
 "ocfs2: fix freeing uninitialized resource on	ocfs2_dlm_shutdown" has been
 added to the 5.4-stable tree
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
X-Proofpoint-ORIG-GUID: JVci56ZsyUGb2ffmaFb09k7pJL639nSH
X-Proofpoint-GUID: JVci56ZsyUGb2ffmaFb09k7pJL639nSH
Reporting-Meta:
 AAFn4o0nAh3NgO83uB6AbKtfxaEGCC7SYN/sT+i1tYb2tsyAl6/C5mY9Us69Y/Je
 vmeSXeYEnVBZGJIgZzqVAXwIcc8sCkH1GUNLranN4Mp1YSczbYPzm6+POB66dEsp
 E4qetMEFpuymRYl7oIRa7gaM5JG8lRjPvPnUB50mYw9STDO9uvtmGrQGgDfJZ4V5
 bfqaquIODdLr8EeMCsR5VwVEf0zufAHWeiwpdmhgyEuBG9jkzkYwaOS8VeY1UQGs
 gAd66F7kL7rER7mOZodm6/qx/XKTV2sdmvCfvQYYLRMeLGy9nAVyN1bZfPKHOUjk
 wfIZb4LCYV91/2Ce1b1PT7Aml1q+O8iIoaZuOZRcXZXB1ck5w8KsVLOWDoDFCVTR
 vNgevYBMLFm8dkqkdQI9Sa7Y2nX1ajOGJ1JT4Urc62nuDDykQNiCPWAP6QSDpS0i
 foQa2kw44nTa8B9mP6yc4XoIWSQsy2YfBeZMveo/XgpmY6wWdQWdMWVVmNGCNYue
 jDx0hn5MdFAWBDJUsZJFxoz59/aD9CYKfkJsAVa5Ay0=


This is a note to let you know that I've just added the patch titled

    ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown.patch
and it can be found in the queue-5.4 subdirectory.

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
@@ -3396,10 +3396,12 @@ void ocfs2_dlm_shutdown(struct ocfs2_sup
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
@@ -1922,8 +1922,7 @@ static void ocfs2_dismount_volume(struct
 	    !ocfs2_is_hard_readonly(osb))
 		hangup_needed = 1;
 
-	if (osb->cconn)
-		ocfs2_dlm_shutdown(osb, hangup_needed);
+	ocfs2_dlm_shutdown(osb, hangup_needed);
 
 	ocfs2_blockcheck_stats_debugfs_remove(&osb->osb_ecc_stats);
 	debugfs_remove_recursive(osb->osb_debug_root);


Patches currently in stable-queue which might be from ocfs2-devel@oss.oracle.com are

queue-5.4/ocfs2-rewrite-error-handling-of-ocfs2_fill_super.patch
queue-5.4/ocfs2-ocfs2_mount_volume-does-cleanup-job-before-ret.patch
queue-5.4/ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown.patch
queue-5.4/ocfs2-fix-memory-leak-in-ocfs2_mount_volume.patch

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
