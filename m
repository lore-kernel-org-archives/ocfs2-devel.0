From: Jan Kara <jack@suse.cz>
Date: Mon, 17 May 2010 18:18:01 +0200
Subject: [Ocfs2-devel] Quota locking fixes for OCFS2
In-Reply-To: <20100514193622.GC29764@mail.oracle.com>
References: <1273780683-3638-1-git-send-email-jack@suse.cz>
	<20100513235114.GE13692@mail.oracle.com>
	<20100514080803.GB3488@quack.suse.cz>
	<20100514193622.GC29764@mail.oracle.com>
Message-ID: <20100517161801.GA3364@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri 14-05-10 12:36:23, Joel Becker wrote:
> On Fri, May 14, 2010 at 10:08:03AM +0200, Jan Kara wrote:
> > On Thu 13-05-10 16:51:14, Joel Becker wrote:
> > > On Thu, May 13, 2010 at 09:57:56PM +0200, Jan Kara wrote:
> > > > Since it really depends on some of the cleanups I have there we have to
> > > > somehow resolve how to merge it. Either I can do it after getting your
> > > > acks or if you wish to wait with the changes until after the merge window,
> > > > I can merge all the generic quota bits and ocfs2 patches can be pulled
> > > > into ocfs2 tree after that.
> > > 
> > > 	I'm fine with Acking this series for you to send with your
> > > cleanups.  They're all going in the merge window, right?
> >   Yes, I plan to submit them during the merge window...
> 
> 	Ok, you can add my Acked-by to these and push them to Linus at
> merge time.
  OK, will do. In the mean time I have found one more possible deadlock
which should be fixed by the attached patch so I'll add it to the series
if you won't object.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
-------------- next part --------------
A non-text attachment was scrubbed...
Name: 0001-ocfs2-Fix-lock-inversion-in-quotas-during-umount.patch
Type: text/x-patch
Size: 2089 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20100517/44d19161/attachment.bin 
