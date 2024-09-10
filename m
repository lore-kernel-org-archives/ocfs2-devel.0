Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6721A4F28
	for <ocfs2-devel@lists.linux.dev>; Tue, 10 Sep 2024 17:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725988666; cv=none; b=EBSd+pLuMTrPg3h3twhPP92P7dNkColnnbUi+eWt74SDyPybKLh7WIEqRkiKH5qxuufUAa8q+w5eC1QUoaVFnBfHU4V6DEi5e9tO0rZYZ1Gjp00rzDYUErNX1dHR7GlcMxiqUghb1cVl9b0ZCUPyOMifbJCK4x2xF537+lzkbmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725988666; c=relaxed/simple;
	bh=ZvF+sWnTM7XXftXtVRmmxW+qAces/LZQ2IoKux9c8Ow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d6kKdsPqAVnJkYZMy6Rgl9m6nyj5mPNwpMoO7+vj6Xqvp+SySpZXptYQVLnPpct8bfqwdix8JaPUyjlgkBBPCvqrflS4IHaOZRfG4sVDyagfmr34zc707inYvmDqsF4IQDqBrfV7h8T/Zv/TGxa8LFafd3o71niu8GJdpxGOZSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gvmh8B+n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gvmh8B+n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725988663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eGgCxf/Q+y1w/s/LMKPer1hZ4WwFdSeTvpbBQokgPm0=;
	b=gvmh8B+nCwWoO9MT0Iw+Xx8dDNzTwiMBozVvLN6YTSNL48Lxv8U3OrkQPNn4EPMfzuPp/t
	pxx+orvPsEsW5STYf0wB7+crcSRHXIjCDtPSOwvaJ67fl/Ea6q2I6O0h/eEpbr+IYJD8Ie
	N3JD741zyNFvEcc0TkO1BzM+2S8scG4=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-_Kr5_X7qMbm0QaHIN9xBaA-1; Tue, 10 Sep 2024 13:17:42 -0400
X-MC-Unique: _Kr5_X7qMbm0QaHIN9xBaA-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2f5086e692cso9054481fa.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 10 Sep 2024 10:17:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725988660; x=1726593460;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eGgCxf/Q+y1w/s/LMKPer1hZ4WwFdSeTvpbBQokgPm0=;
        b=s+Eg/XKvatoVKXiyPZSQvmIrMa38m6MuioeRcav1vhhKMjygpV1pwHwCmY2/x302LK
         xGemf226JlCgO/D+PbEia3fquN8bBLXaODyLftyYlDXoK+BBRIq2TZVVAOxDM/9f0xYf
         Np3+lEP813rpAmDZhDi+EpyptBsk36BTR/HW4hwgNomyc0WqGlUYiWunjuYxqHzObKR0
         7YBwvta3AEd4xnS97ksdLKsFsa3z0L30wZ2UG/CqG9BVFqke1G9RJ5NVyiOxsVT6x3UN
         2cuuq2racp+e4gok0o/1bG/irBQSwf1phr6XUP/Hp37CIDcQbzr9uhTA+rCRYpGLZIWU
         Fw1g==
X-Forwarded-Encrypted: i=1; AJvYcCXPVR9VB8qQm2R1KMuWK8Sl46XhZAbbnC7kOvLNrhf+btRxrfvEjgnvoqAQcqEfScP/HYrM8wx0mRFkgQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyamscLCl++4XKDEU6nxLwnUBs+ACm71UPd/w5TmqxBBA8FpBog
	js+Zj7ZDTsf2Y0eziNdUqYJlQcFjeBX+bW+jquoH/lByl3+dWc66BVzoUmc2H8sLz2ISidUvH+f
	ZK20lu5/uEVhuZT+NcKy2aiIMiapl9cMdzpGV2ZyrWIBRkxxFQgoZb/D26tNeMT0hKn805aSIJg
	w1kqJqoBetkecrzCzblkiIWpc6FjAVNh7bDt8=
X-Received: by 2002:a05:651c:2119:b0:2f6:6101:5a6c with SMTP id 38308e7fff4ca-2f77b73af20mr3666651fa.5.1725988660367;
        Tue, 10 Sep 2024 10:17:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJ5wwf1P4KtRYBRtrnbvCydRsYWK4aAdghD56+2z2qYGQDU3a/G1B7LH8ZDXivu9UowC5fW+LytKjCo/XCUNo=
X-Received: by 2002:a05:651c:2119:b0:2f6:6101:5a6c with SMTP id
 38308e7fff4ca-2f77b73af20mr3666341fa.5.1725988659801; Tue, 10 Sep 2024
 10:17:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230823213352.1971009-1-aahringo@redhat.com> <20230823213352.1971009-2-aahringo@redhat.com>
 <B38733D3-6F54-42DF-BD5B-716F0200314F@redhat.com> <1490adc3ae3f82968c6112bb6f9df3c3f2229b04.camel@kernel.org>
 <C158604C-DD07-49C9-8C7B-A9807CD71473@redhat.com>
In-Reply-To: <C158604C-DD07-49C9-8C7B-A9807CD71473@redhat.com>
From: Alexander Aring <aahringo@redhat.com>
Date: Tue, 10 Sep 2024 13:17:28 -0400
Message-ID: <CAK-6q+jtEk-6JCV9qYcsyjne+hTYS7g1w73dHhBRGG1pMAJWGw@mail.gmail.com>
Subject: Re: [PATCH 1/7] lockd: introduce safe async lock op
To: Benjamin Coddington <bcodding@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	teigland@redhat.com, rpeterso@redhat.com, agruenba@redhat.com, 
	trond.myklebust@hammerspace.com, anna@kernel.org, chuck.lever@oracle.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 10, 2024 at 12:56=E2=80=AFPM Benjamin Coddington
<bcodding@redhat.com> wrote:
>
> On 10 Sep 2024, at 11:45, Jeff Layton wrote:
>
> > On Tue, 2024-09-10 at 10:18 -0400, Benjamin Coddington wrote:
> >> On 23 Aug 2023, at 17:33, Alexander Aring wrote:
> >>
> >>> This patch reverts mostly commit 40595cdc93ed ("nfs: block notificati=
on
> >>> on fs with its own ->lock") and introduces an EXPORT_OP_SAFE_ASYNC_LO=
CK
> >>> export flag to signal that the "own ->lock" implementation supports
> >>> async lock requests. The only main user is DLM that is used by GFS2 a=
nd
> >>> OCFS2 filesystem. Those implement their own lock() implementation and
> >>> return FILE_LOCK_DEFERRED as return value. Since commit 40595cdc93ed
> >>> ("nfs: block notification on fs with its own ->lock") the DLM
> >>> implementation were never updated. This patch should prepare for DLM
> >>> to set the EXPORT_OP_SAFE_ASYNC_LOCK export flag and update the DLM
> >>> plock implementation regarding to it.
> >>>
> >>> Acked-by: Jeff Layton <jlayton@kernel.org>
> >>> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> >>> ---
> >>>  fs/lockd/svclock.c       |  5 ++---
> >>>  fs/nfsd/nfs4state.c      | 13 ++++++++++---
> >>>  include/linux/exportfs.h |  8 ++++++++
> >>>  3 files changed, 20 insertions(+), 6 deletions(-)
> >>>
> >>> diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
> >>> index c43ccdf28ed9..6e3b230e8317 100644
> >>> --- a/fs/lockd/svclock.c
> >>> +++ b/fs/lockd/svclock.c
> >>> @@ -470,9 +470,7 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_fi=
le *file,
> >>>         struct nlm_host *host, struct nlm_lock *lock, int wait,
> >>>         struct nlm_cookie *cookie, int reclaim)
> >>>  {
> >>> -#if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
> >>>     struct inode            *inode =3D nlmsvc_file_inode(file);
> >>> -#endif
> >>>     struct nlm_block        *block =3D NULL;
> >>>     int                     error;
> >>>     int                     mode;
> >>> @@ -486,7 +484,8 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_fi=
le *file,
> >>>                             (long long)lock->fl.fl_end,
> >>>                             wait);
> >>>
> >>> -   if (nlmsvc_file_file(file)->f_op->lock) {
> >>> +   if (!export_op_support_safe_async_lock(inode->i_sb->s_export_op,
> >>> +                                          nlmsvc_file_file(file)->f_=
op)) {
> >>
> >> ... but don't most filesystem use VFS' posix_lock_file(), which does t=
he
> >> right thing?  I think this patch has broken async lock callbacks for N=
LM for
> >> all the other filesystems that just use posix_lock_file().
> >>
> >> Maybe I'm missing something, but why was that necessary?
> >>
> >
> > Good catch. Yeah, I think that probably should have been an &&
> > condition. IOW:
> >
> >       if (nlmsvc_file_file(file)->f_op->lock &&
> >             !export_op_support_safe_async_lock(inode->i_sb->s_export_op=
,
> >
>
> Ah Jeff, thanks for confirming - there's been a bunch of changes in there=
 that
> made me uncertain.  I can send a patch for this, I'd like to rename
> export_op_support_safe_async_lock to something like fs_can_defer_lock
> (suggestions) and put the test in there.

go ahead with the name change.

About the uncertainty the other changes, except this one mentioned
above here in the reply, was a revert of commit 40595cdc93ed ("block
notification on fs with its own ->lock") that had removed a similar
flag to in kind of a reverse logic.
The flag means something that the commit message says "... filesystems
with "good" ->lock methods to support blocking lock notifications.".

- Alex

