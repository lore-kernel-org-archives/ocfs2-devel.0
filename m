From: Jan Kara <jack@suse.cz>
Date: Thu, 20 Nov 2008 20:33:20 +0100
Subject: [Ocfs2-devel] [PATCH 00/00] Implement quotas for OCFS2 (version
	2)
In-Reply-To: <20081106010916.GA15154@wotan.suse.de>
References: <12248859043309-git-send-email-jack@suse.cz>
	<20081106010916.GA15154@wotan.suse.de>
Message-ID: <20081120193320.GG20118@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hi Mark,

On Wed 05-11-08 17:09:16, Mark Fasheh wrote:
> On Sat, Oct 25, 2008 at 12:05:04AM +0200, Jan Kara wrote:
> > Hello,
> > 
> > the following patch series implements quotas for OCFS2. The patch
> > series is based on:
> > git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git linux-next
> > 
> > I've adressed Joel's comments, also node recovery is now fully working
> > and I've fixed a few issues I found during my testing. So I'm currently
> > not aware of any bugs. Please review, test, comment. Thanks.
> 
> Ok, so these patches look pretty good. I've made comments via e-mail and for
> the most part, I'm done reviewing. There's always the chance I see something
> later (especially once I have it in front of me in the form of a git
> branch). None of the comments I had so far though were so critical that we'd
> need to wait on inclusion in ocfs2.git for at least preliminary testing. I'd
> like your opinion on that first though, before I proceed.
  Attached is a tarball of patches rebased on top of your linux-next branch
from yesterday. The patches also contain changes you asked for in your
review (except for checking all quota files on node recovery - I'll
implement that when we agree that is the way to go). I think you can merge
them in the state in which they are.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2-patches.tar.gz
Type: application/x-compressed-tar
Size: 68764 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20081120/6eb00997/attachment-0001.bin 
