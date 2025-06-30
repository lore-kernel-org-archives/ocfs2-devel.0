Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0D849620
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Jun 2025 03:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751254815; cv=none; b=q33Krrp3XB5iV6KQJR8pm5m+6b2TI04Fq6Tjs+x6zf3yuSwfcxE++cvj8AjkJrMtqfOFEvb1/wKox1gGBH5WlD6U+fd3TxJMAsGtXJIQzWE220WIbhKrY/kY4+OzkqrzuvNH5Oj0Ue8+vebLoAi+1Cs5B/0d5Hr0Q+o2LWQNBXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751254815; c=relaxed/simple;
	bh=bfMbO6WK0BKl25ma0GekGjztEJi/z8mdR9cHRYTUpwI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FUhY3UtvDdCkMZKbUXvZxyYoHL0+m7Ee39ImpvvnRed30Of2FF5ZfY/DXzjO699kYVeIqrO1MC4S+nLKE3hOmefiM0qk6DibuOqu1p0BrvMdgjo6Y4L9/Eog68T4SZ/4CnK7dQaxmkC/kaBY5P8TqnVAmuqdOKp59kQ2tJSR7CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eEcY76RJ; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eEcY76RJ"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2350b1b9129so8009055ad.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 29 Jun 2025 20:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751254813; x=1751859613; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pzmu1K4JJ3zo16PjdIAB9kkwSrXC2wV9EcR27ZBj8/4=;
        b=eEcY76RJQTMBE+EyigVVsfMzh2QfbusJhjEarEU1DlBAPKg0FL+OjK9scm6MYCCrH0
         a3bHL5uDvR9WYdQnmnhnTS4Ew+EETj5JSTEQzSLAKBYH1DZJgavZFXOMPhwnjkhfyl4M
         wtlN3Q+oUugHssUgPG2vhd2pQFo/nj2Wy1GqO+XvS5bKrFY91HL4s5hNBR6MUty9Ft6z
         WE1ZLKB3qswpGIg8DydParV3qog5B3JDDVXn931mLGoGM5d+H7Y6A1h5lIEX8eqknDCO
         ZRhM101apL295yxdSSxTQBevGu6KoxslDwG4VxI10iSemmCwOWIPuMugsqe8rUG/fAkJ
         c1nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751254813; x=1751859613;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pzmu1K4JJ3zo16PjdIAB9kkwSrXC2wV9EcR27ZBj8/4=;
        b=huugAZjoYW7z8awBg19pusH91YamEe4bH/4Sz8bdhHYvqeNMxSFQhBsSs4q7Odnz66
         SpUa1qtVLS/2TBGEXpkhw8nuHAFcUjU3cOXTavJjc1keC6a05+j4sHGTis9bzuuyGTx8
         g7OCqOktv2JFTIhxo9hrcEvYEYhmSpRascD4xxBOvPo2zNWN2BvwGEF5FLLWYBcnD1+p
         2AU2W79S/GF6KsIsk41t9VFoKvnhM9SsDO7CtJL2wSODBrfcStOrzaMKJBrCLhXUy177
         tiaqKamiZp9T5dTHHdFN0/CCecK8qipmNviamN6jzLKCTrV8NKiq3GZ/xFPTLjTfiYDW
         v4sg==
X-Forwarded-Encrypted: i=1; AJvYcCXNg9k6Hc1wR1rK5XLhwLVOTcTFtAtdKJjyc6E8m2UHCkdq7nOgk71mkdXvJYx7zagiBO3AHDjPYejerQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwoJUlfbCkt4qFEMP1r8sg7OYhi3U8cBj8uSy1oOzC3yy5XhPwi
	H21kXR7Gk6IGywYZjO1QQG6O/EvhWfSZ/wfzo3XTvYKrRUhW4m80Wb3Z
X-Gm-Gg: ASbGncteU9IcNZgJw1o82JbHjolwaHSIjyc+H/X7QkgN5hlgJbIc0o7yIfhMEpZXYhq
	/V5nW9O3gXrxV8zTd6G4+4UwlWvUlMztPNEwGfPthMhfVkwXmuidR+DqIe50PJL14JRcqI/J9rY
	GfZ9z3Qs858/KOpk1wR+DWKNLshCbjMnJS6pyNTpejp0OqrBGxYJlwzZfu0xEJvMALeh2jaE4lA
	wIpy8HhBR7xIUhS2QQ17hVBTL+ZNZoRuHSshzMWNELE+u+Q0Q2M1e1f/UbM2JOvWKKznQdy5ys7
	fnkwEYwuGptGbLsPd0+7tLZdKS38T+hgpaEtCO0iybpyX7SSMO0cMDkziNv2i6a7eujNMER1nJo
	ADq8FjiVDkt81
X-Google-Smtp-Source: AGHT+IGAi/A0RnJBXP04znAaf7ISR2PfyJDSIKfFd2Uks5eUzzXBq32IWYpqP9TUY6Y9G8nXAGH8aA==
X-Received: by 2002:a17:902:f545:b0:235:ed02:288b with SMTP id d9443c01a7336-23ac460523bmr157603105ad.30.1751254813096;
        Sun, 29 Jun 2025 20:40:13 -0700 (PDT)
Received: from ipravd-Nitro-AN515-55 ([2601:646:a000:5fc0:84f2:7459:db60:b146])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-318c13a270csm7778173a91.16.2025.06.29.20.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jun 2025 20:40:12 -0700 (PDT)
Date: Sun, 29 Jun 2025 23:40:10 -0400
From: Ivan Pravdin <ipravdin.official@gmail.com>
To: Heming Zhao <heming.zhao@suse.com>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Cc: syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: Avoid NULL pointer dereference in
 dx_dir_lookup_rec()
Message-ID: <ckqrcag2cnsrwjccxyzd76vne7epsei7swjulpkfkzwjalk2lj@5iweq3oucsab>
References: <20250627023830.150291-1-ipravdin.official@gmail.com>
 <d6c72ab8-d600-4cc2-9609-8b749b61703d@linux.alibaba.com>
 <d6a11613-9763-4d9a-b4ad-5f451f770b70@suse.com>
 <f5qcns4xuba3r52cmqoiwdfveyv3xez7zhohq64ktcswjw2otk@qoqlu7ui5yp4>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5qcns4xuba3r52cmqoiwdfveyv3xez7zhohq64ktcswjw2otk@qoqlu7ui5yp4>

On Sun, Jun 29, 2025 at 10:45:15PM GMT, Ivan Pravdin wrote:
> On Mon, Jun 30, 2025 at 10:32:35AM GMT, Heming Zhao wrote:
> > On 6/30/25 09:26, Joseph Qi wrote:
> > > Hi,
> > > 
> > > 
> > > On 2025/6/27 10:38, Ivan Pravdin wrote:
> > > > When a directory entry is not found, ocfs2_dx_dir_lookup_rec() prints an
> > > > error message that unconditionally dereferences the 'rec' pointer.
> > > > However, if 'rec' is NULL, this leads to a NULL pointer dereference and
> > > > a kernel panic.
> > > > 
> > > 
> > > This looks possible, but syzbot reports slab-out-of-bounds Read in
> > > ocfs2_dx_dir_lookup_rec(), not NULL pointer dereference.
> > > 
> > > So I think it is because it construct a malicious image and set a wrong
> > > l_recs, then access this damaged l_recs.
> > > 
> > > Thanks,
> > > Joseph
> > 
> > I think this proposed fix (at least the fix method) is acceptable.
> > the crash occurs at ocfs2_error(), where the pointer 'rec' must be incorrect.
> > look back at the previous code lines:
> >         for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
> >                 rec = &el->l_recs[i];
> > 
> >                 if (le32_to_cpu(rec->e_cpos) <= major_hash) {
> >                         found = 1;
> >                         break;
> >                 }
> >         }
> > 
> > either 'el->l_next_free_rec' or 'el->l_recs[i]' has an incorrect value.
> > we can do nothing about this kind of error, simply returning errno to caller is sufficient.
> > 
> > btw, ocfs2-tools has a similar function "static errcode_t ocfs2_dx_dir_lookup_rec()"@libocfs2/dir_indexed.c, which sets ret with OCFS2_ET_CORRUPT_EXTENT_BLOCK and return.
> 
> Thanks, I will include it in v2.

I have realized that ret is already set to EROFS that acts as a general
FS errno. Unless there are any other objectives this is the latest
version.

	Ivan Pravdin
