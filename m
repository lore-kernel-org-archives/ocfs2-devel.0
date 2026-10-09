Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05153DCD8D
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Oct 2026 08:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791534614; cv=none; b=Yn9ysyW09oFxv0Mh5AWffOmYIRfiNWTuPQyX7WzKpFjxU8lqIgm7hqemdZ4vhMii1k+A+ZFYOOavYd2V+d/iBSAZ1n4KT3sMHGZHDfbxB1igXcXuJPHYz8s1yV/1Edd5RTSoTPwhA5/np/i8MkvJssRwpap8ZgNeByhIx8DLyx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791534614; c=relaxed/simple;
	bh=SWOuCd2e4IslNGB7zPLCpuPkBeAy/Wy1kReOgiXhMAU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=K97FL81gtYYz35PIWp+Zr9jnwgnj5wH4xoRpitV9RSS9hbFubSVTIC1R+omtVFv/z/pcqpoo9rj+b5nSjxz+L68W0a41hHgvuFf4xTEeEemu4jPjvVTd2W9T7v/HXG2Y1Tvtn4cu8weoyhZJw5lW6IiOarWp2qQ80TJWCYyOMHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gWCSo3Gn; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gWCSo3Gn"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791534604; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=e5+/Em9NoxIEsaJGqIz6QNqsapFlEznoc9x7pU4evMs=;
	b=gWCSo3GnrUP8+HeT2i7aTxAMwT1jkFOeVU1JIqy0V9KxWzct5BpbRQ6ipkYnTnxjUKB5gQWYWbyBtdgkqDAWsPr2IDAB9j86T5dKqXgqY77eaF8I0yqPbOce+eS2Pfx1UDyJTP9qfpItDOmwi4mNrZ39Q4igJn7TPdOTpM1vOPY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XCSo.Sa_1791534602;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCSo.Sa_1791534602 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 09 Oct 2026 16:30:03 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Anderson Ferneda <anderson.ferneda@braza.com.br>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] ocfs2: deal with legacy signed name hash values
Date: Fri,  9 Oct 2026 16:29:59 +0800
Message-Id: <20261009083002.2621201-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 3bc753c06dd0 ("kbuild: treat char as always unsigned") turned on
-funsigned-char globally, which changed the result of two naked 'char'
loads in ocfs2 hashing code:

	str2hashbuf()            val = msg[i] + (val << 8);
	ocfs2_xattr_name_hash()  hash = (hash << 5) ^ (hash >> 27) ^ *name++;

A name byte >= 0x80 used to sign-extend and now zero-extends.  Both
results are written to disk, the first into the dx leaf when a directory
entry is indexed and the second into xe_name_hash when an xattr is
stored, so anything written by a pre-6.2 kernel is looked up under a
different hash and is no longer found.  readdir and listxattr still list
those names because neither of them hashes, which makes this look like
the filesystem losing entries rather than like a lookup bug.  Anderson
Ferneda reported it that way for directories with non-ASCII names [1].

Patches 1 and 3 do what ext4 did in commit f3bbac32475b2 ("ext4: deal
with legacy signed xattr name hash values"): look up with the current
unsigned hash, retry with the legacy signed one on a miss, and always
store new entries under the unsigned hash.  The retry is skipped when the
two hashes come out equal, so an ASCII name does not walk the index
twice.  Both hash functions now spell out the signedness instead of
leaving it to -funsigned-char, as commit 854f0912f813 ("ext4: make xattr
char unsignedness in hash explicit") did, so a backport to a kernel
without the flag still computes both variants correctly.

Patch 2 is a separate fix, placed before patch 3 so that every commit in
the series is correct on its own.  ocfs2_check_xattr_bucket_collision()
recomputes the hash of the name to decide whether splitting a full bucket
can make room for the entry being set.  That is right for a new entry and
wrong for one that already exists, since an update leaves xe_name_hash
alone.  Against a bucket holding legacy hashes the comparison does not
match, so the split goes ahead and cannot help: a bucket whose entries
all share one hash has no divide position.  How that ends depends on
where the unsigned hash sorts.  Below the legacy ones, the set fails with
-ENOSPC after growing the tree for nothing.  Above them, it lands in the
empty bucket the split just appended and stores a second copy of the
entry there while the original stays behind, so listxattr reports the
name twice.  Using the stored hash closes both.

Nothing retires a legacy hash at runtime.  Deleting or updating an entry
does not rewrite it, and the only code that rehashes existing dirents is
ocfs2_expand_inline_dir() on the inline to extent conversion, so the
retry stays for as long as the legacy entries do.  Rebuilding the index
offline is what removes it for good.

Changes since v1:
  - add patch 2, so that ocfs2_check_xattr_bucket_collision() uses the
    stored hash of an existing entry rather than recomputing it, to
    address Sashiko's comments on v1 patch 2/2;
  - v1 patch 2/2 is now patch 3, with no code change;
  - patch 1 is unchanged and picks up Heming's Reviewed-by.

[1] https://lore.kernel.org/ocfs2-devel/CP5P284MB2780AC2C3C2AB2CF2B6CB7AFBE942@CP5P284MB2780.BRAP284.PROD.OUTLOOK.COM/

Joseph Qi (3):
  ocfs2: deal with legacy signed dir index name hash values
  ocfs2: use the stored hash when checking xattr bucket collision
  ocfs2: deal with legacy signed xattr name hash values

 fs/ocfs2/dir.c   |  76 +++++++++++++++++++++++++-----
 fs/ocfs2/xattr.c | 120 ++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 164 insertions(+), 32 deletions(-)

-- 
2.39.3

