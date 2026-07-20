Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375FE3DCDAB
	for <ocfs2-devel@lists.linux.dev>; Mon, 20 Jul 2026 14:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784557310; cv=pass; b=im6Qlit/h6k9HxdEbPzP7h1qKC4k+1CcmvSUQNMpT4ESb5ZWwAs6v0M7+P2IporbQB3FG1SBsaBfufsD1SKbxcNWPRMAq0CjhkP5l/9ITiOAKjYegd9BBjMp73H7/0rcZJvh9jK5wdA66htGQXUwHxhSH6y2Eux0h6nhbHDwi1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784557310; c=relaxed/simple;
	bh=WEwwCETDlsNQJFv5hY3ZkCq1BoftM3bbFquctiAMLJ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=krOzkoLGv/Mn/jwu55re/Pg0yaAfLxpg8idluXdfB8aTRnY3Lzp5ZFypl6cxLBEo/Rb1Lc9Y92Krowge/LOw3QIeehTkkVS/5XZuuszGQ9DEvVUX9wttFvkGMCnb/+dSWzQS91FDiA3bQxYnrgeoq2J5ptaxfE0l5gJw74yF75s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=blo3LZvG; arc=pass smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="blo3LZvG"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-81e69a2db34so52424607b3.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 20 Jul 2026 07:21:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784557308; cv=none;
        d=google.com; s=arc-20260327;
        b=DTy2RfgQe8EzzWdBTNsRhqUxe2kDmoXxGoN/aS97sszllOnCkuKUiUwkBrxaXhnGWR
         gCLyGEqx5NuON26a/MGzQOsbUYlNdPWQb8qHuQy7i3P6q/EBH0AgLHTbTx6mI36ckocg
         WGy8xQBv0Xewu0zL36Q6hy0XEEAMQikkucyuLmWh76wuO2PNeu3GzhHnzXqBsY2kuwof
         bz4STi52chCJogRooyvezJ7NE4G7+/w4MK6ElNFO+b/RJJSYgu6gfujrqSH44X1ON1IH
         L0IE3bx25cD2lz7fEkmQkazuPgUOpnZhYOzg3dr+8vvMnPP1tZ7B2PxY3Jl+7Dz6mKUe
         ppDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=YEL/okeXjUlwjJKcmLwYHGsfz5XUTlwUM/c5E7Dfnl4=;
        fh=k89a9n86f/iWizPSkBWBJmejCZ2G0fNxnE5KamFxuMw=;
        b=iCiYFnvs+/63i6PfyvmUKslGk23zDdZIvfIWgWnAnU0VPuH2HbY/OcpON3CRt22kfI
         adll6pKPHDe3UJxWkGA2hIVU14t+gF6D6+6MdbFMKCxtjKUfni9+CIcpT07i6CeJmlci
         enMAPvO2hMEWY0WImpIDVn71zqehkLV7Yp6oNzOk2/QOnZrR89BUSBbrtX7onVEuEfTZ
         HzQvSaQ7AsJjm5uySNx4Bvkln4mMVtP6SndQ0KJlcB04FrZvPvUKIFziDyYMYzPbJvmP
         nLSuHoXX0QG+xjOJmiXzaTyCLkeW/lG7mLYWu73ThJ/SyoVUcFoR30XNjylxartdizxt
         kb1w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784557308; x=1785162108; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YEL/okeXjUlwjJKcmLwYHGsfz5XUTlwUM/c5E7Dfnl4=;
        b=blo3LZvGjz5TkZmYhaoogVNoKR47s0YsfWKkkb7zomZJg8UDR8R/MDRATiJhJPtvch
         k/T9ghz0UtCc1bd6gFWqcr/0xoJKlDWTQyGNRRNv2GlBZ47r4xvX2v4SotQLJPam+9bY
         hoLLQLatRTsgmJZs7BYs2Wd41Wi0cmtFjCHl411gX0LZI3QzLZZv9+e5WbyHtik9BrQw
         koaL6JoGkgnG2u3+bOzE3VARC3m4jjuGcOVaFES4YBTb94pLJSX2/PXxkjr4cC+Ql24H
         zGKFGtA79b5yY4WnIbf/elVIYxc9AQS4eXrbHi82HoUdCBCP5DgZItoZvnMhcghRUy52
         txOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784557308; x=1785162108;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YEL/okeXjUlwjJKcmLwYHGsfz5XUTlwUM/c5E7Dfnl4=;
        b=DngGOmuu1VrRIe77njik01Ez8ihqEfUHsVIbOLXMbb9DTmvf2nUA4f4QeFSmF8S2wQ
         T0+S2TXQVi2gRse86KX+WmeKyTubCQdFviPRg7Ptnswle6/N8kErP4sLY6OqY1+FePiC
         dMqteXAPjguGAjjFx44X3ChmshXJLdZPHi0L/DsDafONJKU4GZr3pXg4E8+AWjJvXAmn
         IPlG+aP/hbXGBVjnfbn1gf0ct8MhHJ6LraYU0+XP3UZrgecKpxcM2C+wXtSnlUId2H/v
         W5soHrUe511tjOrtPgCx8/MX79yeSLS8/YiOdWQm+wqAtWZeWwpUz9fd9Kdq1sdD8g2U
         i1Kg==
X-Forwarded-Encrypted: i=1; AHgh+Ro9J2wh3l/3xocFt+UcANuOgFKVLqfn487EW6KU1i3IOhuusRqxlynm/zAKWghHOB/+QEHT0wAEHqCjIA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7xbrabyJBogBdFtQDVXYsfmosQLlK0YTbpCsNftNDCFq6gksH
	Lso5rcfSWXvBjrlNCGjihh3bDDIIptB1k9Ucr/KPavEd7pOpK3bhQcEFMV/tTdCmMb9FOD12mDS
	vIuqwqPrEp2Qf0BTyOvJ8aa250YvpVM8=
X-Gm-Gg: AR+sD10BllQsmj4t5rQjkwJIg2xCG9EcQsfqF/G14ET2WIN7nSSDaZNoUwxGeOu+jEi
	x11wXiqLIITTtYyhbOuov+czKXcp2+36wYmgAwMoRUOYaSeqhLDHhegpGsN+8tjPesx/nc2pYDT
	HHOXza3aWBOYLYDyih+muMuhL2hrRtnhOjbjVs8xD+/xutiwRO+IZYdU2UA8gjW46GaAvZ/Zfdc
	8N4C0PFc8iUvaRaMRzsefoSHli5Rn/6f7Ke/nRjz6PHSyQH0xULVHhLIwwzO0I=
X-Received: by 2002:a05:690c:3505:b0:81e:6c2e:f113 with SMTP id
 00721157ae682-81ef2857f57mr45877217b3.36.1784557307892; Mon, 20 Jul 2026
 07:21:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260714113517.1381604-1-lgs201920130244@gmail.com> <910f147b-baaa-441f-b532-8858f8d43d85@linux.alibaba.com>
In-Reply-To: <910f147b-baaa-441f-b532-8858f8d43d85@linux.alibaba.com>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Mon, 20 Jul 2026 22:21:34 +0800
X-Gm-Features: AUfX_mxzNJs9YoWDwWlmakS-quV6yhdpZ-hCMUrLRog9uycxaVj-yn5HhVsDgsw
Message-ID: <CANUHTR-PTkMvD_wmd3SXAQ2tv=ynnWFG1b0FDambQ4+s+ZE9Ug@mail.gmail.com>
Subject: Re: [PATCH v2] ocfs2: free unused clusters on defrag move errors
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Tristan Ye <tristan.ye@oracle.com>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Joseph,

Thanks for the review.

On Mon, 20 Jul 2026 at 11:09, Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
>
>
>
> On 7/14/26 7:35 PM, Guangshuo Li wrote:
> > ocfs2_defrag_extent() claims new clusters before calling
> > __ocfs2_move_extent(). If the move fails before the extent tree update
> > is attempted, the claimed clusters are not referenced by the inode and
> > must be released.
> >
> > The current error path only logs the error and continues to
> > ocfs2_cow_sync_writeback(), which can overwrite the original error with
> > zero. The claimed clusters are also left allocated.
> >
> > Not every __ocfs2_move_extent() error can free the new clusters,
> > however. Once ocfs2_split_extent() has been called, the extent tree may
> > already reference them even if a later operation fails. Freeing them in
> > that case would leave the extent tree pointing to clusters marked free.
> >
> > Track whether the extent split has been started. On errors before that
> > point, report that the new clusters remain unused so the defrag caller
> > can release them. Once the split has started, leave the clusters
> > allocated. Return all move errors through the transaction cleanup path
> > without allowing writeback to overwrite them.
> >
> > Fixes: 202ee5facb2c ("Ocfs2/move_extents: defrag a range of extent.")
> > Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> > ---
> > v2:
> >   - Do not free the new clusters after the extent-tree update has
> >     started, as pointed out by Joseph Qi.
> >   - Track whether the new clusters remain unused on error.
> >   - Preserve __ocfs2_move_extent() errors instead of allowing the
> >     subsequent writeback call to overwrite them.
> >
> >  fs/ocfs2/move_extents.c | 23 +++++++++++++++++++----
> >  1 file changed, 19 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> > index ad1678ee7cc4..138c65d21668 100644
> > --- a/fs/ocfs2/move_extents.c
> > +++ b/fs/ocfs2/move_extents.c
> > @@ -49,9 +49,10 @@ struct ocfs2_move_extents_context {
> >  static int __ocfs2_move_extent(handle_t *handle,
> >                              struct ocfs2_move_extents_context *context,
> >                              u32 cpos, u32 len, u32 p_cpos, u32 new_p_cpos,
> > -                            int ext_flags)
> > +                            int ext_flags, bool *new_clusters_unused)
> >  {
> >       int ret = 0, index;
> > +     bool split_started = false;
> >       struct inode *inode = context->inode;
> >       struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> >       struct ocfs2_extent_rec *rec, replace_rec;
> > @@ -59,6 +60,10 @@ static int __ocfs2_move_extent(handle_t *handle,
> >       struct ocfs2_extent_list *el;
> >       u64 ino = ocfs2_metadata_cache_owner(context->et.et_ci);
> >       u64 old_blkno = ocfs2_clusters_to_blocks(inode->i_sb, p_cpos);
> > +     bool split_started = false;
>
> Duplicate declaration?
>
> > +
> > +     if (new_clusters_unused)
> > +             *new_clusters_unused = false;
> >
> >       ret = ocfs2_duplicate_clusters_by_page(handle, inode, cpos,
> >                                              p_cpos, new_p_cpos, len);
> > @@ -111,6 +116,7 @@ static int __ocfs2_move_extent(handle_t *handle,
> >        */
> >       replace_rec.e_flags = ext_flags & ~OCFS2_EXT_REFCOUNTED;
> >
> > +     split_started = true;
> >       ret = ocfs2_split_extent(handle, &context->et, path, index,
> >                                &replace_rec, context->meta_ac,
> >                                &context->dealloc);
> > @@ -138,6 +144,9 @@ static int __ocfs2_move_extent(handle_t *handle,
> >
> >       ocfs2_update_inode_fsync_trans(handle, inode, 0);
> >  out:
> > +     if (ret && !split_started && new_clusters_unused)
> > +             *new_clusters_unused = true;
> > +
> >       ocfs2_free_path(path);
> >       return ret;
> >  }
> > @@ -209,6 +218,7 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
> >       struct ocfs2_refcount_tree *ref_tree = NULL;
> >       u32 new_phys_cpos, new_len;
> >       u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
> > +     bool new_clusters_unused;
> >       int need_free = 0;
> >
> >       if ((ext_flags & OCFS2_EXT_REFCOUNTED) && *len) {
> > @@ -309,9 +319,14 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
> >            phys_cpos, new_phys_cpos);
> >
> >       ret = __ocfs2_move_extent(handle, context, cpos, new_len, phys_cpos,
> > -                               new_phys_cpos, ext_flags);
> > -     if (ret)
> > +                               new_phys_cpos, ext_flags,
> > +                               &new_clusters_unused);
>
> Seems we can reuse 'context->new_phys_cpos' to check if need free without
> changing __ocfs2_move_extent() prototype.
>
> Thanks,
> Joseph
>
> > +     if (ret) {
> >               mlog_errno(ret);
> > +             if (new_clusters_unused)
> > +                     need_free = 1;
> > +             goto out_commit;
> > +     }
> >
> >       if (partial && (new_len != *len))
> >               *len = new_len;
> > @@ -684,7 +699,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
> >       }
> >
> >       ret = __ocfs2_move_extent(handle, context, cpos, len, phys_cpos,
> > -                               *new_phys_cpos, ext_flags);
> > +                               *new_phys_cpos, ext_flags, NULL);
> >       if (ret) {
> >               mlog_errno(ret);
> >               goto out_commit;
>

You are right about the duplicate declaration. Reusing
context->new_phys_cpos is also simpler and avoids changing the
__ocfs2_move_extent() prototype.

I will update the patch and send v3.

Thanks,
Guangshuo
