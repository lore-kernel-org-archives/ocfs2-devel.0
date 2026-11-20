Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795154429;
	b=H9EeqibyjNXuhhOcc2TQKJgAzSa6RoRV1aCswZRbsMO98u7eUjYFwL3uEgoR8WJgcSzX
	 ltw0HTGrX//nLpRj7hP2b1Id16NrN90Pi36LKd8KebYajkjh7VGX9Q5hYqmPP9KnwrNwJ
	 WfSY7egEG0XGFX7l0RWgTtct31Lqu8FxB6cN7W0OdmcXS4v7aMJAZHdOIxsTmAl9wQ+AU
	 gpT58ErmDRPe313L01M+PYcM/1lJRQ/C7u9s4qkKEeb7SNM7PezarD0rbHgV89mzGvUwR
	 yDZ92lw86wg1/ODx126nAyCiepWExsUtXY7GibSxVU4RlOKch5ECpdZjmQ544PqLZhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154429;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=DtK7xc22PFS/DS1SnT4QjONMp7nL9Ef3ondTieqkIMA=;
	b=CC48pxN8zuBEngK1YsojIwL0ol6FjW4cLtTLkWQd4b2ZnIVp//x6mq58pw0KtR69uWkr
	 CQxlbLi+Jm81qQhGloxz/vyBa6eAgDIhpsN/IOEIOxzZ34+u5aFzlfqNdYhuvOxOqcObf
	 P+sYetxMZH3UxE8OFF4ATbIOR6ULGTNqKFELMD4ULUxSm6rsfm5uiCyD4GUUIV9jQfkx0
	 wrdFPKBRVibZR9kTOEpMW8iHB0EwTrvUUolCSXz90G9nFki3GaSF0BQcernMau5O8QEzH
	 /SkLScejW0tJ8IN+2uYRrp5D2f3W9SKd5xwC9NMO+U+HQH6fZpdI62mUWYtFvXr17Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=SWYAgrUp;
	arc=none smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22477606A51C
	for <ocfs2-devel@lists.linux.dev>; Fri, 20 Nov 2026 06:00:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22477606A51C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=SWYAgrUp
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c504707acfeso8027566b.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 19 Nov 2026 22:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795154426; x=1795759226; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DtK7xc22PFS/DS1SnT4QjONMp7nL9Ef3ondTieqkIMA=;
        b=SWYAgrUpKTTQpyVyplFMJp4RFYlJ8GFLRRpIdMujA7fDcGqSHSU/pYzdFU+NPoXkN0
         jKHIBFiVqXYP2+fawqT7hEdMvuSsrdyVwqQk74IOyvOi/Vu3vhT4ghFf9hyENvv+cniP
         Ha1rmDwuLOraMFvPu0Yhw99lL/xT4QMMjgxk8aNqgbMnPVlqJQ/VttQL0ob6vWqH8nOD
         uG6fvs5TRRutfxSZSDcVjL2ISvsjznKPUPub3ZHAkWVrcioRJuzVDNekiBlfkefDD8+D
         LvVgNN7GUHA16D58q8zI0VH3E1opqxqxAqzkbd7dZRW6FeJi4XZun8bqNIBIxyt0Z8ly
         fHfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795154426; x=1795759226;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DtK7xc22PFS/DS1SnT4QjONMp7nL9Ef3ondTieqkIMA=;
        b=HMx2pozojiWtJyKUoaef5OtT3XyX3XvLud3Hqb9PjTYLgQtKKITDN8lSzmav3AXBSz
         JgfC7OmsN5ys5xoD0e+a6Hsl2RAAwuq2lch6VFHg2nx1kgrUn3WuJMSh7HeGcbkFfWc6
         fOOke8t+n4CSFx6N0SiZn+72xJfEl+oVYrtzjW7Xbew/Mx1cEJ5c1Q31+m1aXtIRttYD
         WR6Hm7Q7SjhXQ2SuZIIUCFzlnqgWWeC53gN2HvZp3jatzNljwO1GRzsdfxJegR6plwLr
         +yLziRzzy46quzmZ2f2aQbak52ju+dopTn/z6ZZeVCuCxQoBHCQiPZJ/KsNRu7aZkmuF
         chng==
X-Forwarded-Encrypted: i=1; AL+hErHZ8p76+w4rL2vJiphmgxWCouKplYr4CCr1SThkiRwkpy/flYgG/8tsOCE9+pXi61pZThK54jnFsm46Yw==@lists.linux.dev
X-Gm-Message-State: APuU4Z8QWmiF2AVFiK3ZEHD2caEXX9jOb3+haGaOd3ryb6qdNGZf7VrV
	P29te5GipUmPP2PZajMjIIMJP9UhBT3B3asDzW4qM3EYh50cGh5eTiddPW+OXjAONlY=
X-Gm-Gg: AYBFou1up/CexQvJzFuX6NsJUpRdD3F9yC37urNrBqjvm61Xawy9CyZ9Iovi3YhaTz8
	extfGVtR5hJ6CAZdnei8MnvXCBOBKn9QVDSu//Y+89ahNMYI1QzvPN3tDtnYqCm7LaDiyqwbuy4
	wcwdEemexHEiZbB3DJOeiLEAOz4uODbwALJVhMF+xrOHnedUy1TtC14dF5gwktKs9l5xUfuIosy
	X5E313XhEU/PsPEIUcfjvLzok7u2gpTC2OS/svFyqTkfgdah+9Poqb3/SzFnPA9sM2pTzU7skg6
	mBufFiDK2wxesW4sHHM/foYeN+astXeANeHYv9m5nt79PNlo0GIsEcXIqBcn5mcNlcdQImHUUbT
	cBR1m12afP0TmPWvAQCCSVIq6NLgTR4FXrbB5u2AgJvcNaGjsWaRxKDIRteMsXSL1IMnoY70tYK
	eTHZfgsEv8FunQdSqjPirpkI86ktULFMkl3f2IQ0VZu2eW/hFJzIh9v31YV+YczZjD+JD8xbmB/
	QFlnpgB7+mWO1w6L/fAPtf2s2CdTV7e+aRnK0CP7YvcsuIV7X9rqyR/+zcQKoQW24ALBeBkXpIT
	5SN4vzMEM0eGe3b1XyGPEY7QZpFssSIdZHbL1gLfbqk=
X-Received: by 2002:a17:906:cedc:b0:c51:269e:5c7b with SMTP id a640c23a62f3a-c513a85b344mr187941866b.4.1795154426377;
        Thu, 19 Nov 2026 22:00:26 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87343f571sm918597b3a.34.2026.11.19.22.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 22:00:25 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v9 0/3] migrate ocfs2 DIO from buffer_head to iomap
Date: Fri, 20 Nov 2026 14:00:10 +0800
Message-ID: <20261120060014.12087-1-heming.zhao@suse.com>
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

V9 changelog:

Address sashiko's review comments [3] (all changes are in patch [3/3]):

ocfs2_file_write_to_iter():
- switch pr lock to ex when DIO falls back to buffered IO
- Fall back to buffered I/O for a direct write when block size is smaller
  than the page size and the write does not cover whole pages
- clear orphan when rw_lock is still held

ocfs2_dio_wr_map_blocks may use a value beyand u32 to call
ocfs2_clusters_to_blocks()

initialize oi->ip_dio_orphan_pid and oi->ip_dio_orphan_end in
ocfs2_inode_init_once()

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

(4k blocksize 4k clustersize, local mount)

fio --direct=1 --iodepth=32 --rw=write --ioengine=libaio --bs=128k --size=1g \
--numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
before patch: write: IOPS=32.2k, BW=4028MiB/s
after  patch: write: IOPS=38.6k, BW=4824MiB/s

fio --direct=1 --iodepth=32 --rw=read --ioengine=libaio --bs=128k --size=1g \
--numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
before patch: read: IOPS=49.1k, BW=6132MiB/s
after  patch: read: IOPS=50.9k, BW=6360MiB/s

fio --direct=1 --iodepth=32 --rw=randwrite --ioengine=libaio --bs=4k \
--size=1g --numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
before patch: write: IOPS=14.4k, BW=56.4MiB/s
after  patch: write: IOPS=14.4k, BW=56.1MiB/s

fio --direct=1 --iodepth=32 --rw=randwrite --ioengine=libaio --bs=4k \
--size=1g --numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
before patch: read: IOPS=382k, BW=1492MiB/s
after  patch: read: IOPS=419k, BW=1637MiB/s

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

-----------------------

Heming Zhao (3):
  ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
  ocfs2: switch DIO read path from buffer_head to iomap
  ocfs2: switch dio write path from buffer_head to iomap

 fs/ocfs2/Kconfig      |    2 +-
 fs/ocfs2/aops.c       | 1685 ++++++++++++++++++++++++++++++++---------
 fs/ocfs2/aops.h       |   43 +-
 fs/ocfs2/extent_map.c |   34 +-
 fs/ocfs2/extent_map.h |    3 +
 fs/ocfs2/file.c       |  314 +++++++-
 fs/ocfs2/inode.h      |    9 +
 fs/ocfs2/mmap.c       |    2 +-
 fs/ocfs2/ocfs2.h      |   25 +-
 fs/ocfs2/super.c      |    3 +
 10 files changed, 1690 insertions(+), 430 deletions(-)

-- 
2.55.0

