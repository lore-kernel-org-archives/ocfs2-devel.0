Return-Path: <SRS0=i0E0=OT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79477C433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 29 Sep 2021 20:21:30 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B53C560F70
	for <ocfs2-devel@archiver.kernel.org>; Wed, 29 Sep 2021 20:21:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B53C560F70
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=valentin-vidic.from.hr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18TKIQW0002854;
	Wed, 29 Sep 2021 20:21:28 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bcf6cxsnp-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Sep 2021 20:21:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18TIuTwE044543;
	Wed, 29 Sep 2021 18:58:22 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bc3bke8ya-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 29 Sep 2021 18:58:22 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mVemb-0002rR-EU; Wed, 29 Sep 2021 11:58:21 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <vvidic@valentin-vidic.from.hr>) id 1mUsp0-0003FD-4n
	for ocfs2-devel@oss.oracle.com; Mon, 27 Sep 2021 08:45:38 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18RFj7Kl085183
	for <ocfs2-devel@oss.oracle.com>; Mon, 27 Sep 2021 15:45:38 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3b9x50kk3a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 27 Sep 2021 15:45:32 +0000
Received: from pps.filterd (m0246576.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	18RD4oBc016035
	for <ocfs2-devel@oss.oracle.com>; Mon, 27 Sep 2021 15:45:32 GMT
Received: from valentin-vidic.from.hr (valentin-vidic.from.hr [109.200.23.17])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bbehbtd8a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 27 Sep 2021 15:45:31 +0000
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
	id C4D887056; Mon, 27 Sep 2021 17:45:23 +0200 (CEST)
From: Valentin Vidic <vvidic@valentin-vidic.from.hr>
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Date: Mon, 27 Sep 2021 17:44:59 +0200
Message-Id: <20210927154459.15976-1-vvidic@valentin-vidic.from.hr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Source-IP: 109.200.23.17
X-ServerName: valentin-vidic.from.hr
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	adultscore=0 mlxscore=0
	lowpriorityscore=0 mlxlogscore=999 clxscore=202 bulkscore=0
	impostorscore=0 spamscore=0 priorityscore=0 malwarescore=0
	suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2109270107
X-Spam: Clean
X-Mailman-Approved-At: Wed, 29 Sep 2021 11:58:19 -0700
Cc: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Subject: [Ocfs2-devel] [PATCH] ocfs2: mount fails with buffer overflow in
	strlen
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10122 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290110
X-Proofpoint-GUID: jlVLotIlTLDAO1aS5kY_nPUIXFL5cn-G
X-Proofpoint-ORIG-GUID: jlVLotIlTLDAO1aS5kY_nPUIXFL5cn-G

Starting with kernel v5.11 mouting an ocfs2 filesystem with either o2cb
or pcmk cluster stack fails with the trace below. Problem seems to be
that strings for cluster stack and cluster name are not guaranteed to be
null terminated in the disk representation, while strlcpy assumes that
the source string is always null terminated. This causes a read outside
of the source string triggering the buffer overflow detection.

detected buffer overflow in strlen
------------[ cut here ]------------
kernel BUG at lib/string.c:1149!
invalid opcode: 0000 [#1] SMP PTI
CPU: 1 PID: 910 Comm: mount.ocfs2 Not tainted 5.14.0-1-amd64 #1
  Debian 5.14.6-2
RIP: 0010:fortify_panic+0xf/0x11
...
Call Trace:
 ocfs2_initialize_super.isra.0.cold+0xc/0x18 [ocfs2]
 ocfs2_fill_super+0x359/0x19b0 [ocfs2]
 mount_bdev+0x185/0x1b0
 ? ocfs2_remount+0x440/0x440 [ocfs2]
 legacy_get_tree+0x27/0x40
 vfs_get_tree+0x25/0xb0
 path_mount+0x454/0xa20
 __x64_sys_mount+0x103/0x140
 do_syscall_64+0x3b/0xc0
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
---
 fs/ocfs2/super.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index c86bd4e60e20..1dea535224df 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2169,9 +2169,10 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (ocfs2_clusterinfo_valid(osb)) {
 		osb->osb_stackflags =
 			OCFS2_RAW_SB(di)->s_cluster_info.ci_stackflags;
-		strlcpy(osb->osb_cluster_stack,
+		memcpy(osb->osb_cluster_stack,
 		       OCFS2_RAW_SB(di)->s_cluster_info.ci_stack,
-		       OCFS2_STACK_LABEL_LEN + 1);
+		       OCFS2_STACK_LABEL_LEN);
+		osb->osb_cluster_stack[OCFS2_STACK_LABEL_LEN] = '\0';
 		if (strlen(osb->osb_cluster_stack) != OCFS2_STACK_LABEL_LEN) {
 			mlog(ML_ERROR,
 			     "couldn't mount because of an invalid "
@@ -2180,9 +2181,10 @@ static int ocfs2_initialize_super(struct super_block *sb,
 			status = -EINVAL;
 			goto bail;
 		}
-		strlcpy(osb->osb_cluster_name,
+		memcpy(osb->osb_cluster_name,
 			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
-			OCFS2_CLUSTER_NAME_LEN + 1);
+			OCFS2_CLUSTER_NAME_LEN);
+		osb->osb_cluster_name[OCFS2_CLUSTER_NAME_LEN] = '\0';
 	} else {
 		/* The empty string is identical with classic tools that
 		 * don't know about s_cluster_info. */
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
