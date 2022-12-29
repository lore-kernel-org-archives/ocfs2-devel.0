Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2E96C4332F
	for <ocfs2-devel@archiver.kernel.org>; Thu, 29 Dec 2022 16:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=HSVGpxVbvKBPr/2abtkI+0mtnwiSKakf3UvSz9wZ2WM=;
 b=ZcCcXJ/qM40tuQpnp5TOHdCOI86LUl72UNN8yOyUBKOhM6qufRSwRIg9Qnbx53ziL4sApkgoDYkS
   HkOHI6rOdEa1R3oJ7rYTNTBWvasoPMWdl5HCsHH36gS1rUi8bJYvxqnSjXf0tdDQdVRT/JnDpPSq
   oMUdYZwH+bOqpet3JqDtbiGxTbQLMNjBgnwW8ExPSlTnTAIlQFMh0P2WYdAB/2XWgu2EkkEP8vJs
   VqVYkpofEaEI4xiwt5NKfLKTNk8bMZM1DOFfFgNMONzx40OmppAvv4Jj67TLzWWmN+GOavPvZqVO
   VdsMl88cwKeTR586vghkRhJOZrMtZdCLZn26zw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=HSVGpxVbvKBPr/2abtkI+0mtnwiSKakf3UvSz9wZ2WM=;
 b=D9AqPqX0Zn87fj/Gh/yO/ZtTAVoPiYoO2ujPrnQeAdCBILQOWTnE24UMK4Kjz5aDGq9odwIv+vT/
   EyN9vvNjvPOimQVF57UUbfJE7tky1tEYBAghFlYBetYnWqmi6j6VQfCWUNxSScI7Lx7gQHIsvr24
   ZkHNN7V8+eDZhDnmf5sXTtJBdNrquY2J6nCMUO8pf0OM0fMS/4HFUoyxy+6ALjBeMIEMHl21lWZT
   uK7ygg6Mi6sLmzFFbx2mBEPfINJxbECNtFjf40wyxDp2i+T0CpzB1ec4Tapkk1o2/YUI1CIBlcjq
   wdCy3hyIV40/WXGbvK0bfPiI5KMIcB4ogUAGzA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RNN00H23UBSQT30@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 29 Dec 2022 16:11:52 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=wAGRF3f2s+7CXmKUNt5mcDbE20Oprr4M4XP/Y6UM90M=; b=MMpycC1KT21omSKtBmc7e4cD91
 Iur3yD3HgzJ5iMdxiVKkR1ZdnMKaHYh0D1Nuka8SBPXLYXNDFOPUPjutKy047FuX/hr9iOVGjIu9G
 vu3jWyTLYTkn/q4qayrFVqWDQ2qLCxTbqGz5nuJK5RFkoxrMb3jAWruQSKfi5SiDLwNsh91m401s5
 +s+QGTNiigo0NptVFmx9P5DRo4sVO5VktSXZkS2NhcU0aJuEjy0pM6MAIkyfURfefHDrd7Z2txVZo
 W9YfXAgZI90nQqdDcVsuZpNNtkWPWnZ6Ntxlpx6YlHstNPYDMflBh8RUxWsqi/L9Tx/1r9azMHKHQ
 JUeQZujQ==;
To: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
 Jan Kara <jack@suse.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Thu, 29 Dec 2022 06:10:29 -1000
Message-id: <20221229161031.391878-5-hch@lst.de>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20221229161031.391878-1-hch@lst.de>
References: <20221229161031.391878-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10575
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 adultscore=0 impostorscore=0 suspectscore=0 priorityscore=0 mlxscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 clxscore=236 phishscore=0
 mlxlogscore=881 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212290134
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, ntfs3@lists.linux.dev
Subject: [Ocfs2-devel] [PATCH 4/6] jbd2,
	ocfs2: move jbd2_journal_submit_inode_data_buffers to ocfs2
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
X-Proofpoint-GUID: NfsWqDHCwxBk9jqHgKlMIYRqVC25H4s8
X-Proofpoint-ORIG-GUID: NfsWqDHCwxBk9jqHgKlMIYRqVC25H4s8
Reporting-Meta:
 AAHQ80d/jf7Klzsz/7OS8oWPHgwtjedLyhVuAGqauGkEmmDM2GEL9lMNBedZawc7
 7D6YHfQ32/wxSzt583P0FXB8UWJw7XisRLlkslMgQRZ60pMaTfW9tMNeaICtrkLP
 1UQEAXPlpIMd7luoic1EDQmZ8NxSmLaYQVuxkW/M2MDqhmZJLyAC+RbQwaA0hC+l
 MTheHBIZM0Xy8o8MOkb4cdvMPgu9gkwZIBHkDmnzaTVzijqrxeUZ3/VV8rsEcO3T
 QlF5oSkIyY5/4Ug98QA265AtRcTUEljoFHmPWMhX0Tma1bfGMU3Yrmxs3GurUvN3
 X5YgZlGnSxSAX9ceLWBpmZG0ue76qzRh+HNrlwDTuVv7aOwBtktdN6l6Eh/Gu9t0
 jHp6EKAee80GJqODXA/41xse81fOQJ/l12r/kmbxbTowvXNWBWCDXCPSR8dT6Zn0
 nR2/I6CemorfgLFJ5yi3heHlXh72IxeE928nP+EqBBG3SrVuLxYZkVwG9jrIFRW2
 th1SOvcWLnAcOV7ViTC0xJIZ3zIR9efYcsGcpzqSGYY=

jbd2_journal_submit_inode_data_buffers is only used by ocfs2, so move
it there to prepare for removing generic_writepages.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/jbd2/commit.c     | 25 -------------------------
 fs/jbd2/journal.c    |  1 -
 fs/ocfs2/journal.c   | 16 +++++++++++++++-
 include/linux/jbd2.h |  2 --
 4 files changed, 15 insertions(+), 29 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 4810438b7856aa..aeee6b8a6da218 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -181,31 +181,6 @@ static int journal_wait_on_commit_record(journal_t *journal,
 	return ret;
 }
 
-/*
- * write the filemap data using writepage() address_space_operations.
- * We don't do block allocation here even for delalloc. We don't
- * use writepages() because with delayed allocation we may be doing
- * block allocation in writepages().
- */
-int jbd2_journal_submit_inode_data_buffers(struct jbd2_inode *jinode)
-{
-	struct address_space *mapping = jinode->i_vfs_inode->i_mapping;
-	struct writeback_control wbc = {
-		.sync_mode =  WB_SYNC_ALL,
-		.nr_to_write = mapping->nrpages * 2,
-		.range_start = jinode->i_dirty_start,
-		.range_end = jinode->i_dirty_end,
-	};
-
-	/*
-	 * submit the inode data buffers. We use writepage
-	 * instead of writepages. Because writepages can do
-	 * block allocation with delalloc. We need to write
-	 * only allocated blocks here.
-	 */
-	return generic_writepages(mapping, &wbc);
-}
-
 /* Send all the data buffers related to an inode */
 int jbd2_submit_inode_data(journal_t *journal, struct jbd2_inode *jinode)
 {
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 2696f43e7239f8..d331f6ece20a28 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -89,7 +89,6 @@ EXPORT_SYMBOL(jbd2_journal_try_to_free_buffers);
 EXPORT_SYMBOL(jbd2_journal_force_commit);
 EXPORT_SYMBOL(jbd2_journal_inode_ranged_write);
 EXPORT_SYMBOL(jbd2_journal_inode_ranged_wait);
-EXPORT_SYMBOL(jbd2_journal_submit_inode_data_buffers);
 EXPORT_SYMBOL(jbd2_journal_finish_inode_data_buffers);
 EXPORT_SYMBOL(jbd2_journal_init_jbd_inode);
 EXPORT_SYMBOL(jbd2_journal_release_jbd_inode);
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 3fb98b4569a28b..59f612684c5178 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -15,6 +15,7 @@
 #include <linux/time.h>
 #include <linux/random.h>
 #include <linux/delay.h>
+#include <linux/writeback.h>
 
 #include <cluster/masklog.h>
 
@@ -841,6 +842,19 @@ int ocfs2_journal_alloc(struct ocfs2_super *osb)
 	return status;
 }
 
+static int ocfs2_journal_submit_inode_data_buffers(struct jbd2_inode *jinode)
+{
+	struct address_space *mapping = jinode->i_vfs_inode->i_mapping;
+	struct writeback_control wbc = {
+		.sync_mode =  WB_SYNC_ALL,
+		.nr_to_write = mapping->nrpages * 2,
+		.range_start = jinode->i_dirty_start,
+		.range_end = jinode->i_dirty_end,
+	};
+
+	return generic_writepages(mapping, &wbc);
+}
+
 int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
 {
 	int status = -1;
@@ -910,7 +924,7 @@ int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
 
 	journal->j_journal = j_journal;
 	journal->j_journal->j_submit_inode_data_buffers =
-		jbd2_journal_submit_inode_data_buffers;
+		ocfs2_journal_submit_inode_data_buffers;
 	journal->j_journal->j_finish_inode_data_buffers =
 		jbd2_journal_finish_inode_data_buffers;
 	journal->j_inode = inode;
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 2170e0cc279d5c..5962072a4b19e6 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1570,8 +1570,6 @@ extern int	   jbd2_journal_inode_ranged_write(handle_t *handle,
 extern int	   jbd2_journal_inode_ranged_wait(handle_t *handle,
 			struct jbd2_inode *inode, loff_t start_byte,
 			loff_t length);
-extern int	   jbd2_journal_submit_inode_data_buffers(
-			struct jbd2_inode *jinode);
 extern int	   jbd2_journal_finish_inode_data_buffers(
 			struct jbd2_inode *jinode);
 extern int	   jbd2_journal_begin_ordered_truncate(journal_t *journal,
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
