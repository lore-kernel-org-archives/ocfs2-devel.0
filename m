From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Thu, 31 Jul 2008 10:44:16 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2-tools: add error message to
 mount.ocfs2 when mount point is invalid.
In-Reply-To: <4891C0C5.1010007@suse.de>
References: <4891C0C5.1010007@suse.de>
Message-ID: <4891F9F0.6000609@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Maybe change "symbolic link to nowhere" to "broken symbolic link".

Looks good otherwise.

Coly Li wrote:
> Adds error messages to mount.ocfs2 when mount point is invalid in three conditions:
> 1) mount point does not exist.
> 2) mount point is a symbolic link.
> 3) mount point is not a directory.
> Adding these error messages can help ocfs2console provides more helpful feedback information to end 
> use. Similar information can be found when mounting ext[234] file systems.
>
> Patch is generated against upstream ocfs2-tools.
>
> Signed-off-by: Coly Li <coyli@suse.de>
> Cc: Joel Becker <Joel.Becker@oracle.com>
> Cc: Tao Ma <tao.ma@oracle.com>
> Cc: Tiger Yang <tiger.yang@oracle.com>
> ---
> diff --git a/mount.ocfs2/mount.ocfs2.c b/mount.ocfs2/mount.ocfs2.c
> index a97b4cb..eb8e336 100644
> --- a/mount.ocfs2/mount.ocfs2.c
> +++ b/mount.ocfs2/mount.ocfs2.c
> @@ -382,9 +382,21 @@ int main(int argc, char **argv)
>   			o2cb_complete_group_join(&cluster, &desc, errno);
>   		}
>   		block_signals (SIG_UNBLOCK);
> -		com_err(progname, ret, "while mounting %s on %s. "
> -			"Check 'dmesg' for more information on this error.",
> -			mo.dev, mo.dir);
> +
> +		/* complain mount failure */
> +		if (lstat(mo.dir, &statbuf))
> +			com_err(progname, 0, "mount point %s does not "
> +				"exist", mo.dir);
> +		else if (stat(mo.dir, &statbuf))
> +			com_err(progname, 0, "mount point %s is a "
> +				"symbolic link to nowhere", mo.dir);
> +		else if (stat(mo.dir, &statbuf) || !S_ISDIR(statbuf.st_mode))
> +			com_err(progname, 0, "mount point %s is not "
> +				"a directory", mo.dir);
> +		else
> +			com_err(progname, ret, "while mounting %s on %s. "
> +				"Check 'dmesg' for more information on this "
> +				"error.", mo.dev, mo.dir);
>   		goto bail;
>   	}
>   	if (hb_started) {
>
>   
