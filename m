From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 1 Sep 2009 01:30:47 -0700
Subject: [Ocfs2-devel] [PATCH 06/14] ocfs2: Set the xattr name+value
	pair in one place
In-Reply-To: <4A9CCE33.2070506@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-7-git-send-email-joel.becker@oracle.com>
	<4A9CCE33.2070506@oracle.com>
Message-ID: <20090901083047.GC3826@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 01, 2009 at 03:33:07PM +0800, Tao Ma wrote:
> Joel Becker wrote:
> >+	rc = ocfs2_xa_has_space(loc, xi);
> >+	if (rc)
> >+		goto out;
> could you please add some comments here or change the function name.
> when I read ocfs2_xa_has_space, I always think that "if we have
> space, goto out". But actually we get 0 here if we have space.

	A very good point.  It really should be ocfs2_xa_space_needed().
Does that work?

> >+	if (loc->xl_entry) {
> >+		if (ocfs2_xa_can_reuse_entry(loc, xi)) {
> >+			nameval_buf = ocfs2_xa_offset_pointer(loc,
> >+				le16_to_cpu(loc->xl_entry->xe_name_offset));
> oh, I see you use ocfs2_xa_offset_pointer and offset =
> xe_name_offset here. So in patch 01/14, that is really a bug in
> ocfs2_xa_block_offset_pointer.

	Yeah, total bug.

Joel

-- 

"In a crisis, don't hide behind anything or anybody. They're going
 to find you anyway."
	- Paul "Bear" Bryant

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
