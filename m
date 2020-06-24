From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 24 Jun 2020 17:57:04 +0300
Subject: [Ocfs2-devel] [bug report] ocfs2: fix value of
	OCFS2_INVALID_SLOT
In-Reply-To: <83182084-7bb9-93bb-ee44-8cfd25315940@oracle.com>
References: <20200623110558.GA27810@mwanda>
	<83182084-7bb9-93bb-ee44-8cfd25315940@oracle.com>
Message-ID: <20200624145704.GA31008@kadam>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jun 23, 2020 at 01:26:11PM -0700, Junxiao Bi wrote:
> On 6/23/20 4:05 AM, Dan Carpenter wrote:
> 
> > Hello Junxiao Bi,
> > 
> > The patch c824ce1feffa: "ocfs2: fix value of OCFS2_INVALID_SLOT" from
> > Jun 21, 2020, leads to the following static checker warning:
> > 
> > 	fs/ocfs2/super.c:1269 ocfs2_parse_options()
> > 	warn: '(-1)' 65535 can't fit into 32767 'mopt->slot'
> > 
> > fs/ocfs2/super.c
> >    1253  static int ocfs2_parse_options(struct super_block *sb,
> >    1254                                 char *options,
> >    1255                                 struct mount_options *mopt,
> >    1256                                 int is_remount)
> >    1257  {
> >    1258          int status, user_stack = 0;
> >    1259          char *p;
> >    1260          u32 tmp;
> >    1261          int token, option;
> >    1262          substring_t args[MAX_OPT_ARGS];
> >    1263
> >    1264          trace_ocfs2_parse_options(is_remount, options ? options : "(none)");
> >    1265
> >    1266          mopt->commit_interval = 0;
> >    1267          mopt->mount_opt = OCFS2_MOUNT_NOINTR;
> >    1268          mopt->atime_quantum = OCFS2_DEFAULT_ATIME_QUANTUM;
> >    1269          mopt->slot = OCFS2_INVALID_SLOT;
> >                  ^^^^^^^^^^   ^^^^^^^^^^^^^^^^^^
> > OCFS2_INVALID_SLOT used to be -1, but the patch changed it to USHRT_MAX.
> > mopt->slot is a s16 so it becomes -1 again.
> > We assign it to osb->preferred_slot which is an int so it's still -1.
> 
> hmm, i think osb->perferred_slot should be 65535, not -1. I test with the
> following small program.
> 
> #include <stdlib.h>
> #include <stdio.h>
> 
> int main(void)
> {
> ??? int i;
> ??? short s;
> ??? unsigned short us;
> 
> ??? us = -1;
> ??? s = us;
> ??? i = s;
> ??? printf("i %d s %d us %d\n", i, s, us);
> }

I'm looking at linux-next.  The only thing which is unsigend short is
the OCFS2_INVALID_SLOT define itself.  The other variables are either
signed short or int.  In this case what we care about is the
preferred_slot which is an int.

#define OCFS2_INVALID_SLOT ((unsigned short)-1)

int main(void)
{
	short slot = OCFS2_INVALID_SLOT;
	int perferred_slot = slot;

	if (perferred_slot == OCFS2_INVALID_SLOT)
		printf("Works\n");
	else
		printf("nope\n");
}

There are a few other place where the types cause an issue.

fs/ocfs2/super.c:1269 ocfs2_parse_options() warn: '(-1)' 65535 can't fit into 32767 'mopt->slot'
fs/ocfs2/suballoc.c:859 ocfs2_init_inode_steal_slot() warn: '(-1)' 65535 can't fit into 32767 'osb->s_inode_steal_slot'
fs/ocfs2/suballoc.c:867 ocfs2_init_meta_steal_slot() warn: '(-1)' 65535 can't fit into 32767 'osb->s_meta_steal_slot'

regards,
dan carpenter
