From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Dec 11 14:38:05 2006
Subject: [Ocfs2-devel] [patch 2/3]OCFS2: allow the ocfs2 heartbeat thread
	to prioritize I/O --revision 3
In-Reply-To: <4579B3C00200000400262DB0@lucius.provo.novell.com>
References: <4579B3C00200000400262DB0@lucius.provo.novell.com>
Message-ID: <20061211223801.GD6831@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Dec 08, 2006 at 12:48:35AM -0700, Zhen Wei wrote:
> --- trunk.orig/mount.ocfs2/mount.ocfs2.c	2006-12-08 15:09:42.000000000 +0800
> +++ trunk/mount.ocfs2/mount.ocfs2.c	2006-12-08 15:17:59.000000000 +0800
> @@ -393,6 +393,7 @@ int main(int argc, char **argv)
>  		goto bail;
>  	}
>  
> +	run_hb_ctl (hb_ctl_path, mo.dev, "-P");
Don't we need to add another argument for the actual priority value?
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
