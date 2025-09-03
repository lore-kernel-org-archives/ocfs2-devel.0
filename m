Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C8522A4FC
	for <ocfs2-devel@lists.linux.dev>; Wed,  3 Sep 2025 15:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756912761; cv=none; b=rwMIAM9cDW0tXNubiCRiImpn2nKh+qZu8TpCR/g9K9p3GuslaZ5iq7KE4apNEJfCt5wksRKFy+xamYwJ7cPgVihtbzZRjRJgzCHeaWejnF0dMyKHnYbfog4uekTMKwzqaHOj4K9uLrlhYwccd/NIWQVvkIJxbjPIAi0Q2yG4ezo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756912761; c=relaxed/simple;
	bh=S58EWpzS+6u8s5RJ4gmjAsV4nN25GmiHzuNrgIa3T68=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZcAWDmEFM4rw7gXHNyJ8H84a+rXD1qW4BBFort8GyjwRXOGn3Vjvyqd8FOF29eOV0efjEmzdjLUXeOmd4Ek6pVAJ+2nhgSXeUNUY7gapaBK5tyjCs6xEx/S1bBKo0/0LH+wgKeXnBEICSXZJL+5ysv8TRWc2iRUHIvPVqbYZ9eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NtKVCuBq; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NtKVCuBq"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-61e425434bbso5876686a12.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 03 Sep 2025 08:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756912758; x=1757517558; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S58EWpzS+6u8s5RJ4gmjAsV4nN25GmiHzuNrgIa3T68=;
        b=NtKVCuBqNk/w5plSxQRrhl1bV6Hdn57LBEhBHfOE/GuGd7BoigWJ7TZNXkmPq5iZQE
         Vhj1iWVx7+okNiX1yZZQxKZ9Tqha0zQ6u3wVy6XU87xLI05eS8Xh/bzWhjyNMLRyzNNg
         Yr0AfLdU9zEDSHDpUCaTbqr7wixY1ecP/4Wu1WaA8qKccq0qXshyZtG/XV+8aRxcaTwn
         zn8X3YrKp2QtFnxCVzydtDvtK7p9CtpfP+rsGSSZ/kMobzhw02ug8d2f6W/Gjf7sLqdS
         /aCZgPHfBRith7PLLMo6ckNfciAGNTmutd3AVfEXpBtIAYJIQC7ePqVpLw81X2ulMJn8
         oxvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756912758; x=1757517558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S58EWpzS+6u8s5RJ4gmjAsV4nN25GmiHzuNrgIa3T68=;
        b=vHMuVx9I0IAebiYskhlwe0aHEj3zZhpNvC0f39kvkMil66XQ+NrA6McKiXOGUbG7jR
         PY7W6aH8hdd6Z4Du9fn42Ytihtzb0/7LGCdMJatx9s34N5MZFs1GG6gwRt8FAUjTC5P6
         +5cq5mRGNLjIY+CqT6hcH9ycHNhrFwWHq0tbmumGm5akQZuBeuni6DhnfESwf9bpoC9O
         P2jt4r/aezDgKnAzuSwr/29T5BPrw0WPLu8Vz3pEXhZdV9c24jatquoM3yijgILqjibK
         QjbMHj8qD0vchUVmKBomnp280jlS1zl/1fOGbpqMEMZ5Yc+RaA7ibAeglt3/Z4cTRMnm
         rhPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUc8YBQsQb9LpHw9mBcOUH5Lpf3hkPpBBmIQ38QXSrc3d3Kn1R1LMDHeeVXqXNfuJSGdMGK09F815Y09Q==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6tvmN2TQ/G4NBI58IGuyiWdHiOz33fxyT7lN92oH69kKyLJhs
	prZ96jugZa362B7C/ykHqAdxwNgjIfaDmh9koRpxTbjq6YqIKbdC8pAAq19minpU0s5wRGeTQlj
	m65JvqheGc9Eu/nMQNepti9Rgv/TqL3E=
X-Gm-Gg: ASbGnctBIypMY3OpWhbhtOPclOt0weMQAyrKaSY48oDK18vCsrDI9ZeGLeAjkr7/a9B
	XxBcTDf1B63vBKZb7CfkeFvxhHc/OMYV5qjMenvLZMDOT+nZYmnYgqnH3kIu+v37GIt2VKyuVWV
	vlTtO7vBn9SPUqumoNeaBD0qvmr29984g+IeCpbmU4M7CArk7l70ZoDwjFmKNiprDcChiEQ8P8z
	iJboukrSj6PPMGzAA==
X-Google-Smtp-Source: AGHT+IFuctW9BP/uDSAJiqvSGSIsgxexFixfjemcmIpgKvR7o0tUjM8qK2Rj3xAcon+GVuvvjWZFIa6af4NLgSa2XSY=
X-Received: by 2002:a05:6402:1941:b0:61c:4c77:cb8 with SMTP id
 4fb4d7f45d1cf-61d2698786emr13654778a12.15.1756912758212; Wed, 03 Sep 2025
 08:19:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250902145428.456510-1-mjguzik@gmail.com> <aLe5tIMaTOPEUaWe@casper.infradead.org>
 <d40d8e00-cafb-4b0d-9d5e-f30a05255e5f@oracle.com> <CAGudoHE4QqJ-m1puk_vk4mdpMHDiV1gpihE7X8SE=bvbwQyjKg@mail.gmail.com>
In-Reply-To: <CAGudoHE4QqJ-m1puk_vk4mdpMHDiV1gpihE7X8SE=bvbwQyjKg@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 3 Sep 2025 17:19:04 +0200
X-Gm-Features: Ac12FXwvyfe20gyT4wZSs_XlAryf5deG2Ca_IKdYDIFbG-8FYCg8sV_xSwDcDoI
Message-ID: <CAGudoHFKmXJGRPedZ9Fq6jnfbiHzSwezd3Lr0uCbP7izs4dhGw@mail.gmail.com>
Subject: Re: [External] : Re: [WIP RFC PATCH] fs: retire I_WILL_FREE
To: Mark Tinguely <mark.tinguely@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>, ocfs2-devel@lists.linux.dev, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 3, 2025 at 5:16=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com> wr=
ote:
>
> On Wed, Sep 3, 2025 at 4:03=E2=80=AFPM Mark Tinguely <mark.tinguely@oracl=
e.com> wrote:
> >
> > On 9/2/25 10:44 PM, Matthew Wilcox wrote:
> > > On Tue, Sep 02, 2025 at 04:54:28PM +0200, Mateusz Guzik wrote:
> > >> Following up on my response to the refcount patchset, here is a chur=
n
> > >> patch to retire I_WILL_FREE.
> > >>
> > >> The only consumer is the drop inode routine in ocfs2.
> > >
> > > If the only consumer is ocfs2 ... then you should cc the ocfs2 people=
,
> > > right?
> > >
>
> Fair point, I just copy pasted the list from the patchset, too sloppy.
>
> > >> For the life of me I could not figure out if write_inode_now() is le=
gal
> > >> to call in ->evict_inode later and have no means to test, so I devis=
ed a
> > >> hack: let the fs set I_FREEING ahead of time. Also note iput_final()
> > >> issues write_inode_now() anyway but only for the !drop case, which i=
s the
> > >> opposite of what is being returned.
> > >>
> > >> One could further hack around it by having ocfs2 return *DON'T* drop=
 but
> > >> also set I_DONTCACHE, which would result in both issuing the write i=
n
> > >> iput_final() and dropping. I think the hack I did implement is clean=
er.
> > >> Preferred option is ->evict_inode from ocfs handling the i/o, but pe=
r
> > >> the above I don't know how to do it.
> >
> > I am a lurker in this series and ocfs2. My history has been mostly in
> > XFS/CXFS/DMAPI. I removed the other CC entries because I did not want
> > to blast my opinion unnecessaially.
> >
>
> Hello Mark,
>
> This needs the opinion of the vfs folk though, so I'm adding some of
> the cc list back. ;)
>
> > The flushing in ocfs2_drop_inode() predates the I_DONTCACHE addition.
> > IMO, it would be safest and best to maintain to let ocfs2_drop_inode()
> > return 0 and set I_DONTCACHE and let iput_final() do the correct thing.
> >
>

wow, I'm sorry for really bad case of engrish in the mail. some of it
gets slightly corrected below.

> For now that would indeed work in the sense of providing the expected
> behavior, but there is the obvious mismatch of the filesystem claiming
> the inode should not be dropped (by returning 0) and but using a side
> indicator to drop it anyway. This looks like a split-brain scenario
> and sooner or later someone is going to complain about it when they do
> other work in iput_final(). If I was maintaining the layer I would
> reject the idea, but if the actual gatekeepers are fine with it...
>
> The absolute best thing to do long run is to move the i/o in
> ->evict_inode, but someone familiar with the APIs here would do the
> needful(tm) and that's not me.

I mean the best thing to do in the long run is to move the the write
to ->evict_inode, but I don't know how to do it and don't have any
means to test ocfs2 anyway. Hopefully the ocfs2 folk will be willing
to sort this out?

--=20
Mateusz Guzik <mjguzik gmail.com>
