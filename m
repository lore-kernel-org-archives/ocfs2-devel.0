Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF427CCA485
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=c54IzBboE5n/lbIupVo0IrWAo8HAkIt8aQJBYIsMIdU=;
 b=svRb/dJW397a4egtoqY3y660vIUpTEUFnRGkRLS3zpvmu/pTymhFYKJSyChp2qudioscxiRdB2Uo
   9lyDaJ3KV/LCb9vjMvX4F/Up7sHxkL0Exx1QcrdinWOQ23GowdkUKgRCHoX9qAYT+VSPCdJkQLen
   9mMp9+dP+IKD18/BK8iH+MtV5fmgdehKzIv61RtQu3MKAM5GKb6mVHHme9kb5BnAsVz1w+xFXci2
   CF9N+AYceGfTh3QaomOXJSOyyyQFynGBk63kqp1+X6LazTEdZiObx2IHnDaHHDJgigr4NuSNIFKt
   4l6SI4wVsg1K3M9JbLaZprwc4fuE8k4VfX+F+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=c54IzBboE5n/lbIupVo0IrWAo8HAkIt8aQJBYIsMIdU=;
 b=iwuUAgy0TzL25sgbVL6lylXz51yE6Gkc0IXzPbKzqpuBz3ucdChv+lYL6aZd5R0KZpaKJxkXUKei
   3OIqfLgzKh+3l+se7mdxXBhloxmX9aH8lp8OOvaNvXBdawofud9DzcGMsMaURG0I5T5qK8CHjebG
   10cBG9qRcKCycTYxV4KJPSNHgPzhehFaIa4MMwpoM47I2cj2o26G+wnhhQ1MQYsoV2/xTvElIQg/
   fH+Qfz1DE3gHyuDcEYwy5E2lDTb25o7IfnkTUSi6O3zeIbZGAmECty63Nv25dEQAc76+BiPA7zVQ
   PJ0Qm2UQcEhwe3hgprQLpmn7HQK66VE+HvUEcg==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500BMNZ5S6T10@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 15:03:28 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=rXRIRcK5aBVZ2wBOi68suVknWfPexbmGif0IEKfZsbs=; b=lsRn9gaO5tAEYD/OWJOs5+zBTI
 NCwTDYynMk1lnd9OTbJ4EfJRYdVl+3dODL7tzXJVPHXM+7SlQHXOVlUsUboFXhSdXz3aSmA3UKZ6F
 L5v7sh+GECC4njYbIAGlnHpfB8UwcWrwo0wyP4BhZlRei7kEvvdyW2VaiPkXgO55R9kKQgx/YjEqw
 tYFIlMpDyJj5vqIZK5lcNkMFc7QTZ02ItadvJCgbfwAGx5UGipfrdrSUQujOmia2pjwzdNOAWZ616
 V6c9pTOiEz7pLpSwn0iaK2fRQggU3GplOvlDyjFYnosAScOy2AdneQp1BzdO4NPq9SyDvONshsH4r
 X68Lp0aw==;
To: linux-fsdevel@vger.kernel.org
Date: Wed,  8 Jun 2022 16:02:31 +0100
Message-id: <20220608150249.3033815-2-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220608150249.3033815-1-willy@infradead.org>
References: <20220608150249.3033815-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 mlxlogscore=735 spamscore=0 adultscore=0 clxscore=163
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 priorityscore=250
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080064 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2 01/19] secretmem: Remove isolate_page
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
From: "Matthew Wilcox \(Oracle\) via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "Matthew Wilcox \(Oracle\)" <willy@infradead.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: casper.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: qK69fiHYpIAPzt4aFD3dkYwrjxi_fBLG
X-Proofpoint-ORIG-GUID: qK69fiHYpIAPzt4aFD3dkYwrjxi_fBLG
Reporting-Meta:
 AAEOVeCPB1T7ZqplPs7gTF4dfQgJ3YBHjOmfDQ+f88xsStV81sMPKEwjjHiWEUmo
 aEo6L+Z6rUQ8N/y29mygNdYBabv5w2qYVsV1lsZGBkul+fnyQ3dYPxHTNzhDfDg3
 rCQAvQ0JXFDLLYa87HsDd7BNLFI1gy8uNMZbjFWVyXlVzpf6+jJWk5n2DKTnQLLU
 K04t09jPUIPtNOibZzxSwB1A9mL25MNzm7Q6fm9UgUiVhQt3M2GB/tzMXcswxt+J
 CdlBKX6W/5nHmE/vuWCVPgGrG3DQSOs2bwaJ1CU93vslnf+JROhnPX7SYiv4jZKh
 i5AjwVdvfAsmX/PDmgFbxhAlt2jXT+RJBpnEteH4c8xYXiq8CLOzDkkqI+WFOQxP
 w7hFjBZStNVdqNUasrhfPygH/cfMkTS+530ZttZCk3nYpdF1FzKxMWH8BhLbCIaw
 AY9oAcLttAA+dlj0rjTCRvm1okJI6zD0PjeT8KBKz/MEXO0rFVsiujKMJ3+64iaq
 lXn7ozthz3HqVgqbNb0Wv4dPkPlfXuiONssaF6m9ogiC

The isolate_page operation is never called for filesystems, only
for device drivers which call SetPageMovable.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/secretmem.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/mm/secretmem.c b/mm/secretmem.c
index 206ed6b40c1d..1c7f1775b56e 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -133,11 +133,6 @@ static const struct file_operations secretmem_fops = {
 	.mmap		= secretmem_mmap,
 };
 
-static bool secretmem_isolate_page(struct page *page, isolate_mode_t mode)
-{
-	return false;
-}
-
 static int secretmem_migratepage(struct address_space *mapping,
 				 struct page *newpage, struct page *page,
 				 enum migrate_mode mode)
@@ -155,7 +150,6 @@ const struct address_space_operations secretmem_aops = {
 	.dirty_folio	= noop_dirty_folio,
 	.free_folio	= secretmem_free_folio,
 	.migratepage	= secretmem_migratepage,
-	.isolate_page	= secretmem_isolate_page,
 };
 
 static int secretmem_setattr(struct user_namespace *mnt_userns,
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
