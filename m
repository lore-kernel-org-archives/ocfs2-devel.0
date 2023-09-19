Received: from mo4-p03-ob.smtp.rzone.de (mo4-p03-ob.smtp.rzone.de [81.169.146.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30A13B784;
	Tue, 19 Sep 2023 14:59:04 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; t=1695135168; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=iOvNoGriAVw4BG/07a1J6uIof3CWb+6UsSmEBYX+mFyDD9f2QO4Sb9TEKH4ddRJIDy
    pL+qoqUJA0hBoE4nJJQRUmYRrrCYvLF6ta+aYD7VbDg0ud+mbgJHzWwSRqXYR5ZREvcs
    bl3KKbXR7cnsa+lCIA964mIiyg1OT/LsO/TF2FrHwu1Ap2D5rIzbspE4N+uifzZgFcIK
    COMHkjp45ZLpdYvm1mHL/fgF/qpLr3Ss8m6HAe7Z0ayLnnzziqQ/Ve8M0mIoGjiKEXXY
    DzKttOOMKEMKTf6HNofA3SeC0Zyw1CwjchqneHb1ZprMNvSTC6ly89m2hqISShU8ipWO
    EoEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1695135168;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Hu6LWTHD7s/0PwwSBsDsZf9tkhzretwdfBCU6cYVdik=;
    b=jLy0h5BgGkHaTuA6saeMjLcT80O5PDMj8jn0r6tSDDpygqUl+dbmUNK2KZLi3xz36v
    g0+h6MTV2CZKqKfHLAeBYtTJJfvMQrteqrXMAf+YEKI8sPuGyydwMrWtQLIaLuExR1iT
    ivinSDlU9SKzh7cBAAZFAkm4tFYdkD+gAIJ/khpzKYjHS8eYquYbVcwEhmMPjRUSjsJ/
    Xyda/51K4Z+JTv/CxPginA4cOQbB24NRa8A0ACkAg1iZdOLa3LuXWw69p/BQlbcrdUmk
    nDOjL6QI487/iHR7CcqqZHUX3CmeaRWIDTDq0lKjlF6JLf9u9E5GwBe5L4elNs6OFPWg
    /tRQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo03
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1695135168;
    s=strato-dkim-0002; d=clisp.org;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Hu6LWTHD7s/0PwwSBsDsZf9tkhzretwdfBCU6cYVdik=;
    b=fF6//tlGfuaCILPTjW2UXofB8L0JRFiT0ta9GyxmLu/FCo/hW37Kx4K05nm1mWYfZd
    LVW6K8LTlLgwmAHdMNxTGjWLvM3CbMfnEWs6XpLmGxN35UXtfOopJrDhxPXSoAv1kAxk
    txGd6del5ZFz9i7f7QmOOLqULJAgk04E9Inurihh9CTKZ9nagVqkvJz+ZGC16HPzXO5N
    KF+SLwTHn+5drhMusrxLnm/2lhWMaPiVmqnEAm59XcYvwyI3nPVqmk8IusuR43iOH+6V
    azBsyi4ii6sFUL9a23eRkIBKS8HR3R5rirmTCU7G2fe+DZ6pQ7h6YLvKUiFekj0YaORo
    pC6w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1695135168;
    s=strato-dkim-0003; d=clisp.org;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Hu6LWTHD7s/0PwwSBsDsZf9tkhzretwdfBCU6cYVdik=;
    b=6cNjscvMV8QarA/cY83EMrQy954wQIS4PLL+CFn8BrFaSsprhsBVWfpxU4X6tTSJkc
    jxMNKxkGefZPdprJTABg==
X-RZG-AUTH: ":Ln4Re0+Ic/6oZXR1YgKryK8brlshOcZlIWs+iCP5vnk6shH0WWb0LN8XZoH94zq68+3cfpPCifIiwFsCkzyDtyDTaOz6CkM="
Received: from nimes.localnet
    by smtp.strato.de (RZmta 49.8.2 AUTH)
    with ESMTPSA id m03934z8JEqhhDO
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 19 Sep 2023 16:52:43 +0200 (CEST)
From: Bruno Haible <bruno@clisp.org>
To: Jan Kara <jack@suse.cz>, Xi Ruoyao <xry111@linuxfromscratch.org>, bug-gnulib@gnu.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, Tyler Hicks <code@tyhicks.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <huyue2@coolpad.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Miklos Szeredi <miklos@szeredi.hu>, Bob Peterson <rpeterso@redhat.com>, Andreas Gruenbacher <agruenba@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna@kernel.org>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Iurii Zaikin <yzaikin@google.com>, Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, Richard Weinberger <richard@nod.at>, Hans de Goede <hdegoede@redhat.com>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Amir Goldstein <amir73il@gmail.com>, "Darrick J. Wong" <djwong@kernel.org>, Benjamin Coddington <bcodding@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, v9fs@lists.linux.dev, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, ecryptfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-mtd@lists.infradead.org, linux-mm@kvack.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, bug-gnulib@gnu.org, Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v7 12/13] ext4: switch to multigrain timestamps
Date: Tue, 19 Sep 2023 16:52:43 +0200
Message-ID: <4511209.uG2h0Jr0uP@nimes>
In-Reply-To: <1f29102c09c60661758c5376018eac43f774c462.camel@kernel.org>
References: <20230807-mgctime-v7-0-d1dec143a704@kernel.org> <20230919110457.7fnmzo4nqsi43yqq@quack3> <1f29102c09c60661758c5376018eac43f774c462.camel@kernel.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Jeff Layton wrote:
> I'm not sure what we can do for this test. The nap() function is making
> an assumption that the timestamp granularity will be constant, and that
> isn't necessarily the case now.

This is only of secondary importance, because the scenario by Jan Kara
shows a much more fundamental breakage:

> > The ultimate problem is that a sequence like:
> > 
> > write(f1)
> > stat(f2)
> > write(f2)
> > stat(f2)
> > write(f1)
> > stat(f1)
> >
> > can result in f1 timestamp to be (slightly) lower than the final f2
> > timestamp because the second write to f1 didn't bother updating the
> > timestamp. That can indeed be a bit confusing to programs if they compare
> > timestamps between two files. Jeff?
> > 
> 
> Basically yes.

f1 was last written to *after* f2 was last written to. If the timestamp of f1
is then lower than the timestamp of f2, timestamps are fundamentally broken.

Many things in user-space depend on timestamps, such as build system
centered around 'make', but also 'find ... -newer ...'.

Bruno



