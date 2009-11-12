From: Mike Christie <michaelc@cs.wisc.edu>
Date: Thu, 12 Nov 2009 09:10:53 -0600
Subject: [Ocfs2-devel] [patch] Fix: 'return -ENOMEM' instead of 'return
	ENOMEM'
In-Reply-To: <25e057c00911120131q577f18c5v479b9d6f5f8616a6@mail.gmail.com>
References: <4AFB2C0B.50605@gmail.com>	
	<20091111134730.a0da9e38.akpm@linux-foundation.org>	
	<20091112081043.GA25345@elte.hu>
	<25e057c00911120131q577f18c5v479b9d6f5f8616a6@mail.gmail.com>
Message-ID: <4AFC257D.2050906@cs.wisc.edu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: roel kluin <roel.kluin@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "Stephen M. Cameron" <scameron@beardog.cca.cpqcorp.net>, David Airlie <airlied@linux.ie>, Jens Axboe <jens.axboe@oracle.com>, Evgeniy Polyakov <zbr@ioremap.net>, iss_storagedev@hp.com, Eric Dumazet <eric.dumazet@gmail.com>, Joel Becker <joel.becker@oracle.com>, Jeff Liu <jeff.liu@oracle.com>, Andy Whitcroft <apw@shadowen.org>, Dave Airlie <airlied@redhat.com>, Ingo Molnar <mingo@elte.hu>, dri-devel@lists.sourceforge.net, Alexey Dobriyan <adobriyan@gmail.com>, Mike Miller <mike.miller@hp.com>, Mark Fasheh <mfasheh@suse.com>, Karsten Keil <isdn@linux-pingi.de>, rostedt@goodmis.org, Karen Xie <kxie@chelsio.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>, Andreas Eversberg <andreas@eversberg.eu>, Hannes Eder <hannes@hanneseder.net>, Keith

roel kluin wrote:
>> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>>> Andy, can we have a checkpatch rule please?
>> Note, that will upset creative uses of error codes i guess, such as
>> fs/xfs/.
>>
>> But yeah, +1 from me too.
>>
>> Ob'post'mortem - looked for similar patterns in the kernel and there's
>> quite a few bugs there:
>>
>>  include/net/inet_hashtables.h:                  return ENOMEM;         # bug
>>  drivers/scsi/aic7xxx/aic7xxx_osm.c:             return ENOMEM;         # works but weird
>>  drivers/scsi/cxgb3i/cxgb3i_offload.c:           return ENOMEM;         # works but weird

I think cxgb3i is actually in the buggy category. cxgb3i_c3cn_send_pdus 
can propagate the positive EXYZ error value to other functions which 
assume that errors are negative.

Karen, I made the attached patch over James's scsi-rc-fixes tree while 
reviewing the code. Could you test, finish up and send upstream?
-------------- next part --------------
A non-text attachment was scrubbed...
Name: cxgb3i-use-negative-errno.patch
Type: text/x-patch
Size: 2523 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20091112/09f1764b/attachment.bin 
