Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 048E1CCA48B
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 20:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NKSCM2LfjJ/yopq4s8N1Z7tJbrMEPDsJ+WlIgHQ3UHA=;
 b=NTO4H+Zv+Gg/mHZ3stmsuKMRJ1o4hdyHdwrqADtSHXFDWjXiGMOm79WvRibJ5Az7WTEO4By7c5pa
   aN7MXmv1Iu+eYFuP3hWqIVOG+gY+JwUaWAEDf0k7Xq5YYx6E4aerqk5WZVXoDrK6PeYCDBOVSaai
   QHv+FpOklM38dHCUGJJOp0nUnKU6T+I5aKeXjB8ealgmnULW073OnvxYu40FRe7CEjWB6N3lY7lO
   q6QqrI4klzJhdDxRXCnDEKLkZXpqCM5ICGrlihWztH3ujYgKZofHuyuxlwC1vLNutUk7kh7XiymM
   HfTc7GTGlbOYSgKPdMxHcRDnmm0WFIc+wmHInA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NKSCM2LfjJ/yopq4s8N1Z7tJbrMEPDsJ+WlIgHQ3UHA=;
 b=I358apc7KV1qwv016vq5/ZQlMf1rU38im3pNJqijBkMcN4/IziZzaHBj+qX6giV5M6+ITbWLoPIi
   tDY8I4EzEQ/GkBUZFvhXIWIiD6NfDV4HPO0NWhBUKiEUDUopkZVQaF8ti1PTCFxuAxWAQkrK+Pvq
   wKMYUyRbuG9s3D5jRTEoGJcSnW+OYeEFHGoNTT2VBGSBatH6HWPtAiYQC2aVGO5ObBO7sc8e1lF9
   3vO/iRyDkYO0PtERmrAq21vlneLdPuOJHhKWXbf7mhFBl/ZjnTdLr2+N4WYWJ0DVZU6Ir5riNOjj
   XhqlMoucsXjpVh9AJ+T0ZjVr3H6CBXYJuD/nLQ==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD2000X3PGW9NE0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 20:41:20 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=jUHtPvxpwYn/CbCKtCO4gIDrDPVTvyaQoVGtIQShqV8=; b=jSXisP6LX46D6Mw+iXYFF/5dHQ
 Cq+5Fi0773+cVC4U9ukK6uPnYuWIfkHADg3G9SiZaN1QWdL8Bw8OwfYPT7xfddEiqh5OKP81yWVIY
 qERnKHNvRO9zfbKpGHImXAVxsBisgmn/CxiCns5EQmSUyg3J6K8R2kkkIDgNoaevsqaLFhC5Wxh52
 Z38Ws7TQ5Dp7rpDRe4MO4DakZ/+co05qxKtyfgyK3bXqUiSNs9vH9ETqmdeoiAv+unUA3cgwymN9t
 pq0eOgOppmxZCcU/ekIrK65xO/nlqiG9Pvvr5StvpmfjnqBIWv5xh9xJykbFL+Cw79+wHE0k8kIBA
 U9JkUfCw==;
To: linux-fsdevel@vger.kernel.org
Date: Mon,  6 Jun 2022 21:40:41 +0100
Message-id: <20220606204050.2625949-12-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220606204050.2625949-1-willy@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=469 adultscore=0 impostorscore=0
 clxscore=116 priorityscore=115 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060082 domainage_hfrom=8378
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 11/20] ubifs: Convert to	filemap_migrate_folio()
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
X-Proofpoint-ORIG-GUID: pDfshP228Maqb69XkQ8L2_pyjdNblXNK
X-Proofpoint-GUID: pDfshP228Maqb69XkQ8L2_pyjdNblXNK
Reporting-Meta:
 AAFCp4idPUo21eGRRaEq8/7nxXPHS7UPiqYODDrwqZV6YFcqpaepzGao1zDNO1gO
 ZW1ir5bQijuBylALth1PsMGuClFzxmrexoXLRiVHyeyR17czbYR6MIvyB2mdmhOB
 bUn88XhIrq/CVmYixZ7JX2KyOM0sjkf/WXHFMeAUHuanq0dS52v6C5eJSqw8ghRb
 mkTLbTFWmHEFMKE1/A7KQuPtjV8nF2WlGAmH382tanlGT4C/GuwbIXIjej8wXeFI
 NrYkg2J2Bg7gj9bZ1AFOjjeRvl4F09yXXIFhcNimclKbgT9lDTpOS4dpFdmnehCq
 DBAPG0v3qMQw7HKIHns3e0eg2Vc/dvX4ZJ36bnIma/bpaT4TpFQ6BQoM3ACNxcjY
 ya2fOg1IEXMwQ9yS2rpQnS97wtv5bX+jFppY+oZYRqn8w8aLTIVDg2KrUIEUg/7w
 VWuFJpC4c7K/WQ9snlFY7hbm+GR8KiQruQ38k4TifJewAzUo0e0jgwRKJ5HOXM5C
 VW+d1lCHhQOC1R4SrINr0yHb7+j2Tsk6WH6rnsl3/12i

filemap_migrate_folio() is a little more general than ubifs really needs,
but it's better to share the code.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ubifs/file.c | 29 ++---------------------------
 1 file changed, 2 insertions(+), 27 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 04ced154960f..f2353dd676ef 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1461,29 +1461,6 @@ static bool ubifs_dirty_folio(struct address_space *mapping,
 	return ret;
 }
 
-#ifdef CONFIG_MIGRATION
-static int ubifs_migrate_page(struct address_space *mapping,
-		struct page *newpage, struct page *page, enum migrate_mode mode)
-{
-	int rc;
-
-	rc = migrate_page_move_mapping(mapping, newpage, page, 0);
-	if (rc != MIGRATEPAGE_SUCCESS)
-		return rc;
-
-	if (PagePrivate(page)) {
-		detach_page_private(page);
-		attach_page_private(newpage, (void *)1);
-	}
-
-	if (mode != MIGRATE_SYNC_NO_COPY)
-		migrate_page_copy(newpage, page);
-	else
-		migrate_page_states(newpage, page);
-	return MIGRATEPAGE_SUCCESS;
-}
-#endif
-
 static bool ubifs_release_folio(struct folio *folio, gfp_t unused_gfp_flags)
 {
 	struct inode *inode = folio->mapping->host;
@@ -1649,10 +1626,8 @@ const struct address_space_operations ubifs_file_address_operations = {
 	.write_end      = ubifs_write_end,
 	.invalidate_folio = ubifs_invalidate_folio,
 	.dirty_folio	= ubifs_dirty_folio,
-#ifdef CONFIG_MIGRATION
-	.migratepage	= ubifs_migrate_page,
-#endif
-	.release_folio    = ubifs_release_folio,
+	.migrate_folio	= filemap_migrate_folio,
+	.release_folio	= ubifs_release_folio,
 };
 
 const struct inode_operations ubifs_file_inode_operations = {
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
