From: roel kluin <roel.kluin@gmail.com>
Date: Thu, 12 Nov 2009 10:31:23 +0100
Subject: [Ocfs2-devel] [patch] Fix: 'return -ENOMEM' instead of 'return
	ENOMEM'
In-Reply-To: <20091112081043.GA25345@elte.hu>
References: <4AFB2C0B.50605@gmail.com>
	<20091111134730.a0da9e38.akpm@linux-foundation.org>
	<20091112081043.GA25345@elte.hu>
Message-ID: <25e057c00911120131q577f18c5v479b9d6f5f8616a6@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "Stephen M. Cameron" <scameron@beardog.cca.cpqcorp.net>, Mike Christie <michaelc@cs.wisc.edu>, David Airlie <airlied@linux.ie>, Jens Axboe <jens.axboe@oracle.com>, Evgeniy Polyakov <zbr@ioremap.net>, iss_storagedev@hp.com, Eric Dumazet <eric.dumazet@gmail.com>, Joel Becker <joel.becker@oracle.com>, Jeff Liu <jeff.liu@oracle.com>, Andy Whitcroft <apw@shadowen.org>, Dave Airlie <airlied@redhat.com>, Hannes Eder <hannes@hanneseder.net>, dri-devel@lists.sourceforge.net, Alexey Dobriyan <adobriyan@gmail.com>, Mike Miller <mike.miller@hp.com>, Mark Fasheh <mfasheh@suse.com>, Karsten Keil <isdn@linux-pingi.de>, rostedt@goodmis.org, Karen Xie <kxie@chelsio.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>, Andreas Eversberg <andreas@eversberg.eu>

> * Andrew Morton <akpm@linux-foundation.org> wrote:

>> Andy, can we have a checkpatch rule please?
>
> Note, that will upset creative uses of error codes i guess, such as
> fs/xfs/.
>
> But yeah, +1 from me too.
>
> Ob'post'mortem - looked for similar patterns in the kernel and there's
> quite a few bugs there:
>
> ?include/net/inet_hashtables.h: ? ? ? ? ? ? ? ? ?return ENOMEM; ? ? ? ? # bug
> ?drivers/scsi/aic7xxx/aic7xxx_osm.c: ? ? ? ? ? ? return ENOMEM; ? ? ? ? # works but weird
> ?drivers/scsi/cxgb3i/cxgb3i_offload.c: ? ? ? ? ? return ENOMEM; ? ? ? ? # works but weird
> ?fs/ocfs2/dlm/dlmrecovery.c: ? ? ? ? ? ?return EAGAIN; ? ? ? ? ? ? ? ? ?# bug
> ?drivers/block/cciss_scsi.c: ? ? ? ? ? ? return ENXIO; ? ? ? ? ? ? ? ? ?# works but weird
> ?drivers/gpu/drm/radeon/radeon_irq.c: ? ? ? ? ? ? ? ? ? ?return EINVAL; # bug
> ?drivers/gpu/drm/radeon/radeon_irq.c: ? ? ? ? ? ? ? ? ? ?return EINVAL; # bug
> ?drivers/isdn/hardware/mISDN/hfcmulti.c: ? ? ? ? return EINVAL; ? ? ? ? # bug

I noticed some of these as well. I found some more and sent
a few patches last night with a regex like:

git grep -n -E "[^=]=[[:space:]]*E[[:upper:]2]+ *;"

I am not 100% sure this doesn't give many falsies, I am not at home
so cannot test right now. Something like this can show how
common/uncommon these are:

git grep -E "[^=]=[[:space:]]*E[[:upper:]2]+ *;" |
sed -r "s/^([^:]*:).*(return|[^=]=)[[:space:]]*(-?E)[[:upper:]2]+
*;.*$/\1 \3/" |
sort | uniq -c

> 5 out of 8 places look buggy - i.e. more than 60% - a checkpatch warning
> would avoid real bugs here. (even ignoring the cleanliness effects of
> using proper error propagation)

> ? ? ? ?Ingo


Thanks for picking this up,

Roel
