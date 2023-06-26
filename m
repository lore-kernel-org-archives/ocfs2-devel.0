Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FDE6EB64DA
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jun 2023 05:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lQ97kuwp2Bsv4YAtFsOcHh0GuOK5qTBYnOV+BsU0uhE=;
 b=PPICHVe93fq/C588xdi+AOnkXVwFFlASr89F4ZchXoZc4KLQVU9UqBXi3fCwP38jESCEB4lwYacg
   RDvDvvqG20KwGztFGkAlLA8I5W7i3P0nx+ruCPUcLvT/ihj3tUFhY9LQhrLUsdv6V+KAyeiSajtD
   4BljCuEq4DoRW2j23Ah9Mgdeel+MrMS6DtIyW5Dj0iqpsUd/uWo41+RHiG/1dhS6Y4Etogj6eOoR
   YOC/I87eWL2DWmvt6Lu+/cxq7eIkTFKlIDbsXfxdiShTd1XzhhVJ1yUhxp437B2zdwpsXxqylOA1
   dJ6k3IwYjP7c0ACQr0z6CwEt6sC+Q0wKZfbHSw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lQ97kuwp2Bsv4YAtFsOcHh0GuOK5qTBYnOV+BsU0uhE=;
 b=ekKZ06r4a3bI2TfVp9Ynu0gWJtsMvRXheFVv0c8M3ebUwISbxZ6rtb96ZaoGtnNfWPF++IqRabO2
   UMJzo794A9NaWlwq9oIHaJzlzSZVyoOYZ7h60WHTDZwaGBFvAO6IkKd5g45OvufrOfe4ktjdYbu6
   Z22wcP27uTRuxQtTmrDxG4QWeW6H6yftB0N3pEbFhO10OBjuCfdSdnbaWsfOAv+ksgdNUShGgNTh
   6o6lnuT7r03vrbAwsjLAZBANL5Da+DlRiVK5TnTCTqL5WTjDRK5Mv5LrK6l9gngeTw/c0akBUSzK
   1rJpbMuQQsKK4TIqTGxa3/TagDCiN43FUk6kTQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWU003C1J51N380@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 26 Jun 2023 05:55:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; t=1687758928; cv=none; d=strato.com;
 s=strato-dkim-0002;
 b=EgqXIH866ELXGq+mpnR4Eo84d907wx4Op+QW5TGOxwRYybbzxwCaqR/QYoo2XHE3sO
 O8hxtrXLtTHIKU2ZSBQKVXcar1ffNhS9uaOvq5SZcIYgfq066kD30uakd8cgODyZMSWd
 Ux0ZFlR6CCQ7fQHYdrqA18kl3kkP5qKnhX5pWIrTDCffwGIJkgnmisTiasfVOc7XR/pz
 wrTKKyIlXdadrwbSTzMXh9GP84vS/ntzDyxuCnw6yI45EdbvJQ9Bvk4S/W3gikyM2yaj
 oNGWiiMM9bhmILZyjElRBDxqmMeAOJfrDumjbsZ8OHlkl86AV71G5hp7wxpDbgjWrruK l8iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1687758928;
 s=strato-dkim-0002; d=strato.com;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=9JeG8e5YLzIlPXpqO3TJNmd5ODQ+yL/DZJEHg5yXjTE=;
 b=nWoxz5+A/k/RoHG4mmlMrqdSxOOlepNMU8x2QAvJSBtskui+vKEENoLsTc3YTi0hA1
 rPHIzgcl4pBcyJ13X8nDzxUVYmQ4TdvR+y/1AfzGE/l0OBTrb46q2yed4ZXXAgoucuKo
 QttaxXBoGpAweZPDrnQLv1Q14b/XjIrZ7Mqf8Q55pfG3Zs9H8gAll+mZnlzmB4ew5Eif
 fZ3/sAh0WZcgWc9C4aMZ9WgR8FzY8czcPNOD9Rp4d61jOnSyCL3np43woSxh5VgFXtxz
 wQV6b1DDGhYPqdVJtF52We3PeLIZEjiFpGmNnnCw1ZbYrJTRrFt6wkB5cQkXeuyjHigx cJqQ==
ARC-Authentication-results: i=1; strato.com;    arc=none;    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1687758928;
 s=strato-dkim-0002; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=9JeG8e5YLzIlPXpqO3TJNmd5ODQ+yL/DZJEHg5yXjTE=;
 b=bhHuxVIF+VVHUfX01w2F4AvCX8xSsCAen9xIdGzxz7X79QsodQ+Qe5KOE7Z44hAggk
 1NyB5d6YbDMuDUBSN0ZrIKqN/yanGQHGKXLGer0DkdgWTqfUiGsQ9t6g4zRRCjp/sdS2
 6/c1M/z7gswtwjnPVuyRhdYI4CYQbWEnLrNJ8QxHEyoNDSCwiL26X1JJkpwUE8KcL7m0
 vcMwKFocz7beTTJC+PXYEG8reeORzxxr4uc2Gfy/KH7NwGjvCVbMPc7zIbl13rQd6Q+H
 xl/OEcL4fwFz7LyLsqmzXbeo7n0ItnBLYDjgDlQ+OYmvkrSTR+iX3lRbMw90sqWguYBM +lKg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1687758928;
 s=strato-dkim-0003; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=9JeG8e5YLzIlPXpqO3TJNmd5ODQ+yL/DZJEHg5yXjTE=;
 b=leG3fCEvi5hPT0fBTmq9D2X7bfNIhUAhanHELXceIBPiOCl+GQkXnfPaQBd83VSROr
 xP02/5ZSkcyBilmaNbAw==
To: viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 jack@suse.cz, jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 willy@infradead.org, hch@infradead.org
Date: Mon, 26 Jun 2023 07:55:17 +0200
Message-id: <20230626055518.842392-2-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20230626055518.842392-1-beanhuo@iokpp.de>
References: <20230626055518.842392-1-beanhuo@iokpp.de>
MIME-version: 1.0
X-Source-IP: 85.215.255.103
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10752
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 priorityscore=181 suspectscore=0 mlxlogscore=837 bulkscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=136 impostorscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306260053
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, beanhuo@micron.com
Subject: [Ocfs2-devel] [RESEND PATCH v3 1/2] fs/buffer: clean up
	block_commit_write
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
X-RZG-CLASS-ID: mo03
X-RZG-AUTH:
 ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1QLj68UeUr1+U1RrW5o+P9bSFaHg+gZu+uCjL2b+VQTRnVQrIOQ=="
X-ServerName: mo4-p03-ob.smtp.rzone.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: DA7QbgG9un4-XcO7Da5r6eiQSKddP67Z
X-Proofpoint-ORIG-GUID: DA7QbgG9un4-XcO7Da5r6eiQSKddP67Z
Reporting-Meta:
 AAFC9HCU1XToMMuvnkDMaXvZ515zbAiXNMC+n5TJn6uB1nuAPDIbn3tFHN63foa9
 I4GGBroCyPQ8vjAqA9vf96IBd5YGP4QeUR1qStZ/1AKq0ZLHQSWgFwDsIwFxYa48
 PcpYAwxMM0pU/45gdkSMcoCA2gqZ8d22+23Ggf73QXT0M0DqSLlwNuOzajIFVmQq
 e7yrGnF50sZoUNLeCAenwQ9JgKUih93WIiy5WsSojpR0OBK3m31h8/gdSTy0ehYl
 4diBMap/A+sh5PcVamBWE4+/FXitXz1dSyUqB0ne3qv0ctj0f40DEq+R1bPK04x+
 D5SFyIaCbg0utyZ11SfrPqf1X26YWNc5M4BaUabQVm4f7Dp0jDh6MZd7KfVfbE8z
 T1dR0e4CEZFLFoKM6rsJkRBeUgVozc/WMqffWIGK+CeIugcn4DGJu8EouIgyM2ZR
 Eb5RXC/CrpwH4+8jwL7fVHhI194r/wpK+nsdZkpYPUT8Xva7HrO9NARv5WKt4OGs
 dtiGn33A56XJQwW/0N7+XP1QQmF0NcNmnc4Ne+F/5DkG

From: Bean Huo <beanhuo@micron.com>

Originally inode is used to get blksize, after commit 45bce8f3e343
("fs/buffer.c: make block-size be per-page and protected by the page lock"),
__block_commit_write no longer uses this parameter inode.

Signed-off-by: Bean Huo <beanhuo@micron.com>
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
