Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714371;
	b=qSPTaVE71PWqG9xdeub6Pin0b4mc/zizbWNfImq8YAHKo5eEzFahX1jSlGxaoeNd99u5
	 zlWj9PoDE8zXLYVGSEte7CT4xVGCKkHm2EOIOczJpohRjftPcnEd/sb9DcAJAHX35hnBQ
	 qnwFfGkaa5iijRiFTKa2u4aJILuJEduEnQo2Otq7ACS8ewgjFL0grnN46FLjeDvXMZrgM
	 nvX5XeOFX/k4ydP0pkGQHaDrx1nDpyaSYNPSTOKsqaCvwsrt+OkvO8b7hEsr79N5oHV0W
	 1CgwPlKcq1WgLOXTXF1ALfl1NDliXvSFGRhJLBKPVWwvwje1Hy9hcUW/TXcE3llykMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714371;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=74I3nnSN0fQYCG/L/O68krWPpqCBywczA6Ty/j7yNc4=;
	b=jwHSwR+JmNZrO2FHvcnTXCFMWShAdq6Y69HClmXuimYDsdI52nO7OOhRjuEk4M2vwnws
	 x6GT+a83BYAntsCQU/dPqLKeQY1z9lAmG8ZPC9auuANswzyzKxfvdmoA3a7l55uzWrAvN
	 cVuW4Gbv5eEsmRV5pEapR4MeuFDHSS3taN8XtdwPPSuvy+Og9WqIb1CUO1iRTCyJD+UvL
	 wpr2KRd580iOXcMzTxlCQ2uBsO7INwd0ichX1j7RvoTe6GwOsiD8bmm1JL0P4n3bUW3+G
	 a+aD3IG/hHaEJSGkscxtwoZFk8gyhMGLC0nubmJ8QL4kcnwGOfURcSFKQyIiHpFIURA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=UtZuKbJh;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4E7606D820
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Nov 2026 13:59:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E4E7606D820
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=UtZuKbJh
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a610c7e61cso6654325e9.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Nov 2026 05:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793714369; x=1794319169; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=74I3nnSN0fQYCG/L/O68krWPpqCBywczA6Ty/j7yNc4=;
        b=UtZuKbJhDvm3fr9DBbJyvDx1XWGJ0WdQVUec0PoUDyPqq4t3x2hCIZJyT9w2mR6Lmi
         m1R/5qQIilaPyp4ubHLBOfoYJ7+XAQq4MNEzEh5aD4+a73VIyg/BEVDDPR3aRjoGdtNP
         +Ng0PmbdQN4ILPpOoP3+egHiToJrqIrN18enWF6yuIEb0DMSJ/C/bC+eF7bvgnBTZ0nH
         0SxBse5dR/9D8+9FHtr2/1S3rkDbxoAhraRSpN7Bj5zrS8KJifkuuCBpTCQlyCAJst29
         AoqJ6inZpdG88pbgQAjidWcrwg7bizuJKoiQovhmS8Pz69UCoLYu276ErSeJlYIFM35x
         RhTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714369; x=1794319169;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=74I3nnSN0fQYCG/L/O68krWPpqCBywczA6Ty/j7yNc4=;
        b=0HFGQrmPyJ/IRyCJhQr/VNQdz2scSB6Drj0hyqS3MEeVxZ6czIW8JrHPmoqNa4J5Ww
         Zymttvnnh8kkXFok9Yc28BrV7CBHD4xFgtcVCaOTwVmoin1SKXBO/zGAHuTKGmUqgBPc
         nAFry9pU4Ml2Z1GOpR1FTP8q6synKpHhjm1g1dAtEWB0tStOhrdyxCMtROXZDrDPNY4g
         3IMPbMkN42rPMCpSWrrzAosLU1Pdhf+bPmpigme3G0miskWlTzoS87ZqIpNIi6pgV3RK
         xbZQC/iUIg0bYHrDw2l7KiWc7E3YFp3wS7TAef76IhvqZYZxXXzOh2K0zbIaiCXd5vEz
         3hqg==
X-Gm-Message-State: APuU4Z/8mPLjoLKokqF24hiIz+oiQLaqsQQ5ZZhwyytTx6K0LKmuPa5f
	E/Y68lR7A9IpPQDVGKcy7S7pvv9XzKpJ1FHfDs82U5D6vt9cAw2dsoLaoIdR4B9iUlk=
X-Gm-Gg: AYBFou2dXs55a+fKSVMT/x9ur9BrRzrBtW9vBstGH6fRzRf5k+OJdo6v6Bh9GuQcEdV
	yOAXuARzkXIV4Z5RVRGTl2qPh/BE1EuxQAoPdLJ5I7DIdYVIpbrx3Gq1n8Jt3g8TvMTTaiJTn0W
	tS1qtDFkGHt4RsY1lYUkRnM6YskR5ScVpuSu7XC2oG1W7truVRjOW8lfpFCYeHWmO7EJRxgOlZU
	1HyncqQhBAmVG6gsJoKP4sGTrjH4xxr+tVdEYzq1DovLXxnFmtKOEUeLfJLnbww0AaV42a5nLWq
	xe2oium4BXjQJtM98O/q88UGG2wJO69eiN7NSdUygBIbddE3WOge+0qJjILAgV5o/TXUbfLcIH6
	vTnEjmQF+b+0nVkIZZJYfabj+Etv7hDPXcW53bpxWXdHbAHxTkSPpGqv2tLnaY2XGDSxd/XZzY9
	QpxYP6zOBXV9V2hGJ6DBi72eHpylSOp/Q3t3R5IVQbZ1x+6CvmcSQdFi+y6c74Kg/gCrTbdTb06
	wrAiKYMUGgUmFWJjFB9tIqbt6CiZxYEDFB9djSOBXb8ocTxGXRFLPbrIYCSax1vq7wvP4aR5pXt
	sli/OzcIfYDLGyDMUkpWaYy/tqm6UBaZoQ==
X-Received: by 2002:a7b:ce0d:0:b0:4a1:715d:1913 with SMTP id 5b1f17b1804b1-4ac177538c5mr231277385e9.1.1793714368907;
        Tue, 03 Nov 2026 05:59:28 -0800 (PST)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b23b847348sm9348208c88.4.2026.11.03.05.59.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 05:59:27 -0800 (PST)
Message-ID: <2702c09a-3679-4d69-8072-e678f3764945@suse.com>
Date: Tue, 3 Nov 2026 21:59:21 +0800
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
Subject: Re: [RFC PATCH v4 0/4] migrates ocfs2 DIO from buffer_head to iomap
To: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org,
 hch@lst.de
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261103124310.21143-1-heming.zhao@suse.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20261103124310.21143-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi List,

Please ignore this patch set, as it failed to apply on sashiko.

Thanks,
- Heming
On 11/3/26 20:43, Heming Zhao wrote:
> This patch set migrates ocfs2 Direct I/O (DIO) from buffer_head mode
> to iomap mode. And the code base is commit 4056b3c9d3c92ea, and also
> merge Joseph's code and ideas from [1]:
> 
> v4 changelog:
> 
> Fix several issues found during a sashiko review[2].
> 
> To simplify iomap development, we currently adopt the simplest approach:
> retaining the buffer_head style, where only one cluster is allocated
> per iomap_begin() call.
> 
> When creating a filesystem using "mkfs -b 2K -C 8K" (where the cluster
> size is greater than the page size), several xfstests cases crashed.
> The root cause was an incorrect return value from iomap end_io.
> 
> Both the add and del of the orphan inode during write I/O are now placed
> in ocfs2_file_write_iter().
> 
> Additionally, I attempted to implement .submit_io/.end_io in "struct
> iomap_dio_ops" to free dwc inside end_io. However, because ->bi_end_io
> runs in an interrupt context and ocfs2_iomap_dio_end_io_write() contains
> sleepable functions, this approach required scheduling a workqueue directly
> from the ->bi_end_io callback and calling ocfs2_iomap_dio_end_io_write()
> within the workqueue thread context. Furthermore, since iomap_dio_ops.end_io
> still cannot access any private data, it cannot accurately wait for the
> work to finish. Testing with xfstests triggered hangs and crashes.
> 
> 
> [1]:
> https://gitee.com/anolis/storage-cloud-kernel/commit/ea3fe75e2060118ba093e90b1cd34fa382914b29
> 
> [2]:
> https://sashiko.dev/#/patchset/20261018143319.22329-1-heming.zhao%40suse.com
> 
> v1 patch set:
> https://lore.kernel.org/ocfs2-devel/20260724052559.15409-1-heming.zhao@suse.com/
> v2 patch set:
> https://lore.kernel.org/ocfs2-devel/20260727061802.18485-1-heming.zhao@suse.com/
> v3 patch set:
> https://lore.kernel.org/ocfs2-devel/20261018143319.22329-1-heming.zhao@suse.com/
> 
> --------------
> # test report
> 
> This patch set has been tested on 7.3.0-rc7 kernel with the following test
> cases.
> 
> ## ltp
> 
> runltp -f dio -d /mnt/ocfs2/
> 
> 1 fail: diotest4    9  TCONF  :  diotest4.c:346: Direct I/O on /dev/null is not supported
> 
> This fail can be ignored.
> 
> The test results: passed
> 
> ## xfstests
> 
> ./check -g quick -T -b -s ocfs2 -e generic/081 \
> -e generic/266 -e generic/272 -e generic/281 \
> -e generic/338 -e generic/347 -e generic/361 \
> -e generic/628 -e generic/629 -e generic/648 -e generic/650
> 
> The test results are the same before and after the patch set.
> 
> ```
> OCFS2_MKFS_LOCAL_OPT="-b 2K -C 4K --fs-features=local --fs-feature-level=max-features"
> Failures: generic/003 generic/091 generic/094 generic/177 generic/211
> generic/225 generic/263 generic/322 generic/329 generic/331 generic/370
> generic/376 generic/424 generic/448 generic/467 generic/477 generic/481
> generic/510 generic/513 generic/537 generic/552 generic/563 generic/578
> generic/607 generic/620 generic/630 generic/755 generic/760 generic/777
> generic/784
> Failed 30 of 632 tests
> 
> OCFS2_MKFS_LOCAL_OPT="-b 4K -C 4K --fs-features=local --fs-feature-level=max-features"
> Failures: generic/003 generic/177 generic/211 generic/322 generic/329 generic/331 generic/370 generic/376 generic/420 generic/424 generic/448 generic/467 generic/477 generic/481 generic/510 generic/513 generic/537 generic/552 generic/563 generic/578 generic/607 generic/620 generic/630 generic/755 generic/777 generic/784
> Failed 26 of 632 tests
> 
> OCFS2_MKFS_LOCAL_OPT="-b 2K -C 8K --fs-features=local --fs-feature-level=max-features"
> Failures: generic/003 generic/075 generic/091 generic/094 generic/112 generic/177 generic/211 generic/225 generic/263 generic/322 generic/329 generic/331 generic/370 generic/376 generic/424 generic/448 generic/467 generic/477 generic/481 generic/510 generic/513 generic/537 generic/552 generic/563 generic/564 generic/578 generic/607 generic/620 generic/630 generic/755 generic/759 generic/760 generic/777 generic/784 ocfs2/001
> Failed 35 of 632 tests
> 
> OCFS2_MKFS_CLUSTER_OPT="-b 2K -C 4K -N 2 --fs-feature-level=max-features --cluster-stack pcmk --cluster-name hacluster"
> Failures: generic/001 generic/003 generic/091 generic/094 generic/211 generic/225 generic/263 generic/322 generic/329 generic/331 generic/370 generic/376 generic/424 generic/448 generic/467 generic/477 generic/510 generic/513 generic/537 generic/552 generic/563 generic/578 generic/607 generic/620 generic/630 generic/755 generic/760 generic/777 generic/784
> Failed 29 of 632 tests
> 
> OCFS2_MKFS_CLUSTER_OPT="-b 4K -C 4K -N 2 --fs-feature-level=max-features --cluster-stack pcmk --cluster-name hacluster"
> Failures: generic/003 generic/211 generic/322 generic/329 generic/331 generic/370 generic/376 generic/420 generic/424 generic/448 generic/467 generic/477 generic/510 generic/513 generic/537 generic/552 generic/563 generic/578 generic/607 generic/620 generic/630 generic/755 generic/777 generic/784
> Failed 24 of 632 tests
> 
> OCFS2_MKFS_CLUSTER_OPT="-b 2K -C 8K -N 2 --fs-feature-level=max-features --cluster-stack pcmk --cluster-name hacluster"
> Failures: generic/003 generic/075 generic/091 generic/094 generic/112 generic/211 generic/225 generic/263 generic/322 generic/329 generic/331 generic/370 generic/376 generic/424 generic/448 generic/467 generic/477 generic/510 generic/513 generic/537 generic/547 generic/552 generic/563 generic/564 generic/578 generic/607 generic/620 generic/630 generic/755 generic/759 generic/760 generic/777 generic/784
> Failed 33 of 632 tests
> ```
> 
> ## fio on single node
> 
> fio --direct=1 --iodepth=32 --rw=write --ioengine=libaio --bs=128k --size=1g \
> --numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
> - before patch write: IOPS=31.5k, BW=3935MiB/s (4126MB/s)(4096MiB/1041msec)
> - before path overwrite (don't remove write.1g, run above fio command):
>        write: IOPS=39.5k, BW=4935MiB/s (5175MB/s)(4096MiB/830msec)
> - applied patch write: IOPS=37.4k, BW=4676MiB/s (4903MB/s)(4096MiB/876msec)
> - applied patch overwrite (don't remove write.1g, run above fio command):
>        write: IOPS=39.4k, BW=4929MiB/s (5168MB/s)(4096MiB/831msec)
> 
> fio --direct=1 --iodepth=32 --rw=read --ioengine=libaio --bs=128k --size=1g \
> --numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
> - before patch : IOPS=47.7k, BW=5962MiB/s (6252MB/s)(4096MiB/687msec)
> - applied patch: IOPS=48.2k, BW=6024MiB/s (6316MB/s)(4096MiB/680msec)
> 
> fio --direct=1 --iodepth=32 --rw=randwrite --ioengine=libaio --bs=4k --size=1g \
> --numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
> - before patch
>    - creating write      : IOPS=3282, BW=12.8MiB/s (13.4MB/s)(1283MiB/100026msec)
>    - overwriting write.1g: IOPS=41.8k, BW=163MiB/s (171MB/s)(4096MiB/25115msec)
> - applied patch
>    - creating write      : IOPS=3230, BW=12.6MiB/s (13.2MB/s)(1262MiB/100031msec)
>    - overwriting write.1g: IOPS=40.5k, BW=158MiB/s (166MB/s)(4096MiB/25908msec)
> 
> fio --direct=1 --iodepth=32 --rw=randread --ioengine=libaio --bs=4k --size=1g \
> --numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
> - before patch  read: IOPS=361k, BW=1409MiB/s (1477MB/s)(4096MiB/2907msec)
> - applied patch read: IOPS=362k, BW=1416MiB/s (1485MB/s)(4096MiB/2893msec)
> 
> ---------------------
> 
> Heming Zhao (4):
>    ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
>    ocfs2: switch DIO read path from buffer_head to iomap
>    ocfs2: switch dio write path from buffer_head to iomap
>    ocfs2: remove legacy blockdev direct-IO path APIs
> 
>   fs/ocfs2/Kconfig          |   2 +-
>   fs/ocfs2/aops.c           | 568 +++++++++++++++++++++++++-------------
>   fs/ocfs2/aops.h           |  38 +--
>   fs/ocfs2/buffer_head_io.c |  12 -
>   fs/ocfs2/file.c           | 214 +++++++++++---
>   fs/ocfs2/ocfs2.h          |  46 ++-
>   fs/ocfs2/ocfs2_fs.h       |   3 +
>   7 files changed, 616 insertions(+), 267 deletions(-)
> 

