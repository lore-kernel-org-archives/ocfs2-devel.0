From: Tiger Yang <tiger.yang@oracle.com>
Date: Wed, 02 Sep 2009 17:34:16 +0800
Subject: [Ocfs2-devel] [PATCH 06/14] ocfs2: Set the xattr name+value
	pair in one place
In-Reply-To: <1250711679-12441-7-git-send-email-joel.becker@oracle.com>
References: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
	<1250711679-12441-7-git-send-email-joel.becker@oracle.com>
Message-ID: <4A9E3C18.9070500@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> +
> +static void ocfs2_xa_add_namevalue(struct ocfs2_xa_loc *loc,
> +				   struct ocfs2_xattr_info *xi)
> +{
> +	int size = namevalue_size_xi(xi);
> +	int nameval_offset;
> +	char *nameval_buf;
> +
> +	loc->xl_ops->xlo_add_namevalue(loc, size);
> +	loc->xl_entry->xe_value_size = cpu_to_le64(xi->xi_value_len);
> +	ocfs2_xattr_set_type(loc->xl_entry, xi->xi_name_index);
> +	ocfs2_xattr_set_local(loc->xl_entry,
> +			      xi->xi_value_len <= OCFS2_XATTR_INLINE_SIZE);
> +
> +	nameval_offset = le16_to_cpu(loc->xl_entry->xe_name_offset);
> +	nameval_buf = ocfs2_xa_offset_pointer(loc, nameval_offset);
> +	memset(nameval_buf, 0, size);
> +	memcpy(nameval_buf, xi->xi_name, xi->xi_name_len);
> +}
In add namevalue, we should update xl_entry->xe_name_len as well. In 
here we only have a blank entry, so we need to fill this one.
Maybe we should update xe_name_len somewhere else.

thanks,
tiger
