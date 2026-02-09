Received: from devnull.danielhodges.dev (vps-2f6e086e.vps.ovh.us [135.148.138.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D4D3815D5
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Feb 2026 16:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.148.138.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770653635; cv=none; b=E8BXkSFKWFvSzGkEKQFE5LAyzFOyphYrk8gasdIkUymwRAXgE2M1EU0uroWsEPVtI91kD3oTpk95PxMrtoVHI5Nzp2IzSOomr84v9KIK1qIraTwClrfAGTlIN12ezNcvA0Hk/4fv+ZKHJbMxFcJBi/ketLya6FXeRXsBYO5OPME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770653635; c=relaxed/simple;
	bh=BbAHzEmDq6quWXuJVOzwlsWcfxdjzBv1mmQ60zpegig=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aZ4DIIGDJoW3wca28Z3PXKIGzfGrS63OuApTvVNUQkHT/OpIsGgUdan/iCQ5RzSzDxG+xmctlWX9AeQTSjeSudhbQ45DjBG7f09lQbpJ1QelUfvowWVekQxBrr61dTkF3pHmJe6OZIlOdwneubjroTRhiMwpaf2iK4eaL+/V7d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev; spf=pass smtp.mailfrom=danielhodges.dev; dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=hsWqOIqb; dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=KxLc+Bwo; arc=none smtp.client-ip=135.148.138.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="hsWqOIqb";
	dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="KxLc+Bwo"
DKIM-Signature: v=1; a=rsa-sha256; s=202510r; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1770653628; bh=TIzg/21WYc6roqYOqE2C6xR
	chOosyzbnkc8iUinXj6o=; b=hsWqOIqbOtG78PHJyLh4rOYkaq5gKpOInudF0yRmW2F8hF6Tm2
	p/HpAeDLEiiXfoWw5ebsAz4rriI06RK0XdxtrEWfD91CKVKGoErscG4S5Lc7V4tMONCNF5uMZlg
	yXe4nZUZNad5tzswNcsoTB6zWAPWCiDBwu9K9BHRoocxvbooaNaefcIXxA8mVWkQFlMVYLfqzc0
	IPkcgRRdRCkRdJ8mi3wryBQ2TZUjK1/gSEzzW9N1M9g12LCleE8QqnZiw7QsKGmbVvy98ep+H5L
	GQ8hJHSVe0pa4HV1MdRN0mpvSNjfP3cIv0f+LarWX/9YXHwWCnpdFBahNjk98q0F53w==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202510e; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1770653628; bh=TIzg/21WYc6roqYOqE2C6xR
	chOosyzbnkc8iUinXj6o=; b=KxLc+BwosL8FCsZiMixI5znDkBJJ+UeI8qWO9S12iC5i+ZfDQ3
	ZocCY/NzffJgSVi510VeKHRtnsGK8Mso1fAw==;
From: Daniel Hodges <git@danielhodges.dev>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Daniel Hodges <git@danielhodges.dev>,
	syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH] ocfs2: zero-initialize recovery bitmap to prevent uninit-value in find_next_bit
Date: Mon,  9 Feb 2026 11:13:47 -0500
Message-ID: <20260209161347.30400-1-git@danielhodges.dev>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_add_recovery_chunk() allocates a bitmap buffer of sb->s_blocksize
bytes using kmalloc() but only copies (ol_chunk_entries(sb) + 7) >> 3
bytes into it from the on-disk quota chunk. When the number of chunk
entries is not aligned to a long boundary (64 bits on 64-bit systems),
find_next_bit() reads uninitialized memory from the trailing bytes of
the last word in the bitmap.

Fix this by using kzalloc() to zero-initialize the entire bitmap
allocation, ensuring that any bits beyond the copied region are
clean zeros.

Reported-by: syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com
Fixes: 2205363dce74 ("ocfs2: Implement quota recovery")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Hodges <git@danielhodges.dev>
---
 fs/ocfs2/quota_local.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index de7f12858729..bd3eb098097f 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -302,7 +302,7 @@ static int ocfs2_add_recovery_chunk(struct super_block *sb,
 	if (!rc)
 		return -ENOMEM;
 	rc->rc_chunk = chunk;
-	rc->rc_bitmap = kmalloc(sb->s_blocksize, GFP_NOFS);
+	rc->rc_bitmap = kzalloc(sb->s_blocksize, GFP_NOFS);
 	if (!rc->rc_bitmap) {
 		kfree(rc);
 		return -ENOMEM;
-- 
2.52.0

