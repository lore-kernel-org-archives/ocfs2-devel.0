Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D011547C0;
	Thu, 15 Aug 2024 05:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723699686; cv=none; b=oG9T5n1BGo1fiOkeAwadrTcjaLTninywY07pb6LwjtFPuOb0Ev3AWzw8DogNNXloVnVzJ2PDTDPSvLOYxu+RHt/vw96gkiZBNO4M1BTzCs+unJIhJnKD7B0NnBO5DIbUhnuUU2I9pZduvpf9wo+hApI60rl6+SnlZlx9hM6zj2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723699686; c=relaxed/simple;
	bh=eSAiG30U4Qk4f+W5EYF3TdYcm6s5V1OE+Tr7YHKbOXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XV4YJhdq1Dqkkch2vbN0JNqbrEDVnpuU8emomSbuRManTMRgf8sjNm31TBr7nbp/W8nAoAeekHlrUTnvlMnhaPZEsswsN8X+wlPm0D+NCZdRRWw98NlXkBn6N2S6GzSKx5Rs95JQnfcHg9SEKSy+h617FKxgo+H/QiUYqzqCJYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHw50lU0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHw50lU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4662BC4AF0A;
	Thu, 15 Aug 2024 05:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723699685;
	bh=eSAiG30U4Qk4f+W5EYF3TdYcm6s5V1OE+Tr7YHKbOXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hHw50lU0zcvoqZryILu6hk6kw/qqvBsksy7t17Z3t5vNSSZFNg3rhC60tZdyDA5uo
	 7hu123/rmhafQd0QTImyUwCAlCPZwZNcFK51NkilkilfBS4+RDpYaqre/dvQSJHFIv
	 Cv1qTbJXdv5MOto6QzABXxwsmB26eMuiHLGea0n8=
Date: Thu, 15 Aug 2024 07:28:02 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexander Aring <aahringo@redhat.com>
Cc: teigland@redhat.com, gfs2@lists.linux.dev, song@kernel.org,
	yukuai3@huawei.com, agruenba@redhat.com, mark@fasheh.com,
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, rafael@kernel.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	lucien.xin@gmail.com
Subject: Re: [RFC dlm/next 09/12] kobject: export generic helper ops
Message-ID: <2024081519-caddy-monstrous-b37d@gregkh>
References: <20240814143414.1877505-1-aahringo@redhat.com>
 <20240814143414.1877505-10-aahringo@redhat.com>
 <2024081445-coffee-antiques-e9cc@gregkh>
 <CAK-6q+hN8ZRAHc7aS7C_RO4pEGN1t3eA_vDChsSgsQOcJEU4vg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK-6q+hN8ZRAHc7aS7C_RO4pEGN1t3eA_vDChsSgsQOcJEU4vg@mail.gmail.com>

On Wed, Aug 14, 2024 at 04:47:28PM -0400, Alexander Aring wrote:
> Hi,
> 
> On Wed, Aug 14, 2024 at 11:06 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Aug 14, 2024 at 10:34:11AM -0400, Alexander Aring wrote:
> > > This patch exports generic helpers like kset_release() and
> > > kset_get_ownership() so users can use them in their own struct kobj_type
> > > implementation instead of implementing their own functions that do the
> > > same.
> >
> > Why is anyone needing these?  What raw kobjects require this type of
> > stuff?
> >
> 
> In this patch series I introduced kset_type_create_and_add() to have
> the possibility to do the exact same what kset_create_and_add() is
> doing, just setting a different "struct kobj_type", for the kset that
> is created internally by kset_create_and_add(). I can't use
> kset_create_and_add() as it always uses "kset_ktype", see [0].
> 
> I am doing that to have only a callback for ".child_ns_type" assigned
> as it returns the "&net_ns_type_operations;" structure to tell
> underneath everything is separated by net namespaces.
> I don't want to change anything else so the "struct kobj_type" should
> look like what kset_create_and_add() is doing. Therefore I am creating
> the same structure as kset_create_and_add() is using, see [0]. The
> "kobj_sysfs_ops" structure seems to be already accessible from
> outside, just the two functions I am exporting in this patch are
> missing. Or I implement it in the same way in the dlm/gfs2 codebase
> (that is what nfs is currently doing, see [1]).
> 
> And then we are at the two users of those kobjects that are using
> those functions, it's DLM and GFS2 as they used kset_create_and_add()
> before and I just want to add the ".child_ns_type" callback. Other
> users could be nfs [1] (for the release, get_ownership - I have no
> idea).

Ah, makes much more sense, thanks.  And ick, network namespaces...

Anyway, feel free to take this through whatever tree the rest of the
series needs to go through:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
