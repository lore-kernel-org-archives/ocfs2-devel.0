Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714181;
	b=yXE8AMOl+l+qjhX5BHnR02Bg2QojRt0QL8jjmot4rJkbjHKMXksByBuHxCKA3u4jM3QD
	 TwNFSgW/wQpLE/2I1vp3Gl21G3kHr2k/wF7YDNKaegZUwxQFnXArExzbY00chOnJq6+bB
	 5wKnVYyfzvHbplFS+Rfudp7T5OVeAEgpeAu6I6hV1FkeSxGJI/26zsds32KCzjass8fz0
	 8HfKKdaywdsXEKQamTNwd33ieNf/UB9xDXH8/C5OPdoXx4KbfKfTcbcxqDKplSh2emGak
	 /uO54LAY+/M3tyFlg0CZYOzkgPeqQVCkOHHXI3lHpdtc7WpC+bVZiEtLvW4GWs87kZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714181;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1mF/Wb+MOtAslfyKD+az4LMnyLK9TBg4kE+T6uVGVAg=;
	b=DrzaYGsC4gzAWQ+akTvh7gPdmDDmo+HIBa2K8Ape6zZM2iWeMWW8jUgfaDsqSZCLFd+D
	 hfNseb4lAvq6cUKWTUS0ejaebBLKWcXnZkKLB6qZiEPOeTOnXtPHl0rOhnZhp6IGqOm8P
	 gS9JTx1Hc6I8mbIDxNK+3JPS6p4gpuCghVqVP+5d4bz8UO6qR24aWooZLIrYFxhBlp25F
	 kv/vlMpYyMXLTko1OIFQ9Dc6udfCXKRwSeJGCMRAs+MavrjlLpH2CKGcC3Jfx+CVjXKrd
	 WGsNMoElpV+350U20oCmxEI+314EP1oyVvDuBVZlfLCiDn8XsppJC2WyaF3cVGugWlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=cxoNiX8X;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D412A606A330
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Nov 2026 13:56:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D412A606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=cxoNiX8X
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a599e9110eso21766835e9.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Nov 2026 05:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793714178; x=1794318978; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1mF/Wb+MOtAslfyKD+az4LMnyLK9TBg4kE+T6uVGVAg=;
        b=cxoNiX8X8xJ3g2t0jKRjn6v0MmDL+16dir1kLZJsdbqhJIki9Z6bcKEqe5V9hCbhW2
         tMHu96wK2gHE0dSwykU7CuGAtntSCwZq4QR1gBHVSUFatnamkdtdqWjYljKfivYV7Gfu
         qr39meagDnKWJDJvDMpyMQ/HO5iDOsMwx3IgMYv36ZC3wg+YV4XGTMTdbElo36QnVSwU
         DMQa9kYB0M68LJ3cq6pl0ObLaO5J2qYv1HjjhY1keKcsf9NdIr8GCblYKrLAWvJGlJBL
         tbbdDCMvMMQuh5zUcEjQ7baB/4UbfPB2VGLlk/r/c3IkM1hNwsgZCbSIw6pf57QXgYvg
         viLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714178; x=1794318978;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1mF/Wb+MOtAslfyKD+az4LMnyLK9TBg4kE+T6uVGVAg=;
        b=ulHI5/99Fs5hYzJK2pZ+GLbe2cYlOy6RDRXJXqorkGEwHS2Dcoy59jSui9zkFGSLvp
         sTZj3wc8x4coPR8LwWmb7QtF2DULzT7MKUk3TOVV+dK/JGADbaTc8XugnPazrXRbKPNK
         dlRA3WEatJvD619iO7Cjx8ClZWcMMW25+yiyJ5LvPzQUTojHL0Sm6oV0z2tYenfOTSeO
         BnOBxOcJx3fshhCpxS9+ITrHaPWqLjkQcj6ni5C644KzZotLX9RIIXOzMCViiyfpz8xu
         lYYH4GSSXw8io3Wxb5RwqIoAg9xG9JXY+W6t/mH+rRRpwkeTXkb/ZasElwNMn4a9HmUr
         H2Jg==
X-Forwarded-Encrypted: i=1; AKwUvByI9XL1lWgy8iniNh9jRWFp9LrnNHrDYT8nkBFgfEG4lu0/q/snvwa3B3fOFzqgp8RQDvOQpOCuJ35YDg==@lists.linux.dev
X-Gm-Message-State: APuU4Z9KHTbJoyecJnJI5clLBvGGZdmUNIY8bv/8ISTDPWkefegB1/Nt
	OLmgNXL/6Q3Wb/ryKCaAG1r3Cu92seIMi0YGcMGpL2wl47XVxHuMJs3FtPD/smX+hVb1+i+RsP3
	bkRtTom8=
X-Gm-Gg: AYBFou3sL631+yacA1xjHoBAnUTmgjwWIgf+5hVgpsbE0dVGd0FOrQ5OU9/ldBg4zf7
	wus+GUAntD5fVXv4NJGASQNn8wl0mGc8mmGAXHnUPv8X8IVzmIFZgcT8c6NDpWplEiTDdyLrUia
	J8QKOpXIYN9i8QB7ZwoV/65RVFSZpKcHWbJjdDqmcewngbHpbbV0SPobX85IFmWj4xY7GIeYCQ+
	iU0noov47+58lSPYBcMmSijXN+mWfmnWyzU764qGh1rwlS4maSpLpk4TqTd1N5tPPWyvjuwK+7u
	fbtWGrNtimNg2+AMN1PrfcKJSyBzuZM9PfBRDxcURM7nJUsupphYw70M1xCwBeHVmLkuB6dIWs2
	NYnfT5WdVtN98oEEsOjNR7cMGniMjJEG+KfoXYGfbqHL29EAwpO+4yxnrLFwmnSlASHBppnW+jS
	hazE/QmcdMxRvTxk7h779vbpoNn657vAeC7Gfil+SlWVh7VQklD9T6moeIvldQ0swGSaXbc0DAD
	kyGhouv5/gWORLubCxdT73EZuvG7QoT/hkTLXgdo7ojZQbPk0fxSlAg6cjFpDyxQ2X8MoJSGdVA
	owHbmdDoEL6jvKtckd8KKxk/LHjzCTLtbcZ36giAFfY=
X-Received: by 2002:a05:600c:1c06:b0:4a1:e015:6441 with SMTP id 5b1f17b1804b1-4ac12194311mr366054135e9.0.1793714178228;
        Tue, 03 Nov 2026 05:56:18 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac13ef1a16sm39629747c88.1.2026.11.03.05.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:56:16 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RESEND RFC PATCH v4 0/4] migrates ocfs2 DIO from buffer_head to iomap
Date: Tue,  3 Nov 2026 21:55:59 +0800
Message-ID: <20261103135605.22943-1-heming.zhao@suse.com>
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

Previously, I sent a v4 patch set based on commit 4056b3c9d3c9 (v7.3),
which caused sashiko to fail to apply the patches. Therefore, I am
resending the patch set based on commit 6628e7d4c6b2 (v7.4-rc1).

---
This patch set migrates ocfs2 Direct I/O (DIO) from buffer_head mode
to iomap mode. And the code base is commit 6628e7d4c6b2, and also
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
Failures: generic/003 generic/177 generic/211 generic/322 generic/329
generic/331 generic/370 generic/376 generic/420 generic/424 generic/448
generic/467 generic/477 generic/481 generic/510 generic/513 generic/537
generic/552 generic/563 generic/578 generic/607 generic/620 generic/630
generic/755 generic/777 generic/784
Failed 26 of 632 tests

OCFS2_MKFS_LOCAL_OPT="-b 2K -C 8K --fs-features=local --fs-feature-level=max-features"
Failures: generic/003 generic/075 generic/091 generic/094 generic/112
generic/177 generic/211 generic/225 generic/263 generic/322 generic/329
generic/331 generic/370 generic/376 generic/424 generic/448 generic/467
generic/477 generic/481 generic/510 generic/513 generic/537 generic/552
generic/563 generic/564 generic/578 generic/607 generic/620 generic/630
generic/755 generic/759 generic/760 generic/777 generic/784 ocfs2/001
Failed 35 of 632 tests

OCFS2_MKFS_CLUSTER_OPT="-b 2K -C 4K -N 2 --fs-feature-level=max-features --cluster-stack pcmk --cluster-name hacluster"
Failures: generic/001 generic/003 generic/091 generic/094 generic/211
generic/225 generic/263 generic/322 generic/329 generic/331 generic/370
generic/376 generic/424 generic/448 generic/467 generic/477 generic/510
generic/513 generic/537 generic/552 generic/563 generic/578 generic/607
generic/620 generic/630 generic/755 generic/760 generic/777 generic/784
Failed 29 of 632 tests

OCFS2_MKFS_CLUSTER_OPT="-b 4K -C 4K -N 2 --fs-feature-level=max-features --cluster-stack pcmk --cluster-name hacluster"
Failures: generic/003 generic/211 generic/322 generic/329 generic/331
generic/370 generic/376 generic/420 generic/424 generic/448 generic/467
generic/477 generic/510 generic/513 generic/537 generic/552 generic/563
generic/578 generic/607 generic/620 generic/630 generic/755 generic/777
generic/784
Failed 24 of 632 tests

OCFS2_MKFS_CLUSTER_OPT="-b 2K -C 8K -N 2 --fs-feature-level=max-features --cluster-stack pcmk --cluster-name hacluster"
Failures: generic/003 generic/075 generic/091 generic/094 generic/112
generic/211 generic/225 generic/263 generic/322 generic/329 generic/331
generic/370 generic/376 generic/424 generic/448 generic/467 generic/477
generic/510 generic/513 generic/537 generic/547 generic/552 generic/563
generic/564 generic/578 generic/607 generic/620 generic/630 generic/755
generic/759 generic/760 generic/777 generic/784
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
 fs/ocfs2/file.c           | 213 ++++++++++++--
 fs/ocfs2/ocfs2.h          |  46 ++-
 fs/ocfs2/ocfs2_fs.h       |   3 +
 7 files changed, 616 insertions(+), 266 deletions(-)

-- 
2.55.0

