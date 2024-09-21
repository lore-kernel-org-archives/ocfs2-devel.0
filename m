Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC28179EA
	for <ocfs2-devel@lists.linux.dev>; Sat, 21 Sep 2024 02:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726886955; cv=none; b=s3wquhORalhJ35c13Cr9yCerqusT9a7w3336ZSmWmluqTwX5N1HbZnYtJJDJFRQTOX0m+CbD2/9a8exJ/aUwZX4bKQFHUQt4hyvFuvDYzqRQE1Sa42IMtg5sm11Y6KmRQy6sf/7oCAUn40Z2FzxLDvCQqgTUK/oxxnCrdG3bCFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726886955; c=relaxed/simple;
	bh=F5Cc4Qnuaq4/+TFIiSCQCb2clyGJ26TQzJlfEiKKZWo=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=dr588FEZ0xus8BD7pNi0Tjk8P4MJIBJMRlDvvQyreVc1UECA4dbDbGh2vx3DWRiXV/SIN+FBRYu+r+AJ/hPUZOkdUFZjNC2NBdwppLDPz/lDkRnmdekeV2Gt0w9irM2RH3gJoAFCMWXLOiRXLTPER2ElfA5dSVOHBfSetRMRcnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=anpLix85; arc=none smtp.client-ip=162.62.57.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="anpLix85"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1726886940; bh=0+nXvJ0cpAFTJs+fwZb26FfD211gL4HLCxWS5HqA8DM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=anpLix85z6roelSXP+sDbjWBigy96Q+s36GX5ESxDFXz1u8Gk1CXq/CxzDhBhoFEV
	 W2fMl3Mfiao6gNjT0iyyAUluqY5jojlJCBeq5FASr7FDWylyAin7eZ+bTb/fk7ofwy
	 pYe17c5j3eueQvukiybiRi2AfBWEWX2WtneEjAMA=
Received: from pek-lxu-l1.wrs.com ([111.198.224.50])
	by newxmesmtplogicsvrszc13-0.qq.com (NewEsmtp) with SMTP
	id A1B9CAEE; Sat, 21 Sep 2024 10:40:27 +0800
X-QQ-mid: xmsmtpt1726886427t223q0w76
Message-ID: <tencent_E64425D6BAF8BBC833499EEE1BDC4BD41B08@qq.com>
X-QQ-XMAILINFO: Mdc3TkmnJyI/+lCY4jeTXxmHgKoCtwmy3yHPYaDt/h8VF5Ip8kmXhY2W5ngqm+
	 yvpDRP0B0VBwM7R1CPcV+HOrlcBhfufv/3PDblVwEXXLX5CAaXP6GIzaez8k3k42MbgWDaNSEIIO
	 FZHAl33uiox60tTQINGZRJ5AtFss7Y96i7DCoUS6L2LCaU05pHAARBF+1MQ3RwLRgg8LlC9iJ3wz
	 VqXqfm51FYeDMRVuHy5u3pZIQb2tfVodC/hmgi7goZ6FYPzRUgwuYMlDyAiEB6oP0yfLF5uZveY3
	 HGyiBU4ape+dABVxPygf6yey/81FGcU02jtilqCMmwTKFblCQTP3bM0AvxZbIhMu1KAolxa9rwAR
	 YZvCS0K4M1YvoIkktLv2QxJWbIbQ2yvGTdIGF7MCZ6IqdAn0A81P+iDLahGf5IjPB8MtxO5gnedE
	 kpumL/n0jJZaYxVDQsJEPXEin8nJOHy3lIzflGlfCQU3qMdZ09m/VWwh3+SWhFp0s8AF7BkXoCuV
	 Cs91FO0j5C7V0VO5LOGv2Q7jMMh79qL1X+T2MDaYTpKlPDeu9YRlvbMSL59zSjPPEew7nVhRMYfW
	 7vGKWKMw4kz5aJ245SQDVY7PS6Ivt2ZYVu6XXI5kWbMp9ardLuNtLojwKPxiCi4vDFtwTLUE459d
	 g/fiXpFMgCqQ8i1f9/iYmZHK4qn7ZKPB5heMRMtcVRPJmKGt548ub57Ehez8KtCanIDVfRxHimwP
	 sWqfnb813MfDGNfc2gQ5CpN53elqhH0SkOlMPas+aIqXMI3YaSMsjYGUpMibVmbQSM1NUgSYgDHB
	 o5N+0Tze2zG0y8ajvD6HM9loLwFFh5wLf2YQuU1Ino9Npr1EVF4fDQQtCnZkyYPHxi/EQcimyleE
	 S0q+4Had6cKP8dg0/604ow82Xf7YXh2hU14ArYqYizmzcVvatsyfsdKyY8VtM2aRapifpxefiD
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+6c55f725d1bdc8c52058@syzkaller.appspotmail.com
Cc: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [ocfs2?] KMSAN: uninit-value in from_kuid (2)
Date: Sat, 21 Sep 2024 10:40:28 +0800
X-OQ-MSGID: <20240921024027.1240120-2-eadavis@qq.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <66ed92f2.050a0220.29194.005a.GAE@google.com>
References: <66ed92f2.050a0220.29194.005a.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

use inode's uid and gid to replace attr

#syz test

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index ccc57038a977..d4be183bf149 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1129,8 +1129,8 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
 			    dentry->d_name.len, dentry->d_name.name,
 			    attr->ia_valid, attr->ia_mode,
-			    from_kuid(&init_user_ns, attr->ia_uid),
-			    from_kgid(&init_user_ns, attr->ia_gid));
+			    from_kuid(&init_user_ns, inode->i_uid),
+			    from_kgid(&init_user_ns, inode->i_gid));
 
 	/* ensuring we don't even attempt to truncate a symlink */
 	if (S_ISLNK(inode->i_mode))

