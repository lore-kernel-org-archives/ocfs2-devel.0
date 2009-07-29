From: Jan Kara <jack@suse.cz>
Date: Wed, 29 Jul 2009 12:12:45 +0200
Subject: [Ocfs2-devel] [PATCH 09/10] Implement quota support for
	disabling SPARSE	feature
In-Reply-To: <20090729013945.GF20595@mail.oracle.com>
References: <1248776322-14987-1-git-send-email-jack@suse.cz>
	<1248776322-14987-2-git-send-email-jack@suse.cz>
	<20090729013945.GF20595@mail.oracle.com>
Message-ID: <20090729101245.GE19209@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 28-07-09 18:39:45, Joel Becker wrote:
> On Tue, Jul 28, 2009 at 12:18:41PM +0200, Jan Kara wrote:
> > When filling holes after disabling SPARSE feature, we have to
> > properly update quota information.
> 
> I read this as we adjust the quota but don't enforce it.  That is, if
> filling a hole will make a user over quota, we allow that to happen.
> Right?
  Yes, that's what I've decided makes the most sense. It's in the spirit
of "superuser ignores quota limits". Alternatively, we could issue a
warning or even fail the conversion when some user would go over quota
limit but I don't really see the use case.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
