From: Jan Kara <jack@suse.cz>
Date: Tue, 21 Oct 2008 21:13:46 +0200
Subject: [Ocfs2-devel] [PATCH] quota: Remove bogus 'optimization'
	in	check_idq() and check_bdq()
In-Reply-To: <20081021172956.GB10060@mail.oracle.com>
References: <1224523440201-git-send-email-jack@suse.cz>
	<20081021172956.GB10060@mail.oracle.com>
Message-ID: <20081021191345.GF8199@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 21-10-08 10:29:57, Joel Becker wrote:
> On Mon, Oct 20, 2008 at 07:23:36PM +0200, Jan Kara wrote:
> > Checks like <= 0 for an unsigned type do not make much sence. The value
> > could be only 0 and that does not happen often enough for the check
> > to be worth it.
> 
> 	Why not worth it?  Certainly the '<' isn't valid, but is it even
> possible to call these functions with 0?  I don't know enough to answer
> that, but I'm wondering if it should BUG_ON(inodes == 0).  If not, what
> happens after this change?  Obviously inodes==0 means the quota doesn't
> change, but could they get a soft warning they wouldn't get before?
  In theory, yes, user would now get a warning when he previously did not
get it. But I would consider that to be an advantage (warning is issued at
most once and it could happen that warning is not issued yet only because
of some unusual reason like root chowned a file to the user and got him
over quota)... Anyway I'm not aware of a place which would actually call the
code with 0 so I think this is mostly academic question :).
  Anyway, thanks for comments.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
