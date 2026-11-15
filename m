Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794757223;
	b=I5uNe0DtnGPoBgd1RGeyI/oQz6jkjaFeK14y24SwXvX8+6DpyiUguNv6ISGjGbVTNBcY
	 Ag2WsMjFws2T1nIvkcgYrkNJmrOCk3TDo6+DpzZQH6iNWfL68+s3ZNVfz2nWR3y4ymkmD
	 B3DYZR7QffkHOm1hd+u0eEKeAG8zhiYvN+5bYjzGGEDOdTeecLvtgALalV7nb7Dij+dTE
	 LKVFmPuasMjq9sZATYyYPTCtT5k9sgNwFSOEaMzHsHljoYWzWTZxy46S0zsFYfLjD6RyT
	 eVPnfDZWf3mR01WjRM5jGWNhdRHpZ0GkCq6AABE8/QjsujV2Vk46jlH2CnBxOBVXxhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794757223;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TRu6zBCgUTdVoLcTgcV1Q05kOpKndyRZJV5KXfV3RlY=;
	b=a61nopJ39hMFdUr9lXayzF0qbo4FjZe7wY0UtKbWsP3L8QkrptBOVA5OjAoS+IS1KTD3
	 kW9Vu4joPyu61DQeEi+qb1Sgw0xwsTODhCmaOncYL08FXgEq+2F1b9CmUwng/ES657BxX
	 gLm2p32f4SMb035DJ4KiMJnFqOK+1xFNME7Wicai6kD4S+MqUYcNF9n2nQMGQe0J4PT5k
	 TAZli1vFtot5oJyzEsuqBagvKA/HAAO56SrjvwDMo4W5Xi9p5qYOKlC+VLW3gyd3AYJeh
	 nKcAjfQUQnz8k0DL/Q32UT9TLMrumTvwI7KHWvNZCB2ThDH+6GOZOvGE2m58R3Oes+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=HMc9iSOV;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D26F606A338
	for <ocfs2-devel@lists.linux.dev>; Sun, 15 Nov 2026 15:40:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D26F606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=HMc9iSOV
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4913db60638so198474f8f.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 15 Nov 2026 07:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794757221; x=1795362021; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TRu6zBCgUTdVoLcTgcV1Q05kOpKndyRZJV5KXfV3RlY=;
        b=HMc9iSOVHl2qqCEKnZr/lSE+DkE6rkRKliEkLlhUX+V+J531So1VQ66MQ4FsIN5FVC
         Vq8KR7O1PoomGE8VqdOqlFM8j4Y/iQhEvma4AqVdU5yXqU6wE1PYdBR4ys2m2g9S9ORr
         4haiEY7MHyO63Zt4mWB9tOiRFjR9j4p6KVxo2+lvdrPmxq++n9tkn+6gUzyCQG1yGIe7
         sCwS0t4VimwrM3loAa9CXPghlwzdZFX3PVtuiDA82PivyE/G7t3R+i2GOI3nQsustcuE
         ghjzfYeWvmh0Py6hk4l+KvPNDjYr5jNyGpMjQdT576fOT/ETECFP/44dcGyqil4egI8+
         DGWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794757221; x=1795362021;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TRu6zBCgUTdVoLcTgcV1Q05kOpKndyRZJV5KXfV3RlY=;
        b=u1LJxeVuvB0YzzVxf00OWHhwaBQC87dvK9vIl4BhrlBZOmregp9LBjgh3xCXmkMt9f
         2uY6oKMfVz/Y2u+SnXHAPNYCtd2VqfHuuErxi9HQM2x5/q4nLzM61aflHMePJJ5j8+aC
         hm6waa2DXYzpwzWQLiptFyUdt1ElG7Hh3S6U8MQShur9k3IfhHWNa+YqAS7Qj6mnvUXu
         Vsi5ioZcWS+tG64rbMVq+htkL9y4y+AqSGL54gTDEs9Zd13fPbuDcjUov/CvRXsc7Eh1
         2O93682g37gZ8He/rymIMbUGeeP+AAGchNOk43IzB7wmFyhplVk2tLkswD6h71Tr4m6T
         dbKA==
X-Forwarded-Encrypted: i=1; AL+hErHc06NI2gib6svKf+waWIp8xDujKwrNHdCJ3kfKq47XEiILf/FW/K5RqdfMm1Xn1eyL70XbCaL20i3ZEQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z9lclExAM1N0VbJ3x6+urArToUllX8xgzaGTtvjkJALiile6ieb
	78M5cdgJKyWS/OSYklhZ06JgIybOUnUKNPoMEgAB09Lz9BELk4gy67r2DHJzHq6P3Vo=
X-Gm-Gg: AYBFou1grhWnbdZbYzvhtIDM27E2XCk7N0RGNAxOyhf+eg0an/CGf8jh1V1vuR0c74i
	eEJBeIXGra+cm7aK7Xv+AbQm7+Y2CbzRJi9bwbGWuvxNRa1ZeLzPle95YoFtWlZapL5QUXhqsE6
	oG6mJ9Su97TFDVITVI1h4aomFimsGiLsT3iqRFFLwI5Ha424Fya1whrp7QiZbmNcuDy+uMBm/KO
	8BhAru8f4zO3bXudF4tDJzg818KH6btzNRWjF7nIMPoMloR7pkxfQ9RWYfEr7cNqjCuqqm9uLj4
	ouOebsRHZJNdHJ4ssuWknGdZ/vYDlLSvVwYl+y9WyoD/9xgXA+ui8jbMsMhG5R81XefiCyNrYbq
	u2XaM75kUS46BbXbTr5/XLWsSpG0K+eGi6F25e+bSiBqYBi5Ja7IuX/wUaF2yNDFLlHNa97sfbl
	owtrCHTMG3oKnSiA+XtLY0NAm2Y6KurL2v1/V2W6kFfMU29l/+GBw1OBJObxe/hP6fS2PrwKSkh
	HvC9MkM4WPY2dr58AOZ5q+3X3yzn0lwvq16R4cZ1z8J/+9uacsr7WIpqigCWuI9IAQAChlN6cI0
	ZrnnR21Qd0EMEPP1/qJkJFCyRtuk203FSN0mQLCNURQA
X-Received: by 2002:a05:600c:a116:b0:4bb:6c01:de9c with SMTP id 5b1f17b1804b1-4bb6c01e231mr27925495e9.2.1794757220765;
        Sun, 15 Nov 2026 07:40:20 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379558231eesm25648733eec.12.2026.11.15.07.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 07:40:19 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v6 0/3] migrate ocfs2 DIO from buffer_head to iomap
Date: Sun, 15 Nov 2026 23:40:08 +0800
Message-ID: <20261115154013.9379-1-heming.zhao@suse.com>
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
to iomap mode. And the code base is commit 6628e7d4c6b2 (v7.4-rc1),
and also merge Joseph's code and ideas from [1]:

V5 changelog:

- Support allocating multiple clusters at once in iomap_begin.

- Use iocb as a token to detect the unwritten extent list between
  iomap_begin and end_io.

- Squash patch [3/4] and [4/4] from v5 into a single patch
  (since v5 patch [4/4] consists mostly of code deletions).

[1]:
https://gitee.com/anolis/storage-cloud-kernel/commit/ea3fe75e2060118ba093e90b1cd34fa382914b29

[2]:
https://sashiko.dev/#/patchset/20261103135605.22943-1-heming.zhao%40suse.com

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


--------------
# test report

This patch set has been tested on 7.4-rc1 kernel with the following test cases.

## ltp

runltp -f dio -d /mnt/ocfs2/

The failure test results:
(These failures are all minor issues. I'd like to check Sashiko's review
comments first before fixing them.)

diotest4    3  TFAIL  :  diotest4.c:112: read allows odd count. returns 1: Success
diotest4    4  TFAIL  :  diotest4.c:127: write allows odd count.returns 1: Success
diotest4    5  TFAIL  :  diotest4.c:179: Odd count of read and write

diotest4   16  TFAIL  :  diotest4.c:112: read allows  nonaligned buf. returns 4096: Success
diotest4   17  TFAIL  :  diotest4.c:127: write allows  nonaligned buf.returns 4096: Success
diotest4   18  TFAIL  :  diotest4.c:179: read, write with non-aligned buffer

## xfstests

./check -g quick -T -b -s ocfs2 -e generic/081 \
-e generic/266 -e generic/272 -e generic/281 \
-e generic/338 -e generic/347 -e generic/361 \
-e generic/628 -e generic/629 -e generic/648 -e generic/650 


OCFS2_MKFS_LOCAL_OPT="-b 2K -C 4K --fs-features=local --fs-feature-level=max-features"
Failures: generic/003 generic/056 generic/091 generic/094 generic/177
generic/211 generic/225 generic/263 generic/321 generic/322 generic/329
generic/331 generic/370 generic/376 generic/410 generic/424 generic/448
generic/467 generic/477 generic/481 generic/498 generic/510 generic/512
generic/513 generic/534 generic/537 generic/552 generic/557 generic/563
generic/578 generic/588 generic/607 generic/620 generic/630 generic/755
generic/760 generic/771 generic/777 generic/779 generic/784
Failed 40 of 632 tests

OCFS2_MKFS_LOCAL_OPT="-b 4K -C 4K --fs-features=local --fs-feature-level=max-features"
Failures: generic/003 generic/056 generic/177 generic/211 generic/321
generic/322 generic/329 generic/331 generic/370 generic/376 generic/420
generic/424 generic/448 generic/467 generic/477 generic/481 generic/498
generic/510 generic/512 generic/513 generic/534 generic/537 generic/552
generic/557 generic/563 generic/578 generic/588 generic/607 generic/620
generic/630 generic/755 generic/771 generic/777 generic/779 generic/784
Failed 35 of 632 tests

OCFS2_MKFS_LOCAL_OPT="-b 2K -C 8K --fs-features=local --fs-feature-level=max-features"
Failures: generic/003 generic/056 generic/070 generic/075 generic/076
generic/091 generic/094 generic/112 generic/177 generic/211 generic/225
generic/263 generic/319 generic/321 generic/322 generic/329 generic/331
generic/370 generic/376 generic/409 generic/410 generic/424 generic/448
generic/467 generic/477 generic/481 generic/498 generic/510 generic/512
generic/513 generic/534 generic/537 generic/552 generic/557 generic/563
generic/564 generic/578 generic/588 generic/607 generic/620 generic/630
generic/755 generic/759 generic/760 generic/771 generic/777 generic/779
generic/784 ocfs2/001     
Failed 49 of 632 tests

## fio on single node

The test results are similar to v5.

---------------------
Heming Zhao (3):
  ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
  ocfs2: switch DIO read path from buffer_head to iomap
  ocfs2: switch dio write path from buffer_head to iomap

 fs/ocfs2/Kconfig |    2 +-
 fs/ocfs2/aops.c  | 1532 +++++++++++++++++++++++++++++++++++-----------
 fs/ocfs2/aops.h  |   41 +-
 fs/ocfs2/file.c  |  220 ++++++-
 fs/ocfs2/mmap.c  |    2 +-
 fs/ocfs2/ocfs2.h |   25 +-
 6 files changed, 1404 insertions(+), 418 deletions(-)

-- 
2.55.0

