Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9843B71B5
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 16:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035554; cv=none; b=DZt/UZQ2UVygdUdrxpeJHJ+6OcR0+iYIc3/1ZwxZEZuOJZV3Xa42MJGOLmn1ZYI3+7MENNbwQ/iSMeK0ZF6h1TlmyLW7EggtnLI2JCVANtpq1cJSHEJ2mj66f+2RQYgG/dLpW7cp/V/K8ZsBPfqV1LJBV0Xv9PB1ZcR0VKvZ1oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035554; c=relaxed/simple;
	bh=nXfjVTs2WwI7r48njT1474MNwTWULNnJflHmHfHsQpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFnSVjgGEpseYjjyGn+A02yfsSEIgUkhBhNp5eE7Aov5dLJ68/iBm30cjqsMsEV68GEraBfQJF3xWDZ0U5Gt0i2TxcfgbwUce8DZM8CXJzSkMcPgzZDJOWB6PSQDhG7VWjMx+8BLfYbpgcTDsdB3KQk8mWo53pziAaHJS2ZDuTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fCRvVQMZ; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fCRvVQMZ"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-754ac74c495so704033137.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 06 Aug 2026 09:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035551; x=1786640351; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/lKy66WaG7+TnlzmHpXjsimPtvzEbNlkmMtBXzg/7M8=;
        b=fCRvVQMZr9I2CMTg3SFoKEhw2GUV+Mz8+YvukLUjETqYV4teu9VJG2jYVQE4U7jxXi
         28uf/xzfVxDnHPnwLIN3dVwOGQPI38pYZOxGaXi+DEsQ82fG0AT+c+vsbV7SG+jEU+Se
         Uw4YOfuotVt8IPke7iL0TSIF7KYJfcWbpVHIYT4ByWXEiF9GIRet4NqnwY2pJAUtWmPm
         Win1tOC46+8HoRst8YuEQGkmdbFYONl9H5v8uMMT5CEZnLYZr61ZWD81VFsS81P7xEou
         1AaWVzniUixpPJ1vXWZEQEvcqBIJxQsbwvVTiAeN1YzbTMS97mkHKev1Y9binyTvmvpm
         s0eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035551; x=1786640351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/lKy66WaG7+TnlzmHpXjsimPtvzEbNlkmMtBXzg/7M8=;
        b=FMckcywxeOoI8xTTMbyFLnpEU83Hd70cSRNspFA5t3wPy7/8neNbIQkr9kUpRYhUJK
         kWwy7osBN2H7HHD/eBqTBQGQXZaHzc+FdiNdHTQGRknW2pTuaCVmJJU4Lg2Ioal6OWk3
         LuSiVwhLsizSVDxAoFJUtoK/x2zFSnewoRlCNAi0lIk/yBs3yRouezHOIHVbmqRv2zw2
         RoYWtHLc8zUSDDyJZjolO8aNmgR6dwRVuK216nzGiyWpZeqsFPYZPmMmdltAqTO2qUbQ
         y6rQSc5XpjVxcybOp2k/azjkETxR+az1Zvnp8iy47ckTNniMgR8ghqsl5sI7bc55inVK
         zKHw==
X-Forwarded-Encrypted: i=1; AHgh+Rq+w8LatOPAM5A+F1/bOgAa3P8gF5J19qUqQ3Y0nfPNh6q4YpiH+WJ99np9rzn9JmoHboQSeZyBXXMkLQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5cO/yd8rytjV7jHyoU2GgZqgMmkJlZHtdaZWPaX6rKrMZ1Zx+
	YO6YEpjv0c1/3u6/jHuxJ0cXuIg6lBD0/SK0m+L30GA+zI3ss8VJVsqV
X-Gm-Gg: AR+sD135GcFeit1O5rtofcQeCDlZOwxHZrL5/pGldW59Eh0b/I8s9NKnPIe5QjAi55b
	pCoHOcJR/h9eAEA5JFIoupxYtY7HtV+7hviDN1S9XJ7CI50lrE4aFITXpteYkzlTLpr7EhtjShn
	1gWYreWZfViFB3J/m7DHpR0djWgGqZCPUI20nK/Ac8eux7BVJNHT/SBBDd0VR1a6qAJmc2y7GZc
	hYUYL30ijcfvMDXUQRjfqrjwm5twBIIq4i55zhmJKqXw28DNROxlZT4/YhZQbfW/9KJua5Pvi4T
	YLZ39zQEUpBX81EP1uGFT6mT0xnGFBhh57torYaqbGytAJ21SorHOZHOWZkwHfF5jAud9hRNOWb
	Zkz4ZyDRrBYIHNAf2WWSn3vj/+jSQlTiUMaF4RYxCGickYFZAQf41UrgIiAPCgL2w8mjW3V7Pnp
	mNr1zDvSU+BIvqVATk1XwiFYdXSN9vTvHwFZ7HNt5Jm0AbZdh/5jm4XUe15o3Yn8PLh+/6Yje4u
	elCKhk=
X-Received: by 2002:a05:6102:f09:b0:6f0:3ba3:7d84 with SMTP id ada2fe7eead31-760e77f0ff5mr4020392137.5.1786035551228;
        Thu, 06 Aug 2026 09:59:11 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:10 -0700 (PDT)
From: Chao Shi <coshi036@gmail.com>
To: Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>,
	Weidong Zhu <weizhu@fiu.edu>
Subject: [PATCH v2 04/21] buffer: read the folio's mapping directly in buffer_set_crypto_ctx()
Date: Thu,  6 Aug 2026 12:58:27 -0400
Message-ID: <3fe72ec37bf8491a69031db5f3ba1319da935b97.1785951556.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785951556.git.coshi036@gmail.com>
References: <cover.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

folio_mapping() was doing two jobs here.  One was to turn a slab folio into
NULL, which is what made this safe for jbd2's shadow buffers; the previous
patch removed the need for that by giving those buffers no folio at all.

The other is a hazard.  folio_mapping() maps a folio in the swap cache to
its swap_address_space, so if a buffer_head were ever attached to such a
folio this would hand fscrypt a swap mapping and dereference ->host on it.
There is no reason to want that here: this path wants the file's mapping or
nothing.

Read ->mapping directly.  Buffers with no folio are already handled above.

Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 04fcc34e4fa6..2851830995d8 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1108,7 +1108,7 @@ static void buffer_set_crypto_ctx(struct bio *bio, const struct buffer_head *bh,
 	 */
 	if (!bh->b_folio)
 		return;
-	mapping = folio_mapping(bh->b_folio);
+	mapping = bh->b_folio->mapping;
 	if (!mapping)
 		return;
 	fscrypt_set_bio_crypt_ctx(bio, mapping->host,
-- 
2.43.0

