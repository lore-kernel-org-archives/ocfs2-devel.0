Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 896E2C46467
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 Jan 2023 17:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=17d+bSkSlvaQ0viQdwiAUQ/HJKxmN0UBtrEYAJSCEMs=;
 b=vgyd7tdCgeZ9jH3uu2e0btQfMzqulAv9j+dKWLWlXNVtv6Yn0wpFgSuVxzi96074LXfxZy0YhD8v
   BI2GWmhWzPxwDz2DsZjs9OyS3cLuPPkZkqUwlXpzVNbZZ0WTjlEYcgolyJEGgWcjjjPABh4osUiD
   50m8UGU+MhcDbiZTSfVyd1wQPvFBlPzedzfMWr+OFurIpaRURxc8IynXVCuXDlwsJYllekOoB4/l
   9j51Noq7azGCFKSFFVhPNfSVCP3JquS77nN3aonf8ayc6F+h99FQdLrRh5yqB7mrKgpbekakhKUt
   nS2t+SxcDwyaMwFQZJF6dYXX1muALkcs8C8Fww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=17d+bSkSlvaQ0viQdwiAUQ/HJKxmN0UBtrEYAJSCEMs=;
 b=LRsnbrPBBVS9BvX2PNqptqkG13V1Ga/TQTQNlGJDjgj0qegmiN8qa01sjxnOojpYatkI75jJ5mvn
   DcK6nA+dDPCwLeoPOXyPUFgS12SBpWkr+3M7Z8KVaPOYbgLJN6IGs/RE/7e3JDVek1fgPcZYQ/zF
   xfc+EbH5g1QhmJWwf+3Y3qIaRMJsTJIGv04J0TOqrGIeUMLlhaGjX3EBNsWRkK1HWJZhy7n5j94G
   JKevIWFnn0krSlVhc4FSGg11JSuFO4QUhzw3coTN2oGrdbAbBBAngtV7x9WVbNQ3dtQRptNeoGU/
   hvp1M5ZKbKnLsLFQJWoYh+kgOmMwfo2m0LoTvA==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROO000O2ZBTX800@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 18 Jan 2023 17:31:05 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=MsUsFoYQrTDA+hFUE1VWaBiacxBoUahLt80xRKfGZMs=; b=kqj2fnr+ij0si90SGxbS9qXDce
 2JYRKEHhI08O/eeOkZ4fGkif49Gsu87pWSEM4bCYAka8wxoBOy8Zc580p2lB4mZWpTixufgfK4OWL
 QOavXNp6Asr34uSPGFg/IlFkuGxb7C9Oi725gTlRiHA/LbWnneZBscVJ9VevMC6By9zCafaIYLB2E
 AAtGIINa79oLsbuf7OKhFM5ul79N4sg8/31bpJaYz/xFON4czyRlrMVFTN7bYi0CwSZkkYVHqz2ja
 0k4Y+DBDHOLUeyjVmwWHyPJIbN7Pq7wEVKXlZb0IoaURU0TlddjqfeacFkSNiucvibBPeu9Z+lfuf
 mpMph1gA==;
To: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Wed, 18 Jan 2023 18:30:22 +0100
Message-id: <20230118173027.294869-3-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-reply-to: <20230118173027.294869-1-hch@lst.de>
References: <20230118173027.294869-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10594
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 adultscore=0 impostorscore=0 phishscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=235 priorityscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180148
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 2/7] minix: fix error handling in
	minix_delete_entry
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
X-Proofpoint-GUID: fyyK2bN_guRdHuaR9zdjwtEE2WAXz9VD
X-Proofpoint-ORIG-GUID: fyyK2bN_guRdHuaR9zdjwtEE2WAXz9VD
Reporting-Meta:
 AAF+DhxvWj2jXmkXIsfQdOfuZ0cAubSG4K4kz/zqFZ965ABGCJgyrMHUeU2mekH1
 ZLU3C3x6NuXjbFDQe2CwnzztGpeUePM3AM6e5USCl1qALjbM08ifeGcCeYerfAyA
 R/9kK685Pnt3I15ZIuGXC5ihio7TAHD5D1hluG2dy3fqLoXazfo/3KMyVq6rTm/9
 siC+OfJ+WRIJyO0tnoqJq0lcxoCrMDRiY7mr3hla5kS/43+fKI6sx5ZRlniF+OtF
 WuOU7/2D5QD7T3cj/5oTI7tbYevD+mBA3Hx5MQkwmu6oamoKNKu2L8qCm9yuOz0d
 AN3Qt5BFKSMjqudhS0MpEBVVkqtwoAMnpUm1MDgoiwQkkFXEg52DBR4DeMnzH2qj
 6Dl51oyFq2qwXocrlSMp5X28e3vIQEJG9QjP51n94iin7bZNRiqF/EqI8mt0YJab
 G4HbNknV5FcfOdvtjm3pM6RCwLY3Ffj+ujN4PVb9rV/r2EiALX1VibfR7aJ8+d7M
 YuvTLpz0QQDqi7eXslfx/a0WfxTqu2Y1MWg+1Vt2NXRH

If minix_prepare_chunk fails, updating c/mtime and marking the
dir inode dirty is wrong, as the inode hasn't been modified.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/minix/dir.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index ec462330e749af..242e179aa1fbeb 100644
--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -297,18 +297,20 @@ int minix_delete_entry(struct minix_dir_entry *de, struct page *page)
 
 	lock_page(page);
 	err = minix_prepare_chunk(page, pos, len);
-	if (err == 0) {
-		if (sbi->s_version == MINIX_V3)
-			((minix3_dirent *) de)->inode = 0;
-		else
-			de->inode = 0;
-		err = dir_commit_chunk(page, pos, len);
-	} else {
+	if (err) {
 		unlock_page(page);
+		return err;
 	}
+	if (sbi->s_version == MINIX_V3)
+		((minix3_dirent *)de)->inode = 0;
+	else
+		de->inode = 0;
+	err = dir_commit_chunk(page, pos, len);
+	if (err)
+		return err;
 	inode->i_ctime = inode->i_mtime = current_time(inode);
 	mark_inode_dirty(inode);
-	return err;
+	return 0;
 }
 
 int minix_make_empty(struct inode *inode, struct inode *dir)
-- 
2.39.0


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
