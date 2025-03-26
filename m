Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9FB33F9
	for <ocfs2-devel@lists.linux.dev>; Wed, 26 Mar 2025 01:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742952262; cv=none; b=Gq1m7VmvpEmjNyCCZJ3XQsxtTFVcyaXbX1DX8sNPtyPSQq5qnfLOZA/1ys8a9RBvWyhBPIRG49MWcBXO36dvjG/qC9AUpVNCuYr6wRxK7m+SVJnlk3mCLKSZpvNsXWqaJY+7HoaZQvgnkwFwcz3mFG6mX7oCfng4NoC6X11306w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742952262; c=relaxed/simple;
	bh=Oi1Z22yZJA1yS6YPQXUV6cXCGUgnvPfPGqlZ4rgGyp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOoT4HxeyfL8lqQGvrR7M5TkpGUd249LgTO+l4k1nVIbcyb8pn6KVVFRVhnkWWN1lWH+i8Y4Eo6XgMLkS/iI3ZW5LuIeLpO9+30xkbkjF6BYORGO1rDgdv6ja8nJIlKGhICNk8nBAhf2eH42kCxMd6X2gURCvyF6hLQ+uuG/hmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VJwcNmxa; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VJwcNmxa"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2243803b776so6860505ad.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 25 Mar 2025 18:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742952260; x=1743557060; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QYrG1/OuLUFFBlcwhHmejvyl9EYkI835zqF6w04LsWs=;
        b=VJwcNmxadOCqhJmXWFH2YvdvamVsZraV6NftqD11u/1HbnzKLyz1sfLltshkFt2bDa
         H5ygQ9NjQxEABbM1Jyo5kc6+GFQa75Czfg3fxGuh72dD0MGmJIdoN2MuNo9FwZGqoa09
         hbWLAkv4csFYfcXdbCN1RsTJ+izLMaD9jhTY3O8dr4+WWLGZdIn3uujm1CSFwfohIEVA
         zq1mRbpw1yvn7F05FxOtcjVHxmnk5NrLKXI2dUxGSdF8jqN4/ofVMTgWboLtQK4YieF6
         V3q0STIh9esHshRUsy2OHEF8ziuZP+TT7wvsQ29mLHULCRjBJ8p0GQrcyww1JwAhpcMU
         H32g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742952260; x=1743557060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QYrG1/OuLUFFBlcwhHmejvyl9EYkI835zqF6w04LsWs=;
        b=EVID6PgqjnRG5ZNc/Tb6ZcBOAc5lfnbCg4dZ7RytO8flScc/UIk/wV3AJtxzKZgRkk
         trqjhCW2RukNrmEemSSVv1uJfF9smA4QR34gsK7B4WbD7Ay4m87FXU2chrbp3J4fMvH3
         hZEsSiFQBBjm1MisMm2GQyeXvI5lcSl8Y3Ndo7Zb/WT19azMujc/l+SF1K3zWhr7ysuK
         o4lDQz35RyCQd+PMWSv4xxqLHwYHgf5+it0NU3TPAaBv+iGBgneizXdAbSU2qJqXHhid
         fXkyFxDj8dFW0aOd5QeUXjLrzHKjClf+oWdZQ97J5bcIoVLeSdllR2zfLdEOPnRhEay2
         etRg==
X-Forwarded-Encrypted: i=1; AJvYcCVguLmdT0JZfo4+4myzVMZw/Z8yP57vGlCZFFhIER9nWrDzTZy7N7TtuHJ8cCdVEdktQgSny8liDv/IiA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwZaocq6l8ejcvWmWa/Dm6Dt0QRlUcBA5Ehp+MlGHLLNlJ+ChfE
	1/35anHuqCL+WpbBTgX7WPA+pSDoLLDcd65j7FgejuNFx8OiZTnR
X-Gm-Gg: ASbGnctwgSxz9LD7bRBvmc5XzeUl02vq3NMsa7+/TDEbdBYj/ROv1N7Ki2qYBkVU7qX
	/c4A6X7BlSn+47Rr+axYx+KJiFVtxCwfujE1o2ZXjGaCskBtgja5gXEkyL6x1jDABqT4geOcESJ
	AMwfYO9wGR837JrxFkh4sNUg1hYfIihdOmVw+7NgnsnJyxnjnXwg6OKEi85O4YRWqect9LnoVXN
	CWv6YKdIV4Mp7vhK6SJ/7chYrWc3n9q6UVYXm+SgFWt7SHIBeE3PsJw2CdcRu/JF3FBAT3Jjlxo
	yJ7J7/jESgV2SFrh8p4oG4GHUlQo87f/bGNKwtEx4jtzJDXfiR18JP9en3FxturOxtmmAcc0mQ=
	=
X-Google-Smtp-Source: AGHT+IESWh02EZmuZOrl611kqR40Qv2PFZj3Zdm4xfFDbMryIvQlaRN2oCSf3GJp4xI81j9HNKdmgw==
X-Received: by 2002:a17:903:2346:b0:224:5a8:ba2c with SMTP id d9443c01a7336-22780e1a5a7mr219092775ad.52.1742952259887;
        Tue, 25 Mar 2025 18:24:19 -0700 (PDT)
Received: from vaxr-ASUSPRO-D840MB-M840MB.. ([2001:288:7001:2703:7cf9:c75d:456:248c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f45a06sm97962765ad.69.2025.03.25.18.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 18:24:19 -0700 (PDT)
From: I Hsin Cheng <richard120310@gmail.com>
To: syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com
Cc: linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	I Hsin Cheng <richard120310@gmail.com>
Subject: Re: [syzbot] [ocfs2?] KMSAN: uninit-value in _find_next_bit
Date: Wed, 26 Mar 2025 09:23:56 +0800
Message-ID: <20250326012356.9099-1-richard120310@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <67ddd191.050a0220.25ae54.006a.GAE@google.com>
References: <67ddd191.050a0220.25ae54.006a.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

---
 fs/ocfs2/quota_local.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 2956d888c131..c0bbfdab40ec 100644
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
2.43.0

