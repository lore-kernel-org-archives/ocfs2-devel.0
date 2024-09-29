Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518DF1362
	for <ocfs2-devel@lists.linux.dev>; Sun, 29 Sep 2024 04:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727585304; cv=none; b=XbFYtJEnEtxS9JJZ6bmJmJ6mqlZw94xfc61U0tREBKhMhMP8wlfmOuZCmiJk+B0XMXr9dmGIcjPF9ZDpJKQ8Kpdj0tI/1VAQV4CphyzS0JsH/DsOZTSuvGgkj9q+9WHFGPBx8CfuEWG28oyCA1OAFeJTG5xQKt4sncNPHdiHzfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727585304; c=relaxed/simple;
	bh=w3JLJH1HW4HWGrx9dQCVYe7A8aJKvoxhjCsTssUXrkE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ixa9PZElh7GZ+SYTxnsWIJtceXieeicIvqw3K56WrusWUkPevisvgBbkbb1jCr4HMpztJ0QoLnP91xmZoOGmPokzrWrFYD288VtQDDN34yzXwOpw6RZYzZzo7iU+uSdiiS5FlOPOAWnvtWLi30ye1SHwniSPs9MtHFZLRGdkvQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48T4dtwb010943;
	Sun, 29 Sep 2024 04:47:54 GMT
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 41x8s88y30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 29 Sep 2024 04:47:53 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sat, 28 Sep 2024 21:47:52 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Sat, 28 Sep 2024 21:47:50 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com>
CC: <jlbec@evilplan.org>, <joseph.qi@linux.alibaba.com>,
        <linux-kernel@vger.kernel.org>, <mark@fasheh.com>,
        <ocfs2-devel@lists.linux.dev>, <syzkaller-bugs@googlegroups.com>
Subject: Re: [ocfs2?] KASAN: use-after-free Read in __ocfs2_flush_truncate_log
Date: Sun, 29 Sep 2024 12:47:49 +0800
Message-ID: <20240929044749.135112-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <66f86aaa.050a0220.4a974.000e.GAE@google.com>
References: <66f86aaa.050a0220.4a974.000e.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=VaulP0p9 c=1 sm=1 tr=0 ts=66f8dbf9 cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=EaEq8P2WXUwA:10 a=3Jp-bdffBUNAT6w8rh0A:9
X-Proofpoint-GUID: Jmn43806UUbBooG68zUyDrN80SlN0-w5
X-Proofpoint-ORIG-GUID: Jmn43806UUbBooG68zUyDrN80SlN0-w5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-29_01,2024-09-27_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=658 suspectscore=0 clxscore=1011 mlxscore=0 impostorscore=0
 bulkscore=0 phishscore=0 malwarescore=0 spamscore=0 adultscore=0
 priorityscore=1501 classifier=spam authscore=0 adjust=0 reason=mlx
 scancount=1 engine=8.21.0-2408220000 definitions=main-2409290034

When the truncate log is initialized, it got a too big tl_used in truncate 
log inode, tl_used is 64512 and tl_count is 39.

So, when the condition tl_used > tl_count holds, use the value of tl_count
to tl_used.

#syz test

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index ea9127ba3208..a309920fecd1 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6326,6 +6326,25 @@ void ocfs2_truncate_log_shutdown(struct ocfs2_super *osb)
 	}
 }
 
+void ocfs2_bh_valid(struct buffer_head *bh)
+{
+	struct ocfs2_dinode *di;
+	struct ocfs2_truncate_log *tl;
+
+	if (IS_ERR_OR_NULL(bh))
+		return;
+
+	di = (struct ocfs2_dinode *) bh->b_data;
+	tl = &di->id2.i_dealloc;
+
+	if (tl->tl_used > tl->tl_count) {
+		mlog(ML_NOTICE, "tl_used [%d] is greater than tl_count [%d], "
+		     "set it to tl_count.\n", le16_to_cpu(tl->tl_used),
+		     le16_to_cpu(tl->tl_count));
+		tl->tl_used = cpu_to_le16(tl->tl_count);
+	}
+}
+
 int ocfs2_truncate_log_init(struct ocfs2_super *osb)
 {
 	int status;
@@ -6339,6 +6358,8 @@ int ocfs2_truncate_log_init(struct ocfs2_super *osb)
 	if (status < 0)
 		mlog_errno(status);
 
+	ocfs2_bh_valid(tl_bh);
+
 	/* ocfs2_truncate_log_shutdown keys on the existence of
 	 * osb->osb_tl_inode so we don't set any of the osb variables
 	 * until we're sure all is well. */
