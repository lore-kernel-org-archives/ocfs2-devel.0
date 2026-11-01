Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793494173;
	b=TC6SCJADyXTQP7xQJl9AokICqLSQ4pqa2kUl6ePm3wJ0rYSyBfMVuz2VxsKMeuLyR+nh
	 XBbat3ECwBk8ZFv++72quk4dexuqmgKJfMH63lFtYq1jd2oBLoW1aQCQgOBf2wt5agTHe
	 prH4XnKdWGJXV1veK58jsRobcP+kkJVB38hRQqy7WSJDhePv7u2gtxXNv5RsuIXItj6Lg
	 8j7icvXUBhywKNZQJtsB6J5fywi6e6rpVbp7hVQmgUdUEB84WhmsctTCaPL2sq7+AbnaZ
	 M9YZYE8QwNQ7ChGvtyhjp/Y4dZQHUPY0aaM0T89WXkTAXvwf4N+luKGnrg3Zb7eKYNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793494173;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:Autocrypt:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=EUpJKvz8mlj+rANwwFPIVtc0TayK+TWucETEd0TlynI=;
	b=uFMNcnxNUySTcp0q6YFjxuot7QLKyW1uFr8NOwFKgxrmOdWLO0PRXU0I/v8dsGlfdFO0
	 M416kPQ47ulfWlIXcxyEmYeE3gNc/ZarDfb0LLiV/fYz8/6a0ybVi/JmsZ6e0Rz36BIUl
	 4WG7XTnZ7kIYa3o9w+Op1Trz3mMus3yRpjDAayefL58xNI0iUIoNf+mSUFMKi43qOu+1U
	 8ITwV+l2eVn0YM98HgzYRIEjnYWcVfidVta8rB64/CA2SY2cbiuEivXSJMgEULb84JxOE
	 cAC1N9ehDgg5mQS+j/oG2hP8CgLDfQd+EI31GhH2WNNGQKn1PbQY3DU9NWyIqVUDwJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dubeyko.com;
	spf=pass smtp.mailfrom=dubeyko.com;
	dkim=pass header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=GNR8XfGG;
	arc=none smtp.remote-ip=209.85.128.174
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C447606A321
	for <ocfs2-devel@lists.linux.dev>; Sun,  1 Nov 2026 00:49:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C447606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=GNR8XfGG
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8ac9d666d4eso17077427b3.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 31 Oct 2026 17:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20260707.gappssmtp.com; s=20260707; t=1793494172; x=1794098972; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EUpJKvz8mlj+rANwwFPIVtc0TayK+TWucETEd0TlynI=;
        b=GNR8XfGG4iR28bAHXEqIifKRc1/T0Ypim7Xdo19awjlhuyJ9cPOeQGXkHt0nZgaKVo
         QnB6sIn+rc1C7TlFEaIb7EdPk7FQNIgwsDmAOjDwMogr3q1iT/2Dvaz7Om+FPsI4eE/d
         ztlheGBIhPe+OuwmlgZ08/oyOChfZ6PJ1/dGncKlH2RqEZbcERn+y100b9C8uUKLyBqZ
         jCRVfFFnS5n6Jfu/+zCWRwYA3ahg1cIa5sdVVmJaFM8Ng+k4vmEN265bPrLUjvKRW2Gx
         rBZ5NPoqYFffvbpEizWZYZ+WN4EWhMIGTqLVvFrgluzb013hrnlUcmI5Tw8hDL112oyp
         kjsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793494172; x=1794098972;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=EUpJKvz8mlj+rANwwFPIVtc0TayK+TWucETEd0TlynI=;
        b=y3HAshfU+KohQJ9zXNXU8O8CkkiGnVBcS8snQDJleyB/W6gDQWDRZunV4WRQ8K5V8d
         vsRSuXxT0mh/SV0X4zhd1nRPBbjUrMzjvohulTWR/QQyH697CiNiXFqH7cy//6zizzAb
         /Id96IAhDCaQwnv6NqBGm6WzIGcinIaWf/iGK5wGdv8EArTw91CASNVO+4ieRKFOx8PI
         ma41tYV76Up7IZAayEA7invCvqe1Vtolx0zEYn2PgtSyqCr8Tbl5/cpuiLU6kvm85Qcn
         Di8AkiVsz8MWVrXl0p5J8m1/ORRWSVjycDOmL2e2mDY/1VStZdp7BdhpFMvFpWfxk/yT
         ABzQ==
X-Forwarded-Encrypted: i=1; AKwUvBybc4+aK87Ubd7xP2ocziGzDAZyf0iuN3oZc5vzLlHDOPYZMhZyBfNJ4jslZu/z5A/SYsv9roL6p7/lQg==@lists.linux.dev
X-Gm-Message-State: APuU4Z+Aumvl7RJEG0fg/3JiqSFIsIhA1OxokxuGW9wX6Aj9KoYCA1BD
	hXR5UtVc1IHjA2rr31XeUwI71zF9zMXbpSp7rM4qK1HZsMLkxLlg4e1Sl+DDUkmG37o=
X-Gm-Gg: AYBFou0ZV09VteFH80PllNNUCjAffi+Qk11mGZQIumJJpE00xXYdBMP/6ux4OYQ7tFH
	oE74UtQhJJpyMQ5XeQFnw+pHH6Y851j9S9MhQu1emBH7XMC/RYjxvFN59R6gAWajaSe0CFPSdvU
	/4MJ4XcBb9C3EIZ3vlnfs+NAldHjThCB9NfFc1SSU9zFkDk23S+AW7iq5zwMq/Bme6tUVgx5sdy
	5RJsu+v1AQ0EzfRy+XkiVoV4X6yWlQLx5dm4umx0ymLxVmmq0XOUnZbzozz6iJxxFCzzC1+RP0B
	eHHT6gu/luKruD8pFmMh3NImW9g0EI/0gtQ7TYS1TDqUGNfga6e/0sByWkYd/XPb2QPoM8oN5cU
	I5VECjdt8ydfgC0iT+8594kgOBC5K6WrWOxnVdKJHGPYSQHtYNReMW03X55ruVHihiTCPinGNUb
	b1EuYH2cJfqyyE9VnhynbbVrnWTFcqEXqysQSmovcoBbi8/yAjMyjNTXkflKMq5EWtd0I6+RgAB
	+ZfAyjI9PYw0zyGmQtOHcbzn5PTTCzVGCdr61Hgxe8lhnhLf2Iw4+MfzKzkroxIIboxOfWh3vRX
	uyDwQAfvYNrSVqKNQy6/f3KzlwmY6zviZIaUgw2U+a4yz93kyepryae4Ad0VvnDfFvo7x4nnW2O
	Wxsmh4KlgaLuMEjzxVYaciSQLjXjqFZntNnrEfSTSxQWPHZT2U9jkHA06+oKVZAbsjsWYJ8E3im
	K6in46dyUWOMZ2PsVMjuU=
X-Received: by 2002:a05:690c:6b01:b0:8b1:810d:276 with SMTP id 00721157ae682-8b2b66e9a50mr29543167b3.34.1793494172036;
        Sat, 31 Oct 2026 17:49:32 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:6f84:fe3e:51d2:f3cd? ([2600:1700:6476:1430:6f84:fe3e:51d2:f3cd])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b71bd543sm29098627b3.45.2026.10.31.17.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 17:49:30 -0700 (PDT)
Message-ID: <49d219dab3cb6411a1626efe78070d1aed94e96b.camel@dubeyko.com>
Subject: Re: [Jfs-discussion] [PATCH v2 12/34] hfs: use the generic
 emergency read-only state
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
 Jan Kara <jack@suse.com>
Cc: ntfs@lists.linux.dev, linux-xfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, 
	linux-mm@kvack.org, ocfs2-devel@lists.linux.dev, ecryptfs@vger.kernel.org, 
	gfs2@lists.linux.dev, exfat@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
Date: Sat, 31 Oct 2026 17:49:29 -0700
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-12-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
	 <20261029-work-fs-sb_rdonly-v2-12-2f44f64f0b66@kernel.org>
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

On Thu, 2026-10-29 at 17:07 +0100, Christian Brauner via Jfs-discussion
wrote:
> Set SB_STATE_EMERGENCY_RO instead of a private bit and drop the
> checks
> the VFS does now. What's left is hfs_get_block(),
> hfs_file_truncate(),
> write_begin, O_DIRECT writes, the hfs.type and hfs.creator xattrs,
> hfs_write_inode() which still writes the b-tree headers, and the MDB
> commit, close and dirtying paths.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/hfs/attr.c=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0fs/hfs/dir.c=C2=A0=C2=A0=C2=A0 | 12 ------------
> =C2=A0fs/hfs/extent.c |=C2=A0 4 ++--
> =C2=A0fs/hfs/hfs_fs.h | 11 -----------
> =C2=A0fs/hfs/inode.c=C2=A0 | 20 ++++----------------
> =C2=A0fs/hfs/mdb.c=C2=A0=C2=A0=C2=A0 |=C2=A0 8 ++++----
> =C2=A0fs/hfs/super.c=C2=A0 |=C2=A0 5 +----
> =C2=A07 files changed, 12 insertions(+), 50 deletions(-)
>=20
> diff --git a/fs/hfs/attr.c b/fs/hfs/attr.c
> index bd9a1289d8c5..337b22f28208 100644
> --- a/fs/hfs/attr.c
> +++ b/fs/hfs/attr.c
> @@ -129,7 +129,7 @@ static int hfs_xattr_set(const struct
> xattr_handler *handler,
> =C2=A0	if (!value)
> =C2=A0		return -EOPNOTSUPP;
> =C2=A0
> -	if (unlikely(hfs_emergency_ro(inode->i_sb)))
> +	if (unlikely(sb_emergency_ro(inode->i_sb)))
> =C2=A0		return -EROFS;
> =C2=A0
> =C2=A0	return __hfs_setxattr(inode, handler->flags, value, size,
> flags);
> diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
> index f0d8ddb07503..f6b97da19788 100644
> --- a/fs/hfs/dir.c
> +++ b/fs/hfs/dir.c
> @@ -189,9 +189,6 @@ static int hfs_create(const struct mnt_idmap
> *idmap, struct inode *dir,
> =C2=A0	struct inode *inode;
> =C2=A0	int res;
> =C2=A0
> -	if (unlikely(hfs_emergency_ro(dir->i_sb)))
> -		return -EROFS;
> -
> =C2=A0	inode =3D hfs_new_inode(dir, &dentry->d_name, mode);
> =C2=A0	if (IS_ERR(inode))
> =C2=A0		return PTR_ERR(inode);
> @@ -222,9 +219,6 @@ static struct dentry *hfs_mkdir(const struct
> mnt_idmap *idmap, struct inode *dir
> =C2=A0	struct inode *inode;
> =C2=A0	int res;
> =C2=A0
> -	if (unlikely(hfs_emergency_ro(dir->i_sb)))
> -		return ERR_PTR(-EROFS);
> -
> =C2=A0	inode =3D hfs_new_inode(dir, &dentry->d_name, mode);
> =C2=A0	if (IS_ERR(inode))
> =C2=A0		return ERR_CAST(inode);
> @@ -258,9 +252,6 @@ static int hfs_remove(struct inode *dir, struct
> dentry *dentry)
> =C2=A0	struct inode *inode =3D d_inode(dentry);
> =C2=A0	int res;
> =C2=A0
> -	if (unlikely(hfs_emergency_ro(sb)))
> -		return -EROFS;
> -
> =C2=A0	if (S_ISDIR(inode->i_mode) && inode->i_size !=3D 2)
> =C2=A0		return -ENOTEMPTY;
> =C2=A0
> @@ -299,9 +290,6 @@ static int hfs_rename(const struct mnt_idmap
> *idmap, struct inode *old_dir,
> =C2=A0	if (flags & ~RENAME_NOREPLACE)
> =C2=A0		return -EINVAL;
> =C2=A0
> -	if (unlikely(hfs_emergency_ro(old_dir->i_sb)))
> -		return -EROFS;
> -
> =C2=A0	/* Unlink destination if it already exists */
> =C2=A0	if (d_really_is_positive(new_dentry)) {
> =C2=A0		res =3D hfs_remove(new_dir, new_dentry);
> diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
> index dacf7ce1ffe4..fd874a93a92f 100644
> --- a/fs/hfs/extent.c
> +++ b/fs/hfs/extent.c
> @@ -357,7 +357,7 @@ int hfs_get_block(struct inode *inode, sector_t
> block,
> =C2=A0			return -EIO;
> =C2=A0		if (ablock >=3D HFS_I(inode)->alloc_blocks) {
> =C2=A0			/* No new allocations after an error. */
> -			if (unlikely(hfs_emergency_ro(sb)))
> +			if (unlikely(sb_emergency_ro(sb)))
> =C2=A0				return -EROFS;
> =C2=A0			res =3D hfs_extend_file(inode);
> =C2=A0			if (res)
> @@ -494,7 +494,7 @@ void hfs_file_truncate(struct inode *inode)
> =C2=A0	hfs_dbg("ino %llu, phys_size %llu -> i_size %llu\n",
> =C2=A0		inode->i_ino, (long long)HFS_I(inode)->phys_size,
> =C2=A0		inode->i_size);
> -	if (unlikely(hfs_emergency_ro(sb)))
> +	if (unlikely(sb_emergency_ro(sb)))
> =C2=A0		return;
> =C2=A0	if (inode->i_size > HFS_I(inode)->phys_size) {
> =C2=A0		struct address_space *mapping =3D inode->i_mapping;
> diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
> index 325214573d91..fdfa5d303d5e 100644
> --- a/fs/hfs/hfs_fs.h
> +++ b/fs/hfs/hfs_fs.h
> @@ -143,7 +143,6 @@ struct hfs_sb_info {
> =C2=A0#define HFS_FLG_BITMAP_DIRTY	0
> =C2=A0#define HFS_FLG_MDB_DIRTY	1
> =C2=A0#define HFS_FLG_ALT_MDB_DIRTY	2
> -#define HFS_FLG_EMERGENCY_RO	3	/* read-only after an MDB
> write error */
> =C2=A0
> =C2=A0/* bitmap.c */
> =C2=A0extern u32 hfs_vbm_search_free(struct super_block *sb, u32 goal, u3=
2
> *num_bits);
> @@ -294,16 +293,6 @@ static inline const char *hfs_mdb_name(struct
> super_block *sb)
> =C2=A0	return sb->s_id;
> =C2=A0}
> =C2=A0
> -/*
> - * Writing back the MDB failed and the filesystem stopped all
> modifications
> - * until unmount. SB_RDONLY isn't used for that because it must not
> change
> - * without s_umount.
> - */
> -static inline bool hfs_emergency_ro(struct super_block *sb)
> -{
> -	return test_bit(HFS_FLG_EMERGENCY_RO, &HFS_SB(sb)->flags);
> -}
> -
> =C2=A0static inline void hfs_bitmap_dirty(struct super_block *sb)
> =C2=A0{
> =C2=A0	set_bit(HFS_FLG_BITMAP_DIRTY, &HFS_SB(sb)->flags);
> diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
> index 6ea3b8ffb284..71f7ddf60fb2 100644
> --- a/fs/hfs/inode.c
> +++ b/fs/hfs/inode.c
> @@ -54,7 +54,7 @@ int hfs_write_begin(const struct kiocb *iocb,
> struct address_space *mapping,
> =C2=A0	loff_t total_capacity;
> =C2=A0	int ret;
> =C2=A0
> -	if (unlikely(hfs_emergency_ro(inode->i_sb)))
> +	if (unlikely(sb_emergency_ro(inode->i_sb)))
> =C2=A0		return -EROFS;
> =C2=A0
> =C2=A0	total_capacity =3D (loff_t)sbi->fs_ablocks * sbi->alloc_blksz;
> @@ -143,7 +143,7 @@ static ssize_t hfs_direct_IO(struct kiocb *iocb,
> struct iov_iter *iter)
> =C2=A0	ssize_t ret;
> =C2=A0
> =C2=A0	if (iov_iter_rw(iter) =3D=3D WRITE &&
> -	=C2=A0=C2=A0=C2=A0 unlikely(hfs_emergency_ro(inode->i_sb)))
> +	=C2=A0=C2=A0=C2=A0 unlikely(sb_emergency_ro(inode->i_sb)))
> =C2=A0		return -EROFS;
> =C2=A0
> =C2=A0	ret =3D blockdev_direct_IO(iocb, inode, iter, hfs_get_block);
> @@ -479,11 +479,8 @@ int hfs_write_inode(struct inode *inode, struct
> writeback_control *wbc)
> =C2=A0	int res;
> =C2=A0
> =C2=A0	hfs_dbg("ino %llu\n", inode->i_ino);
> -	if (unlikely(hfs_emergency_ro(inode->i_sb))) {
> -		/*
> -		 * Writeback still writes the b-tree nodes. Keep the
> headers in
> -		 * sync with them so the trees on disk stay intact.
> -		 */
> +	if (unlikely(sb_emergency_ro(inode->i_sb))) {
> +		/* Keep the headers in sync with the nodes writeback
> still writes. */
> =C2=A0		if (inode->i_ino =3D=3D HFS_EXT_CNID)
> =C2=A0			hfs_btree_write(HFS_SB(inode->i_sb)-
> >ext_tree);
> =C2=A0		else if (inode->i_ino =3D=3D HFS_CAT_CNID)
> @@ -640,8 +637,6 @@ void hfs_evict_inode(struct inode *inode)
> =C2=A0
> =C2=A0static int hfs_file_open(struct inode *inode, struct file *file)
> =C2=A0{
> -	if ((file->f_mode & FMODE_WRITE) && hfs_emergency_ro(inode-
> >i_sb))
> -		return -EROFS;
> =C2=A0	if (HFS_IS_RSRC(inode))
> =C2=A0		inode =3D HFS_I(inode)->rsrc_inode;
> =C2=A0	atomic_inc(&HFS_I(inode)->opencnt);
> @@ -673,9 +668,6 @@ int hfs_inode_setattr(const struct mnt_idmap
> *idmap, struct dentry *dentry,
> =C2=A0	struct hfs_sb_info *hsb =3D HFS_SB(inode->i_sb);
> =C2=A0	int error;
> =C2=A0
> -	if (unlikely(hfs_emergency_ro(inode->i_sb)))
> -		return -EROFS;
> -
> =C2=A0	error =3D setattr_prepare(&nop_mnt_idmap, dentry, attr);
> =C2=A0	if (error)
> =C2=A0		return error;
> @@ -727,10 +719,6 @@ static int hfs_file_fsync(struct file *filp,
> loff_t start, loff_t end,
> =C2=A0	struct super_block * sb;
> =C2=A0	int ret, err;
> =C2=A0
> -	/* Inodes aren't written back after an error. */
> -	if (unlikely(hfs_emergency_ro(inode->i_sb)))
> -		return -EROFS;
> -
> =C2=A0	ret =3D file_write_and_wait_range(filp, start, end);
> =C2=A0	if (ret)
> =C2=A0		return ret;
> diff --git a/fs/hfs/mdb.c b/fs/hfs/mdb.c
> index 1a56cf5ea56e..b821b06121ad 100644
> --- a/fs/hfs/mdb.c
> +++ b/fs/hfs/mdb.c
> @@ -338,7 +338,7 @@ int hfs_mdb_commit(struct super_block *sb)
> =C2=A0	struct hfs_mdb *mdb =3D HFS_SB(sb)->mdb;
> =C2=A0	int ret =3D 0;
> =C2=A0
> -	if (sb_rdonly(sb) || hfs_emergency_ro(sb))
> +	if (sb_rdonly(sb) || sb_emergency_ro(sb))
> =C2=A0		return 0;
> =C2=A0
> =C2=A0	/*
> @@ -347,7 +347,7 @@ int hfs_mdb_commit(struct super_block *sb)
> =C2=A0	 */
> =C2=A0	if (!buffer_uptodate(HFS_SB(sb)->mdb_bh)) {
> =C2=A0		pr_err("primary MDB is corrupt, mounting read-
> only\n");
> -		set_bit(HFS_FLG_EMERGENCY_RO, &HFS_SB(sb)->flags);
> +		sb_set_emergency_ro(sb);
> =C2=A0		return -EIO;
> =C2=A0	}
> =C2=A0
> @@ -381,7 +381,7 @@ int hfs_mdb_commit(struct super_block *sb)
> =C2=A0	=C2=A0=C2=A0=C2=A0 HFS_SB(sb)->alt_mdb) {
> =C2=A0		if (!buffer_uptodate(HFS_SB(sb)->alt_mdb_bh)) {
> =C2=A0			pr_err("alternate MDB is corrupt, mounting
> read-only\n");
> -			set_bit(HFS_FLG_EMERGENCY_RO, &HFS_SB(sb)-
> >flags);
> +			sb_set_emergency_ro(sb);
> =C2=A0			ret =3D -EIO;
> =C2=A0			goto out;
> =C2=A0		}
> @@ -432,7 +432,7 @@ int hfs_mdb_commit(struct super_block *sb)
> =C2=A0void hfs_mdb_close(struct super_block *sb)
> =C2=A0{
> =C2=A0	/* update volume attributes */
> -	if (sb_rdonly(sb) || hfs_emergency_ro(sb))
> +	if (sb_rdonly(sb) || sb_emergency_ro(sb))
> =C2=A0		return;
> =C2=A0
> =C2=A0	if (!buffer_uptodate(HFS_SB(sb)->mdb_bh))
> diff --git a/fs/hfs/super.c b/fs/hfs/super.c
> index bcc19c3a4f6b..c815d22ab900 100644
> --- a/fs/hfs/super.c
> +++ b/fs/hfs/super.c
> @@ -82,7 +82,7 @@ void hfs_mark_mdb_dirty(struct super_block *sb)
> =C2=A0	struct hfs_sb_info *sbi =3D HFS_SB(sb);
> =C2=A0	unsigned long delay;
> =C2=A0
> -	if (sb_rdonly(sb) || hfs_emergency_ro(sb))
> +	if (sb_rdonly(sb) || sb_emergency_ro(sb))
> =C2=A0		return;
> =C2=A0
> =C2=A0	spin_lock(&sbi->work_lock);
> @@ -131,9 +131,6 @@ static int hfs_reconfigure(struct fs_context *fc)
> =C2=A0		return 0;
> =C2=A0
> =C2=A0	if (!(fc->sb_flags & SB_RDONLY)) {
> -		/* After an MDB write error it stays read-only until
> unmount. */
> -		if (hfs_emergency_ro(sb))
> -			return -EROFS;
> =C2=A0		if (!(HFS_SB(sb)->mdb->drAtrb &
> cpu_to_be16(HFS_SB_ATTRIB_UNMNT))) {
> =C2=A0			pr_warn("filesystem was not cleanly
> unmounted, running fsck.hfs is recommended.=C2=A0 leaving read-only.\n");
> =C2=A0			sb->s_flags |=3D SB_RDONLY;

Looks good.

Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>

Thanks,
Slava.
