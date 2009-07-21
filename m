From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 21 Jul 2009 15:49:04 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: flush dentry lock drop when sync
 ocfs2 volume.
In-Reply-To: <20090721223902.GA19591@duck.suse.cz>
References: <1248080922-24908-1-git-send-email-tao.ma@oracle.com>
	<20090720123401.GA15341@duck.suse.cz>
	<20090720190846.GA7768@mail.oracle.com>
	<20090720202524.GB7768@mail.oracle.com>
	<20090721085806.GA4775@duck.suse.cz>
	<20090721194654.GA19170@mail.oracle.com>
	<20090721223902.GA19591@duck.suse.cz>
Message-ID: <20090721224904.GI19170@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 22, 2009 at 12:39:02AM +0200, Jan Kara wrote:
> On Tue 21-07-09 12:46:54, Joel Becker wrote:
> > On Tue, Jul 21, 2009 at 10:58:06AM +0200, Jan Kara wrote:
> > > > 	A quick #ocfs2 discussion ensued.  Let's rename OCFS2_OSB_UMOUNT
> > > > to OCFS2_OSB_DROP_DENTRY_LOCK_IMMED.  That flag doesn't mean anything
> > > > other than the dentry lock behavior, so we'll name it specific to its
> > > > purpose.
> > > > 	I think the rest of the patch looked good, so please resend with
> > > > the renamed flag and a clean patch header and I'll verify and apply.
> > >   OK, attached is updated version of the patch.
> > 
> > 	Still says OSB_UMOUNT.  Attached the wrong version?
>   Drat, you're right. Now it should be the right version...

Looks it.  Thanks.  This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"I am working for the time when unqualified blacks, browns, and
 women join the unqualified men in running our overnment."
	- Sissy Farenthold

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
