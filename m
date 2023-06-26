Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96D76EB64D7
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jun 2023 05:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=gK4ArPCiLUKRgOEGrDu84q8pislsbTRDUCXF2Zgjs4I=;
 b=k+gRJRI7zFAD2KxtejKuaIurc2cat3Qp+qGNf1DMEgY//30PNEA66h4jpPQ999wKmrIoBRwyWU7e
   LfG7k8mxOKsrKWBCESinqOLkvAijllZeWj4Aa09h9ElyWefQrg6Xa4GPFQ9zqOJNE9JOvfO8I/va
   XsnJpws94wRy2gvOhPMSlOZ4n2vHlVx9Ya+RdCmCM28YDzyBFldnuYt3BTwoPwoZz6JXo4THwnYr
   Ax3addQe9+Nv3UOx7oQzS4RhqKvmt62OmiFtyNxH6Rl7Xw7N5PCDKFaGmT7MOYMDzoxYSiCDmfon
   1IaYlwMdIxMV+Jw/TxG268Su6aT31dIJeUgrRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=gK4ArPCiLUKRgOEGrDu84q8pislsbTRDUCXF2Zgjs4I=;
 b=id/3oIj2MvDdQxv8lTPjmGbw0WtB2cPHh7nrv9KMLkat0H3YTppHA7/+woAJy3aQc5EJs0DIJW0q
   iqCzzNUN/kK4ElHFYlegT7rIhZ6mL64KOgoyzTvnQWgXTJtl1LukHtWFnaP7Z6RCDEeQ1MId9RbB
   QC/BZjqSxwEi+5mpN7m26TjPSP4N6rIq3FWaYnAeIRMxoLIS2KnNDxda7Qp0o2kChdwaNNOiPECB
   nCazJyR1+nOBX350dKM26COq5nju5V+89lZTcmv0hBsVz8zRirzwDwr0wdcr9Qpq+Vt46oQErlg7
   NIrmFbViHEF0bap5GL3rGlUboxYHdtlXsbxyGA==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWU00EYPIIT7510@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 26 Jun 2023 05:42:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; t=1687758123; cv=none; d=strato.com;
 s=strato-dkim-0002;
 b=BLsPKXmVGveNz1cWfRhdc45UhP+767VVGi141W8RVA4ZEZZP2JgAB7tkOyloadHPea
 0m8yVuCv2OM2Ww/pKkTRGeq5+h6R+6PtU9AlyZeLz7CSeofmO/tplJEPdE5jQFqK8zPr
 A2xHXfLEvKepgABVVft3avmi0JZwzM1dTSnXFqI0JgiOft/xbF5P5+U709b9gNebW8X4
 6Q2RtPXYx4ntxvsqHajtQBtDOrvb6IU//Ep5CLUlO85BnH1IeTqr/Eki+cElugzSE6Lj
 kvb7wqHdXV60ZjL5zS/x8J4jtFqaDk22YveWArqxNOIgQs92yJbmF6aYgg7XuqFbnDMs Tlkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1687758123;
 s=strato-dkim-0002; d=strato.com;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=mhoN52NrOJrJXRtOmObH8v06ZrNecZha/sBxCLu1zqg=;
 b=ZCsWMe2TXHMNkB9FaqP7W1Xr9DE2eQO0B3JLwm7wWM+OpaeyxV3s8fnwOVtU6U2znq
 sOZ97vbok1ZltiWjDNWwOwvX6gL7W+MS+oc6jmXNRnrh3f9aPeTL7sd3Dgi9VBlS8pGI
 mjBfWJTzszyhPSzT4nnQNtq73xv77mIzop6oAmjcUCO48LxQiSs4UU4Uw4M6d08ocKSv
 mjpA+gOcMbFedY+Z3FRwfbI2/NMyo3LtKRmlLN6N9FsbnLvQUTaIchVUSKe5uZ7+6Nh9
 6qaCupaSCFzFOajM87SnnUOejjWtLcFw52IflFKsJMDC4k5Fj70Vjl3QRn9V+hWTvf08 /BMw==
ARC-Authentication-results: i=1; strato.com;    arc=none;    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1687758123;
 s=strato-dkim-0002; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=mhoN52NrOJrJXRtOmObH8v06ZrNecZha/sBxCLu1zqg=;
 b=dn38vfl83FJAEJOE40CVxkpykk4kWCRRj+jGqEk4ue0L6B+wq4eRyadOJMt/7fuYgE
 Ebr4Z95t5+LdRzbdf2OThbZFWcPfDh5bbrdsK+uPwPEjY8zMuU2VvNTgMwXrCxyJAkOP
 dhZfYU+D5eKk07vPzSiJzrPf/sGSSj+6gL6c51Qx/mGXnhUm3EKn+gy2WYdtX37Pvnmo
 Hd6Od+VbbmxgcG3KQooJa8VG/k/OFxd7rCDSCLDysv3EeTU/QNOcoz+18yDb6jThitLc
 vX+8ASVpvg+5uzTA4/zW+Oxg6CzKjhuaNW7GSfznKVoyEPIEqoVk1bWIy6LynEphYsVb LSFw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1687758123;
 s=strato-dkim-0003; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=mhoN52NrOJrJXRtOmObH8v06ZrNecZha/sBxCLu1zqg=;
 b=7QCQPusEOW3XxIMInpXpKbXXPNiNqkdAG/j4EsA3IiOrCjdXQit8tl8J7yBwJznqtG
 TXhSJI8/Zw5kTNmmRyDA==
To: viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 jack@suse.cz, jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 willy@infradead.org, hch@infradead.org
Date: Mon, 26 Jun 2023 07:41:52 +0200
Message-id: <20230626054153.839672-2-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20230626054153.839672-1-beanhuo@iokpp.de>
References: <20230626054153.839672-1-beanhuo@iokpp.de>
MIME-version: 1.0
X-Source-IP: 85.215.255.81
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10752
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0 unknownsenderscore=20
 spamscore=0 mlxlogscore=837 clxscore=138 phishscore=0 bulkscore=0
 priorityscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2306260050
Cc: linux-kernel@vger.kernel.org, Bean Huo <beanhuo@iokpp.de>,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, beanhuo@micron.com
Subject: [Ocfs2-devel] [PATCH v3 1/2] fs/buffer: clean up block_commit_write
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
 ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1QLj68UeUr1+U1RrW5o+P9bSFaHg+gZu+uCjL2b+VQTRnVQrIOQ=="
X-ServerName: mo4-p02-ob.smtp.rzone.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: h_yeqvxDxMDSkyjfSfJ55t5NHrTVhR-t
X-Proofpoint-GUID: h_yeqvxDxMDSkyjfSfJ55t5NHrTVhR-t
Reporting-Meta:
 AAHusnVEcCYRqZBDB6zw2au+lA7GhboNNgpwJOWVxElSHY89ItQmE/Br175MFzRv
 +X7IJkiR5AnE+9hnihEEZ/m6uwE1Ufwlwko54l28YUxzQt7rF8SkyLlgCwpewMiX
 +8JM0Mcc2YEJAItdnXv6f2clREtS7oiEHlMKA9OoAr4mOUMpgnnVdZRCZP0n2q4g
 T1FZfErhn7l47sV7WEAlNLAJzqmae+CY1jZZdr7pChrlfaVDPFM0SF0v9hA2HJcr
 krQ0SeqloIcOCx3PEQb2MMD1l5zbEnlRP8G8LFb13zt42fI1+eWOqpwvwveAF0ZQ
 QYssSEmX6eCr1CW+K4mZABnTN5dd+CWPRs8QParX0/WtdONEf58GouUYfpHlypyu
 js5idcMDPbC0TDJJM0A9pZuS+LXw/FxsPetFo9FKOsYjkRGNiT5RV1a2yphlAenZ
 ZvUbSKU0VdeSM4bRWrgMbmbxxS6s68J8Hj/TSbVaZgw01xxQrE+UcC8HazPrW5jz
 bbIk2KWRVaHfTdblg/wwU1Kc2Ex9OpTgN50OXl1eW5fV

From: Bean Huo <beanhuo@micron.com>

From: Bean Huo <beanhuo@iokpp.de>

Originally inode is used to get blksize, after commit 45bce8f3e343
("fs/buffer.c: make block-size be per-page and protected by the page lock"),
__block_commit_write no longer uses this parameter inode.

Signed-off-by: Bean Huo <beanhuo@iokpp.de>
---
 fs/buffer.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index bd091329026c..50821dfb02f7 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2180,8 +2180,7 @@ int __block_write_begin(struct page *page, loff_t pos, unsigned len,
 }
 EXPORT_SYMBOL(__block_write_begin);
 
-static int __block_commit_write(struct inode *inode, struct folio *folio,
-		size_t from, size_t to)
+static int __block_commit_write(struct folio *folio, size_t from, size_t to)
 {
 	size_t block_start, block_end;
 	bool partial = false;
@@ -2277,7 +2276,7 @@ int block_write_end(struct file *file, struct address_space *mapping,
 	flush_dcache_folio(folio);
 
 	/* This could be a short (even 0-length) commit */
-	__block_commit_write(inode, folio, start, start + copied);
+	__block_commit_write(folio, start, start + copied);
 
 	return copied;
 }
@@ -2601,8 +2600,7 @@ EXPORT_SYMBOL(cont_write_begin);
 int block_commit_write(struct page *page, unsigned from, unsigned to)
 {
 	struct folio *folio = page_folio(page);
-	struct inode *inode = folio->mapping->host;
-	__block_commit_write(inode, folio, from, to);
+	__block_commit_write(folio, from, to);
 	return 0;
 }
 EXPORT_SYMBOL(block_commit_write);
@@ -2650,7 +2648,7 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 
 	ret = __block_write_begin_int(folio, 0, end, get_block, NULL);
 	if (!ret)
-		ret = __block_commit_write(inode, folio, 0, end);
+		ret = __block_commit_write(folio, 0, end);
 
 	if (unlikely(ret < 0))
 		goto out_unlock;
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
