Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795070441;
	b=R5I83X4PMwXcF23vOKRAFxk5m8/mzBd+TbMXTQYhgdbL7dn+XabR4weP7bk85sUcHpu9
	 GHe+v8v9RL1IpBTOwaq/LHH/5M8/MFnxov59c3hF8T+i4RbfM50OfvQxESMmrbjVkoQW1
	 bjWSZtJz75DcyDn+2Y8NCGqNJ37v5uB2GlqfxjBvvBuN+ODlqVeKwkbd7hksy7a5RfE1z
	 beEugobQvHUEEnwe8Fanoo02aAmQKneRNpr6qE8iNu8xAH/fgnKsn+UfAc8QiK4Sl5MnB
	 3CAuPNoZ9gMim1niZi4pA1PUUI0iuak1E6HhFuX04WNySC3nE/u5en+6IM2Y+67gk6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795070441;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0+i4kPjCyDFw5Pumf94Wx8o9MH3eUOLWR8/QQh7Fq4I=;
	b=MlAqdrZOByU/ecWHVMS5msSsZiVaOH13RLR8deaP4QtB/4ux0WAgjiDBU5Lk0chUvExj
	 JZhn2k+mCtXV90aVT2ciYsBHZ2wKQzj5IKu/at1oCJ/+WqrOOOFfPW10DxSVv80x29L4d
	 5dJD+7WYQnS4Ccb0soiLw+JxZva2q6e0aDW+mXLxqsxHCidw/IewhDezALd60+88hWVdE
	 IOaBdkBiADq89CYbCjZ13hX5DG46NaGRkA7ZkxeuFxcNODzDarUeYO1U+zQ2gJvlnqCz9
	 onIftR0YSiZEmzL4gzx8+XmPXhl0bgpTd6zyYgkuNGiEsQF30iq5bw8tnQOyyCtWq4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=cGeNgH5V;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F34606A337
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Nov 2026 06:40:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84F34606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=cGeNgH5V
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bb7679f28bso1462185e9.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 18 Nov 2026 22:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795070439; x=1795675239; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0+i4kPjCyDFw5Pumf94Wx8o9MH3eUOLWR8/QQh7Fq4I=;
        b=cGeNgH5V1cTFrjMsIYOOizGNJNYY8QJrVf1PD0c3InKaybL97F7E/YBicc6ZQMaWey
         b/b97B6F9lqCUauu90UjLUOMFx7zV4z8Jpb2mdyC0jgC6igwP4n3qHaWOZ/FMBmoC7Ua
         gyhZRo9zYRAkL9hVhq6HDTleGVaQVKT5abBzxbWaYr5MaLMIx6A0tp2GEgfZTWOaZqiW
         s7ePMLf4yp2XsXuwIbaMg2u9p6VRJDCpSOUWLx0HYAce4sxZIbSuK1x050ERclmjIX8T
         8X7IOfcT8DLwLdEHXNqCYhucrDAmktNzYpEvIQhvn18Psx746oYaK/evzVW9NKIp4V4f
         nUWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795070439; x=1795675239;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0+i4kPjCyDFw5Pumf94Wx8o9MH3eUOLWR8/QQh7Fq4I=;
        b=bHeyFQI+c/O4iGiWVLOBJ9xy68v4Q5D9gANmKitobtxmFE8vsDY6K8Bp0Ua8aUv+I9
         5s3O0pzbZOWxhgKVkgBRs89a/mSMmrAykrcpKJsg6DwReeu06DSzk+3hbmMjjZOW0mLB
         lPwGAZVCuc/4w/Hacr9dG9E4QmeiX6oTIvULt/hFnia1KHZnRAeQOI1CD0JYLgpjU6Su
         +f64c/IAJwp3554Fv7kpsSinTWBtFn2ZpeCZ65NrHbxMy6DvV/YRc4XPqWBRvH5Z8VHQ
         SgUirGLHDfpfFfDq68F8CLFqo45Rfkduua6Rz0Y7+AJ/iebla+Q1hpd8l45vDZPJ3n6j
         xfNA==
X-Forwarded-Encrypted: i=1; AL+hErELGyBsM9mhibvBfB+FbYNHJw5/+mgjZwcTYfG6REh+m5hVKwjAGdvDCAqLrVx67gkOzflUOjjbofmeLw==@lists.linux.dev
X-Gm-Message-State: APuU4Z+8+VJm2WOxVMGakxGiO7QVy6g6bYnZhdPJY0gAInNWmYvXnOrI
	+jcBWEhcjwKsqk+sADkhx1IMBkClDu3tus1U0W1+RCbiyAfllkGU5s9RFrR+gv+LFc4=
X-Gm-Gg: AYBFou0JJNwNrkg7QBWN2MgY+EDr2cfmJieLpIKYuf087j+gP58SYAfHLBccsFM/bXc
	T0GnemvVN7gOOWUH1CiuRkXWRVj1YyTqzWjy9To15rZzWeTGO/JpvD9WElukyiV/ciiemEvMgZA
	SZas8LbffXHEYvvxs8tKfWomDSRP67QeoUwCQaECAnTdW9xSt8tKak6i+aDpHFpTqfLI0+AbhzY
	rktZeX4gI4rMaffjqwtNsFEyqgLMWzEZVGMb5x0+32y1M3IBZRmAUA2Gr5LkUc1XttLngCT9Tkm
	Yk0xIxoF+YNopi1cw3MsVSVUh7jIq7xa2rEiRu8QWq/4gM6WVhbBlMYWP2V+ap2QrfQiwETfoK3
	vieB+9skPBduBle0U0KxGPLP5odPva5kK1cY9yOzhcVo/rmEdftWaZ6yvxudwQp7ISqafcYBpyW
	XTaRd6gL52qD5RXNxz0aiBqPUo4LGDmgtdmpubVH7IWfcj82A8rl3gTpxeEG1DcJksDRKoXtXCq
	VCC8UNtWzs+qk13jb0mMdu4BKOAUorjB0Cw56+Z0RbquyqA24O0TANlrzoAzvMGEuEb7hwheZRc
	ZD/HvA7FMdCE0CwflJWlkYul53bLXgBt3Q5eyxqonW8=
X-Received: by 2002:a05:600c:4e92:b0:4bb:7ae0:30bf with SMTP id 5b1f17b1804b1-4bb7da147cfmr84885725e9.2.1795070438763;
        Wed, 18 Nov 2026 22:40:38 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c5ca7aa769sm2286469b3a.18.2026.11.18.22.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 22:40:37 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v8 0/3] migrate ocfs2 DIO from buffer_head to iomap
Date: Thu, 19 Nov 2026 14:40:24 +0800
Message-ID: <20261119064029.11910-1-heming.zhao@suse.com>
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

V8 changelog:

Address sashiko's review comments (all changes are in patch [3/3]):

1. move del_orphan from ocfs2_file_write_iter() to
   ocfs2_dio_end_io_write().
2. Fix several edge-case handling problems in the DIO write path.
3. adjust dio fallback logic in ocfs2_file_write_iter() to ensure
   dirty pages are properly written back or invalidated.
4. Note that some issues reported by sashiko are pre-existing
   problems and won't be fixed in this patch set.

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

OCFS2_MKFS_LOCAL_OPT="-b 2K -C 8K --fs-features=local --fs-feature-level=max-features"
Failures: generic/003 generic/056 generic/075 generic/091 generic/094 generic/112
generic/177 generic/211 generic/225 generic/263 generic/319 generic/321 generic/322
generic/329 generic/331 generic/370 generic/376 generic/424 generic/448 generic/467
generic/477 generic/481 generic/498 generic/510 generic/512 generic/513 generic/534
generic/537 generic/552 generic/557 generic/563 generic/564 generic/578 generic/588
generic/607 generic/620 generic/630 generic/755 generic/759 generic/760 generic/771
generic/777 generic/779 generic/784 ocfs2/001
Failed 45 of 632 tests

## fio

fio --direct=1 --iodepth=32 --rw=write --ioengine=libaio --bs=128k --size=1g \
--numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
before patch: write: IOPS=38.5k, BW=4808MiB/s
after  patch: write: IOPS=39.3k, BW=4911MiB/s

fio --direct=1 --iodepth=32 --rw=read --ioengine=libaio --bs=128k --size=1g \
--numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
before patch: read: IOPS=51.7k, BW=6461MiB/s
after  patch: read: IOPS=50.0k, BW=6253MiB/s

fio --direct=1 --iodepth=32 --rw=randwrite --ioengine=libaio --bs=4k \
--size=1g --numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
before patch: write: IOPS=27.3k, BW=107MiB/s
after  patch: write: IOPS=26.9k, BW=105MiB/s

fio --direct=1 --iodepth=32 --rw=randwrite --ioengine=libaio --bs=4k \
--size=1g --numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
before patch: read: IOPS=372k, BW=1455MiB/s
after  patch: read: IOPS=350k, BW=1368MiB/s

------
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
v6 patch set:
https://lore.kernel.org/ocfs2-devel/20261115154013.9379-1-heming.zhao@suse.com/
v6 sashiko review:
https://sashiko.dev/#/patchset/20261115154013.9379-1-heming.zhao%40suse.com
v7 patch set:
https://lore.kernel.org/ocfs2-devel/20261118002050.9019-1-heming.zhao@suse.com/
v7 sashiko review:
- https://sashiko.dev/#/patchset/20261117150053.18417-1-heming.zhao%40suse.com
- https://sashiko.dev/#/patchset/20261118002050.9019-1-heming.zhao%40suse.com

-----------------------

Heming Zhao (3):
  ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
  ocfs2: switch DIO read path from buffer_head to iomap
  ocfs2: switch dio write path from buffer_head to iomap

 fs/ocfs2/Kconfig      |    2 +-
 fs/ocfs2/aops.c       | 1661 ++++++++++++++++++++++++++++++++---------
 fs/ocfs2/aops.h       |   42 +-
 fs/ocfs2/extent_map.c |   34 +-
 fs/ocfs2/extent_map.h |    3 +
 fs/ocfs2/file.c       |  226 +++++-
 fs/ocfs2/inode.h      |    9 +
 fs/ocfs2/mmap.c       |    2 +-
 fs/ocfs2/ocfs2.h      |   25 +-
 fs/ocfs2/super.c      |    1 +
 10 files changed, 1577 insertions(+), 428 deletions(-)

-- 
2.55.0

