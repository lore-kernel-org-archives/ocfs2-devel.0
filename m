Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7B32FB635
	for <ocfs2-devel@lists.linux.dev>; Mon, 27 Oct 2025 11:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761565333; cv=none; b=UzyWctUZSr/llvmcLPWvlBqKdKnqTaxlHDwZUwYw1CD1OSKu4k3yYe/vyhljPx0VFL1g7WWfcw/A6D1lCW1mwFRfz2uc/1yZ8hmjccyQ9V8efGapR2bHBfbSTsBo2ErY1YN0mvrQjk5P25VdpTFH9dfchVpIJj0E+NFtF38INoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761565333; c=relaxed/simple;
	bh=Cy6xgG22ImoRvVsfhnOrYcTI3bpmgDKeqoQ9Mmj1Tn0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cBQvVuIL0HfV2UvwebTQs3kezxvNIcnWuB6j83FFI34R5zZ+JxyldyYigxty7Py5wtYh4fdXbfUu/mI99gc5nKi1lwED32h4QyQxGUigrhoErJuYewWeS5TTWGAyDqL3cySqMpG2Exb0WCXdWN/aT5PT4z5IjkvAFtaE07BWSbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G3S4p7T3; arc=none smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G3S4p7T3"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-63e393c49f1so5078843d50.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 27 Oct 2025 04:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761565331; x=1762170131; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Cy6xgG22ImoRvVsfhnOrYcTI3bpmgDKeqoQ9Mmj1Tn0=;
        b=G3S4p7T3sKgTjd1L+mNE/AOaQDqgKCOKYdt4O4L+/4PAEHY3+guzOFsvDBUjohlWLW
         HInCICF3CHjxRLGYexpCRXDpn+TQ5SA6V5Q2nCSKleoCInVRCHi3aDPN+wWOqiJUrnkk
         7MdREDN4alUbvn+qV7UpglOu3rFK/xpDWF8+Xute8cM7skI34w2po6IKz97oM9gkDt32
         qnlYIrOMEJzCdb69jKoj0jCClvMcMBD3uHuQvqHvKvI2cfD3tIgD12iMkWpx86r79aOr
         3NjvIP4xqguYSmQsohXMNoSUN+v5vfbzr35RUeLPu9sDldNwLUw3r4GlFmZFRWFzmn+P
         CJag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761565331; x=1762170131;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cy6xgG22ImoRvVsfhnOrYcTI3bpmgDKeqoQ9Mmj1Tn0=;
        b=UueGO0N243zjk1Mk72UvEIy2Mid0/utlTKpACQMUlll4UPtYiYTLQgQMY9ZTmEhD0l
         DZhWu3SuUEM3m30DuoLKPRR1NDD4G+dUKRXkU0tmYJJ4qNQYVR7r9fXzf3F3el4zzJBu
         bpXkM/mWJCr81gny1kv7p/LekrXwdOAkhLnY1HlS4HGMW75MjEryi0v1qgl+fz1e9bll
         M837HaOv/wrxYh4fFCM2mZ5xN4b+H8VQe/Lk+buClKe3moYbdMZ7rFg08IliGkEFyXwv
         gQtDAiA1iGKojVCzF9ahxEON1/Gc4clI5J36Hx0IN2vs9hjft7AYk3phjf58YkEdEgeH
         OaiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWe6DhayRt1vvq7ihUYW714l9g1FB/y2b04kL0vU/6pL9T7UDPa5AMFSLTE1amiLYsQotoz8ezkrunVeQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzM/nTWwPPpxMbnGjU5tDiFwQt7O9AhO6Ru6jk30jkDZlaBWcZ+
	eR9vw1c8RszYO4SiH7ngV1Mp0GihxslR9XxIqaxjYKCnaHCQGJWaL9xSxMA5xmSB4BnchFHAY+W
	DqeoqnnihdQpb5nd51q/CworyvPXBuhA=
X-Gm-Gg: ASbGncu9GQLvJgi7E81Hc41VbyMsodBFA1MPxqpVb8BWV794BpNV8OuL8pFSLHSUj1l
	RFfS4I/kbpvKmMGhyPBcAgLO3kfMyZt3XpNG6VXMhyVxvzy4IFgU+WsJWT8Ub77RSbO7Gc+zRrO
	M67AvZvoRuibBHgiEHKsv+XIoLY7k7CuEvfJD2eRh9hoOuS9uIvsLgyjFCq9LSzqR50PlXoJANV
	BK6GoaSuj23EbNuN/osscueBnjlHD6DFrVJYC/jenVdmEPjc70bESBNj6HJxIsHrauOGpRHe97Y
	Jn7XTPaGUMN488IwJQ==
X-Google-Smtp-Source: AGHT+IFFVIyBUciJhEdrSmCPXcpTypjEGn4Qgj9ViJLBr7VlEM5XbX9uzWCnWbhO+Qg4BOHaVGtJp0XNrYmMyPBe+Zg=
X-Received: by 2002:a05:690e:4101:b0:63e:1e98:fb2e with SMTP id
 956f58d0204a3-63f43560880mr7895415d50.42.1761565331007; Mon, 27 Oct 2025
 04:42:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251026132625.12348-1-kartikey406@gmail.com> <0b618470-a8ad-4045-86a0-a8327d613a28@linux.alibaba.com>
In-Reply-To: <0b618470-a8ad-4045-86a0-a8327d613a28@linux.alibaba.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 27 Oct 2025 17:11:57 +0530
X-Gm-Features: AWmQ_bm_gC3kt4j_m4yQOfoKPEMD8eeEZQLpZWn_tCxtmxS3RW6T-Wh2QP2BUEc
Message-ID: <CADhLXY7_NT4e8jV=CV0nA6wLFJcrokGV2dRfp_cUJmX7=UY5RA@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: validate cl_bpc in ocfs2_block_group_alloc to
 prevent divide-by-zero
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, Heming Zhao <heming.zhao@suse.com>, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Joseph,

Thank you for the review and suggestion!

You're absolutely right that moving the validation to
ocfs2_validate_inode_block()
would be cleaner and benefit all code paths. I'll revise the patch to add the
validation there, checking for OCFS2_CHAIN_FL before validating cl_bpc.

I'll send v2 shortly.

Thanks,
Deepanshu
