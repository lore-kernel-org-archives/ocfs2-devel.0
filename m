Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CBF1E6187
	for <ocfs2-devel@lists.linux.dev>; Wed, 21 Aug 2024 09:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724231725; cv=none; b=UooRAerc3SjpWcN7GkNSqVZJTj6SOqk7CrL99zJgOfWmSTOOztnQf007qFNiQNIjWyQxFQs9j1uObmnciiYHkx2SCjvPlrb/IIxX8ANhTRn+ptK7SlMahGKnDMgKSvU/itKkmu3ToqQgwIhUxiWWBuclxsL3LSWPIL5v+Kk3ZcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724231725; c=relaxed/simple;
	bh=h4sR+Z0uQ3Nu8ylmSuNrlCa70NIXH8qFhIgnbMAO+Pg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ua3ZOFlbPk1FniR4/YQkDWoPUz2zFFgfanPV5qxNdDtpSKNAFLBwhq4apV+RTV5hrvyGwRVcbbItwERu317TN9M9/TkkjQckSwzY9IJi0JshvqavPhC5yXspZniHe9Ge9fbriXiPhAS1ssv9fIKl3EFYMXjWIrN22614qDNJKYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47L60Jk5019935;
	Wed, 21 Aug 2024 09:15:04 GMT
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 412j0xky18-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 21 Aug 2024 09:15:04 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 21 Aug 2024 02:15:02 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Wed, 21 Aug 2024 02:15:00 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <joseph.qi@linux.alibaba.com>
CC: <heming.zhao@suse.com>, <jlbec@evilplan.org>,
        <linux-kernel@vger.kernel.org>, <lizhi.xu@windriver.com>,
        <mark@fasheh.com>, <ocfs2-devel@lists.linux.dev>,
        <syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com>,
        <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH V4 2/2] ocfs2: Fix possible null-ptr-deref in ocfs2_set_buffer_uptodate
Date: Wed, 21 Aug 2024 17:14:59 +0800
Message-ID: <20240821091459.681136-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <1a063827-5cf3-42df-a690-f3c644c10996@linux.alibaba.com>
References: <1a063827-5cf3-42df-a690-f3c644c10996@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=PszBbBM3 c=1 sm=1 tr=0 ts=66c5b018 cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=yoJbH4e0A30A:10 a=iox4zFpeAAAA:8 a=9y8SH6q5Cau_Sw3l_tAA:9 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-ORIG-GUID: xX5jtSt2MlpqpSMLXuG_l2NYl7z5pkLW
X-Proofpoint-GUID: xX5jtSt2MlpqpSMLXuG_l2NYl7z5pkLW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-21_07,2024-08-19_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=613 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.21.0-2407110000 definitions=main-2408210067

On Wed, 21 Aug 2024 15:58:36 +0800, Joseph Qi wrote:
> On 8/21/24 3:37 PM, heming.zhao@suse.com wrote:
> > Hi,
> >
> > On 8/21/24 14:55, Lizhi Xu wrote:
> >> On Wed, 21 Aug 2024 14:23:08 +0800, Heming Zhao wrote:
> >>> Where is my "Reviewed-by" tag, and where is [patch 1/2]?
> >> Sorry about your "Reviewed-by" tag, I remove it, if you don't mind, you can
> >> add it by yourself.
> >
> > Good answer!
> >
> > This patch issue was found by me, and I also pointed out how to fix it, then take the time
> > to review your code. But in the end, you removed my "Reviewed-by" tag.
> >
> 
> Seems a misunderstanding, take it easy:)
> Lizhi may think since this is a new version, it needs a new round review.
Yeah, the subject and comments have all been changed.
Thank you for defending me:)

BR,
Lizhi
