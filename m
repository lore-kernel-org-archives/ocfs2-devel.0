Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B192266576
	for <ocfs2-devel@lists.linux.dev>; Thu, 20 Nov 2025 01:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763602606; cv=none; b=QcM+w/Mj8ADLT5/LXwbK8ktp8f9ykj5tTxJYN3RQ3g1WAqSwRYLTvGtzdhIY8rS18BOUcxir88QmouS+SUczBrpqsvv+bffIhXFqzd364MzZKXCqE4SbFMrVfKuEG7doNmcOyqgJgzRUra9feDFg61wrRXo77iLUZs0nMubITZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763602606; c=relaxed/simple;
	bh=HMXhcDQ9wd2PNO/JQKveVwAFfo1U1cBXobg2gRA748g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PDcwKih/XvIxijAzzQXYLkEWuKwSdxEiALWevHeBhGIYYZq00s28J1vDOsYWqPJbMhsQYOD4lMxW/vAGZ01U0AddHqXxY3vkP79TnfoZr01Dm1b/Ahz1mBhpvmcnshPKVuRWec1HORBHwoPMs11ydDmVMxDoU8aw6vBuztZXsMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b0PBd4Dr; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b0PBd4Dr"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-787da30c53dso3449097b3.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 19 Nov 2025 17:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763602604; x=1764207404; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HMXhcDQ9wd2PNO/JQKveVwAFfo1U1cBXobg2gRA748g=;
        b=b0PBd4Drp6a2IsKfusx2LyEhUeFgkN+8CEmGn7F3boW+KbENH34+JW6rzFY8WOGY/a
         M421INlu85DlzjtKF8e9e9p5XBZLgscAuDMBUgNjnWrQzf7FJfmNNvVmahpE0oOOJsL7
         Y83oAnwRHYiWl/x7kFlpoBZHy8PVO2+IbPaqpNtajRc3SPA35+Hs1cTNNqYhfvU0ihPL
         f1e3wNAjbor9w+5UYABztRf2bEclXUP5McRcihatMg3Tg/ukp4wZJVNTGGfyf8jlf3hu
         +ISvF2/VSwYfkQq0OhIDopKrXykH5lVRf0MxbFZag1dtCdFcV/lZyt+ZIe086h+Qz27A
         LnwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763602604; x=1764207404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HMXhcDQ9wd2PNO/JQKveVwAFfo1U1cBXobg2gRA748g=;
        b=jH8S+r1JhOmPvyHXLitwhDENWzZIaHiAa9bOoasaAzjHoxzxy+rGylavvNmsY/fJgo
         upK9yKt9OvffSPHy5rAC/zsKDCkNR4VnK6bidWqKkz5a/kKrVaI+jcDyQY9bRpEr5hu3
         T7s+eoACVXJWx6Y8uxfYJGYHdDG31S8f5xV8G0NEWUCoQGffK80OdLk1HD9Du74G6HHo
         LxxNU++Z5vm5rHERxoX7PgsooK3747qX97lHOZ/Mcl4b5zA9ZbB6+FqEFhY5uImnCX+/
         nZkNM1ZSLC7RGrqkzSnkJ2CLFv09M5qx07cB7YCeb7NuabvO32gGgv/coxAf9WbAqr6K
         LUiA==
X-Forwarded-Encrypted: i=1; AJvYcCUWba/N4C8vRdZS5L9nxr/wVALxoa+Nmg/FPbN+FQ1/uQ1GXG3w3gzVC7/uoN8mQ9HTzJzXZECUKRGs/g==@lists.linux.dev
X-Gm-Message-State: AOJu0YwR849v/MliThenvdCvpy1TMlNNJaN3AJjWhJjSsmcVCk+MC2NE
	rvI4N96h+vjhFTyTb2fBg6Dm8ksebZGoYt3himpWrqWyudW2xsn+huc4PDpZka07Cw7ZfucV1fl
	q5XnJHZvDPKLWRJL/crd9O6sRwqUh9kk=
X-Gm-Gg: ASbGnct/QWw9jdRtQSAkAsy27H73JHlw7sX1JadCO07yl4fRk72VlKKTzwWw6ro+sp7
	ymDSsI+Rpam9EgtiB2cvS+cEw/z5s10Liw7g6AIdATaqSwAuAekSp6Wnz9r4B2ycsJhZQWjR+Xm
	qaQeNqF4ZVgx2QThmI9MnGCVf9pWjwCT2paxBCL0rxSJiN1HSLMfumBV9KcbWdNxdmJOGYH5tzM
	KyZ/iPMr4BuTgyA2H7dwhbV4aypT/6CFO3X5cn81QpW/splAkcDWpTX0D3dPfoENzAp1NepnYSU
	5zm4J054ba9wjahaMW3wskRk5IB2EhT8M08w393RYTxYEV8m2g==
X-Google-Smtp-Source: AGHT+IHEU3DTSQUfAb7Aqplfk/Gm+4VSr6mIghdCWeiY9KmI6r3u7ZI6l7tNw0sFonsJZG3cBFHtEEpdtQCQpEr69qI=
X-Received: by 2002:a05:690c:6d12:b0:786:98d8:c1c7 with SMTP id
 00721157ae682-78a7ab5e60dmr7424527b3.18.1763602604149; Wed, 19 Nov 2025
 17:36:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251117114224.12948-1-kartikey406@gmail.com> <ef22zw37ifljwla5ifbtrgjrx35gnifqi5lcaxfgabaeydbmco@zbc2eulbbmea>
In-Reply-To: <ef22zw37ifljwla5ifbtrgjrx35gnifqi5lcaxfgabaeydbmco@zbc2eulbbmea>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Thu, 20 Nov 2025 07:06:31 +0530
X-Gm-Features: AWmQ_bkMTO4ZpX2-dBR81Deo2Jf9oF0zm4IHcwPFylG6so_kOnPAA-hdO0-EGS0
Message-ID: <CADhLXY5hPspTaBkXPn1ibZrzRnkbQUqH7Du4BzutbBZU=e99aQ@mail.gmail.com>
Subject: Re: [PATCH v3] ocfs2: validate inline xattr size and entry count in ocfs2_xattr_ibody_list
To: Heming Zhao <heming.zhao@suse.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2025 at 9:06=E2=80=AFPM Heming Zhao <heming.zhao@suse.com> =
wrote:

> The following patch code is LGTM, but I can't understand the meaning of a=
bove
> xh_cont:20041. Please show more details for the value 20041.

The value 20041 is the actual corrupted xh_count from the syzbot
reproducer's filesystem image.

> In my view,
> the sizeof(struct ocfs2_xattr_header) is 16 (by: 2+2+2+2+(4+2+2)+0)
> the sizeof(struct ocfs2_xattr_entry) is 16 (by: 4+2+1+1+8).
> when the inline_size is 256.
> the max number of entries for inline mode: (256-16) / 16 =3D 15.
> therefore, the xh_count of 22 (by: 15+7) corresponds to a value that is 7
> entries beyond the boundary.

You're absolutely right! I made an error in my commit message - the
max is 15 entries, not 7.
I'll send v4 with the corrected example using xh_count of 22 as you
suggested, which is clearer than the raw syzbot value of 20041.

Thanks for catching this!

Deepanshu
