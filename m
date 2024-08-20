Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543A9190670
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 13:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724162177; cv=none; b=Yv/DBgqZ9eDv5h91wMr/4YC8MSl352Opdr3uau45ArFNSZ0Gcs3fAyLYOU3JWrBmsxIGytd7jj9fEI+lDMNGcBTj+XsB44ASqW8LcmZg+Y3U5ytRWHN5Tt+5l9xhGzJVyrPO2J6LN4m1xAAWyQZDx45UTfJV5Yk0Z95fPiIZLvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724162177; c=relaxed/simple;
	bh=55jJYgOUczFj86iKSrhJP2mQI8SrM2z+EKFOQSKC2Ug=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=IGfcUQVHCtnHESsfIW+qbFz6U4VayBpSJ4Wm8B0MAga9gUDb+9mZc21lq8swhvnwPy1RhFniRjCQWkHTqENCs6nmVEduhLTyo0DDsk+plnK8GF0D3dWHPsR4/d+k8Gp5WSbFzJ5qgYoMoSR1QNJkuuELAMfNVDYP9az7jnUQIBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=ewG5yDD2; arc=none smtp.client-ip=162.62.58.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="ewG5yDD2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1724162162; bh=7w2ZeBRO8dWCQ5Ju3weMtW2rPYoozSsTikvsgwQXQ60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewG5yDD29nwKk/wz1GJCsaz9Q0u/EX+YSDykZEamWFy/eSWhtYWQszkeTQcw7jBFU
	 YRT8rBNxqiyC7WCMaN75JMTq0kY8dsJCxNeWmlBOyTS3A6G5IwJul61yw+srLOd7kk
	 Rbaic2QWyB6Ijg8syLsIP+2mUvLkvJPkc1F61iPk=
Received: from pek-lxu-l1.wrs.com ([111.198.225.4])
	by newxmesmtplogicsvrszb9-0.qq.com (NewEsmtp) with SMTP
	id DE680CCA; Tue, 20 Aug 2024 21:55:38 +0800
X-QQ-mid: xmsmtpt1724162138tw1xzbvi4
Message-ID: <tencent_16A450176CD77A86C8536B8366297C03A105@qq.com>
X-QQ-XMAILINFO: NMGzQWUSIfvTPOzuldNXnGcmcxVJyiZqBUaZ/eqKMv37A08Aq287QLK1GsQIGQ
	 s5vLdnv1VefJJ+MUbLyCxWXUkgczqmfyrzjmMsYec6i976yV4Iz+cD8kVhij4gx2W1HwZLsj+sY8
	 IFVisBloGxenpUM0Xkmn1TUr7obA6InYSKyO8gzuKl25QedHAc7LaAhQL14JZosnfWOQgOK0HgQC
	 aBsrQMaygwKTPcZMUWZxG5gWN2XKTV7XzmYuAKkMua95uBNlBMk493eBIKEhh0WGNdjC2kxbqB0g
	 eEv3g70j0wIA55Dwk3V3/cVzzFlmQk4MS2pgls5TSiMEL0I0IcnYHjV6nYBnX4aYibnmvNpyS6lU
	 QumZC/DJCTbMHfl3RIKgkDIY0GW+PVUQQM4yaM7nTztq8Xb4uvN3wg3M1FvHYj0+GY4hUgAOfqTp
	 xtnu+Pd/xXwU8W9E40Hbh0WzDmp+YwiAaVwOa2b0LBgzISQcYhqMoKnuSprnUC1fZN2htoTXBfXv
	 xM7sSlH5PSFwWNyHQxVK0xuVlooau9wF8KJRYBl682OfzeN/NT/h+BW6t1vb/nNYaGBPJ1skbBoV
	 dqh8h5rzRI8ZdXacw8WhfhAuPHWhmEkJnYlCG1fN6eB68HdUu7ctMYiqeXezgygiB8Gixf26CBbD
	 5YKb+6RVJoL0nbbW/b7kqoIhe6YUdtZ/0hx4wNUUk+oC/Jw39SWMR3J+syp/z21XhYh806/QO8gY
	 hp9v1H4xO4G4BFf4k++B9gC0j0isP5AVxQ/gPDtGXo2vS43SI50okpqgaDov8EUk8meLeP4F6nOH
	 K6SopTH49Mikpv41L3K1cs4XvLvsoZdHOkYhIS913xhKy4iswkt4H6RewAcyAiEKNiS975k96jd6
	 5HHKSHceUMH4fogKc7lQ64LGoH1DYcQNGN0kFDk/wBWW13QEhU8c5HI+FnjazkGYIFHEV3MsamuZ
	 XZdZm0fINM4UmcVWY/T0cNpwU8rkTb
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
From: Edward Adam Davis <eadavis@qq.com>
To: joseph.qi@linux.alibaba.com
Cc: eadavis@qq.com,
	jlbec@evilplan.org,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] ocfs2: Add i_size check for dir
Date: Tue, 20 Aug 2024 21:55:39 +0800
X-OQ-MSGID: <20240820135538.4048106-2-eadavis@qq.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <205e0d29-2567-4d82-a024-a8e7826d9f18@linux.alibaba.com>
References: <205e0d29-2567-4d82-a024-a8e7826d9f18@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 20 Aug 2024 20:44:37 +0800, Joseph Qi wrote:
> > When the i_size of dir is too large, it will cause limit to overflow and
> > be less than de_buf, ultimately resulting in last_de not being initialized
> > and causing uaf issue.
> >
> > Reported-and-tested-by: syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com
> > Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> > ---
> >  fs/ocfs2/dir.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> > index d620d4c53c6f..c308dba6d213 100644
> > --- a/fs/ocfs2/dir.c
> > +++ b/fs/ocfs2/dir.c
> > @@ -3343,6 +3343,8 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
> >  	unsigned long offset = 0;
> >  	unsigned int rec_len, new_rec_len, free_space;
> >
> > +	if (i_size_read(dir) > OCFS2_MAX_BLOCKSIZE)
> > +		return -EINVAL;
> 
> Why OCFS2_MAX_BLOCKSIZE?
I think it is largest block size in ocfs2, therefore, if it is larger
than it, it must be incorrect, even though the value of i_size in dir
in the current issue is much larger than it (i_size_read(dir) is 0x900000000000100).
> It seems that this is caused by a corrupted dir inode, since this is an
> inline case, we may try best to make sure it won't exceeds block size?
> i.e. dir->i_sb->s_blocksize.
You mean dir->i_sb->s_blocksize bigger than OCFS2_MAX_BLOCKSIZE?

BR,
Edward

