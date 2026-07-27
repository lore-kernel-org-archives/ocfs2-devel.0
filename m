Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9238B374E5B
	for <ocfs2-devel@lists.linux.dev>; Mon, 27 Jul 2026 06:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785133095; cv=none; b=LlmCcD4G37h/6QGqpImP3gnWo7QvWQSJ+2KK1UXVh/SKxmlBDbDrhMgzYyW00Bdxr6e3QbygqqzSYbUvj9FLYGGNNMxpHvSbgftPEAEJ7yHuzBQWVxF0gVAAFqPdY2ia3xXJNQHrPM2vVrslbUqVv3FFN+zmIbjq/+C1vZoMCoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785133095; c=relaxed/simple;
	bh=QBP9a89AMNaQ8DRac7GhUKzUutZi3smd70+sHc0L+RY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VKVwcFkmaT89nzJ55hp8r1fsSBnpiqxAwD/npBjyyRXzFm3INQnxegg82H+zRvtFXfsOZT/ZvZnYCpfNbj+oJH+4Hzsws3TdsNRZS16/C24B4eo7w96X91kqPVXlhC1iyc5uV8aeIVR8Cur79nuTQc2VeJcsvY/REklzYq+VFSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JWEVdZsJ; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JWEVdZsJ"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-698af3e3620so289062a12.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 26 Jul 2026 23:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785133091; x=1785737891; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=H3RnS+SAmK8gHqGJ7lt2BLTRqjrhBIWUbM3/GTl6MUM=;
        b=JWEVdZsJCduv2J3b5Zn38a/8MnwwbTK5riiIqNwjgCBF79vPOdE5yRVQ5zrrSVFFnx
         SjSBk14L9zqFEaXOEESS8HzbvzB58HVbg2o33hj/NCcqbzL7lGaVR+IoIXPQOPPDD4Nn
         oZ3A7XtIDZpE8fNH3AcglqjOCXgiMZ24nNutJt1gjBq0zBFQcm0Q1HME9t9wrjB5XkNB
         BVzYiMsv9kZ6FqFfNPl+8z/ABMqo/DlRqIQV+YCawLUjwIp6Rq5RmqY6Or1ku4YthzOD
         /OsG1kX7jHtFgQ0+oUS9heX0djz2xIxGk+haY9yn1fPadGQsBKWifvatLTrYiTI4vzyZ
         kN1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785133091; x=1785737891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H3RnS+SAmK8gHqGJ7lt2BLTRqjrhBIWUbM3/GTl6MUM=;
        b=Pto5ux0JTr22hmYfziEgpb5Nhxy0uozCUe1gXXVHfIYq34zDdVM85Lt1Y/CkPXazhY
         f2ei4t/g0hDz4r3C93wDOCu0KH5q0tI+wCGgn0RiPOzIl7YLnsTwOuS0dDMyKQSccXm4
         V664OzrtQTVCXeglnntJA2cemHF2KfP7uTU89AKUccSF+BCagvAum7alq5bQ3p3T2bRv
         6I/mlv8GS0xYCwv74LoRgHRtm54NL6QGUcaNkBDcXSAgWF/S4kz4SqlpdZZa5uA20jjl
         Ig2ZeFVMQdZONjiDPFnAwE5mfE4+dEwRvcf6RT8ZRnVd11n1KXQWzhMv9lzODXBtk2cq
         s8Aw==
X-Forwarded-Encrypted: i=1; AHgh+RquAS0HdFepT+ZUihWmYu3HhydW77deYn43keUQCd4BYKjE151Ye8yWHLWXdzPj3f4axbV9LSKPoTHU6g==@lists.linux.dev
X-Gm-Message-State: AOJu0YyEZOPOjibhxOerS7yx2KZ6NA7Xm17LUI5gOCuhv/Wb7PSWMCux
	p7aPsmJeQbNbPAvtL5v8cD2pqx2HYufleyNZqPjahdV+Y9S0feHtga0YwdP2LknbPnk=
X-Gm-Gg: AR+sD11AeEXAxmj+EARFahVi3vQyBePAwuh7YiLpH9ALJHfKuBL1QPtakV0KJJ39StO
	5zEbrrNFk9j8xBtIbXzS7WS3wSgj6T3bETc3X/4UhAEsl23ggpeP5H7Eh8E8L6ENHlHGjfwlaFJ
	/CYX0ra0gEVnseET8ihSxldoR2ds422BlX4Hcvm7gi7zpaZxt4UMA9b1SU8796odntQHNIKWVgV
	+51ReQlhk3OKpoDfDaPw6OhvON6qR7ejy2RxaP8Qt4JeFACQ4zPcrv3HdGqVAoEk+4nqsdUytHC
	FbROk2FlyqlbjGZstMV2v2jK2r1jr84y2qFrHdmHxTa1IjbDRSEl+Ukx323LoteERfLgLvcX+7H
	rIsZ9PFyBj2A6T13H7olXk81GgvPiL6+KqWggB/I2Fh+o6VvVPoP2a4F22KHb7gRCQg1+I+M26T
	UOhz8=
X-Received: by 2002:a05:6402:c1c6:b0:69f:ce9a:89 with SMTP id 4fb4d7f45d1cf-69fce9a04f0mr1907498a12.1.1785133090661;
        Sun, 26 Jul 2026 23:18:10 -0700 (PDT)
Received: from p15.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f2951f0afsm2583300a91.16.2026.07.26.23.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 23:18:09 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 0/4] migrates ocfs2 DIO from buffer_head to iomap
Date: Mon, 27 Jul 2026 14:17:56 +0800
Message-ID: <20260727061802.18485-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set migrates ocfs2 Direct I/O (DIO) from buffer_head mode
to iomap mode. And the code base is commit 58717b2a1365d.

Changelog:
v2:
- Merge Joseph's code and ideas from [1]:
  - Add FMODE_CAN_ODIRECT to f_mode in ocfs2_file_open()
  - Change iomap_ops and iomap_dio_ops API declarations from ocfs2.h to
    aops.h
  - Switch from iomap_dio_rw to __iomap_dio_rw + iomap_dio_complete
  - Change "struct iomap_dio_ops" from read/write style to PR/EX locking
    style. With this approach, we completely eliminate the need to define
    any iocb->ki_flags bits.
- Remove alignment code from ocfs2_should_use_dio(), because iomap internally
  already handles this.
- Add patch 4 to remove unused functions and the CONFIG_LEGACY_DIRECT_IO
  Kconfig option.
- Add "Co-developed-by: Joseph Qi <joseph.qi@linux.alibaba.com>"

[1]:
https://gitee.com/anolis/storage-cloud-kernel/commit/ea3fe75e2060118ba093e90b1cd34fa382914b29


v1:
https://lore.kernel.org/ocfs2-devel/20260724052559.15409-1-heming.zhao@suse.com/T/#t

--------------
# test report

This patch set has been tested on 7.2.0 kernel with the following test
cases.

## ltp

runltp -f dio -d /mnt/ocfs2/

The test results: passed

## xfstests

./check -g quick -T -b -s ocfs2 -e generic/081 \
-e generic/266 -e generic/272 -e generic/281 \
-e generic/338 -e generic/347 -e generic/361 \
-e generic/628 -e generic/629 -e generic/648 -e generic/650 

The test results are the same before and after the patch set.

Failures: generic/003 generic/322 generic/329 generic/331 generic/370
generic/376 generic/420 generic/424 generic/448 generic/449 generic/467
generic/477 generic/510 generic/513 generic/537 generic/552 generic/563
generic/578 generic/607 generic/620 generic/630 generic/755 generic/777
generic/784
Failed 24 of 632 tests

## fio on single node

fio --direct=1 --iodepth=32 --rw=write --ioengine=libaio --bs=128k --size=1g \
--numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
- before patch : write: IOPS=18.8k, BW=4708MiB/s (4937MB/s)(4096MiB/870msec)
- applied patch: write: IOPS=39.6k, BW=4953MiB/s (5193MB/s)(4096MiB/827msec)
- overwrite (don't remove write.1g, run above fio command) speed seems same. 

fio --direct=1 --iodepth=32 --rw=read --ioengine=libaio --bs=128k --size=1g \
--numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
- before patch : read: IOPS=52.4k, BW=6554MiB/s (6872MB/s)(4096MiB/625msec)
- applied patch: read: IOPS=52.2k, BW=6522MiB/s (6839MB/s)(4096MiB/628msec)

fio --direct=1 --iodepth=32 --rw=randwrite --ioengine=libaio --bs=4k --size=1g \
--numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
- before patch
  - creating write: IOPS=20.9k, BW=81.7MiB/s (85.6MB/s)(4096MiB/50159msec)
  - overwriting write.1g: write: IOPS=281k, BW=1097MiB/s (1151MB/s)(4096MiB/3733msec)
- applied patch
  - creating write: IOPS=21.0k, BW=82.0MiB/s (86.0MB/s)(4096MiB/49938msec)
  - overwriting write.1g: write: IOPS=329k, BW=1286MiB/s (1348MB/s)(4096MiB/3185msec) 

fio --direct=1 --iodepth=32 --rw=randread --ioengine=libaio --bs=4k --size=1g \
--numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
- before patch : read: IOPS=372k, BW=1452MiB/s (1522MB/s)(4096MiB/2821msec)
- applied patch: read: IOPS=369k, BW=1441MiB/s (1511MB/s)(4096MiB/2842msec)


## fio on two nodes

### write in different folder

node1 /root/fio/diff/ocfs2-w.sh:
> fio --direct=1 --iodepth=32 --rw=write --ioengine=libaio --bs=128k --size=2g \
> --numjobs=2 --runtime=100 --group_reporting --filename=/mnt/ocfs2/node1/write.2g --name=tst

node2 /root/fio/diff/ocfs2-w.sh:
> fio --direct=1 --iodepth=32 --rw=write --ioengine=libaio --bs=128k --size=2g \
> --numjobs=2 --runtime=100 --group_reporting --filename=/mnt/ocfs2/node2/write.2g --name=tst


node1 /root/fio/diff/ocfs2-randw.sh:
> fio --direct=1 --iodepth=32 --rw=randwrite --ioengine=libaio --bs=4k --size=2g \
> --numjobs=2 --runtime=100 --group_reporting --filename=/mnt/ocfs2/node1/write.2g --name=tst

node2 /root/fio/diff/ocfs2-randw.sh:
> fio --direct=1 --iodepth=32 --rw=randwrite --ioengine=libaio --bs=4k --size=2g \
> --numjobs=2 --runtime=100 --group_reporting --filename=/mnt/ocfs2/node2/write.2g --name=tst

run on both node, 
pdsh -w ssh:tw2510-[1-2] /root/fio/diff/ocfs2-w.sh
- before patch : write: IOPS=19.3k, BW=2417MiB/s (2534MB/s)(4096MiB/1695msec)
- applied patch: write: IOPS=20.8k, BW=2599MiB/s (2725MB/s)(4096MiB/1576msec)
pdsh -w ssh:tw2510-[1-2] /root/fio/diff/ocfs2-randw.sh
- before patch : write: IOPS=3742, BW=14.6MiB/s (15.3MB/s)(1462MiB/100007msec)
- applied patch: write: IOPS=3765, BW=14.7MiB/s (15.4MB/s)(1471MiB/100010msec)


### write in same file

node1 & node2: (/root/fio/share/ocfs2-w.sh)
fio --direct=1 --iodepth=32 --rw=write --ioengine=libaio --bs=128k --size=2g \
--numjobs=2 --runtime=100 --group_reporting --filename=/mnt/ocfs2/share/write.2g --name=tst

node1 & node2: (/root/fio/share/ocfs2-randw.sh)
fio --direct=1 --iodepth=32 --rw=randwrite --ioengine=libaio --bs=4k --size=2g \
--numjobs=2 --runtime=100 --group_reporting --filename=/mnt/ocfs2/share/write.2g --name=tst

run on both node
pdsh -w ssh:tw2510-[1-2] /root/fio/share/ocfs2-w.sh
- before patch : write: IOPS=2052, BW=257MiB/s (269MB/s)(4096MiB/15967msec)
- applied patch: write: IOPS=2558, BW=320MiB/s (335MB/s)(4096MiB/12808msec)
pdsh -w ssh:tw2510-[1-2] /root/fio/share/ocfs2-randw.sh
- before patch : write: IOPS=3588, BW=14.0MiB/s (14.7MB/s)(1402MiB/100001msec)
- applied patch: write: IOPS=3590, BW=14.0MiB/s (14.7MB/s)(1403MiB/100001msec)

Heming Zhao (4):
  ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
  ocfs2: switch dio read path from buffer_head to iomap
  ocfs2: switch dio write path from buffer_head to iomap
  ocfs2: remove legacy blockdev direct-IO path APIs

 fs/ocfs2/Kconfig          |   2 +-
 fs/ocfs2/aops.c           | 650 ++++++++++++++++++++++++--------------
 fs/ocfs2/aops.h           |  37 +--
 fs/ocfs2/buffer_head_io.c |  19 +-
 fs/ocfs2/file.c           | 161 ++++++++--
 fs/ocfs2/ocfs2.h          |  45 ++-
 fs/ocfs2/ocfs2_fs.h       |   3 +
 7 files changed, 596 insertions(+), 321 deletions(-)

-- 
2.54.0

