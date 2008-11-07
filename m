From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 6 Nov 2008 17:26:35 -0800
Subject: [Ocfs2-devel] [PATCH 11/15] ocfs2: add POSIX ACL API
In-Reply-To: <1225366901-6416-1-git-send-email-tiger.yang@oracle.com>
References: <49099B13.9030802@oracle.com>
	<1225366901-6416-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20081107012635.GJ15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 30, 2008 at 07:41:41PM +0800, Tiger Yang wrote:
> +static int ocfs2_set_acl_handle(handle_t *handle,
> +				struct inode *inode,
> +				struct buffer_head *di_bh,
> +				int type,
> +				struct posix_acl *acl,
> +				struct ocfs2_alloc_context *meta_ac,
> +				struct ocfs2_alloc_context *data_ac)
> +{
> +	int name_index;
> +	void *value = NULL;
> +	size_t size = 0;
> +	int ret;
> +
> +	if (S_ISLNK(inode->i_mode))
> +		return -EOPNOTSUPP;
> +
> +	switch (type) {
> +	case ACL_TYPE_ACCESS:
> +		name_index = OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS;
> +		if (acl) {
> +			mode_t mode = inode->i_mode;
> +			ret = posix_acl_equiv_mode(acl, &mode);
> +			if (ret < 0)
> +				return ret;
> +			else {
> +				inode->i_mode = mode;
> +				if (ret == 0)
> +					acl = NULL;
> +			}
> +		}
> +		break;
> +	case ACL_TYPE_DEFAULT:
> +		name_index = OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT;
> +		if (!S_ISDIR(inode->i_mode))
> +			return acl ? -EACCES : 0;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (acl) {
> +		value = ocfs2_acl_to_xattr(acl, &size);
> +		if (IS_ERR(value))
> +			return (int)PTR_ERR(value);
> +	}
> +
> +	ret = ocfs2_xattr_set_handle(handle, inode, di_bh, name_index,
> +				     "", value, size, 0, meta_ac, data_ac);
> +
> +	kfree(value);
> +
> +	return ret;
> +}
> +
> +/*
> + * Set the access or default ACL of an inode.
> + */
> +static int ocfs2_set_acl(struct inode *inode, int type, struct posix_acl *acl)
> +{
> +	int name_index;
> +	void *value = NULL;
> +	size_t size = 0;
> +	int ret;
> +
> +	if (S_ISLNK(inode->i_mode))
> +		return -EOPNOTSUPP;
> +
> +	switch (type) {
> +	case ACL_TYPE_ACCESS:
> +		name_index = OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS;
> +		if (acl) {
> +			mode_t mode = inode->i_mode;
> +			ret = posix_acl_equiv_mode(acl, &mode);
> +			if (ret < 0)
> +				return ret;
> +			else {
> +				inode->i_mode = mode;
> +				if (ret == 0)
> +					acl = NULL;
> +			}
> +		}
> +		break;
> +	case ACL_TYPE_DEFAULT:
> +		name_index = OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT;
> +		if (!S_ISDIR(inode->i_mode))
> +			return acl ? -EACCES : 0;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (acl) {
> +		value = ocfs2_acl_to_xattr(acl, &size);
> +		if (IS_ERR(value))
> +			return (int)PTR_ERR(value);
> +	}
> +
> +	ret = ocfs2_xattr_set(inode, name_index, "", value, size, 0);
> +
> +	kfree(value);
> +
> +	return ret;
> +}

Why don't you combine these two into one function which just calls
ocfs2_xattr_set() when handle == NULL and otherwise calls
ocfs2_xattr_set_handle()?

Otherwise, we could take the common part and make it it's own function which
they both call.
	--Mark

--
Mark Fasheh
