From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 7 Jul 2010 13:04:18 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: When zero extending,
	do it by page.
In-Reply-To: <4C349AFF.9040301@oracle.com>
References: <20100703213219.GB21262@mail.oracle.com>
	<1278501367-7710-2-git-send-email-joel.becker@oracle.com>
	<4C349AFF.9040301@oracle.com>
Message-ID: <20100707200418.GB22311@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tao Ma <tao.ma@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

On Wed, Jul 07, 2010 at 11:19:27PM +0800, Tao Ma wrote:
> >+static handle_t *ocfs2_zero_start_ordered_transaction(struct inode *inode)
> >+{
> >+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> >+	handle_t *handle = NULL;
> >+	int ret = 0;
> >+
> >+	if (ocfs2_should_order_data(inode))
> This should be if (!ocfs2_should_order_data(inode)) I guess? ;)

	Of course it should.  Fixed ;-)

Joel


-- 

"Too much walking shoes worn thin.
 Too much trippin' and my soul's worn thin.
 Time to catch a ride it leaves today
 Her name is what it means.
 Too much walking shoes worn thin."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
