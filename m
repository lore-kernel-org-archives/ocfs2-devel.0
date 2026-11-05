Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793863182;
	b=V2rXMWp/xh2kbEWwMmvagcjTAShsYfyOk8PD8aRJorZZT1nc5eGqki4Px1nAlPq9TilV
	 nQMbKDHvNoM55VQS4sKyy6galD35DIq/u/Wb38OfGJEi1JVIodkVrFzla2xyOlMF+0Lcu
	 h2G8DapiKj8/BCQCB1Cp8c+aw+sHr6rpigQyij+LuvcJXcEiAD28L4tIRC4bUDJP2eZAl
	 NP6o/Vq8A4Wf20ekAdSiw/EVxaj2pMNoVgs8KiCQLEiy3lE6ZHq9mNSjV/Hd/xNN60CaR
	 GwLdOz7tqKXFbzJ9O8iBqxEW/r92ccNgISrNf1//LNTN1Kmvr4xdJSAetrZQpx0MM4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793863182;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jtvDZEshy0cFy/xn5t5FZPavM2QZtUZi4LpThlcs6fg=;
	b=YxL8a6d3uAcNDGOVX2fLI2aWKwdG85jwyjH9y44HhZJvR4XjV2qYrzAGt6BLi6x9FZO+
	 819n2EfSnI1olcsgTxkCZAvoG8nF3S3aLwl4q0YNvi3AxjvBG0Qb158JhV2O9XgB7Jot5
	 S1WB0F6uuayqZGGEqfK2WdAKVLqGI4FMl07lqiZdry4nLvBzzAfWUNkCOlPZ1eGTxldHB
	 papx1FA7vKr/Wc7YiIsQSQ7AN//7kz29HGJLYofaM3jzsKsC9UAv/hN/5Y8YWQv2qLHmf
	 nkylg67WkL0wcyiiejS0VtBNU5tmNv7rc4geiYCyVL0QXTfz0tFmWcdJfZo01+S77fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=YCpWYvlm;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1AF606A328
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 07:19:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E1AF606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=YCpWYvlm
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4af52002471so3224945e9.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 04 Nov 2026 23:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793863180; x=1794467980; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jtvDZEshy0cFy/xn5t5FZPavM2QZtUZi4LpThlcs6fg=;
        b=YCpWYvlmIA74ESqXIrwUK7qATVrFHumv7EYbwHQGmpjNVH5RBltZH+vm6a6DSS8RE0
         ho7TOdqJiE4sugFjSFMx0Fw5Ou18SsAMmTfJe3d6FEJAQy1YdccnZzneQm09KVFoAanj
         R8Mc6xRM115vGh1P+FSJVvFm7FoDUJkceh0C7Qihfk/bVrQUz/NRBFhrVY0LjQWWLPQ7
         B1x3DRlFhFqE+LN78Tmk0BQkJwYfYs7s5kdv/kvoNX9LED4ms7CVHxRxDVlnOAHwjkDJ
         8RZl/lfUTjx4wxlvjEcBIu6RQspm/EU09XV39EsNDy6absLlJwH6Klnz8W6jI0Y1aqSv
         TuiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793863180; x=1794467980;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jtvDZEshy0cFy/xn5t5FZPavM2QZtUZi4LpThlcs6fg=;
        b=hj0kSGrAA4Tsf2fWGZHC/qwT96p91Ob1q2zHuon8aM83J6pqo6fb1y6UI9ryXosAZa
         wLevVCqC+S2w9ZkSP+2qQvZqzEiUHRrnE7dOcSIUt7ghU3IU8+icDZai8vUkZcl5UAl3
         ZKp6j35DcYjJKvUc54cawEArD1AJ92OApFHnAyTBpoLQ8zuKOrdCkihC46Juk7TUsYQi
         5gBj+jGA333fnkAbj5SCcwD8EdlEJEKodoiNq61hxUOIGmIniY9i7kz+9h9GQkIODipv
         pWEcvEHg/jWHAXQfeVVRMOMMXmLdaIzeo2zct9Fqz6cjHssrH2pzlbRa508y6gih13GQ
         g1LQ==
X-Forwarded-Encrypted: i=1; AKwUvBw2MpNMV7XlfEvIpN6jH4BP0VrATRZpwhhZoYQ1wUQNB8oQ4bYeBWdXFDTRCJb6X36SU72jTnqVTd6/AA==@lists.linux.dev
X-Gm-Message-State: APuU4Z8B0LE3FYHmjGRFfoPs12PuKpbiQhKR7xK8KkgYNhRA49dTf8iO
	X1fZRK9bjmWcZvpxSL3/bg9tpZIRQFdo3Rh7C16jxz5zpCnksIyC+cmySm0ptaOeT4k=
X-Gm-Gg: AYBFou1aefQvjoC3C9jSFgr8oPWRM5avHjxl8v6HByIamwd1IY0wHY/LuFGvtbUkJNQ
	8E2Uoc1CywXbvBTu+FFk+C/bEZ75gm0goPuF20wo/H0gbXa/ONc2v6wOe+E0A3p/vZOL05uhcV8
	hyCInnl97WdYF3Z5ESWIHp6gXoFmC827hNr/65OZ2LWG3v1JLOsslPorImimyfu1CHexOZ4lqCY
	w5bR7uUhXgKeuZ0jxHdUb0AES312aDJPruCbMQYpovMV9RVBlabq9iWhay/OqgErqljLBSOP8k/
	VVk4O1N2b03SdHtQ+RYyis3t+KSv9kb4dBjKShIqw5ZdnoEybXOZmrlT3HDxMaMWyOofKvZF2iR
	/TJgkctz+9Dm/JMVJ7fuLn6KPRe85lzQpDmc4N+Uv5XSjgq6DT6OiopEUW0AdTmb5SPTrOspiIv
	EGZd6pVMcs96OuiXuMcqPRuaXM7ido3QR5qQxujg5YUawzw4XUsQiAx59NDQ4pJuV7dbYGZ1Ns5
	v/B0+uDUCJJzmX+U2uh9HOgKOPv7SVKe+DokUkhOVcUI/u3rDLjn+jtECPw/VP6jGjEG1h29oMo
	R1N5bnmjpf2ORCgBlePQXFUbM2pxWpxU8Ee6MF7txPpzrakjO7SaUVj3FSczuh3U
X-Received: by 2002:a05:600c:1798:b0:4a0:1f9e:5f78 with SMTP id 5b1f17b1804b1-4ac1228a41emr254417105e9.0.1793863179681;
        Wed, 04 Nov 2026 23:19:39 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245b86fbesm14687084c88.1.2026.11.04.23.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 23:19:38 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v5 0/4] migrates ocfs2 DIO from buffer_head to iomap
Date: Thu,  5 Nov 2026 15:19:24 +0800
Message-ID: <20261105071930.16399-1-heming.zhao@suse.com>
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

The key for the patch set

To simplify iomap development, we currently adopt the simplest approach:
retaining the buffer_head style, where only one cluster is allocated
per iomap_begin() call.

Introduce OCFS2_MAX_LOGICAL_BLOCK to cap the logical offset in the iomap
code path.

Put zeroing and orphan inode handling in ocfs2_file_write_iter(), the
buffer_head style is handled in ocfs2_dio_wr_get_block() with dwc
helper.

I attempted to implement .submit_io/.end_io in "struct iomap_dio_ops" to
free dwc inside end_io. However, because ->bi_end_io runs in an interrupt
context and ocfs2_iomap_dio_end_io_write() contains sleepable functions,
this approach required scheduling a workqueue directly from the
->bi_end_io callback and calling ocfs2_iomap_dio_end_io_write() within
the workqueue thread context. Furthermore, since iomap_dio_ops.end_io
still cannot access any private data, it cannot accurately wait for the
work to finish. Testing with xfstests triggered hangs and crashes.

In iomap end_io, there is no dwc. ocfs2_iomap_dio_end_io_write() calls
ocfs2_lock_allocators() with a roughly calculated extents_to_split value.

v5 changelog:

Fix several issues found during the sashiko review[2].

Remove "map->flags = 0" in ocfs2_map_blocks().

Remove some useless/unnecessary OCFS2_IOMAP_* definitions.

When iomap falls back to buffered reads, add a check to ensure ki_pos is
strictly less than i_size.

In ocfs2_iomap_begin():
- Remove redundant code for the case where blocks are already allocated.
- Remove the IOMAP_ATOMIC code, which is not currently supported.

In ocfs2_file_write_iter():
- call kiocb_modified() after ocfs2_prepare_inode_for_write().
- use direct_write_fallback() to handle fallback to the buffered write case. 


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


--------------
# test report

This patch set has been tested on 7.3.0-rc7 kernel with the following test
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

```v7.4-rc1
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
```

Please note v7.3 kernel only has 35 cases failed, and v7.4-rc1 has 44
cases failed, so the failures are not caused by this patch set.

OCFS2_MKFS_LOCAL_OPT="-b 2K -C 8K --fs-features=local --fs-feature-level=max-features"
Failures: generic/003 generic/075 generic/091 generic/094 generic/112
generic/177 generic/211 generic/225 generic/263 generic/322 generic/329
generic/331 generic/370 generic/376 generic/424 generic/448 generic/467
generic/477 generic/481 generic/510 generic/513 generic/537 generic/552
generic/563 generic/564 generic/578 generic/607 generic/620 generic/630
generic/755 generic/759 generic/760 generic/777 generic/784 ocfs2/001
Failed 35 of 632 tests


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
  - creating write      : IOPS=26.9k, BW=105MiB/s (110MB/s)(4096MiB/38985msec)
  - overwriting write.1g: IOPS=231k, BW=902MiB/s (946MB/s)(4096MiB/4539msec)
- applied patch
  - creating write      : IOPS=26.9k, BW=105MiB/s (110MB/s)(4096MiB/38987msec)
  - overwriting write.1g: IOPS=228k, BW=891MiB/s (935MB/s)(4096MiB/4595msec)

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

 fs/ocfs2/Kconfig    |   2 +-
 fs/ocfs2/aops.c     | 539 ++++++++++++++++++++++++++++----------------
 fs/ocfs2/aops.h     |  38 +---
 fs/ocfs2/file.c     | 213 ++++++++++++++---
 fs/ocfs2/ocfs2.h    |  25 +-
 fs/ocfs2/ocfs2_fs.h |   3 +
 6 files changed, 565 insertions(+), 255 deletions(-)

-- 
2.55.0

