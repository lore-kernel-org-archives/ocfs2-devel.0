From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Mon Feb  4 19:16:23 2008
Subject: [Ocfs2-devel] Re: [patch 01/16] ocfs2: Add check for missing
 range_* prefix in struct writeback_control
In-Reply-To: <20080202162710.319523000@suse.com>
References: <20080202162652.006821000@suse.com>
	<20080202162710.319523000@suse.com>
Message-ID: <47A7D4B4.6090802@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Jeff@locomotive.unixthugs.org wrote:
> --- a/fs/ocfs2/Makefile	2008-02-02 10:36:14.000000000 -0500
> +++ b/fs/ocfs2/Makefile	2008-02-02 10:36:24.000000000 -0500
> @@ -116,6 +116,10 @@ ifdef NO_MANDATORY_LOCK
>  EXTRA_CFLAGS += -DNO_MANDATORY_LOCK
>  endif
>  
> +ifdef WRITEBACK_CONTROL_NO_RANGE_PREFIX
> +EXTRA_CFLAGS += -DWRITEBACK_CONTROL_NO_RANGE_PREFIX
> +endif
> +
>   

If it's ok, I am changing EXTRA_CFLAGS to 
CFLAGS_compat_sync_mapping_range.o instead.
More targeted.

Rest all the patches look good. If no one objects, I will push these 
tomorrow.

Sunil
