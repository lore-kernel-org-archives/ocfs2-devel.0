From: Jan Kara <jack@suse.cz>
Date: Mon, 17 May 2010 23:30:18 +0200
Subject: [Ocfs2-devel] Quota locking fixes for OCFS2
In-Reply-To: <20100517191746.GA22775@mail.oracle.com>
References: <1273780683-3638-1-git-send-email-jack@suse.cz>
	<20100513235114.GE13692@mail.oracle.com>
	<20100514080803.GB3488@quack.suse.cz>
	<20100514193622.GC29764@mail.oracle.com>
	<20100517161801.GA3364@quack.suse.cz>
	<20100517191746.GA22775@mail.oracle.com>
Message-ID: <20100517213018.GE3364@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon 17-05-10 12:17:46, Joel Becker wrote:
> On Mon, May 17, 2010 at 06:18:01PM +0200, Jan Kara wrote:
> >   OK, will do. In the mean time I have found one more possible deadlock
> > which should be fixed by the attached patch so I'll add it to the series
> > if you won't object.
> 
> 	One question: is it possible for additional work to be added
> between the time we call the cancel and the time we take the
> dqonoff_mutex?  If it is not possible, ack on the patch and put it in
> the series.
  It isn't possible. There are only two places that queue work to this
workqueue. The first one is called when quota is being enabled (i.e., during
mount) and the second one is called from qsync_work_fn() itself. Now
cancel_delayed_work_sync() has an explicit note in the comment before it
that "It is possible to use this function if @dwork rearms itself via
queue_work() or queue_delayed_work()." so I believe everything is fine.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
