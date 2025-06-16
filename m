Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8440360
	for <ocfs2-devel@lists.linux.dev>; Mon, 16 Jun 2025 01:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750037530; cv=none; b=iatcdWXbb9jBoNTJRVuAGXUHJFKGxNmD4L5UvASNq2XQNRNM1yW8h8X5m9sFw6kf4QZN41vtse1RjfL41ULQWtd+uUQE4Ols6wiLM61hmqmAeYlHWAkzNDQ5SzSkEPf8sHwEjc4+Yj8q0D6iuaWMrxCwMNhyyGW+Tsf6GdoAWiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750037530; c=relaxed/simple;
	bh=VSafLg20ijrLrjjSIN/9RD2FHjGJsFhkBCHmI+gvDPU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tqqv/Ckb8GtZFVHIC28oYAlkxNGen1SbCO47Kf4f+o94o84Dw6o8jaxBPlq1yT/FDq375Eb5sChotteRq9NqbgjHuCnFoU5TUDOVwpRf0k+fEolSCtE/rgyBbQ9JH98rFguWOfQnAofwN+Lrs3ph1/pWHVB8JrYfkLvOZpjTQi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55G1QftV017685;
	Mon, 16 Jun 2025 01:31:45 GMT
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4790281ag1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 16 Jun 2025 01:31:44 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Sun, 15 Jun 2025 18:31:43 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.57 via Frontend Transport; Sun, 15 Jun 2025 18:31:41 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <syzbot+c2ea94ae47cd7e3881ec@syzkaller.appspotmail.com>
CC: <jlbec@evilplan.org>, <joseph.qi@linux.alibaba.com>,
        <linux-kernel@vger.kernel.org>, <mark@fasheh.com>,
        <ocfs2-devel@lists.linux.dev>, <syzkaller-bugs@googlegroups.com>
Subject: [PATCH] ocfs2: reset folio to NULL when get folio fails
Date: Mon, 16 Jun 2025 09:31:40 +0800
Message-ID: <20250616013140.3602219-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <684efdcd.050a0220.be214.02c1.GAE@google.com>
References: <684efdcd.050a0220.be214.02c1.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE2MDAwOSBTYWx0ZWRfX3DYRoYSkBAM8 nZAjbVYaiMkoTLbY8oRQkQoF6CbBbwa/yj/khCl83stPKD4II5F9zuXjjwZHS4PhtK0LmXEYdP9 BcnfJwF81/6F+uwyU2Kh+DPYo7+uJMzQWCcKYGRPA2YR+0C1KaupmNi1Xyv5tb7+LD4bZgyp2Fx
 i8qYTxhlhYmogh/TgT+hxYeeZea+9BpPBfmr+aFgEIFVf41rxfp+L2MHfC0uoWOx1kd16dkKarN 2gdd5IVtS6jHdTJVQoidNzEMHmXc4/fgsKnHKIC59tFxEcXiyyh5T9WxcPlV8tVdcyu97Rm7bxI hg49A2UPIs3As/0w097oeQlfYCEtwvQw8hTxZO9kXrMyGHLJwts3kIs9sNwzYJBfGikaUxw5asb
 ntTKxiktAp+6xgI+e01k3ii4iOo6raLkZBEGDOKpRLSER7orqZFCUBx20OhFEGxECTlaw9sj
X-Proofpoint-GUID: DMiliXBUZePCpmRx072qLsN4UuLpnDAE
X-Authority-Analysis: v=2.4 cv=ar2yCTZV c=1 sm=1 tr=0 ts=684f7400 cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=6IFa9wvqVegA:10 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8 a=VIXK_nqSdHjJPRK1elYA:9 a=DcSpbTIhAlouE1Uv7lRv:22
 a=cQPPKAXgyycSBL8etih5:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: DMiliXBUZePCpmRx072qLsN4UuLpnDAE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-15_10,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 impostorscore=0 clxscore=1011 bulkscore=0
 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.21.0-2505280000
 definitions=main-2506160009

The reproducer uses FAULT_INJECTION to make memory allocation fail, which
causes __filemap_get_folio() to fail, when initializing w_folios[i] in
ocfs2_grab_folios_for_write(), it only returns an error code and the value
of w_folios[i] is the error code, which causes ocfs2_unlock_and_free_folios()
to recycle the invalid w_folios[i] when releasing folios.

Reported-by: syzbot+c2ea94ae47cd7e3881ec@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c2ea94ae47cd7e3881ec
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
---
 fs/ocfs2/aops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 40b6bce12951..89aadc6cdd87 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1071,6 +1071,7 @@ static int ocfs2_grab_folios_for_write(struct address_space *mapping,
 			if (IS_ERR(wc->w_folios[i])) {
 				ret = PTR_ERR(wc->w_folios[i]);
 				mlog_errno(ret);
+				wc->w_folios[i] = NULL;
 				goto out;
 			}
 		}
-- 
2.43.0

