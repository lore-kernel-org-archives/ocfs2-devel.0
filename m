Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795750250;
	b=sWhiDiDadfygTxNTsaZksv+pHmdhly53y64RxKL+AaX/tXr7vf6E4hGEpKh76WNvDWk/
	 +osyjgv1eutaMywCXir/Q7w8hpeBH7QU6vVu2VpdpyfyJa+0fVRKplyHWo30S+P/TCfqc
	 auNn1tJTCziBrCaz4P8nels+V+G/PGeZvDkRFU+s+djsL3MFmkasA3XdjKO9mTlgiGvVN
	 rFLnYjsvI1fWwXVmu6Xv+u4thkYDVqsTG7GfqA5HTQBpbAtYbZEWOTaiXzta6s5UZLT1F
	 YaiqJUpc79g8s4BJ7OdT3GltxiJHMj6QXYvIr52VZn8iujwluBi+FoFVZwVX0Jl4CnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795750250;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=2WntL9HcIOIR5AycSmIyUOX5AWULz5zCJD14PkRWd7w=;
	b=N1gnSib/w+QrJ1SPqm1ATKCJ0JaxFeEgXQFjVAcl9Z+zc0lZQ8PuE/b2iWbBKePWVeuy
	 8FNPCB5f7tJX7e/Z0uQMXzVHLUx9nTP/mJLsTDa2xGe0rRWBzDhNSwRnb+/9tFqP61yT2
	 qw6qXHwe1Uju4MHTYe2uJDchyxleahB7KqBuWx69cDZ+PC7uG6x0Hgtg4V97JTf8eEvS7
	 dhhYM4bsHu+Tah2qwsG8XbyjZjFUAcEOVZhUXnD86ruvpPH+7xPcGb7iDvf0KsCOR+Eo5
	 iKCSoTQp5AcSt57T9LGlc+lxI+i3Kue2kNeKAp35p5AipBGemYsP/O3VZaD+VsmwB9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b="Hm9w/6Rh";
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BE5606A321
	for <ocfs2-devel@lists.linux.dev>; Fri, 27 Nov 2026 03:30:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77BE5606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Hm9w/6Rh
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c50692e6c0aso118452466b.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 26 Nov 2026 19:30:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795750248; x=1796355048; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2WntL9HcIOIR5AycSmIyUOX5AWULz5zCJD14PkRWd7w=;
        b=Hm9w/6RhSJ4GPvNQvpxVQ0/XYFpHxyoUtrm4rPcgwqzNKbaByQfPJOLkw7S7bYIwPp
         7tb4r0Cpa7Ejry/ee8dYwZ8pXqEKQIoDSNMvY8oZvHLtp9vLWHD8TWY6D0VbMNDidwQ3
         q4dLeGiffZkZvMTbvF1SU5qcOysVARW/R1DP80I9OkU3acur/eAOtDmXF3KN4mYfw2GX
         C1tN23N3QHokMb7CI3S/PnRgudjlzuFYWH2kkRgLiXhfoe6tcvMU7ZHXYT8KktgmgbgT
         EKYUiPe6aeKKcQeV8KweqyfZGL3EXxd06XKH2HTGMl5rX1UB/9tLW5hjOa4NSWUuBtRR
         OW9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795750248; x=1796355048;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2WntL9HcIOIR5AycSmIyUOX5AWULz5zCJD14PkRWd7w=;
        b=rj25eHqoHd9rviVikS4oLmTH2/aJrkGymp1fzlO7RFDV7moA44xTecsXwN5oBAhvde
         f2SzGuLQBzoZDuceKciPfOxXrMgc592Z53V+hwA+Vxi6NR9aebzlLbng1Sdi5FDiAbxe
         d1RaiTIX/AFGs0GxiounkRrz8uTgUuOu2i50s31/us4oEDDLov4my7ur0i26gXxaA3wP
         uApSE/p5atBujhdsimhMeM8N4Erk/Q5ax2cZSU3OkCZjmJ3srC3a1nyr1CTUNxxbZsRz
         /S1gkjJr9d7+mibDQ9Qxv7B2OCFUho1tgSZHIgfW2CYInb18zd/DkNq0qqRlAkrNkg7z
         bPog==
X-Forwarded-Encrypted: i=1; AL+hErEPfbZg6DscoS0oqbMvEL/tbE+RYCUE38821NrtAhCt9jW0W3D5+dgmdVO/aHTwq9GKEKz+o+n98j671Q==@lists.linux.dev
X-Gm-Message-State: APuU4Z/GyOWbWhT9fa5eDoGvs6MR+sw/dX4xodtV8/Q3ixpxd0JJ6yHv
	c3sfXdBS1tprx4r2TbWAt9JaXTPWtuVxsiDeqeh96IWqFIhxehiH96dU1ydrtJ5xOEM=
X-Gm-Gg: AZFdTZevv9SMMR3sAYWkCatD452b6PsIDoA6d+udCBghnpISEIMKCi9FFo3vCq4QBzM
	O3os+6BXYf3gAdYBWsSAK6qaPzBy3wAJyRlyqihPRPs4JBaxC3G2i+a0j3NTTKuO0eeQb1FC4qZ
	/AHDjKLScKYCj/ZNuxeHOalBAH2OYrfAgJLziCvrMxO45pdENZbKyjcRCVMQRpo7Zl0WP4caWLn
	br+KBTE2HsNLckoICInVXgvVIXX53/6Nezw2K6VIszdbVFlTJrvzv+tS13PGrKO55BnhRsjHI9N
	3Tb8RR7UEajwYQ5Te/DeZoVjt5Dp40C8LSNf976pDohlF9NMcbOFaC69KbWr043LWvXBBX94m7/
	jI0fT8JEDWjctfCBXYJuiAiPWZ0dyMfdVOzItAC6PZKf0h2l4+RlSe4eRHLSrRCjy9F2FAQ0Ulp
	ozF+IU1cUeYJYlPtsQUHt922cvfd/mAc95lAMAqCFXHKYiD+FrQgiF+mYINDd2KqqvhJGtnGtev
	zxB0+IlWl75h1zObg7zgLI1161jkwM1QW7KAL9dZWUV2pIdDrdByeZCtZd+jKntwjpRLvZVfQFz
	Vv/FgD5qRZ0bVwXQuJcxOoBeNOvZXsCg3Gs=
X-Received: by 2002:a05:6402:a545:10b0:6b4:2960:d381 with SMTP id 4fb4d7f45d1cf-6ba37c76e50mr15405397a12.1.1795750247803;
        Thu, 26 Nov 2026 19:30:47 -0800 (PST)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405ecb486sm38346233a91.16.2026.11.26.19.30.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 19:30:46 -0800 (PST)
Message-ID: <97e7fc50-80ff-4c73-a3a2-7e09c9d8849c@suse.com>
Date: Fri, 27 Nov 2026 11:30:42 +0800
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
Subject: Re: [RFC PATCH v12 3/3] ocfs2: switch dio write path from buffer_head
 to iomap
To: Joseph Qi <joseph.qi@linux.alibaba.com>, sashiko-reviews@lists.linux.dev
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20261125154626.22335-1-heming.zhao@suse.com>
 <20261125154626.22335-4-heming.zhao@suse.com>
 <sashiko-outbox-233793@kernel.org>
 <a9224bf6-9d1b-4fdd-9980-a70c39b11b57@suse.com>
 <843bc832-5731-4f06-835c-9594c53a4cd1@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <843bc832-5731-4f06-835c-9594c53a4cd1@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/27/26 10:11, Joseph Qi wrote:
> 
> 
> On 11/26/26 11:07 PM, Heming Zhao wrote:
>> On 11/26/26 01:05, sashiko-bot@kernel.org wrote:
>>> Thank you for your contribution! Sashiko AI review found 11 potential
>>> issues to consider:
>>> - [High] ocfs2: missing fsync tid and i_blocks update in
>>>     ocfs2_dio_end_io_write()
>>> - [High] ocfs2: buffered and mmap writes do not wait in
>>>     ocfs2_unwritten_check()
>>> - [High] ocfs2: ocfs2_dio_cleanup_range() fails on zeroed folios past
>>>     i_size
>>> - [High] ocfs2: missing IOMAP_F_DIRTY in ocfs2_iomap_begin() for
>>>     uncommitted metadata
>>> - [High] ocfs2: orphan entry and block leak on failed or short DIO write
>>> - [Medium] ocfs2: overestimated metadata reservation in
>>>     ocfs2_write_begin_nolock() for DIO
>>> - [Medium] ocfs2: per-cluster multi-MB allocation thrashing on ENOSPC in
>>>     ocfs2_dio_wr_map_blocks()
>>> - [Medium] ocfs2: per-cluster w_desc kvcalloc, ip_lock scans, and
>>>     duplicate lookups in DIO
>>> - [Medium] ocfs2: preallocated extents truncated in
>>>     ocfs2_dio_clear_orphan_locked()
>>> - [Medium] ocfs2: stale inode state after lock drop in
>>>     ocfs2_dio_upgrade_rw_lock()
>>> - [Medium] ocfs2: ocfs2_should_use_dio() forces buffered I/O for
>>>     sub-page DIO overwrites
>>> -- 
>>>
>>
>> It feels like the more code I modified, the more issues I introduced.
>> Furthermore, Sashko has started reporting performance issues.
>>   
> 
> I'll take a look this weekend.
> And then we discuss and come to an agreement which could be left in this
> series.
> 
> Thanks,
> Joseph
>   
> 

I will send v12.1 for fixing following issues:

- [High] ocfs2: missing fsync tid and i_blocks update in
   ocfs2_dio_end_io_write()

- [High] ocfs2: ocfs2_dio_cleanup_range() fails on zeroed folios past
   i_size

- [High] ocfs2: missing IOMAP_F_DIRTY in ocfs2_iomap_begin() for
   uncommitted metadata

- [Medium] ocfs2: overestimated metadata reservation in
   ocfs2_write_begin_nolock() for DIO

- [Medium] ocfs2: per-cluster multi-MB allocation thrashing on ENOSPC in
   ocfs2_dio_wr_map_blocks()

- [Medium] ocfs2: stale inode state after lock drop in
   ocfs2_dio_upgrade_rw_lock()

After v12.1, I will stop fixing bugs/issues until we discuss what to do next.

Thanks,
Heming
