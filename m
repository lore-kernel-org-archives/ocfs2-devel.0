Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219B52853F1
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 03:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764647570; cv=none; b=p1THi60vRVvk0BCpleaou4HQpQPlqg3oFh6xttk0blNJaoGvoZFYQ+f2EgnRcbkL0xUhn7D3UEbTa1J/IQs2mMf+z58IrloIK4+3JrVxsqQ8wPxS8To2C9yNeReJhMEfSCWdCwCq5k/qCNO5/SND1P4nkj7s+mxIahDD7YBnBlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764647570; c=relaxed/simple;
	bh=pkXKG2GQvk1OEM7BRuyJtmnfW0wRTjwlafvcYL/JLdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1mVqTm4nru9rce6/fo02Z7oy0xbzQgYBi7e/+Kf3JOcoaslk2xQna9YvlPvAcoeeKO+a3SqXqRxhkhO4M47Sq18/X6MW08U4Es/35gYUk3DFIub3e7wwKS6KjIPC3VDHZXivG2W0qc80UW6lfF3hyu3ni6bxw0qT066488Caek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mkMfaFZU; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mkMfaFZU"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64080ccf749so7336193a12.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 19:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764647567; x=1765252367; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P8o+Eh8EpW8XhTpnWYxXlVactBs+R1cj59cC43cOEtg=;
        b=mkMfaFZU/IWlZqOehAvHSZ8JCx7OLqrnX411Se1PDyAoalLxP6mHMB+CFDGR3sGzyT
         h9MPvqoKjxYxaYyWqO1C6mFB5gPXOjJ4Q6CweCXjdlnVZ4jsnED+477YB3ULN6u/nh+5
         1NJt3WlKGzQ3LNsTRtWyBb219GXhbLuTS/pOFVA2P56T6RISpbgorQrtcUW5ngb2RpxN
         CeuVwdbRlDQP0u3l87UlP9Vrsd8G1MtMPo2kCQKvOCcXXxGpGhM/l+Yo+VP/57h6BTUd
         xiyPLsncAkospcDBCVCs/x5YuYkposXJ9pC9UD0Kwn8wJFPNH50y1jFQ6FmwMpRLyEHV
         +r4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764647567; x=1765252367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P8o+Eh8EpW8XhTpnWYxXlVactBs+R1cj59cC43cOEtg=;
        b=rOc5zlQvJEfJgO+dUZCJWfewpwTfquBXxGH5mGcz0oHuZk0i96V6cQJ1HMy5BSiV/E
         FrWEYmb/EI6kM4vwkONqWWOMIo+7c83pmXftpPQngPJ/MCtTqtb0UXFoB89Ujyhdi/F1
         Ymx/B4Ryz/pdlrwYYrJxvHAuqrHCW4Ri9JGE+zJuYQr5pKYSpSDioPLHyeDMhdCGLv2T
         0eLNCPYNw3IYUdNBlvMly8Q3swQK7B3/aeKtAFeDpaNp1ecsU0c9Gn1CRacvB5AbRDE1
         WnYfXddPi3KD8920P+jG9OYaXR8lRHpYe6kUEcGsT0xPecUeMHyLm79m6lBGF/Pp1W0x
         pkBQ==
X-Gm-Message-State: AOJu0Ywd3ngxlthSDEiSFUUi0Yqzjy7aX851RlcT62NNHCoUYidP0MwA
	+rc9lNCbZSHjwCY4KjOUH7GlrZ1GwDbTSfFileL9QVQTy7lntGxU825o
X-Gm-Gg: ASbGncvyPjNP/JnYGnT4iXfl+0iwsX7Lipq08Cgujv+VFw/cyPQqkj7YOcfad7fGJFl
	ochRwufgtNmV/D3MTpHOkus7i8c8YuDpgd/NyZC5Lls/P7H+QIKaHvKi9flgKamTng7CcTPQbeK
	fzgXSGy8PXOx961/4uPzl2WMoXB0TC3Q2lNDoQZEi5vghfc8v8EkgJq4QhCrzymD4nuqpMlyNGC
	vlkCcAa1KfXd889uEivBxulAbd6yitRGIMWiu+7itdnC4wXYRRN0whGcI/7dQqoVXuj2dMIR4/2
	2+QLOb/x7v0N6uWedf0xKjzqVX7mESQrsbFLmXcVtnd9CuXGnh8WIltffmJyYkDvvC9QH164NCa
	h3YYFVnmZESmgx3zhnn3W8lTuYMniktMHrhPo30lPWnjC0Gr8oGW0H0n6lb4sBjJvUx3S/9qToo
	afRWFY5Lovgj8=
X-Google-Smtp-Source: AGHT+IG06jGTfFPngWqU5kONNdXZ5AeL1NtkquBXAeYGQwQ1JA/HugAKi8S5UOBcmoblocgG3NCdkA==
X-Received: by 2002:a17:906:2612:b0:b76:b632:1123 with SMTP id a640c23a62f3a-b76b63214demr2491416866b.42.1764647567357;
        Mon, 01 Dec 2025 19:52:47 -0800 (PST)
Received: from eray-kasa.. ([2a02:4e0:2d14:1a1:8eee:b306:2d20:a328])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f5162d3esm1419648266b.8.2025.12.01.19.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 19:52:45 -0800 (PST)
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com,
	skhan@linuxfoundation.org,
	Ahmet Eray Karadag <eraykrdg1@gmail.com>,
	syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com,
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: [PATCH v5] ocfs2: Invalidate inode if i_mode is zero after block read
Date: Tue,  2 Dec 2025 06:52:14 +0300
Message-ID: <20251202035213.633096-2-eraykrdg1@gmail.com>
In-Reply-To: <20251108120133.37443-3-eraykrdg1@gmail.com>
References: <20251108120133.37443-3-eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A panic occurs in ocfs2_unlink due to WARN_ON(inode->i_nlink == 0) when
handling a corrupted inode with i_mode=0 and i_nlink=0 in memory.

This "zombie" inode is created because ocfs2_read_locked_inode proceeds
even after ocfs2_validate_inode_block successfully validates a block
that structurally looks okay (passes checksum, signature etc.) but
contains semantically invalid data (specifically i_mode=0). The current
validation function doesn't check for i_mode being zero.

This results in an in-memory inode with i_mode=0 being added to the VFS
cache, which later triggers the panic during unlink.

Prevent this by adding an explicit check for (i_mode == 0, i_nlink == 0, non-orphan)
within ocfs2_validate_inode_block. If the check is true, return -EFSCORRUPTED to signal
corruption. This causes the caller (ocfs2_read_locked_inode) to invoke
make_bad_inode(), correctly preventing the zombie inode from entering
the cache.

Reported-by: syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com
Fixes: https://syzkaller.appspot.com/bug?extid=55c40ae8a0e5f3659f2b
Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Previous link: https://lore.kernel.org/all/20251022222752.46758-2-eraykrdg1@gmail.com/T/
---
v2:
 - Only checking either i_links_count == 0 or i_mode == 0
 - Not performing le16_to_cpu() anymore
 - Tested with ocfs2-test
---
v3:
 - Add checking both high and low bits of i_links_count
---
v4:
 - Reading i_links_count hi and low bits without helper function
  to save few cpu cycles
---
v5:
 - Clear i_links_count check
 - Log the actual i_nlink/i_mode
---
 fs/ocfs2/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 14bf440ea4df..08ce0846289c 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1456,6 +1456,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if ((!di->i_links_count && !di->i_links_count_hi) || !di->i_mode) {
+		mlog(ML_ERROR, "Invalid dinode #%llu: "
+			"Corrupt state (nlink = %u or mode = %u) detected!\n",
+		        (unsigned long long)bh->b_blocknr,
+			(di->i_links_count_hi | di->i_links_count), di->i_mode);
+		rc = -EFSCORRUPTED;
+		goto bail;
+	}
 	/*
 	 * Errors after here are fatal.
 	 */
-- 
2.43.0

