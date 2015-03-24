From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 24 Mar 2015 14:06:42 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: trusted xattr missing
 CAP_SYS_ADMIN check
In-Reply-To: <1427211992-9803-1-git-send-email-sanidhya.gatech@gmail.com>
References: <1427211992-9803-1-git-send-email-sanidhya.gatech@gmail.com>
Message-ID: <20150324140642.7f8b9da9782fd7164e574f38@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: mfasheh@suse.com, jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, taesoo@gatech.edu, sanidhya@gatech.edu, blee@gatech.edu, csong84@gatech.edu, changwoo@gatech.edu

On Tue, 24 Mar 2015 11:46:32 -0400 Sanidhya Kashyap <sanidhya.gatech@gmail.com> wrote:

> The trusted extended attributes are only visible to the process which hvae
> CAP_SYS_ADMIN capability but the check is missing in ocfs2 xattr_handler
> trusted list. The check is important because this will be used for implementing
> mechanisms in the userspace for which other ordinary processes should not
> have access to.
> 
> ...
>
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -7326,6 +7326,9 @@ static size_t ocfs2_xattr_trusted_list(struct dentry *dentry, char *list,
>  	const size_t prefix_len = XATTR_TRUSTED_PREFIX_LEN;
>  	const size_t total_len = prefix_len + name_len + 1;
>  
> +	if (!capable(CAP_SYS_ADMIN))
> +		return 0;
> +
>  	if (list && total_len <= list_size) {
>  		memcpy(list, XATTR_TRUSTED_PREFIX, prefix_len);
>  		memcpy(list + prefix_len, name, name_len);

Ouch.  Won't this break existing userspace?
