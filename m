From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 29 Jul 2009 11:32:51 -0700
Subject: [Ocfs2-devel] [PATCH 09/10] Implement quota support for
 disabling SPARSE feature
In-Reply-To: <20090729101245.GE19209@duck.suse.cz>
References: <1248776322-14987-1-git-send-email-jack@suse.cz>
	<1248776322-14987-2-git-send-email-jack@suse.cz>
	<20090729013945.GF20595@mail.oracle.com>
	<20090729101245.GE19209@duck.suse.cz>
Message-ID: <20090729183251.GC5849@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 29, 2009 at 12:12:45PM +0200, Jan Kara wrote:
> On Tue 28-07-09 18:39:45, Joel Becker wrote:
> > I read this as we adjust the quota but don't enforce it.  That is, if
> > filling a hole will make a user over quota, we allow that to happen.
> > Right?
>   Yes, that's what I've decided makes the most sense. It's in the spirit
> of "superuser ignores quota limits". Alternatively, we could issue a
> warning or even fail the conversion when some user would go over quota
> limit but I don't really see the use case.

	I agree, the superuser is asking for sparse to be removed, and
they have no quota.  Upon remount, the regular user obviously can't
create anything until they get below quota.  So this is the right
behavior.

Joel

-- 

"Sometimes one pays most for the things one gets for nothing."
        - Albert Einstein

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
