Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004021D63FB
	for <ocfs2-devel@lists.linux.dev>; Sat, 11 Oct 2025 04:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760158222; cv=none; b=fCXnsGKacQqXL4dftAI+yE1K0ycleLrdLXhUtFaP63OvhHT8Qu5zBtK/KHhAepw3kBraHoZlpW39tbH4NQ+DVuCsVXjW0sYL7IQZNNvzwfFlhU+SJGqMSV+mv1Uoy50UtG//4pn30MfSGBleZARMpLljCwIIU6xRFjtwctu+m1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760158222; c=relaxed/simple;
	bh=7iZCkk6Utuot4Emf4RdZwIk0Xs7t/Yn2MMHIxN2VZXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EtjNJgsGiIKfxU0Tf5+aPuWIiOTY7yNTxojD6YDiZHZiFHdtcapD66yLDeCVRhqbZw1wdn7fyjNut3ynr853PYTBFazVgE4qni1IGoxeYjurFqmkc2E/FVyr+QJjZ51zD70a5ATzbAlWilfoD135u8KsG0jzrpx5HgLnN92G9zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=C80duFx9; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C80duFx9"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46e3e16d7fbso4277105e9.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 10 Oct 2025 21:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760158218; x=1760763018; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gJaHHzb98whMDANy7SthGXRNhzvrWK14yO7S2VCvICQ=;
        b=C80duFx93pYsA9Dsirrg4pFpSH7cExl6GezmoFSLbzxQNaHtgbKW6RqWfbJpqRo2Wh
         wuZVMx+GZCOBGOD5jY2qFbZ1snThw34qaOr8NRBGUJQzGj1FjX8iHGgWlQFrRPsp6bWs
         X3Jg/Tp+ThY75fsuWopuGC4ikAvgIc+S01XsDOotg0qdDnZ+jWZn2tacG6jr2Jm/rPDK
         +ogELVP36LxUlW7baDim6kCQwa5eBUmlMEPZNX9C/BXcbsW8+E77X80Ji4gBMquzBd13
         0jG1WS5VCkzwMSKri4GMipnR+DXE9uT+cJakD5xtN4lqPPwXZG8CtgbPSuCQqZmSTnYn
         DkKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760158218; x=1760763018;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gJaHHzb98whMDANy7SthGXRNhzvrWK14yO7S2VCvICQ=;
        b=LL0OfGXYcpD6aVjKL+payTNLTtyHeE8mP3tdWNk7r01zt1cUnGac0+Q+gVgHfbhnQ/
         VF7u471hDT+vtE3Kvb5p4gDvgPXIgU6TsQyFPBtgWlXMerIxpN5XZmAOe3D1JwPN1xbZ
         em+8+j3AGK3onPUx3nxaDvuSdX85NFRV+Ra2sW0MUMiG1E44LFDEJ+kMPdhdjXV+z6Ri
         sa1Ua8AMT9PbuZgJ5qH1qPBBtbEmsjZCa0L8f+BtMruOuFhbiySjtsSmPl0QSTei58uv
         zzhIsmMcrHO7rpF1o2QNGSaGIBFJxjxnc6lZUow7gQWfkNsFJF4BFLaIrcgTuTdL8BFQ
         EYFA==
X-Gm-Message-State: AOJu0YwDMWSREPHSqPZ7AcCQXZIhs2uSBLXtLscokeihJawz/R0LkJmn
	uRwOhm6DjnmDL3OD90/HLLHB/kgCHVnVNPbW1sClkXQrqzHL6XcAw3lztYsPfM34foc=
X-Gm-Gg: ASbGnctAXHXsMSbPMEhy6FOoevF0nRftUyCQKo35beFIs9jF9jZFEU/CIx2N5r4U88Y
	GV5cYcohFKK/A/1HCROSS9KA9Hhm8f+1lR+HmlgHDpl6g2/6qN5MNaA2GfFm/uyiZuOwaCXXsPA
	0l6vXJ/rGCOzCAhsnmwShdn8HnODRyfMerkMOUys8x2xuTX/GfnOdU1eNtzgWqxGUULxJTENlIf
	FP/iaIgOM9N0LOSe24lhs4yztdWL+OLCHdy8NlH4t244k5YATChG9S1HOPXbdh1gBmf83BWOJk2
	g9udEyov2Y7PwufYCIyiYIOGApmBpP0ihyutPhLrdQocBvUSfKwpKjHksasWTyud3YMTftm+Y/t
	z6s18WbmWiyo4fZmglCRl+wvYKRUp0wOS9Qpg4HhATr8q6bZC
X-Google-Smtp-Source: AGHT+IFCY7Bg3bp4HCamL6JdB/O3QwZvJNhtQGCXiG4FoXzDe+0ZqNgI+aBZeDl466KKigUX3DuZFg==
X-Received: by 2002:a05:600c:c162:b0:46e:6778:c631 with SMTP id 5b1f17b1804b1-46fa9a214c4mr51840405e9.0.1760158218154;
        Fri, 10 Oct 2025 21:50:18 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b61aac5besm4970688a91.14.2025.10.10.21.50.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 21:50:17 -0700 (PDT)
Message-ID: <6541511c-8865-4903-b26c-2e2abf78ad99@suse.com>
Date: Sat, 11 Oct 2025 12:50:12 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix stale extent map cache during COW operations
To: Deepanshu Kartikey <kartikey406@gmail.com>, joseph.qi@linux.alibaba.com,
 mark@fasheh.com, jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
References: <20251009142917.517229-1-kartikey406@gmail.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20251009142917.517229-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Deepanshu and Joseph,

On 10/9/25 22:29, Deepanshu Kartikey wrote:
> 
> Hi Joseph,
> 
> Thank you for the review. You are absolutely right - the cache clearing at the end of ocfs2_refcount_cow_hunk() should handle the COW path correctly.
> 
> After further investigation with the syzbot reproducer and extensive debugging, I found the real issue is in the FITRIM/move_extents code path. The bug occurs when:
> 
> 1. copy_file_range() creates a reflinked extent with flags=0x2 (OCFS2_EXT_REFCOUNTED)
> 2. ioctl(FITRIM) is called, which triggers ocfs2_move_extents()
> 3. In __ocfs2_move_extents_range(), the while loop:
>     - Calls ocfs2_get_clusters() which reads extent with flags=0x2 and caches it
>     - Then calls ocfs2_move_extent() or ocfs2_defrag_extent()
>     - Both eventually call __ocfs2_move_extent() which contains:
>         replace_rec.e_flags = ext_flags & ~OCFS2_EXT_REFCOUNTED;
>     - This clears the refcount flag and writes to disk with flags=0x0
> 4. However, the extent map cache is NOT cleared after the move operation
> 5. Cache still contains stale flags=0x2 while disk has flags=0x0
> 6. Later, when write() triggers COW, ocfs2_refcount_cal_cow_clusters() reads:
>     - From cache: flags=0x2 (stale)
>     - From disk extent tree: flags=0x0 (correct)
> 7. The mismatch triggers: BUG_ON(!(rec->e_flags & OCFS2_EXT_REFCOUNTED))
> 
> The proper fix should be in __ocfs2_move_extents_range() to clear the extent cache after each move/defrag operation completes. I will send a v2 patch with this fix.
> 
> Thanks,
> Deepanshu
> 

let's look at the syzbot page [1].
the following analysis is based on the c code from "2025/10/03 12:11" [2].
(btw, syzbot never calls __ocfs2_move_extents_range().)

The test code mainly involves 9 steps:
1. create img data and mount
2. one time open() the file (0x200000000080ul), return fd: r[0]
3. two times open the file (0x200000000280ul), return fds: r[1] r[2]
4. call ioctl F_SETFL 0 on r[1]
5. write r[2] with "0x0000000000000000" len:0xfea0ul //clean data job
6. call r[3] = dup(r[1])
7. do copy_file_range(), copy from r[1] to r[3] len=0xd8c2ul
                 //creates OCFS2_EXT_REFCOUNTED and create extent cache.
                 //check ocfs2_remap_file_range() => ocfs2_reflink_remap_extent()
8. trim r[0]
9. write on r[1] //crash.

the root cause is that, in step <9>, it calls ocfs2_refcount_cow():
- the input parameter di_bh is created by the caller via
   ocfs2_prepare_inode_for_write() => ocfs2_inode_lock_for_extent_tree() =>
   ocfs2_inode_lock_update(), which reads file data from disk.
   The extent is without OCFS2_EXT_REFCOUNTED flag because r[1] & r[2] point
   to the same file, and step <5> cleanup the file data.
- ocfs2_refcount_cow() then calls ocfs2_get_clusters to retrieve the extent
   from cache, which does contain OCFS2_EXT_REFCOUNTED (cooked by step <7>).
- this difference leads to it calling ocfs2_refcount_cow_hunk(), which
   triggers a BUG_ON().
   I suspect step <7> needs some time to write back the COW data, and syzbot
   starts step <9> too quickly before the write-back job start.

how to fix:
the v1 patch is reasonable, but the commit log needs to be revised.

for Joseph's question: (I copied here)
> At the end of ocfs2_refcount_cow_hunk(), it has:
> 
> 	/*
> 	 * truncate the extent map here since no matter whether we meet with
> 	 * any error during the action, we shouldn't trust cached extent map
> 	 * any more.
> 	 */
> 	ocfs2_extent_map_trunc(inode, cow_start);
> 
> It seems the cached extent record has already been forgotten. So how
> does the above step 3 happen?

my answer:
the crash only happens on the first call to ocfs2_refcount_cow_hunk().
ocfs2_extent_map_trunc() does the cleanup later, but the malicious
extent block is cooked before ocfs2_refcount_cow_hunk() is called.

[1] https://syzkaller.appspot.com/bug?extid=6fdd8fa3380730a4b22c
[2] https://syzkaller.appspot.com/text?tag=ReproC&x=163c9214580000

- Heming
