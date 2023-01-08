Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A71F1C54EBD
	for <ocfs2-devel@archiver.kernel.org>; Sun,  8 Jan 2023 16:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=fcLdFCnZSGCUxt/F07lnOr+xSJgQbt33POouMhiaSAU=;
 b=ISGR1rGxCAoIvB/fePH5yz1Y9Z37nfwK8xE9m9M4NUbcAz1VQ9J5/XqQo+qX1xCd0+7jFL/nUaSO
   ynXfciLulAJc1+Fw6wYxgA/mSS5dsA7qnPp9JWwgKEX2MwFiLzvoRA0J23jfpnc97CujvldddQoj
   npBZ87nluOfZtXFX6Z97b19t07tBjZBZ3xUcOww8mLMiwhILKZNb/6+pCXJ0bwEmf/QQ8rb8qvP3
   VIqxYkAb2pu/s6L1CsQYHPOFtIkE9JNEme5E4jy+6SjCS7UjJRVf6DNfI67fw27jGjEvdGX8S+nw
   1Vt93E6PVvTy6LpEOyEtpOan48B2rOUT4Gmvag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=fcLdFCnZSGCUxt/F07lnOr+xSJgQbt33POouMhiaSAU=;
 b=t7LhUDhm80g2XRlxAPTLsTB3xpoUvWCfjsfVXlAkHWpMD4UlDOvFYsA+iFBnLKtTFDGmGiC7mr7x
   /rroUgpHDrVPvqSrdEMsr8Akxb5zZFwgVzj7RmTQHpWOAGoWaJrYeNAfG1J7K3Y+xysWflm1Of+9
   ugjILkyUVG5BK7hiXjsXif/TU6Xi8RyBS4ttX7f18mNVTd2R2b4lX/cnXp+wVidxNBsQ6KsRB9N7
   PaC/ArOULsSNy8eUB26rjMC2e2JPDNNH0fDQcKoeTaGYl9l/NYZugc10SXSTK62OwTNDdxCyr5qa
   K9NZlvwA2UP7JCX+RIQk3aHKCx74zwlQvrb5KA==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RO600K29F3UPN90@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 08 Jan 2023 16:57:30 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=0rSqpARFgQRqBHywsTtuZPRrJbLJdUkqrGBn/TckkNw=; b=XAeNW8PvyrIFuzPCKY54kLv+Iq
 Nr0c94bBAgRDDYDs5fmWgHLdSM4wuFdpF0unhRSD05WKElizN+oMfOJkw/ZCfBExPH0+8eVVmc912
 7+oPJRHsL5+w9Rpr4VxeL7F5SeY7g5CAteFbTDP2J+gJgCxiyFQkNBrhF7Pa7ERmrkiZnVL3g6aDV
 OCLJZQzxEq9s12LkEeWA6DqmpS49TRyZ/uVPnrptKfZ9FZYtvU/2AZ6auVcSG1Wcrk3eL9/aU8x7+
 JbJbDjelN9hkQfgxThV2QIF6AWhJ18L87Zumj5Z/1nBQW32E6qDIlVj/jLl4R6qHf834ghBLWQjiE
 TsSGua7Q==;
To: Andrew Morton <akpm@linux-foundation.org>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Dave Kleikamp <shaggy@kernel.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Sun,  8 Jan 2023 17:56:44 +0100
Message-id: <20230108165645.381077-7-hch@lst.de>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20230108165645.381077-1-hch@lst.de>
References: <20230108165645.381077-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10584
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 priorityscore=60 mlxlogscore=763 spamscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 clxscore=244 mlxscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301080126
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com,
 linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 6/7] ocfs2: don't use write_one_page in
	ocfs2_duplicate_clusters_by_page
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
X-Proofpoint-GUID: _d5rajPJPjXNcRl6D2xtLs-UrgHVzr1v
X-Proofpoint-ORIG-GUID: _d5rajPJPjXNcRl6D2xtLs-UrgHVzr1v
Reporting-Meta:
 AAGfAWcuTdqMkV1b6n/Db34FieZRjQfxJw08BfmITaPN7a4S2Ekuhgxlg03zFhEP
 w5Wjtdbo6nH7WHMBD0fA0IRdQkJTQB4s8bAf1ecjW9NPJD0jNQZEv69NQfw0qmj1
 45Yr0/jkVQP7ILopmKRaQXsNz0dBLpI4fzWgH7RlQvRosF7DjZ8g+SavYm3FuzhY
 f8M6tCGOMtpGoczoSp/joDaaoAbcUs8ibt/xmVMPWQttGhmOGWnY71zgUZKbUEt0
 lu3Pgkd+J/GAyKt/26efTNxyG2/MtaQZ7o40jIWIzMDs1AJ+XVaJClrhWlLslRqW
 wk3UYBZckIkcOuCTZiZceKcLLbj+dCuSJ7yHoS3W4bax1Nsu7Dtq21gYHslgtCjD
 QboMUK9QVH0IQThUhWzq/eoFa8QjUX5HcjjzuR/0lNeuOZKBmbbXLhmvc/4eHBNy
 pQZETVUkouMM4d/sPq8apVCd/9kIcTFrzEPbO5QDwtPtwxJ0GJ8fF4+Xj9cvcYF6
 FriI39YrtKEwYL9yVitkuXBBtxl+0LFrQWFnJ4k9ddpo

Use filemap_write_and_wait_range to write back the range of the dirty
page instead of write_one_page in preparation of removing write_one_page
and eventually ->writepage.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ocfs2/refcounttree.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 623db358b1efa8..4a73405962ec4f 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2952,10 +2952,11 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 		 */
 		if (PAGE_SIZE <= OCFS2_SB(sb)->s_clustersize) {
 			if (PageDirty(page)) {
-				/*
-				 * write_on_page will unlock the page on return
-				 */
-				ret = write_one_page(page);
+				unlock_page(page);
+				put_page(page);
+
+				ret = filemap_write_and_wait_range(mapping,
+						offset, map_end - 1);
 				goto retry;
 			}
 		}
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
