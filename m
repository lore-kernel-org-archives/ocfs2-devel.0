Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A42C1C64991
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 13:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Iz8niT28R/j0Gma1iAmexQqXcxmu0auXr57hWc5mNSg=;
 b=mN7JqHDpwY60tVWawhgRf5jHsXdxPUhi++UNsSvg6m5CEeDnGmTNzB6E4L5ogxzw947sCSFA2t3E
   Dab+1ko7S5VwdvbvOWkEWL4S0K878XBIJyBp4O60h3xcJVpugvJAEbtZ+etcU6nczxtfIE5mJopq
   Tg7ng87SpcCo7Lnz3apenVozE/iV6h6VIf9ACSZiOPdC6h2wUf/H8Y6N1RqmYWosDqOOoZto/JLz
   kQ5lBektN1a7FR1CKOrsSrtzeV9TQtOASCR9lForxkvxqvLKAtGewzTEPD+/hw4ZT2zovr7iHlFg
   fttp6FurOrmiG9n6Uj6l5RQ48zz8BtGgfXzvRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Iz8niT28R/j0Gma1iAmexQqXcxmu0auXr57hWc5mNSg=;
 b=JN1xu2Eak79f69RZwtgp2I7wEQ1QbZ807nBNJdB0S32pqcZnws3FSybAX2xCnFmfU7EMZPxnAqH3
   iS41i4JbgUeRCy9nJ7LKt9zlhKVNvXFFJen9WDCdM5kavlEPmnKtTbn2AcOdM/YS90l3y8IwXXAu
   RzG265/7Q0VKp4ILcFkMxe7fsPgy5G9X0I1ejzHNlI+Aq20nL6/Mk5PRK0cQngHobh3DMSG1eMvq
   mKhhxeqcsk3XycFb/4IdJzRkqUtzz9bKzz0UV5Y7wOzalPNWMC2zO9lOksb9iaRfnqFiVNwJiM0W
   jKAnAd5CSQT5wwedh0vS1hDvAz6BaLVrDItVoA==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ007EX98J8X10@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 13:24:19 +0000 (GMT)
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <cluster-devel@redhat.com>,
 <ntfs3@lists.linux.dev>, <ocfs2-devel@oss.oracle.com>,
 <reiserfs-devel@vger.kernel.org>, <jack@suse.cz>
Date: Thu, 1 Sep 2022 21:34:53 +0800
Message-id: <20220901133505.2510834-3-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220901133505.2510834-1-yi.zhang@huawei.com>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.127.227]
X-Source-IP: 45.249.212.187
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 adultscore=0 priorityscore=207 mlxlogscore=770
 clxscore=119 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010060 domainage_hfrom=8269
Cc: axboe@kernel.dk, hch@infradead.org, tytso@mit.edu, agruenba@redhat.com,
 yi.zhang@huawei.com, almaz.alexandrovich@paragon-software.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, rpeterso@redhat.com,
 dushistov@mail.ru, chengzhihao1@huawei.com
Subject: [Ocfs2-devel] [PATCH v2 02/14] fs/buffer: add some new buffer read
	helpers
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
X-ServerName: szxga01-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-GUID: WBkEPgVXZYA8ZpzJz7ZXnby9AbFgF3qo
X-Proofpoint-ORIG-GUID: WBkEPgVXZYA8ZpzJz7ZXnby9AbFgF3qo
Reporting-Meta:
 AAF2x+q1GWvWJCW6ocMuMEwXSi4KbqRgdGigNhBvvQFU6Q66mcluShaj09qrQ4sX
 DDE78Q1JU37zeJuck4yQNxAF6pxnzBtdTP+fSsHsSfDXuNVMkuINlsirURYZs+u4
 H02p0TMSWzKi/A33LB507zm/7ST/+ne8jnxJRtHmf0O0dWzcGBdhlnE3FevnXRVp
 HeA1AiZz63+tBUhiNEYzz2Uq8AgIeX5u1RyOTZK8Lc6Dnk+aVH1qKqYk/X7i4n0Z
 Boi5EuMOSSYQv5aizA+0icBwZBXUkQfkARBWBLlkay5eI0df0+6lQjH17XQZraqE
 lVfPxfuIyHjfvJpgliW+Pqts5z8jZy+5/XJmq6zzd6VjNke/sUnIRLlny33DgOwo
 OKWIy0VWNIDV3BWPf0ywblMOzi0b5585YbSgJX6XQsqLhwA/Zg7pkgb/muuWv2zV
 8pC74BB8sOoZI85x2gkpMmf8ZvmdTS234aRCXjNoob1FNK1Ob1g1hS8+NHoNlhW3
 RILosnPz+N2fdeu46zgG2bOCO/s+ZqbhTA9cbVbIt2XSKA==

Current ll_rw_block() helper is fragile because it assumes that locked
buffer means it's under IO which is submitted by some other who holds
the lock, it skip buffer if it failed to get the lock, so it's only
safe on the readahead path. Unfortunately, now that most filesystems
still use this helper mistakenly on the sync metadata read path. There
is no guarantee that the one who holds the buffer lock always submit IO
(e.g. buffer_migrate_folio_norefs() after commit 88dbcbb3a484 ("blkdev:
avoid migration stalls for blkdev pages"), it could lead to false
positive -EIO when submitting reading IO.

This patch add some friendly buffer read helpers to prepare replacing
ll_rw_block() and similar calls. We can only call bh_readahead_[]
helpers for the readahead paths.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/buffer.c                 | 65 +++++++++++++++++++++++++++++++++++++
 include/linux/buffer_head.h | 38 ++++++++++++++++++++++
 2 files changed, 103 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index a0b70b3239f3..a6bc769e665d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3017,6 +3017,71 @@ int bh_uptodate_or_lock(struct buffer_head *bh)
 }
 EXPORT_SYMBOL(bh_uptodate_or_lock);
 
+/**
+ * __bh_read - Submit read for a locked buffer
+ * @bh: struct buffer_head
+ * @op_flags: appending REQ_OP_* flags besides REQ_OP_READ
+ * @wait: wait until reading finish
+ *
+ * Returns zero on success or don't wait, and -EIO on error.
+ */
+int __bh_read(struct buffer_head *bh, blk_opf_t op_flags, bool wait)
+{
+	int ret = 0;
+
+	BUG_ON(!buffer_locked(bh));
+
+	get_bh(bh);
+	bh->b_end_io = end_buffer_read_sync;
+	submit_bh(REQ_OP_READ | op_flags, bh);
+	if (wait) {
+		wait_on_buffer(bh);
+		if (!buffer_uptodate(bh))
+			ret = -EIO;
+	}
+	return ret;
+}
+EXPORT_SYMBOL(__bh_read);
+
+/**
+ * __bh_read_batch - Submit read for a batch of unlocked buffers
+ * @nr: entry number of the buffer batch
+ * @bhs: a batch of struct buffer_head
+ * @op_flags: appending REQ_OP_* flags besides REQ_OP_READ
+ * @force_lock: force to get a lock on the buffer if set, otherwise drops any
+ *              buffer that cannot lock.
+ *
+ * Returns zero on success or don't wait, and -EIO on error.
+ */
+void __bh_read_batch(int nr, struct buffer_head *bhs[],
+		     blk_opf_t op_flags, bool force_lock)
+{
+	int i;
+
+	for (i = 0; i < nr; i++) {
+		struct buffer_head *bh = bhs[i];
+
+		if (buffer_uptodate(bh))
+			continue;
+
+		if (force_lock)
+			lock_buffer(bh);
+		else
+			if (!trylock_buffer(bh))
+				continue;
+
+		if (buffer_uptodate(bh)) {
+			unlock_buffer(bh);
+			continue;
+		}
+
+		bh->b_end_io = end_buffer_read_sync;
+		get_bh(bh);
+		submit_bh(REQ_OP_READ | op_flags, bh);
+	}
+}
+EXPORT_SYMBOL(__bh_read_batch);
+
 /**
  * bh_submit_read - Submit a locked buffer for reading
  * @bh: struct buffer_head
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index c3863c417b00..6d09785bed9f 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -232,6 +232,9 @@ void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize);
 int bh_uptodate_or_lock(struct buffer_head *bh);
 int bh_submit_read(struct buffer_head *bh);
+int __bh_read(struct buffer_head *bh, blk_opf_t op_flags, bool wait);
+void __bh_read_batch(int nr, struct buffer_head *bhs[],
+		     blk_opf_t op_flags, bool force_lock);
 
 extern int buffer_heads_over_limit;
 
@@ -399,6 +402,41 @@ static inline struct buffer_head *__getblk(struct block_device *bdev,
 	return __getblk_gfp(bdev, block, size, __GFP_MOVABLE);
 }
 
+static inline void bh_readahead(struct buffer_head *bh, blk_opf_t op_flags)
+{
+	if (!buffer_uptodate(bh) && trylock_buffer(bh)) {
+		if (!buffer_uptodate(bh))
+			__bh_read(bh, op_flags, false);
+		else
+			unlock_buffer(bh);
+	}
+}
+
+static inline void bh_read_nowait(struct buffer_head *bh, blk_opf_t op_flags)
+{
+	if (!bh_uptodate_or_lock(bh))
+		__bh_read(bh, op_flags, false);
+}
+
+/* Returns 1 if buffer uptodated, 0 on success, and -EIO on error. */
+static inline int bh_read(struct buffer_head *bh, blk_opf_t op_flags)
+{
+	if (bh_uptodate_or_lock(bh))
+		return 1;
+	return __bh_read(bh, op_flags, true);
+}
+
+static inline void bh_read_batch(int nr, struct buffer_head *bhs[])
+{
+	__bh_read_batch(nr, bhs, 0, true);
+}
+
+static inline void bh_readahead_batch(int nr, struct buffer_head *bhs[],
+				      blk_opf_t op_flags)
+{
+	__bh_read_batch(nr, bhs, op_flags, false);
+}
+
 /**
  *  __bread() - reads a specified block and returns the bh
  *  @bdev: the block_device to read from
-- 
2.31.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
