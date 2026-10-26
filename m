Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792992329;
	b=KWbHQ9mrtUdURlZp/YzIV/GiY6/wzxMLHNOMpBQQEamtHvftjxJ31ZG0BTSxxInK7x/k
	 jr8/iJXsVRK/znxv4KkikMaGSvrkirj1HLhwd2Dv6lOtdGSNG+eVWmzv2HcT+LbSpCCam
	 c15UDWnpQVj/1eVHF6ET5vJQRwmNMHTgczNFzFEsq8zQi428aQOUgoSv7qfRM2h1T5PXc
	 eFk49voWB90+tMY8a2Ybo5J/ef7oErdOBQ1ijqffsYMU8lwtlWCXz9JSsRvl5O4iyUIxC
	 yXi+lHkO4BDHmUet6OLVKgDSq3pfdnSTVJafzlYPtYoCjNBQlQ6mSfZ1RY88Gah7hkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792992329;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=bKIzzGBwaCJ4jtOixxQxSSbSQWvSLniGHV6RCXhihVs=;
	b=FnqdSMI0Sj9DT0DR+DvKfROMw36gYfEtCbQgzCfYAb3LejQgXj7W+Lz3wMNsmFjvhhXv
	 EFCr9hdBJwruK3+ZniEVXnKWOsLbCS86ljBjQEs0ypZoj4LVruaz87m5RFaEmjKF0L4xr
	 6trEqjX9OGKeeUWmO9nKToB/M38DcwT867nzwShGkjPmny4kPPxGDbC1GDLDynjqD0G1X
	 xp65E4FX4KwE1W/tyYI9dLcf/xKby+f5yijPrxSAl2s2vHQYnY3L3c0mpnoZp0HUbWtoc
	 M7zVkPVdTkzYJxvGiLTVSrlLB/qZb7Kd2lq5+vORhusXhIBx1TLvZsd5XnWnfIqtvMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=gySqvs9D;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942B9606A31A
	for <ocfs2-devel@lists.linux.dev>; Mon, 26 Oct 2026 05:25:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 942B9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=gySqvs9D
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a005aa0838so3114205e9.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 25 Oct 2026 22:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792992327; x=1793597127; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bKIzzGBwaCJ4jtOixxQxSSbSQWvSLniGHV6RCXhihVs=;
        b=gySqvs9DAb55knJXMCBRnR34bKT7ZjvmyAENwAghWyBoIWSwLrDY7+Txhec1Vw6mXE
         STUimLTjGkK+PG6FkpotIMMmnVEv+ZUxzPRm98QcFYsJfEO5PFlzOMZJ2tQUSyK9vZHj
         QF9QSO9HhlF1+IWT33Vda6E1j7uM2zsUveSw19XdcN+gHAVvDB4MGJL/wazaXmpwlyDh
         hqWdSKCSqbtMZaCANeqCxExcGwC7XRx94VcD/QJtaklBOAbh1xt2RAtu0fwwTjUKYuBC
         u5rm564OzHVBzZIuSqzxREJgUC8Z9JCzklyqVVkL0LEpVMRhhEf1jncD2OlOiUC1+iIH
         YEGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792992327; x=1793597127;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bKIzzGBwaCJ4jtOixxQxSSbSQWvSLniGHV6RCXhihVs=;
        b=okIZ4EXtV6PoiKNVthd0k5cVDFn6oLVcUaRS9fadMqu7eRhQKAT76cYyXqlE+/kq5o
         xrg9Z8n3uK3aEORcSm2qdtT9CcssWKwFjbrZcCfWoXqp2m9jkpWoBbBmLLrEY+75anwu
         tEpchxowdtsUUSuBTvPnsDOi2YCwve7lMzaIR6iTUfMjgrXmjQFHF2oPXfjyiGoKXfkw
         OFh+vNYceRzvBSCjnScmKNRsrmOudCPTy0XxtLHunXvExeapgVLXb4w8gCMD78o2f+Js
         03iDpQB4DpRYJnFP2SgdP+B8oEg+at8KDF6rsNav88CVAKhKjVRboMxcDJRO1bDhA4kX
         09eA==
X-Gm-Message-State: AFq9FYItVIyvhPFYLZLzN/2D6F7bwtq5ZcXLFxijEe7DkxEzdKa40Snr
	8jgRwBO9B51vy5eS6T05cb/1RsE1+35rXujkzcJGUv/mMmTOksLwbKCYirAQwgZvZKo=
X-Gm-Gg: AYBFou1+Ogz69QVCwh90rMp3E2Tnpg62UIadwxVWhiW7pHqp5S6KxbYIaVeS/Wo/+Ya
	cl0LE9S0gfuk9kE1HpFcWhY0mZlJmrzOUhAPazaWwUVR7i5XS/zyE5P+8XZJ6kGil6ycLxK2hhn
	qLUa+DeMKE14w394ybOzDbSrhtny+CMC/p14N0uBah4YeFTD/z5WwyCxG+jA60/shIrMeiwKbz9
	YioPi2bWadSZ6tO/82nVRdEJSjBsQVhku5FPcUoxaz8snn5/c69x/rdZGmy7pdXiL0eM6KBBzXt
	anggtATSDERSU2gQz0o24ZYYFBARf6Fk3ijquw2ZQo2iaf9aqaKC6g941GqDd+YbRXoVxCZnt1u
	TtFyMCDyhMJf6xNnNcPBRRCfhqOyT5n+JEx3Pwjxggk1q5pEzCVnD/rAAup3u6SRGFpRGdHcuCT
	0Cs2ueqJiyjTC4zUSGOXTvuBz2QF24bxO8kN1Hqc8QkSTA41hqRfaMlX7WODShSn1MSQ2FlmjUQ
	7TyYWvPaI05ntbUJiAvQQV9GIa8nzHEoJjDW05Et9sMCqaUfoJOAya/qGbFWQ==
X-Received: by 2002:a05:6000:2905:b0:48d:f14a:9186 with SMTP id ffacd0b85a97d-48e3eb97829mr12422096f8f.6.1792992326871;
        Sun, 25 Oct 2026 22:25:26 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adeba32f70sm6668139a91.1.2026.10.25.22.25.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2026 22:25:25 -0700 (PDT)
Message-ID: <dd546510-34c9-4b08-8b34-defcbe7a1c22@suse.com>
Date: Mon, 26 Oct 2026 13:25:21 +0800
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
Subject: Re: [RFC PATCH v3 0/4] migrates ocfs2 DIO from buffer_head to iomap
To: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org,
 hch@lst.de
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261018143319.22329-1-heming.zhao@suse.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20261018143319.22329-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello list,

When using the format command "mkfs.ocfs2 -b 2K -C 8K --fs-features=local \
--fs-feature-level=max-features /dev/<disk>" to run xfstests,
I encountered some new hang issues. These issues are from the iomap
write path. I will withdraw the v3 patch, and after fixing all the
issues, I will send v4.

Thanks,
Heming

On 10/18/26 22:33, Heming Zhao wrote:
> This patch set migrates ocfs2 Direct I/O (DIO) from buffer_head mode
> to iomap mode. And the code base is commit 58717b2a1365d.
> 
> Changelog:
> v3:
> patch 1/4
>   revise the commit log
>   for ocfs2_map_blocks():
>   - removed S_ISLNK() handling, as S_ISLNK inodes are already handled by the existing code path:
>     ocfs2_read_folio => block_read_full_folio() => get_block (ocfs2_get_block)
>   - replace "return -EIO" with "return err" at the end of this func
> 
> patch 2/4
>   revise the commit log based on hch's comments.
>   in ocfs2_iomap_begin(), replace the "/* todo */" comment under the IOMAP_WRITE case with "return -EOPNOTSUPP".
>   revise comments in ocfs2_iomap_dio_end_io()
>   remove the unused "bail" label in ocfs2_dio_end_io_r_pr()
> 
> patch 3/4
>   revise the commit log based on hch's comments.
>   remove the unused var max_blocks in ocfs2_iomap_dio_end_io_write().
>   followed Joseph's comment, directly set map.lblk in ocfs2_iomap_dio_end_io_write().
>   in ocfs2_dio_wr_map_blocks():
>   - replace BUG_ON(p_blkno == 0) with "ret = -EIO, mlog_errno() and goto unlock".
>     (the legacy code was copied from ocfs2_dio_wr_get_block())
>   - adjust arithmetic for map->len by substracting the offset and using min_t() to cap the length within limits.
>   - adjust error handling style for the return value of ocfs2_write_end_nolock().
>   introduce a new function, ocfs2_dio_zero_eof().
> 
> patch 4/4
>   Set f_mode with FMODE_CAN_ODIRECT only for non-inline files, per Joseph's comments.
> 
> v2:
> - Merge Joseph's code and ideas from [1]:
>    - Add FMODE_CAN_ODIRECT to f_mode in ocfs2_file_open()
>    - Change iomap_ops and iomap_dio_ops API declarations from ocfs2.h to
>      aops.h
>    - Switch from iomap_dio_rw to __iomap_dio_rw + iomap_dio_complete
>    - Change "struct iomap_dio_ops" from read/write style to PR/EX locking
>      style. With this approach, we completely eliminate the need to define
>      any iocb->ki_flags bits.
> - Remove alignment code from ocfs2_should_use_dio(), because iomap internally
>    already handles this.
> - Add patch 4 to remove unused functions and the CONFIG_LEGACY_DIRECT_IO
>    Kconfig option.
> - Add "Co-developed-by: Joseph Qi <joseph.qi@linux.alibaba.com>"
> 
> [1]:
> https://gitee.com/anolis/storage-cloud-kernel/commit/ea3fe75e2060118ba093e90b1cd34fa382914b29
> 
> 
> v1:
> https://lore.kernel.org/ocfs2-devel/20260724052559.15409-1-heming.zhao@suse.com/
> v2:
> https://lore.kernel.org/ocfs2-devel/20260727061802.18485-1-heming.zhao@suse.com/
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
> The test results: passed
> 
> ## xfstests
> 
> format cmd: mkfs.ocfs2 -M local --fs-feature-level=max-features /dev/vde
> 
> ./check -g quick -T -b -s ocfs2 -e generic/081 \
> -e generic/266 -e generic/272 -e generic/281 \
> -e generic/338 -e generic/347 -e generic/361 \
> -e generic/628 -e generic/629 -e generic/648 -e generic/650
> 
> The test results are the same before and after the patch set.
> 
> Failures: generic/003 generic/091 generic/094 generic/177 generic/211
> generic/225 generic/263 generic/322 generic/329 generic/331 generic/370
> generic/376 generic/424 generic/448 generic/467 generic/477 generic/481
> generic/510 generic/513 generic/537 generic/552 generic/563 generic/578
> generic/607 generic/620 generic/630 generic/755 generic/760 generic/777
> generic/784
> Failed 30 of 631 tests
> 
> (following is 7.2.0 kernel test result)
> Failures: generic/003 generic/322 generic/329 generic/331 generic/370
> generic/376 generic/420 generic/424 generic/448 generic/449 generic/467
> generic/477 generic/510 generic/513 generic/537 generic/552 generic/563
> generic/578 generic/607 generic/620 generic/630 generic/755 generic/777
> generic/784
> Failed 24 of 632 tests
> 
> ## fio on single node
> 
> (this is v2 test result, v3 test result is similar)
> 
> fio --direct=1 --iodepth=32 --rw=write --ioengine=libaio --bs=128k --size=1g \
> --numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
> - before patch : write: IOPS=18.8k, BW=4708MiB/s (4937MB/s)(4096MiB/870msec)
> - applied patch: write: IOPS=39.6k, BW=4953MiB/s (5193MB/s)(4096MiB/827msec)
> - overwrite (don't remove write.1g, run above fio command) speed seems same.
> 
> fio --direct=1 --iodepth=32 --rw=read --ioengine=libaio --bs=128k --size=1g \
> --numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
> - before patch : read: IOPS=52.4k, BW=6554MiB/s (6872MB/s)(4096MiB/625msec)
> - applied patch: read: IOPS=52.2k, BW=6522MiB/s (6839MB/s)(4096MiB/628msec)
> 
> fio --direct=1 --iodepth=32 --rw=randwrite --ioengine=libaio --bs=4k --size=1g \
> --numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
> - before patch
>    - creating write: IOPS=20.9k, BW=81.7MiB/s (85.6MB/s)(4096MiB/50159msec)
>    - overwriting write.1g: write: IOPS=281k, BW=1097MiB/s (1151MB/s)(4096MiB/3733msec)
> - applied patch
>    - creating write: IOPS=21.0k, BW=82.0MiB/s (86.0MB/s)(4096MiB/49938msec)
>    - overwriting write.1g: write: IOPS=329k, BW=1286MiB/s (1348MB/s)(4096MiB/3185msec)
> 
> fio --direct=1 --iodepth=32 --rw=randread --ioengine=libaio --bs=4k --size=1g \
> --numjobs=4 --runtime=100 --group_reporting --filename=/mnt/ocfs2/write.1g --name=tst
> - before patch : read: IOPS=372k, BW=1452MiB/s (1522MB/s)(4096MiB/2821msec)
> - applied patch: read: IOPS=369k, BW=1441MiB/s (1511MB/s)(4096MiB/2842msec)
> 
> 
> ## fio on two nodes
> 
> ### write in different folder
> 
> node1 /root/fio/diff/ocfs2-w.sh:
>> fio --direct=1 --iodepth=32 --rw=write --ioengine=libaio --bs=128k --size=2g \
>> --numjobs=2 --runtime=100 --group_reporting --filename=/mnt/ocfs2/node1/write.2g --name=tst
> 
> node2 /root/fio/diff/ocfs2-w.sh:
>> fio --direct=1 --iodepth=32 --rw=write --ioengine=libaio --bs=128k --size=2g \
>> --numjobs=2 --runtime=100 --group_reporting --filename=/mnt/ocfs2/node2/write.2g --name=tst
> 
> 
> node1 /root/fio/diff/ocfs2-randw.sh:
>> fio --direct=1 --iodepth=32 --rw=randwrite --ioengine=libaio --bs=4k --size=2g \
>> --numjobs=2 --runtime=100 --group_reporting --filename=/mnt/ocfs2/node1/write.2g --name=tst
> 
> node2 /root/fio/diff/ocfs2-randw.sh:
>> fio --direct=1 --iodepth=32 --rw=randwrite --ioengine=libaio --bs=4k --size=2g \
>> --numjobs=2 --runtime=100 --group_reporting --filename=/mnt/ocfs2/node2/write.2g --name=tst
> 
> run on both node,
> pdsh -w ssh:tw2510-[1-2] /root/fio/diff/ocfs2-w.sh
> - before patch : write: IOPS=19.3k, BW=2417MiB/s (2534MB/s)(4096MiB/1695msec)
> - applied patch: write: IOPS=20.8k, BW=2599MiB/s (2725MB/s)(4096MiB/1576msec)
> pdsh -w ssh:tw2510-[1-2] /root/fio/diff/ocfs2-randw.sh
> - before patch : write: IOPS=3742, BW=14.6MiB/s (15.3MB/s)(1462MiB/100007msec)
> - applied patch: write: IOPS=3765, BW=14.7MiB/s (15.4MB/s)(1471MiB/100010msec)
> 
> 
> ### write in same file
> 
> node1 & node2: (/root/fio/share/ocfs2-w.sh)
> fio --direct=1 --iodepth=32 --rw=write --ioengine=libaio --bs=128k --size=2g \
> --numjobs=2 --runtime=100 --group_reporting --filename=/mnt/ocfs2/share/write.2g --name=tst
> 
> node1 & node2: (/root/fio/share/ocfs2-randw.sh)
> fio --direct=1 --iodepth=32 --rw=randwrite --ioengine=libaio --bs=4k --size=2g \
> --numjobs=2 --runtime=100 --group_reporting --filename=/mnt/ocfs2/share/write.2g --name=tst
> 
> run on both node
> pdsh -w ssh:tw2510-[1-2] /root/fio/share/ocfs2-w.sh
> - before patch : write: IOPS=2052, BW=257MiB/s (269MB/s)(4096MiB/15967msec)
> - applied patch: write: IOPS=2558, BW=320MiB/s (335MB/s)(4096MiB/12808msec)
> pdsh -w ssh:tw2510-[1-2] /root/fio/share/ocfs2-randw.sh
> - before patch : write: IOPS=3588, BW=14.0MiB/s (14.7MB/s)(1402MiB/100001msec)
> - applied patch: write: IOPS=3590, BW=14.0MiB/s (14.7MB/s)(1403MiB/100001msec)
> 
> Heming Zhao (4):
>    ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
>    ocfs2: switch DIO read path from buffer_head to iomap
>    ocfs2: switch dio write path from buffer_head to iomap
>    ocfs2: remove legacy blockdev direct-IO path APIs
> 
>   fs/ocfs2/Kconfig          |   2 +-
>   fs/ocfs2/aops.c           | 689 ++++++++++++++++++++++++--------------
>   fs/ocfs2/aops.h           |  38 +--
>   fs/ocfs2/buffer_head_io.c |  19 +-
>   fs/ocfs2/file.c           | 168 ++++++++--
>   fs/ocfs2/ocfs2.h          |  45 ++-
>   fs/ocfs2/ocfs2_fs.h       |   3 +
>   7 files changed, 634 insertions(+), 330 deletions(-)
> 

