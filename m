From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Dec  7 16:21:02 2006
Subject: [Ocfs2-devel] [patch 2/2]OCFS2: allow the ocfs2 heartbeat thread
	to prioritize I/O
In-Reply-To: <4578193D0200000400262C06@lucius.provo.novell.com>
References: <4578193D0200000400262C06@lucius.provo.novell.com>
Message-ID: <20061208002057.GH4497@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Zwei,

On Wed, Dec 06, 2006 at 07:37:04PM -0700, Zhen Wei wrote:
> From: Zhen Wei <zwei@novell.com>
> Subject: allow the ocfs2 heartbeat thread to prioritize I/O
> Patch-mainline: ocfs2-1.2.2
Ok - the kernel patch looks good thus far.


> +errcode_t o2cb_get_hb_thread_pid (const char *cluster_name, const char *region_name,
> +			   pid_t *pid)
> +{
> +	char attr_path[PATH_MAX];
> +	char _fake_cluster_name[NAME_MAX];
> +	char attr_value[16];
> +	errcode_t ret;
> +
> +	if (!cluster_name) {
> +		ret = _fake_default_cluster(_fake_cluster_name);
> +		if (ret)
> +			return ret;
> +		cluster_name = _fake_cluster_name;
> +	}

Hmm, I don't see any other test for cluster_name == NULL in similar code
paths... Is there any particular reason why you added one?


> --- /tmp/ocfs2-tools-1.2.2/ocfs2_hb_ctl/ocfs2_hb_ctl.c	2006-10-20 01:10:46.000000000 +0800
> +++ ocfs2_hb_ctl/ocfs2_hb_ctl.c	2006-12-07 10:04:10.000000000 +0800
> @@ -29,6 +29,7 @@
>  #define _GNU_SOURCE /* Because libc really doesn't want us using O_DIRECT? */
>  
>  #include <sys/types.h>
> +#include <asm/unistd.h>
>  #include <inttypes.h>
>  
>  #include <stdio.h>
> @@ -47,18 +48,56 @@
>  #define DEV_PREFIX      "/dev/"
>  #define PROC_IDE_FORMAT "/proc/ide/%s/media"
>  
> +extern int ioprio_set(int, int, int);
> +extern int ioprio_get(int, int);
> +
> +#if defined(__i386__)
> +#define __NR_ioprio_set         289
> +#define __NR_ioprio_get         290
> +#elif defined(__ppc__)
> +#define __NR_ioprio_set         273
> +#define __NR_ioprio_get         274
> +#elif defined(__x86_64__)
> +#define __NR_ioprio_set         251
> +#define __NR_ioprio_get         252
> +#elif defined(__ia64__)
> +#define __NR_ioprio_set         1274
> +#define __NR_ioprio_get         1275
> +#else
> +#error "Unsupported arch"
> +#endif
> +
> +_syscall3(int, ioprio_set, int, which, int, who, int, ioprio);
> +_syscall2(int, ioprio_get, int, which, int, who);
> +
> +enum {
> +        IOPRIO_CLASS_NONE,
> +        IOPRIO_CLASS_RT,
> +        IOPRIO_CLASS_BE,
> +        IOPRIO_CLASS_IDLE,
> +};
> +
> +enum {
> +        IOPRIO_WHO_PROCESS = 1,
> +        IOPRIO_WHO_PGRP,
> +        IOPRIO_WHO_USER,
> +};
> +#define IOPRIO_CLASS_SHIFT      13
> +

After looking at all this, and realizing that the proper syscall definitions
don't exist anywhere on a modern distro, I'm begining to think that perhaps
we want to just fork and exec /usr/bin/ionice.

It seems more future maintainable than defining the syscall interface
ourselves.


> +	case HB_ACTION_IONICE:
> +		err = adjust_priority(&hbo);
> +		if (err) {
> +			com_err(progname, err, "while adjusting heartbeat thread I/O priority");
> +			ret = -EINVAL;

So, one thing I don't want to see is spurious errors if the set_ioprio or
ionice stuff doesn't exist - this should work just fine without confusing
users if they're still on an old kernel. You probably then want to filter
out any errors pertaining to the existence (or not) of that api.

Otherwise most of your patch looks pretty reasonable. I guess a follow up
patch would be to get mount.ocfs2.c to call ocfs2_hb_ctl to set a
higher-than-the-default priority.

Thanks!
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
