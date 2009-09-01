From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 1 Sep 2009 01:26:54 -0700
Subject: [Ocfs2-devel] [PATCH 01/14] ocfs2: Introduce ocfs2_xa_loc
In-Reply-To: <4A9CB1F5.3050809@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-2-git-send-email-joel.becker@oracle.com>
	<4A9CB1F5.3050809@oracle.com>
Message-ID: <20090901082652.GA3826@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 01, 2009 at 01:32:37PM +0800, Tao Ma wrote:
> Joel Becker wrote:
> >+static void *ocfs2_xa_block_offset_pointer(struct ocfs2_xa_loc *loc,
> >+					   int offset)
> >+{
> >+	struct buffer_head *bh = loc->xl_storage;
> >+
> >+	BUG_ON(offset >= bh->b_size);
> >+	return bh->b_data + offset;
> >+}
> It looks that the "offset" is from the start of the buffer, while in
> your description above "offset" is from "loc->xl_header". In both
> inline and block case, header != buffer_start. xl_size seems to be
> against xl_header, so I would guess here you need to change somehow.

	Doh!  That's a bug.  The description matches reality -
xe_name_offset is from the start of the header, not the block, right?
So this function is just wrong!

Joel

-- 

"We will have to repent in this generation not merely for the
 vitriolic words and actions of the bad people, but for the 
 appalling silence of the good people."
	- Rev. Dr. Martin Luther King, Jr.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
