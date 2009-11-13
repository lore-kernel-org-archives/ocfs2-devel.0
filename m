From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 13 Nov 2009 03:56:10 -0800
Subject: [Ocfs2-devel] [patch] Fix: 'return -ENOMEM' instead of 'return
	ENOMEM'
In-Reply-To: <20091113075306.GB2775@elte.hu>
References: <4AFB2C0B.50605@gmail.com>
	<20091111134730.a0da9e38.akpm@linux-foundation.org>
	<20091112081043.GA25345@elte.hu>
	<20091112191758.GA22985@mail.oracle.com>
	<20091112202728.GC22985@mail.oracle.com>
	<20091113075306.GB2775@elte.hu>
Message-ID: <20091113115610.GB28530@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "Stephen M. Cameron" <scameron@beardog.cca.cpqcorp.net>, Mike Christie <michaelc@cs.wisc.edu>, David Airlie <airlied@linux.ie>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, Evgeniy Polyakov <zbr@ioremap.net>, iss_storagedev@hp.com, Eric Dumazet <eric.dumazet@gmail.com>, Andy Whitcroft <apw@shadowen.org>, Dave Airlie <airlied@redhat.com>, Hannes Eder <hannes@hanneseder.net>, dri-devel@lists.sourceforge.net, Alexey Dobriyan <adobriyan@gmail.com>, Mike Miller <mike.miller@hp.com>, Mark Fasheh <mfasheh@suse.com>, Karsten Keil <isdn@linux-pingi.de>, rostedt@goodmis.org, Karen Xie <kxie@chelsio.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>, Andreas

On Fri, Nov 13, 2009 at 08:53:06AM +0100, Ingo Molnar wrote:
> > Sorry, I read the code wrong.  This function is just a handler. The 
> > caller, dlm_send_begin_reco_message(), expects the positive EAGAIN as 
> > a non-error case.
> 
> Well, at minimum the error code usage is very confused. The 
> dlm_begin_reco_handler gets registered via o2net_register_handler(). 
> Here's where dlm_begin_reco_handler gets registered, followed by 
> dlm_finalize_reco_handler right afterwards:
<snip> 
> A negative error code right there. The other event handlers are seem to 
> be similar - dlm_begin_reco_handler() is the odd one out.

	The usage of the handlers - 'status' is the return code of the
handler - is pretty straightforward.  Once you're in the mindset of the
o2net code, of course.  This is old stuff, from the earliest days of
ocfs2 development, so we haven't had to spelunk in here for a while ;-)
	Sunil and I both thought while looking at this code that we
could probably return -EAGAIN just as easily, though.  We'll probably
clean it that way at some point.

Joel

-- 

 There are morethings in heaven and earth, Horatio,
 Than are dreamt of in your philosophy.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
