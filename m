Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B2C1A8F98
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Jan 2025 03:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735875054; cv=none; b=Lxhzwwh/+wukM73n4EIuCgzxa2eHaMiMZz+Sm1tvPg6D56BT8oiBftMn72hl2yi7ammHgRNJhHUW4ivWgv14z/lSL79FNJ1gK8p8x3pX6p45B6/K/Q3ejT5x7ISpLGOXCUHp+pZoZqzoqJoMdVyAbU0+niMXklUhVJrL5LnHhKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735875054; c=relaxed/simple;
	bh=5AJEQozojgPgZAmY3ME1ymxgIYA2p6xXoB9+eOT3n1Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HzyV+1lhF0/w3CIDWF8HDkBal9nD5SWjlkNB+zxdnK17AJx6KhxXLtYDwafNa18wT/x0cBdFMjfgPy/js7+1fG4k7bVKnHggSAt5Tk0sh0po7GHQHohYZuT0brYHkhSypbA8fdJP3aGwuixjOuJZrA14TK0o6FaVx0Lgm3UfEO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BJavpKjj; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BJavpKjj"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2ffd6af012eso165308281fa.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Jan 2025 19:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735875050; x=1736479850; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5AJEQozojgPgZAmY3ME1ymxgIYA2p6xXoB9+eOT3n1Y=;
        b=BJavpKjjqOCaMzfs+SktMPJT+lyXd1Ukd46BZFIV251D2WJDePkXNE+gBVI7Jft1on
         0aKN0Y6MVwRv9mOdVuOryBlU6a/QNykgJjGYIFPk7dt49E5dH6ozVrXAuwhxEcGVegfy
         YJwIVQQ4/qfh2tPw6HPtYYibF8eYjqmcpRcquGqEz+2FsRCWFlb5PotbrdeoZgupLII0
         dRmXRsGm3WXNvsujQcFSOaj40uKdZfWlLUqA+/Bi4wJeZMqXF0H6FWiPt/IyuTdaHnOF
         Gu6owSmuez4onNyDZhuVPdiFxm7W9T1Pyw6jEmTsbumFPN66kZjQsPWoODNnM0/wrcpi
         sAxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735875050; x=1736479850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5AJEQozojgPgZAmY3ME1ymxgIYA2p6xXoB9+eOT3n1Y=;
        b=TPjo0fEYucU/uxCghFwqqWGQmccDDBQD1ZUE7R2TlaBE3/3V81n81etQncUarkfFN1
         yKBpTVpz2DEqzdYS6Tzb88MGCEe/zUlZKZoimJJ32BXJ7QQabzmPN63VHs5iWFVpnzFl
         jhFYRYL0vlgQfhPJt+dqhP3qhaWChKrHB7F7nxEFKjivGitk7nQ7TZoXQBGOwA36iPzo
         EFprDS7hRvWoj2IIWI/C65cBV2Qhs479AY93hrVoO1B/kSy2YAzS1coNRJslqG8D2wzV
         nZ2ruroV+/6AtBmntFeEqdTn+nefiklnb+rCurnsI8X/CZo9TMnx4tU6R4xVyt8cDtDX
         MIGA==
X-Forwarded-Encrypted: i=1; AJvYcCUghfqVdITQZG9oKdNgNCC432iDqvcqccKvbZpacOaP2AdDbaUZ1vBP98BaLL4ohfwpkdjovUTst7FOuQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzu0r2PN6icRjGoKkBad4r89i1KsbJqMrsZwmlFF64OMQvFWTrb
	BevwJ5xv7VP42SfAFFuWKOWrQvH7+zdgHdb+kp441VXsZ4hMkRDIn50JiliKxUDwWtg7v+tJtgT
	IbXQuY1ebziNItuRk1stH3WbTdnw=
X-Gm-Gg: ASbGncuChv2a7o0aHIo/39ItMe3STqbGREnHFulTPzHe+Q6yM9NcheQJiqkZw50+I/u
	apsquRCLbtIuOHOl/Sw6cUsr1cgME9npUz5zR5W+A
X-Google-Smtp-Source: AGHT+IED5jo4nC6Hy4YPK08XDqeYYAx8CIbXxw7D/pD3KZHBu4NlZHggx9iG2mPgBcpId6HkdN3woBY7BM7VXF/ey/8=
X-Received: by 2002:a05:6512:b11:b0:542:29e5:7321 with SMTP id
 2adb3069b0e04-54229e57405mr13545494e87.10.1735875050124; Thu, 02 Jan 2025
 19:30:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250102124539.711325-1-sunjunchao2870@gmail.com>
 <B8A96D29-146B-403F-8AFC-4098488599EC@suse.com> <73897870-03c6-4a81-a311-b6e1a75957f4@linux.alibaba.com>
In-Reply-To: <73897870-03c6-4a81-a311-b6e1a75957f4@linux.alibaba.com>
From: Julian Sun <sunjunchao2870@gmail.com>
Date: Fri, 3 Jan 2025 11:30:38 +0800
Message-ID: <CAHB1Nahw-ZyiCVPQpSgYtc2VuMFPzQLtCUg+6pbWKH4CHg6FBA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ocfs2: Add a sanity check for corrupted file system.
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Glass Su <glass.su@suse.com>, ocfs2-devel@lists.linux.dev, mark@fasheh.com, 
	jlbec@evilplan.org, syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Joseph Qi <joseph.qi@linux.alibaba.com> =E4=BA=8E2025=E5=B9=B41=E6=9C=883=
=E6=97=A5=E5=91=A8=E4=BA=94 10:48=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> On 2025/1/3 10:15, Glass Su wrote:
> > The subject is too generic. Would you please change it to something lik=
e:
> >
> > "ocfs2: check ocfs2_extent_list::l_next_free_rec in ocfs2_get_clusters_=
nocache=E2=80=9D?
> >
>
> Or simplify to
> ocfs2: check el->l_next_free_rec in ocfs2_get_clusters_nocache

Fixed it in next version, thanks.



--=20
Julian Sun <sunjunchao2870@gmail.com>
