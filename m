Received: from out203-205-221-240.mail.qq.com (out203-205-221-240.mail.qq.com [203.205.221.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B5C18028
	for <ocfs2-devel@lists.linux.dev>; Sat, 21 Sep 2024 01:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726883678; cv=none; b=ZIDd/Yb46w1YiYPKK4K2Az59suHqX4rwxuZ0iqf9XwP+OyKPonVppARR3i0hgaFoeVLo4rroIKpFuAzqNT/jtn8d+OjMhmMtpRBPnl+sJw/CJHUauxpY4n148CFB6da5+ym4vZAPSXSbJPgj+KFRyJo5Uc08sZoEFFs5n3zYOYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726883678; c=relaxed/simple;
	bh=7/8g2fuAgVMHqexzRbDHmS2bUPStYkoDrWwV+VcVOBM=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=nlCQ02QVfZVND8YQJAaxPr1j11eB2FAXXw2KfORWov1zJhbPc1fiy6O6TYT9z1wkSeR9dIjhySWSjIJevX4bIvwTr//3odDUQvfMO9I6+5YCEraTwHGsQZylHWux431GO63cnBKw1m6OuIlUf+ivvu3DtEMF8APfNp44ivvwTng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=CUWQ22J3; arc=none smtp.client-ip=203.205.221.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="CUWQ22J3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1726883668; bh=UJiFXwfKAlpBJRYBa0OheelTVuEqzt+wTSFRaUaUYG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CUWQ22J349OgDjgcwLgfeOnG4ahROrXvh7/hqKgRSEQPg8u6Reo2L5P+1TQQ7PcS3
	 8CdX/SkDhCGGYOQ30DBEbbZ0hHq9/5FUsG0MAXCr3n12ADOSd8/JvhaFecfDpSwYwU
	 +7MRXQUI2TE65ERWQLmzC42AgTkl7iUg/gYFgzCk=
Received: from pek-lxu-l1.wrs.com ([111.198.224.50])
	by newxmesmtplogicsvrsza10-0.qq.com (NewEsmtp) with SMTP
	id D8E2A6A4; Sat, 21 Sep 2024 09:54:14 +0800
X-QQ-mid: xmsmtpt1726883654tjo3above
Message-ID: <tencent_8A28BB01332A9E381B7A4BFB1BAB2512BA08@qq.com>
X-QQ-XMAILINFO: Nfm/+M6ONQ57hLVtYhHNwGPDLymwCYniO4ZEeGUKWTkj8lpEcbScnh1BWezX9r
	 tqs/BVz+oQc+79Cr0Ierz+VEKs0YsBnXF4xQbMnjJtYT/J7Mm5Qxdfl6AAcv5naolXdwxxkGpmnu
	 FvIn08XokgWp7jr0s613FtVIohSs41PUUs4SSiNnTNlghdp/1cN5JD8qi7e3+xUc8NmsnH/a4of+
	 OPAJ4HSA4X9iv+JFepeqEsrGF6gIsh1/nfeZz2ci4O2dBlUAFTMOsWdprXRyTATfoG/IW6dtBoGT
	 r/IDXuG3t7wyuM8MOV9xSGKPiv26Wk87EtRqASz6FuP+fmqyBfsn/nb+a8OPCqE2YcxYvrOkntre
	 gz2NEI8XEXOT232ZBmN6v9tMApu6Uu9rgKjN2Dc2s6TO4S8gCdehgAufJt1RMt476LrjryqPlXsX
	 Fqsh/fF5+PTowmmpQaT7GSlzanUp+kJuggECeibIQvwzJ2JR4T6nY+ZU5zGHDrdnOn4w6m3TAwU6
	 zGqANAAk7vq/xPEYgOQRvpYw+ELGwhd8/wGhm/Iy/lAOny+47j8Kq5b0dx/z+Ob8ovoLYjq1TlNO
	 sHY1Ve+3v+gLUfCwqfZnD9GQ7CFpG6zinrPNbq9O47oYSscOYmlVzPurS/sPetFLYDUANdDjr/gW
	 e37sX92QJW7sTGZepZZgc4JDzLuVaT77aJ2zs/s50FyGOuGRfJ94EK57Y/WfwyYOWqNDVHht6g/L
	 xwYcLnQBZvpLbuFws+3T6h1Gda6jfEZmDExNPKUd+HjJGd2xwZiR3h7CgcMy2y3vee/COVSQgWL0
	 NRadaLbAm/UMLnVwLNZl6HiMp4XxbgXlksgfnQ1aWqDtiwlr6JVUB2rF/GsMOyvIN2uUoFqIJfD4
	 qrQWTmiA/pSjSieJ8Xx9ZSkuOm8d6944rQ+15oMJA9tM7wH1o9c6gRkffEdulUkQ==
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+0e4e71041c9609d922a2@syzkaller.appspotmail.com
Cc: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [ocfs2?] WARNING: bad unlock balance in ocfs2_inode_cache_io_unlock
Date: Sat, 21 Sep 2024 09:54:14 +0800
X-OQ-MSGID: <20240921015413.1196597-2-eadavis@qq.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <66edaf4d.050a0220.3195df.0000.GAE@google.com>
References: <66edaf4d.050a0220.3195df.0000.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

remove excess ocfs2_metadata_cache_io_unlock(ci)

#syz test

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index cdb9b9bdea1f..e62c7e1de4eb 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -235,7 +235,6 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 		if (bhs[i] == NULL) {
 			bhs[i] = sb_getblk(sb, block++);
 			if (bhs[i] == NULL) {
-				ocfs2_metadata_cache_io_unlock(ci);
 				status = -ENOMEM;
 				mlog_errno(status);
 				/* Don't forget to put previous bh! */

