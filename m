Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648F8233D6B
	for <ocfs2-devel@lists.linux.dev>; Fri,  8 Nov 2024 19:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731094115; cv=none; b=lTQ9u6c9dgP7HyC/3L+0n+rWq4V0Jn6zmG0cLp2Q/yOoVReM7UgjRB3uMRgbY+Es6G9jN+pzg+gc7Yt9N23FxTOg/+bTfo+oeGLZE0mIQwIZGdUB5HirxvCQgww1hBLA/C46gSQ0GYepvv17huncwoVF9qg7jvptMILf2DhMqRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731094115; c=relaxed/simple;
	bh=H1/Q8Q69sRhszF0sFk6w6nbRMiCcEK1Z2wEQSZLWGMo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mMXCyHoHsdTLu7zz+I275z+ufujal/4OkiP8Z9NvrwF7zZbPmTW8fWntczo7RDN7v2ozQab7uY9627R7eTIfc1uEjmDwkIJ5IbY3Kude43AOVwQP31/9MwdwhiY1egMAfPn3BvjO/6qijx1n3Rz00lq6TDJmnKHHD3PE67nwdes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J9awpJzQ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J9awpJzQ"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A8Fu1lC031684
	for <ocfs2-devel@lists.linux.dev>; Fri, 8 Nov 2024 19:28:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=YuHR9lUgPIlCtRdRT2iafBl5fb0qE
	Xp+JUameDlIn3Y=; b=J9awpJzQFkR6JrRufv1tkbAYV/+DGhTk3zifO3tCKPmXZ
	Xcnop2IxgwTYHM2phppQZPoGj+3QC1UzXz7l4TR+C5YVwSECJtotmWqUyqg1UwbU
	X+TihYfmxAq1wd7b/Nfhb9xPOAZzCF1EnLGXf8BnnNVsaV57Oj1KFLUce1Yi9NaC
	7uuqx2FKAbD9y26MrYexfoXJjIFDufrgWwHo8n8VNDK89kjudMwyhSGhi8ofDDGM
	oHDSyURsWJhrZJrHVqCEtOt9Vi0g/Mu6eF9oTheRN8rhYhUOsOxZtO++tHtPoAxL
	Wqi+glXK0eGbx1vXslLJSZ5Ac2/5Y9BWxKRjhv/8g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42s6jx29ms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@lists.linux.dev>; Fri, 08 Nov 2024 19:28:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A8Iu99a028672
	for <ocfs2-devel@lists.linux.dev>; Fri, 8 Nov 2024 19:28:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42nahbsspy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@lists.linux.dev>; Fri, 08 Nov 2024 19:28:31 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A8JSUh0026104
	for <ocfs2-devel@lists.linux.dev>; Fri, 8 Nov 2024 19:28:30 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-65-131-171.vpn.oracle.com [10.65.131.171])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 42nahbsspm-1;
	Fri, 08 Nov 2024 19:28:30 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: ocfs2-devel@lists.linux.dev
Cc: wen.gang.wang@oracle.com
Subject: [PATCH] ocfs2: update seq_file index in ocfs2_dlm_seq_next
Date: Fri,  8 Nov 2024 11:28:29 -0800
Message-Id: <20241108192829.58813-1-wen.gang.wang@oracle.com>
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
 definitions=2024-11-08_17,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411080161
X-Proofpoint-GUID: gp-HjAWak60D_fwyOpN2-e94tLzczq84
X-Proofpoint-ORIG-GUID: gp-HjAWak60D_fwyOpN2-e94tLzczq84

The following INFO level message was seen:

seq_file: buggy .next function ocfs2_dlm_seq_next [ocfs2] did not
update position index

Fix:
Updata m->index to make seq_read_iter happy though the index its self makes
no sense to ocfs2_dlm_seq_next.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlmglue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 60df52e4c1f8..349d131369cf 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3120,6 +3120,7 @@ static void *ocfs2_dlm_seq_next(struct seq_file *m, void *v, loff_t *pos)
 	}
 	spin_unlock(&ocfs2_dlm_tracking_lock);
 
+	m->index++;
 	return iter;
 }
 
-- 
2.39.5 (Apple Git-154)

