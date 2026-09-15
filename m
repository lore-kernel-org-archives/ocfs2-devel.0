Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93E03DF01A;
	Tue, 15 Sep 2026 15:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.133.104.62
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789484873; cv=none; b=g33+q0o8kIyY5tk/qq5Ob2ttZRy6dnfsPEqcgWkLhj8wBeaHR6zTyEf1/m62U6wnIkf/yanfwx1xEcO3RIrK5Y7zNcUv8FnwCUwfTCihKWaccIccP6Q9naYKHowWsml9uOQMjHEgLi2jqgTtwoc4uR88oY8RKwAjJadqjTmvKEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789484873; c=relaxed/simple;
	bh=PYhg+lZHLzOdUosWz93zB8+JUnSqXWBu4/OVfDYhwCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZRSKGWhTWy8CmqkkJXx8Nz33OVSYG4icVwsl1ish4P5HiDctnzaOGqzmD57LuPsVQ5uZUWJBnZjt1NDYo9gb0XtvfSAkb/2fhYjLZ6by2LlKO53LuP9ZPDLAtAEKJeO7juEknGUKw5j92iWwxY7WSinKPoE7aHqmXSe5VfGczE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iogearbox.net; spf=pass smtp.mailfrom=iogearbox.net; dkim=pass (2048-bit key) header.d=iogearbox.net header.i=@iogearbox.net header.b=lUmtdg00; arc=none smtp.client-ip=213.133.104.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iogearbox.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iogearbox.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iogearbox.net header.i=@iogearbox.net header.b="lUmtdg00"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=cIIBMveQ7jKi3fZhD2t+SiOVvv9aeAZjOxjJNUxRtp0=; b=lUmtdg00S30tu+4o34cmydhE3k
	hv3gR+2RWAhC0sW6Xdj1F6HuyxvW6fG/d87Y3//keDC1uh6QzYtcLJfm5WzUYbsuVN3JJxx+yyTWb
	gRMkfoa3bJ6bdnDu9Fkn99o7IlwGcPBsbKKivc9ecFJxbJKhXNqDZkvFBt9wmwqhu5pSa0j8CwgfH
	M/DHk1cs2Vj0bK2ItQkklYS6h1U/9TnyHT8EYSyoIrkfnaf3Qrt8OMEN8CrWCeBNrcnGBpGHD41EJ
	kr7tYDyqtcqocm6wzy4jZt3+a0JjfTjqfGZvcWIpPHpmVc0uxwD+9NhRGusXBCjlR0yLq7yqULz3o
	X7zQXG0g==;
Received: from localhost ([127.0.0.1])
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1x6Ul3-0007Jt-2r;
	Tue, 15 Sep 2026 17:07:41 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
To: alexei.starovoitov@gmail.com
Cc: brauner@kernel.org,
	dwindsor@gmail.com,
	john.fastabend@gmail.com,
	memxor@gmail.com,
	kpsingh@kernel.org,
	matt@bobrowski.net,
	bpf@vger.kernel.org,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH bpf-next 1/8] ocfs2: Copy the xattr name in ocfs2_initxattrs
Date: Tue, 15 Sep 2026 17:07:32 +0200
Message-ID: <20260915150739.284189-2-daniel@iogearbox.net>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915150739.284189-1-daniel@iogearbox.net>
References: <20260915150739.284189-1-daniel@iogearbox.net>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: Clear (ClamAV 1.4.3/28124/Tue Sep 15 08:27:28 2026)

ocfs2_mknod() and ocfs2_symlink() ask for the security xattr up front
through a struct ocfs2_security_xattr_info, so that they can size the
transaction before setting it. ocfs2_initxattrs() duplicates the value
since the array security_inode_init_security() hands is freed on return,
but keeps the name pointer as-is, given so far every LSM stored a string
constant there. bpf_inode_init_xattr() places the name in the same
allocation as the value, which security_inode_init_security() frees on
its way out. Copy the name alongside the value and free both together.
This is the only special case wrt xattrs in the bpf_inode_init_xattr()
context.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Zhan Xusheng <zhanxusheng@xiaomi.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev
---
 fs/ocfs2/namei.c | 2 ++
 fs/ocfs2/xattr.c | 5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index e9c7774ccf91..e24f0e337a56 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -480,6 +480,7 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
 
 	brelse(new_fe_bh);
 	brelse(parent_fe_bh);
+	kfree(si.name);
 	kfree(si.value);
 
 	ocfs2_acl_init_release(&acl_state);
@@ -2068,6 +2069,7 @@ static int ocfs2_symlink(struct mnt_idmap *idmap,
 
 	brelse(new_fe_bh);
 	brelse(parent_fe_bh);
+	kfree(si.name);
 	kfree(si.value);
 	ocfs2_free_dir_lookup_result(&lookup);
 	if (inode_ac)
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 35bcbb0ff607..d83840b6bed9 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -7524,8 +7524,9 @@ static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array
 				    GFP_KERNEL);
 		if (!si->value)
 			return -ENOMEM;
-
-		si->name = xattr_array->name;
+		si->name = kstrdup(xattr_array->name, GFP_KERNEL);
+		if (!si->name)
+			return -ENOMEM;
 		si->value_len = xattr_array->value_len;
 		return 0;
 	}
-- 
2.43.0

