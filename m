From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 18 Jun 2008 13:22:26 -0700
Subject: [Ocfs2-devel] [RFC][PATCH] configfs: Report errors
	in	config_*_init_type_name()
In-Reply-To: <1213813851-7359-1-git-send-email-louis.rilling@kerlabs.com>
References: <1213813851-7359-1-git-send-email-louis.rilling@kerlabs.com>
Message-ID: <20080618202226.GG16780@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed, Jun 18, 2008 at 08:30:51PM +0200, Louis Rilling wrote:
>  [ applies on top of http://lkml.org/lkml/2008/6/12/427 ]
> 
> config_item_set_name() may fail but its error code is not checked in
> config_*_init_type_name().
> 
> This patch adds the missing error checking and make config_*_init_type_name()
> report errors. In-tree users are updated to report errors as well.

	While this patch is correct on the face, I'd like to try a
different approach.  I wasn't thinking about it right.
	See, config_*_init_type_name() are generally a create-time thing.
Almost everyone uses it without error checking because they know it is
safe; they are usually using a static name.  config_item_set_name()
can only error if strlen(name)>CONFIGFS_ITEM_NAME_LEN.   That's why
config_*_init_type_name() are void.
	In other words, we shouldn't be adding useless error-check
boilerplate for already-safe things.
	But there are a couple of users of config_*_set_type_name() that
aren't safe.  The lockspace in fs/dlm/config.c is one (lockspace names
can be 64 characters).  The config_*_init_type_name() helpers are quite
convenient.
	I see two choices:

1) Make your changes to return errors from config_*_init_type_name(),
   but don't check the errors on known-safe usage (small static
   strings).
2) Provide two API, one that is void and one that is not, so that
   known-safe usage can use the void call (and BUG_ON() if the strlen()
   is off), while other usage checks the errors.

Joel

-- 

Life's Little Instruction Book #3

	"Watch a sunrise at least once a year."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
