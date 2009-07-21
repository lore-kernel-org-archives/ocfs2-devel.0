From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 21 Jul 2009 12:46:54 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: flush dentry lock drop when sync
 ocfs2 volume.
In-Reply-To: <20090721085806.GA4775@duck.suse.cz>
References: <1248080922-24908-1-git-send-email-tao.ma@oracle.com>
	<20090720123401.GA15341@duck.suse.cz>
	<20090720190846.GA7768@mail.oracle.com>
	<20090720202524.GB7768@mail.oracle.com>
	<20090721085806.GA4775@duck.suse.cz>
Message-ID: <20090721194654.GA19170@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jul 21, 2009 at 10:58:06AM +0200, Jan Kara wrote:
> > 	A quick #ocfs2 discussion ensued.  Let's rename OCFS2_OSB_UMOUNT
> > to OCFS2_OSB_DROP_DENTRY_LOCK_IMMED.  That flag doesn't mean anything
> > other than the dentry lock behavior, so we'll name it specific to its
> > purpose.
> > 	I think the rest of the patch looked good, so please resend with
> > the renamed flag and a clean patch header and I'll verify and apply.
>   OK, attached is updated version of the patch.

	Still says OSB_UMOUNT.  Attached the wrong version?

> BTW, Joel, did you have any chance of looking at the quota fixes I've sent
> you last week?

	Not yet, I'm going to try to get to them today.  Patch review
requires brain power :-)

Joel

-- 

"The nice thing about egotists is that they don't talk about other
 people."
         - Lucille S. Harper

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
