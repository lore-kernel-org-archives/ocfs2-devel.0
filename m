From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 22 Jan 2010 16:15:40 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: add extent block stealing for
	ocfs2 v4
In-Reply-To: <20100123001322.GA8165@mail.oracle.com>
References: <> <1264147166-9097-1-git-send-email-tiger.yang@oracle.com>
	<20100123001322.GA8165@mail.oracle.com>
Message-ID: <20100123001540.GB8165@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 22, 2010 at 04:13:22PM -0800, Joel Becker wrote:
> > +	atomic_set(&osb->s_num_meta_stolen, 0);
> >  	status = ocfs2_reserve_suballoc_bits(osb, (*ac),
> >  					     EXTENT_ALLOC_SYSTEM_INODE,
> > -					     slot, NULL, ALLOC_NEW_GROUP);
> > +					     (u32)osb->slot_num, NULL,
> 
> 	The int-vs-u32 casting is weird.  Note sure what to make of it.
> Why does ocfs2_reserve_suballoc_bits() take a u32 instead of an int?

	Oh, because the alloc context has a u32.  I blame someone.  But
let's leave it as you have it for now.

Joel

-- 

"Depend on the rabbit's foot if you will, but remember, it didn't
 help the rabbit."
	- R. E. Shay

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
