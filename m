Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793709806;
	b=OaNYft6NPUhG6v6Gw+pyE7Lio+1aqyCu4+yhpR1kvL9UtVp9fPTbaeCt59/uLvTTCOik
	 69R5sUPVH46Z89uo+r2ckfxgbTTxCa+J7qxBPsvCk8EX3xFPaPb/UuTajEe+ws/M0mSjw
	 QlvO3w8rIF1AAsdKPJ2HJx7hvhp5urbgs0SStuxO31REQlCTUAxVGJbiSaRfJVKNLWiC/
	 glBRqNNWkUsV7iXdqILo6M87667k4h0GTD6oynPWkTig/gWWWB5ELitIV0A55H7eIXLr+
	 FW91IfMxh51m9l0KJ9SqTmZcOVVVqsyTXnZjHxcPMOEUnJQgX48i3zeYYlahYln2bOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709806;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=EYwaFjTaiXHJpW1ztljpbxc/E5ty0DDSV7TAsaiQzBw=;
	b=JrS8EJMlBeY0SNskQxsdxHtbnvHQwf/nVfOMdZPHy8h2N4b5QvAAXrRIm95jxSlY9tqh
	 zvRk7IfhmRvP6Nx990z+O4jM8UPj8DbPXs6vzdFaL0hiBiS/sLR+v+KgIA2U4PaFDHc7w
	 vYB6jKkic+0IriJLWM7cRMQSeeVpPyqrZ+bXiACrkHepHxTCUub6CMlAm9V2QgkweoJC+
	 vezKUqt7qmFNSn4tIQxSL6/p8JZ3wjTfQW4bxGusg2OJwcuYZQK2k2y2IyBF/IYcRDfYm
	 8FwYwDAI7uKBO3LUmiCbJ+r79TV0Zfamk1E3HvDJwxJnH6PgYHI1feDheeSZgZAlTbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=NB0GHWlA;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A76F606A327
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Nov 2026 12:43:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A76F606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=NB0GHWlA
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a73fdd2966so6467425e9.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Nov 2026 04:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793709805; x=1794314605; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EYwaFjTaiXHJpW1ztljpbxc/E5ty0DDSV7TAsaiQzBw=;
        b=NB0GHWlANdkjNmxJ7M2dgqItdkdqyISfRmiNfWaji2Hz7d6CwhAt+79LNZ8F46iUsu
         B9oG5eIf+I2pjUr9im/e38N2OlH/lNuKmFzv5Wg1sstYM62qbk4puTMCvkXwfBAGXbiG
         UJHSve2CP63KIwUD+48Nr8OnvN3E6GjbXYqGscZPZx3QyDs1GBzIhUtHBs1V27mU2orv
         k0WNIYtCyYf4hi7i9EM7/WwBO3rXNfqU3eDVFjhqE7MR5k5h1fK+qzQQUrxG6q5by3cr
         BxmVqtuTYpSs5Hd1V8vpLaFKShqJdS0lfyc+zEWnoC80OLvvqQUDXvpPm1FRvkLvV2ZU
         +T2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793709805; x=1794314605;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EYwaFjTaiXHJpW1ztljpbxc/E5ty0DDSV7TAsaiQzBw=;
        b=LPcc1oNljPHlOm7ycmnJhLZnc76CYBPMIIey+1WHJ/xeTGWIQ3vY9TI6WW5NNa7/dU
         XoqDfToANB49qVIGa8lnZsrnR7m3s//r5saCVEUVX0KynQxg+58cXIIcc6T9FfNzi5SL
         kn4ydjbSsdp/AJ3hIXPleh7iOMoUUqEGGzRpkwAtYIb7Nkg7jjdSBBku1uuisptD/gv9
         fzbeNx8959ICJcKHgL6AMs72YxhGnBSHJoEKusxB7PqArjpdZ0N0ctmISBEdVOH6Ae0+
         f5kp16+GDUN8mQjRoGc9pf862+G++SHhRJGgs2wGkK9kFldcpMLK/0UqOmmoRd1oN2VA
         9BCQ==
X-Forwarded-Encrypted: i=1; AKwUvBwEVFrvU0QvgvX4N8mHciKsSsE88OyYDivyhbMuRU8O7mfHt8r9JnUg3zYN/OofzfeK/GY7btwP9M3B/Q==@lists.linux.dev
X-Gm-Message-State: APuU4Z9KGdjE+aTgOelCIUIS1494kMJeT1IrA5YUnmRYh2AEa1ccUgKN
	d77jPpGkvsWNF241vFWP/CgA8Eln9MFU76FoW2npBOKx8YY1Ik5QvMIvzlfXji/MOiw=
X-Gm-Gg: AYBFou2sVh4jqHm/QPPENNPtuuFD8pIqS1e36SxlPf1/xVoSo+5F9CYoc3CnfQiUPci
	MpX2xkwixw0yxu0E7EH4OnKuXtNekjlqwoHidv4slhGr3o9yub+u+AnPymal0wBM4wi+4gfd5Lz
	1vkzSfs+nsTa8FHkJ/UFF4RbLsPy55YxrKFqYjX4bm7J5FWLpJgd2Rg//aqBSK2FZWqYvxpT5Jx
	nf18LJVC+SQ2aev3cPDiUHLsLOXVz0xefGogMrkXvOiVaVqdhT08REFMwJItuJlAw5TzJ21GKdT
	c3NKO+DxZi4PHG+35oZvl+QRQ/MZMKhpEyWgeYPybA8/sqyzDSDj1y0NvTAEjLetBAjh47fjeTG
	pcxcs0fl2Hbn4N880mdz7KbQy0v2mUB19Zar8lvBuPjPE3E/jY6ybCnDgBOltiLauM8L7UQO/o9
	iu6+fDs8DVJqiUD6ceUgBBDOs/W5NVzXmzM7K6O+0kGXvmQ5SInV0svZp62Gyz03rbc6UWihCXF
	Zocpv9BMxp0zQEq8ALVP4wIz3BpdqnEheLuuZFdtLUZK3iEa0G+0qBont6mGmbCJfnub9bwE289
	qNgiuA1Br/Uw6VQWOjATwiKinTNa/5QEskQzUpkQypE=
X-Received: by 2002:a05:600c:a010:b0:4a1:7dcf:be1f with SMTP id 5b1f17b1804b1-4ac166ee4d6mr292750935e9.1.1793709804657;
        Tue, 03 Nov 2026 04:43:24 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c8460acsm4365014a91.7.2026.11.03.04.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 04:43:23 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 0/4] migrates ocfs2 DIO from buffer_head to iomap
Date: Tue,  3 Nov 2026 20:43:04 +0800
Message-ID: <20261103124310.21143-1-heming.zhao@suse.com>
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
to iomap mode. And the code base is commit 4056b3c9d3c92ea, and also
merge Joseph's code and ideas from [1]:

v4 changelog:

Fix several issues found during a sashiko review[2].

To simplify iomap development, we currently adopt the simplest approach:
retaining the buffer_head style, where only one cluster is allocated
per iomap_begin() call.

When creating a filesystem using "mkfs -b 2K -C 8K" (where the cluster
size is greater than the page size), several xfstests cases crashed.
The root cause was an incorrect return value from iomap end_io.

Both the add and del of the orphan inode during write I/O are now placed
in ocfs2_file_write_iter().

Additionally, I attempted to implement .submit_io/.end_io in "struct
iomap_dio_ops" to free dwc inside end_io. However, because ->bi_end_io
runs in an interrupt context and ocfs2_iomap_dio_end_io_write() contains
sleepable functions, this approach required scheduling a workqueue directly
from the ->bi_end_io callback and calling ocfs2_iomap_dio_end_io_write()
within the workqueue thread context. Furthermore, since iomap_dio_ops.end_io
still cannot access any private data, it cannot accurately wait for the
work to finish. Testing with xfstests triggered hangs and crashes.


[1]:
https://gitee.com/anolis/storage-cloud-kernel/commit/ea3fe75e2060118ba093e90b1cd34fa382914b29

[2]:
https://sashiko.dev/#/patchset/20261018143319.22329-1-heming.zhao%40suse.com

v1 patch set:
https://lore.kernel.org/ocfs2-devel/20260724052559.15409-1-heming.zhao@suse.com/
v2 patch set:
https://lore.kernel.org/ocfs2-devel/20260727061802.18485-1-heming.zhao@suse.com/
v3 patch set:
https://lore.kernel.org/ocfs2-devel/20261018143319.22329-1-heming.zhao@suse.com/

--------------
# test report

This patch set has been tested on 7.3.0-rc7 kernel with the following test
cases.

## ltp

runltp -f dio -d /mnt/ocfs2/

1 fail: diotest4    9  TCONF  :  diotest4.c:346: Direct I/O on /dev/null is not supported

This fail can be ignored.

The test results: passed

## xfstests

./check -g quick -T -b -s ocfs2 -e generic/081 \
-e generic/266 -e generic/272 -e generic/281 \
-e generic/338 -e generic/347 -e generic/361 \
-e generic/628 -e generic/629 -e generic/648 -e generic/650 

The test results are the same before and after the patch set.

```
OCFS2_MKFS_LOCAL_OPT="-b 2K -C 4K --fs-features=local --fs-feature-level=max-features"
Failures: generic/003 generic/091 generic/094 generic/177 generic/211
generic/225 generic/263 generic/322 generic/329 generic/331 generic/370
generic/376 generic/424 generic/448 generic/467 generic/477 generic/481
generic/510 generic/513 generic/537 generic/552 generic/563 generic/578
generic/607 generic/620 generic/630 generic/755 generic/760 generic/777
generic/784
Failed 30 of 632 tests

OCFS2_MKFS_LOCAL_OPT="-b 4K -C 4K --fs-features=local --fs-feature-level=max-features"
Failures: generic/003 generic/177 generic/211 generic/322 generic/329 generic/331 generic/370 generic/376 generic/420 generic/424 generic/448 generic/467 generic/477 generic/481 generic/510 generic/513 generic/537 generic/552 generic/563 generic/578 generic/607 generic/620 generic/630 generic/755 generic/777 generic/784
Failed 26 of 632 tests

OCFS2_MKFS_LOCAL_OPT="-b 2K -C 8K --fs-features=local --fs-feature-level=max-features"
Failures: generic/003 generic/075 generic/091 generic/094 generic/112 generic/177 generic/211 generic/225 generic/263 generic/322 generic/329 generic/331 generic/370 generic/376 generic/424 generic/448 generic/467 generic/477 generic/481 generic/510 generic/513 generic/537 generic/552 generic/563 generic/564 generic/578 generic/607 generic/620 generic/630 generic/755 generic/759 generic/760 generic/777 generic/784 ocfs2/001
Failed 35 of 632 tests

OCFS2_MKFS_CLUSTER_OPT="-b 2K -C 4K -N 2 --fs-feature-level=max-features --cluster-stack pcmk --cluster-name hacluster"
Failures: generic/001 generic/003 generic/091 generic/094 generic/211 generic/225 generic/263 generic/322 generic/329 generic/331 generic/370 generic/376 generic/424 generic/448 generic/467 generic/477 generic/510 generic/513 generic/537 generic/552 generic/563 generic/578 generic/607 generic/620 generic/630 generic/755 generic/760 generic/777 generic/784
Failed 29 of 632 tests

OCFS2_MKFS_CLUSTER_OPT="-b 4K -C 4K -N 2 --fs-feature-level=max-features --cluster-stack pcmk --cluster-name hacluster"
Failures: generic/003 generic/211 generic/322 generic/329 generic/331 generic/370 generic/376 generic/420 generic/424 generic/448 generic/467 generic/477 generic/510 generic/513 generic/537 generic/552 generic/563 generic/578 generic/607 generic/620 generic/630 generic/755 generic/777 generic/784
Failed 24 of 632 tests

OCFS2_MKFS_CLUSTER_OPT="-b 2K -C 8K -N 2 --fs-feature-level=max-features --cluster-stack pcmk --cluster-name hacluster"
Failures: generic/003 generic/075 generic/091 generic/094 generic/112 generic/211 generic/225 generic/263 generic/322 generic/329 generic/331 generic/370 generic/376 generic/424 generic/448 generic/467 generic/477 generic/510 generic/513 generic/537 generic/547 generic/552 generic/563 generic/564 generic/578 generic/607 generic/620 generic/630 generic/755 generic/759 generic/760 generic/777 generic/784
Failed 33 of 632 tests
```

## fio on single node

fio --direct=1 --iodepth=32 --rw=write --ioengine=libaio --bs=128k --size=1g \
--numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
- before patch write: IOPS=31.5k, BW=3935MiB/s (4126MB/s)(4096MiB/1041msec)
- before path overwrite (don't remove write.1g, run above fio command):
      write: IOPS=39.5k, BW=4935MiB/s (5175MB/s)(4096MiB/830msec)
- applied patch write: IOPS=37.4k, BW=4676MiB/s (4903MB/s)(4096MiB/876msec)
- applied patch overwrite (don't remove write.1g, run above fio command):
      write: IOPS=39.4k, BW=4929MiB/s (5168MB/s)(4096MiB/831msec)

fio --direct=1 --iodepth=32 --rw=read --ioengine=libaio --bs=128k --size=1g \
--numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
- before patch : IOPS=47.7k, BW=5962MiB/s (6252MB/s)(4096MiB/687msec)
- applied patch: IOPS=48.2k, BW=6024MiB/s (6316MB/s)(4096MiB/680msec)

fio --direct=1 --iodepth=32 --rw=randwrite --ioengine=libaio --bs=4k --size=1g \
--numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
- before patch
  - creating write      : IOPS=3282, BW=12.8MiB/s (13.4MB/s)(1283MiB/100026msec)
  - overwriting write.1g: IOPS=41.8k, BW=163MiB/s (171MB/s)(4096MiB/25115msec)
- applied patch
  - creating write      : IOPS=3230, BW=12.6MiB/s (13.2MB/s)(1262MiB/100031msec)
  - overwriting write.1g: IOPS=40.5k, BW=158MiB/s (166MB/s)(4096MiB/25908msec)

fio --direct=1 --iodepth=32 --rw=randread --ioengine=libaio --bs=4k --size=1g \
--numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
- before patch  read: IOPS=361k, BW=1409MiB/s (1477MB/s)(4096MiB/2907msec)
- applied patch read: IOPS=362k, BW=1416MiB/s (1485MB/s)(4096MiB/2893msec)

---------------------

Heming Zhao (4):
  ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
  ocfs2: switch DIO read path from buffer_head to iomap
  ocfs2: switch dio write path from buffer_head to iomap
  ocfs2: remove legacy blockdev direct-IO path APIs

 fs/ocfs2/Kconfig          |   2 +-
 fs/ocfs2/aops.c           | 568 +++++++++++++++++++++++++-------------
 fs/ocfs2/aops.h           |  38 +--
 fs/ocfs2/buffer_head_io.c |  12 -
 fs/ocfs2/file.c           | 214 +++++++++++---
 fs/ocfs2/ocfs2.h          |  46 ++-
 fs/ocfs2/ocfs2_fs.h       |   3 +
 7 files changed, 616 insertions(+), 267 deletions(-)

-- 
2.55.0

