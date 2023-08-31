Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C24711CB6
	for <ocfs2-devel@lists.linux.dev>; Thu, 31 Aug 2023 19:28:44 +0000 (UTC)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-58d70c441d5so13049897b3.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 31 Aug 2023 12:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693510123; x=1694114923; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K8qDQJExdf2/MyftTvEkhS4s/WAMk52xVgwr8SGMiDE=;
        b=fUW7eIRLFeSKAgPPNhe7tLi3k71SXV4jLApMuzLk1xVWGCqqWx11O8ItgIBJV+fkrA
         YWIp16vV7LPSohLUvSamtgDAamaYhX/y/NN+0F2Xvn25XiqAILVYeOEhRZdMIFXvqnSv
         UhtCoBA5/hvd2IVD5hsolPW8Z3VGAinspgLWoL7Dqjvi0XpAukAqK6cZlrgwLy4INjLu
         iAV9d3ujVA9sijI6i7ECJ7wwklLelWhZzl+sJetpVvj4rPxBGV2K9+mDR5RT0gSXdxKw
         9F9sFrlWjO4sPls1MIer8Zl2ilZubZbfxZ+Vh9B5HCT+rdiUD1NceQw/x5NASXVS1sv2
         aIjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693510123; x=1694114923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K8qDQJExdf2/MyftTvEkhS4s/WAMk52xVgwr8SGMiDE=;
        b=iiYEFkKahT93C+1RnY+hxv8xEP25vtnfnPiZ2C0UNTbAEjTb/23a4V7KpaE8HS/jvX
         bG3+y74te71rVp4698tUFDEX0s/kBCqk7OGPJHG/1DHmzs180bcJswMqEgmdrPsmXUwG
         WREEngnb4AA1aqP9Evhzk8CLrjg7E8yN2ZWY0ZkSWmMWMWq14LKtuOIX0YDa//7uX2Cf
         r8ks2EujaVwsdXdflwyZYdzvk9iZZ8YHSXaQXF6OIygyahUPNJM4eya/NO1pzDvhNxes
         jWWOH+d4/DODlvx5PxIrIqfUrOgRXeN60jsOg15Bbx6PJ2jqMpz6THwlR91GswG8A7ko
         bejQ==
X-Gm-Message-State: AOJu0YzzJVELO6p+Ha20DWWym4MwKooByAviCDIHwSIKhcLmygz9ncAN
	6iSH8+OkZjOnxz1U4IDVoK6VUU8C+/b/zpKI3DY=
X-Google-Smtp-Source: AGHT+IHUk+T46JxLGqYp6rQq8hKNL4/Cn40334y926ibfAf3nZ4zAVGPqIKHXAMfPwddXw3jVUWSXX+nNgI0+RVu+F4=
X-Received: by 2002:a25:6642:0:b0:d78:2383:4427 with SMTP id
 z2-20020a256642000000b00d7823834427mr671226ybm.9.1693510123188; Thu, 31 Aug
 2023 12:28:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230830215426.4181755-1-azeemshaikh38@gmail.com>
 <20230830215426.4181755-3-azeemshaikh38@gmail.com> <202308301601.8A8EE6B653@keescook>
In-Reply-To: <202308301601.8A8EE6B653@keescook>
From: Azeem Shaikh <azeemshaikh38@gmail.com>
Date: Thu, 31 Aug 2023 15:28:32 -0400
Message-ID: <CADmuW3Wc7fzoCcif7WmY4X4FWErFc4poMOqzMXu=3mf0ycju1Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] ocfs2: Replace strlcpy with strscpy
To: Kees Cook <keescook@chromium.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, linux-hardening@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Dave Chinner <dchinner@redhat.com>, 
	Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 30, 2023 at 7:06=E2=80=AFPM Kees Cook <keescook@chromium.org> w=
rote:
>
> On Wed, Aug 30, 2023 at 09:54:26PM +0000, Azeem Shaikh wrote:
> > strlcpy() reads the entire source buffer first.
> > This read may exceed the destination size limit.
> > This is both inefficient and can lead to linear read
> > overflows if a source string is not NUL-terminated [1].
> > In an effort to remove strlcpy() completely [2], replace
> > strlcpy() here with strscpy().
> >
> > Direct replacement is assumed to be safe here since
> > it's ok for `kernel_param_ops.get()` to return -errno [3].
> > This changes the behavior such that instead of silently ignoring the
> > case when sizeof(@buffer) < DLMFS_CAPABILITIES, we now return error.
> >
> > [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strl=
cpy
> > [2] https://github.com/KSPP/linux/issues/89
> > [3] https://elixir.bootlin.com/linux/v6.5/source/include/linux/modulepa=
ram.h#L52
> >
> > Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
> > ---
> >  fs/ocfs2/dlmfs/dlmfs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> > index 33e529de93b2..b001eccdd2f3 100644
> > --- a/fs/ocfs2/dlmfs/dlmfs.c
> > +++ b/fs/ocfs2/dlmfs/dlmfs.c
> > @@ -80,7 +80,7 @@ static int param_set_dlmfs_capabilities(const char *v=
al,
> >  static int param_get_dlmfs_capabilities(char *buffer,
> >                                       const struct kernel_param *kp)
> >  {
> > -     return strlcpy(buffer, DLMFS_CAPABILITIES,
> > +     return strscpy(buffer, DLMFS_CAPABILITIES,
> >                      strlen(DLMFS_CAPABILITIES) + 1);
> >  }
>
> This is another case of "accidentally correct".
>
>
> param->get() is hooked here, in the sysfs "show" callback:
>
> static ssize_t param_attr_show(struct module_attribute *mattr,
>                                struct module_kobject *mk, char *buf)
> {
>         int count;
>         struct param_attribute *attribute =3D to_param_attr(mattr);
>
>         if (!attribute->param->ops->get)
>                 return -EPERM;
>
>         kernel_param_lock(mk->mod);
>         count =3D attribute->param->ops->get(buf, attribute->param);
>         kernel_param_unlock(mk->mod);
>         return count;
> }
>
> Meaning ultimately this will show up here, if I'm reading names right:
> /sys/module/ocfs/parameters/dlmfs_capabilities
>
> Anyway, the "count" being returned would be quite bad if
> DLMFS_CAPABILITIES were dynamic and larger than PAGE_SIZE (the size of
> the sysfs buffer).
>
> For this case, I would say replace strlcpy with sysfs_emit:
>
>         return sysfs_emit(buffer, DLMFS_CAPABILITIES);
>

Thanks, sending out a v2 for this. Out of curiosity - why sysfs_emit?
Is it because DLMFS_CAPABILITIES is a hard-coded string?
