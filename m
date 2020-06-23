From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 23 Jun 2020 13:26:11 -0700
Subject: [Ocfs2-devel] [bug report] ocfs2: fix value of
	OCFS2_INVALID_SLOT
In-Reply-To: <20200623110558.GA27810@mwanda>
References: <20200623110558.GA27810@mwanda>
Message-ID: <83182084-7bb9-93bb-ee44-8cfd25315940@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 6/23/20 4:05 AM, Dan Carpenter wrote:

> Hello Junxiao Bi,
>
> The patch c824ce1feffa: "ocfs2: fix value of OCFS2_INVALID_SLOT" from
> Jun 21, 2020, leads to the following static checker warning:
>
> 	fs/ocfs2/super.c:1269 ocfs2_parse_options()
> 	warn: '(-1)' 65535 can't fit into 32767 'mopt->slot'
>
> fs/ocfs2/super.c
>    1253  static int ocfs2_parse_options(struct super_block *sb,
>    1254                                 char *options,
>    1255                                 struct mount_options *mopt,
>    1256                                 int is_remount)
>    1257  {
>    1258          int status, user_stack = 0;
>    1259          char *p;
>    1260          u32 tmp;
>    1261          int token, option;
>    1262          substring_t args[MAX_OPT_ARGS];
>    1263
>    1264          trace_ocfs2_parse_options(is_remount, options ? options : "(none)");
>    1265
>    1266          mopt->commit_interval = 0;
>    1267          mopt->mount_opt = OCFS2_MOUNT_NOINTR;
>    1268          mopt->atime_quantum = OCFS2_DEFAULT_ATIME_QUANTUM;
>    1269          mopt->slot = OCFS2_INVALID_SLOT;
>                  ^^^^^^^^^^   ^^^^^^^^^^^^^^^^^^
> OCFS2_INVALID_SLOT used to be -1, but the patch changed it to USHRT_MAX.
> mopt->slot is a s16 so it becomes -1 again.
> We assign it to osb->preferred_slot which is an int so it's still -1.

hmm, i think osb->perferred_slot should be 65535, not -1. I test with 
the following small program.

#include <stdlib.h>
#include <stdio.h>

int main(void)
{
 ??? int i;
 ??? short s;
 ??? unsigned short us;

 ??? us = -1;
 ??? s = us;
 ??? i = s;
 ??? printf("i %d s %d us %d\n", i, s, us);
}

Thanks,

Junxiao.

> Then we do:
>
> 	if (osb->preferred_slot != OCFS2_INVALID_SLOT)
>
> Since -1 is not equal to USHRT_MAX then this condition is not true.
>
>    1270          mopt->localalloc_opt = -1;
>    1271          mopt->cluster_stack[0] = '\0';
>    1272          mopt->resv_level = OCFS2_DEFAULT_RESV_LEVEL;
>    1273          mopt->dir_resv_level = -1;
>    1274
>    1275          if (!options) {
>    1276                  status = 1;
>
> regards,
> dan carpenter
