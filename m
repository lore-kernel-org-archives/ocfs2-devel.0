From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 2 Sep 2009 03:30:37 -0700
Subject: [Ocfs2-devel] [PATCH 06/14] ocfs2: Set the xattr name+value
	pair in one place
In-Reply-To: <4A9E3C18.9070500@oracle.com>
References: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
	<1250711679-12441-7-git-send-email-joel.becker@oracle.com>
	<4A9E3C18.9070500@oracle.com>
Message-ID: <20090902103036.GD10257@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Sep 02, 2009 at 05:34:16PM +0800, Tiger Yang wrote:
> Joel Becker wrote:
> >+
> >+static void ocfs2_xa_add_namevalue(struct ocfs2_xa_loc *loc,
> >+				   struct ocfs2_xattr_info *xi)
> >+{
> >+	int size = namevalue_size_xi(xi);
> >+	int nameval_offset;
> >+	char *nameval_buf;
> >+
> >+	loc->xl_ops->xlo_add_namevalue(loc, size);
> >+	loc->xl_entry->xe_value_size = cpu_to_le64(xi->xi_value_len);
> >+	ocfs2_xattr_set_type(loc->xl_entry, xi->xi_name_index);
> >+	ocfs2_xattr_set_local(loc->xl_entry,
> >+			      xi->xi_value_len <= OCFS2_XATTR_INLINE_SIZE);
> >+
> >+	nameval_offset = le16_to_cpu(loc->xl_entry->xe_name_offset);
> >+	nameval_buf = ocfs2_xa_offset_pointer(loc, nameval_offset);
> >+	memset(nameval_buf, 0, size);
> >+	memcpy(nameval_buf, xi->xi_name, xi->xi_name_len);
> >+}
> In add namevalue, we should update xl_entry->xe_name_len as well. In
> here we only have a blank entry, so we need to fill this one.
> Maybe we should update xe_name_len somewhere else.

	Good catch.  It belongs right here.  Fixed version pushed.

Joel

-- 

"Can any of you seriously say the Bill of Rights could get through
 Congress today?  It wouldn't even get out of committee."
	- F. Lee Bailey

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
