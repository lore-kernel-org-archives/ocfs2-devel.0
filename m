Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CCF7BB0A
	for <ocfs2-devel@lists.linux.dev>; Tue, 12 Mar 2024 19:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710273364; cv=none; b=tBILEbxIDdgybvk4kCR0cLtp6liCqQok7pMZdUVWg0uUOnMb1RGtBFkfQ5zNxj906Dww8DucYVozmLYQaxCeJgTG++nFXhvyHraBd9AgOz//pC+BpSVFvtnwmrSy5HxeeEnVcpZaFfqgEfWkHreGuR722LzJsHni9At4rJkmKDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710273364; c=relaxed/simple;
	bh=zaQRN2eIIcIFUCcUV85M49ifGyoWTWILoUBmWvh9DVw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yk8jt3MGkJJUFoolWtLkmTiTjecYR2iULE31fpY1B/KTt2DNBj0HS0WP95NZI4uA6qxsdZp/mOqW8QEW9iPEqq7Ftj/GOWA6nzcABuzU4woZyAENU6f4SntLSKU64PtSd3bm/sgcc/T+Uhw3hAGfdYM694a9wRxhrvgtebjLXoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PN+tQx4y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PN+tQx4y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710273360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zaQRN2eIIcIFUCcUV85M49ifGyoWTWILoUBmWvh9DVw=;
	b=PN+tQx4yLMsmZ/lAH5mwtObRJNbK58I806hzarWRaSBXehu+b9ETdFf9aPb4kqtmyxUVsl
	LwFeovuUtrEqdz44+qk7mzTsBB2XqFIAw7UnzoOhU/BiCAOlqlRhm8AqRu23DPW4MjCtSg
	ZdT635z7R0zM8T33Sqtn8y3mokhdeLs=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-OvDTUJjgP0uJLjj7MM-nLw-1; Tue, 12 Mar 2024 15:55:59 -0400
X-MC-Unique: OvDTUJjgP0uJLjj7MM-nLw-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2d359de20dcso42102071fa.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 12 Mar 2024 12:55:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710273357; x=1710878157;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zaQRN2eIIcIFUCcUV85M49ifGyoWTWILoUBmWvh9DVw=;
        b=Fvnjar+e5AnT/n/tLw64BHmElDN+YFlDCwZdpqe77MgE8PIksFajn0pFUpz7olExsu
         13aOMZHQTEZAPlg7mNzYbsISnyUQvsxtcEXyK0tSd60I63AeTCF405uQTidJBRtxTjiV
         LQ5/LTlJyGFEbCEwd1cZt4aL75bPiVwSHkQNzO7yucNtpbRuTACt6gKUKDGX8yJGgdR/
         ud610fheR5rMEpj5wJRusHlCvH0gvMdH8v6iDQGKZoTdRDXJVIjwQF/0YBpQucmOC86U
         yR7buM7gyOhOBcDBf+bE6LyYdCdeVn0zsCf7jW92iV+9L88mHjdk5Iq3Ap2/i4NnCZE+
         osDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDWExajQyEgmsbY3VQ2oebriGhJy4zzBXwt5EEIJKy9TzqCLVVpp62SV1JFdLXI7u6uenYdZBvkjjcr/hmTIyo4cib0O7ZKgeB8rw=
X-Gm-Message-State: AOJu0YzZnGGE4+BT5hPrQ8eh0pnnKRCJYICaF7yRulhU0sIn7CI+Rma8
	4aqwv/ABmPT43fqKpzQAUKnj0uvXiTQ6UScOCvBu8F8zEVmGanU7vAnqWokvaoUqBLMLBGsxy4m
	MR736HutbTOHvk/NdnDKMg+vpfkZaqlPtP7w60xQBQVFPIJkmo9/8JIBO+tQx+iYNlIjjYi5trq
	E2MSBjSZaa9T5ESVWuNuUqmeaWsZ9Qdr0PQkE=
X-Received: by 2002:a2e:be26:0:b0:2d4:62b7:4c7b with SMTP id z38-20020a2ebe26000000b002d462b74c7bmr1514945ljq.51.1710273357720;
        Tue, 12 Mar 2024 12:55:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5H+kB3eQomR79ZQeTw0LDVGA2kOYjA46qEsLN8P2NCCQiAV7njySR5I4rjzLMebkFnec6JaD2L/NiSVgxDfo=
X-Received: by 2002:a2e:be26:0:b0:2d4:62b7:4c7b with SMTP id
 z38-20020a2ebe26000000b002d462b74c7bmr1514935ljq.51.1710273357339; Tue, 12
 Mar 2024 12:55:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Ze4qSvzGJDt5yxC3@valentin-vidic.from.hr> <49396145-712d-44eb-884e-58eb19b1f4f2@linux.alibaba.com>
 <Ze7IiZmlhRaOgdhm@valentin-vidic.from.hr> <CAK-6q+jFv8tK4rF-xY6okTwhK87zMtOKP6fthzCQ-H8-4q=wbQ@mail.gmail.com>
 <Ze9bIiT3rAWTtPJp@valentin-vidic.from.hr> <CAK-6q+j2UDh0mi0KUTdtsRE8pj4+tuw_SU+yjzjsR3GCLURz=w@mail.gmail.com>
 <ZfANyOkQh4SgXoty@valentin-vidic.from.hr> <CAK-6q+hBa08LoAEhsdiiG4DarCGF-CWy41zDjU3zB81P7hHx1A@mail.gmail.com>
 <ZfCg6o3Kmkq78SIG@valentin-vidic.from.hr>
In-Reply-To: <ZfCg6o3Kmkq78SIG@valentin-vidic.from.hr>
From: Alexander Aring <aahringo@redhat.com>
Date: Tue, 12 Mar 2024 15:55:46 -0400
Message-ID: <CAK-6q+j8Ag5yj6pn0P4wC2kRSNMVaHGmVY+G6+H5aYD1-ygzSw@mail.gmail.com>
Subject: Re: ocfs2 mount error
To: =?UTF-8?Q?Valentin_Vidi=C4=87?= <vvidic@valentin-vidic.from.hr>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com, 
	David Teigland <teigland@redhat.com>, gfs2@lists.linux.dev, ocfs2-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Mar 12, 2024 at 2:37=E2=80=AFPM Valentin Vidi=C4=87
<vvidic@valentin-vidic.from.hr> wrote:
>
> On Tue, Mar 12, 2024 at 01:55:54PM -0400, Alexander Aring wrote:
> > I was able to reproduce the issue and sent a fix out.
>
> Yay, thanks a lot for testing, I can confirm the patches fix the problem
> for me!
>

Then you can reply to the mail with:

Tested-by: Valentin Vidi=C4=87 <vvidic@valentin-vidic.from.hr>

that would help to bring the fix upstream.

> > If you want to extend your debian testing using different approach
> > (not libdlm) this can be done by:
> >
> > mount -t ocfs2_dlmfs none /dlm
>
> I tried that but fsck than fails to make a lock, so I think ocfs2_dlmfs
> is only relevant when used with o2cb cluster type instead of corosync.
>

Yes, I think you are right. It is a replacement for
corosync/dlm_controld handling. It seems I had both setup working at
the same time, but it still uses kernel DLM locking.

> > I am curious about your testing at debian cluster, do you also test gfs=
2?
>
> Yes, a similar test for gfs2 would be this:
>
> https://salsa.debian.org/ha-team/gfs2-utils/-/blob/master/debian/tests/co=
rosync?ref_type=3Dheads
>
> It is not really a cluster test since it only runs on one KVM
> machine. But as a package test it works well because even for
> 1-node cluster all the code (userspace and kernel) still needs
> to work correctly.
>

I see, I currently have plans/ideas to add namespace support into
kernel DLM that might help you by extending your testing. The general
idea would be that you can do something like:

...
ip netns exec node1 mount /dev/fake_shared_block /mnt/node1
ip netns exec node2 mount /dev/fake_shared_block /mnt/node2
ip netns exec node3 mount /dev/fake_shared_block /mnt/node3
...

I hope that somehow explains the idea behind it. Setup your cluster
networking with namespaces, e.g. selftests of Linux kernel is doing it
[0] and the DLM lockspaces are separated by net namespaces*. It
"should" run like a cluster with several machines, it is only to do
more testing and we don't need to synchronize tests over the network.
However it will _not_ replace real cluster testing but it is a
starting point to make testing "simpler". Somewhere is even a big fat
"software" switch you can run wireshark on it to see all cluster
traffic going on.

* In theory I am only abusing net namespaces for separate DLM
lockspaces, but I don't want to introduce another kind of namespace
now. However net namespaces fit here because it is necessary for a per
node networking setup anyway.

- Alex

[0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/tools/testing/selftests/net/icmp.sh

