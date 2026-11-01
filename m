Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793493222;
	b=tvJo1Ly11FIikroW7V3lqqD9P1hU2ut1F2jieO0yETVSYJnxfA2FsUY4uWsmPmn7JMc+
	 OC8trOKm3ewBKFCD29DmkSKWqznFcd6LmZJMcXa2yL4OAp/E0kVoRn+L5DrQ9Ps5ukXc3
	 SfH52A/7yf+2zmjPZgp2OLZO+MO3dEoZa0mMm+2ZNDpCqzadyYn/25uZjmKCFvqF2iNNr
	 5CiP99KoK0acWu2+JnuF+R4+1KJ/kuTnnNN8XJdz/c0HxPIACgde7/Ha05ybjcjIusKOJ
	 ps1ebr24SKgaE7qLpBFgsyaZ1OzE3YB4lwZqERlbiZNV4mT8kbUwdgGdgKchD82s9YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793493222;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:Autocrypt:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=/OyNuE+u9LVqbLjPn4c642Wjld5y0QKeGGJuFQ0QfKY=;
	b=R0hMUAJz4YYzLtCiAwzA7EuW9g4V2pMCCQLGRhGV+rZlY6fb4Kbipw4/Nb6Ta6J6q1sK
	 W42UIJZyCc6hY8MQ31chzlhxyYm0yiROKguZw2aqy+YvSLvX2zHs3hCRhT/YQLr6mYEIr
	 v4La252JTdR6JWsdjILbYqbAaZOGsODFd09m1if+W9ZftXgUCVX/iG5WY4O+j2BTbw8Bg
	 yyRq4i3km8bNVLwL9ZCnQwUr5h7Vj1VtWWQ6BJS9phkhQqGhWTzECq+gmL2HfUAkSITS8
	 fJceceJo16a2sB8DS7Nvbo4lFGoPcKZmkeaBARL4yqESmLMvNYF6Uim7ztVqFUGoQmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dubeyko.com;
	spf=pass smtp.mailfrom=dubeyko.com;
	dkim=pass header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Nyu9pDl5;
	arc=none smtp.remote-ip=74.125.224.43
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA35606A325
	for <ocfs2-devel@lists.linux.dev>; Sun,  1 Nov 2026 00:33:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECA35606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Nyu9pDl5
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-6798c43a3d6so1288330d50.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 31 Oct 2026 17:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20260707.gappssmtp.com; s=20260707; t=1793493221; x=1794098021; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/OyNuE+u9LVqbLjPn4c642Wjld5y0QKeGGJuFQ0QfKY=;
        b=Nyu9pDl5RAYyLcjZHkzxoDxgvvvBoMiIGD8J47kzds2AH5Jn14oTQYXDptuKQ4ImAq
         Jgf44bJ3KEj+pJ8exgOpoKlh+nZavej70q4WQD4flfpQ8IpYY8tDxXz9cEgrFDsKEKqX
         ZkkWZSudNGWJ9zpBDXqQ0Ei2q4wXVVA6jC/6JG75DcfbEYRsBd1Bod2/9eNWEXi7TBWa
         h5uPjEcYBcq9m0btLP3ThyteXLaJGsLLE3hTntQs41QlW/uUZEeisJnh+2OOrh/mFeJo
         qm3etrmlojwbvidlI52oKn6MhHjR8k4AXuoeQ/EwAwfQV9171gSb6o4PGgvgEht4J6m0
         m90g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793493221; x=1794098021;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/OyNuE+u9LVqbLjPn4c642Wjld5y0QKeGGJuFQ0QfKY=;
        b=vEdufCysb5Bj5eroXPcwHsQ6jfg1Khv/j+/5xPHjsMxuRdY5aWg5Cjs9SnibtLEak/
         McXemoEoc3dx4v9caFHN91TU4bPcydtRdArTQk8/Z4Zn8NH9ZG4QdStQcgQfQ9QVMmeX
         waEZ06JzRV7r2TnhgLrLBXEw00FDX6EtUvVq0ApkpU54vodoVCLZjdAAaj/qoYrn5OSh
         2EkVKva/g1OSILOqOfEsNEJthSpAmZH0GraMjbOK5aN9R2aJ2mg0CKgAxT+5PgBRk+dJ
         ZfQpeeFwWCpiFxqOI5EFNBdnRZeqO0oSyF893DjS4XM2fBI9CH92OWM1aFiujJ0dOkrI
         wv4g==
X-Forwarded-Encrypted: i=1; AKwUvBzBK33eB9hMWuGrAVE3jOXWMxTJXePqNy9alXdEKmtTGoM8nJ6fRhpS0HirFEDVwKcVz8m6PKabs+sbJw==@lists.linux.dev
X-Gm-Message-State: APuU4Z/AV4fdkZ9SOKC3f4n0wqkwdAAIQ7AssFywCZI9p8tBuV6/T89N
	EX1G3TGAnNVfkG1zY/Z3sZDaZvkTrvMag+FVpGsQNVKd/BImMOYsgXbCsXm8ar3uttM=
X-Gm-Gg: AYBFou0Xfl06LE0YSHg0xT8V7eJcPotjyazfDzIUGEv8LEWDbjjszJbaNdt8IEHIvkm
	gn8Kpk/Bw+uQ2CXjlpnYm1BZiYorgWyuLERJkwKE+P7VqYZiWhtI1N5DrOwXSf/VF/hMC+3+M6y
	1lJC5t63ha0cxhyseoJsIFU3y9X3t9aCCUKqHMgmFaVyh9Uvrjacy5v24Os9jmMkPsvN64QOyoT
	GrSQ4GavS0T0uql/touUiDLrsFUEWHc6RpJ5uiM+nrHX1b5++/Y9+L0USe52YXTnKnHLx20ojbX
	Ek+CeIs3yIndZNtSPq1+O//9S8o9RcZVkwcxz91xLk9+3TNP3UmVe3e4NbSVSBQ5AG+Rc0ftgE9
	1uAxw/hL+IewSPz4oH6Mza+k4eVbGf0/a7/k8pxGSJzFq2jiJilg0+AIz1wsdIJNYe23T9XorIL
	tZAsVkBJa9IB7ThH/b4lLoW9e7U1UDz9v+Yx+WQzmJinaIyfUrxrqmODo5jbwNOJJdU/YRnOUad
	t3q0AB8pH0/kV9d6S8HJPWrg8X/9CSDcFvY6PR3PcV7w9CqvJ25Aa8S1qDVDYI+uyCOSrKKVQmZ
	UxQ0rKDcpmwaQD1izYYpLfqhYWagxX9/l0YIjv+31AUB6r/v30AxVOYy9uq7wKzdO7SbgQCvHDa
	SI9hSK7BG1YAUrWjWQhOu4z7+FJD8UnZj0xmlXo/MkS3gaoRk9Gptt3lpB8/R9Ok57SPtX4drjK
	WCcu47/wOo8bYf+cBjQv4=
X-Received: by 2002:a05:690e:140e:b0:675:3d40:3c34 with SMTP id 956f58d0204a3-67bb3041657mr1552875d50.68.1793493220725;
        Sat, 31 Oct 2026 17:33:40 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:6f84:fe3e:51d2:f3cd? ([2600:1700:6476:1430:6f84:fe3e:51d2:f3cd])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b7198c65sm28593177b3.36.2026.10.31.17.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 17:33:39 -0700 (PDT)
Message-ID: <39d08fa0b0e45c61dbb4f57ccc911d1235ff9b5f.camel@dubeyko.com>
Subject: Re: [PATCH v2 13/34] hfsplus: don't set SB_RDONLY when creating the
 attributes tree
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
 Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
	ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 linux-btrfs@vger.kernel.org, 	gfs2@lists.linux.dev,
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-xfs@vger.kernel.org
Date: Sat, 31 Oct 2026 17:33:37 -0700
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-13-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
	 <20261029-work-fs-sb_rdonly-v2-13-2f44f64f0b66@kernel.org>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0

On Thu, 2026-10-29 at 17:07 +0100, Christian Brauner wrote:
> hfs_btree_open() sets SB_RDONLY when the map record of a b-tree
> doesn't
> mark the header node as used. That's fine while mounting. But
> hfsplus_create_attributes_file() calls it too when the first extended
> attribute is set on a filesystem that has no attributes file yet.
> That
> runs on the live filesystem without s_umount and a filesystem must
> not
> change SB_RDONLY behind the VFS' back.
>=20
> hfsplus_create_attributes_file() opens a tree it has just created
> itself
> with the header node marked as used, so there's nothing to check
> there.
> Move the check into hfsplus_fill_super() and do it for every tree it
> opens. No functional changes.
>=20
> Suggested-by: Viacheslav Dubeyko <slava@dubeyko.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/hfsplus/btree.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 42 +++++++++++++=
+++++++++++++++-----------
> ---
> =C2=A0fs/hfsplus/hfsplus_fs.h |=C2=A0 1 +
> =C2=A0fs/hfsplus/super.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 5 +++++
> =C2=A03 files changed, 34 insertions(+), 14 deletions(-)
>=20
> diff --git a/fs/hfsplus/btree.c b/fs/hfsplus/btree.c
> index bd4dbdbc8f98..4a67569050e3 100644
> --- a/fs/hfsplus/btree.c
> +++ b/fs/hfsplus/btree.c
> @@ -270,7 +270,6 @@ struct hfs_btree *hfs_btree_open(struct
> super_block *sb, u32 id)
> =C2=A0	struct hfs_btree *tree;
> =C2=A0	struct hfs_btree_header_rec *head;
> =C2=A0	struct address_space *mapping;
> -	struct hfs_bnode *node;
> =C2=A0	struct inode *inode;
> =C2=A0	struct page *page;
> =C2=A0	unsigned int size;
> @@ -381,19 +380,6 @@ struct hfs_btree *hfs_btree_open(struct
> super_block *sb, u32 id)
> =C2=A0	kunmap_local(head);
> =C2=A0	put_page(page);
> =C2=A0
> -	node =3D hfs_bnode_find(tree, HFSPLUS_TREE_HEAD);
> -	if (IS_ERR(node))
> -		goto free_inode;
> -
> -	if (!hfs_bmap_test_bit(node, 0)) {
> -		pr_warn("(%s): %s (cnid 0x%x) map record invalid or
> bitmap corruption detected, forcing read-only.\n",
> -				sb->s_id, hfs_btree_name(id), id);
> -		pr_warn("Run fsck.hfsplus to repair.\n");
> -		sb->s_flags |=3D SB_RDONLY;
> -	}
> -
> -	hfs_bnode_put(node);
> -
> =C2=A0	return tree;
> =C2=A0
> =C2=A0 fail_page:
> @@ -407,6 +393,34 @@ struct hfs_btree *hfs_btree_open(struct
> super_block *sb, u32 id)
> =C2=A0	return NULL;
> =C2=A0}
> =C2=A0
> +/*
> + * Check the map record of a b-tree at mount. hfs_btree_open() can't
> do it
> + * because hfsplus_create_attributes_file() calls it on the live
> filesystem
> + * where SB_RDONLY must not be set.
> + */
> +int hfsplus_btree_check_map(struct hfs_btree *tree)
> +{
> +	struct super_block *sb =3D tree->sb;
> +	struct hfs_bnode *node;
> +
> +	node =3D hfs_bnode_find(tree, HFSPLUS_TREE_HEAD);
> +	if (IS_ERR(node)) {
> +		pr_err("failed to load %s header node\n",
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hfs_btree_name(tree->cnid));
> +		return PTR_ERR(node);
> +	}
> +
> +	if (!hfs_bmap_test_bit(node, 0)) {
> +		pr_warn("(%s): %s (cnid 0x%x) map record invalid or
> bitmap corruption detected, forcing read-only.\n",
> +				sb->s_id, hfs_btree_name(tree-
> >cnid), tree->cnid);
> +		pr_warn("Run fsck.hfsplus to repair.\n");
> +		sb->s_flags |=3D SB_RDONLY;
> +	}
> +
> +	hfs_bnode_put(node);
> +	return 0;
> +}
> +
> =C2=A0/* Release resources used by a btree */
> =C2=A0void hfs_btree_close(struct hfs_btree *tree)
> =C2=A0{
> diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
> index 6f240f87f8ff..58c780b09b6f 100644
> --- a/fs/hfsplus/hfsplus_fs.h
> +++ b/fs/hfsplus/hfsplus_fs.h
> @@ -362,6 +362,7 @@ int hfsplus_block_free(struct super_block *sb,
> u32 offset, u32 count);
> =C2=A0u32 hfsplus_calc_btree_clump_size(u32 block_size, u32 node_size, u6=
4
> sectors,
> =C2=A0				=C2=A0 int file_id);
> =C2=A0struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id);
> +int hfsplus_btree_check_map(struct hfs_btree *tree);
> =C2=A0void hfs_btree_close(struct hfs_btree *tree);
> =C2=A0int hfs_btree_write(struct hfs_btree *tree);
> =C2=A0int hfs_bmap_reserve(struct hfs_btree *tree, u32 rsvd_nodes);
> diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
> index ff7d6b3336a6..532f23502df3 100644
> --- a/fs/hfsplus/super.c
> +++ b/fs/hfsplus/super.c
> @@ -564,6 +564,11 @@ static int hfsplus_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	}
> =C2=A0	sb->s_xattr =3D hfsplus_xattr_handlers;
> =C2=A0
> +	if (hfsplus_btree_check_map(sbi->ext_tree) ||
> +	=C2=A0=C2=A0=C2=A0 hfsplus_btree_check_map(sbi->cat_tree) ||
> +	=C2=A0=C2=A0=C2=A0 (sbi->attr_tree && hfsplus_btree_check_map(sbi-
> >attr_tree)))
> +		goto out_close_attr_tree;
> +
> =C2=A0	inode =3D hfsplus_iget(sb, HFSPLUS_ALLOC_CNID);
> =C2=A0	if (IS_ERR(inode)) {
> =C2=A0		pr_err("failed to load allocation file\n");


Looks good.

Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>

Thanks,
Slava.
