Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794850650;
	b=AD/MUQiTUVwBvARHk/Sn8Nn0CFbw5x8qUv/pO7UfxydYR7Qzv5vCMXkjPxgId9bZEeT9
	 GnOXSuSXcRHsqr8FQTk35GB4w53O3IMd38yvSatAUrqXWtrHd4njpGYbqHFgp5SOxWR/w
	 LMxTt1gnP1gODnV5PbznSyJlby0hfdthBdeszO2wMhPGHWuLQ+04YBo4ZTYpEW6huOlaw
	 CilUnHQvFKozlVnNeH6jc2GidaPTd3P7bmZMnPLIFsX0ziyUpitnJ98HLO32R2wMcEQ9o
	 xZkN1hTfXOEbsndnwECeYYIoc3sAlBlu91O59ALCoOEooxOmi+J0EkcUAU5gIxNanYw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794850650;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ASqD7yYrxwRTXpvky24aSldHzEJHTNv4OUWKJ01NHN8=;
	b=cmcZAlUHwA9QnUWQYR2/ZJuqBSvN63SWOGq8rcD7CVlo/4LpvIy0riwppu+GoYr+cZQf
	 urKPCAkP416QsYA2iqa3rVv0tF9Pu+zjmMtH+2zUqLb0T92r7BaWN3ZkRXOcT1SuyR45F
	 U4egKJ7BB6W1rAs53Q4V+3GuoFK4VS2KKgSXHeDiE0a8+lb4gYLDAF6Sa/8nRaniPeB+I
	 YmDvdK6mCQACMTGmVcuSmFcYq+7gHS6DzvDzhsmBi4D7OM3F9rs9zUI9vJ4YA2GhrLC/7
	 YvFMjb4F6onoIzmddZlIvfQhrLOJUIqM6tOYCThlIEs/UqB6iWTiJORDAtCtRLosR4Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MIIHDm6t;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407A3606A882
	for <ocfs2-devel@lists.linux.dev>; Mon, 16 Nov 2026 17:37:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 407A3606A882
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MIIHDm6t
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b81214ab40so218691a12.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 16 Nov 2026 09:37:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794850648; cv=none;
        d=google.com; s=arc-20260327;
        b=aEk5UqMhWDDanFZuETpyZ4NX/jlvZn5mTBFVffHEymGm/r6OH9o1P20jXlG6Hqo1z0
         2xctlO56q4a+x9VbiF/SvjDZjInWSsQTnlzX2KXHXdZPBqHL18oSF43h++70o9JHcXxy
         Quy48gmTNW7LHDO5T3BiFxUtlCXBiGeHaOyC20VJSRhfyVkSHM1o0gpqQWsqWIqIqWuK
         v9vPz6jI5q5Uak7kT2NTZGBSIuwAbDEhv+ZOClndFO8ru15oDb39nD/KaqnMX+INTgNw
         3WFgTwhAVnQNbvkHkNQrnbN5Zm9r2Zp48+LUmy57sflsMTTUzlUhBNB2wsvIQJbDc7Mn
         T0xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ASqD7yYrxwRTXpvky24aSldHzEJHTNv4OUWKJ01NHN8=;
        fh=MrQqSKZjFTZNzZJMSH9II3hyba2aoJcTI4DRRg08zUQ=;
        b=QdW1eIoc9QABn523NoquEVO7BYNztqNREDo64B72BB+yWhEvrkVgS+j6Gs2VbTaTdg
         lgR4MAQ9QwsHmMYU4GPCxd5g+Kr4M08tASOlmSX7gtNjZGeogIk2UZ5Q7Z5B2pe0A6OU
         KMyiSVN7xpKRB5ueKG8/hFp0meQbIceoszgaMHQXnkA/zdUcY/pEnBepjFeVSR1jXET4
         LuojaYB46OvpcQlfuKK1Q5R364ZH9fp7hPWQV2dHuT8zm+RUQaJa41iDPxOpJ3SpJQ7R
         0gBIDiWPHydcvRANU0pFxYqxawUNIGJAhirKwkqknz1mlVKnqKmnQIF0DIjDrUfq8y/f
         uP6w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794850648; x=1795455448; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ASqD7yYrxwRTXpvky24aSldHzEJHTNv4OUWKJ01NHN8=;
        b=MIIHDm6tNl0jMwQGZFYspXzw69ZH9P9dqlik2bLwSZHN79vb9UQDq3BhLSBW5bLNnp
         kdIeVHGjhZHzf61SyL3b3ydlxwim4EjsThqb0fnZxnanBsxutaCIhyTlGBRG9hPSRbOZ
         fFaG5vsg41r3wTTij9drFm8gpxLl42CkbIANWuXryWOvdftgQB/8SBQEIjVn8KSPtYSU
         2vlHLos9zQsrpdhu2xI22Ez4Yub9+BznFJIQxI6j/wgPmjfKMw/Zc4e/dF3RGn2Ktq3T
         s21vwK591UvJv1ZlyUvhsPDv/2gU2Po7TGDNdkl+TDZ6z2h+AfFyVPIkrcGrM8jz08LR
         NM+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794850648; x=1795455448;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ASqD7yYrxwRTXpvky24aSldHzEJHTNv4OUWKJ01NHN8=;
        b=yCfQ5CDFcDtOlYWRdqFxgEvf5CwcGlx7WNdapZcf7N+JNPynitUiFJKANlqvTeGHRf
         Lpe5sXK+KHNN6ltI+EnQurvAwNwQKAHzgoj5DPWLS7R01VsZcSQdCQ88WwZjw3ijTCkG
         Dswa1yZJFy0FT1uqPB26gFH7cenvXVAAs/WYzrlPWfKBNWhhUE26HxJCf0gccszRO+8a
         AN/a0XTOjSHXywdAaBH0r33ryoCn0+/GWKimFQp8tWkkYHLz6WsabsX/Zik9LOerzKy+
         HlzT766DwtgQ3mzpyWo3JVUs66tQ6E1Pmpt1XRfMLUVFrPnC91dIDLe1eYPWMWgAXu62
         5keA==
X-Forwarded-Encrypted: i=1; AL+hErFU2sBFF+3syWXSfFvHLGxG1nsOtTMZi/AYlIUrBdkJebaJKIRmcBFvCb1e2T+yxHK8jKmit0iYoUFkHg==@lists.linux.dev
X-Gm-Message-State: APuU4Z94LvnlaRZrVKk4kJ5zEGpo5vyywYyShtiqqV930YB6npZYJdy4
	XjeFE7QROQcmMlBmoS1YvjdTuOM2euaJMVn+ZYN869ndFgbW2Fje6P8haYbeWH0TRYD6AbRpZeb
	ntF9ceY3PX3kuvodJU0H+RRF8WhD7AkI=
X-Gm-Gg: AYBFou34Y2asLbByp77qJaYkCYaJuuHtauylb/412eJlZ19sQslB91kCyckaj7I0tF0
	To+xe8PFX0Kn9BTiFWOs4r5OVAb+ySooX5WTbqWfDkk/GEXYik+wgfnQ131G3ejJ2SMZfjgYajK
	rUjk34MSkP2WftfLSyNKWqw3qqEXo7qzRRyP4CIfW4YaFuAsJEJk4ehTfxTEy0qZle3TuLWZ9Nv
	k09kx4N5io4JXUbVSymUPxxw0AnQ9AlclQB7EO0naJ+r0/H77XNGxL3JooCa7SB7wnYBLgUawlX
	TAlFL5BX0HyYXBDwXX2ZauXhErlsomTeNaFyCYgN6lj354s0w1PjetT2jBfSCbu4Y+UoXtEM0Mz
	bIEEh5LTX8Hqp97JvKlYRB+uMyipOlckoaHZlUhPUraluP0zt0IIk/O+uH9tSi+VSwkAT9A==
X-Received: by 2002:a05:6402:1598:b0:6b5:7250:d621 with SMTP id
 4fb4d7f45d1cf-6b859ae1a00mr134291a12.15.1794850647426; Mon, 16 Nov 2026
 09:37:27 -0800 (PST)
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org> <20261116-work-loop-pseudo-v3-33-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-33-8cbbea1cf34f@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 16 Nov 2026 18:37:16 +0100
X-Gm-Features: AclHuK_sKnxFPAK3k65pZhjyZC94SJD4eZ9z2j_P12s3kyb9TMw6hurQcjyq55Q
Message-ID: <CAOQ4uxgPerkkG4ie0SyHVXaBD9VZN2wYfQpEAEi4hytn=ara3A@mail.gmail.com>
Subject: Re: [PATCH RFC v3 33/44] ovl: refuse data-only layers on pseudo filesystems
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 12:10=E2=80=AFPM Christian Brauner <brauner@kernel.=
org> wrote:
>
> The data of a metacopy file can live in a data-only layer. overlayfs
> doesn't look that data up when it looks up the file. It only remembers
> the absolute redirect and looks up the data lazily the first time
> someone needs it. So until then nothing can tell which filesystem holds
> the data of such a file.
>
> But a data-only layer has no business being a pseudo filesystem in the
> first place. All it does is hold the data of metacopy files and the
> regular files of a pseudo filesystem are kernel interfaces, not storage.
> So let's refuse data-only layers on superblocks with SB_I_PSEUDO at
> mount time.
>
> Data-only layers can be added via the "::" separator in "lowerdir=3D" and
> via "datadir+" by path or by file descriptor. All of them end up at the
> end of ctx->lower. So a single check in ovl_get_lowerstack() covers all
> of them.
>
> Note that regular lower layers on pseudo filesystems are left alone.
> Stacking overlayfs on top of sysfs keeps working.
>
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo=
91QjJHH9T_Yw@mail.gmail.com
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/overlayfs/super.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 39d4d57dec230..719c2569dfeaf 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1237,6 +1237,14 @@ static struct ovl_entry *ovl_get_lowerstack(struct=
 super_block *sb,
>         for (i =3D 0; i < ctx->nr; i++) {
>                 l =3D &ctx->lower[i];
>
> +               /* Pseudo filesystems don't hold data for metacopy files.=
 */
> +               if (i >=3D ctx->nr - ctx->nr_data &&
> +                   (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {
> +                       pr_err("filesystem on %s not supported as data-on=
ly layer\n",
> +                              l->name);
> +                       return ERR_PTR(-EINVAL);
> +               }
> +

How about we make this just a tad more restrictive:

                /* Pseudo filesystems don't belong in composefs setup */
                if (ctx->nr_data &&
                    (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {
                        pr_err("filesystem on %s not supported along
with data-only layers\n",
                               l->name);
                        return ERR_PTR(-EINVAL);
                }

I could send this as followup patch, but since this version is simpler
there is no real reason to have the intermediate "only ban datadir" step.

Only the commit message needs a little more flexing to justify this.

Thanks,
Amir.
