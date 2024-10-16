Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30BF206059
	for <ocfs2-devel@lists.linux.dev>; Wed, 16 Oct 2024 11:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729079348; cv=none; b=IwvVsBtkUtHmp23Fj7b4ut1Jj1XrFQiCAV4SWW7sPXFy5QrQLAqXaKDqQVCGApWTD/M/MOudrqF5GWmWgFylkQbPd4tCS2TOhuxof/JomSZ+Gyd0CspSXZFNFdN625wc7Tbyv9Twm6rZM5cfBdB7sCPk0pi+B2ss/zNtLKlRWS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729079348; c=relaxed/simple;
	bh=Hhun68pEXm1I8OMa33hp/XVM0+Fa6o8CmxUyhbGrnAU=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=tEqsl538mvHn+hm7wTWdCdjwoQW46sRxsEIuYjrVRWA8/Xprrjdq9Tfprz2ViIFKMeSSETsU2ixXwLQy4rlVxZEeK1gzeysTVyF8IAPIdaRqIY0rnStxREm1tzXmIeRJzU0ybHcoxsN2zvFreCXGpQ023/B4gD9IJd4heuWVxAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=p4ldwY45; arc=none smtp.client-ip=162.62.57.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="p4ldwY45"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1729079029; bh=2s6mvbIdK7Ylz7hH+N9PxsETej2AtREbW6xmk6nzlD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p4ldwY45v5sf6082+5tMkRKIdKtumhJ8eYmiYpDzjzwXWJTgJk36wzTPrIYwYQT9f
	 SJZcXIXE/MpCyO+mqt0K+KJ1XiN9Q7B6s9GvJQpD/4ciR9b1fYESexgSkPhSmZLpMI
	 p3emNQeB+EdPe3a0dBmOWFQPd+BcgNvwqGYGI9SI=
Received: from pek-lxu-l1.wrs.com ([111.198.224.50])
	by newxmesmtplogicsvrszc16-0.qq.com (NewEsmtp) with SMTP
	id AEF15A65; Wed, 16 Oct 2024 19:43:47 +0800
X-QQ-mid: xmsmtpt1729079027tuw1cfhjh
Message-ID: <tencent_D48DB5122ADDAEDDD11918CFB68D93258C07@qq.com>
X-QQ-XMAILINFO: OM+L06Djy6i4kvMwuLOWs7T0XcPHEDqnkO3PokcFOIF7xOZu4gGH33B2UhElMX
	 Sa5lmdTCpqN3B4Ttw4XjAViPgFuuiZ1E9AaELwJ0FyW1ojseUy5nnf6PYLT7wfa5dZTkcM/FfWLh
	 HAahEtBWpWMUleoUvW3+OfLrJjwNhO03SC18iNrgJTbKUYwBotiZlI/tS2LHaoNhkS605PLYwSM3
	 SGAJmEtZQTi15AmKIU9ii5E+NBzbSy3PVY22X7Eh2dNmtLALZJlau52We5qGqh9XgnOYGvHKJZr6
	 0rwhdvLf65kz8P23kGJPaQPRKMLVd6wa5s/tK0r7Sb3bIeSFV8r6Bwpqzm+QDyO0rvlgIXfMqUhj
	 +J98/12jqzAhhOU0+Cbwk/lyWR6fSYoAf1CLjtnK6oZy7BfkM2Kj0DFT9ROkoaQvV/fKk7rq4Rm9
	 gFVdtx5upvLwwnhDl95di2BnLyfaslGP50ABN99K6fMkVEQ4Reygunoxc95TgfNuK/icAWDSWK/u
	 ohrvLffgC80YYVc/yH+a3y10hcdqt8Ktv41oqgFEfy7Pl/goRrFnWTFI+9qa10aEYMSGSaFb6Rp+
	 rV1WcUKOaLoqnTywgbi/NFw5kmj0pTyb1ZUfue89UYKvs3tdQ+AArAG4tlZ5VtH+sVwCVJwp07ty
	 4HMP97JF5l9iv9a5A8kZeTOQFOiT6sjlcYKE+bI4JwtBGBMbc7c6Vo9PimzXN26FfSd8Ct5aQzAs
	 J5pZPI3KOxZfERBEV7LoAntHrgkIe5rS0fwtZL+xETLAPOOCNVY1nxYwToNAKT3NMWfVeRYhff/R
	 ol0BjL6EYO7sCLuwYV2GK6xqLPkG0GeFk/aosKSEssa/gBzXssKGLQaT58WVByVMLOy2TmgYf2a1
	 FmsqF56GYbtuEaaX6VP+8sOhHX+zIZ+PT1+tE5AmoPokh65aFbcP8po+/tae4t+VHLP2QDXokVuQ
	 QaYnH4KVIgMIjyTTi9jxMsRP68eud/Q0Ka5duFsy0=
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
From: Edward Adam Davis <eadavis@qq.com>
To: joseph.qi@linux.alibaba.com
Cc: eadavis@qq.com,
	jlbec@evilplan.org,
	l@damenly.org,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH V4] ocfs2: pass u64 to ocfs2_truncate_inline maybe overflow
Date: Wed, 16 Oct 2024 19:43:47 +0800
X-OQ-MSGID: <20241016114346.891602-2-eadavis@qq.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <21d7a0d6-faac-4914-8907-1d7d983953f2@linux.alibaba.com>
References: <21d7a0d6-faac-4914-8907-1d7d983953f2@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot reported a kernel BUG in ocfs2_truncate_inline.
There are two reasons for this: first, the parameter value passed is greater
than ocfs2_max_inline_data_with_xattr, second, the start and end parameters
of ocfs2_truncate_inline are "unsigned int".

So, we need to add a sanity check for byte_start and byte_len right before
ocfs2_truncate_inline() in ocfs2_remove_inode_range(), if they are greater
than ocfs2_max_inline_data_with_xattr return -EINVAL.

Reported-by: syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=81092778aac03460d6b7
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
V1 -> V2: move sanity check to ocfs2_remove_inode_range
V2 -> V3: use ocfs2_max_inline_data_with_xattr return value replace UINT_MAX
V3 -> V4: rename variable, modify return value and comments

 fs/ocfs2/file.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index ad131a2fc58e..47121ee4b4df 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1784,6 +1784,14 @@ int ocfs2_remove_inode_range(struct inode *inode,
 		return 0;
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		int id_count = ocfs2_max_inline_data_with_xattr(inode->i_sb, di);
+
+		if (byte_start > id_count || byte_start + byte_len > id_count) {
+			ret = -EINVAL;
+			mlog_errno(ret);
+			goto out;
+		}
+
 		ret = ocfs2_truncate_inline(inode, di_bh, byte_start,
 					    byte_start + byte_len, 0);
 		if (ret) {
-- 
2.43.0

