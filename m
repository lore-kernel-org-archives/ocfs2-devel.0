Received: from forward100a.mail.yandex.net (forward100a.mail.yandex.net [178.154.239.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B30E2E2DC4
	for <ocfs2-devel@lists.linux.dev>; Mon, 13 Oct 2025 10:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760351918; cv=none; b=RKp7n/gKZ2O1ScXHloY/H9zSUgtPAY+gGtSGX7gIpAO9PN6A3rJrtbPWZkFJGfpCE+lqACDeZbX82RIsHUHKo/q96X8U+BoJP4y5r8FMN3JH0+4TlXD9Xq9GjwmRBajth7O3kidniVqdxvtBqSeCLk6TWA5DNZsJCNKbb4p17WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760351918; c=relaxed/simple;
	bh=fAAp1hNHN5d1YGPNLsOdjOGRIkAPsS7hWfNjWVzHc2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BwwPOwRjx8DDIJt3GJH6oyqnlhCXiEUVga0CURCd6/KhvUg87AYX2UrK3qozz4+I470qzDndvjCych3iAdN2ZSS4pc5JYgWe+cDhTtbPApYAY8jgr5B5zFKxGWpd3/h0sSyVF104IYFn1++9alr58zA6V9q4h7vHnDJYIW67SkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=nQUT7fIR; arc=none smtp.client-ip=178.154.239.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="nQUT7fIR"
Received: from mail-nwsmtp-smtp-production-main-64.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-64.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1d:2a1c:0:640:8b3d:0])
	by forward100a.mail.yandex.net (Yandex) with ESMTPS id 7FD98C0078;
	Mon, 13 Oct 2025 13:38:27 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-64.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id PcLCwZOLxeA0-YV5rOQVx;
	Mon, 13 Oct 2025 13:38:26 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1760351906; bh=4q4FnW+oosFlbISp7IPu+A+S0xKZAUykkjP+42fG8m8=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=nQUT7fIR9ByetOqxjvffiXbBADK3wJR+B7+S/eQpLu5JILQvmzbi9XHMX7WO8NbEf
	 qwZSI6A7pz+kUsGy+noGNWcmsZymDjTaxNUCG7sdonp5kCC8YVe7o7XDsDPugZv344
	 wK1euzLlEtsfyf2YVF4DaA+hFbgyoe+Gyi9CtLjI=
Authentication-Results: mail-nwsmtp-smtp-production-main-64.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+ded9116588a7b73c34bc@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: add directory size check to ocfs2_find_dir_space_id()
Date: Mon, 13 Oct 2025 13:37:09 +0300
Message-ID: <20251013103709.146001-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'ocfs2_find_dir_space_id()', add extra check whether the directory
data block is large enough to hold at least one directory entry, and
raise 'ocfs2_error()' if the former is unexpectedly small.

Reported-by: syzbot+ded9116588a7b73c34bc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ded9116588a7b73c34bc
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/dir.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index b9bf1428a3d9..3c2dacba9b0a 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -3444,6 +3444,14 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
 		offset += le16_to_cpu(de->rec_len);
 	}
 
+	if (!last_de) {
+		ret = ocfs2_error(sb, "Directory entry (#%llu: size=%lld) "
+				  "is unexpectedly short",
+				  (unsigned long long)OCFS2_I(dir)->ip_blkno,
+				  i_size_read(dir));
+		goto out;
+	}
+
 	/*
 	 * We're going to require expansion of the directory - figure
 	 * out how many blocks we'll need so that a place for the
-- 
2.51.0

