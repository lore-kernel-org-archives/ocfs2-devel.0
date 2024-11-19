Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802BF1CF295
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 Nov 2024 17:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732038311; cv=none; b=lLMiIxwcjGu2j+odetB0n5GUaP+7S6ksYyNZA4DpJSTBzolyF5K0qMuDXRiQBq4fkRK/xdUjsNccgl81o/6/v14IfEFrh3aWaUX3VUkFPoyDNnSTRKTnXdxAfFFKbOEMQPQ+qcBvsyHwWFSs8HJQmcz90sViiWxr629wmMGsZ+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732038311; c=relaxed/simple;
	bh=vgpHjBNwWiCaKyeg537qyMNpRI/dOXDXllYwMtT98WI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DFaBAQTXSPDysvaWk3GVYJCGGW6M0Y1xSk45Lno2vDDp0Eq0b6Vse/v6Dl0GUN+3UDAXtzBwb+Hk4nooODG2tJ4YXSgWR0POGEx9Hdq/IbLsYZXqvNsHZqFoBpiqqqOzTf3682fQk93lu23xeNZUYmEmXBL3oDlgYLRU3mHWuHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N3Ty7jiF; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N3Ty7jiF"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJHBet2027679;
	Tue, 19 Nov 2024 17:45:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=ib8t/9DH3kIuYJXaAFRw5CAzaQPL6
	LNH+8oX/Vcdg/s=; b=N3Ty7jiF4HeRySlj5Go4r0B9YttyyFDnhl5EvuJWawz8m
	sRKnL6b0ZpOarf8xoFLz+zbxHJLLkbPRZVNDcc1AQ5YPZ+4qMvYaa52TZteBGOXQ
	0J2j9rN0qIsDKUtZ+AvrWj2oBCSSf/411kSYx/5n45/xY/txOn4QzQFtNZi9SlJ0
	pxy/WZ+KBqd3qg3qYWBcYCe3zsKSZbiPM9GUuNTVvsbH+6Z7tH7zhfjw15SQOEEZ
	TvGfiOwHVeayslQVTlni/sGhmCWVbyeuC367orhsHOw5wC4PeVfuU3w32sdJ5aow
	PN+3jl55QAw27hMrIBfcELhtehmoc/3kjPxo5WeFA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xjaa5kq1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Nov 2024 17:45:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJHCaV9007698;
	Tue, 19 Nov 2024 17:45:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42xhu8vbeg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Nov 2024 17:45:02 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4AJHgjg4037068;
	Tue, 19 Nov 2024 17:45:02 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-232-123.vpn.oracle.com [10.159.232.123])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42xhu8vbcp-1;
	Tue, 19 Nov 2024 17:45:02 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: ocfs2-devel@lists.linux.dev
Cc: wen.gang.wang@oracle.com, joseph.qi@linux.alibaba.com
Subject: [PATCH] ocfs2: update seq_file index in ocfs2_dlm_seq_next V2
Date: Tue, 19 Nov 2024 09:45:00 -0800
Message-Id: <20241119174500.9198-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-19_09,2024-11-18_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411190132
X-Proofpoint-ORIG-GUID: oAe_xil4M8i_8cB7EvqRrJPBrWVI5m86
X-Proofpoint-GUID: oAe_xil4M8i_8cB7EvqRrJPBrWVI5m86

The following INFO level message was seen:

seq_file: buggy .next function ocfs2_dlm_seq_next [ocfs2] did not
update position index

Fix:
Update *pos (so m->index) to make seq_read_iter happy though the index its
self makes no sense to ocfs2_dlm_seq_next.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlmglue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 60df52e4c1f8..764ecbd5ad41 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3110,6 +3110,7 @@ static void *ocfs2_dlm_seq_next(struct seq_file *m, void *v, loff_t *pos)
 	struct ocfs2_lock_res *iter = v;
 	struct ocfs2_lock_res *dummy = &priv->p_iter_res;
 
+	(*pos)++;
 	spin_lock(&ocfs2_dlm_tracking_lock);
 	iter = ocfs2_dlm_next_res(iter, priv);
 	list_del_init(&dummy->l_debug_list);
-- 
2.39.5 (Apple Git-154)

