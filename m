Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BC022128A
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Oct 2025 16:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760026720; cv=none; b=aEWjFpfDApOtiflMtz0NRBbEoKo1W/ZKO15Sq13pvFtpyJ+l+2Yu6e18laOlhtZMvO1YuvBIHNS6+g1yy55jwYbDACxs3ocJDcilv4qcn1wJZ2HWPYihpng5C+D2cRdHw2Avhk/KuB2ObL6y9jWVPxtGufhgbhYKpruaOA3Y3YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760026720; c=relaxed/simple;
	bh=kxVHxMc95GGXvIkwI+FLL8BN/0LlIRrn4Zoc+7oMMro=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iEuFKwjwccE7/H5afC23B2DVUwkOboBiZYfjd/SgU3PesjwW7XniDs9vffPbGjvTijtrMZKQpTm3IQvGQzcT+PD2RMjDzS0qNFiaHAQpyGQwAisPquOIVqkQ6gJsuWwWQEpN2noAVc5zhC3Nn8pMJCs1mBQsUPgdXe4J34uV07g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fasheh.com; spf=none smtp.mailfrom=fasheh.com; dkim=pass (2048-bit key) header.d=fasheh.com header.i=@fasheh.com header.b=B3udyKqV; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fasheh.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fasheh.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fasheh.com header.i=@fasheh.com header.b="B3udyKqV"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ddabf2ada5so16775461cf.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Oct 2025 09:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fasheh.com; s=google; t=1760026718; x=1760631518; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c+yglEpiCczijhLlnigG3G/VKFVz3v4OuKtLzp+LX7k=;
        b=B3udyKqVifmGm0KtzGARBJwDktdODc3JnEqCY6zV9y+T898MgQItnD8OFHkxpULH02
         HithIb/DG8yn2p9h5F2Akz7bZih15x/l0VnJef42PAKCMMXje+OHeNp4Zi20LKSv5nWT
         BsNq1I7D+u35VKQS7qh7zD9Zrdkl1ECRtVWw4Bo34br91aC8p4PgWwFujc38FZwOuc54
         F73aYuQ5LtgEIOsdSvErgkyI9Hl1bbFpt/S/yaKfcxm07Wf3n4Tl8SeWJEn2HGG7m+Gm
         wQIRR0fMFrmh4DpC9XIEC2duXyJVn+m3eXyp1+tKaN2h4DRQiihX+mgqL0HWaNjS0hp7
         JfRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760026718; x=1760631518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c+yglEpiCczijhLlnigG3G/VKFVz3v4OuKtLzp+LX7k=;
        b=H0ci8GYyEAPKbGbxtCVIgvMB81qJC5NtkqoiESLo+g4sNogpGiFVv1iK1LT4b/l/wg
         13qB1d5BPIeJDvJJ5MiYgJe6PtwgadsinJVLotzpkmC9u5QH73sKYsOagARaJQPjwgB7
         iLz4TVJlRgY3xGSRBWUkYdU/00vOHyZByjQgRHdokuSDGFEctdso494R0TWvZ6zj2ZL/
         kHqyaKbMW8rdGboZUge6N9t097gGp6HK0j0KtWdR6jqwq5hSl8EqHmLx2Lxixb8RqoXY
         2tEulBaSefmKR5Kuc64kdWh+ZTrkvrRPBVkK1Sc1aRu+jGPBA5XQW+KMGTEk1YyGkfBI
         3gng==
X-Forwarded-Encrypted: i=1; AJvYcCVl2BmPXEA5otwooldYKfZ0taOO/JoEhrkuhgwOvdgRLyyl2pgi+TtoH6EEIIX3xXS7vcz01EoV/qsGwA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzA3B/nlHsmWJwwGnK5a1kYqhMBeCbqDIElK/viHK9+/YZCmI/t
	uRrhMqNgJ6wqTR+rX2gYCCNC1iBWEId9Dd/RWtlWi3PlK5bEjUstaziCxy72kBZtqzv9+6w3ZIB
	zAZg5tDPe0Nf8rc3hQutxx5WC8lr4Bt8mXoPB2yFjSw==
X-Gm-Gg: ASbGnctxK/zS4tcjhHJJ078G3xkBsJQ1Iul3AqWEdMWjd0Ma7rjvgCb3ZyySzKwTwHU
	uQKjxH75lMCA9JLLkim7cEDcLp/LQzCIpNy842NNpcmc/EFFqhC4+Agh9JyhPGFIaHaZzFyC9gY
	D2NfpdIbo7CTlOm4Ge7/XZAJ0QoUNq+hS6ZWwUurpwpo1rfc/MEmX0/mRN96skAIgqWPgh2YST4
	s/GrBMzMmB0txPf91EGWWRmf0ygXtKFjvh8btprwFhllZcxULoQGl+/zpHCa4WA
X-Google-Smtp-Source: AGHT+IGSDZQ91zkPiorf3Ebe4MIrTohmsmEWtbBJXTxxH9beyjPQsa9hq/WsR7pKHUgmveibuCGt0jSW8LvPr4NIfEY=
X-Received: by 2002:a05:622a:1b24:b0:4e3:970:661a with SMTP id
 d75a77b69052e-4e6ead91fe2mr116013621cf.75.1760026717692; Thu, 09 Oct 2025
 09:18:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251009154903.522339-1-kartikey406@gmail.com>
In-Reply-To: <20251009154903.522339-1-kartikey406@gmail.com>
From: Mark Fasheh <mark@fasheh.com>
Date: Thu, 9 Oct 2025 09:18:26 -0700
X-Gm-Features: AS18NWA5Pj-hSBrzbQwf_Ctu81wdTtwASD3kSEuUG2O5T0FbiO7a4qiMtv8BTWk
Message-ID: <CAGe7X7nk+XJdGX0vGFy4geXfeWdHBwC4rw6CoALr7L9M2REV+A@mail.gmail.com>
Subject: Re: [PATCH v2] ocfs2: clear extent cache after moving/defragmenting extents
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 9, 2025 at 8:49=E2=80=AFAM Deepanshu Kartikey <kartikey406@gmai=
l.com> wrote:
>
> The extent map cache can become stale when extents are moved or
> defragmented, causing subsequent operations to see outdated extent
> flags. This triggers a BUG_ON in ocfs2_refcount_cal_cow_clusters().
>
> The problem occurs when:
> 1. copy_file_range() creates a reflinked extent with OCFS2_EXT_REFCOUNTED
> 2. ioctl(FITRIM) triggers ocfs2_move_extents()
> 3. __ocfs2_move_extents_range() reads and caches the extent (flags=3D0x2)
> 4. ocfs2_move_extent()/ocfs2_defrag_extent() calls __ocfs2_move_extent()
>    which clears OCFS2_EXT_REFCOUNTED flag on disk (flags=3D0x0)
> 5. The extent map cache is not invalidated after the move
> 6. Later write() operations read stale cached flags (0x2) but disk has
>    updated flags (0x0), causing a mismatch
> 7. BUG_ON(!(rec->e_flags & OCFS2_EXT_REFCOUNTED)) triggers
>
> Fix by clearing the extent map cache after each extent move/defrag
> operation in __ocfs2_move_extents_range(). This ensures subsequent
> operations read fresh extent data from disk.
>
> Link: https://lore.kernel.org/all/20251009142917.517229-1-kartikey406@gma=
il.com/T/
> Reported-by: syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
> Tested-by: syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?id=3D2959889e1f6e216585ce522f7e=
8bc002b46ad9e7
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

Reviewed-by: Mark Fasheh <mark@fasheh.com>
