Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AE0125A9
	for <ocfs2-devel@lists.linux.dev>; Thu, 27 Nov 2025 03:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764214094; cv=none; b=PDc7UVyDKBRj0r2ZpXIbF2FonwP7wogULxO/jzjzp+eL4eyZ3Fl/MqAc43EbsIL08G4p96GeZROYk9c6LIXtQCb1nIqmJSFoNhW7rg+qWF2E/Ifqi0JVxv/CDQQhlP6zQEUMWH8ThVEZAU1n6+W4V/dsgsolGoh9TcHiGQhq588=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764214094; c=relaxed/simple;
	bh=2KxJyX4lqSf5767fDUj3V9HhadTgg5nd/kaSCbL3sb0=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=XACrIenxrFcVSCq2y9w6ydgXTsbs3yzXTQ8/hBcUcVwK8DcvFXwdVOCeWVpclF3HXcYlszzfzjT27BeydMxho3EwTosWJIxsB31SyWqdWdnGy4RH+GP1iVxzH75QiwVvHqELdqE2zfmUN2CbQ20EdxonqmBjIQPTCCuxM9nnSE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=vQ/tPh/s; arc=none smtp.client-ip=162.62.57.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="vQ/tPh/s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1764214079; bh=pBwqlKLH9THCP/d3+Dwi8D3FgaITDU8Yf9/p/kCQSMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vQ/tPh/sEXlA+jU7SUpKR7yc/nJz0MegKkJWM9L7G8l1xUC36FzAjmRU6B5weYfGE
	 I/F50MKOU6SrzM2ZfMVZ4u6hA2BqHronlsIBP+QDqgItBATgpeTouxg2BItkkg0DWd
	 3dYIJMS4YY42H7kKtJRn4h4pBXC3Dd572SpjAEPM=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id 6A8A3AD2; Thu, 27 Nov 2025 11:26:40 +0800
X-QQ-mid: xmsmtpt1764214000thycdmp4h
Message-ID: <tencent_B24B1C1BE225DCBA44BB6933AB9E1B1B0708@qq.com>
X-QQ-XMAILINFO: OVFdYp27KdlJns2ayx7zs4wL0LVizLFC0tCxkzZRQD/uuzJ/kGtDPaSRyYxHq9
	 aJb1cXRNpKi0FMK15emwvoxPamkGJjsvl1mz7ZA9YYaYbq4jfAx+4E45U6c4wVhZ8Ww2WaXHRGX3
	 98777i1dJZIp0sBrJM2NlDwhfuGYlNfAqxuiqhQb5Dl1JhIu0tyC4A5GhWIkBlV1YslJ2N/oH/t4
	 XTL86G637C+WHYZsW7N6ToYQrSscv7kde5HAThcQiYEVezzHk9EBVhtFNjb4kTJbWs/CVAWKaquW
	 VyJ9ssKJi2W/dnYwrBryBk3nBy46jqExO1iXD/pOP13IP5q6kEqBjQREFrVrb7zXCPP/SYHIpDp8
	 AZ4TK2M3/TrN9kKHA6AZ+Vmft1hEAmNSuIgwkpRBsIfX3kW/0islCHHUcuw81TTbCH9DqIj1lR6s
	 8e6ZcElmqEE7OIxOjMcphkISkRE7yRB09b6gAYS4DnopXwD6KDi0C9/HxwjrEXDGUcCM9VXxsHAe
	 l5X7EevE5UPlXUlFJ9G9YxbvF+gi5RfBSUOXrV2XAxoLHAn5yOGam+vAr5B5fN4Iwv2qah1wnaeG
	 IxyDIhHMI2234sNrwqhovK5sF7Gxis37csxjnZOdwj+vjsCT9F6eXHpVdRY7FgHWmLKiIsAh4CPv
	 QdI/ZbTSqMuo867j3V49yZtd/5hCuz4d7yQfZbUFKpr5gRNQIfGATsH5uPWbWzVjvVBLaeXVnP6h
	 VY99knT7UmYeK8NG/+G7PVQFZBDV/TyJP0dCkh+2gSmZuC949Wch9jX+g+Q6e3jJejHtv4nOa/ks
	 byeGYhYrRpzogzAXaJOksq6SWwPRFDTo9C4gc6LTXYKaIMd8qbbYb9BaeM6NEn1BsO4tsBSBx1D2
	 3jCJruTSE4/ACNodgjFqeZoN+Mr0/CPlHprEoTSiR6V85Pg8QCgKGHgYBinCZjhTzSs6t+hzDagP
	 iPHtGNdG/Pzijwn9LfcsGpCTcEFksMV7nDfYWZBUtNyvDdbXKMs9rF+zdu4FCPZS2XaPNhjVY=
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+f82afc4d4e74d0ef7a89@syzkaller.appspotmail.com
Cc: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] ocfs2: check tl_used after reading it from trancate log inode
Date: Thu, 27 Nov 2025 11:26:40 +0800
X-OQ-MSGID: <20251127032640.41538-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6927a541.a70a0220.d98e3.00e5.GAE@google.com>
References: <6927a541.a70a0220.d98e3.00e5.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The fuzz image has a truncate log inode whose tl_used is bigger than
tl_count so it triggers the BUG in ocfs2_truncate_log_needs_flush() [1].

As what the check in ocfs2_truncate_log_needs_flush() does, just do
same check into ocfs2_get_truncate_log_info() when truncate log inode
is reading in so we can bail out earlier.

[1]
(syz.0.17,5491,0):ocfs2_truncate_log_needs_flush:5830 ERROR: bug expression: le16_to_cpu(tl->tl_used) > le16_to_cpu(tl->tl_count)
kernel BUG at fs/ocfs2/alloc.c:5830!
RIP: 0010:ocfs2_truncate_log_needs_flush fs/ocfs2/alloc.c:5827 [inline]
Call Trace:
 ocfs2_commit_truncate+0xb64/0x21d0 fs/ocfs2/alloc.c:7372
 ocfs2_truncate_file+0xca2/0x1420 fs/ocfs2/file.c:509
 ocfs2_setattr+0x1520/0x1b40 fs/ocfs2/file.c:1212
 notify_change+0xc1a/0xf40 fs/attr.c:546
 do_truncate+0x1a4/0x220 fs/open.c:68

Reported-by: syzbot+f82afc4d4e74d0ef7a89@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f82afc4d4e74d0ef7a89
Tested-by: syzbot+f82afc4d4e74d0ef7a89@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/ocfs2/alloc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 162711cc5b20..570d747a00ca 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6164,7 +6164,7 @@ static int ocfs2_get_truncate_log_info(struct ocfs2_super *osb,
 	struct buffer_head *bh = NULL;
 	struct ocfs2_dinode *di;
 	struct ocfs2_truncate_log *tl;
-	unsigned int tl_count;
+	unsigned int tl_count, tl_used;
 
 	inode = ocfs2_get_system_file_inode(osb,
 					   TRUNCATE_LOG_SYSTEM_INODE,
@@ -6185,8 +6185,10 @@ static int ocfs2_get_truncate_log_info(struct ocfs2_super *osb,
 	di = (struct ocfs2_dinode *)bh->b_data;
 	tl = &di->id2.i_dealloc;
 	tl_count = le16_to_cpu(tl->tl_count);
+	tl_used = le16_to_cpu(tl->tl_used);
 	if (unlikely(tl_count > ocfs2_truncate_recs_per_inode(osb->sb) ||
-		     tl_count == 0)) {
+		     tl_count == 0 ||
+		     tl_used > tl_count)) {
 		status = -EFSCORRUPTED;
 		iput(inode);
 		brelse(bh);
-- 
2.43.0

