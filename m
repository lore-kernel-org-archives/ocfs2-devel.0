Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAC8FC64991
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 13:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=YLkcqhbGajkU2sUy67PK9wpiTtQ+y+2FHnU88DuUAaY=;
 b=J9jlC4sPmmi55GevqL/iiKPJIG6Tu4+nR3Jnvi01gDABgy1GxYQq2Vpo69psF4Erfzrk4Z6fpObm
   Fa/fzhdW0Wte2EW02LqgmZQrcIxEHlUgfrecQJ3ldBWTa9l2ibMINO5iq0csJ8rWfV3d29TAHUAr
   A6t/UU1KW8RHk9J7dCWXFVXk1ufNhRKmm2auACs57G0KD2+tvmTlIHaTC/AitjJHrZwiSWZc9A2U
   sGk/CrTyMVghxHe9uIbT3Yqox5wWX03QLWcjVa5vH1rL/Mo6e2FLPr+iFYXMybOF90wEBi58mmW0
   W/G11z5aHNO5Uk8B6MZas90PkIyk+hnYxGx1+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=YLkcqhbGajkU2sUy67PK9wpiTtQ+y+2FHnU88DuUAaY=;
 b=VuuOVzYOP84j+DH/hO/Jk6n+LzHJp5dtRuHvIjXAXRtePPmNj8+mgYg7iWX524o7cFQLKigHeQ+Y
   m3pb3Bjr9YPodTR4mR99q9BG0s2PdyEArLb6TmpjB6nvGnkD82zaU41mCLh7fI6DqHqd4L3RDTnu
   RepSWlaLwbd7Xd3LzE4YhEUQKzpAZgD06c6uZkJ8gMCddbdr0MuZWoSOfBac0WSkjHAul74K/D/D
   HjQiKdgdub6tsj4DDWs6csBu4t1VE5VatDODYZssGVqoI+cbS6Z3domcbDcuGsSj8iB+z8uIbP+R
   bQUANBmMRYANTRk7iTK+Z9gmGW5GQURqHPaC7g==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ00D5098MQ6C0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 13:24:22 +0000 (GMT)
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <cluster-devel@redhat.com>,
 <ntfs3@lists.linux.dev>, <ocfs2-devel@oss.oracle.com>,
 <reiserfs-devel@vger.kernel.org>, <jack@suse.cz>
Date: Thu, 1 Sep 2022 21:34:57 +0800
Message-id: <20220901133505.2510834-7-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220901133505.2510834-1-yi.zhang@huawei.com>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.127.227]
X-Source-IP: 45.249.212.188
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=142
 priorityscore=237 lowpriorityscore=0 adultscore=0 spamscore=0 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=942 suspectscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010060 domainage_hfrom=8269
Cc: axboe@kernel.dk, hch@infradead.org, tytso@mit.edu, agruenba@redhat.com,
 yi.zhang@huawei.com, almaz.alexandrovich@paragon-software.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, rpeterso@redhat.com,
 dushistov@mail.ru, chengzhihao1@huawei.com
Subject: [Ocfs2-devel] [PATCH v2 06/14] jbd2: replace ll_rw_block()
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
From: Zhang Yi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Zhang Yi <yi.zhang@huawei.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
X-ServerName: szxga02-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 1msWMPqh4PUAGmcfTcs-htwM5aqdHZek
X-Proofpoint-GUID: 1msWMPqh4PUAGmcfTcs-htwM5aqdHZek
Reporting-Meta:
 AAG4az+Z18ZmH0WISyIDBIf5Y2IQW+3ERFdDT8St+4QfD1855s2tKoJA6pTjbnJt
 JdOJfcGPzhrF7TR7/0PvfjoBWMXPEVnL5Imdi8FedVVYvh8gIIsZZ/fyvgSXbdtE
 AmCRpEdZr0WIt8UHpZmWl+1949luHE2546NxxXBg2jdeGh+33yb09jkPtBymKeeT
 4ExVYCT4Ata+xTHVo/RHbj9j4KkNIOCNJStqqEhyOBGitksExsPVQIhQfSURMtNH
 QcnnzzW//E9xr8qvHpjzkhkXe6Ox/7NZRLtZv3tXR/Ed5cgL+sY5GKkOhO/MbnRp
 IR7c+N5w/BqAbKJRUI5FPlammu7mav0HnGyo5PtOrZWzUE09pRJsMFV5dl45ZSAl
 IAai9NCwUOX+KABXjfkr+/40/ej32elNS6UtWpB3bGyrm1TtiivEEW8Ru+t1kI0H
 Yo2TP/w+m94W+TkndEFJ08kyoEVlUUGlXq2nDRyfpTWXCvWb/Fs6joCX31jVBX/1
 zj47z4rwXa2CShUFWq1dzrRBzPvt4JYsrZZt2k0a8ltN

ll_rw_block() is not safe for the sync read path because it cannot
guarantee that submitting read IO if the buffer has been locked. We
could get false positive EIO after wait_on_buffer() if the buffer has
been locked by others. So stop using ll_rw_block() in
journal_get_superblock(). We also switch to new bh_readahead_batch()
for the buffer array readahead path.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/jbd2/journal.c  | 15 ++++++---------
 fs/jbd2/recovery.c | 16 ++++++++++------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 6350d3857c89..140b070471c0 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1893,19 +1893,16 @@ static int journal_get_superblock(journal_t *journal)
 {
 	struct buffer_head *bh;
 	journal_superblock_t *sb;
-	int err = -EIO;
+	int err;
 
 	bh = journal->j_sb_buffer;
 
 	J_ASSERT(bh != NULL);
-	if (!buffer_uptodate(bh)) {
-		ll_rw_block(REQ_OP_READ, 1, &bh);
-		wait_on_buffer(bh);
-		if (!buffer_uptodate(bh)) {
-			printk(KERN_ERR
-				"JBD2: IO error reading journal superblock\n");
-			goto out;
-		}
+	err = bh_read(bh, 0);
+	if (err < 0) {
+		printk(KERN_ERR
+			"JBD2: IO error reading journal superblock\n");
+		goto out;
 	}
 
 	if (buffer_verified(bh))
diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index f548479615c6..1f878c315b03 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -100,7 +100,7 @@ static int do_readahead(journal_t *journal, unsigned int start)
 		if (!buffer_uptodate(bh) && !buffer_locked(bh)) {
 			bufs[nbufs++] = bh;
 			if (nbufs == MAXBUF) {
-				ll_rw_block(REQ_OP_READ, nbufs, bufs);
+				bh_readahead_batch(nbufs, bufs, 0);
 				journal_brelse_array(bufs, nbufs);
 				nbufs = 0;
 			}
@@ -109,7 +109,7 @@ static int do_readahead(journal_t *journal, unsigned int start)
 	}
 
 	if (nbufs)
-		ll_rw_block(REQ_OP_READ, nbufs, bufs);
+		bh_readahead_batch(nbufs, bufs, 0);
 	err = 0;
 
 failed:
@@ -152,9 +152,14 @@ static int jread(struct buffer_head **bhp, journal_t *journal,
 		return -ENOMEM;
 
 	if (!buffer_uptodate(bh)) {
-		/* If this is a brand new buffer, start readahead.
-                   Otherwise, we assume we are already reading it.  */
-		if (!buffer_req(bh))
+		/*
+		 * If this is a brand new buffer, start readahead.
+		 * Otherwise, we assume we are already reading it.
+		 */
+		bool need_readahead = !buffer_req(bh);
+
+		bh_read_nowait(bh, 0);
+		if (need_readahead)
 			do_readahead(journal, offset);
 		wait_on_buffer(bh);
 	}
@@ -687,7 +692,6 @@ static int do_one_pass(journal_t *journal,
 					mark_buffer_dirty(nbh);
 					BUFFER_TRACE(nbh, "marking uptodate");
 					++info->nr_replays;
-					/* ll_rw_block(WRITE, 1, &nbh); */
 					unlock_buffer(nbh);
 					brelse(obh);
 					brelse(nbh);
-- 
2.31.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
