From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 12 Aug 2010 18:28:05 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Cache some system inodes of other
	nodes.
In-Reply-To: <4C649E16.7040704@oracle.com>
References: <1281603796-3867-1-git-send-email-tao.ma@oracle.com>
	<20100812094350.GB6561@mail.oracle.com>
	<4C6499F7.8080509@oracle.com> <4C649E16.7040704@oracle.com>
Message-ID: <20100813012805.GI22777@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Aug 13, 2010 at 09:21:26AM +0800, Tao Ma wrote:
> Sunil Mushran wrote:
> >        if (is_global_system_inode(type)
> >                arr = &(osb->global_system_inodes[type]);
> >        else {
> >                BUG_ON(slot == OCFS2_INVALID_SLOT);
> >                BUG_ON(type < OCFS2_FIRST_LOCAL_SYSTEM_INODE ||
> >                        type > LOCAL_GROUP_QUOTA_SYSTEM_INODE);
> >                tmp = (slot * NUM_LOCAL_SYSTEM_INODES) +
> >                      (type - OCFS2_FIRST_LOCAL_SYSTEM_INODE);
> >                arr = &(osb->local_system_inodes[tmp];
> >        }
> >
> >How does this look?
> oh, since both of you prefer a simple system_inode array, I will
> rework it. Thanks.

	In Sunil's proposal, you can easily keep the "which remote
inodes to keep" question very local.

		if ((slot == my_slot) ||
		    (type == TYPE1) ||
		    (type == TYPE2) ...) {
			local_system_inodes[x] = inode;

Joel


-- 

"Conservative, n.  A statesman who is enamoured of existing evils,
 as distinguished from the Liberal, who wishes to replace them
 with others."
	- Ambrose Bierce, The Devil's Dictionary

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
