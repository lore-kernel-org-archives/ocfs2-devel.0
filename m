Received: from forward102b.mail.yandex.net (forward102b.mail.yandex.net [178.154.239.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FB7770FE
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 10:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761646585; cv=none; b=GfQTnvpzmr3O3l+OPmXQW07QKokzfUgOwFHcsZyAlw9EkANq+DEMp1JezZk4Oa7Rv4KodsUcxsuxAnX19A55SHyHy3qlpJvb1YToykgm2Q+XSZcEdQA4Z0jnBhww52v5Vqr3RfE654k9OIPjk0fzv0x33QyYfLUSjK+WDQ2rHlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761646585; c=relaxed/simple;
	bh=Aasj4iqf8E5t7q++4zhhLX6UR3/rcVS/8uH3PGg7Usc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BaffonlC480SWnKQfkaYecZ+g8NREH/+FKgjeX4uUwmbBPS0i4RkEYnW2nquJrJkwNheaFtPmPTja4XI3Alj71AJlwnXMzYJSRQp1WTvebfvO7ooXmwfpK6qiEm+3YtBbx7FqaRkVj9WH+vvKSgHdo3rBbix2fTJwtXhCo6thXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=VEi7U2yb; arc=none smtp.client-ip=178.154.239.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="VEi7U2yb"
Received: from mail-nwsmtp-smtp-production-main-71.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-71.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:942:0:640:e3c0:0])
	by forward102b.mail.yandex.net (Yandex) with ESMTPS id 7E2CBC000F;
	Tue, 28 Oct 2025 13:16:12 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-71.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id AGacY7NLCa60-XjE5SbEp;
	Tue, 28 Oct 2025 13:16:11 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1761646571; bh=35XissWwhKmwhY9Oga+KWcspwd9TBX3uXOGi2zp+k6E=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=VEi7U2ybrrOvnDrsqPsbX1nApyKCmInauqrnSKrU/Di19M42w1eH+is/k0s4LYP3q
	 ZntNu4OWj0cON5au/jSO8kvJYL5og5mYawagnGCMIvq9jXY1GPjQbSJZ6IRD5crQIK
	 osxpkEPjO2wuS11tw2TcWNZswv1gX13AdNfb95+w=
Authentication-Results: mail-nwsmtp-smtp-production-main-71.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+77026564530dbc29b854@syzkaller.appspotmail.com,
	syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: add extra consistency checks for chain allocator dinodes
Date: Tue, 28 Oct 2025 13:14:47 +0300
Message-ID: <20251028101447.693289-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When validating chain allocator dinode in 'ocfs2_validate_inode_block()',
add an extra checks whether a) the maximum amount of chain records in
'struct ocfs2_chain_list' matches the value calculated based on the
filesystem block size, and b) the next free slot index is within the
valid range.

Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
Reported-by: syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5054473a31f78f735416
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
note: this is going to replace "ocfs2: introduce chain list sanity check
      with ocfs2_check_chain_list()" because it looks more consistent and
      allows to filter out damaged/inconsistent dinodes earlier (immediately
      after being read).
---
 fs/ocfs2/inode.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index fcc89856ab95..1b6bdd9d7755 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1503,6 +1503,23 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
+		struct ocfs2_chain_list *cl = &di->id2.i_chain;
+
+		if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb)) {
+			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list count %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(cl->cl_count));
+			goto bail;
+		}
+		if (le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
+			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list index %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(cl->cl_next_free_rec));
+			goto bail;
+		}
+	}
+
 	rc = 0;
 
 bail:
-- 
2.51.0

