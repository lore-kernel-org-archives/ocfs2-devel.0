Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DB72EEE61
	for <ocfs2-devel@lists.linux.dev>; Fri, 16 Oct 2026 01:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792113073; cv=pass; b=rqWx9N+R7mdUuYkO4bDcVEKXlNWMX7AX3M5DCT0DR43ueKtNAiPVvhlvDhVDwn3rmOX9vbsCQV7fyTUVCTWC7qvDlJt5/GuVYoJoWJvdUSnEqU1h7jpkc6iasef/FbsxzyyGLlEpa1MXAg/g4n5+85xwIDLdEFko0CRhcnPldc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792113073; c=relaxed/simple;
	bh=JzG9jaJYiued69pJ3zjgkohjroIPbtGqeOHKXUqa6kI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gC7dgb+I34LFwBF2TG7tf62h0uoy8g83S1HMJ+oTSMfcVIs7K9gPZH6EZ63xF6Io3QSm6SEpKjAV8egB9uhpbG4JKghKwMs6dnvHyAhD0Wu6B4sdRw4S1xDUlBV6nF/4yLkrbdXvxOMk4W/qoTsa2Oo7RHH5JTN3EkQE2Zm2S2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PRwFYbXW; arc=pass smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PRwFYbXW"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-8aea7b7ca0cso45690567b3.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 15 Oct 2026 18:11:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792113071; cv=none;
        d=google.com; s=arc-20260327;
        b=m1coZqmlbxtaORkQ5Xg4NyBOa68Y9+LBfDnT7q6rodhmObNTt4mQOi7ED0jPyZTPCf
         pRhHFFIJoJ0XDCestkQr6xPAboJ4ToQy9LingpYbLBFVy0rXjvIyJctHzsuwxX03ESVV
         MfNxRvGwdFaA76a87XkXzFwBr2oG/xFpvphNevAsLVfCRIREIVUIyJ94DtRwRmoyftUN
         rY0kq3R5VmYIQo5YwTNoacBUmerPvcRfqzdYXhnZeP45DREwokbIjltuYSfySN9ySJXg
         9j3GE6G3HrdeyqZhS06IyluivEbYioXV0lTeFAGz2SDjTugM4oY2OCvNSw1/gA9tcb66
         DRiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VQkIfSljpkAXMtApCpc6CLLTd+fi+11lXbgR/qs4Vvs=;
        fh=/fc+kd9kqvMue/wWZ3402yszXfjYCcZrW+OIzt3fZlw=;
        b=pNlYDMxmVTZCYaucSODgwmG1K6KJC734kbq6o2U1lC8QFUSHx2hs8tb5IIJltnvBVP
         8ja12JIZjLVj1ZayBszZdw7dFwwjCOV8Vef8suvximk+0zisJHGTjWWdSKYg7FSbr9rD
         fbPuhNKiKliDCuqNiUFqLUl77zy1K/LaIkynmFw5LJceUyhp7MM6yuN1zr3Q/iJjtUM/
         DTe2JwVs0BFxc/oAMjCOEmRifpwvMx/QwVGV2POhzxIf75kJmbIj3dUDWK7GLct+vbaA
         YPjLQA8DG/bBlafRO5COH3TjWcLo9wiDRYMVbUHBaUOwZ+SokC+ymZYNCCISQ1/25tp9
         0Z1w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792113071; x=1792717871; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VQkIfSljpkAXMtApCpc6CLLTd+fi+11lXbgR/qs4Vvs=;
        b=PRwFYbXWn7XNI/6XzsF7m8vyIBXGAvTdwqpd3xadeX0+8cwWEwKTbPYHM4Iuof05Eb
         /Fc/3eepgWD+JPQajsvMOZbkbQg1BOlf0cNmvPVWNpytAauOZ0RhJAOy0d2flznSReVx
         6BGwdvPqbRBUDSOqDgNGoCNch7h2RE6omXzfspXaJN5fXN8GZFF684DWWbeXxt9oeA/U
         QB+VgiJ9ls4O70d5IqFJ8DrQbjzixfmMQySw9USwtkjVZetKLW37oy3q17nmXPQv3CxO
         +MqUdkOvvUGQk0WYDe/Ctb+dLLnqe5JIy34zCP3ILjWV83xO0CGA4NBXf2wutWnrgjeX
         IKAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792113071; x=1792717871;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VQkIfSljpkAXMtApCpc6CLLTd+fi+11lXbgR/qs4Vvs=;
        b=z6b675Q7bPb3J2ibf3kBTTDURgcURcZBdJYCd/3MrO/L8sCzO3/zkbsliz77ackzZ5
         gGrjiL8hpp271rMXD6yr3OUBRtC6diUodC+gcWBe56+lj+PbaBMSSbyG7LzQ+20DO/MC
         KNHexRXBkhj1eIYogM9GKRY5qJEw6gXE63bwg2xFWSI9DcaBjoCIqsMGpJ3wBGZHgmqs
         NjaX7oQENyzYpsaSFlDKfH0x9KtLa8KX9HZzmaJ7sSNapi9lRBPHMwwOo+JLw9n1zl9w
         jpfWNhl+TL+eJ3048HONHG/3mOSZoTx/qDlOZcWfq9wlxYoIQ12qJsDh3/R4/DoxziZg
         BozQ==
X-Forwarded-Encrypted: i=1; AKwUvBz4aUZiN9xOHcEP1lGsL/kxDlO1XevNrz2Li8XyPymn3GarNb6tJANFwkcPSqjgV7tX5vcqQgZj7uf17w==@lists.linux.dev
X-Gm-Message-State: AFq9FYJx+rz//zcnacyoXcZD3AiZlUZRpMpfNq+xbRK2kNGzr2ExxkRO
	0joDOb+8JwXgIrp04cEqkd2AXPS3BGK6t9DI3ABRvdGFbk0m8M0qoV87bfgtyWk+lqfTtKpD8Fd
	Bw9xJDxleJPU5F+Mhs9ucjYorqpTOhCs=
X-Gm-Gg: AYBFou2CGAQplwOUY//bpuha0ychk0UNwZQJ1wO7LS3LODZg9lGTprIgUuQuTBl7KVa
	3AMxOytYXxsG6lduqxE/NjcfeRIMZlNmazi1IfPoQI8X5eXus7s+l/+rGZIBRCJsz7LTlaGmX77
	JalfsP9zwT+30OBwuaaRexu9ellUa/ly8pON+inSqF+G7Ix3ivJ0JN3FARUHBV1SO5ZfKwDkRv+
	dujngp27EB2QTvoFH45W2PR78nScZHNPsNKWmwPuW9lwjEPBVZvtrf3/N/1Z1g11Dv0BlchY3Vx
	VCwuI82vozD2HssbOaBbhVCDmBJVgGB1AjoPch6KzYdv33ccgHZGZXMruHVZylUTC8HL7VNZ82h
	gu/2ZVdBwGoImZld1T8jz
X-Received: by 2002:a05:690c:c4e9:b0:8b0:8ec8:d4df with SMTP id
 00721157ae682-8b08ec8d874mr61136177b3.53.1792113071334; Thu, 15 Oct 2026
 18:11:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <pm-ocfs2-objects-candidate-0089-v5-076c780eeaf45afb2a53@gmail.com>
 <202610151231.3D8F9A63@keescook>
In-Reply-To: <202610151231.3D8F9A63@keescook>
From: Cen Zhang <zzzccc427@gmail.com>
Date: Fri, 16 Oct 2026 09:10:58 +0800
X-Gm-Features: AclHuK8edup2SupqX1o3fhs6D1NgY4SqIBp2hHyIkSs-U-DuEilWC35HgZo3hmg
Message-ID: <CAFRLqsUAQuorPYcEOWJX-hgduzG+CGYUy=ozS-rXB-Cs+VNBTg@mail.gmail.com>
Subject: Re: [PATCH v2] ocfs2: Pin owning modules for open debugfs files
To: Kees Cook <kees@kernel.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	heming.zhao@suse.com, akpm@linux-foundation.org, kmehltretter@gmail.com, 
	christophe.jaillet@wanadoo.fr, ericterminal@gmail.com, rppt@kernel.org, 
	rollkingzzc@gmail.com, brauner@kernel.org, sunil.mushran@oracle.com, 
	kurt.hackel@oracle.com, jack@suse.cz, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, baijiaju1990@gmail.com, 
	jjzuming@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kees,

Kees Cook <kees@kernel.org> =E4=BA=8E2026=E5=B9=B410=E6=9C=8816=E6=97=A5=E5=
=91=A8=E4=BA=94 03:32=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Oct 16, 2026 at 12:42:32AM +0800, Cen Zhang wrote:
> >  static const struct file_operations o2hb_debug_fops =3D {
> > +     .owner =3D THIS_MODULE,
> >       .open =3D         o2hb_debug_open,
> >       .release =3D      o2hb_debug_release,
> >       .read =3D         o2hb_debug_read,
>
> Please match the indentation of neighboring member assignments through-ou=
t.
>
> --
> Kees Cook

Thanks for the review. I will fix that.

Best regards,
Cen Zhang
