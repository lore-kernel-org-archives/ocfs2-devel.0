From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 12 Nov 2009 11:17:58 -0800
Subject: [Ocfs2-devel] [patch] Fix: 'return -ENOMEM' instead of 'return
	ENOMEM'
In-Reply-To: <20091112081043.GA25345@elte.hu>
References: <4AFB2C0B.50605@gmail.com>
	<20091111134730.a0da9e38.akpm@linux-foundation.org>
	<20091112081043.GA25345@elte.hu>
Message-ID: <20091112191758.GA22985@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "Stephen M. Cameron" <scameron@beardog.cca.cpqcorp.net>, Mike Christie <michaelc@cs.wisc.edu>, David Airlie <airlied@linux.ie>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, Evgeniy Polyakov <zbr@ioremap.net>, iss_storagedev@hp.com, Eric Dumazet <eric.dumazet@gmail.com>, Andy Whitcroft <apw@shadowen.org>, Dave Airlie <airlied@redhat.com>, Hannes Eder <hannes@hanneseder.net>, dri-devel@lists.sourceforge.net, Alexey Dobriyan <adobriyan@gmail.com>, Mike Miller <mike.miller@hp.com>, Mark Fasheh <mfasheh@suse.com>, Karsten Keil <isdn@linux-pingi.de>, rostedt@goodmis.org, Karen Xie <kxie@chelsio.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>, Andreas

On Thu, Nov 12, 2009 at 09:10:43AM +0100, Ingo Molnar wrote:
> 5 out of 8 places look buggy - i.e. more than 60% - a checkpatch warning 
> would avoid real bugs here. (even ignoring the cleanliness effects of 
> using proper error propagation)
> 
> Cc:-ed affected maintainers. The rightmost column are my observations. 
> Below is the patch fixing these.

Acked-by: Joel Becker <joel.becker@oracle.com>


-- 

"Can any of you seriously say the Bill of Rights could get through
 Congress today?  It wouldn't even get out of committee."
	- F. Lee Bailey

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
