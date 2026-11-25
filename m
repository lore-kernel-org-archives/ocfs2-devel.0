Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621597;
	b=xvm3U+yrys3JNqKfgKyN7a8n5afZLWHN11ZZhjlCDvZhMpx3flIbpGyz7A7HLICnmX4h
	 RZX1tnW/9krxDL8i2i9m0cpbXecq2ZECgP+5/GsnD7t6BoWcoE6tp9u2vwJ0lFFVHGjdW
	 kftg3wq17ImC6mCyR0IWKKBfzrUcnojDe7ZB2apIXy4md+ljIxTz1TTnhfuXdQ7MjYUIf
	 FPLZXaUv70Hs0smMrlyFbF7gjR2CfuWjLeU3/mBUee2OKcbKo5oAPXLn4/rluqbXcLbMe
	 9sMP0Led+yRXDKQh8Y3Ijg+BT/n02Zsk+xWBGSULlPrjw6gQROsISiavLoSia8gKfhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621597;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=adV91UNf/xXHzN6L3ZMDB+0yf+V1HEUnItm0oTlcCfk=;
	b=ZY4UBA6vWdAEJZmgCEhHBitGcCrOyHblYUb+O5XYs5dvhPI8wbVu13VJ+mJ2A9lVt25j
	 2AFKmmHU5nbJEczJI8AKLnT9mgHhEoAgOAOWyD6mJzH9M1hU05UneNXR32/fPp3Oz2Jf6
	 YLIu57qq8XThWPF61doYLdaGEsHgkBafPt8/lhHjypTBXC63lBxzB29f71Z0rzUAn09Pu
	 nF3UjH/9E/RvR6XfT7FvPF0/F6SPurPYJeWn79Oyj3o7UbshC63V0SDK+BSZMwVBNK0eg
	 Zk2Mk495B2G5Cnhl+H2NZEAjnFHIXH1lc75q8gvIhKGx1AaikhJdEJMF3uuyqETbH8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=LnD3lVzx;
	arc=none smtp.remote-ip=209.85.208.45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC660606A32C
	for <ocfs2-devel@lists.linux.dev>; Wed, 25 Nov 2026 15:46:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC660606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=LnD3lVzx
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b88aab58fdso639121a12.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 25 Nov 2026 07:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795621594; x=1796226394; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=adV91UNf/xXHzN6L3ZMDB+0yf+V1HEUnItm0oTlcCfk=;
        b=LnD3lVzxVmxs6v1ann5cokJcWQGfX1jJRS9Z1ATK8vqQ10enmx1ZiI0iLgIwAA+7Cu
         CatK0SHLndgAMbgdV+sdwH+cRo9CIKmrW6A6gQrU9vbJLT96BKUIifnBnTxj/j3V7NfG
         S/5hx8+dKQECtLAltbBsuyc4Bx0CIkObt+K2eVgctds43Nxd9NjHi1GJGa3BWC5rObGs
         7uzB89OKkFznYsjlcsd3JxLHFrz0ysGJ8aXoA4Nmhyuin0Rhf5cLcKghpTlU6Tek7uL7
         UJoHeMJuzuBcfFUqUh7X+tAcqA9Z8obs1a/1pLjA0ZTbmxV0CN72AvBiLQcaR7cDb3Yz
         ZveA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795621594; x=1796226394;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=adV91UNf/xXHzN6L3ZMDB+0yf+V1HEUnItm0oTlcCfk=;
        b=1kfHSKAIeYMHKMbjHkbBJWeMqAlS0JnAZswwqbmP6+Rmbktipl4kpPUfdkwo189Dsx
         s5/ae+uD8y6+ZadvPXWkJ3R9HnIXc0K79zxArCEH85QVh0efqlEvdiua53rwDUsQ9cBB
         uC015GuNI9OmvJqGJIjz+xYA3Z2HMWM41hh4itugWvFm8WcScKs9B1sr4NE+xEDwaWzh
         kRgtY2G+lUfzalkE7QXawyECB6CM0PCKReEQkm5GJT89YOi7yIdxfcMeKQSlGUWlfDs3
         ac9tUkhxUy2VmRXmP5EcMitrmmXiOhwAjgaMxjdg64J/KJW1HeEUj2n3zdoVFcU31GMH
         c20w==
X-Forwarded-Encrypted: i=1; AL+hErFavWhsquG9h7JzCPrHKItBL8LPJV15bhTsgyd7DJzEZchkg4tOkeMcxToHTdXbH6Zo4gg+JZpH3LWsXg==@lists.linux.dev
X-Gm-Message-State: APuU4Z/yua1F3KBX8bqqpW+0OnAe5cNW8FK3j3kVREaVImxVBlTVU8W0
	UJBVQHyvyx9Rvg2hokkbL6vlCnTPEi31bqHm6oHlDBysKaPym+sdekTP6JNf1ojSegg=
X-Gm-Gg: AZFdTZfoFPW4GdiTj/uImpXuUbYEocGWUiJVLLxvhY8/73dXFTiFoIBCdaiHZ6OUgfr
	1D5Cc8GzinvY/Kfte4EQ3XdqxFPOLoZLKlNqfXUXaPhNo0fVYFkFY0dqEzT3oGx+MCrVo1KEJM7
	OfBxj6h/sd7lXfadrd9hb2ccymcaEI1/jMjz04TZiDxWUzhjMG0eMsD6kkpxabwxQzaFALJUwzH
	Mzzkq/Gvqe+a3JkKxrJLIz84At45WJt3FdCGHxL8FJiLX4WgaxX05HpfoYiaEoK5xY4dHXAgs+w
	4QnPRsG+SWTRtX43TQP5g6R/eiP4/zjoDcuOtQE5ZjU9oyyTIDQ52qDX3lWvIXvOMiqPo0ohCEV
	gz1EsTFo4sZ/lMki9J9QrBfVADt2WIlriBtJlXF6EOMnv63d+UhamCn4XCU8Gw5rxC0AttPHik8
	4foIOxQRW+pOC+2dj48kz0B6G403mk8Rj/TwucwvkK5vdQT+ayIjIBPTGjzLG4rKtVUd5Iax2/e
	zhmO+iD47A4PIqyT34Z7uspATfOtgeTW791uy6eHfevC84W/M2mjKTND/+G1+wEx4UKJ8Qqtf42
	/H08c0T55MCcIm4rvto3czalvijj4s33GXipUm2kItg=
X-Received: by 2002:a05:6402:a545:10b0:6b4:2960:d381 with SMTP id 4fb4d7f45d1cf-6ba37c76e50mr12198200a12.1.1795621594123;
        Wed, 25 Nov 2026 07:46:34 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c8707792e8sm9419677b3a.7.2026.11.25.07.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 07:46:33 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v12 0/3] migrate ocfs2 DIO from buffer_head to iomap
Date: Wed, 25 Nov 2026 23:46:22 +0800
Message-ID: <20261125154626.22335-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set migrates ocfs2 Direct I/O (DIO) from buffer_head mode
to iomap mode. It is based on commit aebb72744764 (v7.4-rc3), and
also incorporates Joseph's code and ideas from [1]:

V12 changelog:

patch 1/3: no change
patch 2/3: no change
patch 3/3: (based on sashiko's review comments)
- add IOMAP_F_DIRTY in ocfs2_iomap_begin() when the write extends i_size

- introduce new api ocfs2_dio_cleanup_range/ocfs2_dio_cleanup_pages to
  fix Sashiko review problem for function ocfs2_dio_end_io().

  ```sashiko review comments
  [Severity: High]
  What happens if a multi-mapping direct write to unwritten or newly
  allocated clusters completes some I/O (size > 0) and then fails on a later
  mapping or bio (error != 0), for example with -ENOSPC in
  ocfs2_dio_wr_map_blocks() or -EFAULT in bio_iov_iter_get_pages()?
  
  During ocfs2_dio_wr_map_blocks(), any unaligned head or tail folios in the
  page cache for the first and last clusters of the earlier mapping were
  already zeroed, mapped to the cluster's physical blocks, and marked dirty
  and uptodate via block_commit_write().  Because error != 0,
  ocfs2_dio_end_io() skips ocfs2_dio_end_io_write() and discards the
  unwritten list, and iomap_dio_complete() skips
  kiocb_invalidate_post_direct_write().  That leaves dirty, mapped page
  cache buffers pointing at an extent that is still marked
  OCFS2_EXT_UNWRITTEN on disk.
  ``` 

--------------
# test report

This patch set has been tested on 7.4-rc3 kernel

## ltp

runltp -f dio -d /mnt/ocfs2/

results: passed

## xfstests

./check -g quick -T -b -s ocfs2 -e generic/081 \
-e generic/266 -e generic/272 -e generic/281 \
-e generic/338 -e generic/347 -e generic/361 \
-e generic/628 -e generic/629 -e generic/648 -e generic/650 

OCFS2_MKFS_LOCAL_OPT="-b 2K -C 4K --fs-features=local --fs-feature-level=max-features"
Failures: generic/003 generic/056 generic/091 generic/094 generic/177
generic/211 generic/225 generic/263 generic/321 generic/322 generic/329
generic/331 generic/370 generic/376 generic/424 generic/448 generic/467
generic/477 generic/481 generic/498 generic/510 generic/512 generic/513
generic/534 generic/537 generic/552 generic/557 generic/563 generic/578
generic/588 generic/607 generic/620 generic/630 generic/755 generic/760
generic/771 generic/777 generic/779 generic/784
Failed 39 of 632 tests

OCFS2_MKFS_LOCAL_OPT="-b 4K -C 4K --fs-features=local --fs-feature-level=max-features"
Failures: generic/003 generic/056 generic/070 generic/091 generic/094
generic/177 generic/211 generic/225 generic/263 generic/321 generic/322
generic/329 generic/331 generic/370 generic/376 generic/424 generic/448
generic/467 generic/477 generic/481 generic/498 generic/510 generic/512
generic/513 generic/534 generic/537 generic/552 generic/557 generic/563
generic/578 generic/588 generic/607 generic/620 generic/630 generic/755
generic/760 generic/771 generic/777 generic/779 generic/784
Failed 40 of 632 tests

OCFS2_MKFS_LOCAL_OPT="-b 2K -C 8K --fs-features=local --fs-feature-level=max-features"
Failures: generic/003 generic/056 generic/075 generic/091 generic/094
generic/112 generic/177 generic/211 generic/225 generic/263 generic/321
generic/322 generic/329 generic/331 generic/370 generic/376 generic/424
generic/448 generic/467 generic/477 generic/481 generic/498 generic/510
generic/512 generic/513 generic/534 generic/537 generic/552 generic/557
generic/563 generic/564 generic/578 generic/588 generic/607 generic/620
generic/630 generic/755 generic/759 generic/760 generic/771 generic/777
generic/779 generic/784 ocfs2/001
Failed 44 of 632 tests

## fio

no test

------
[1]:
https://gitee.com/anolis/storage-cloud-kernel/commit/ea3fe75e2060118ba093e90b1cd34fa382914b29

[2]:
https://sashiko.dev/#/patchset/20261103135605.22943-1-heming.zhao%40suse.com

[3]:
v1 patch set:
https://lore.kernel.org/ocfs2-devel/20260724052559.15409-1-heming.zhao@suse.com/
v2 patch set:
https://lore.kernel.org/ocfs2-devel/20260727061802.18485-1-heming.zhao@suse.com/
v3 patch set:
https://lore.kernel.org/ocfs2-devel/20261018143319.22329-1-heming.zhao@suse.com/
v3 sashiko review:
https://sashiko.dev/#/patchset/20261018143319.22329-1-heming.zhao%40suse.com
v4 patch set:
https://lore.kernel.org/ocfs2-devel/20261103135605.22943-1-heming.zhao@suse.com/
v4 sashiko review:
https://sashiko.dev/#/patchset/20261103135605.22943-1-heming.zhao%40suse.com
v5 patch set:
https://lore.kernel.org/ocfs2-devel/20261105071930.16399-1-heming.zhao@suse.com/
v5 sashiko review:
https://sashiko.dev/#/patchset/20261105071930.16399-1-heming.zhao%40suse.com
v6 patch set:
https://lore.kernel.org/ocfs2-devel/20261115154013.9379-1-heming.zhao@suse.com/
v6 sashiko review:
https://sashiko.dev/#/patchset/20261115154013.9379-1-heming.zhao%40suse.com
v7 patch set:
https://lore.kernel.org/ocfs2-devel/20261118002050.9019-1-heming.zhao@suse.com/
v7 sashiko review:
- https://sashiko.dev/#/patchset/20261117150053.18417-1-heming.zhao%40suse.com
- https://sashiko.dev/#/patchset/20261118002050.9019-1-heming.zhao%40suse.com
v8 patch set:
https://lore.kernel.org/ocfs2-devel/20261119064029.11910-1-heming.zhao@suse.com/
v8 sashiko review:
https://sashiko.dev/#/patchset/20261119064029.11910-1-heming.zhao%40suse.com
v9 patch set:
https://lore.kernel.org/ocfs2-devel/20261120060014.12087-1-heming.zhao@suse.com/
v9 sashiko review:
https://sashiko.dev/#/patchset/20261120060014.12087-1-heming.zhao%40suse.com
v10 patch set:
https://lore.kernel.org/ocfs2-devel/20261124045501.10281-1-heming.zhao@suse.com/
v10 sashiko review:
https://sashiko.dev/#/patchset/20261124045501.10281-1-heming.zhao%40suse.com
v11 patch set:
https://lore.kernel.org/ocfs2-devel/20261124152623.7838-1-heming.zhao@suse.com/
v11 sashiko review:
https://sashiko.dev/#/patchset/20261124152623.7838-1-heming.zhao%40suse.com

-----------------------

Heming Zhao (3):
  ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
  ocfs2: switch DIO read path from buffer_head to iomap
  ocfs2: switch dio write path from buffer_head to iomap

 fs/ocfs2/Kconfig      |    2 +-
 fs/ocfs2/aops.c       | 1820 +++++++++++++++++++++++++++++++++--------
 fs/ocfs2/aops.h       |   43 +-
 fs/ocfs2/extent_map.c |   34 +-
 fs/ocfs2/extent_map.h |    3 +
 fs/ocfs2/file.c       |  345 +++++++-
 fs/ocfs2/inode.h      |    9 +
 fs/ocfs2/mmap.c       |    2 +-
 fs/ocfs2/ocfs2.h      |   25 +-
 fs/ocfs2/super.c      |    3 +
 10 files changed, 1857 insertions(+), 429 deletions(-)

-- 
2.55.0

