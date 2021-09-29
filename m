Return-Path: <SRS0=i0E0=OT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D042EC433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 29 Sep 2021 19:01:53 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6AE326135E
	for <ocfs2-devel@archiver.kernel.org>; Wed, 29 Sep 2021 19:01:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6AE326135E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=valentin-vidic.from.hr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18TIMOZE017406;
	Wed, 29 Sep 2021 19:01:52 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bcg3hqk9c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Sep 2021 19:01:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18TIuAAi042436;
	Wed, 29 Sep 2021 18:58:22 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bc3ceq8q1-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 29 Sep 2021 18:58:22 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mVemb-0002su-MJ; Wed, 29 Sep 2021 11:58:21 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <vvidic@valentin-vidic.from.hr>) id 1mVdzh-0000NY-PR
	for ocfs2-devel@oss.oracle.com; Wed, 29 Sep 2021 11:07:49 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18TI5hxN141508
	for <ocfs2-devel@oss.oracle.com>; Wed, 29 Sep 2021 18:07:49 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3bceu5v5tb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 29 Sep 2021 18:07:44 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	18THKdrB017814
	for <ocfs2-devel@oss.oracle.com>; Wed, 29 Sep 2021 18:07:43 GMT
Received: from valentin-vidic.from.hr (valentin-vidic.from.hr [109.200.23.17])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bcvf6gq0j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 29 Sep 2021 18:07:42 +0000
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
	id 8E8D270E4; Wed, 29 Sep 2021 20:07:33 +0200 (CEST)
From: Valentin Vidic <vvidic@valentin-vidic.from.hr>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Wed, 29 Sep 2021 20:06:54 +0200
Message-Id: <20210929180654.32460-1-vvidic@valentin-vidic.from.hr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <1ab61ba3-8c9b-092c-7843-9c45b58e3987@linux.alibaba.com>
References: <1ab61ba3-8c9b-092c-7843-9c45b58e3987@linux.alibaba.com>
MIME-Version: 1.0
X-Source-IP: 109.200.23.17
X-ServerName: valentin-vidic.from.hr
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10122
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=284
	priorityscore=0
	suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
	impostorscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2109290104
X-Spam: Clean
X-Mailman-Approved-At: Wed, 29 Sep 2021 11:58:19 -0700
Cc: Valentin Vidic <vvidic@valentin-vidic.from.hr>, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: mount fails with buffer overflow in
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109290110
X-Proofpoint-GUID: zHOq0VSWL4G26H4AFxOwR9ExCxRIDoSL
X-Proofpoint-ORIG-GUID: zHOq0VSWL4G26H4AFxOwR9ExCxRIDoSL

Starting with kernel 5.11 built with CONFIG_FORTIFY_SOURCE mouting an
ocfs2 filesystem with either o2cb or pcmk cluster stack fails with the
trace below. Problem seems to be that strings for cluster stack and
cluster name are not guaranteed to be null terminated in the disk
representation, while strlcpy assumes that the source string is always
null terminated. This causes a read outside of the source string
triggering the buffer overflow detection.

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
v2: update description, add comment, drop null termination

 fs/ocfs2/super.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index c86bd4e60e20..5c914ce9b3ac 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2167,11 +2167,17 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	}
 
 	if (ocfs2_clusterinfo_valid(osb)) {
+		/*
+		 * ci_stack and ci_cluster in ocfs2_cluster_info may not be null
+		 * terminated, so make sure no overflow happens here by using
+		 * memcpy. Destination strings will always be null terminated
+		 * because osb is allocated using kzalloc.
+		 */
 		osb->osb_stackflags =
 			OCFS2_RAW_SB(di)->s_cluster_info.ci_stackflags;
-		strlcpy(osb->osb_cluster_stack,
+		memcpy(osb->osb_cluster_stack,
 		       OCFS2_RAW_SB(di)->s_cluster_info.ci_stack,
-		       OCFS2_STACK_LABEL_LEN + 1);
+		       OCFS2_STACK_LABEL_LEN);
 		if (strlen(osb->osb_cluster_stack) != OCFS2_STACK_LABEL_LEN) {
 			mlog(ML_ERROR,
 			     "couldn't mount because of an invalid "
@@ -2180,9 +2186,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 			status = -EINVAL;
 			goto bail;
 		}
-		strlcpy(osb->osb_cluster_name,
+		memcpy(osb->osb_cluster_name,
 			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
-			OCFS2_CLUSTER_NAME_LEN + 1);
+			OCFS2_CLUSTER_NAME_LEN);
 	} else {
 		/* The empty string is identical with classic tools that
 		 * don't know about s_cluster_info. */
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
