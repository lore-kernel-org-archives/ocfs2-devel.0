Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE9D35970F
	for <ocfs2-devel@lists.linux.dev>; Tue, 26 May 2026 15:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779807632; cv=pass; b=gDR8xWZ7uJ9eU2L3tRi6iNom+Pkom/cH5aJscDRFzPp6vvLKz1afxHRNACTbXaNDs121j2AmBugp5gjCDKpgl5k4+EyYIzhqhYZPVqxC9l1hEMYPo1lpQo7rlpgM/eCnZOmyYPdes0qf/iH5/b0+8hKAyTyHCHqlgOwoH7WbxSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779807632; c=relaxed/simple;
	bh=EvbsFrM1aOZoE9rzekiebiw0GdV7XyQJiZp1BOpUdEc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gRFB+j/Pp0/277aZdPqPhmg9a+6q1lVgFDUAHXSjzu3bwWtxn5bMyXHdFoFZeOxHrXxVczWHHCLcq6588VTrAbTSKaX37+pPry3KUYtfjEqsi20NbWc8X8WzLq3pzHfwU6fNLjOJ9R7REERSbE7xXpp5SwmD7gpk90Pw1u/Nybw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=XkrK9+aa; arc=pass smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="XkrK9+aa"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-914ae4101b4so628792785a.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 26 May 2026 08:00:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779807630; cv=none;
        d=google.com; s=arc-20240605;
        b=cAjwOF6UD3A/n0KSvPbc0baAnKksKxG/ov09xpzZf/ojZYoZsD4oW8hudbWHPxCehm
         TJKhTgSeMM9GI/Yc0t0qiV5GQre0lFv/Or0sNLvEvS/ucgtGW0BcW5UxTkM8TzYFAzmI
         K6wrdyPEo+GSOzuvm+2WIaR48/xRGHgCyN9RBVa9oXcU9zCvqoXW1i9tQGzxaf6JJhMg
         Vc2XMagIL7IjfR/jHTK+ENH72j1MTooC15qTQbx21Xd6cmhJP4BM0dk2qo5VxjLDxMQB
         dIOqJ2j9RM5iNgRy9y6EhJikUiIgqL7UP4fJnP04DLrDyTnpwDeASZZPm3mFcoryrQUO
         Mjkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=EvbsFrM1aOZoE9rzekiebiw0GdV7XyQJiZp1BOpUdEc=;
        fh=ostZwacuIpEcvzS3hIEjIdffYG5mZuNvMvFkTEq8+wY=;
        b=jy1ayaUKJoSafCeDQyFPMrJ4UzgZ1cih99eEzM3SL3kFMuwK9MHc/KsRVoLplnZcJU
         dn5hsK0nwG2enNPll+oVdhnzbcacKtiV9m9AsZeTnTRbvd9DTz8kGF/ywcIeartRSkU6
         JOKWc1fHrvX2c21ZRX4GCE2UXMIKt/8kxBnMCqQB8jwTTK4vtdi/8d6F+vd/ZG0N2dwG
         J/5THaKGTiYkP/xIppr2Jt32976H5cVobvyXzC3DVnPW5Wof2BdE3dzAAQ1DTT0e2kR8
         qEB5kHTQyiZ+aiMxzElqYkJSfUqTXfWzfAxRD/YdyHENbAQsw7Vtczn9KDVw/YrIuCj1
         yVqQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1779807630; x=1780412430; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EvbsFrM1aOZoE9rzekiebiw0GdV7XyQJiZp1BOpUdEc=;
        b=XkrK9+aaN4UMayDxZNc9lWPX+PbYCDFBgwomylbxpkjVGQmTfM2OqoU6rWN+CZhWFs
         4eI1gEre2U8+W6R7oFt0FWveb3EA0BZzYsy1FSNNMFVewRMx2ichf5ZdpNe3hKR/d3SW
         YzbFtc0f43vYYwDTp7DAoHuhmzf6v2p8nwOQw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779807630; x=1780412430;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EvbsFrM1aOZoE9rzekiebiw0GdV7XyQJiZp1BOpUdEc=;
        b=NoI7ZcGDLOSeBL+nX9OWH5htliMydEaOLFoDKGLoeLAl41Q5ReHs+i9AwHAWThNZfz
         9f1J95wfOi738az7YVTEaaCodHJUwgodyI6X1maK/+nGvtzeu7RjLIYDo1NryTz0B2Bw
         ga39ucSoISmBONNL4Gl4NICv98x52RqX0YRPvp1cZshJdXiqVwCYbM7FvuCDQaBN2BEm
         gEOfRlseoWBzLMivhutK1xdAKj4NkTYf/DTfYAJoJr9RQVRYMd7IVGoa+EbculvznEF5
         RDq45f7cCYauWNlpc0POiz8slmz6nyjOlmuN8O6G0+iyWqPinK9nzwCl3wWdMcXNutHQ
         Q1pA==
X-Forwarded-Encrypted: i=1; AFNElJ8L8ieEizt+wa3dwvOVgC34N9evZtS8tYfB90DviZ5pRiYHd0jovee0ASZ1m3p4T09OIo0LT67S4vg/PQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyVZmxAj/t/RL9O/o/F2TiR+xA6+f+JP9XR9tnGgDMBvuix/y+V
	pZDb0OSwbtZsrz2qQbyIHrkizLdcyyEsWACkjDIWZ7lBY/HZr/sKfLzgGL1j6GDMscelyJStH1U
	SM3m+R2dAaRPpgUF86Sslb6nPmNuvxgx84wnz18gc/g==
X-Gm-Gg: Acq92OEV+tws1aVYnaQWO1I0sZLonDmAPtTIyBXGRfDKtixek9ZXOY9ocnDU/HSwvTN
	LOSogXIEYs4+YwgmLYGpWC9v2lPZ6iMfQ7R12vgnqU3Byccdr+U2HR9eqe2GA5YRNLu9mVVF2Za
	tYaAakJCSvvk1e8MQ67Z6zmF4dgdivuzZSLLEaMhuaPd6kMXVnx8yeahGeOTIAsUKsiLk7AMnnQ
	6CcfHttvXPjUNhku9zQosRfGKolgdSRn5/JYw+ijYtoBsu2WKnamVijv8i0ehHfzBOy4elnZY8Q
	0F/0nfd1DiGNFwIK09Lb8a6d1oOJZBCXo7otmsIyPTSNt8kL5Q==
X-Received: by 2002:a05:620a:2a14:b0:90c:e5b5:65f4 with SMTP id
 af79cd13be357-914b48b5d36mr2776455585a.2.1779807620596; Tue, 26 May 2026
 08:00:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org> <20260523-b4-fs-v1-12-275e36a83f0e@kernel.org>
In-Reply-To: <20260523-b4-fs-v1-12-275e36a83f0e@kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 26 May 2026 17:00:09 +0200
X-Gm-Features: AVHnY4KilITCIvGtFxS6FTciw1vCUm1AhcuYlYRxf5FBmn1jF7w4ka-Ynpxrnvc
Message-ID: <CAJfpeguR8uzC+GdyYfby1LS+HyB=p7=ri3J4aAmUFfZ2V06+1Q@mail.gmail.com>
Subject: Re: [PATCH 12/17] fuse: replace __get_free_page() with kmalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dave Kleikamp <shaggy@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 23 May 2026 at 19:56, Mike Rapoport (Microsoft) <rppt@kernel.org> wrote:
>
> fuse_do_ioctl allocates memory for struct iov array using
> __get_free_page().
>
> kmalloc() is a better API for such use and it also provides better
> scalability and more debugging possibilities.
>
> Replace use of __get_free_page() with kmalloc().
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>

Thanks,
Miklos
