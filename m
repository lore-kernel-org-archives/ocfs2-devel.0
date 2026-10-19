Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06543DCD85
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Oct 2026 13:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792417485; cv=pass; b=TDwz7R8RHqnRRpeN4FwkVuvKyH9U3Evip/ZjlpLO8NdrM1Ll5qD7OqsKDJQwgtl0phVYRniIa6/OpuWCB22nkczMmpxDFdGrn1p8HWENvaP/zBhKnlBH3uRBzZwflT1IQW6Xz4IB7crpwTguDQTZOWp9I2PgT48NFTMFY5L2Sx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792417485; c=relaxed/simple;
	bh=N6otFQ+2tvXWfIAg1Rmz2WPlSNDcEmt3lrNhdwAkn1A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FBf4cEzdm+ZNl9wUIyOibsk7imde8M/a1j1ZsnMvlQTP11pn/+68pkOZVWq/lbiOrn+ElOb0oal17DTSE1nn6thmHC7wdlN0mB4kR54TzeW4fg3xKegxJYwf6BSYtKafqfhGMqcyzgg/QP5wCANxqlxmoV1fpBD7p71gJLAF2Ec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O4/wZaIh; arc=pass smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O4/wZaIh"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-6798af41644so1379454d50.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Oct 2026 06:44:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792417483; cv=none;
        d=google.com; s=arc-20260327;
        b=Y0s6G4qSna5roz+hQnHKNpYaOPkPnAMV0yB7pUmE3Bj+smbbMfgoESjGcFMR8b8z5n
         yl1c/zlobEz5E/5fdplCjXkdTrLJZPDJ0znrzZ923o/lkRBpjb7awTeDgBuXgbvwryQd
         6ZiY8uZAuQB8PnKFQ6zo9oG7QDmxPJ4fzurMZ1tvTeKT4BXPzWHGU8LCPbGzZxrtM0VA
         uZN0JPatXq3A7M1Bkgm6qCvh8sTtC1bC8vU2FmIsZK89MTxiqO/Rz2pRN9R9gq/hQ94W
         XMhON8BpsXs3ZUe9XHqvS/+XJCXnrdl/G8J98nBSzbUEA499+4liL9TdEIX4ubpKzjAa
         Ec1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c6zrnlMaydst9vfRtkenLVpyYJzF31Gchs+iCqt4/Js=;
        fh=xHv0axa0mvKtQv00JaKwdemqhuUdrYsiqf0rl9Fu78M=;
        b=cTpRBKqqP95/zdhjVMTyF/9FJ6Fs0qbU4EuH+ugABmPBx3wEpCMLHSvykKMOI1l8xz
         x2zzqN7Nc+hyIcy+YlYOADdB1E4iQqTAOCE7Pg2Ktpf8u+8RqhK9Qs9jZWN1GbL3H/XQ
         fbJyiqhjZhHnSoXR6tGCHR0wYSknhWkGZY4D/Zz+B/8DmcuT0ffwZHsEeRG/hdJiy22P
         C+NffYbA0PVftTlN58Q/2Po4dBxeZwsRx9uuc6ZXO6O7qD+ucmtIEs/XT8b455J0mHbu
         pwccm9oprswc+3nqd71CmsPjcID1yjsmSuCgEiP8RKqqZBerYKrNXwMsm/K33ehtq3sA
         d2gg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792417483; x=1793022283; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c6zrnlMaydst9vfRtkenLVpyYJzF31Gchs+iCqt4/Js=;
        b=O4/wZaIhdjPbof1kN+dLnm7nvINnXC3PfUIreOBFBwo6yfqPogc/ZTJDe4XeB/VKpw
         B/kJhyklizii0iOKHX3CTEz1shrk7+dG8Y3JQF1pbZkB57orcWD4dPy0yVy4HlqkhwBI
         vrO6k+q8AlHD+q1g32ZejD7KqHm5TWSBMIUqIo1tT9rbTiZk1Nhxsm3rgytPvKb+JHBG
         TmLyEfy7f3ATCWOIBiHbPyh6AHnFivQjG0/R/8zPcrgMqPC+KIJNrfgupGrURTqfm0ig
         KlaMRQUtVAsAoZnj6Bx6kPXKdDUE0P6n8JdI8Fdvb278ZDqXgmpos+2YuMsClEnc+24m
         +cHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792417483; x=1793022283;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c6zrnlMaydst9vfRtkenLVpyYJzF31Gchs+iCqt4/Js=;
        b=oCKwGxTXHlCQ07uKu+n9I03k3vPmT5lTF6njSgDgMJAoYKdg39oXX/RRlX1XSb1Aul
         JTfVQFiChA8QJOxTJHJG2Q3AzRA0IqYDC9rZqi24q2ldODHHadlDO67GA0nWXnGXfqh8
         9C9QZYVsqI62ck/Nd3Tb/+vCcc7+C3dhuJgZg9ka4zWVPbOKvBKELde/GqsZ83kTkA4T
         asMHN9N2z4U8mORTBWSp4dSkJ8jgh415BT8HuJ2N9BFzNLYjnZMS7g5d98LesGRkSGBB
         tyjbjSYDfqaM7X1nkY8JAl1rhV6JJgGtxiRWq9N+ABOjI9yNxnvnrUeei7sUBuNFRujL
         PokA==
X-Forwarded-Encrypted: i=1; AKwUvBwlMKvD5HquI+kP9oc4VOM2/7ZFf0HdQ4ouURj7NJUbQTY90AJplG2FcfKwhHd0VSZYvFkwhxsaYn2WyA==@lists.linux.dev
X-Gm-Message-State: AFq9FYI0AbiKeT+Slsgs8MjLY8FowfWGEXdOWMDsGsKJowyiwSrBZQfq
	J9F85Ktk43d6M4s0n3ntoTuabEwXUx3CbxonrvQzPEcOUYVRIBapKnkEsYL8pO6Tm/xVU0ydMWo
	HkW12GqZmlmJB0+P5LO0BXQtut8K0flM=
X-Gm-Gg: AYBFou3npATdnoWDRSWturzBkmcQSXNIgVqONdMKQ8d/CFXUnvCt8wEErKAz1DaOJGI
	O+yFbMJxboOVKXJeWLjTCJ+Y52DiFN/2GKijkYqkiHwPLXT7hA28mIlsEepP5wQMAKVOOcKrcff
	1qd2FmZRG6UdaPu20O3qzwzjEQwq93ylsmxFV6KZiUe7OWvQMmPg4lYZQv2lzkWlLvddNuNDcHr
	tFNaJKLkCoN2fEVnbX1nrVe1i02r1pIkCFj/NB+h9/q6HG/gbluPXZckOMfEOIepV7IdAmFMm9J
	JMfdJtvyc85Sdk4D/Y+iyhs1zP+7Jy0rEW9rt871XIrqe3krQLmfd84aLaeBE+6AV9+jVKjdsPf
	aHoYhluR4Fg==
X-Received: by 2002:a05:690e:400b:b0:677:d31f:5a6b with SMTP id
 956f58d0204a3-679ca744115mr2203453d50.16.1792417483474; Mon, 19 Oct 2026
 06:44:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <pm-ocfs2-objects-candidate-0012-v5-a0413a339b72c02fc885@gmail.com>
 <b273a680-6b96-4fd6-94e6-c1a79922efc2@linux.alibaba.com>
In-Reply-To: <b273a680-6b96-4fd6-94e6-c1a79922efc2@linux.alibaba.com>
From: Cen Zhang <zzzccc427@gmail.com>
Date: Mon, 19 Oct 2026 21:44:31 +0800
X-Gm-Features: AclHuK-1bDPBzjxBFC-g5JhoX08zvMpID73JpPkYTgaCzs0JQP3z-Kv1Dhf22ZY
Message-ID: <CAFRLqsXdt0sDKAkKmWH0aL=urZgWWEwhGjnWpkx5CyDkDqnukA@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: Keep the dentry lock inode alive until callbacks drain
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com, jack@suse.cz, 
	akpm@linux-foundation.org, rgoldwyn@suse.de, srinivas.eeda@oracle.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Joseph,

Joseph Qi <joseph.qi@linux.alibaba.com> =E4=BA=8E2026=E5=B9=B410=E6=9C=8819=
=E6=97=A5=E5=91=A8=E4=B8=80 19:20=E5=86=99=E9=81=93=EF=BC=9A
>
> Commit 9f70968af3e6e ("ocfs2: Re-order iput in ocfs2_drop_dentry_lock")
> is what moved iput() above ocfs2_simple_drop_lockres() to begin with, and
> it was a deliberate move:
>
>   Do this to avoid a theoretical (I haven't seen this in practice) race w=
here
>   the downconvert thread might drop the dentry lock, allowing a remote un=
link
>   to proceed before dropping the inode locks. This could bounce access to=
 the
>   orphan dir between nodes.
>
> With the new order the downconvert thread gives up the dentry lockres and
> only afterwards reaches iput() -> ocfs2_evict_inode() ->
> ocfs2_delete_inode(), which takes the nfs_sync lock in shared mode and
> then the inode lock exclusive.
>
> Thanks,
> Joseph

Thank you for the review and pointing out the history.

I will preserve iput() before ocfs2_simple_drop_lockres(). The stale
access is in ocfs2_get_dentry_osb(),
which obtains osb through dl_inode->i_sb after the final inode
reference may have been dropped.

For v2, I plan to store osb in the lock resource=E2=80=99s existing l_priv
field, use the default osb lookup, and recover
the containing dentry lock with container_of(). The mount context is
freed after DLM shutdown, so the callbacks
can obtain it without accessing the inode.

This preserves the existing inode and open lock release order. I will
send a revised patch soon.

Best regards,
Cen Zhang
