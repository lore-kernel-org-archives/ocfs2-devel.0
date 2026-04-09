Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAEF30F531
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Apr 2026 03:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775705884; cv=pass; b=iFqa/X1CPeQ6JrAmMIy3A4yPHL7AleXrn1gxMKZ39pr6Fos18QAUmukzvnXQZqmhBA9x3bYm5GaHSGv1uNmZWwJ5t8N3dkHCJXwW5YNYgYOY1DwHz9FcsgglyqkAAQAIsM5eX9gcN3MzhKCJSUjf+hnSwJ9VlTN2ka+cOQtwtv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775705884; c=relaxed/simple;
	bh=Z+Gsih3swvgAjs1WkbC19fgVahp4B44NyvTycksfEek=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CNk9KdExTVRxQtp9tpG8IWtH/vT8GmFyvQ1l6Xo0AylZ6H56NxOsnU6T14EQ6T1J1wgiUOh0ZBRyc3fKQgywwmbbcuJ3+qT5EDfCtSaEYZpCS17kD2o8+05bhJshyRLnh+r3SS5kGI32gYt3PyxSbtU4OukEorj44TILm6QBfU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WIx1FTtW; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WIx1FTtW"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b9825ba7e8dso54720366b.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 08 Apr 2026 20:38:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775705881; cv=none;
        d=google.com; s=arc-20240605;
        b=CDPsdydr67KOH5LmySHcyJHpP61inr7i9gsFGhlhxRyhYsBQjeXBvSYTkBa1N27ZjV
         qZ7LmEPBKlCREesetvHCVOFazE5XBfogGXc92s/MOkEQBkpezKFgQ8U013nYvIlM/ydj
         kcg5wIqZWVmvjlNKwE5n3Y59VZOTqug9H87p3zO7yywyC+NneokRWc16p2Yu9zlTZyBO
         u77tngvUK0B2LNxZcXnUbv4Z4rVcwE9FAh5vpjQqspQZ+7exo9XO4Xy/6ujS30TkFkbw
         B2dJ2OHIiPP0kp0l7NrHGs192CU5AnBvq1Kbf3ouDc7DxRtUa2kAbxM5Cqw8m4/vnihL
         zopw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Z+Gsih3swvgAjs1WkbC19fgVahp4B44NyvTycksfEek=;
        fh=Y/yQZqbcGdaXO8VIujCtO/8geMVRLU2IgAy2KG0ICoY=;
        b=LXwl1X4tUObG1Lbibsq2jScNoMfwCw2pss99eLj+eQR7QRUUW/2i3jbmIGrza3DFqX
         fZ2ZmgKUO73m+u5SKKZlAF4S1VIiqSwlXFQXd6QFMoAfztKcf5wTJWIURBV0z5sr5aTT
         8QdG8m8H/T1dlk3d0xcYPEdst45DMzJYWiQJeUhwL8ZXYZdMxc61suFRfHZ9v+7TjWX5
         lAVN/QZYppvoKqhfGcDlT7rc1Kfj/NwhLuN537xIoTLPJJeGVUi4MIQqiLjAiU7LStV8
         MPtymlkUwWxUopsQHlzyVFyZkthWlZg2t5CfIGm1FFaanHwq/CLDp6eQcQQ76kEN/YF8
         m3NA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775705881; x=1776310681; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z+Gsih3swvgAjs1WkbC19fgVahp4B44NyvTycksfEek=;
        b=WIx1FTtWrus/lkCZKqJX74IsgHS1mm7vXoQ7Bf6SUA/JbxkZjaYPhUCUrsATTmvHFN
         BIsxU6ZHUDUsCiE+N+n4tc+ay3TFzSN1P8nIEHNr9MEs727TQFXrw+SZK7UeQDTsXMF7
         HzrqIe7R6PIiW+M3q8REkFGvarNwjbXsIImlBRXWZ94XiRabNGqUQ9v1BTWD4legLQEI
         ATmQ2j+4J4VmHCxCtwCGAvpi3RGT848WGBzLPR8ClIznEiNoOPSn9OJtnWjvEy2DcGZk
         s6KoAFdgoKnglFP9NRpEfyG39MF/oGKJZkCmtGhrrGwl4N/1qUXu4zbLR7j3n29txkgi
         swiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775705881; x=1776310681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z+Gsih3swvgAjs1WkbC19fgVahp4B44NyvTycksfEek=;
        b=lvcQdf65ENX6adK8/dPReKLqgR+GsvLEc4gUvAWq62RDlSq2YFnGIWGJ61H0KkmT/7
         7nQYvrXBeizUzfKDxS0k53V3MtOYZ/dZuHwTYBLKSFv+IkPQnxlc4g3VFRIgJYbGDngp
         /nA0/wCC25YC8HxM64kKG3YaCRRDcdA8ziTO7ZlUDF9I+ooXyQlGlBQ9XgBcyUJ/mLX+
         B98QBdbxvXxHf7WFTAuZ/z+HTECPOg8Gi1ddD1dcIp/DhQQ9wAYGe1Cv+NKtBK6Uu1fS
         XXpzKXY24aS3ZMP2wQstc5hfjG4IT0dS3SX8WOvdfD2/va+LxCiLsMVqYQZ4U/ZTohap
         ZO9Q==
X-Gm-Message-State: AOJu0Yyg32DfNE/sNdlUZTLyHT319XqdJd9ub0BUnjJbiCV49uD7bcYo
	JmAWANuCC4pFyKlBI8D69ZXb+GacylsgBr3r4OCbt1pCKwWhgt2Z+WRzOUskvBuRDq1DWCCpuHD
	PWuqvca/j0tY0XLoQDWWysTRH5ZAeDao=
X-Gm-Gg: AeBDievA/3UgY0XHRkSqrvwGy9Mt1OSIlwh4nVC9lcqgjefr1J+He1DJHWfgh+pvwkw
	FNuQXQC2UHucrlRhbZerA2JAQYcxI7MS82xalin9IfhIHqZbq062zNQrq7lPzQjNGan09/ixL/w
	zt/uoV3wsWFYiCJL+LUKhgmlD0R6EPF6fojaCuczY7m/EUsKDTumrf+naoCpeuQn3asi6UjUakY
	UEBdmRW1C8Rem2tiCEI/yVFJ92FPbKJMXVgwv92eeZpBgY0kqNWWSwYtzQ06z0RLGXBwK37Bip1
	CPn0BUdNm1lmfjHuoaf1q98WIoH98/VKpdte6lCIJQrH8seSX/7EnJ4=
X-Received: by 2002:a17:907:60cc:b0:b9d:326c:463 with SMTP id
 a640c23a62f3a-b9d326c4c83mr249034766b.23.1775705880662; Wed, 08 Apr 2026
 20:38:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260403063016.438287-1-gality369@gmail.com> <de8b2fd1-5176-472c-9fe6-e0b464133e7f@linux.alibaba.com>
In-Reply-To: <de8b2fd1-5176-472c-9fe6-e0b464133e7f@linux.alibaba.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Thu, 9 Apr 2026 11:37:34 +0800
X-Gm-Features: AQROBzAhwXuikxoaTEf2FL8gc_uUrRDLZeJCA9JIBBGc6SvwrzidZN1Z9eAKbsA
Message-ID: <CAOmEq9Xz9Z3qgC4iMzxyDJ=CnanM7J5-GZgzyn0djXmid9tCAQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] ocfs2: stop BUG_ON crashes in suballoc invalid-dinode paths
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, akpm <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 3, 2026 at 5:30=E2=80=AFPM Joseph Qi <joseph.qi@linux.alibaba.c=
om> wrote:
> On 4/3/26 2:30 PM, ZhengYuan Huang wrote:
> > commit 10995aa2451a ("ocfs2: Morph the haphazard
> > OCFS2_IS_VALID_DINODE() checks.") converted several OCFS2 dinode
> > corruption checks from graceful error handling to BUG_ON() under the
> > assumption that every caller only sees validated inode buffers.
> >
> > That assumption does not always hold for JBD-managed buffers. The commo=
n
> > inode read path can still hand suballoc code an invalid dinode, which t=
urns
> > crafted filesystem corruption into a kernel panic instead of a normal O=
CFS2
> > filesystem error.
> >
>
> When inode first read from disk, it will call ocfs2_validate_inode_block(=
)
> to validate if it is valid.
> So it seems this is a code bug once the buffer is modified? Or how it
> happens?
>
> Thanks,
> Joseph

This bug was discovered by our fuzzing framework. The fuzzer mutates
filesystem metadata on disk to test filesystem robustness, but it does
not modify in-memory state.

Due to an unknown issue, the full crash log was truncated, so we
currently cannot deterministically reproduce the bug. We are still
working on reconstructing a reliable reproducer based on partial
traces.

From our current analysis, one possible explanation is that the
initial inode validation does not guarantee the buffer remains valid
for its entire lifetime:

On mount, OCFS2 loads local system inodes before journal replay, so
the allocator inode can be instantiated and validated first.
Afterwards, dirty journal replay writes filesystem blocks back through
jbd2 recovery using __getblk(j_fs_dev, blocknr) + memcpy(nbh->b_data,
...) + mark_buffer_dirty(), which can overwrite the same cached bh
that was previously validated.

Later, OCFS2 rereads inode blocks through ocfs2_inode_lock paths, and
those read paths explicitly skip inode validation when buffer_jbd(bh)
is set. This is visible both in ocfs2_read_blocks_sync() and
ocfs2_read_blocks(), and the latter even documents that journal-held
buffers never get NeedsValidate set.

Normal allocator updates make these dinode buffers JBD-managed via
ocfs2_journal_access_di() -> jbd2_journal_get_write_access() ->
set_buffer_jbd(bh). So the bug is not that the very first read forgot
to validate; it is that a previously validated system-inode bh can be
changed later, and subsequent JBD-owned rereads bypass validation
before reaching the BUG_ON in suballoc.

So the issue does not appear to be that the initial validation is
missing, but rather that a previously validated buffer can be modified
later (e.g., by journal replay), and subsequent accesses bypass
validation due to JBD state.

We are still investigating and will update if we manage to produce a
reliable reproducer.

Thanks,
ZhengYuan Huang
