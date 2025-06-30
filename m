Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7470153BD9
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Jun 2025 02:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751251517; cv=none; b=BM51R1t/KjDgxUeMkAnW/eId3KxGwPNcv3aoJ9suDX06Bp8BfBLvLDrTAqasM1TIt9CUpYLn2RWxRZY7N/3Kqa5u39+oiqERVzGTarlYNjTGXlsHWjhXRq+LBcNKAE+l4Ha2yJqxijm3Tpq3DuDzvC6ALHN5sneRXPJqJr/CfpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751251517; c=relaxed/simple;
	bh=Vo6W5GRQ6H3qzWX3UombAMvAKBGTLOzp6x+XKizs6RU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZuSJarqtK0P0MSHoponZJsHKAzbSnlePYQB/xU5b9Uk7oX6XRzdxA33sVJ8ohkBfccwqrJo4qUkIAyEMtRQjHlSZsQ2YwfWS/2oVq/Yu50d07WSp81JpyIjmmDzdRyM2jmo0gAb9cOFPxKUHh2yEs2I4td2LIUzNBIwxqV20jLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gwGSAfgf; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gwGSAfgf"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b31e0ead80eso3505802a12.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 29 Jun 2025 19:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751251515; x=1751856315; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1IpcXOgS4DRYfBKMIVCF0qH9xXAuT76wTmWAshDnkkU=;
        b=gwGSAfgfaHe8CK/ZiQV7Q3jAPd5MjXws/ZsyePnfxxJVqTGD4gx7+TS6eEUM1gZ+8g
         o6i2TT3i8WUj+ekNSbI4aEcSNtY2WLhtxwhfSA5gbUOFHGLaiWewzxjXZf5/eapzXXoU
         1SJhbn/Pyjno8sDSED0xj4VtU+zO7tosqwwap+9enxBppcXFQYLeOHLwyRy0Kn24/ALC
         Yu2no+HKUD/UY2kPTv6wYXDVSVR5jwCiq9orFi4eTKybiMLo9Zxxqa3f2zzAQee1w1O1
         Wdza8QxAgWCgS4bUzK28iUgeNWASgpf+ToTpVt2p1pav/9MBqGwMeebWF/XepaIfLJ5b
         HdTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751251515; x=1751856315;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1IpcXOgS4DRYfBKMIVCF0qH9xXAuT76wTmWAshDnkkU=;
        b=Y6CWs6dwySdfD9JfjClGQ93rSQuCM5tMXqhSBUkl9u6wu2L43E7jEi8JYxUh/xae89
         jQw2IybEdAbKyATNqS0cTnPMEX0xOM2aDSAwwioYHhpYzQWJOCPjBdfgMD7FLN1wWwfy
         pQzNSScByl3s5B/QWx4K2BRFROCPzm4WineVsaw+A6ZaxYc5BL8IScNwnIB75qQ+VGVj
         PX++8jVmMwbnI/PhlnIAGnGvor0SMjKjvC/H4CF2QzyFGLeZngL/4pJrtTLrhK4yf7Gg
         HsvcXOVlT/dfqD9zun/SI1MgrCCzfBFgqzN1s/A5xaCna+xfVDJAK9HRCmbTBda5wQ3m
         iulA==
X-Forwarded-Encrypted: i=1; AJvYcCWiQF1zs7adBSMEJmVQqNXTbyuDVWt+9xmhU9W8VpHjzVKLXUy4Fh0Fqjev38p7a45Ek6YlLdaVWfemHg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxAYDA0L8XrCGZxsTpCfWfLTWPduwsiXG3oQlwQ8oVmx1FGSmXy
	/f5VZcEn8S0eHn3HQvFsMxYCnJsd1DuKOKaAHrdJeZ0eK8B4bafTvwsD
X-Gm-Gg: ASbGncvGb4dML7xftObyKewoOf+mQHzJ1dJ8jrPUk6PUnXFW2HYhEnOf1wAAbFq2Evv
	ySlcCnblMYoQgMoG45kQ4RWf/roIJbezohJBCdbBhCTfhOMic2Gd9yYF+zHZfGsF/Q7t0fNjNbA
	XakjwoMbVw2jKOpIiB4T5zEK+vmezv4c4H0yi+rLLMpwFF0JsfU1FLeBH8Re01PVuAWsV4alrSX
	8kYURww4KWzVpDcTK4P/5FWKX3+nc3kY756mMhJDwpWC9u/5ykrsLkyLVM+B2MxjWeW5MILgjPc
	6UNoT4Ph9tE6xhiAqclRKl1yUiipLt/ye5t4+Dc8G6MGwcknY2tUc3174CQ4e4u3rMap4knEXb8
	dVPUEOsZyOSyt
X-Google-Smtp-Source: AGHT+IGxYHOEoC7d9V3SX/9r0y0UZ4hPGyESGJPZAar/1QHd0h4+Cd1lUvfxijoo2AT1Y37w59s1Hw==
X-Received: by 2002:a05:6a21:6d8f:b0:220:396b:991e with SMTP id adf61e73a8af0-220a16c98efmr17264682637.32.1751251515038;
        Sun, 29 Jun 2025 19:45:15 -0700 (PDT)
Received: from ipravd-Nitro-AN515-55 ([2601:646:a000:5fc0:84f2:7459:db60:b146])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34e3008e2esm6899030a12.16.2025.06.29.19.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jun 2025 19:45:14 -0700 (PDT)
Date: Sun, 29 Jun 2025 22:45:12 -0400
From: Ivan Pravdin <ipravdin.official@gmail.com>
To: Heming Zhao <heming.zhao@suse.com>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Cc: syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: Avoid NULL pointer dereference in
 dx_dir_lookup_rec()
Message-ID: <f5qcns4xuba3r52cmqoiwdfveyv3xez7zhohq64ktcswjw2otk@qoqlu7ui5yp4>
References: <20250627023830.150291-1-ipravdin.official@gmail.com>
 <d6c72ab8-d600-4cc2-9609-8b749b61703d@linux.alibaba.com>
 <d6a11613-9763-4d9a-b4ad-5f451f770b70@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6a11613-9763-4d9a-b4ad-5f451f770b70@suse.com>

On Mon, Jun 30, 2025 at 10:32:35AM GMT, Heming Zhao wrote:
> On 6/30/25 09:26, Joseph Qi wrote:
> > Hi,
> > 
> > 
> > On 2025/6/27 10:38, Ivan Pravdin wrote:
> > > When a directory entry is not found, ocfs2_dx_dir_lookup_rec() prints an
> > > error message that unconditionally dereferences the 'rec' pointer.
> > > However, if 'rec' is NULL, this leads to a NULL pointer dereference and
> > > a kernel panic.
> > > 
> > 
> > This looks possible, but syzbot reports slab-out-of-bounds Read in
> > ocfs2_dx_dir_lookup_rec(), not NULL pointer dereference.
> > 
> > So I think it is because it construct a malicious image and set a wrong
> > l_recs, then access this damaged l_recs.
> > 
> > Thanks,
> > Joseph
> 
> I think this proposed fix (at least the fix method) is acceptable.
> the crash occurs at ocfs2_error(), where the pointer 'rec' must be incorrect.
> look back at the previous code lines:
>         for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
>                 rec = &el->l_recs[i];
> 
>                 if (le32_to_cpu(rec->e_cpos) <= major_hash) {
>                         found = 1;
>                         break;
>                 }
>         }
> 
> either 'el->l_next_free_rec' or 'el->l_recs[i]' has an incorrect value.
> we can do nothing about this kind of error, simply returning errno to caller is sufficient.
> 
> btw, ocfs2-tools has a similar function "static errcode_t ocfs2_dx_dir_lookup_rec()"@libocfs2/dir_indexed.c, which sets ret with OCFS2_ET_CORRUPT_EXTENT_BLOCK and return.

Thanks, I will include it in v2.

> 
> - Heming
> 
> > 
> > 
> > > Add an explicit check for a NULL 'rec' and use an alternate error
> > > message in that case to avoid unsafe access.
> > > 
> > > Reported-by: syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com
> > > Closes: https://lore.kernel.org/all/67483b75.050a0220.253251.007c.GAE@google.com/T/
> > > Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
> > > ---
> > >   fs/ocfs2/dir.c | 16 +++++++++++-----
> > >   1 file changed, 11 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> > > index 7799f4d16ce9..dccf0349e523 100644
> > > --- a/fs/ocfs2/dir.c
> > > +++ b/fs/ocfs2/dir.c
> > > @@ -809,11 +809,17 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
> > >   	}
> > >   	if (!found) {
> > > -		ret = ocfs2_error(inode->i_sb,
> > > -				  "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
> > > -				  inode->i_ino,
> > > -				  le32_to_cpu(rec->e_cpos),
> > > -				  ocfs2_rec_clusters(el, rec));
> > > +		if (rec) {
> > > +			ret = ocfs2_error(inode->i_sb,
> > > +					"Inode %lu has bad extent record (%u, %u, 0) in btree\n",
> > > +					inode->i_ino,
> > > +					le32_to_cpu(rec->e_cpos),
> > > +					ocfs2_rec_clusters(el, rec));
> > > +		} else {
> > > +			ret = ocfs2_error(inode->i_sb,
> > > +					"Inode %lu has no extent records in btree\n",
> > > +					inode->i_ino);
> > > +		}
> > >   		goto out;
> > >   	}
> > 
> > 
> 

	Ivan Pravdin
