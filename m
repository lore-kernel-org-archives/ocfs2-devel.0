From: Jan Kara <jack@suse.cz>
Date: Fri, 14 May 2010 10:08:03 +0200
Subject: [Ocfs2-devel] Quota locking fixes for OCFS2
In-Reply-To: <20100513235114.GE13692@mail.oracle.com>
References: <1273780683-3638-1-git-send-email-jack@suse.cz>
	<20100513235114.GE13692@mail.oracle.com>
Message-ID: <20100514080803.GB3488@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu 13-05-10 16:51:14, Joel Becker wrote:
> On Thu, May 13, 2010 at 09:57:56PM +0200, Jan Kara wrote:
> > Currently ocfs2 with quotas survives fsstress and fsx runs without oopsing
> 
> 	When you say "currently," do you mean mainline ocfs2 or
> ocfs2 with these patches? ;-)  I'm guessing you mean with these patches.
  I meant ocfs2 with these patches :)

> > The patch set is on top of:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6 for_next
> > 
> > Since it really depends on some of the cleanups I have there we have to
> > somehow resolve how to merge it. Either I can do it after getting your
> > acks or if you wish to wait with the changes until after the merge window,
> > I can merge all the generic quota bits and ocfs2 patches can be pulled
> > into ocfs2 tree after that.
> 
> 	I'm fine with Acking this series for you to send with your
> cleanups.  They're all going in the merge window, right?
  Yes, I plan to submit them during the merge window...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
