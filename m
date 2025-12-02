Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C79C1E9B3D
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 01:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764640279; cv=none; b=l/N4C8LjZE0AnkbGmAmokRGCjePIHkI7ukm8pO11vKc6Kc/sHBjf2VlIgFxEWGo+1WzaRlzxW6f2yrrLHyEnXTIStAAKf8iCC3K0IBIKI9YZvzrGfV61xCfOWmvnU6+LjEs91kge6O9Gd/6pZKabnHawF8S9TyBLrlXjHictrwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764640279; c=relaxed/simple;
	bh=/8xkrEPazKfzyzrUumQ8ugo7oqOZcTRyp8/peU+RjUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JlXndc89aA82st5zlHQMm4m5lGiQQymvyq6aGERXHc5t7wWPKDyGrwY6sB4FDBvgPZu49JCjyC+9u7NE5PY1SWGkjnkiQ+Sa6UjDU3gE3k2SRsXXobvDHTXxPipMLF5Cj8iRJGmfB1NITDQIo+eDwS+rcCbaG9ooadmZyg9KX1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=asdphWGE; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="asdphWGE"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-640a503fbe8so1906833a12.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 17:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764640274; x=1765245074; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xvy/SLVzcwhGLHk+WQH9jNRotYaxhvGol5SkkdGX+y4=;
        b=asdphWGEhGXoeeWQDk4OfVtZmFxa8pPIAfyvWyFYBSQC6LT8n0oaRcx1z3t7NW+StY
         oE3bXhJ9prAZcw7MhpE6Y6uvudSNoTg3tATMuxA4JmVPsbYAs8HoUN86QLskYIBlKArm
         UbmT1C4N9Ko2lp9BFD/Dr7bwk1/qH9RNpoZ9a6qird7bcvrpLsV2xl9u3cWjo9wcgOgK
         stcQpGAEvCCUC3ZkHh3ZTyfwTW7hUzIv1j/G5k23EU95pb8N0xUN7NjY+AG5aMFjTCGB
         g6G0OEV6WqDwpCqFiTv+X81Ng8wIuU4v1u6pkN/GrirrmJlIbUwKr0u23/Mm6+Sa521j
         Oq5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764640275; x=1765245075;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xvy/SLVzcwhGLHk+WQH9jNRotYaxhvGol5SkkdGX+y4=;
        b=RfyxpE49hTmLirvfcWXH7qWHGdKJu1LNzlCu12TA0oWjrXNxzCf7+hkrjsxqtzrVdc
         JN35d0ivufa+hh8yk/jVtPUlAXbmEraVc6qhsGvM9JWkSZJT8AU0Z7WcGFcutzihhgwi
         6NAp638v3tTY3YR5u0QvMBlIJYqzmvoVg2U3hMNf1dC+aiKEfhrLvnTHAvnP11+T9Ad7
         +zWvEgHjjCvL2b+vOA+v5wyMrrW8AxXX9EdFsnSob+J0D7E5xxFm+WmQcFXFp0nX8WEm
         ZsFi8NkoCcpo2AvhmRakLbg7LK3r2gLWnzXY2PfZ87nogZHbk7Sr3PgYYGraew9sM+jy
         lEQg==
X-Forwarded-Encrypted: i=1; AJvYcCVDNf9BjQKkcyEYIx+oDLhmDqrrCTuUycFgI+Ug13/sDUAbPTQP8p1YVvZAh3GR2jlClCPdNZImAtACAw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8ESlDVhfytQcCsLxDkuOxygAicPogep5yy4ndGTHFSVlYhfSU
	+LgZwyJtbmS9ktjIuw9Q2a+MU42KnnG51VtzOVXYGDvAFFST7OkuWABq
X-Gm-Gg: ASbGncteccbpVLdXFuDEEopXvBHJY7THpmQYAlPa1FOXS1eMHL+g3LtOtMl4vTuDr4U
	gfv70GeTaZDbUR23Ow3ujqM4nQhvt1yHADLFCjUF8FUzLpEiLfS/+H7fIWbEIkW8s84etNBiaxw
	xU4E97bPiAcM/OMcehv4QBeBHOFnDLIPmrcvSV/B1lFm3k+tTKpajjy3sLrtxFEculOLSmrP6f3
	sHJnPnTHXM4kxVBIP5ZywTA8ixpcdeMew/nKAcmIWT8dpOrJM/g2vbGbvjSt23xab2K0RFH8nQv
	iJRLNHwXfQ03t8Qoaqw+zog0yyKFA9ti3mul2753CR/+bmX/Np6se8coFgvh9b636Xi4YCM1zR+
	rL7iIYHxwa6BfNoWiAfLEVlRrZc5d8CptLtK8ewr4Hf70BMeJWUAd5Dr6EO3EY1QZb/QXrjOHNt
	nuwYBpTDhF
X-Google-Smtp-Source: AGHT+IGg9p02+L/a/lXtBqHXbLkKYNbcyW7WWXzp+P5g1sUiRvzwwWtLYKBJH2KeMk4RAdKNLuaZbQ==
X-Received: by 2002:a05:6402:3512:b0:647:70c0:f3f5 with SMTP id 4fb4d7f45d1cf-64770c0f478mr7226967a12.33.1764640274443;
        Mon, 01 Dec 2025 17:51:14 -0800 (PST)
Received: from eray-kasa ([2a02:4e0:2d14:1a1:8eee:b306:2d20:a328])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64751062261sm15624912a12.33.2025.12.01.17.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 17:51:14 -0800 (PST)
Date: Tue, 2 Dec 2025 04:51:11 +0300
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>, mark@fasheh.com, jlbec@evilplan.org,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com, skhan@linuxfoundation.org,
	syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com,
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: Re: [PATCH v3] ocfs2: Invalidate inode if i_mode is zero after block
 read
Message-ID: <aS5GDxVwTtefzxCI@eray-kasa>
References: <20251108120133.37443-3-eraykrdg1@gmail.com>
 <20251119221723.171746-2-eraykrdg1@gmail.com>
 <lkeaoxtkqccd3knpskbewkbn4cimlxaufix4evugcfkplk6u4b@oi36e4iu3x3r>
 <971dd5c8-970d-47d0-8cd3-b2b56aa0aee8@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <971dd5c8-970d-47d0-8cd3-b2b56aa0aee8@linux.alibaba.com>

On Tue, Dec 02, 2025 at 09:25:14AM +0800, Joseph Qi wrote:
> 
> 
> On 2025/11/20 10:32, Heming Zhao wrote:
> > On Thu, Nov 20, 2025 at 01:17:24AM +0300, Ahmet Eray Karadag wrote:
> >> A panic occurs in ocfs2_unlink due to WARN_ON(inode->i_nlink == 0) when
> >> handling a corrupted inode with i_mode=0 and i_nlink=0 in memory.
> >>
> >> This "zombie" inode is created because ocfs2_read_locked_inode proceeds
> >> even after ocfs2_validate_inode_block successfully validates a block
> >> that structurally looks okay (passes checksum, signature etc.) but
> >> contains semantically invalid data (specifically i_mode=0). The current
> >> validation function doesn't check for i_mode being zero.
> >>
> >> This results in an in-memory inode with i_mode=0 being added to the VFS
> >> cache, which later triggers the panic during unlink.
> >>
> >> Prevent this by adding an explicit check for (i_mode == 0, i_nlink == 0, non-orphan)
> >> within ocfs2_validate_inode_block. If the check is true, return -EFSCORRUPTED to signal
> >> corruption. This causes the caller (ocfs2_read_locked_inode) to invoke
> >> make_bad_inode(), correctly preventing the zombie inode from entering
> >> the cache.
> >>
> >> Reported-by: syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com
> >> Fixes: https://syzkaller.appspot.com/bug?extid=55c40ae8a0e5f3659f2b
> >> Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> >> Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> >> Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
> >> Previous link: https://lore.kernel.org/all/20251022222752.46758-2-eraykrdg1@gmail.com/T/
> >> ---
> >> v2:
> >>  - Only checking either i_links_count == 0 or i_mode == 0
> >>  - Not performing le16_to_cpu() anymore
> >>  - Tested with ocfs2-test
> >> ---
> >> v3:
> >>  - Add checking both high and low bits of i_links_count
> >> ---
> >>  fs/ocfs2/inode.c | 7 +++++++
> >>  1 file changed, 7 insertions(+)
> >>
> >> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> >> index 14bf440ea4df..c8b129db756e 100644
> >> --- a/fs/ocfs2/inode.c
> >> +++ b/fs/ocfs2/inode.c
> >> @@ -1456,6 +1456,13 @@ int ocfs2_validate_inode_block(struct super_block *sb,
> >>  		goto bail;
> >>  	}
> >>  
> >> +	if (!ocfs2_read_links_count(di) || !di->i_mode) {
> > 
> > the code logic looks good to me, but I prefer the following code to save a few
> > cpu cycles.
> > 
> > ```
> > /* only check if the "link count" or i_mode is ZERO */
> > if (!(di->i_links_count | di->i_links_count_hi) || !di->i_mode)
> > ```
> > 
> > @Joseph
> > which do you like?
> > 
> Sorry to miss this thread discuss.
> The above check looks wried since "(di->i_links_count|di->i_links_count_hi)"
> is meaningless, though it may work well...
> So I'd prefer the code readability first.
> 
> BTW, from the syzbot report, I haven't seen where to show i_mode=0 or
> i_nlink=0. Am I missing something?

You are right, the syzbot report itself doesn't explicitly dump the inode 
values. I reproduced the issue locally and debugged ocfs2_unlink() to 
inspect the inode attributes just before the crash.
The debug output confirmed that the inode had:
   i_ino = 17057
   i_nlink = 0
   i_mode = 0

It appears the inode block read succeeds (physically), but due to corruption, 
validation was insufficient, allowing a zeroed/corrupted inode struct to be 
initialized in the VFS cache.

> 
> Thanks,
> Joseph
>

Regarding the patch logic: We had previously discussed and seemed to agree 
on an approach in the thread linked below, but since I didn't get a 
final response there, I refreshed the patch here.

https://lore.kernel.org/all/20251022222752.46758-2-eraykrdg1@gmail.com/T/

Thanks,
Eray 
