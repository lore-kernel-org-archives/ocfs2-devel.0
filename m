Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90060193426
	for <ocfs2-devel@lists.linux.dev>; Wed, 21 Aug 2024 06:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724223337; cv=none; b=khH3Qu3/bZfIHyt5wnHfJzL1lbi+k1crXPnaW8SMTTW7nqKNsldZxxQXwVrihjVMC9WLj+N6sy59XrtTZkNPr/kSSxy7NhRlQwrbBkJEHjI88/5f3ltQm1WQWX6e2KU7V0/HOQ/uHzEPqJ+ifkPWXvv4o1RmjZsPSN1zBgJ2rKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724223337; c=relaxed/simple;
	bh=DRsyjL07w6v2g4NFSwNfou54Af18/pM08M9a2CC3nfg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bRxWdeX8G5OMY4wdeVEBJO+O0FS+OO1Y4OdAPf4yCVGj4R0Nszq/DuWlzCYg3rSmCCK4qx1/+wXG3gYqJRB1XIFZCmQPTygBRf53xn+/6a87dPAZaBdqxkWuF5YyThja6+ktom8E750vYJb4XiEz3oZDvD9HLO264mvUml4zBGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47L4OTKb001709;
	Wed, 21 Aug 2024 06:55:22 GMT
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 412ju6utg8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 21 Aug 2024 06:55:21 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 23:55:20 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Tue, 20 Aug 2024 23:55:18 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <heming.zhao@suse.com>
CC: <jlbec@evilplan.org>, <joseph.qi@linux.alibaba.com>,
        <linux-kernel@vger.kernel.org>, <lizhi.xu@windriver.com>,
        <mark@fasheh.com>, <ocfs2-devel@lists.linux.dev>,
        <syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com>,
        <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH V4 2/2] ocfs2: Fix possible null-ptr-deref in ocfs2_set_buffer_uptodate
Date: Wed, 21 Aug 2024 14:55:17 +0800
Message-ID: <20240821065517.3844044-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <0dd1d1b4-5e83-449e-af48-3811abd2e6a4@suse.com>
References: <0dd1d1b4-5e83-449e-af48-3811abd2e6a4@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 6epE-8XzP66Y1CPRTuUZRVXcCA_PPSn4
X-Authority-Analysis: v=2.4 cv=VdWlP0p9 c=1 sm=1 tr=0 ts=66c58f59 cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=yoJbH4e0A30A:10 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=Kczxqsgznl8jAPX-KdsA:9 a=AjGcO6oz07-iQ99wixmX:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: 6epE-8XzP66Y1CPRTuUZRVXcCA_PPSn4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-21_07,2024-08-19_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 spamscore=0 malwarescore=0 impostorscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=761 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.21.0-2407110000 definitions=main-2408210049

On Wed, 21 Aug 2024 14:23:08 +0800, Heming Zhao wrote:
> Where is my "Reviewed-by" tag, and where is [patch 1/2]?
Sorry about your "Reviewed-by" tag, I remove it, if you don't mind, you can
add it by yourself.

In my previous email, I explicitly stated that only this patch should
be sent separately, as the first patch has already been reviewed by two
reviewers. If the second patch is updated with the first patch, I
personally think it is unnecessary.

[patch 1/2]: https://lore.kernel.org/all/20240820094512.2228159-1-lizhi.xu@windriver.com/ 

Lizhi
