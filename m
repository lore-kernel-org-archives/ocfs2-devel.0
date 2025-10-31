Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B619D18626
	for <ocfs2-devel@lists.linux.dev>; Fri, 31 Oct 2025 14:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761920540; cv=none; b=Zdqb2n+sRAkTCmzTgYPAZhEO+kqv/DZgGHCUqYTsSSd/0mfqx43QN4T5Nscu3kQjKix/CqoYP7jtmgbfdns83VuY3Qss3FvszOa1fF5JPGXBBSq3Rh1lA41DnR2Siyjcs+3RIwG/n1wo/dN7alKRqEqFVFIgwG7SO4ZAQ2yyQmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761920540; c=relaxed/simple;
	bh=U/JnwHocTOv3DE1OsEmzLByYGz+pJaHHFL1XoiTiHWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y4y+cSu5t/LQCrhATIWPoFZiy+rP4JlyBBlCcwB2/xcq7lofLGQlBvSzNcP6qQL/fKwu/hD6kMIijIgCdST3HRy47xrGYo/MLJOzdxrjf4zzhMCKym4JFTyAK0o5NHDwNWt2PFv+8T+aE1JBerV4xK2zAL9OiIFM3MHetwjQpdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=imRTzLDO; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="imRTzLDO"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4e8850b09eeso21241911cf.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 31 Oct 2025 07:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761920537; x=1762525337; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HmvHznY30SKNic0c8rWZfpNF8gg00p8bPWt2eYJyfec=;
        b=imRTzLDOHmQzlFsbuiPDZ87CltALUkNsYbmReanK5+aKj6UgsW9lZtUq5s/jAeUhFI
         +fpekpU6XpWxG+S8+hDStWgPQUrlLPpaMeYsc+muB14nB17Vs6JwQg523S/s5YHY9p31
         Ls5OrH6+gB6xdKu97RvwE9MA1mlsLaIA4P3/JBDE2rBPWRgzZ38KukLAbXdvgW7Dxonh
         +bFZveW8ipqj6UNMZCC+5j+PgJdPPpYGrV5UxyMXvAYTHXaY6C8PjapUorpQnJt9NtqQ
         2kQCJJtTyR2DgF5Y/+VgRPRt6VhzICYfvLbW2vFMWgmw98KwDVtbphJ36zLY0TJWNtYm
         +bIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761920537; x=1762525337;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HmvHznY30SKNic0c8rWZfpNF8gg00p8bPWt2eYJyfec=;
        b=RSvONDAFsu6pLMUx0bKBNXyJv7kZ2g+XcbTHR3W+b7X90KkmFRKypG0XIlU4UJzviz
         ApMhSFCbmzdzH2t/VCxF8zCuCQPh46YviG7fsfrvlZFAdbf7+lkJJqnN/2iE8VVUF+R1
         b5tsz4Ex9BFDnc2s8tIftL4isAwYCzpgfB+hpUsBYs2v+OYoxJ6nI3K8YTBbGkQ+xIQO
         fAunIDKZdTFWmqgpBiugmwDcmkfnfZ2oyfuoecqHyEjGQClzfPBr1H6E1AO+Jx4OX9vC
         iEpbF+1paZqS8OPhZp8ckzcZ1uxbyp04u4n1PCzHKN6SABFZpdbi/4KOMqqj/EQc3VtT
         A6AQ==
X-Forwarded-Encrypted: i=1; AJvYcCWN9NexbFFPS3oe2Qa2mFd5l5ppZba3YtsR9hHCbxA3DkBQz5DbPmX2o9UAwoMCVUs3LJmWWcTkU8rrmQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwOGmJXYT/+QgmpkxFVyJf/I5Wfl/1pi7gm4kmWy2esm8u3tTtA
	f+1604x9fEkqoSDYuioZl7+ZD1bU88zTxiOx/I0nrLgy/Z3qEnccxiK4
X-Gm-Gg: ASbGnctz/aOqbcmbMsmwqpxOwv6GTiMIcTYKvKpflKBrqecmZBKmPXKTkoBSfjakXuE
	2PzT966qHTe3DRD5MRa6JIHpfPBftBPcxktaxaFsxpJpti9k5N2DU148bfuUxp2gtq7y9txljkw
	MoV1Rt2IljDE9MNgi+WTymmRtlM/MXjv+XO16wBCEJy2TRqMYEKIwtJo6hd2F7aYQUmSKE8X0P3
	bkM+B4YwH6pmHWRXrgQqUlHd6hxUoKfmj9Q2W61OA+WDsiH9kJGQIlEDs7iiq6NDvho8G2zLec6
	7GPSSrALk3J4Gas1LAy5H5Z8MMjnc94m3ZQw2SQL42isVpqtb1LTKjLxcHeaLsPdlNyYrgdytEQ
	9HSwrBwhqv2vzSeC4qsNLUbCyWh8jtqBMjpWJLwQ0Za7e/INEjd4/U0BuePPzIoDw2Kq+AJk=
X-Google-Smtp-Source: AGHT+IGHtm/+hhl7f5mUMjQi2hNOc2hOPb+Jd0XRa+ulUtHaxufSgtRvl924/sYMVKbMfvjfNf8rFQ==
X-Received: by 2002:a05:622a:2307:b0:4ec:ee66:166b with SMTP id d75a77b69052e-4ed31001a6dmr41523111cf.57.1761920537330;
        Fri, 31 Oct 2025 07:22:17 -0700 (PDT)
Received: from arch-box ([2607:fea8:54de:2200::c98d])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ed35354982sm11212601cf.34.2025.10.31.07.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 07:22:16 -0700 (PDT)
Date: Fri, 31 Oct 2025 10:22:14 -0400
From: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
To: Heming Zhao <heming.zhao@suse.com>
Cc: Ahmet Eray Karadag <eraykrdg1@gmail.com>, mark@fasheh.com,
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com, skhan@linuxfoundation.org,
	syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com
Subject: Re: [RFC RFT PATCH] ocfs2: Mark inode bad upon validation failure
 during read
Message-ID: <aQTGFvVX22RmDhb0@arch-box>
References: <20251029225748.11361-2-eraykrdg1@gmail.com>
 <wzykonhpj76qowdn24inwtaji4zfclesmc3lqnnc7cn6jkyjl4@oauagnarupov>
 <CAHxJ8O_7-PfJRyGp9-1KOkwmYJWQDzCvvo_P-jxzbzHoqXyH9Q@mail.gmail.com>
 <qfizhbe5rwzddwnoekr6xjy3gozbqbtl64c5xmfeuudxvficmv@onazesxv4ur6>
 <aQQ0DLqL0iVN7D15@arch-box>
 <leys5guzkcvlilaccjmsw7cvncm6o2vqo2wwezhuz7r6lcfjnk@va3cnphl4zf3>
 <aQS_oUDXGt_nF__d@arch-box>
 <stmj7kbqis2idlscf5iwch23ft2azuyyr7q2kmelavjk5lnug4@66in667d6bym>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <stmj7kbqis2idlscf5iwch23ft2azuyyr7q2kmelavjk5lnug4@66in667d6bym>

> > > I support adding make_bad_inode() in ocfs2_read_inode_block_full().
> > > ocfs2_read_locked_inode() calls ocfs2_read_inode_block[_full] to read the inode
> > > from disk. However, ocfs2_read_inode_block[_full] have many callers, and in
> > > current code, only ocfs2_read_locked_inode() marks the inode as bad. All others
> > > forget to set the bad_inode.
> > > 
> > > The 'forbid' write operations when read-only mode is worth another patch, and
> > > I plan to create this patch. This patch adds a similar ext4_emergency_state()
> > > function for ocfs2.
> > 
> > We're working on this as part of the Linux Kernel Mentorship Program, and we'd
> > love to take on implementing the read-only check if it's not overly
> > complicated. We're just beginners, but we thought it would be a great learning
> > experience to work on this following the ext4 pattern you mentioned - if you
> > haven't already started working on it by the time you see this reply.
> 
> I haven't started the patch job, you are welcome to take it.

Thank you! We'll work on it and send the patch for review.

Cheers,
	Albin
