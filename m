Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795400752;
	b=YmwuhfTHULN9P2WjBYoUjD1trbhHkCcwZfzs4nnbyRB+e9NSXpU+e7t7p60UTUoMdEgn
	 fmedkszsk2nkWIdiTftu1PJeN4engrnBPgXvRv/xG9bmAdBiB5oU5WXexhuv72dyX2/TH
	 sE562n9Jr4ipwzT+nhd/443em7qOL0yqB97yxNB/9nBXF/9G1Bpx8E87J/o3LpHLZOGbL
	 rYB/MbYzt9xeYM6KW4iN9Ofk5317EtaJ35mX3oITKj9hgFNFSmQVbNPnHz/oazOxAM8XE
	 U3nrnt71wmyzc4Q//bpWALvmP3WiAdfgex14iyprt6OK1kLtk3OfaYtMkRu/TGb7xQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795400752;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=0jf05AivAf9iRp9AP9BjA4tTMOtS7Al7ccSsRTpnHXE=;
	b=5RRFEO+wfZqfwFJpqv8RAMuQv5qJS825/pdhUFIEa473uc7UKAqxocMWHxdwF9SkTkcN
	 d99TbTvkwdP/k/WD58FFqWuQcuSAX+KkLWbO+pXGRAgWt+ZiK04ufgmTG3yC73WE1DvZa
	 airmMD3OiMNTLQGiAM3yDuN/nqpLmIGvkr1UvrSCZ/qDhidbkAXnyw6AFRBN3lTkY982p
	 gNkUwgCzfkOiLAbom6oNUWm2a/kYAMO3YN1nfrZDZm3o3B8unpbbTZWdr9SQYwLZ/fnjj
	 BkJMqXwMWMfFRpzZiYxRIpO+rB50PZQ63K2mFdfbrLqYwX6HLxNhCJQdj1dGK2yjpgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cwmAQPIy;
	arc=none smtp.remote-ip=115.124.30.113
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0944F606A31A
	for <ocfs2-devel@lists.linux.dev>; Mon, 23 Nov 2026 02:25:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0944F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cwmAQPIy
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795400743; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=0jf05AivAf9iRp9AP9BjA4tTMOtS7Al7ccSsRTpnHXE=;
	b=cwmAQPIyBw/yCkBBMVYczVCDnvo+wdd4uuYUqpekQZwpjTU451JV6swqq3pCvJTO/r1uMBGT1PIOMXwWgi4DLi9LeIWytYsrWDO16g1bbalrhS6HHYmvoRRrLQfHNn4nua8SjyRWh0QPXMgQ/2T6mkPDle3Ket/2cpLbjf4C5Qc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XFC-hGu_1795400741;
Received: from 30.222.33.45(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XFC-hGu_1795400741 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 10:25:41 +0800
Message-ID: <f178e3d2-5770-4f97-8b7f-f943fbd8cd8f@linux.alibaba.com>
Date: Mon, 23 Nov 2026 10:25:41 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v9 0/3] migrate ocfs2 DIO from buffer_head to iomap
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Heming Zhao <heming.zhao@suse.com>, hch@lst.de,
 Andrew Morton <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20261120060014.12087-1-heming.zhao@suse.com>
 <c57890bc-6085-461f-9f7c-47b72e104b65@linux.alibaba.com>
In-Reply-To: <c57890bc-6085-461f-9f7c-47b72e104b65@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/21/26 9:12 AM, Joseph Qi wrote:
> Thanks for this work.
> I'll apply this series on top of next-20261119 and run a full test first.
> 

I've run ocfs2test as well as xfstests 90-test DIO-focused set, and found
no regressions.

For ocfs2test,
  direct-aio (writeback, ordered)	PASSED
  aio-stress (writeback, ordered)	PASSED
  fill_verify_holes — 9 variants incl. -M mmap, -U unwritten, 512/4096 blocks, 4K–1M clusters	PASSED
  mmap_truncate — 6 variants	PASSED
  splice, sendfile, mmap	PASSED
  rename_write_race, create_and_open, filesizelimits	PASSED
  reserve_space, inline_data, xattr_test (1786 s), mkfs, tunefs, backup_super	PASSED
  80 passed, 2 harness-path failures, no kernel-related failure

For xfstests DIO-focused set,
  base   : PASS=52  FAIL=10  NOTRUN=28  EXPUNGED=6   (Failed 10 of 90)
  iomap  : PASS=52  FAIL=10  NOTRUN=28  EXPUNGED=6   (Failed 10 of 90)
  Failures (both): 091 094 219 263 326 328 521 587 617 733

Thanks,
Joseph

> 
> On 11/20/26 2:00 PM, Heming Zhao wrote:
>> This patch set migrates ocfs2 Direct I/O (DIO) from buffer_head mode
>> to iomap mode. It is based on commit aebb72744764 (v7.4-rc3), and
>> also incorporates Joseph's code and ideas from [1]:
>>
>> V9 changelog:
>>
>> Address sashiko's review comments [3] (all changes are in patch [3/3]):
>>
>> ocfs2_file_write_to_iter():
>> - switch pr lock to ex when DIO falls back to buffered IO
>> - Fall back to buffered I/O for a direct write when block size is smaller
>>   than the page size and the write does not cover whole pages
>> - clear orphan when rw_lock is still held
>>
>> ocfs2_dio_wr_map_blocks may use a value beyand u32 to call
>> ocfs2_clusters_to_blocks()
>>
>> initialize oi->ip_dio_orphan_pid and oi->ip_dio_orphan_end in
>> ocfs2_inode_init_once()
>>
>> --------------
>> # test report
>>
>> This patch set has been tested on 7.4-rc3 kernel
>>
>> ## ltp
>>
>> runltp -f dio -d /mnt/ocfs2/
>>
>> results: passed
>>
>> ## xfstests
>>
>> ./check -g quick -T -b -s ocfs2 -e generic/081 \
>> -e generic/266 -e generic/272 -e generic/281 \
>> -e generic/338 -e generic/347 -e generic/361 \
>> -e generic/628 -e generic/629 -e generic/648 -e generic/650 
>>
>> OCFS2_MKFS_LOCAL_OPT="-b 2K -C 4K --fs-features=local --fs-feature-level=max-features"
>> Failures: generic/003 generic/056 generic/091 generic/094 generic/177
>> generic/211 generic/225 generic/263 generic/321 generic/322 generic/329
>> generic/331 generic/370 generic/376 generic/424 generic/448 generic/467
>> generic/477 generic/481 generic/498 generic/510 generic/512 generic/513
>> generic/534 generic/537 generic/552 generic/557 generic/563 generic/578
>> generic/588 generic/607 generic/620 generic/630 generic/755 generic/760
>> generic/771 generic/777 generic/779 generic/784
>> Failed 39 of 632 tests
>>
>> OCFS2_MKFS_LOCAL_OPT="-b 4K -C 4K --fs-features=local --fs-feature-level=max-features"
>> Failures: generic/003 generic/056 generic/070 generic/091 generic/094
>> generic/177 generic/211 generic/225 generic/263 generic/321 generic/322
>> generic/329 generic/331 generic/370 generic/376 generic/424 generic/448
>> generic/467 generic/477 generic/481 generic/498 generic/510 generic/512
>> generic/513 generic/534 generic/537 generic/552 generic/557 generic/563
>> generic/578 generic/588 generic/607 generic/620 generic/630 generic/755
>> generic/760 generic/771 generic/777 generic/779 generic/784
>> Failed 40 of 632 tests
>>
>> OCFS2_MKFS_LOCAL_OPT="-b 2K -C 8K --fs-features=local --fs-feature-level=max-features"
>> Failures: generic/003 generic/056 generic/075 generic/091 generic/094
>> generic/112 generic/177 generic/211 generic/225 generic/263 generic/321
>> generic/322 generic/329 generic/331 generic/370 generic/376 generic/424
>> generic/448 generic/467 generic/477 generic/481 generic/498 generic/510
>> generic/512 generic/513 generic/534 generic/537 generic/552 generic/557
>> generic/563 generic/564 generic/578 generic/588 generic/607 generic/620
>> generic/630 generic/755 generic/759 generic/760 generic/771 generic/777
>> generic/779 generic/784 ocfs2/001
>> Failed 44 of 632 tests
>>
>> ## fio
>>
>> (4k blocksize 4k clustersize, local mount)
>>
>> fio --direct=1 --iodepth=32 --rw=write --ioengine=libaio --bs=128k --size=1g \
>> --numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
>> before patch: write: IOPS=32.2k, BW=4028MiB/s
>> after  patch: write: IOPS=38.6k, BW=4824MiB/s
>>
>> fio --direct=1 --iodepth=32 --rw=read --ioengine=libaio --bs=128k --size=1g \
>> --numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
>> before patch: read: IOPS=49.1k, BW=6132MiB/s
>> after  patch: read: IOPS=50.9k, BW=6360MiB/s
>>
>> fio --direct=1 --iodepth=32 --rw=randwrite --ioengine=libaio --bs=4k \
>> --size=1g --numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
>> before patch: write: IOPS=14.4k, BW=56.4MiB/s
>> after  patch: write: IOPS=14.4k, BW=56.1MiB/s
>>
>> fio --direct=1 --iodepth=32 --rw=randwrite --ioengine=libaio --bs=4k \
>> --size=1g --numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
>> before patch: read: IOPS=382k, BW=1492MiB/s
>> after  patch: read: IOPS=419k, BW=1637MiB/s
>>
>> ------
>> [1]:
>> https://gitee.com/anolis/storage-cloud-kernel/commit/ea3fe75e2060118ba093e90b1cd34fa382914b29
>>
>> [2]:
>> https://sashiko.dev/#/patchset/20261103135605.22943-1-heming.zhao%40suse.com
>>
>> [3]:
>> v1 patch set:
>> https://lore.kernel.org/ocfs2-devel/20260724052559.15409-1-heming.zhao@suse.com/
>> v2 patch set:
>> https://lore.kernel.org/ocfs2-devel/20260727061802.18485-1-heming.zhao@suse.com/
>> v3 patch set:
>> https://lore.kernel.org/ocfs2-devel/20261018143319.22329-1-heming.zhao@suse.com/
>> v3 sashiko review:
>> https://sashiko.dev/#/patchset/20261018143319.22329-1-heming.zhao%40suse.com
>> v4 patch set:
>> https://lore.kernel.org/ocfs2-devel/20261103135605.22943-1-heming.zhao@suse.com/
>> v4 sashiko review:
>> https://sashiko.dev/#/patchset/20261103135605.22943-1-heming.zhao%40suse.com
>> v5 patch set:
>> https://lore.kernel.org/ocfs2-devel/20261105071930.16399-1-heming.zhao@suse.com/
>> v5 sashiko review:
>> https://sashiko.dev/#/patchset/20261105071930.16399-1-heming.zhao%40suse.com
>> v6 patch set:
>> https://lore.kernel.org/ocfs2-devel/20261115154013.9379-1-heming.zhao@suse.com/
>> v6 sashiko review:
>> https://sashiko.dev/#/patchset/20261115154013.9379-1-heming.zhao%40suse.com
>> v7 patch set:
>> https://lore.kernel.org/ocfs2-devel/20261118002050.9019-1-heming.zhao@suse.com/
>> v7 sashiko review:
>> - https://sashiko.dev/#/patchset/20261117150053.18417-1-heming.zhao%40suse.com
>> - https://sashiko.dev/#/patchset/20261118002050.9019-1-heming.zhao%40suse.com
>> v8 patch set:
>> https://lore.kernel.org/ocfs2-devel/20261119064029.11910-1-heming.zhao@suse.com/
>> v8 sashiko review:
>> https://sashiko.dev/#/patchset/20261119064029.11910-1-heming.zhao%40suse.com
>>
>> -----------------------
>>
>> Heming Zhao (3):
>>   ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
>>   ocfs2: switch DIO read path from buffer_head to iomap
>>   ocfs2: switch dio write path from buffer_head to iomap
>>
>>  fs/ocfs2/Kconfig      |    2 +-
>>  fs/ocfs2/aops.c       | 1685 ++++++++++++++++++++++++++++++++---------
>>  fs/ocfs2/aops.h       |   43 +-
>>  fs/ocfs2/extent_map.c |   34 +-
>>  fs/ocfs2/extent_map.h |    3 +
>>  fs/ocfs2/file.c       |  314 +++++++-
>>  fs/ocfs2/inode.h      |    9 +
>>  fs/ocfs2/mmap.c       |    2 +-
>>  fs/ocfs2/ocfs2.h      |   25 +-
>>  fs/ocfs2/super.c      |    3 +
>>  10 files changed, 1690 insertions(+), 430 deletions(-)
>>
> 

