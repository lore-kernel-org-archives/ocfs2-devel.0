Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792854624;
	b=Oibour8WKsxJqRvBvBi0ntcIDYdLPVhYerusWaFcjI9pZTdkDbXP6EOM1JvZLBhDvwng
	 IAtChAPmBCwlmHweo0ywsuM2rhVaVEMOzkp4cMqwHCy3KqSMzFR9MBRsJdyD73tyhCEED
	 YjYaQ06A8O19VxhK9L/hV4L7T5a1ql8B53qbq1OUDJRcWl8J74dHdDA1x9yLi+nt84oIC
	 lhL0y3hGZnhZen8e575BFwH77hoQBUtOJJGNWS+KOvhUouLDuhkx4pIChOnXhjIQziyis
	 WAWzqahS94YDY8s2ioXJJVIJPUhtYuzz3Kp1uUyT1cS5k3n9g2fuDXhSAph0cqhUn/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792854624;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=pgOgHSkQy+vlG7fTbkBba2DJALi86z5qXnzSUHGXa6s=;
	b=t5hgHDKKU62wJhOEXTQ6P9qD5waIxO7AZZ4WDOGFNeZLUIrDqGYCULAMigDy0cw90pcq
	 vhSRHonnG8uFym5DlBzBwvdn0oA9EgIfz5zfn1ga4P4vDee4JlDO5S4VaVIgHkqloblOo
	 K/3oDYIjNDXnoxRu5ra62hbUsBEtVjeDtW3hTEJoAf9hBtOwJLoYuoLErAFmjRXRcxZ8k
	 L3Rh6EgiyuJnlPIPnXq+5bCGkgFdKxjPZVV0NrHd0LGxr3jS9vouNPVavxsd1PR3gog7D
	 e+DYT98d4ijw1jRBpiY/NYFqxoeimZfI7Lw1snYZKmIQJoBxaeP/EGqgO2f09cWBWsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b="Rlb78/2K";
	arc=none smtp.remote-ip=115.124.30.124
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B24606A31E
	for <ocfs2-devel@lists.linux.dev>; Sat, 24 Oct 2026 15:10:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73B24606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Rlb78/2K
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792854615; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=pgOgHSkQy+vlG7fTbkBba2DJALi86z5qXnzSUHGXa6s=;
	b=Rlb78/2K7zklJ3BbFkYUtzW7PmncAlSrTANJAhlsapCXdrDWfUrsJmeKBbrK/JYXQCwBOi9RekdQ+CCqUzI3PSgRxJGcFHTo49ZUhIy3p5rjSO9t8EXifiskS9qfuBLvZycJCeNKlqgGff7cFYVaNHWxGG5mPsPybsLPKDFAulU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XDONePF_1792854612;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDONePF_1792854612 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 24 Oct 2026 23:10:12 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] ocfs2: fix stale xattr entry pointers and empty header reads
Date: Sat, 24 Oct 2026 23:10:06 +0800
Message-Id: <20261024151012.1059683-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
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

Five defects in the ocfs2 extended attribute code, plus one robustness
measure that belongs with them, all on the paths that move entries
between a block, a bucket and an index tree.  They fall into two groups.

Stale entry pointers (patches 1 to 3)

ocfs2_xa_set() writes through a pointer into xh_entries[] that two of
its callers invalidate first.  Defragmenting a bucket ends in a sort()
on xe_name_hash, and lib/sort.c is an unstable heapsort, so entries that
share a hash can trade slots.  Copying a block into a bucket changes the
order outright, since a block holds its entries in insertion order while
a bucket holds them by hash, yet ocfs2_xattr_update_xattr_search()
relocates the search by the index the entry had in the block.  Neither
path compares the entry's name with the one being set, so setxattr() can
replace a neighbouring attribute's value and still report success, or
trip ocfs2_xa_reuse_entry()'s BUG_ON.  Patch 1 takes the hash before the
sort; patches 2 and 3 look the entry up again afterwards.

Reads of an empty entry array (patches 4 to 6)

A block and a bucket may both hold no entries: ocfs2_xa_remove_entry()
keeps the last slot when it removes the only one, so an empty bucket
still carries the hash it is keyed by.  Three sites index xh_entries[]
without checking xh_count and so read xh_entries[-1], which lands on the
header and comes back as xh_count | xh_free_start << 16.  Nothing
faults, but the value is acted on: the collision check reports no
collision for an empty bucket, the divide commits a sentinel hash that
hides part of the key space from ocfs2_xattr_bucket_find(), and the
block to bucket copy claims storage the bucket does not hold.  Patches 4
to 6 guard each site and keep the one read of xh_entries[0] that
ocfs2_xa_remove_entry() documents as intentional.

Joseph Qi (6):
  ocfs2: read the xattr entry hash before defragmenting the bucket
  ocfs2: find the xattr entry again after defragmenting a bucket
  ocfs2: find the xattr entry again after converting a block to a bucket
  ocfs2: do not read the entry array of an empty xattr bucket
  ocfs2: do not index before the entry array when dividing an empty
    bucket
  ocfs2: do not read the entry array of an empty xattr block

 fs/ocfs2/xattr.c | 146 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 123 insertions(+), 23 deletions(-)

-- 
2.39.3

