From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 18 Nov 2008 15:08:08 -0800
Subject: [Ocfs2-devel] [Patch 3/3] ocfs2-tools: Fix compilation
	of	Pacemaker glue for ocfs2_controld
In-Reply-To: <6150956E-4D24-40F9-B0C7-1E05CC82068D@suse.de>
References: <6150956E-4D24-40F9-B0C7-1E05CC82068D@suse.de>
Message-ID: <20081118230808.GC10451@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 18, 2008 at 11:18:45AM +0100, Andrew Beekhof wrote:
> Fix compilation of Pacemaker glue for ocfs2_controld when the  
> underlying Pacemaker installation supports both the Heartbeat and  
> OpenAIS stack
> 
> Signed-off-by: Andrew Beekhof <abeekhof@suse.de>

	I'll trust you on this one.

Signed-off-by: Joel Becker <joel.becker@oracle.com>

> 
> --- upstream/ocfs2_controld/pacemaker.c	2008-09-11 16:51:11.000000000  
> +0200
> +++ dev/ocfs2_controld/pacemaker.c	2008-10-23 13:14:56.000000000 +0200
> @@ -20,8 +20,16 @@
>   #include <unistd.h>
>   #include <syslog.h>
> 
> -#include <crm/crm.h>
> -#include <crm/common/cluster.h>
> +#include <bzlib.h>
> +
> +#include <pacemaker/crm_config.h>
> +/* heartbeat support is irrelevant here */
> +#undef SUPPORT_HEARTBEAT
> +#define SUPPORT_HEARTBEAT 0
> +
> +#include <pacemaker/crm/crm.h>
> +#include <pacemaker/crm/ais.h>
> +#include <pacemaker/crm/common/cluster.h>
>   #include <fencing/stonithd_api.h>
> 
>   #include "ocfs2-kernel/kernel-list.h"
> @@ -29,9 +37,6 @@
> 
>   #include "ocfs2_controld.h"
> 
> -#include <bzlib.h>
> -#include <crm/crm.h>
> -#include <crm/ais.h>
>   #include <sys/utsname.h>
> 
>   int			our_nodeid = 0;
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"Nearly all men can stand adversity, but if you really want to
 test a man's character, give him power."
	- Abraham Lincoln

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
