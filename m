From: Jan Kara <jack@suse.cz>
Date: Thu, 15 Oct 2009 12:34:04 +0200
Subject: [Ocfs2-devel] [PATCH 0/5] Quota support for disabling
	inline-data feature	(v2) and a fix
In-Reply-To: <20091014200453.GD4530@mail.oracle.com>
References: <1255543739-23844-1-git-send-email-jack@suse.cz>
	<20091014200453.GD4530@mail.oracle.com>
Message-ID: <20091015103404.GB5971@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed 14-10-09 13:04:53, Joel Becker wrote:
> On Wed, Oct 14, 2009 at 08:08:54PM +0200, Jan Kara wrote:
> >   here is a new version of the patch to implement quota support for disabling
> > inline-data feature. Now, main functions for changing quotas are implemented
> > in libocfs2 as Joel asked and used from tunefs.ocfs2. Disabling of sparse
> > feature is changed to use these functions as well.
> >   Finally, the series contains a fix to not load quota information from disk
> > when it's already in memory (happens when tunefs is asked to do several
> > operations at once) and a rebased patch to do not account for space used
> > by sparse system files when disabling sparse feature.
> > 
> > 								Honza
> 
> Any chance you can resend these to ocfs2-tools-devel?  I just want to
> make sure folks involved in tools work get to see them.
  I've bounced them there already yesterday when I realized the problem
(but it takes some time to reach the list since I'm not a member of
ocfs2-tools-devel and thus moderator approval is needed). Or do you think I
should resend the series again? I didn't want to spam involved people...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
