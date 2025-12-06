Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C381199FAC
	for <ocfs2-devel@lists.linux.dev>; Sat,  6 Dec 2025 12:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765024301; cv=none; b=jww1SiDBFzPr4X3Q0+zhRVQU0i3avc+NHYctZ7FIHAAXqeqD6a5L539rv8TUmCipeE4mGdbc56B3Tq1+jD3Fbc+SMXCxqUKC7OUfQbbszuuU75zPpLPErXy2MryYwZdatmhsZbSy7d7jRHTNDA/gC11G4Tf1zwRAdSUFTE5K1Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765024301; c=relaxed/simple;
	bh=qPyv+FhaSq47XVLsCXQLi9CDfoboWzwT/pxzsncu2BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCt2cO78xSZwt8Sx7TheqkZAPgDY6/yKrtbJEYp19PRXVv0ytgaj6YliL3A4NAv++FgnYwvlREaKU5nu77sv5uXr0Po2ESwG9v6WEUHf94Ny4G62ffATRQQaJOrMdrUqT9+W46PDDiGIywrHoi/hxW78/zDlu9nvnL+YbNgbZGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R2VRct03; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R2VRct03"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-343684a06b2so3069858a91.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 06 Dec 2025 04:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765024299; x=1765629099; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MQ6sUIQeO9wN86/IeO38lG0jZ2ssRJIsnfgLRfSeJng=;
        b=R2VRct037tB1C9P0gT+bWe6VBsTdKR5D2J/bl9wqK36hNg/kNoKQJVOGO3a9iXNi8d
         BP6KfUZMLY5PmL5lE2DfQT93BziLNSrsOEq2yQ3zN2RPKl8VkvV/IYaEviwy1VGe8RzE
         WF1sBh4f0HAd4RPZVibm3H3RazUMlbfZVqXYxcgHEvMOMHJPWx5VClv5zlquwY3bMBGK
         Kirdq+lzDXs4KpQWBdy30Zgbx9/iy77MDX+3tTjADp/xtyD5LIp6FOnbqYA0i/CEmy23
         fzmFcN7hJlQWRDOkauhP6nT/ZxFjXQIzvWfbh1P1lF7kDLijdTvgGoXEX9xH4AqM2Qmo
         zNUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765024299; x=1765629099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MQ6sUIQeO9wN86/IeO38lG0jZ2ssRJIsnfgLRfSeJng=;
        b=XQoYuI7UyPrzNy6WSOoP5tPhI3yZJ3qrSZOlsl240PnzYSby4Y95cFX90M8wLEk+5o
         iEgP624Og+IJ3thRLIBVnlFZKzwkDTD164catLHPtI5pTlj9KUSi6OV+W43P8E5QQpW6
         4AT+0sgn1zG0OFm8IfZXxapIrdJWZPSDPyZxFcEHJnawSbuQGy79AAL3VSyBAf7XZpWc
         unJsQxolr0clFSj57dvwM1OZ0kckI7hCJsWP4QKyNxr3lTgOAEN5xWqn0KcDIkYI4k7s
         8zTGmxITAoJpKL/FklYTIXdnWkH0Fn5dDWiR5srD9G9UflXfVgT8uKD5CBTE7J1qo5l1
         jBug==
X-Forwarded-Encrypted: i=1; AJvYcCX5fk230xIVNFYcDioJn+McBtpbo4wITO8rCCRaEhWZTNQtO8exSa8t++0FbJxRzhjIZ4PHk4OkOmdRNQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+f0yLwUVabtvDS8ofiaShOBdR+8OVtOXgdTt1S/sxrDimaqRM
	p/MmtDWq3Dx8WJXiOVCHmubH4iv9mpFHt1pBhZ02FZxzcBmiRnM0EISw
X-Gm-Gg: ASbGnctnO/4lXVP4DCeQNXbvspTDVBl/ozMAH1WmUPFQmalgSyLpMRjQR1I1FQFlQtU
	xe8tLwUkiPmS/8Q1TE4+Ta0RUmjPeV+sTzO8PtL8oOKzd7Rl0QwVlfJuhTdrOyb/jjmhga45qjg
	g/b75pkrro/pkMdXQ4cOpCMUi6+nJEbvW+pNptPj37IRZ8sQLRGTt+nKuV64yEtSI6zPQicqrks
	Pii27aKrUKaEVgFIZr6P3Eeteg16ycbyEkMz2vUO5KKXbvFuRRwPyL1UkYtKyx3LHo1ivtcIdmw
	ujimiujTkkb4Ygrq77rXvyZ2xaX22XSSL46Vj31KQX82DvyIqrVwS02RBVZlZbv7ss/IjBeQrl6
	SVLKDfeURuKFYQyKYK5ny9KYgQjczccX6SOLiAI7qvcT/5+mTP27CYxvn5PP+ZEE/Lk8dxfly+E
	CIeyvRz37pDxCBa3w/SuTsW+0JdQ==
X-Google-Smtp-Source: AGHT+IGtaB0EGCaAK2Wt9cTECFElyS6yuLR2Hf6WAOGYhBpxMm2ZHQxuY++ypKoDZzes/kdKOWZ63g==
X-Received: by 2002:a17:90b:350c:b0:340:ec6f:5ac5 with SMTP id 98e67ed59e1d1-349a24ec644mr1681359a91.2.1765024299363;
        Sat, 06 Dec 2025 04:31:39 -0800 (PST)
Received: from localhost.localdomain ([114.79.178.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-349b601646esm1265194a91.3.2025.12.06.04.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Dec 2025 04:31:38 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com
Cc: linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	Prithvi Tambewagh <activprithvi@gmail.com>
Subject: Syzbot testing for ocfs2: Fix kernel BUG in ocfs2_write_block
Date: Sat,  6 Dec 2025 18:01:26 +0530
Message-ID: <20251206123128.166117-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <66eb6a0e.050a0220.115905.001b.GAE@google.com>
References: <66eb6a0e.050a0220.115905.001b.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 24172e0d79900908cf5ebf366600616d29c9b417

Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
 fs/ocfs2/slot_map.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index e544c704b583..de793a83555c 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -193,6 +193,16 @@ static int ocfs2_update_disk_slot(struct ocfs2_super *osb,
 	else
 		ocfs2_update_disk_slot_old(si, slot_num, &bh);
 	spin_unlock(&osb->osb_lock);
+	if (bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) {
+		status = ocfs2_error(osb->sb,
+				     "Invalid Buffer Head Block Number : %llu, "
+				     "Should be >= %d",
+				     le16_to_cpu(bh->b_blocknr),
+				     le16_to_cpu((int)OCFS2_SUPER_BLOCK_BLKNO));
+		if(!status) {
+			return -EIO;
+		}
+	}
 
 	status = ocfs2_write_block(osb, bh, INODE_CACHE(si->si_inode));
 	if (status < 0)

base-commit: 24172e0d79900908cf5ebf366600616d29c9b417
-- 
2.43.0

