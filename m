Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA951C08
	for <ocfs2-devel@lists.linux.dev>; Wed, 30 Aug 2023 12:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693397724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pXW+YJ7Es1NUxs1wO/8B0lyOdXp6T+rmiitd4bvcpy8=;
	b=SG+WuMrf5wj6EH0bpIhdtMrbBWrcJEbV1Dq2liUzRemjDqjiHbSKd6vob/iCylWdFKlbNg
	JyvpUGUoIn82lAOvdJ1LX888EfBHKbPI0PQpUlt5bKwIGIAaq2cK6QWDYQ43VwzSzZdZkJ
	VHBneZzBphz5VtUCi+nlLgHCdAaw10Y=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-99Ba1X8aNTGwLubsTh9s-A-1; Wed, 30 Aug 2023 08:15:22 -0400
X-MC-Unique: 99Ba1X8aNTGwLubsTh9s-A-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2bcb47970eeso60312341fa.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 30 Aug 2023 05:15:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693397721; x=1694002521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pXW+YJ7Es1NUxs1wO/8B0lyOdXp6T+rmiitd4bvcpy8=;
        b=VyXMgbe/bY8uSBHZPmu/1Axtgndsot1QAf0TjPHxTVyhLUsWcO9jJuNu0r+QdmbjUj
         xeFQfBaaE7HlVlbuT/9WdXSy/hwpiYgqk+G4oEzrvAfE0oETEHEUo60djBMLs/WoHuCm
         Yb2p3506QARHToFpUBf7ZAbvTs/bdgYH131WOOwm/aKynMkrT+PkrwIBjXr8HKSWmelu
         YhhTHdxDN64d5TzZy/nJ31QPvh8H9Sc7l8T7PCOE83B+IfpsqEqR5I99SWwfISxUHRe4
         XgTFrn6l9Ym9MmfzlYuEld1eFv0UxltcEam9xuHfkMN542YD62V4nLAzSvrwWS4Te/PE
         vHrQ==
X-Gm-Message-State: AOJu0Yz1pau+wxuowyZqN0TKl0ua+IdiwNJFv2lssT92egrG3xlFjBBo
	TolaBCC5zffTTZm+y2PAq3M7/LcT8alNvhm1pY+rxS2psDAKAAik7hW6hJS/BXxBpSWx0xBG+sp
	fUXGSOcwBSQEUGnvR4DNcZf8Bu0Q1bRIVYK2yFuU=
X-Received: by 2002:a05:6512:3a8e:b0:500:bc5a:517a with SMTP id q14-20020a0565123a8e00b00500bc5a517amr1599280lfu.56.1693397721196;
        Wed, 30 Aug 2023 05:15:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFH4CTWLGIc2/L6PKaTeIATaE0rFTOba0dxmf+/1WydwsNUiyEi5RRMTlB/tcj2GzHwHxxqFM7q4A7ioapsKgE=
X-Received: by 2002:a05:6512:3a8e:b0:500:bc5a:517a with SMTP id
 q14-20020a0565123a8e00b00500bc5a517amr1599259lfu.56.1693397720785; Wed, 30
 Aug 2023 05:15:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230823213352.1971009-1-aahringo@redhat.com> <20230823213352.1971009-3-aahringo@redhat.com>
 <ae36349af354dcf40c29ff1c6bf7d930f08e7115.camel@kernel.org>
In-Reply-To: <ae36349af354dcf40c29ff1c6bf7d930f08e7115.camel@kernel.org>
From: Alexander Aring <aahringo@redhat.com>
Date: Wed, 30 Aug 2023 08:15:09 -0400
Message-ID: <CAK-6q+hZ8T+Ji5kkmrE4xfA0mf+B7k44nySJqDf2zyJEO3n9Ng@mail.gmail.com>
Subject: Re: [PATCH 2/7] lockd: don't call vfs_lock_file() for pending requests
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-nfs@vger.kernel.org, cluster-devel@redhat.com, 
	ocfs2-devel@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	teigland@redhat.com, rpeterso@redhat.com, agruenba@redhat.com, 
	trond.myklebust@hammerspace.com, anna@kernel.org, chuck.lever@oracle.com, 
	fstests@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 25, 2023 at 2:10=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> On Wed, 2023-08-23 at 17:33 -0400, Alexander Aring wrote:
> > This patch returns nlm_lck_blocked in nlmsvc_lock() when an asynchronou=
s
> > lock request is pending. During testing I ran into the case with the
> > side-effects that lockd is waiting for only one lm_grant() callback
> > because it's already part of the nlm_blocked list. If another
> > asynchronous for the same nlm_block is triggered two lm_grant()
> > callbacks will occur but lockd was only waiting for one.
> >
> > To avoid any change of existing users this handling will only being mad=
e
> > when export_op_support_safe_async_lock() returns true.
> >
> > Signed-off-by: Alexander Aring <aahringo@redhat.com>
> > ---
> >  fs/lockd/svclock.c | 24 +++++++++++++++++-------
> >  1 file changed, 17 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
> > index 6e3b230e8317..aa4174fbaf5b 100644
> > --- a/fs/lockd/svclock.c
> > +++ b/fs/lockd/svclock.c
> > @@ -531,6 +531,23 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_fil=
e *file,
> >               goto out;
> >       }
> >
> > +     spin_lock(&nlm_blocked_lock);
> > +     /*
> > +      * If this is a lock request for an already pending
> > +      * lock request we return nlm_lck_blocked without calling
> > +      * vfs_lock_file() again. Otherwise we have two pending
> > +      * requests on the underlaying ->lock() implementation but
> > +      * only one nlm_block to being granted by lm_grant().
> > +      */
> > +     if (export_op_support_safe_async_lock(inode->i_sb->s_export_op,
> > +                                           nlmsvc_file_file(file)->f_o=
p) &&
> > +         !list_empty(&block->b_list)) {
> > +             spin_unlock(&nlm_blocked_lock);
> > +             ret =3D nlm_lck_blocked;
> > +             goto out;
> > +     }
>
> Looks reasonable. The block->b_list check is subtle, but the comment
> helps.

thanks. To be honest, I am "a little bit" worried (I am thinking of
this scenario) that we might have a problem here with multiple
identically lock requests being granted at the same time. In such
cases the most fields of struct file_lock are mostly the same and
nlm_compare_locks() checks exactly on those fields. I am concerned
this corner case could cause problems, but it is a very rare case and
it makes totally no sense that an application is doing such a request.

I am currently trying to get an xfstest for this upstream.

- Alex

