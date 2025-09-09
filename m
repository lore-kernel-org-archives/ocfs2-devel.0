Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0780B3002C3
	for <ocfs2-devel@lists.linux.dev>; Tue,  9 Sep 2025 18:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757442763; cv=none; b=jPG5I2EuzFRQfxpF1CkF58Dz3kkjhkaD/pnsZ1j7fH2Q8JQcRJC7V82hA8riGi8uW2DIwr4PuTlyPWeUOkyd6V93505Pal6ScZlHYvfoKsHqY4lsqZkwOZiIErBHSefLs538UFe9D6PbCcpgox2RQsza7P7OKWt3aIPQmnG5LcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757442763; c=relaxed/simple;
	bh=GW2x3BiMlxtdXONsUQUaEy/dHtbMsT4sWtlNzRaafO4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n5UV1l6T1Y1oVNau2WoxfVBT/JCYtzvlo8vYkh7htHsjBpr+oTVQ/olfJ8IKijWXFshTvdJpA6wq5t1nexnqpRVgVN6+cMvcWoAxzMI/3UjRIwq38h6YdCOVuOTGhJkXPxdBxE1aK0l1ud1GJ0M6cg3ibyUU/t/xqjQ0SVvJazo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P6wwuqj3; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P6wwuqj3"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-625e1ef08eeso6602329a12.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 09 Sep 2025 11:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757442760; x=1758047560; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yIGs9FBrVN4ysExlh34AjdYI0YF46w+oZSmAFf3lNX4=;
        b=P6wwuqj3yziXl0Cai96or+gUtCbhUA6R7qtmTlTnaUqBDLe5RunHCXFJPRfmx+eGnv
         zlM+Oi4iHb5dGMtANxlbiYJkExbu6qVK2vXHImyNCaS/mjzY7rNKUxkeSFn/d8e6FjqJ
         rL/Bv7dLlHOx6pHx/ukbhpij28o5X8dhCMn3nrTlahL5hPiGFSWsUhB/shmKXG1D4Tip
         HiytWda0ymz2fNKtfaNMROU1pnBOC0TDOI7H5RWZcDETofT0UflLWeFauBVj2w5l8+Zt
         zycTAr/GS2WDLBpHg04MPDflkbk34S4DtdDv3hYRUxlAjEO2fwC6aqw4QFHj6Nx0vRmG
         tGCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757442760; x=1758047560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yIGs9FBrVN4ysExlh34AjdYI0YF46w+oZSmAFf3lNX4=;
        b=r4ELyCl5VTF4FDJ5c7Z+TU266ZtZpRGH7a2cTbbHYl7Z3nggQTVt/tNxArDVGVKKsA
         Td5c23V1HXxMiPnBalZoKzwG3zI6yZai0PBU+p7Xk8LXyx6tXuZcoflrPsl8AeX+050N
         2rwqxL894mtH81UEP9m57uUvg6LLsWG2agqj/zGFQKP+O65Mmh538NnNAL70MVrg/BbZ
         hrGf3yZpT+ccI/g1cayBrztNgR0JoLGZ77quKrv1p2CUdVk2LAf++cYb/bkIVsNTLMTo
         yNOmRJnOLIfQuvKfYFenDIgLLjuT8PN+NfJkhpCa0+Htpk+Vo7uom2f9pcaBfkbfpE5F
         Wc/A==
X-Forwarded-Encrypted: i=1; AJvYcCV1lth7tCnD1yIagl0cqR5wZREa3sqqAIcXgObKCet6zykiAeAh3WzRS65ZnaEF1Cf6IKgDLf4MlNFw/g==@lists.linux.dev
X-Gm-Message-State: AOJu0YzPpjf3cq3WC0/X7ZlH0kE7J0PoibfL7Np40eSOOyMKDaA+4Z3/
	DadsFsjTqK8y6QaxqAQ4TiCTPKGgTp+3+P4mZ2Q9Xab2rC1sM7Cz/GNHSzozxey7ddrKOSiZB7S
	j3Z7xQZFvTMdm502+MeZ/WTHQUQB6XL8=
X-Gm-Gg: ASbGnctlDnjUWsF7GbzrdkNV2vPE1fE2hThSfnJxeROtNIwNv1bRwnb6ZMYrouvOmRl
	UtwvYjaL0Cj7bAVsK9uL4mo7f9Qq0FKjvQRrbszj2OL479kZhJOyBQB5jlZSvdUfkuhpHC3xdFq
	FkcgsOYoexEyUcvoQAudv3713DFk62rLv4PLywz/m6ZbJKVkRPffIPUpqly2DLEt+a0XOQhAoEF
	caNSaOujPn/ZfyIAg==
X-Google-Smtp-Source: AGHT+IGIpYLmFMQhXwhapf2seoXIPbxx2/CNzBSDsmPVTyytD6TFl/TeK/249z9Axk5K8USmmiSQ3V6JXdtG0O8zPdM=
X-Received: by 2002:a05:6402:3589:b0:62c:62e1:8ff4 with SMTP id
 4fb4d7f45d1cf-62c62e1986amr2372712a12.23.1757442760027; Tue, 09 Sep 2025
 11:32:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250909091344.1299099-1-mjguzik@gmail.com> <20250909091344.1299099-10-mjguzik@gmail.com>
In-Reply-To: <20250909091344.1299099-10-mjguzik@gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Tue, 9 Sep 2025 20:32:27 +0200
X-Gm-Features: AS18NWBEChkhzDf6oUf2_3PrIR6nRSPRVkR8w4kTgZptP8cMl4B5_HTLHZwMBuQ
Message-ID: <CAGudoHG59Q=hQg3cQpPamCj2x8NuNZ7qhTMcOamWTkYDJB4PZw@mail.gmail.com>
Subject: Re: [PATCH v2 09/10] fs: set I_FREEING instead of I_WILL_FREE in
 iput_final() prior to writeback
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, josef@toxicpanda.com, kernel-team@fb.com, 
	amir73il@gmail.com, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, ocfs2-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 9, 2025 at 11:14=E2=80=AFAM Mateusz Guzik <mjguzik@gmail.com> w=
rote:
>
> This is in preparation for I_WILL_FREE flag removal.
>
> Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> ---
>  fs/inode.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/fs/inode.c b/fs/inode.c
> index 20f36d54348c..9c695339ec3e 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1880,18 +1880,17 @@ static void iput_final(struct inode *inode)
>                 return;
>         }
>
> +       inode_state_add(inode, I_FREEING);
> +
>         if (!drop) {
> -               inode_state_add(inode, I_WILL_FREE);
>                 spin_unlock(&inode->i_lock);
>
>                 write_inode_now(inode, 1);
>
>                 spin_lock(&inode->i_lock);
> -               inode_state_del(inode, I_WILL_FREE);
>                 WARN_ON(inode_state_read(inode) & I_NEW);
>         }
>
> -       inode_state_add(inode, I_FREEING);
>         if (!list_empty(&inode->i_lru))
>                 inode_lru_list_del(inode);
>         spin_unlock(&inode->i_lock);
> --
> 2.43.0
>

With a closer look I think this is buggy. write_inode_now() makes
assumptions that I_FREEING implies removal from the io list, but does
not assert on it.

So I'm going to post an updated patch which moves this write down
evict() after removal from the io list, and only issue the write
conditionally based on the drop parameter.

On top of that write_inode_now() is going to make a bunch of asserts
about the inode being clean after the write if I_FREEING is set.

--=20
Mateusz Guzik <mjguzik gmail.com>
