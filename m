Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794698411;
	b=Bdwb34t4Lbcq1iswvcWDVt7DI44a+x9pbkUhuIOCPxXK63dBEPgT/Lh1wu60Tuk5jL+y
	 XEyEE1Vn+WEXp1dUFrpMmo3PnmoLj2b/FtnkzXJgroW4hqOJEU+AlnNpdfLktzgP0fN1O
	 AQcYq6cf3iC8z0Clrg9AXxDjKhbJ3WT0iIbu/um4BiD29Z5l5nv6Kv3Vxi/CMYrl5auC3
	 kBRN6k70bOIN3KkK9e1G1f/OWUXWnGWHr3LxqcnpwxsL30pYE+wKyOgru59rx0FnLoEY4
	 QHlVLxx6uV5vhQOwURZzy9aJl6xswCiJAl6pey2sGIURRsS21Mt2cS2cieDzcD5iFZQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794698411;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
	b=jjOAVhVXnsW5o8WV36S1aYKa+aBD4tEUC5xg4pKlP2lrNc2mKeDRyrTToEGR+EeicD0W
	 aNiw9pm2zKzDo6JlNDCWIDTakG4cCzVE9xwIseIAO/njtJPCtNZOH+njvQPC7yJMc/1Wg
	 iSqSLS67Tjou4cBy6xl58xNHX7oGF7bamADfDIdp+mr+jxXj7BHRtC+qLFeExg2WEi4e5
	 0fi0P8DaEsvChZ3cmYzYmBhEI+3ANx7Uw1e37SnVbr1nz3w0dKoxGYaC1A9I5QYKzZ50p
	 Nt1SBxDFX2mJtpgG1DOvaYn6JmSd6LVZDFQx8/lLUgzGSnftYv6kR1HM0Gv6aSYzBNA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Eq8MMJ7E;
	arc=fail smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E6B606A32D
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Nov 2026 23:20:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9E6B606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Eq8MMJ7E
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b7245ab5e2so5593826a12.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 14 Nov 2026 15:20:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794698409; cv=none;
        d=google.com; s=arc-20260327;
        b=KVOOKb8y1HY4/5R3ik79Vbt3mEzF6EOJHJy83f6kKOZRGP7Dzl+mzujiBikncGiVCr
         EbiUAgmJLEwT5tadjWmcubOT0Npj0Krr0LwGHCs/4LTKr7bFEm9V9lX4J0SzOFP+JcNU
         3hbaZLccnAqDfGukFFfvj5eAi1KBBxjMzRim+1/eIGaAij9KA1NtAdRDgUIW823/ona4
         Agk8X6vybDwosd3U1SpCJYAZ2b5BJgE+LwQwLjik86llnb2/H3aTDLTCKSMMCKTp9Hit
         WmZAu6KlAMOs1MqIfcy1DmE7F5S/svAXK+UHnOydVxr43WPzvv+Ydu0MNFscq/jGvz7I
         fGPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
        fh=XQF6MdF/xT8u68DjXprkBkNULaBbv4G8ZFyuHJU3nKE=;
        b=Q8WPKvUycsmVp2q9nLjrC7gGJmL0Z+qmrBkvJwBi9Jtxaw6nAvDBX44Wfj668GtTXX
         jV1Vz3RqIAjF5eMQhTV7nRhNwa/g7I5WF0pXX4w11qndrkQeLNTjrSX6aFkWzgsKpjXp
         62NSa53ix1sgKZPYdR6glhI+jl7JBqgDtiu4BLfa1kg5bql4p1LHVVLwmYOi/BYDdL2n
         TA+EgKdzu6tgrLhAiBT5z/aOj2Ipt6dqz6NNcuZMT+U4IxFJhik2jN+oEUjzlbZL0vq8
         iLqWuNnEnAgYDOyJThJBns1dKcOsYNaIDWUtqcSpxcWUDPJGWyebEO1eoj6RoTtq4c8J
         vOGw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794698409; x=1795303209; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
        b=Eq8MMJ7EAUM8qhA7gIHpM+wwYLHiJOgQoJ+ONSWGg9YHnntBzB0rQQGaylRPUsVkRp
         wHWgynTCQOm0MDmeIoQHf0/GJxQxpL2+t18UktoVBxzTX6+pLGCxHfi6exFM4TMo1v7/
         ucVawa7jay7kzullFaC44kYAYmggjlQ1b7EX7VyTldo4iEKLWOwtPaPStmEJPoarXtHJ
         DxIIs/swFDQJvrYj2AQ7EecdRorpLL9B16mlALFDZVI81KWhfeKfpN8YID3V6YyOGC4M
         00lkv/2pwqzdaN6edGSCJjyAg93JDetC7d8/w6ObdHXV5W4D21PA4T5132kQFdfc2TcQ
         xaeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794698409; x=1795303209;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
        b=ai1rstKHR4KBpljcAPD6zQWEqTIdcvp27MQShwpf67FEfQfHcgc5McW8UVkVrBrx+S
         YhubdnwWnyltZU9AInfG31JZefmrtgfhXnA9KpEGVyq56vLApkYaK9QqTPKgcaHF5UUy
         XsCpjMqzEmPhuxH8urrLigd7vWSscQD5jImVx+4vyBxBouTA6NipgNWx2TpIEz+3a8/a
         SVQCzw4+i4kds8qXaKDD1ln5F/l0KkR+04gmq0Yy78+i/7MfgT26xal5YyxMLWdV8Sr6
         PJRHF2KsZzhAQTuIgFJxUhN72rhz8VFDdR62xrj7QGHD4SQ876NsYaHadYppldP5zhXL
         KibQ==
X-Forwarded-Encrypted: i=1; AL+hErGmhKgGEDtO8A9uHGpVjQOvRu6xdD7YXu/pIQMwSfjR2AQ9LQ+jeJddZRuLA6LfTABwP67jZsBLwrZ5qA==@lists.linux.dev
X-Gm-Message-State: APuU4Z9vJ+z7oc/oRhVR3E603jqSoeNjdWQmWisjtLKizVu229aVlKgd
	3MHWRii3pN2Zgmji6N7mQIAPKOMv9VSRwOuklaZft40q4ULoGKJXQ6ELVBjLiXnOQF/qjM2Bf4O
	dJKS+1YK82/8BuVqjRNo+kOeZvheNBBw=
X-Gm-Gg: AYBFou1ND8oTVwL1t8KmeAemagapSl/UgjloWckCyWwnSDnjK5xq/Jyb3BV+Tq5Stio
	N9DdiUCxXnwhhTRLds7EXyI4n+rjGLM2jdwNAqQ/pFHaKEdSRMXbtH9ijYUQZo782sp27G1ML2Z
	AgeMvyPjHY/CEG3HHKspKHkhhJLh9TGWdth1Y3oeH5Y51n6tEZLEA7puO50HOQ8cMsZTcRk8C4O
	BZUrmOY3z+a0+GCXyn8GEj2vo+ev0xSWSEAM6+fktww9ZxHLyQmYbW2s3qUzGNshQkOq+gppV84
	KFhyJHPlFW3dvapxliNT+HWoQOM7Pn6T7M8slu5OQRBGQdZq1S22AyX+rRb8rZ1MTBSL5ldPBtX
	ryjhd3saBPkNIYjiPze8HLk2JC1bkqLQqrpM9DfDGhci/b64BeiSpZHQd3TKYMo+HAwMQkg==
X-Received: by 2002:a05:6402:e10:b0:6b7:f00e:5e56 with SMTP id
 4fb4d7f45d1cf-6b7f00e5f37mr1542816a12.1.1794698409123; Sat, 14 Nov 2026
 15:20:09 -0800 (PST)
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
 <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org> <20261114120557.4bc1eb6e57218cdc@chrisdown.name>
In-Reply-To: <20261114120557.4bc1eb6e57218cdc@chrisdown.name>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 15 Nov 2026 00:19:57 +0100
X-Gm-Features: AclHuK_YVxhIpv6JLzeNAX5mX5IHGfu05WS6uQ-TCKewxE3JKeci2PyA-UDMCbo
Message-ID: <CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJHH9T_Yw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 33/42] fs: add file_check_backing()
To: Chris Down <chris@chrisdown.name>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
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

On Sat, Nov 14, 2026 at 9:06=E2=80=AFPM Chris Down <chris@chrisdown.name> w=
rote:
>
> Hi Christian,
>
> Christian Brauner writes:
> >+      /* Look through stacking filesystems at the inode with the data. =
*/
> >+      if (d_real_inode(file->f_path.dentry)->i_sb->s_iflags & SB_I_PSEU=
DO)
> >+              return -EINVAL;
>
> This looks good in general, but what the bots said about O_PATH files
> here is real. With FMODE_PATH this is reached for a file that was never
> opened, so on overlayfs nothing has been through ovl_open() to look up
> the lowerdata of a metacopy file yet. ovl_d_real() then does the lookup
> itself, and when that fails it hits the WARN(1) at its end and returns
> the overlayfs dentry, so the check passes as well.
>
> Only fuse passes FMODE_PATH, so it takes CAP_SYS_ADMIN to get there, but
> it's easy to trigger with that. From a quick test with a metacopy file
> whose redirect into a data-only layer points at nothing, registering an
> O_PATH fd of it with FUSE_DEV_IOC_BACKING_OPEN gives
>
>      ovl_d_real(/f, 0): real dentry not found
>      WARNING: fs/overlayfs/super.c:79 at ovl_d_real+0xc9/0x210
>      [...]
>       file_check_backing+0x308/0x5e0
>       fuse_backing_new+0x219/0x4a0
>       fuse_backing_open+0xe8/0x390
>       fuse_dev_ioctl+0x53a/0x7d0
>
> and the ioctl still succeeds. A normal open of that file fails with
> ENOENT, so nothing could have used it as a backing file anyway, but with
> panic_on_warn this is now a panic.
>
> Maybe ovl_d_real() should just stop warning when the lookup fails, now
> that it has a caller that isn't trace_uprobe?

Yeh I guess that this needs to be a Fixes for lazy data lookup.

The correct fix would be to teach all the callers to deal with an error.

> The check would still pass
> for an O_PATH file whose lowerdata couldn't be looked up at that point,
> though.

One observation relevant to this patch set is that a datadir layer has no
business being a pseudo fs and that can and should be blocked explicitly
at overlayfs mount time.

The other observation is that fuse_passthrough_open() should probably
check the backing_file that was opened for io in addition to checking
in fuse_backing_open(), which could have different FMODE and specifically
could be FMODE_PATH.

Thanks,
Amir.
