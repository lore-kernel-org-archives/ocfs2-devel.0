Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19551537FF
	for <ocfs2-devel@lists.linux.dev>; Wed,  9 Oct 2024 15:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728486378; cv=none; b=udDYYWmpQO4Eo1fG2511Ra7Zn19lpGApKUMBczSfMPryclfg3Kcj8t4E1tX1bE/njzBu6JpTovw9be49YYkL9SF1CCoikhQIiOG0tGWMg3fRhc8Eo7AZ7d9zTibJ0CjeGas0BG42oNKjn7HxblOOorKz5XMbxXOfEcmgxmH09UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728486378; c=relaxed/simple;
	bh=lxVkjeqcgTi8Qj7Tn7qa4mbaz/3lmo0ODYWBOUdIDnc=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=cTLirK91Bza8gfzFBhOYo4VNv2Vvxhz9rEagaaqGSLCDOuVpURY8WEWjE8eKDd0YEYMXanfnfGlhFq1tTESNLTQ/SqNsSiE3lD2MyG811hBQE6v2fyOYYL5d1UTTQpGLnn3nXjGeYUvpptSvPNqZNeV8cWdN/C+ynE90EPWUflA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=ePBUSZeS; arc=none smtp.client-ip=43.163.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="ePBUSZeS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1728486364; bh=3AcLT5cVXlL+9HeGz8dpIv8K+ePt2O9N12m/C3/Kk08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ePBUSZeS3RDkTFFRysi/WpD5ahkra3UrSuOLIvtj0k8BuruBSmkkCHbxhjZ5toUId
	 qGRUVwjpsy1jFqU4k/iZQyTQ5u0gOjz+JYCm4MzNhMopkbJtUCYBBknoSwCj9f/M0E
	 dCv4rucWWw1jbXg08s1/hh24VrFxhlW8w+0RaZzs=
Received: from pek-lxu-l1.wrs.com ([111.198.224.50])
	by newxmesmtplogicsvrsza29-0.qq.com (NewEsmtp) with SMTP
	id 1692FA11; Wed, 09 Oct 2024 23:05:41 +0800
X-QQ-mid: xmsmtpt1728486341tfhqsg3sh
Message-ID: <tencent_B22CA96C8896C0E9FEEFD2CCAC795A6E500A@qq.com>
X-QQ-XMAILINFO: MR/iVh5QLeieHUBSR0h8MKTmRH3ISJl68dnigd3jpclZS20rbXT0/ttlcbcMFI
	 gK//TnHGsv32S1q7sFEx9Y+zyP+W9F9ZTlBsg+6XWSlcxoHw+HE6Co3hxnCMu77ItqfhDDijEV6I
	 72eYEQwUi+nMEYSTabUN0oSid4xRX+R+sQ7u3JNSU4JWMWTJxTVOwiC1RA/fGzqF6KCUzfMAxANg
	 uiN0Izp0EeoGIU9Mnch1/iUWSXbM3g+de5M8aQsuCuPR2Mf2gBHKJPeoyyF8uBmXb89K92jwxkbu
	 92J0ooryDs+La65F1M8eWAYn8fcZJ2kH5gW8nKdRPCgBmfppOSdDnGDmr+y9MOfpPbbGDyo4cgAy
	 9OJ2GyPO24bh4lE3qIojrwBBFKfsWRaFcrLc92Nege9kPUE1l9ZcmAFfJ1WfLDXTU6HL/mv0qqHv
	 0Z9iBkkN5Tbyq2K3IbRzEPG/LddoXwNsZsbeRzh9VpkUrJlYsaEYvdXuoAFWzVjvyEScYOJsguhQ
	 CgpkBACMAIQs5zJroUD2IP7Su6YJNnC8owU3JQvH/GcDX9dLZhoxFwaDuM1Mq14KbAE7xzWXr7Rs
	 aUgfj4VzTF959DyWV0fsrteQfks1/JnZKXj8yMhW7O5e11K6gkaT3vXfPvtJJpDZQsLl/jxjIoZ9
	 yofO0WFIV4YEY9i4JZi8IGh6XG/BICTMbKb1QANtpMuIL77OKrR8yAJ/2yLfmOfguiZFmDKxPLTS
	 5S4aSNc2H0MCFveUDzFkXkn1ye+hWjbM53TupQGXlsfTr2wycNFToa0dn6XI4VjHX8e/8OFL5+vQ
	 qiRCew58ZrETs9CbkrFJufpmt34sxHmDbcsUoKi8bu/6hF0v5L6R0kzIYcDyuXSoTRKHfjvjZfax
	 oAESi22fF2r5DQGlaNHBa+4mNohMJx/Jv3YnKxEgrxGC1G5l5R+MVrP7v3txA5bjPhE0MTMwjf6u
	 jlSZgHcH8Z3GR27vEvciRsvEOEWPU0
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com
Cc: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] ocfs2: pass u64 to ocfs2_truncate_inline maybe overflow
Date: Wed,  9 Oct 2024 23:05:41 +0800
X-OQ-MSGID: <20241009150540.1595244-2-eadavis@qq.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <67062030.050a0220.3f80e.0024.GAE@google.com>
References: <67062030.050a0220.3f80e.0024.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot reported a kernel BUG in ocfs2_truncate_inline.
There are two reasons for this: first, the parameter value passed is greater
than UINT_MAX, second, the start and end parameters of ocfs2_truncate_inline
are "unsigned int".

So, we need to add a sanity check for offset and len in ocfs2_fallocate, if
they are greater than UINT_MAX return -EFBIG.

Reported-and-tested-by: syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=81092778aac03460d6b7
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/ocfs2/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index ad131a2fc58e..ed26ec8ac6b6 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2117,6 +2117,9 @@ static long ocfs2_fallocate(struct file *file, int mode, loff_t offset,
 			return ret;
 	}
 
+	if (offset > UINT_MAX || offset + len > UINT_MAX)
+		return -EFBIG;
+
 	if (mode & FALLOC_FL_PUNCH_HOLE)
 		cmd = OCFS2_IOC_UNRESVSP64;
 
-- 
2.43.0

