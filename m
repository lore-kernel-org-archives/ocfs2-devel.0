Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BADB36B917
	for <ocfs2-devel@lists.linux.dev>; Fri, 24 Jul 2026 05:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784870778; cv=none; b=FSILWVdO53CnLxswA/C5kqxgHTmRVgUQpw7hTV8jC868h5auuM7CXvam1gJno8lhmxMTtUPb811rJfuI2IAW6eyhbCeMRXsqUNNnZdyyKEAq6crMqOLF/cdwf2jGAZ8P7CPRZtHyVdumc9SmX2nq2VO9+9p6SsLAeskbDGdEZOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784870778; c=relaxed/simple;
	bh=WKqoca10O4t3Oju347uRIWeepA/cddxAeo+Q1+BF/BY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gEJ1EnZZMANKJDosVTCfszcHs8JeFfS9MqqqAB7Q4pTIZ66+tGGqtHmLs33TfsL5qD7haSQrm3f38OMXQLe1GEGMbzDXs5KDa58yQ6GThDjCsvkW3SrC/AOIXn06Kumn2iaCgtC3sr5ICeU2ypUhfE0YG0O0SY1EtdAOsH4JqZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=N8j6cYTY; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="N8j6cYTY"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-69af1bc780bso5803a12.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 23 Jul 2026 22:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784870774; x=1785475574; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=r268vXjA5mG0+LPoOSbwKU1HHavlapa/3U4ORjTQk7M=;
        b=N8j6cYTYuMEYZyqVpBmL+1zOKREJSovIWFpDbn1tum3Y+GIlWuknPa6C3h8i+Wqdrk
         FNpy7FR7aSwnZssDz/jLhxtG0tThmoNJAdmbmn+5j2cwTN84XBz1lM5584Guy4RyCjlo
         FHEZAonm52psv/Y6UBgXkCsYb6+JVaQ+MSjqVZ0XnqYk6ZEu6PBgjB58k/8/lCYdvDcl
         Rb1DImTUyjhqwb+RWCpxNhYsTaB4mpCJaV9YPZlY0jWAuj3lhZ0fKdl5cKk1UDuGP5c6
         gH8V3prFsCcMJwbg28Th70Os1V0W7CHXfKnBC2mgMyE6t0zoCJ4BkaU23TrHUWoO/D75
         zxMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784870774; x=1785475574;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r268vXjA5mG0+LPoOSbwKU1HHavlapa/3U4ORjTQk7M=;
        b=GE7/yhY3SLoGw38Ydj+8pC18aMP9XaP41uk46bMojtfclz19ohNJ7okJTaVMsI4US2
         CJQFVXrdZOpuhE2CR6xjZcBD6s1CK97HFkYotBTdOVhdpoM4GHWwPv8SgXCy/XdVRJv1
         URL7qVh6iC+gHwnP8pwWDHvrcAFn9LQ9UjzQyRX00AYsoa7rNpgjq4YPZ9ojX5dLfyB0
         NxJ22wiXBnxK4O1SCbvZ6cOKwzdsy5NBWlVSuH/s7R3U4vwNuEVfGTQVcLKRirDCO0h0
         60jPSQTzsNYkXwV6Wjt7SXSOJ4ypedSsf1PtFurO7pHMkt723uXUPDoT/ES2VJb6gt1u
         lxXg==
X-Forwarded-Encrypted: i=1; AHgh+RrojKNMfqd52K+CUbwk9siL0nRwUGkb+0Z16NcsndRVOy5/JEjg1vbBRCduWeHv8hr3GOADbtI/JBewbA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5NJYT0bIogitJ5TsftOneESfI8rfFgysAtNQYxQvJKVLmem9R
	iRgb+4WlNW7kKZ/4pM+03+VWA+ntbnpE9OfwiB8YkZHs3mzpBtfUCoz3dLZ/anT2E0s=
X-Gm-Gg: AR+sD11eqgVqmYPach0pMQro89moGV/o8t/nMCx1p8z/8zI99JSybR/ujHcTjk5Tr3V
	1GZE2uYEUPHa04/DF4tUXqipTif5sArZmebzddALFIDo5jbxvE+t0iedKl9muUMtifljQB0ueJ3
	7fmtn+KjvhJQNj1ZHfo5ATr2Ru2CJYIwgBjYExBnifRa7RpOPOdJRdcLTBKpsBEtG5MtN15HyJ8
	lqiRBqtWjHFJ4YjcVgAHI94Ii5qyDlsL0LFGNcTECdg0UZawcGgKg38W2kcCv4pQWYdU3hv3oEH
	Oysb3z2oEUu8CFZXdKOofnO077kmji1q5lLbgtleLH0r/RJZ682fBzB4wJVhTwyEMLstdq06tUJ
	xiqNsYzfaot1SxBRXTt0HXT9vTBzVlwU2MKi+3mkq4PnTSmAb6ayFfTF96xokeoLuvY20w6tIEF
	/MJgk=
X-Received: by 2002:a05:6402:5255:b0:697:deb8:761a with SMTP id 4fb4d7f45d1cf-69f8ddeed17mr549117a12.6.1784870774551;
        Thu, 23 Jul 2026 22:26:14 -0700 (PDT)
Received: from p15.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f039b1ce3sm898577a91.4.2026.07.23.22.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 22:26:13 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/3] migrates ocfs2 DIO from buffer_head to iomap
Date: Fri, 24 Jul 2026 13:25:54 +0800
Message-ID: <20260724052559.15409-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set migrates ocfs2 Direct I/O (DIO) from buffer_head mode
to iomap mode.

For patch [2/3], this patch leverages the top 2 bits of `iocb->ki_flags`
(`IOCB_OCFS2_RW_LOCK` and `IOCB_OCFS2_RW_LOCK_LEVEL`) to safely carry
the lock state into the `end_io` callback. If this patch set is accepted,
I plan to submit a follow-up patch to the iomap module to introduce two
dedicated flags for `iocb->ki_flags`, avoiding the need to use the top
two bits internally in iomap.
i.e.:
```
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 50ce731a2b78..ad9fd768746e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -357,6 +357,8 @@ struct readahead_control;
 /* kiocb is a read or write operation submitted by fs/aio.c. */
 #define IOCB_AIO_RW     (1 << 22)
 #define IOCB_HAS_METADATA   (1 << 23)
+#define IOCB_FS_PRIVATE1    (1 << 30)
+#define IOCB_FS_PRIVATE2    (1 << 31)
 
 /* for use in trace events */
 #define TRACE_IOCB_STRINGS \
```

----------------

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
--numjobs=2 --runtime=100 --group_reporting --filename=/mnt/ocfs2/node1/write.2g --name=tst

node2 /root/fio/diff/ocfs2-w.sh:
> fio --direct=1 --iodepth=32 --rw=write --ioengine=libaio --bs=128k --size=2g \
--numjobs=2 --runtime=100 --group_reporting --filename=/mnt/ocfs2/node2/write.2g --name=tst


node1 /root/fio/diff/ocfs2-randw.sh:
> fio --direct=1 --iodepth=32 --rw=randwrite --ioengine=libaio --bs=4k --size=2g \
--numjobs=2 --runtime=100 --group_reporting --filename=/mnt/ocfs2/node1/write.2g --name=tst

node2 /root/fio/diff/ocfs2-randw.sh:
> fio --direct=1 --iodepth=32 --rw=randwrite --ioengine=libaio --bs=4k --size=2g \
--numjobs=2 --runtime=100 --group_reporting --filename=/mnt/ocfs2/node2/write.2g --name=tst

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

Heming Zhao (3):
  ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
  ocfs2: switch dio read path from buffer_head to iomap
  ocfs2: switch dio write path from buffer_head to iomap

 fs/ocfs2/Kconfig          |   1 +
 fs/ocfs2/aops.c           | 580 +++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/aops.h           |  26 ++
 fs/ocfs2/buffer_head_io.c |  19 +-
 fs/ocfs2/file.c           | 108 ++++++-
 fs/ocfs2/ocfs2.h          |  49 +++-
 fs/ocfs2/ocfs2_fs.h       |   3 +
 7 files changed, 753 insertions(+), 33 deletions(-)

-- 
2.54.0

