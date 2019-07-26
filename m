From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Fri, 26 Jul 2019 17:37:30 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] fs: ocfs2: Fix possible null-pointer
 dereferences in ocfs2_xa_prepare_entry()
In-Reply-To: <20190726033655.32253-1-baijiaju1990@gmail.com>
References: <20190726033655.32253-1-baijiaju1990@gmail.com>
Message-ID: <b6aef7d8-9884-7349-bcec-0c8654d1b062@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jia-Ju Bai <baijiaju1990@gmail.com>, mark@fasheh.com, jlbec@evilplan.org
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org



On 19/7/26 11:36, Jia-Ju Bai wrote:
> In ocfs2_xa_prepare_entry(), there is an if statement on line 2136 to
> check whether loc->xl_entry is NULL:
>     if (loc->xl_entry)
> 
> When loc->xl_entry is NULL, it is used on line 2158:
>     ocfs2_xa_add_entry(loc, name_hash);
>         loc->xl_entry->xe_name_hash = cpu_to_le32(name_hash);
>         loc->xl_entry->xe_name_offset = cpu_to_le16(loc->xl_size);
> and line 2164:
> 	ocfs2_xa_add_namevalue(loc, xi);
>         loc->xl_entry->xe_value_size = cpu_to_le64(xi->xi_value_len);
>         loc->xl_entry->xe_name_len = xi->xi_name_len;
> 
> Thus, possible null-pointer dereferences may occur.
> 
> To fix these bugs, if loc-xl_entry is NULL, ocfs2_xa_prepare_entry() 
> abnormally returns with -EINVAL.
> 
> These bugs are found by a static analysis tool STCheck written by us.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  fs/ocfs2/xattr.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 385f3aaa2448..f690502daf3c 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -2154,8 +2154,10 @@ static int ocfs2_xa_prepare_entry(struct ocfs2_xa_loc *loc,
>  			}
>  		}
>  		ocfs2_xa_wipe_namevalue(loc);
> -	} else
> -		ocfs2_xa_add_entry(loc, name_hash);
> +	} else {
> +		rc = -EINVAL;
> +		goto out;
> +	}

Since entry not found, so there is nothing to do in
ocfs2_xa_prepare_entry(). We may change it like:

if (!loc->xl_entry) {
	rc = -EINVAL;
	goto out;
}	

if (ocfs2_xa_can_reuse_entry(loc, xi)) {
	......
}
.....


Thanks,
Joseph
>  
>  	/*
>  	 * If we get here, we have a blank entry.  Fill it.  We grow our
> 
