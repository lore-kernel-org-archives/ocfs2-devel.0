From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Mon, 20 Jul 2020 09:16:35 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix remounting needed after
	setfacl command
In-Reply-To: <20200717023751.9922-1-ghe@suse.com>
References: <20200717023751.9922-1-ghe@suse.com>
Message-ID: <3bcaf181-9a1a-e9d1-c41b-0dd1edc79d63@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>, mark@fasheh.com, jlbec@evilplan.org
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org



On 2020/7/17 10:37, Gang He wrote:
> When use setfacl command to change a file's acl, the user cannot
> get the latest acl information from the file via getfacl command,
> until remounting the file system.
> e.g.
> setfacl -m u:ivan:rw /ocfs2/ivan
> getfacl /ocfs2/ivan
> getfacl: Removing leading '/' from absolute path names
> file: ocfs2/ivan
> owner: root
> group: root
> user::rw-
> group::r--
> mask::r--
> other::r--
> 
> The latest acl record("u:ivan:rw") cannot be returned via getfacl
> command until remounting.
> 
> Signed-off-by: Gang He <ghe@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/acl.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
> index bb981ec76456..7b07f5df3a29 100644
> --- a/fs/ocfs2/acl.c
> +++ b/fs/ocfs2/acl.c
> @@ -256,6 +256,8 @@ static int ocfs2_set_acl(handle_t *handle,
>  		ret = ocfs2_xattr_set(inode, name_index, "", value, size, 0);
>  
>  	kfree(value);
> +	if (!ret)
> +		set_cached_acl(inode, type, acl);
>  
>  	return ret;
>  }
> 
