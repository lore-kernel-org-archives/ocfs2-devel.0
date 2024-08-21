Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98341166305
	for <ocfs2-devel@lists.linux.dev>; Wed, 21 Aug 2024 05:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724219771; cv=none; b=N8vfPUepTHra13ofHnet9O0FPzbCFWwF0inSlVzRd6YXS3fFytApNR19hACoKJz/1kW/WNRvMx0cteJNn7WepH5fduF3ODDeH+YONo0sfnEhR5ljMwnVFkFaTvNqDZpNCpGn4p9ZfVVGOiDOpZJDYxLFh/jLuwclMyl8b3adLj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724219771; c=relaxed/simple;
	bh=+CiLoA34CL/5DFr3zuoJbYKrVfAZhVKXtMf9USEuRz4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IF3DKcURouvM9kztycQknERFFC9gEyw1M9AoKTxJWgWfqOCO0ArMpP53wPnvk6LzXxomBa0ltMVrYiYZ3l16rhpdtUF6q+EDG2xT3/ZzM6aRuc3Zc+2cbMo+SvBiqOsdWHSVjlyK6t8dbCsY5BNu+XsQ9LaPodUjtOSHW/NmlgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47L5sNHA026656;
	Tue, 20 Aug 2024 22:55:50 -0700
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 412q543kjw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 20 Aug 2024 22:55:49 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 22:55:49 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Tue, 20 Aug 2024 22:55:47 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <heming.zhao@suse.com>
CC: <jlbec@evilplan.org>, <joseph.qi@linux.alibaba.com>,
        <linux-kernel@vger.kernel.org>, <lizhi.xu@windriver.com>,
        <mark@fasheh.com>, <ocfs2-devel@lists.linux.dev>,
        <syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com>,
        <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH V3 2/2] ocfs2: Fix uaf in ocfs2_set_buffer_uptodate
Date: Wed, 21 Aug 2024 13:55:46 +0800
Message-ID: <20240821055546.3254888-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <7d0d7bbc-6265-4f60-ba2c-a9c15771e95e@suse.com>
References: <7d0d7bbc-6265-4f60-ba2c-a9c15771e95e@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: ljy-7_17P4RvQQZO0ONoadsUkDXj0e9b
X-Proofpoint-ORIG-GUID: ljy-7_17P4RvQQZO0ONoadsUkDXj0e9b
X-Authority-Analysis: v=2.4 cv=b+3g4cGx c=1 sm=1 tr=0 ts=66c58166 cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=yoJbH4e0A30A:10 a=C9ecxsx6l8i5rYL_O6gA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-21_06,2024-08-19_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 phishscore=0 mlxlogscore=682 lowpriorityscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.21.0-2407110000 definitions=main-2408210041

On Wed, 21 Aug 2024 10:39:39 +0800, Heming Zhao wrote:
> > And this is not a UAF case, but NULL pointer dereference.
> > So I suggest change the subject to:
> > ocfs2: fix possible NULL pointer dereference in ocfs2_set_buffer_uptodate
> 
> I agree with above too.
> I didn't care about the patch subject in previous review jobs, 'UAF' is not suitable.
> 
> -Heming
OK, I will update and send this patch V4 separately.

Lizhi
