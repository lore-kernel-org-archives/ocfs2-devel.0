Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD56827FB18
	for <ocfs2-devel@lists.linux.dev>; Mon, 17 Nov 2025 22:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763418923; cv=none; b=b2UVL7aWhurH+XMd/s9mu+GSlgAPTSTYeOatXHr84aucnz46asIHLfeD3znkZrl4uBpSlJzfV76tpPLz1X8BUGmyTWqqVVOG3M2zJjnxEWHp86/aWlRjuSJaPJ/7/162xHCbZ62kr6XsB2s/Fz0dOYzlm/UEzIDFquDd1YUUq4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763418923; c=relaxed/simple;
	bh=oGtexn4m4+/9rjdY4N/CCX3LUXXjxq7mDh8Xf+jaA30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIZ9zX0BmP3bOZnrNa3Zz2kdzqtdYzNmwlj0aWTeOnmZyjbnBsbUeDlzUklTh5sxUIxwDpYIGFf8h+0n6Q4R6MfLdtYq0/inCL+4FZVAEvHwzuyCUpatesi4V7huFvT8cvQhPkvyDWEuCB/3TdqlPDKm62lhZ4MUtfVc5uwtB6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c+gqPgSd; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c+gqPgSd"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64074f01a6eso8165369a12.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Nov 2025 14:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763418920; x=1764023720; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bt0FMPe4Qa6sEYYxJmZwi44mFWT2CwJlUvRkRKRBNv4=;
        b=c+gqPgSdQt4qZsvtZMhVnR7Mby54zUAzdXIKuobVV7k4oIbxeoE1ka5I2QSboq7o5O
         iw0Iwq2AGd3WWgwuAtcLgOPRePWqWwPKxE6kcz71F8PKw7U3x7HvYF3PAnOOV+/Cg8ad
         aDzwipujPqG6mwsERyK1A2HLvvZzZrdMBR/+VCFZ49vaA1q0Scbib7P008T89rCizkRn
         9gUD/Lu3O1Nd3Q5wG/RFefm/DLFtrRQKRtzXbAa3Jd+xBbRoKJDVRaJxRYz8560pvdhL
         vJ+SXjE80u5lghTPQDXXHurolo9+UuYsBeOuWtWfv8cbXiQSNMr+Vv7VHGJlJVn1SuVB
         b+lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763418920; x=1764023720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bt0FMPe4Qa6sEYYxJmZwi44mFWT2CwJlUvRkRKRBNv4=;
        b=G+xOz88u6F6RtFXIE+kNGWx5gimSWZ+8oEyIf4S4I/bB66XqbjBoi9IW93FQ5QF6nh
         oetMSY3/8OhZEEKlQp04FjOEQ+3Ro/UW1+OqVHdTEoJirbLPteA1QGLH4nnCZCdfqHgX
         4q1pebVkmO1kAtnx4uYE9WYR8yPo+xK7c5ir7mlg1HQMBhWSda8BQ5LiqjjXkq9lIPis
         oaY4RtUR/QROm6yU36BgpbpeeSxL3EJ/2GS/hh82hO6P49nkiv6I3FttfZoOEjRWqjCo
         LSGKFbkFjWanv2tc7eHxVC4vU3poZJ/E/K79urj/96aomjOfdA9bQpnA6OTA0mjrWbe4
         QrgA==
X-Gm-Message-State: AOJu0Yxqmv4QECQtDyDcmYtH7PzBbDSPC6uDIBi4o0B+88OBG9Xg+kpx
	8UpgdpfDqYXixemVJmsrPd14hpf4OnZCPSgE3zSXRDdCQXuIoksCjVFj
X-Gm-Gg: ASbGncuOelJMV3ZcyBzb9PNEF3OcqfVkJUr2vF4k1N3Ci1uLETzUBaC0+dzs38e5CaI
	0mPGgNLUSDpWiODk8xf6hm/gsWFdO2AtMo66JdjLKH5Zbzy/J6WaGl/HYG91bI79uxDQChKHzo6
	GnYuj7CDzMFB82IBQzS/rzHDQcngTE2nYV7lIuXlUEN2O/lpg32sj3BAods1QX0WCidokSEJMz0
	I1AyHwhFfWrfHuJKTj1aFOKuynF6oYijiL7Fwl0lAsZcM8TSbiUFxvPrg8Cc2ua2FL3ErgSCJ58
	9NtBK7g4wT0AAhrFaZEyWAEEvItmxqmy84qP/UTF2hyMCwlDhB+c+DNdxZ+A7lD+bv+sOl0K3+w
	xFm0Pgkq6s3F1fUGoMyDu8cI4tTFq1GioZLZ+3uyAkllx8JeqgGrnlobxJ3wj9DxwiyS1RPmGUe
	AS
X-Google-Smtp-Source: AGHT+IELFS6lvG4mnDClLXFQxCFcVvQotosVXxtJ9lksxQKVeVZ8zurwvbwRqKhRihu00ocg3gqWQg==
X-Received: by 2002:a05:6402:520b:b0:640:eea7:c95b with SMTP id 4fb4d7f45d1cf-64350e04610mr11137593a12.6.1763418919862;
        Mon, 17 Nov 2025 14:35:19 -0800 (PST)
Received: from eray-kasa.. ([2a02:4e0:2d08:f72:eb64:1d0d:5855:afe7])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6433a4b2615sm11103469a12.32.2025.11.17.14.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 14:35:19 -0800 (PST)
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
Subject: [PATCH v2] ocfs2: Invalidate inode if i_mode is zero after block read
Date: Tue, 18 Nov 2025 01:35:07 +0300
Message-ID: <20251117223506.299511-2-eraykrdg1@gmail.com>
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
 fs/ocfs2/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 14bf440ea4df..6641caa45292 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1456,6 +1456,13 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (!di->i_links_count || !di->i_mode) {
+		mlog(ML_ERROR, "Invalid dinode #%llu: "
+			"Corrupt state (nlink=0 or mode=0,) detected!\n",
+		        (unsigned long long)bh->b_blocknr);
+		rc = -EFSCORRUPTED;
+		goto bail;
+	}
 	/*
 	 * Errors after here are fatal.
 	 */
-- 
2.43.0

