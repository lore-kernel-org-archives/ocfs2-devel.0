Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DB73D4119
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Jan 2026 23:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768951017; cv=pass; b=NXZLkbc2+deoxJjRGo7SlqBlPpgba1bmoSbwWMYtLV0ZGXu4Pn+7437AJGCVnGOHj19/K/CVFgY2qMLt3YuEWoxDJIRlmOJj+wsXIWJEeBUm5UoYWDReTdwfu6KDT6CsQccCzoCeB5MLMUyVndQLgdCOCshvcfsYTAGBsncM3OI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768951017; c=relaxed/simple;
	bh=RF/N8b8SRXZDWb+He6uR0DWSN8niCh0ZC3MjarpCknM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W7C4Hp9T+8duGmVrG8NyVp9ja7T6sLu0fNK5R56p5wmXwS9aGiq0EVUVbMiIoLXVNBJ9O7ueZmCknk4GJJItaI6Jg6Trq/M2DHzto2DsN4imALi4878nEtEcUvGnwLsCFqRNeWF8bK8Xdv38C2cn7Ns/we3xOMUDZ6yXB264OKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q0jF9BIN; arc=pass smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q0jF9BIN"
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-12336c0a8b6so12442086c88.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 20 Jan 2026 15:16:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768951015; cv=none;
        d=google.com; s=arc-20240605;
        b=gKXjMoNmpt34FBPLXl/cdRilGOJYxZQ6d1xg4DAq5lT5Ar+uDD+9urHKpaklZ3q/Vt
         0yLByoB/Udj21WWgTG9d3ML5bzDyu+OEEvSn9iBQEdK4wCNOhBOgRqcVEDdDZHbU1yio
         idtztRfulyMvM2Cidry/T5G7BIfNE5NsUPEAEx4viJiB3Pe0Heb/VH0GYzCr3Tc6w5Cd
         itBGklMfoaBhQnyA71f40kY+SO9LUAaqJleJ8sgnkKo8F9FyXm+KAflQJx7BP1mCdN07
         fFpDycKYUxhtF2HOeiEZy9sU9yC+8kyVuS+dCsU6FFdrKSiGLNScM+fMO1q/7GziWavp
         VFWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=B51LJK40lUQxErxvEoyk2USaJJ7Fw1jG/c/H4mfNiT0=;
        fh=98ecAdnt9r482qLdUI7ZHi+k3k7bvBJYny76lQt6iMo=;
        b=gywwTUQ7yRF3epCotaIqp0xL0gSJqy3py5PxpRGROnf/BLCbFGPvLJjVvydXTuuEog
         4Fv7k2T/Blm24Qxww4zA+qxahOHXX1emd1agWP23Gyold5+OEAiu+APkFxT/4ffKUSCH
         GUbSvnS4CQYXgVIssFDphKhw1SSX1OdO3RjUPMxnNeoxexuJ50kw42U6XGfY15NICO7d
         /HH7eM6UXw3UlongxaCQZj7tR93sP8EJN1QEBmP27UsQReiE8cIj2Dv1H3eTQrJ0fIZ5
         Aer5RId0QkZnuLN+sk9AY7bHVVPT5eCAo/fzNIuv2VhS9EWP8Er/YG4NO8Y1vYDYDRCL
         Oa3A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768951015; x=1769555815; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=B51LJK40lUQxErxvEoyk2USaJJ7Fw1jG/c/H4mfNiT0=;
        b=Q0jF9BINt9Op7Hiw5KsvrbbqPjqNrycesGbt1vT6AxrdxNrbJZ/GxAXVwtxkZgx3+g
         riRhPOXQH3wJW/wsEPLrvEzaV9FRmsgZPaXaS+xBbbvtX2PKvEFkRZGjA2YB+L/a7VPR
         lZEQdZND7F5HQR7AwKQIUzo5178dc2BH1/TBWOzMnXs+wl+toH+xc/c0y+HDyrdqFPGP
         cifq6HFyIm4l5J669Tau3GJDB2OKj6dMh1uBop+unHpBuFqCFOMyDfTLIQlDQnFR7JV7
         0Gu2AwGSIm6rat5/xyCh1YxbLgjjrKjaXST2LZmTpO0QMKDpeUiJc1DgPKSOvjTSYZ04
         IOjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768951015; x=1769555815;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B51LJK40lUQxErxvEoyk2USaJJ7Fw1jG/c/H4mfNiT0=;
        b=ZAYU3ue+oB+gGKicIaUD3kuyfhHGhbWLgcAaMqkIFRy6KJVkOkjhDXPsxkuLQKr9e8
         h0FljK+LLfW9Nx0o/qDzKXjaq23/cB3mNjKDUxlw/jycCf+D7rBb9xNV381kAkzE3tbi
         wZffpqKZJLkVZ+1AZ3uHt0vVVuKAaoFA2ETC1VRFRaVLyOwZNu52Y94E7FAi+aBdNNcC
         GZI9qSwaT4QvByXVngeJd3Thppy36eTYbvLLQ4HVfm8sEICQCN/4jdg+9ZNXZpotAJnF
         UrFWgmqSup5aplydlHzcYIi0VSKDIqpQV1q7x8YsUPeiClHQkovzOzS1o+zMojDowB+3
         mV1A==
X-Gm-Message-State: AOJu0YyeTff9iuzK91aY5XVAKxDO4Gqj20DSBJy2VEst8lYTZt9rTjLS
	WB6YVJePciBDs1mIPVqLlZFMk6k1qQL2H/t/j8gCjxFjp5vTG/vJRehPOmJcVwkCFUV5IdzIq4E
	4V3gOkwDoM8U1OgE38a+uvetvE6QbZLI=
X-Gm-Gg: AY/fxX75xb1cH3iBmSWvjmTyVbvZTgmQfxJpNTMWVUIANZl31m+aShWO9ru5PZMU8WT
	9OfkdE1Ikly/FZ4o2iFA1144aFt8t8YMus8FsD8NdjaFYDktfAO+jV0MYbePjEWrsXLlconXykS
	w804lUT699HUC68QdjQAjgHrvT8Kbu64xuQ9+iY7fyKLDnZJk/CQ9CHqNbvkWwXT9g2pVYbICe8
	w9O4xTgzAMqJgKBLl5+bZgUEykInYjpNFtUFF6mdfjwTd59EKyFJwvfkPEldklHHqxa4w==
X-Received: by 2002:a05:7022:925:b0:119:e569:fba6 with SMTP id
 a92af1059eb24-1244a7195b4mr17069482c88.21.1768951015096; Tue, 20 Jan 2026
 15:16:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251227174251.121668-1-swilczek.lx@gmail.com>
 <1e0dba77-e8a3-43e2-b20c-fbac6fdc928f@linux.alibaba.com> <CAJRoVwh8LUOaFb2OcNtE3Y=LU-tmSGrkOiN43C5SiEunr_coZQ@mail.gmail.com>
 <25d90176-743e-4638-9643-861bd5792eed@linux.alibaba.com> <CAJRoVwgxBKXcMSU-CMH8gC1TLnWFdMHiaFGOyFrkDZqzfpN8Ng@mail.gmail.com>
 <0a2eab22-95ee-4172-9052-aefcbc5bf227@linux.alibaba.com>
In-Reply-To: <0a2eab22-95ee-4172-9052-aefcbc5bf227@linux.alibaba.com>
From: Szymon Wilczek <swilczek.lx@gmail.com>
Date: Wed, 21 Jan 2026 00:16:21 +0100
X-Gm-Features: AZwV_Qgl_ru0u2fj8HVfAwt_Ypr1_jhG5AtJVpzbdHxZbMJcU7DiRyWw3cTi1n4
Message-ID: <CAJRoVwiBkZj1Xor7izsWkFyCK=kXjTmqP+PU4Znz+FORghcAzA@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: fix circular locking dependency in ocfs2_acquire_dquot
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, mark@fasheh.com, jlbec@evilplan.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	syzbot+51244a05705883616c95@syzkaller.appspotmail.com, 
	akpm <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

Hi Joseph,

You are absolutely correct. Since ocfs2_disable_quotas() completes before
ocfs2_shutdown_local_alloc(), these two specific paths likely cannot race
at runtime.

However, the Lockdep report is based on lock classes, not just runtime
concurrency.

1. The shutdown path (ocfs2_shutdown_local_alloc) teaches Lockdep:
   sb_internal -> ocfs2_sysfile_lock_key (on Local Alloc inode)

2. The acquire path (ocfs2_acquire_dquot) teaches Lockdep:
   ocfs2_sysfile_lock_key (on Quota inode) -> sb_internal

Because both inodes use the same lock class (ocfs2_sysfile_lock_key),
Lockdep sees a contradiction:
   sb_internal -> sysfile -> sb_internal

Even if they don't race, this inconsistent ordering is a violation
that Lockdep flags. Fixing the order in acquire_dquot resolves this
contradiction and ensures sb_internal (freeze protection) is always
taken outermost.

Thanks,
Szymon
