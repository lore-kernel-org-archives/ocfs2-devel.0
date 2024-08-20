Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C149A18E35B
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 06:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724136932; cv=none; b=JHNemoOHz4LraI8kF5oHw5xRCuCVik6oAFUCf4ItOsq8RFv61rsD9VoM/q2HcQMh4/k51JPvMQMhJ+uJFdsjOnFCm065C89aokK95Y6nHh8HbaWbyYE+vt/ZCTtQF9lKebCVCDqkmxibdfR70E/GH33y7ffzvJcfuFt1AP3mosA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724136932; c=relaxed/simple;
	bh=/epsLOSw6T6gTNaMlIyU+2fJGj/i1Zw7b49vfGmzXWM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f3UEpk/hlWjDx+CDdEbNApeZYTLK0Jj5A1CQtXZQYTKCnfE4IebXleBTtsvpePyzcD4eevcBpjjBOvenagONkbx4hW+7AO0XVK+ggB0+1b/tL6Iwms5jHbj6EsTGieamOsOgbAO7ppva4vfk6IRKl478P5ZOSvQWGe1KbfY4CuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47K507An022758;
	Mon, 19 Aug 2024 23:55:17 -0700
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 412q542fek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 19 Aug 2024 23:55:17 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 19 Aug 2024 23:55:17 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Mon, 19 Aug 2024 23:55:14 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <heming.zhao@suse.com>
CC: <jlbec@evilplan.org>, <joseph.qi@linux.alibaba.com>,
        <linux-kernel@vger.kernel.org>, <lizhi.xu@windriver.com>,
        <mark@fasheh.com>, <ocfs2-devel@lists.linux.dev>,
        <syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com>,
        <syzkaller-bugs@googlegroups.com>
Subject: [PATCH V2 2/2] ocfs2: Fix uaf in ocfs2_read_blocks
Date: Tue, 20 Aug 2024 14:55:11 +0800
Message-ID: <20240820065511.996453-2-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240820065511.996453-1-lizhi.xu@windriver.com>
References: <2e662cb6-47d9-4bbd-855d-1f6d5edb8633@suse.com>
 <20240820065511.996453-1-lizhi.xu@windriver.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: S7OUX7iONbJWwIbwUXZhaqBIkdo7uacx
X-Proofpoint-ORIG-GUID: S7OUX7iONbJWwIbwUXZhaqBIkdo7uacx
X-Authority-Analysis: v=2.4 cv=b+3g4cGx c=1 sm=1 tr=0 ts=66c43dd5 cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=yoJbH4e0A30A:10 a=iox4zFpeAAAA:8 a=t7CeM3EgAAAA:8 a=9EmYBDHLg3qkdQoSP7EA:9 a=zZCYzV9kfG8A:10 a=WzC6qhA0u3u7Ye7llzcV:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-19_16,2024-08-19_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 phishscore=0 mlxlogscore=846 lowpriorityscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.21.0-2407110000 definitions=main-2408200050

In the for-loop after the 'read_failure' label, the condition
'(bh == NULL) && flags includes OCFS2_BH_READAHEAD' is missing.
When this contidion is true, this for-loop will call ocfs2_set_buffer
_uptodate(ci, bh), which then triggers a NULL pointer access error.

Reported-and-suggested-by: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
---
 fs/ocfs2/buffer_head_io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index e62c7e1de4eb..b4a76f45253d 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -384,6 +384,8 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 					goto read_failure;
 			}
 		}
+		if (!bh)
+			continue;
 
 		/* Always set the buffer in the cache, even if it was
 		 * a forced read, or read-ahead which hasn't yet
-- 
2.43.0

