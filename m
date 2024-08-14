Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075AF1C3F09
	for <ocfs2-devel@lists.linux.dev>; Wed, 14 Aug 2024 20:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723668469; cv=none; b=FsPW1R1hRTcuMaY89h7ZxkJhx9kIKWRJqbuGExYgsAm4+a7x/LbBhOvhSt7WXVCjILJZ/9o8dNuCWWnhNYbdBHlL1Smsma6z/pDan5S7wffoI/w5RSHmITXdOxOblXJ/bFnBH+zxNPLJ1CtqWLOxNy4+KkuyPvDOEAnvHoHGza0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723668469; c=relaxed/simple;
	bh=xAuqg4LG4M0fbnSo/GQcVfg4wjhYXdK6fQ96rx9RI40=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IwFaXTyerkvO1t/waDtVCAeb1ZuwSWd6ZYJ86bCw24xXHc2ZYGDCESrLXIcDLJgO2kzbQTOOTlNVOJBW8vOUT19RWkpxlbYNDaeAh57WGyt7HwVcXvu+nWxSxDlsujhszlblkL3iyT+48b0ZzWG/8u8G8TV41ry4DdjdiBw9q7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PFAG+na0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PFAG+na0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723668463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L+6lTZVqxZijRPSjfEzQi+vwTAY7CwJ2b1e+TxM4Mrk=;
	b=PFAG+na0653VjDsKS+cfl7B4hE41AIqnu5rzljUwwJAyLZ9+yzxefVbv9f7v6fQUvC+yhu
	3T9yQSpG4+vid3CQOkj6DPna4n09v89fDYwIWYCQWum4LcFe5ArmLOIQXphIckNd/wpX0G
	kyxcZifIvDP9Isw9P2ExXg8ZIHJJMpo=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-oD6olpZiNRS_SNsJ8ObXSQ-1; Wed, 14 Aug 2024 16:47:42 -0400
X-MC-Unique: oD6olpZiNRS_SNsJ8ObXSQ-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2ef23ec8dceso2453601fa.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 14 Aug 2024 13:47:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723668461; x=1724273261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L+6lTZVqxZijRPSjfEzQi+vwTAY7CwJ2b1e+TxM4Mrk=;
        b=GobuMyIsuUk1Tno9fyB7jO26qJe4hhRqAJVcLysy4aHdU8JB8i+s0HDfMELYilyi+f
         LZTRDBayVcxghEYlBHUpTg7LNzWr7TjT2XYXmoNUFQDaHJ8OvJuTLCi3h4vZTVH2GCuo
         Qr0rXLAqj0vKY0jxudnl26d+9ad5+TSaj0N3KZl7gTrQk/IhHy72JLuiaJWpnoN8kCi/
         8WzoJLlRNsx78pTTY/Czw0dtvJ8822gusbrZqF6TEN30dTTCptg6O3sbZPc6un+Mg3Bw
         3Vndv+sVXu9OFVVCDwZa26layc0tXj36ljaxGKW5bKUz9m7XQqxRdCB4soCaobeM8sKt
         wr0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVRWZRFMfO+h2Pws/EcQ0j4CaNq9b/dXEbgHwGU2bEldYojgwgYZdfea8RwRi7QrClMQcIPHZymzwKdLOwxOIBL9BB5gVk6uGpTNSc=
X-Gm-Message-State: AOJu0YzX/32CoC4HMsbLM2D09DCBgCCiGLqgiAywIIGPPzhA70mE9UAw
	83BIiu2/WG3TOLHj97Jd39DZl6lkfcPONmV7r56LcLfgJHqNT5hv67+otH22CeiUPQ9rXxbr2DQ
	S8WKQ2xuNdPMYsBMk+pEHCX+9pGC0Ju1pNbt59gqxM24FHEsBvuB3AMLS2IyDjCoKhmV+ZN+37+
	YVgck5xoNwuCHalQC4SuBclYdfELH8dMsWQEM=
X-Received: by 2002:a2e:9683:0:b0:2ef:2ce0:6ac with SMTP id 38308e7fff4ca-2f3aa1f1dd1mr24000351fa.22.1723668460827;
        Wed, 14 Aug 2024 13:47:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOJF6QT6rKh2U8kgEkPVDV5badXvR0hhWLGciNfUm778LjMDYtscMG23tmLAtY9tHBPsjoWq2/pM4uncBTUwk=
X-Received: by 2002:a2e:9683:0:b0:2ef:2ce0:6ac with SMTP id
 38308e7fff4ca-2f3aa1f1dd1mr24000091fa.22.1723668460232; Wed, 14 Aug 2024
 13:47:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240814143414.1877505-1-aahringo@redhat.com> <20240814143414.1877505-10-aahringo@redhat.com>
 <2024081445-coffee-antiques-e9cc@gregkh>
In-Reply-To: <2024081445-coffee-antiques-e9cc@gregkh>
From: Alexander Aring <aahringo@redhat.com>
Date: Wed, 14 Aug 2024 16:47:28 -0400
Message-ID: <CAK-6q+hN8ZRAHc7aS7C_RO4pEGN1t3eA_vDChsSgsQOcJEU4vg@mail.gmail.com>
Subject: Re: [RFC dlm/next 09/12] kobject: export generic helper ops
To: Greg KH <gregkh@linuxfoundation.org>
Cc: teigland@redhat.com, gfs2@lists.linux.dev, song@kernel.org, 
	yukuai3@huawei.com, agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, rafael@kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, lucien.xin@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 14, 2024 at 11:06=E2=80=AFAM Greg KH <gregkh@linuxfoundation.or=
g> wrote:
>
> On Wed, Aug 14, 2024 at 10:34:11AM -0400, Alexander Aring wrote:
> > This patch exports generic helpers like kset_release() and
> > kset_get_ownership() so users can use them in their own struct kobj_typ=
e
> > implementation instead of implementing their own functions that do the
> > same.
>
> Why is anyone needing these?  What raw kobjects require this type of
> stuff?
>

In this patch series I introduced kset_type_create_and_add() to have
the possibility to do the exact same what kset_create_and_add() is
doing, just setting a different "struct kobj_type", for the kset that
is created internally by kset_create_and_add(). I can't use
kset_create_and_add() as it always uses "kset_ktype", see [0].

I am doing that to have only a callback for ".child_ns_type" assigned
as it returns the "&net_ns_type_operations;" structure to tell
underneath everything is separated by net namespaces.
I don't want to change anything else so the "struct kobj_type" should
look like what kset_create_and_add() is doing. Therefore I am creating
the same structure as kset_create_and_add() is using, see [0]. The
"kobj_sysfs_ops" structure seems to be already accessible from
outside, just the two functions I am exporting in this patch are
missing. Or I implement it in the same way in the dlm/gfs2 codebase
(that is what nfs is currently doing, see [1]).

And then we are at the two users of those kobjects that are using
those functions, it's DLM and GFS2 as they used kset_create_and_add()
before and I just want to add the ".child_ns_type" callback. Other
users could be nfs [1] (for the release, get_ownership - I have no
idea).

thanks.

- Alex

[0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/lib/kobject.c?h=3Dv6.11-rc3#n937
[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/fs/nfs/sysfs.c?h=3Dv6.11-rc3#n23

