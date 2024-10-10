Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11D51925A2
	for <ocfs2-devel@lists.linux.dev>; Thu, 10 Oct 2024 04:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728533339; cv=none; b=B35pGZJxQ1/dwMzUnizrz+xPQmuoQhyvXv5nLcWNdeZBWFFQSNDZLGWDByo9ET31CA4UGs1WN7tOhTdMyBMKA2aW8ZAm5/eVF0Xv9afTWu+Bl8WhHK8+W8P6NC7Cr2GUNwhI095pmLre4IPbOnaVXNy3wR/0ivhG50URSCIoQP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728533339; c=relaxed/simple;
	bh=N+pyFf78H/AqcS+gzEpmdQub5nK33PwlUOdXF1CpalM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j5+YndOati45Oo+Z1AUpsbEIdszt4f4P6HmCkhr4qZg78XblLYCHf25hInUH7VH/yvpbFZc3zRNbV71uROybGc75a65hhetoR96G0DlIGy8MYBO1DZfnA9CdHSGC8JlT9XJ+gu+xUYJYDA1eqVhGvwwX+eI2JqjdSUUGRgDtAT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49A3jCgM012573;
	Thu, 10 Oct 2024 04:08:39 GMT
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 422tp45b1y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 10 Oct 2024 04:08:39 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 9 Oct 2024 21:08:38 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Wed, 9 Oct 2024 21:08:36 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <syzbot+66c146268dc88f4341fd@syzkaller.appspotmail.com>
CC: <jlbec@evilplan.org>, <joseph.qi@linux.alibaba.com>,
        <linux-kernel@vger.kernel.org>, <mark@fasheh.com>,
        <ocfs2-devel@lists.linux.dev>, <syzkaller-bugs@googlegroups.com>
Subject: Re: [ocfs2?] KASAN: use-after-free Read in __ocfs2_find_path
Date: Thu, 10 Oct 2024 12:08:35 +0800
Message-ID: <20241010040835.1648107-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6706e8cd.050a0220.67064.0053.GAE@google.com>
References: <6706e8cd.050a0220.67064.0053.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=XPtiShhE c=1 sm=1 tr=0 ts=67075347 cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=DAUX931o1VcA:10 a=2ZFrcfy9enmZ0iwdtswA:9
X-Proofpoint-ORIG-GUID: 5S04E4MbfOFA_rkQYAifu3mSzYrn9a2E
X-Proofpoint-GUID: 5S04E4MbfOFA_rkQYAifu3mSzYrn9a2E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-09_23,2024-10-09_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=671 malwarescore=0
 suspectscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1011 classifier=spam authscore=0 adjust=0 reason=mlx scancount=1
 engine=8.21.0-2409260000 definitions=main-2410100026

Extent tree depth is never bigger than 256, because the high 8 bits cannot be used.

#syz test

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index f7672472fa82..2ca546af9191 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -415,6 +415,15 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 	tree_height = le16_to_cpu(el->l_tree_depth);
 
 	if (tree_height > 0) {
+		if (tree_height > 256) {
+			ocfs2_error(inode->i_sb,
+				    "Inode %lu has too big tree depth %d in leaf block %llu\n",
+				    inode->i_ino,
+				    tree_height,
+				    (unsigned long long)di_bh->b_blocknr);
+			ret = -EROFS;
+			goto out;
+		}
 		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, v_cluster,
 				      &eb_bh);
 		if (ret) {
