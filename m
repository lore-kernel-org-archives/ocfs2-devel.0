Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F237AEB64DD
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 14:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mhtiZlaZZogItZq1GwRHsxOJXJFEhhFb+caz1rSIk/g=;
 b=1erDZLZ9TWG7e1ywR0gBY8OYyJK+uik5k57jYC9f8QMH6f6NzQ8h58IPoiSPQezYw4xEhEAjDuvd
   +LId9unC9BN0fm9x6/NP9xHtaZ8aKY11cqUnY0b9ZVSzGTdsU67+65mtAQ2U4PWQOtopyTAg31ez
   cmx3zAO0lYByPICSnQjcPTYvPvOq8G2IxFxusEoXQwl9W53Hp5HA9m2y/ep8EAgBD+dFVhZPDLkn
   1YzVzqJW6VKSGnJIB+UxB89fnf/NUg7q3wcJPdr0R7awoA5sjUA4IeqsyNyuwXRIBxIccijIouWh
   BfKkS9ov37rA9MoXTR6Jab8yCftruZnnKBtzBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mhtiZlaZZogItZq1GwRHsxOJXJFEhhFb+caz1rSIk/g=;
 b=Z0p8V82Cp+Hnhzr/OC0u5MbVbiatKEGwGxIJ1UJ+AzsO0Qx/Fx1P65Ha8MPTvwzrsq6ryg9xzuQI
   sv+b/6IO6wvjhB0SObv/cgqcFagVvnnzQGqW46lx7H8gnIhiXD2I1FS64DJWXQBytMKx9QRG/OBh
   PLB1vRbpSwE7+mnqk9bd2dKhA2o9pUG5dmejsYt84w6u3yXBtDou4qpnydXmtFtYCc6+Njih5iKP
   mAj3co+o7/LqqH2dRnQBUv+F9YoBOC66BmGAGX900N2Tn6Owp9ioDryHOf2BdEtPTvrDfbkcKEhD
   9l667dqe5e9ZGsuqrtHEsjNY8j8fnXrILgOM8g==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWK0049945YPU10@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 14:56:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; t=1687123987; cv=none; d=strato.com;
 s=strato-dkim-0002;
 b=pLEHJ/bKY0zR7WfVem2YJX11hI5zcyydSYNrxDhLqLUbG2eh5hktn73AF1yxlwqMpY
 g/ARQjKIM9Lry5xsVby9JTIq4HbhPhyyh2bBtLKJYbUt/CvLVCe7zNdGaWF/TSkISzOw
 HqDwsUuBXDn4ahcCZqQ576hepzZRQYD6feXBbkVO49mZBNZti/lxcGjBC9YPT/4v/D3B
 9GSsOc7VPjYQ7dgyWlukJCLLh++tza2j5IrxgDhrqq+7g86Av4rkvHpsko32TxJ3WclB
 4CSTeJw7QSK6fgZs6bh/rfV5idezwMvQ/semvtQtCs+dp0eAOHYbnMW1JSbpoAJmHA3f /9eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1687123987;
 s=strato-dkim-0002; d=strato.com;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=ByE+GUzwLDG5usz6jIof8CLTzZ6sYXPxh+V91S3i84U=;
 b=W8l2heUn/qa9X6uxx9qZLX8bsfkjD1TyNpx7NIlB8Gnmr90fhd4c1Sl6boZCyjfeR5
 kAD8fr51l2ZvCr2g/uxT6XHmnbgB3TmwkHbzh3fgtHvp23vz23ySCVm7VIQYYVJKll36
 ZPKytI+0d0mwhlUcX9UOWBJGM+cTUiSOGAfoLprazJMlzQS3JwnpcFdrfC1R+Fxdsjsu
 gbjhn+oXinSlWJngIq2ITgzVZh+2VWPCdw/nPgnQOQ6fto20AuNtXnZmxtJ4cmFtULXH
 x9l+aryDOaA6fKejukojxwupuNGDUw/3dUQx4NC52LyQ8DmwwBSQjiLGrGjYGszvY32r naNg==
ARC-Authentication-results: i=1; strato.com;    arc=none;    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1687123987;
 s=strato-dkim-0002; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=ByE+GUzwLDG5usz6jIof8CLTzZ6sYXPxh+V91S3i84U=;
 b=I/Sam9ubiVNWnsYHM4Uz6c4kDnTzvMysr+UiOj6HJZIkBo+wMoVNH5A/vTf9eYMLoM
 13Mqc3UasIbqYpxQ+iuJDkoHvWuKaCy0y765bFXo7cts4FPXEcLIDlATt/O8AVvvtm8+
 4xASk8jV2skvOTGJ2/FFH2MaYWmXGMEcFImuOAuyYx3jitdFoFSXc2V5sYsINEFltzg+
 yK3Y14rSsN27mg1HG9aL/iUKcsMD/mNqMY+hWDgz81uxsoxYA/m2FKrk2te4DzI+WWfg
 3wtLLUgMcIm1W8pxknPaTRJuaDh5P3T9liRplpwq5UN947Fi6Js8ewuAdNdXmYRPKUki GF7Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1687123987;
 s=strato-dkim-0003; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=ByE+GUzwLDG5usz6jIof8CLTzZ6sYXPxh+V91S3i84U=;
 b=R2J1VAchfVBP7IiVOUW+S6F/wiHWLIMM2xxuk2gf6Ug7a0Z5LFWJyXUGOKBW+C16Xy
 pE9ZAu31RN7r+LTMBFCA==
To: viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 jack@suse.cz, jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Date: Sun, 18 Jun 2023 23:32:49 +0200
Message-id: <20230618213250.694110-5-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20230618213250.694110-1-beanhuo@iokpp.de>
References: <20230618213250.694110-1-beanhuo@iokpp.de>
MIME-version: 1.0
X-Source-IP: 81.169.146.170
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10745
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=791
 priorityscore=0 unknownsenderscore=20 impostorscore=0 mlxscore=0 clxscore=93
 spamscore=0 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2306180205
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, beanhuo@micron.com
Subject: [Ocfs2-devel] [PATCH v1 4/5] fs/ocfs2: No need to check return	value
 of block_commit_write()
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
From: Bean Huo via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Bean Huo <beanhuo@iokpp.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-RZG-CLASS-ID: mo02
X-RZG-AUTH:
 ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1EQ33bneoxgmq5ARfEwes1hW/CxwfjqKzP/cKnUXGNs35zouFQhI="
X-ServerName: mo4-p02-ob.smtp.rzone.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: YMmwQKdkBiG6_CiJoYgH-LeP8oxoWEmQ
X-Proofpoint-ORIG-GUID: YMmwQKdkBiG6_CiJoYgH-LeP8oxoWEmQ
X-Mailman-Approved-At: Tue, 20 Jun 2023 14:56:20 +0000
Reporting-Meta:
 AAGSxUH9GD/DCbzHVSj7tRC9ZXJx59aRcMe/JuZEkCI+Muyw6Tx9q68Fo8dYYN1a
 061jmYKqH0289pjhOtZwUTTaZhuRSEHvyoc5efniwlqbAuyvYZA+R2IQN+cOEUPO
 AahDBv2rs65H5wrM4vKYMvxOfgPhalph+rWMifHWpgPbnNjRqIWBZBU0HOWHBxlY
 OCCPbgNOhtBsbShhM9AYSRncJivvEOJQejgL1siXmwwQrzgxTtFOODSXD6YqRMz7
 RrDV98k5WASA1r/u724OHlEjxBQfhnU8A8lAoCq6E9ocBeB/MmeYpORbC+2gxjoc
 Pa2hs3yi60XWVPUcyheVZ+t9NGlKck8Alp2dsOisR5qmAkvotCYKj7Aj+F09ucRz
 DiqoJzt5EoFB9uD2IAeROgd+VB5sjBOLCtG0AyUBDl1eKZN1K0lMxuG+hJUQmJpS
 eJEpL/Zsssx8zz8ZfZo27SOCXIrpddN3AgURKzfYnJJuwKGyF47iuZaUdVuUXKC1
 72M2DabzISIKGQeDcUutLRC4rA17x+lsOUluIpUU4mdX

From: Bean Huo <beanhuo@micron.com>

Remove unnecessary check on the return value of block_commit_write().

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 fs/ocfs2/file.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index efb09de4343d..39d8dbb26bb3 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -808,12 +808,7 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
 
 
 		/* must not update i_size! */
-		ret = block_commit_write(page, block_start + 1,
-					 block_start + 1);
-		if (ret < 0)
-			mlog_errno(ret);
-		else
-			ret = 0;
+		block_commit_write(page, block_start + 1, block_start + 1);
 	}
 
 	/*
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
