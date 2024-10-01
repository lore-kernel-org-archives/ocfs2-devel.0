Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5795B36C
	for <ocfs2-devel@lists.linux.dev>; Tue,  1 Oct 2024 00:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727741376; cv=none; b=JkJFh/Q7a3SlLksEPRgoKXQ0EOe9Tv6BmtDvGizSFIZpqSWYiACAVNgguaSVwYCetLyBmlpK/mXSdgYp1VuENW7WxB81rh9tVL0flGI7qAJT/TGLR08NQm7ouSEDIMQT/1Qb4Sm+z0l9AVu0MyoZmoIGE9CCwtJQ0DylOlbNH7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727741376; c=relaxed/simple;
	bh=WF4UHcsBQQQGtG8XoiJEAw7KXBLW+DJUXSSekfDa2Aw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZG54lyjqm30dFOUWPgVWnPRGnZ7AIBi6JucO1mox8hoGxBLsGGUF5atAIw5Wd2XaWXzVrwm7mKss8LMLUnHoL4ktyMcl21Knoc4MLKjaG5ttUBha5MRXpi/yLWyoeYnkyK4aNdxgZWcTk+bfAj4sg7Fe268FMiTl5jqiWuY5xDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dZo/3Rhi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dZo/3Rhi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727741373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A1dfu9XorZM4ryDcem8zGUAOayEDNnDp9d6zeR4JweE=;
	b=dZo/3Rhi8sr94Dh54VoWrSUpy6JpxqE7mpJbnb+oAif4omMT00586Tzt2Dxlg980sQJTcw
	CZh1USitD9MBXUO7/fhiroi7QjiRNj/ibXy2+ofw6Tvro0mkJvHsMdBRSF0jeQyHZKbokH
	SwjC4OYQKkW1tUVDx3KHG7ZQsvL+0OY=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-wfe31Eg5OzGmfx1CDckB7w-1; Mon, 30 Sep 2024 20:09:32 -0400
X-MC-Unique: wfe31Eg5OzGmfx1CDckB7w-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2fabc7c9e69so22966521fa.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 30 Sep 2024 17:09:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727741370; x=1728346170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A1dfu9XorZM4ryDcem8zGUAOayEDNnDp9d6zeR4JweE=;
        b=dhgK5GbnHfaRzDOcDKGwXfERcUZOhhyFRYInuRHHO3FpJBfmUM2lD/K0/jDlmkfqk9
         w5PVvsJjXjfNM8lEkKgGrzpa0UL/RW1xj6GIpA/jz8cRXkNtTzCCqaLYDuyxFnoOIASy
         5tnmnQOrhvIWSEJhUR9JuXv7JQ9nhy28FLMh+NWX4xDj4MtFlEJVJXVhgz3x2HUmW3hh
         2WuB4lmj0Jel35G3SjoU7j5y7yGoAUCRxRh9pXHEnr1BoVIvFgJKIGmsU+lfx9zP9lHD
         jim8UvmZCpaCsPDA7m769dlIBPJtFs5n+D/XRknrDU1NhG86sttz0K2Tip0NIHTvsGDq
         dDXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXp1Q1eQfmx1/UfL11848qZNRKchGRB2qotZloW4yAvTDAjMlA/BDMnOFPot0MEx9r1m6hGjIcr96xwQA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwLgRpDaHOc7OUA/LbGkhKaieOGkpQK9F8jFcvI/LdFOdi30Z1y
	Uq37TW2Esr+hBKzYBCdVmJR1YQl+dncXQzeW19dreb2atzYcWvPI4TPkhVBHa95XEruR1ufntvy
	VRRhC1uMdYxUWdBZTNduaiimKAOZM/j/qv3B0+vOjN9fIKi8A5KrAHJVVi4GkbtUvyIlL30b1LV
	4t4FjKs5/zP8EStnL6LG5ru8QdsiQsRmRgY14=
X-Received: by 2002:a2e:b8ce:0:b0:2f3:f1ee:2256 with SMTP id 38308e7fff4ca-2f9d41a4eb4mr97165581fa.44.1727741370403;
        Mon, 30 Sep 2024 17:09:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAcNC4y6SEhrnCgxe2rflhwoVRt5eNNwUxKVe6lm/QOKjgu/J0xJMsRT/ns1AHeaEbV17+L0+tU8r1y5LOUC8=
X-Received: by 2002:a2e:b8ce:0:b0:2f3:f1ee:2256 with SMTP id
 38308e7fff4ca-2f9d41a4eb4mr97165311fa.44.1727741369925; Mon, 30 Sep 2024
 17:09:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240930201358.2638665-1-aahringo@redhat.com> <26363.3177.994264.260348@quad.stoffel.home>
In-Reply-To: <26363.3177.994264.260348@quad.stoffel.home>
From: Alexander Aring <aahringo@redhat.com>
Date: Mon, 30 Sep 2024 20:09:18 -0400
Message-ID: <CAK-6q+iAp+sXrEyK858qL=HO2Os4=3-3y+iOQt3T1W=QpY6AXw@mail.gmail.com>
Subject: Re: [PATCHv2 dlm/next 00/12] dlm: net-namespace functionality
To: John Stoffel <john@stoffel.org>
Cc: teigland@redhat.com, gfs2@lists.linux.dev, song@kernel.org, 
	yukuai3@huawei.com, agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, gregkh@linuxfoundation.org, rafael@kernel.org, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	netdev@vger.kernel.org, vvidic@valentin-vidic.from.hr, heming.zhao@suse.com, 
	lucien.xin@gmail.com, donald.hunter@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 30, 2024 at 4:49=E2=80=AFPM John Stoffel <john@stoffel.org> wro=
te:
>
> >>>>> "Alexander" =3D=3D Alexander Aring <aahringo@redhat.com> writes:
>
> > Hi,
> > this patch-series is huge but brings a lot of basic "fun" net-namespace
> > functionality to DLM. Currently you need a couple of Linux kernel
>
> Please spell out TLAs like DLM the first time you use them.  In this
> case I'm suer you mean Distributed Lock Manager, right?
>

Yes, DLM stands for Distributed Lock Manager that lives currently in "fs/dl=
m".

> > instances running in e.g. Virtual Machines. With this patch-series I
> > want to break out of this virtual machine world dealing with multiple
> > kernels need to boot them all individually, etc. Now you can use DLM in
> > only one Linux kernel instance and each "node" (previously represented
> > by a virtual machine) is separate by a net-namespace. Why
> > net-namespaces? It just fits to the DLM design for now, you need to hav=
e
> > them anyway because the internal DLM socket handling on a per node
> > basis. What we do additionally is to separate the DLM lockspaces (the
> > lockspace that is being registered) by net-namespaces as this represent=
s
> > a "network entity" (node). There might be reasons to introduce a
> > complete new kind of namespaces (locking namespace?) but I don't want t=
o
> > do this step now and as I said net-namespaces are required anyway for
> > the DLM sockets.
>
> This section needs to be re-written to more clearly explain what
> you're trying to accomplish here, and how this is different or better
> than what went before.  I realize you probably have this knowledge all
> internalized, but spelling it out in a clear and simple manner would
> be helpful to everyone.
>

Okay, I'll try my best next time.

Usually lockspaces are separated by a per node instance as a different
"network entity" with net-namespaces. I separate them instead of
building a different "network entity" as a virtual machine that runs a
different Linux kernel instance.

There might be a question if DLM lockspaces should be separated by
net-namespace or yet another "locking" namespace can be introduced? I
don't want to go this step yet as lockspaces are separated by a
"network entity" anyway.

> > You need some new user space tooling as a new netlink net-namespace
> > aware UAPI is introduced (but can co-exist with configfs that operates
> > on init_net only). See [0] for more steps, there is a copr repo for the
> > new tooling and can be enabled by:
>
> What the heck is a 'copr'?
>

That is just a binary repo for rpm packages. Some users may find it handy.

>
> > $ dnf copr enable aring/nldlm
> > $ dnf install nldlm
>
> > or compile it yourself.
>
> These steps really entirely ignore the _why_ you would do this.  And
> assume RedHad based systems.
>

That is correct. I will mention that those steps are only for those
specific systems.

> > Then there is currently a very simple script [1] to show a 3 nodes clus=
ter
>
> nit: 3 node cluster
>
> > using gfs2 on a multiple loop block devices on a shared loop block devi=
ce
> > image (sounds weird but I do something like that). There are currently
> > some user space synchronization issues that I solve by simple sleeps,
> > but they are only user space problems.
>
> Can you give the example on how to do this setup?  Ideally in another
> patch which updates the Documentation/??? file to in the kernel tree.
>

https://gitlab.com/netcoder/gfs2ns-examples/-/blob/main/three_nodes

As I quote with [1]. Okay, I will move them away from my separate
repository and add them in Documentation/

> > To test it I recommend some virtual machine "but only one" and run the
>
> I'm having a hard time parsing this, please be more careful with
> singular or plural usage.  English is hard!  :-)
>
> > [1] script. Afterwards you have in your executed net-namespace the 3
> > mountpoints /cluster/node1, /cluster/node2/ and /cluster/node3. Any vfs
> > operations on those mountpoints acts as a per node entity operation.
>
> Which means what?  So if I write to /cluster/node1/foo, it shows up in
> the other two mount points?  Or do I need to create a filesystem on
> top?
>

Now we are at a point where I think nobody does it in such a way
before. I create a "fake" shared block device with 3 block devices:
/dev/loop1, /dev/loop2, /dev/loop3 and they all point to the same
filesystem image. Then create only once the gfs2 filesystem on it.
Afterwards you can call mount with each process context in the
previously mentioned "network entity" for each block device in their
"imagined" assigned network entity. The example script does a mount
from each net-namespace in the executed net-namespace and you can
access each per "network entity" mountpoint per /cluster/node1,
/cluster/node2, /cluster/node3 on the executed net-namespace context.

Yes when you call touch /cluster/node1/foo it should show up in the
other mountpoints.

> > We can use it for testing, development and also scale testing to have a
> > large number of nodes joining a lockspace (which seems to be a problem
> > right now). Instead of running 1000 vms, we can run 1000 net-namespaces
> > in a more resource limited environment. For me it seems gfs2 can handle
> > several mounts and still separate the resource according their global
> > variables. Their data structures e.g. glock hash seems to have in their
> > key a separation for that (fsid?). However this is still an experimenta=
l
> > feature we might run into issues that requires more separation related
> > to net-namespaces. However basic testing seems to run just fine.
>
> So is this all just to make testing and development easier so you
> don't need 10 or 1000 nodes to do stress testing?  Would anyone use
> this in real life?
>

Stress testing maybe, development easier for sure. There are scaling
issues with the recovery handling and handling about ~100 nodes
related that DLM will stop all lockspace activity when nodes
join/leave, that is something I want to look at when I hopefully have
this patch series upstream.

Another example is the DLM lock verifier [0], and I need to be careful
with the name lock verifier. It verifies that only compatible lock
modes can be in use at the same time on a per "network entity" basis.
This is the fundamental mechanism of DLM, if this does not work DLM is
broken. We can do that now because we know the whole cluster
information. We can confirm on any payload that DLM works correctly.
For me, this alone is worth having this feature.

For example, we can introduce a new sort of cluster file system
xfstests, touch /cluster/node1/foo and check if the file shows up in
/cluster/node2/foo. That is an easy example, sometimes we need to
synchronize vfs operations and check them on the other "network
entity". With this feature we don't need to synchronize our "testing
script" over the network anymore with other processes running on other
"network entities".

In real life there is maybe not an example yet. Maybe when people
start to use DLM for user space locking on a container basis, but this
requires net-namespace user space locking functionality that is a
future step.

> > Limitations
>
> > I disable any functionality for the DLM character device that allow
> > plock handling or do DLM locking from user space. Just don't use any
> > plock locking in gfs2 for now. But basic vfs operations should work. Yo=
u
> > can even sniff DLM traffic on the created "dlmsw" virtual bridge.
>
> So... what functionality is exposed by this patchset?  And Maybe add
> in an "Advantages" section to explain why this is so good.
>

Sure, it is important to mention that this net-namespace functionality
is experimental. If you use DLM without changing the net-namespace
process context it should work as before, in this case there are no
limitations.

- Alex

[0] https://lore.kernel.org/gfs2/20240827180236.316946-1-aahringo@redhat.co=
m/T/#t

