Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33159296BA4
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 23:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765581501; cv=none; b=sucfnih1qJq3xj7LX25p+WRBjlLYa+1vXltsGFe/CzhZfSWmcAn3Lz05OLyaPeMaQi5mKp+463fAMhybXg4LAFrRTa+7joTcne3t+sBHj3sq46jSajQwEf99UmGSF20VI2CI4B0Yt8rCmZKmLQ6WJat7ZW5WOFomYasQFm+IjR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765581501; c=relaxed/simple;
	bh=tKl/sVYKIc83LSrOCLSVo7s+3IH5y45pwC+1rYy0yJA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xy9IcuIIdGpyfKTR0GApVpEVU2skpn+jvQ9QP4L+Wl2k7FCCzCbK4tKsbSrhOREF/No0Q27CDyHgvAaBJ/aEMLGI3JawZ8zXdWQJTZ39jvl2XJLQmDMUgjk8D99iojokUF+ImKoUohyiSfktmoLpDWb8vwegcYCGECTk9frvweE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fasheh.com; spf=none smtp.mailfrom=fasheh.com; dkim=pass (2048-bit key) header.d=fasheh.com header.i=@fasheh.com header.b=UkcwY+0y; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fasheh.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fasheh.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fasheh.com header.i=@fasheh.com header.b="UkcwY+0y"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4f1aecac2c9so19022391cf.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 15:18:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fasheh.com; s=google; t=1765581497; x=1766186297; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tKl/sVYKIc83LSrOCLSVo7s+3IH5y45pwC+1rYy0yJA=;
        b=UkcwY+0yeF8js4OPS4ZnpkYQqblQqEqn6z8SYzfeg3P7lQTRy8wBvaN2c/swfed1Kr
         pR0H3Zk70Ju5p41PTP+5GUDnVowTqT0SPXSA1r+10Q2BKUOciSVoYD9R2pjlS3HNKZlV
         hlUy3tl3r8POp+48UJHF7Fg3cpPHm+dJEjvNHyM+zBAZuI8MYXgEQgBlu7UNAwzHgnGY
         1QVIZwa+HKcIZQ+bBecNHHVQquFIuCHRzePwLAy7iDOGqc3jl0hi7sm58H7jvZ4AuoEF
         +8dyVtPQbldeGcZbbaV+lTQvS+L6T740DucOeUlmSz7R9Rxr+KqIoOpzgk8NpA3kHpev
         qo+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765581497; x=1766186297;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tKl/sVYKIc83LSrOCLSVo7s+3IH5y45pwC+1rYy0yJA=;
        b=fCC7gN9O5v3IaawSYYvyoPOP8820KSPEWq/lJCbNEYdDTIyjDQiZnowETjkMVLqnZu
         nxF8p4ykdXamORYFnFUzbH2/r71f/QVv2lTZ2+hvsGdrIIa++6ee3LkoTQMgLlCAC5xi
         GkbguagWCTqrsKLuCut5aerj+XH3tgYZW0jxI4AE/KEWliLAIeBbqMv+OqiM9otrIBYz
         sL23SLG+2pXoKB9oAdVcqt5z23P/fBe7YSymXfG1G5WNVeN+SqrWwYyBjssqrPwnM8Sk
         n3Njs2UbHf18QdSiCleLRtruENlcOf9nsuPTweXxykHBMAzYK4+9Zu7QecX0pCRJNO7J
         fLEw==
X-Forwarded-Encrypted: i=1; AJvYcCXihMOLhb21FH5YVZkLmGcQ8gRMA4THULQJfxxlbEUrYNE68RNWxQmLHgzuw+PKmI3FK4o/o8z6PQ3LfA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyxpSPCY7JIk8qWLIOFMYJ5O5a/VgJgaWUreom2rB4HrjpLH+Bw
	8DPhh2rIPYgnSm8v9WANLUvC+/piqJQk8VKFIpGhxSLl8f3fQ0gYEDV/xRKsima2ns959OFWjPO
	QO6JiQVoeFWjH27dIOCUgYl9kSFm7NtKtvcMjRuU60Q==
X-Gm-Gg: AY/fxX4wiT3v3B7q89BcPf0LoLsBBjDktiN8CRmlJ4KKG0a7gKTgn3b8FxJnitbxV7u
	1XmaIWZSEV6BUbsDiMbaXjexaT9Ey22Ypaah7dZsz/v5a3kMn5VATLGvwkT5EW4B6NrNoLiX3lH
	zPPBvxN0m1LL1lPeVsuZECWmmhtFCQ0P5pj9SHGFQ3kcE/J0/hNGqdwT7sy3nCNlLvRy3W/UbXz
	TNmhBA5PI7IAD7MwYDylNoR1xVvrNYEc8gUJen19iBwWD9nuVADB/Ln//WIaXL2FVDf16KpbtL/
	5vbVeTJ1LJb0HRK3vxhbmJqIYmQf
X-Google-Smtp-Source: AGHT+IFPR02hNpJissvoKNCvcuwELE6c3P8Y7ZsWMkvd5nTd/A78pOB1xN8IBcCVCPPVHFBjx2uRhauo3zaIKWbrF2Q=
X-Received: by 2002:a05:622a:50f:b0:4ee:12e6:dc73 with SMTP id
 d75a77b69052e-4f1bfc359c5mr114046891cf.20.1765581497129; Fri, 12 Dec 2025
 15:18:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251212190631.210139-1-swarajgaikwad1925@gmail.com>
In-Reply-To: <20251212190631.210139-1-swarajgaikwad1925@gmail.com>
From: Mark Fasheh <mark@fasheh.com>
Date: Fri, 12 Dec 2025 15:18:06 -0800
X-Gm-Features: AQt7F2r52sHuy_7XqniANYHfN44uoWN5JGv-1U7f2hMtbKAje0UXursg3mdf3Lc
Message-ID: <CAGe7X7nY5iFFNmV5VT5Mji-vknFgi-cGeJYn6U7z5HcnCr=mBA@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: fix xattr array out-of-bounds in ocfs2_xa_remove_entry()
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	"open list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)" <ocfs2-devel@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL HARDENING (not covered by other areas):Keyword:b__counted_by(_le|_be)?b" <linux-hardening@vger.kernel.org>, skhan@linuxfoundation.org, 
	david.hunter.linux@gmail.com, 
	syzbot+cf96bc82a588a27346a8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 12, 2025 at 5:36=E2=80=AFAM Swaraj Gaikwad
<swarajgaikwad1925@gmail.com> wrote:
>
> Syzkaller reported an out-of-bounds access in ocfs2_xa_remove_entry(),
> triggered when removing an xattr entry.
>
> The root cause is that the original code decrements xh_count in-place usi=
ng
> le16_add_cpu() before reading the updated count value into a local variab=
le.
> However, due to the way the entry removal logic interacts with the array =
bounds
> checking (enforced by __counted_by(xh_count)), the stale count during sub=
sequent
> operations leads to the out-of-bounds access during the removal process.
> This patch fixes the issue by reading the current count first, computing =
the
> decremented value locally, and then explicitly writing the updated count =
back to
> xh_count at the end of the function. This ensures the array bounds are co=
rrectly
> reflected throughout the entry removal without relying on in-place modifi=
cation
> timing.
>
> The fix has been tested by reproducing the syzkaller crash report, which =
no longer
> triggers after applying the patch.
>
> Reported-by: syzbot+cf96bc82a588a27346a8@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com./bug?extid=3Dcf96bc82a588a27346a8
> Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>

Reviewed-by: Mark Fasheh <mark@fasheh.com>
