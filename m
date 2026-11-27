Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795796335;
	b=ssQBdvYS6Qdl86y85KpAZdbZY6qQGuUrjunYXhVMrLAtUKM962jMeMSvRzXAn+8WaE7I
	 o68XZrovIKpMU3tlRhR4Hj34SetDGcnO17fJ4Dc6e7729juzp+jhX85xupOLyfBuyTj9E
	 URWoE74Riwl2PG6GoN6VnGIs4gy3Tap3oh+V8viDLyfFucR3KwcAWPLj65moRNAh9DyC6
	 Rrl+/+jK3CKlZ3VF4T3bu3YWLw7bON/3HlQWRPpltTx+2vsoFwkzrAe2+VQl+p5rN2Fzu
	 bcQqAYg9L28bXeP4M93waave9Yb46kVodL8Def+xlU9Ju4ao8JMsky+I5EsGQeaQxZQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795796335;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=WcqK/TokdPrpJ1SyssRoGlfCD57QN3XIIcFf/99tphc=;
	b=FI3r9GJuO9yTNmEevxLqiSIYOLwkTp2A5bfJZiaUdtgEI77uPYA0CkMTLIjM1dpCK067
	 TCcmcK7WJWccbqrMUcvXXiGPLNNlvoxLeIH/hRPa9xGPlMzJZ+Bm4Ga9XkSqzUm9LjGRf
	 KK2YmISMkBVCAwGvfPPqFggA3mcy/5zFCtbVmd6ZGr5Ymw6r+GLgFN7fjyI+3TiADniCc
	 /nWerHq61JDCQWachJF9atUJwEjrB9xzFM+GUnpUnw3vcTEU/9mldcXHoL4vjRksJxY0w
	 GPrH4muBYv7xFxsN/mvpA/3p0ZaJETlpfxXB9fKLOFwKohVuk+3PgwVx4wVMDl5/vHA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zg4MqP4O;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.51
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF301606A323
	for <ocfs2-devel@lists.linux.dev>; Fri, 27 Nov 2026 16:18:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF301606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zg4MqP4O
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c51d158acc6so185367566b.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 27 Nov 2026 08:18:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795796333; cv=none;
        d=google.com; s=arc-20260327;
        b=ebhlF5yZzZhGBwPD58fLHm/t6lR/rxsWUyBrb+bl4moD4MZ4f8UcENfeHrmUH3mW1w
         ouCret27e+OMEk5ylTLP1m8UhGzpSw2Fm03LRXhb1m4VuqdAZElpesTzEqPE95lxiCgJ
         zx40wx7saq1OdMRaUDm2tma7SWm0eTw3LhWbwRwCi5hTRrRZNMkcy8H1PBs+nnz56ATz
         pagiISaaDfuNpdjxyvfkOA57SZK8dJQoZnwn6/3oS95haQ5NfJI3XqEEkBw5ssxnpzq0
         wglN4gflyhcljU+OD+A3K+ZNJHk96exMa09PCPjqjFWXjkgnfbZMXsEP1M/x+SBRz+Ij
         bUlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WcqK/TokdPrpJ1SyssRoGlfCD57QN3XIIcFf/99tphc=;
        fh=Ow7btAnf6jgiUAZmdI1thJg20h7H1V0gywXC0LmyBpE=;
        b=D+egR7opsPp5vIg1NsOIpV6o3Pf76xIpzr9ETF+64ZOpRe9uYwCH3TnLVZ+vzHVmKo
         AQY8qb6GE+H6efK4t5GqaO187xw05HnTw3CxLFPLTx6e9gnfJ5g6UTrvBlZsF54YxnTJ
         mxuC837QeDXFLV3dfYkYIKibtsL3/zsw5AqOXLOAEp99eRx+9la93J2ii0YCN2VggZSe
         q8ecgSHQ7PDy6E1OnnUHgzgSNaGJNcyXCn3NtnOB20jYmnnVQ0sqZONHOIchhpVgse88
         8FGYfU7hkvQyT0/68zwpfi7gIT7ddi6Q9PJVNjDIUwmLCtk2kbVqVn5RnaNsyk+FoSlN
         tTsw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795796333; x=1796401133; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WcqK/TokdPrpJ1SyssRoGlfCD57QN3XIIcFf/99tphc=;
        b=zg4MqP4OEZg7DgljGqu6JeYUfr1Vy5+Pmz3PHBr3f2JX/9VAih7o4MZ8s5+CAPl21U
         tqcBw9Q2PhUaqdVA3I5ecZpD+uf6XsynHKvGsJKqnYuGT2ndCpkOsB72/gktJAL7S/TO
         aHvTDp6ogcWVu1G3FIYy2jYQwGtkbXCUxdMZ/LsRnZXql66jAeFxK/UVxBJyqmyvZbEg
         IZI8b6wWNt02VT668dq+EwyheJXKDUJdjXOXtnObmqcBzxSv9VSjuiFAFSqD8a33RsO2
         t33TPRM0WCFIfd4E76Dfgsxn5Yoa5/9MFykeYj6OdDH/nig/+s732uyxxaS+2C/O2+7h
         sw2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795796333; x=1796401133;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WcqK/TokdPrpJ1SyssRoGlfCD57QN3XIIcFf/99tphc=;
        b=edg3lk7e6lxH1UcU0AWjt+CpZ4N5LeCDTHvujVHdlAkU+43mm3Igm7yyN9Adj15M3X
         Da21TZMNrOhqR5DuJnq88YcWp8tpx/3hDXYkZHNDdotzOtGEFSLwRw6U+PqSbn6ChscR
         pe9URFNTicr6+i60/KaJJlMc1a+asP/zppZauDWAXvn9efH49JQ8PRc8ImbLRsXo0Ku4
         D8VxZ4d5hzQGyl8BmOFS+k8EIIEXeYa0YQWmID8ri4t9K8RakD1njadvG6D8WzepPZcu
         x8clSqm/4Xr18LZjcXz0mAFDb5aZn6ioKBApUWi9VmeYqCNSvkgseqQB+k9d9fcteun1
         kLLg==
X-Forwarded-Encrypted: i=1; AL+hErGa0Drc/PQd4kxvtZwwO1yqclXOODV9/MGbxfpvNsP+seCxDnPVuBx/KmhfdTuCEqXTuDqFetvT+kuj+Q==@lists.linux.dev
X-Gm-Message-State: APuU4Z/iwxzlkU5uWYSlxqqLfKzC/TLpinRYnf0t01HjFa3Oq+XSzl+0
	J+zOJRrmxhIKRXanYaHp1gotxvC+BJ2D8JB2lt9SeqiN01tYJFyOrGQAADOimz3aRpwdeWnyhe8
	BwIFFa+FJl8nNPRlrjvmorL+efQ0y+7U=
X-Gm-Gg: AZFdTZdixRTTQTVq26To1Y8BC3Qh1KmscRWmHw70WF3oPLsxgaoWig13m75c83xwc5r
	ljz5oTNfXdgOPmLZlH1mNmC8S1gHufGd2YpBRH8k4Fi73pmGoYenUD+pBS2tVqooiq51kwxxlMf
	hXixWNe9kgOPdeWWLmpk1w596Wfyhh5PwrFGIF+Gyzm4JpwSZRjLf0On0d/wIK5Kv5S0dnvglki
	pdu3vzgyZEKpx2nlrlLiZv8htQc30Uk5Y67xv+hKvHXx+Ut4kffVNr/Yxb/yLhFpPptsvHY6GaH
	wB+e6ywKLceVNfYmlmSbTBynE5kAjwesZ69b5PMNbKeKKkB3V3a7cQcXaInWd7nwwetPG8YBjRy
	KBkHJBm94WnGdUyrGz3Qm0+D3v9tCAMjZhmynafSpGhrSCiWyNuGKGUbpvorw23RY6Dn9Mg==
X-Received: by 2002:a05:6402:e05:b0:6af:80c4:8981 with SMTP id
 4fb4d7f45d1cf-6ba37e890fcmr19985269a12.26.1795796332918; Fri, 27 Nov 2026
 08:18:52 -0800 (PST)
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com> <20261119153222.65195-1-lauri.gates@gmail.com>
 <20261127-disput-nestbau-wahlparty-c189ad680243@brauner>
In-Reply-To: <20261127-disput-nestbau-wahlparty-c189ad680243@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 27 Nov 2026 17:18:39 +0100
X-Gm-Features: Aa3M54qCjcbbYjv0mzgNqjSQ7Sw_WVEr_GJN4PX5Bm9lrA0JqzVoRsl7zVlER60
Message-ID: <CAOQ4uxhE38TnXseMOyWY1OvidBWew2hAYAV+rYeTPaqRYZb45g@mail.gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
To: Christian Brauner <brauner@kernel.org>
Cc: Lauri Gates <lauri.gates@gmail.com>, koraynilay <koray.fra@gmail.com>, 
	Dave Chinner <dgc@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 27, 2026 at 1:44=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Thu, Nov 19, 2026 at 05:32:22PM +0200, Lauri Gates wrote:
> > One constraint for that case: the flag has to stay out of
> > FS_XFLAGS_MASK. As I read your fileattr_to_file_attr(), every bit in
> > FS_XFLAGS_MASK is reported as supported on every filesystem, so a
> > plain flag there would read as "supported, not shared" on btrfs.
>
> Right.
>
> > Christian, with this mask on the way, would you take a plain flag
> > (say FS_XFLAG_MAYSHARE, "may have extents shared with another file")
> > that filesystems advertise through fsx_xflags_mask? If so, I'll build
> > the RFC on top of koraynilay's series instead of using the inverted
> > FS_XFLAG_NOSHARED.
>
> Yes, a plain flag is fine. It's simply the stx_attributes_mask model.
> Filesystems that have support raise the flag in the mask and everyone
> else just doesn't. I see that Amir's busy discussing some details in v2
> so maybe base the RFC on that series, I guess.

FWIW, I think the v2 posted API is a solid candidate wrt the UAPI -
The AT_FILEATTR_ opt-in and the struct extension leave very little
open questions - the remaining discussion over v2 and obviously needed v3
is around implementation and the fine details of the contract, but for a si=
mple
readonly flag like FS_XFLAG_MAYSHARE, it is very clear how it behaves.

Thanks,
Amir.
