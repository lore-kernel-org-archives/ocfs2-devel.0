Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A711DC43334
	for <ocfs2-devel@archiver.kernel.org>; Thu, 14 Jul 2022 15:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=GRwzQNSKJ2S7hfeXv4sBXOVJ0TcZaPNpquTka6yMTL8=;
 b=PkQCkmiPqEwL9DxlnKrY/cwrfZRzv/Gn9b7qvfpmOrlS4FdrLpiGgM42UWxD/+PVLXsVUo2t9gtN
   Kw0nq2ru7hijJJRNHKDGwLs5a5T6pLWEqBBdEYQP5bLN2Tzn3z4eUY0hiGIMg8kNc3qadKjnzEcS
   Y6vDNGw17lsFrgiG1N+l/56Bw2T5e+PSBbkPNOL96Tq/BOXA81Xl5hLBAvn9qd2jpTMRkxuwxRaV
   nmFTF4VaCSk/DirQBo2r87A0xouA4PhxUkfg8XljxK04EavX3zdp7DJohd73ppJ9Spx6wHonwkMw
   nQoHqDHhaYUxYKvce2GQUJpP4LWZqkq6C7wRFg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=GRwzQNSKJ2S7hfeXv4sBXOVJ0TcZaPNpquTka6yMTL8=;
 b=j7Ei9i2fMWCpQqI67ESBHCZw6MLrRAqXPQGsuAF/yUTeSxUM0q8hCUnjZFn86sx38X53S7IN8eZd
   jMxVfAPXiV56J4ERFLP1QCcv6Aq+mPmIJEna2zoSmtOf2vN++oGPwLIjik+YdgDzZebbW1ZqJcuK
   rGtpb41V+Rbgz2/PIXSBzb93OHXWN3XTeV2+r5l7l3p9YAV4vLKls93/XjzjFwkusbWghltsgeqv
   uc1ef2oMGfLUCQx/O8ZHMcy3PNSQ6hb3SI17GpLJpMMxQBbvjHWsACkb1wmE7Zk+o2uJrdxZLXyS
   bQ1enDjioCLtyj/FbJN6pybIaxwtEo/73PoGqw==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220603 64bit (built Jun  3
 2022))
 with ESMTPS id <0RF0002IQN9PFD00@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 14 Jul 2022 15:05:49 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=bjngWu2+fy+EhLHzFfowceaR1j/UA31xrrxHhRbbPPo=; b=eK7l6IZou/+UiLWuRhRJW2kUNF
 RpfKvThqfwsyR+cMUx8PBvIbgU01gZ0oWI9XpdINo2jgH3dSHI1lEPGQmlTEgoPYTMOYbr16595A3
 MFz2oVSMmjvNoyPs1BGlO4XvDNzM48KTWLf3Bq7fJFTwhw+/LCG88jGR8AtzHLYtERIhWYGenwnL/
 6CU15IsolJQgPTYsk278i56pFs5cTzgQETWdjwZTez1Gqm8nU+YCZmIAsZ63Vidzj/Gu7//ryo9h9
 9He+NBNWjW6V4elzAZic6h5Ntm+w7m8ATCSfAU2++U3Wc9+GDrzV9dI6n3kVsckgX5IOjbRGaLv3F
 fjyauc/Q==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 13 Jul 2022 07:53:16 +0200
Message-id: <20220713055317.1888500-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220713055317.1888500-1-hch@lst.de>
References: <20220713055317.1888500-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10406
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 malwarescore=0
 priorityscore=30 bulkscore=0 suspectscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=262 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207130024
Cc: linux-block@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>, linux-ext4@vger.kernel.org,
 Jack Wang <jinpu.wang@ionos.com>, ocfs2-devel@oss.oracle.com,
 drbd-dev@lists.linbit.com
Subject: [Ocfs2-devel] [PATCH 8/9] ext4: only initialize mmp_bdevname once
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@lst.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-ServerName: bombadil.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: ngij6J2mVMO7A1R7FspP0F7WN_VpEMlr
X-Proofpoint-ORIG-GUID: ngij6J2mVMO7A1R7FspP0F7WN_VpEMlr
Reporting-Meta:
 AAE92KhnYkrtn1tIl4h/wpNlo0cE+LLXfe7vfpR+76lb0uP/BPvPiYTwXBMv4HFA
 EzO+kTB+94/Al5N6H4nTVZUHXmgoEbJ4JwlnxL5vHsMepLA587mB9JJ7ryT88Vxp
 Hswvxx0xBMLvI/JzFLTdPU7zVNOFUqGSQ8QHGLOifCiWogjIoZDDfAcDPx2JC19l
 yxeh5/3Fbjpoxf4CcTaem6KnkuQ8Ey61PQtcGk+ydvxN0XVtwvCse2gVLvg+kpQQ
 Gnbm0/ttq8HmMt5y6lPrtiUykemHPHm8vwxE2/4ro67OLZoRSjZ3gvyGqt2xlidi
 r4xCtj3m8bqpFWrH0RxBcuRmDlbTn3jDRGkCikZ1BRgD+tgmhr8ym6Fsa/zavVOr
 NNKBJT1lUAruQ0vkcTIvHMURdD11OC/SgkQbUE5VjSYJduxwatG8sjDOFPRTvp0S
 euRtrNPGBSlAlA7CZ2d8SXVQdRtYuL66YtqXGTxIpRH0G7FtYL/PRPwLD9c9g4nt
 8sfVdXUQdMR0XSBaBij8uyZEOWBKkeM2KGl/4uUzoU29

mmp_bdevname is currently both initialized nested inside the kthread_run
call in ext4_multi_mount_protect and in the kmmpd thread started by it.

Lift the initiaization out of the kthread_run call in
ext4_multi_mount_protect, move the BUILD_BUG_ON next to it and remove
the duplicate assignment inside of kmmpd.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ext4/mmp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 79d05e464c432..b7a850b0070b8 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -150,8 +150,6 @@ static int kmmpd(void *data)
 	mmp_check_interval = max(EXT4_MMP_CHECK_MULT * mmp_update_interval,
 				 EXT4_MMP_MIN_CHECK_INTERVAL);
 	mmp->mmp_check_interval = cpu_to_le16(mmp_check_interval);
-	BUILD_BUG_ON(sizeof(mmp->mmp_bdevname) < BDEVNAME_SIZE);
-	bdevname(bh->b_bdev, mmp->mmp_bdevname);
 
 	memcpy(mmp->mmp_nodename, init_utsname()->nodename,
 	       sizeof(mmp->mmp_nodename));
@@ -372,13 +370,15 @@ int ext4_multi_mount_protect(struct super_block *sb,
 
 	EXT4_SB(sb)->s_mmp_bh = bh;
 
+	BUILD_BUG_ON(sizeof(mmp->mmp_bdevname) < BDEVNAME_SIZE);
+	bdevname(bh->b_bdev, mmp->mmp_bdevname);
+
 	/*
 	 * Start a kernel thread to update the MMP block periodically.
 	 */
 	EXT4_SB(sb)->s_mmp_tsk = kthread_run(kmmpd, sb, "kmmpd-%.*s",
 					     (int)sizeof(mmp->mmp_bdevname),
-					     bdevname(bh->b_bdev,
-						      mmp->mmp_bdevname));
+					     mmp->mmp_bdevname);
 	if (IS_ERR(EXT4_SB(sb)->s_mmp_tsk)) {
 		EXT4_SB(sb)->s_mmp_tsk = NULL;
 		ext4_warning(sb, "Unable to create kmmpd thread for %s.",
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
