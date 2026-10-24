Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792854626;
	b=sMyWZWW6G1VUk0xE1OlB1Rlk2F6/cCQa9rDEtzWZcVXrDr6oeHKC0xiHKzVhFY3n1hCf
	 pfLQMOaA4wwXLJslsbdQGaM53ranJVl2/ge+16OsgYF0k5n3uedvVy70XGtjj5o7mG9T3
	 8gwCkJNZXY6d2QlksVvik/SpsWhm/vPbJRD7fyDNlEiSZlZOtmFowCGTw645J30++s4w3
	 vspds8QcEPLgp+JiIkB2PW5TM3lK1pH6v2tJ960pewoONiEJr5KqEFc/ezDeUQhoKF8hH
	 dBn7LMQsNhCJeJhVipgLKOqhWoqUhdg/nQxJ8ZFz8q2Go2ntyGy9DWp7BKFtECj4z4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792854626;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LNFr3EHBFqjwLmKdUG2gvja8FVODo4njy00KhKID214=;
	b=agM+4kyw29UbN9i1bz7/FMi4DcpAbRG/+yiFbA24RoB+jK6Cv0kyLUYYWkS6geXv0GzU
	 H/SfZfehixvM09yhhgnrKErQEZ7Nhp+uUORPx9jvwl+6CAKR/q97ikIDxoSRjHau3tgkU
	 OoMWhGNwJbVWzu19Cha6ZbXKb6TFPfu5X/Ab9wmbvQTG3A+IgFcGec2S4uLJm2plge+V+
	 N9zUFbskeqH0s2I0RbmbwetT15W3OqM+3PeH+NgQwYvasGX/riogwu1kPps5HNtz2AmO1
	 Vj4QtxKlQeSyafeYk4kCKB5ruPStAit/f+PweZIW8Xsj6ZkrIYUmpajeHdR1M0wT45A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=aFpb1elY;
	arc=none smtp.remote-ip=115.124.30.124
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3DC606A326
	for <ocfs2-devel@lists.linux.dev>; Sat, 24 Oct 2026 15:10:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB3DC606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=aFpb1elY
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792854614; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=LNFr3EHBFqjwLmKdUG2gvja8FVODo4njy00KhKID214=;
	b=aFpb1elYNErpaInshfvrayaI2Wcu6mRs5wjGtlAyfX+PA86HuBHyjBRtr+GJJco0SZwWWhwUWUHO9kUG66LsIEC9pE8zJnXXKJxYwMggwsafPce2v5kYvRmk10zJ5W9D2Pn+LEqHoewCFMIwHOrzfx4okV86EymVg5PdnfzAyxw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XDORGgV_1792854613;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDORGgV_1792854613 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 24 Oct 2026 23:10:13 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] ocfs2: read the xattr entry hash before defragmenting the bucket
Date: Sat, 24 Oct 2026 23:10:07 +0800
Message-Id: <20261024151012.1059683-2-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261024151012.1059683-1-joseph.qi@linux.alibaba.com>
References: <20261024151012.1059683-1-joseph.qi@linux.alibaba.com>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_xattr_set_entry_index_block() takes the hash a bucket split has to
work with out of xs->here, but only after ocfs2_xattr_set_entry_bucket()
has tried and failed to fit the entry.  That call defragments the bucket
when it runs out of room, and ocfs2_defrag_xattr_bucket() finishes by
sorting the entry array by name hash.  lib/sort.c is not stable, so two
entries sharing a hash may trade slots and xs->here is left naming an
entry other than the one the search found.

The hash value itself survives the permutation -- the array is already
sorted, so a slot can only exchange with an equal-hash neighbour -- but
there is no reason to depend on that.  Pick the hash up before the set,
where xs->here is unambiguously the entry the search landed on.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/xattr.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index b2bd06083a14..bb5b12924e1b 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -6100,6 +6100,22 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 
 	trace_ocfs2_xattr_set_entry_index_block(xi->xi_name);
 
+	/*
+	 * An existing entry keeps the hash it was stored under, and that is
+	 * the hash a split has to work with.  A new entry is stored under the
+	 * unsigned one, which is what ocfs2_xa_add_entry() will write.
+	 *
+	 * Read it before the set below.  Filling the bucket may defragment it,
+	 * and ocfs2_defrag_xattr_bucket() re-sorts the entry array, so
+	 * afterwards xs->here only denotes whichever entry the sort left in
+	 * that slot.
+	 */
+	if (xs->not_found)
+		name_hash = ocfs2_xattr_name_hash(inode, xi->xi_name,
+						  xi->xi_name_len);
+	else
+		name_hash = le32_to_cpu(xs->here->xe_name_hash);
+
 	ret = ocfs2_xattr_set_entry_bucket(inode, xi, xs, ctxt);
 	if (!ret)
 		goto out;
@@ -6115,17 +6131,7 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 	 * the maximum number of collisions we will allow for then is
 	 * one bucket's worth, so check it here whether we need to
 	 * add a new bucket for the insert.
-	 *
-	 * An existing entry keeps the hash it was stored under, and that is
-	 * the hash a split has to work with.  A new entry is stored under the
-	 * unsigned one, which is what ocfs2_xa_add_entry() will write.
 	 */
-	if (xs->not_found)
-		name_hash = ocfs2_xattr_name_hash(inode, xi->xi_name,
-						  xi->xi_name_len);
-	else
-		name_hash = le32_to_cpu(xs->here->xe_name_hash);
-
 	ret = ocfs2_check_xattr_bucket_collision(xs->bucket, name_hash);
 	if (ret) {
 		mlog_errno(ret);
-- 
2.39.3

