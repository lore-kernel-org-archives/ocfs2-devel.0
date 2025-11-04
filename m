Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EF128BAAC
	for <ocfs2-devel@lists.linux.dev>; Tue,  4 Nov 2025 22:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762295477; cv=none; b=ri8nsnwJg913mDXgMqIofc0vVguoudsJO8OYCiJqX+Rv+N9GJHiRQyIGwafLEbM4gCd7tl4E9LZlLQ7mCJLwbohHti4Dl8EhzvWMqGYXCBHHRj1v/Uu+SCBMPmYLTJQs4+5jx2ePEsDAELWBhls09wSgt7OYiKZyj0mxgd4LlCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762295477; c=relaxed/simple;
	bh=qlbJi6CQT+n1/uVC5NZZQC6Ch1uElRomX6k6JiAkjB8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pbxwafqoeGUEauvlKXE7s0fyYbcyZHl+RVzXk0inzTIQkezqC1qMMnwA+OPQnA2iRgY/XZ021v4nk/EVIlETnkIgZTTYBRtwPtoG+DJxu0MPgFc2A4xne/dh2EOejmJlEQKs3wpQ+sB/ek8LReqpqR2HE4i6er0Z21gZ/Sj35R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hPtqQhWT; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hPtqQhWT"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-640b06fa959so5108896a12.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 04 Nov 2025 14:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762295473; x=1762900273; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9C5WZt85rCvQ7iKyht7ngDQOKVzbs+0o0ZE9snmn2Ws=;
        b=hPtqQhWTHKw9q0Sdtvy4r03+2IquWLVbXq59g0h5MVDcjxmjrV8fH2wm+tiCoShb2e
         OpavlHgqs2Fp/0Zva/5Xm/sQcDpu35lGy/lNZ698hNvAcRX5gqpoObvJBJQhs61UT2+1
         Q6KgpRinQkwFHEONNeqVYERrFBk2nbVEyr6sNGUZ70mNgVlhiFnJbXrOnbNuH7fCn5ht
         Ncc+5aurPyMmUf/v0XeWFel2IEfVAN0+4V87cVmDrk81T2Wg+Xjxm5nyc5EBTdgmeBfx
         GObxv2uL9uG9jGHqsPwSKJzyq6azNxkXfJOvBl5FaTSFKnOhfFIUCnJxvcYUWgj6ssID
         Vr0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762295473; x=1762900273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9C5WZt85rCvQ7iKyht7ngDQOKVzbs+0o0ZE9snmn2Ws=;
        b=fBLm8qYyyqlgrod6U2pmPpHOi+Q6eUvxl+krITwfCo2l18UvBqY8JJeVM/LTFsHGI+
         fTD/ptlXIXNd+Ncl1thWwoFR37s1L5cjzBxYx2LbvzJCcKC18goCtUH2+cxTtIWtV1od
         XM4GLMqrZoM8v5LJ50npNybuv5bsX086Umo2MKWKNKPnVeFz7bQVu2OCP54gRUSYYk1j
         A6fdEFlH6q4gAAkPM8n7ewc7prceXYN/o0AsWL2qhjePEGNUeBtq6S84Z/3nKWnRsoTJ
         3fTXBqp/bu2yJOP/lX2vil09nXJQYPmmqGyKl3Qc7pM5PbnChssy1i7oUCBjbSsfzQJf
         uu2A==
X-Gm-Message-State: AOJu0Yy/fI15u2rJw5atrn0xAYCZZ8g69rpT8cYKp94r6OcqGnLNU3CH
	txScqsm65uyeZ9mJOCGdikdjfq3rn/buBUaZcidX+/NwQIS6Hwde4Ve7gnmhQMuK2ZofxeFkQyG
	oE5UPpSj/O17B6rx0sI0dvzaTc/PaOJFRDSb4ML4=
X-Gm-Gg: ASbGncsUKSgHQUQLkqArw847h77L/6IXwrITliOjwG9zctPv35P/8ia9e8q5HeSW33e
	bOlmi5ufkdPTFk/qMM7PcJps7KjD8ittVDYM30C2+jttS3eRQ619AudCHvt7W133tzoCiTI+IXk
	jePayOFunGClB8qaaHIgBadwmVCcqXbp4D9wIvZ6NUe+vAuAMPGPPltkqL9ldCPznDIvGcINrGT
	/MFJ3a9dqAsw70UEGIWMgjQoCP/CXRag4mbHXAgjCpvxtwOqeA3Sc72XvxP1dPCIowYI+fEVsjM
	cFvaNOfMEhVNSg0OB5T8L5+fHuc=
X-Google-Smtp-Source: AGHT+IGkfz+qjDL3k+h5Laf2ETyxJ3mO3I0sjY2eJBKDI86RPmEM4cuOT83qYE1w0rrQkzVZmnhlgLzsRzWS+8AcLAc=
X-Received: by 2002:a05:6402:280c:b0:637:e94a:fb56 with SMTP id
 4fb4d7f45d1cf-64105b7a5famr781421a12.35.1762295473353; Tue, 04 Nov 2025
 14:31:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251029225748.11361-2-eraykrdg1@gmail.com> <wzykonhpj76qowdn24inwtaji4zfclesmc3lqnnc7cn6jkyjl4@oauagnarupov>
 <CAHxJ8O_7-PfJRyGp9-1KOkwmYJWQDzCvvo_P-jxzbzHoqXyH9Q@mail.gmail.com>
 <qfizhbe5rwzddwnoekr6xjy3gozbqbtl64c5xmfeuudxvficmv@onazesxv4ur6>
 <aQQ0DLqL0iVN7D15@arch-box> <leys5guzkcvlilaccjmsw7cvncm6o2vqo2wwezhuz7r6lcfjnk@va3cnphl4zf3>
 <aQS_oUDXGt_nF__d@arch-box> <stmj7kbqis2idlscf5iwch23ft2azuyyr7q2kmelavjk5lnug4@66in667d6bym>
 <aQTGFvVX22RmDhb0@arch-box>
In-Reply-To: <aQTGFvVX22RmDhb0@arch-box>
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Date: Wed, 5 Nov 2025 01:31:01 +0300
X-Gm-Features: AWmQ_blkF6ejm-czi2Y2XOMbxdhh-bOt3sr0JARj8POY-hJwKrtKgmSpVDXLl_E
Message-ID: <CAHxJ8O9Yci6QzGckrsWhuoDHatYyOOok++ySmYc43WbEhFy3xg@mail.gmail.com>
Subject: Re: [RFC RFT PATCH] ocfs2: Mark inode bad upon validation failure
 during read
To: ocfs2-devel@lists.linux.dev
Cc: Albin Babu Varghese <albinbabuvarghese20@gmail.com>, mark@fasheh.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, 
	Heming Zhao <heming.zhao@suse.com>, david.hunter.linux@gmail.com, 
	skhan@linuxfoundation.org, 
	syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi folks,

I'm having some trouble getting xfstests-dev set up to test some ocfs2
changes. I can't seem to get the configuration working correctly to run
the ocfs2 test group.

Could anyone share some insights or pointers on the proper setup? Any
help would be much appreciated.

Cheers,
Ahmet Eray

Albin Babu Varghese <albinbabuvarghese20@gmail.com>, 31 Eki 2025 Cum,
17:22 tarihinde =C5=9Funu yazd=C4=B1:
>
> > > > I support adding make_bad_inode() in ocfs2_read_inode_block_full().
> > > > ocfs2_read_locked_inode() calls ocfs2_read_inode_block[_full] to re=
ad the inode
> > > > from disk. However, ocfs2_read_inode_block[_full] have many callers=
, and in
> > > > current code, only ocfs2_read_locked_inode() marks the inode as bad=
. All others
> > > > forget to set the bad_inode.
> > > >
> > > > The 'forbid' write operations when read-only mode is worth another =
patch, and
> > > > I plan to create this patch. This patch adds a similar ext4_emergen=
cy_state()
> > > > function for ocfs2.
> > >
> > > We're working on this as part of the Linux Kernel Mentorship Program,=
 and we'd
> > > love to take on implementing the read-only check if it's not overly
> > > complicated. We're just beginners, but we thought it would be a great=
 learning
> > > experience to work on this following the ext4 pattern you mentioned -=
 if you
> > > haven't already started working on it by the time you see this reply.
> >
> > I haven't started the patch job, you are welcome to take it.
>
> Thank you! We'll work on it and send the patch for review.
>
> Cheers,
>         Albin
