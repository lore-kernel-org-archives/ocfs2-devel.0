Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5094C282FD
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 06:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724133656; cv=none; b=bEzefz0f4DNBEhElCIZspAkaCcSSq3sXgfwfibO/c7O5ZS1NuSmJSdRPElBuvh2YYJRAW4Zbqy4ThUTiPtlG8LlOZFsOjEhf001L8YEzqa3e10cYdPvm8p/+9LY4jO1XuqOhUZkn8HJIAL5x3JU/UxVEq0y5rjWW8Gh2j8V+lFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724133656; c=relaxed/simple;
	bh=o/tBuE7Q+e6uqNisyjOpuuITYMHcVkk6m6s43+NtjPc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K7qGUMOQW+6r69EZdixDueglJsuts3DF9zBDJcJfPZRujy8lQ1811gOgXQjkQnL1obVwb69uFu4NWc2SHIBJJn56pT8cXiciB4UG/6dHWUecEZCTqUdd0H2yN07ERzU/DO6CIb6aus46IrEaedeDIb0HF+72Vxztg+PYr9GXh3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47K4Uo1j024085;
	Mon, 19 Aug 2024 22:59:34 -0700
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 412uck29te-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 19 Aug 2024 22:59:33 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 19 Aug 2024 22:59:33 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Mon, 19 Aug 2024 22:59:29 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <heming.zhao@suse.com>
CC: <jlbec@evilplan.org>, <joseph.qi@linux.alibaba.com>,
        <linux-kernel@vger.kernel.org>, <lizhi.xu@windriver.com>,
        <mark@fasheh.com>, <ocfs2-devel@lists.linux.dev>,
        <syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com>,
        <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH] ocfs2: remove unreasonable unlock
Date: Tue, 20 Aug 2024 13:59:28 +0800
Message-ID: <20240820055928.580684-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <2e662cb6-47d9-4bbd-855d-1f6d5edb8633@suse.com>
References: <2e662cb6-47d9-4bbd-855d-1f6d5edb8633@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=SIcQV/vH c=1 sm=1 tr=0 ts=66c430c5 cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=yoJbH4e0A30A:10 a=hSkVLCK3AAAA:8 a=edf1wS77AAAA:8 a=t7CeM3EgAAAA:8 a=2y87MDzrW35xszVHdtEA:9 a=cQPPKAXgyycSBL8etih5:22
 a=DcSpbTIhAlouE1Uv7lRv:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: DyZfKKupH0sGRjg3OoD3SvRfuiZus5Qh
X-Proofpoint-GUID: DyZfKKupH0sGRjg3OoD3SvRfuiZus5Qh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-19_16,2024-08-19_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=851 clxscore=1011 impostorscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 phishscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.21.0-2407110000 definitions=main-2408200044

On Tue, 20 Aug 2024 12:04:39 +0800, Heming wrote:
> > There was a lock release before exiting, so remove the unreasonable unlock.
> >
> > Reported-and-tested-by: syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=ab134185af9ef88dfed5
> > Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> > ---
> >   fs/ocfs2/buffer_head_io.c | 1 -
> >   1 file changed, 1 deletion(-)
> >
> > diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> > index cdb9b9bdea1f..e62c7e1de4eb 100644
> > --- a/fs/ocfs2/buffer_head_io.c
> > +++ b/fs/ocfs2/buffer_head_io.c
> > @@ -235,7 +235,6 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
> >   		if (bhs[i] == NULL) {
> >   			bhs[i] = sb_getblk(sb, block++);
> >   			if (bhs[i] == NULL) {
> > -				ocfs2_metadata_cache_io_unlock(ci);
> >   				status = -ENOMEM;
> >   				mlog_errno(status);
> >   				/* Don't forget to put previous bh! */
> 
> The fix looks good to me. However, I found another issue in this function.
> 
> In the for-loop after the 'read_failure' label, the condition
> '(bh == NULL) && flags includes OCFS2_BH_READAHEAD' is missing.
> When this contidion is true, this for-loop will call ocfs2_set_buffer_uptodate(ci, bh),
> which then triggers a NULL pointer access error.
> 
> If you agree with my analysis, please add the new fix and send a v2 patch.
I agree with your analysis conclusion, but this is not the same issue
as the current one, so I will split it into two patches. 
The first patch fixes the unbalanced lock issue, and the second patch will
be used to fix the UAF problem of BH.

BR,
Lizhi
