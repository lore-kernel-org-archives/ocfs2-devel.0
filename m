Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBAB26980F;
	Tue,  4 Aug 2026 20:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785876120; cv=none; b=fBpj0SCd3vSei3d9/xiykVpndBipfn4c8a5S6FCqr/6H1itlysPhycUexjrSaiSQY7ylbCmyk+Ql9ZxsBEO0n0+360VVFJzLRn6nPXmF0IcioP6Y1gijTVLMrJyfj2+c6rwb0T2UoU+ibwB4atXRlOhxU8NnQNZIijO7b/sNmaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785876120; c=relaxed/simple;
	bh=FMk8DIWB3bdakDfBVwdsb2RDnpL+zJI0E6HeG20sIsA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=UZhposy5XvPEbNL0pYt5qIVwlABouNneb/r0aL6UmhMlZFayxj6X6gs530xjQk0yneBAcM4x5O934Kol+4HyvBgr9XZovd0mRO11bb/wxtB8osagnuLLeVdo1+w8tt3XdQ7y8nrUm2tz+3ccC+BoSuBA4pZ2BFf1ofLKHmKx+Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MD9R3jZl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MD9R3jZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5321A1F000E9;
	Tue,  4 Aug 2026 20:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785876118;
	bh=vNic1rwDVawtLuHJPF3q/Av9ZqRDKaAF+irjR4UtxC4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MD9R3jZlHyK/XWWuqmek/JuX4agOuR5wbZ+DPcKk9/Vh2c10RT2NfFIXS6D65ZoZY
	 W1u8FBGn+gwWTWZJ1E+MNesSo0VMVI+GfouA68YIM6QaTUPIw5fIfZ3DcHzORzObFl
	 Lc3VAUOLN3cHtSaW79oojAM+sBHgEA+sWa2VidmA=
Date: Tue, 4 Aug 2026 13:41:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 tom442288@tuta.io
Subject: Re: [PATCH 0/2] ocfs2: validate active orphan slots during inode
 read
Message-Id: <20260804134157.38e3b8513d53c079f8b05823@linux-foundation.org>
In-Reply-To: <20260803030007.3993199-1-gality369@gmail.com>
References: <20260803030007.3993199-1-gality369@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  3 Aug 2026 11:00:05 +0800 ZhengYuan Huang <gality369@gmail.com> wrote:

> OCFS2 trusts active ordinary and append-DIO orphan slots read from dinodes.
> A corrupted slot can therefore index osb_orphan_wipes or the slot-local
> system-inode cache outside their allocations before the corruption is
> reported.

Thanks.  AI review raised several possible issues, all pre-existing. 
"out of bound access", "crash the kernel", "out-of-bounds heap access",
"triggering this crash", etc.  All the usual things (seriously!).

	https://sashiko.dev/#/patchset/20260803030007.3993199-1-gality369@gmail.com

None of which stands in the way of your fixes.

The best I can do with this onslaught is to make maintainers aware then
move on.

I do wish that Sashiko was more organized about these drive-by bug
reports.  Retain them in some lookable-uppable way for maintainers to
look at when they have time.  This has been suggested to the Sashiko
developers.  Perhaps one day...
