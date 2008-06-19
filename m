From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Thu, 19 Jun 2008 11:10:03 +0200
Subject: [Ocfs2-devel] [RFC][PATCH] configfs: Report errors
	in	config_*_init_type_name()
In-Reply-To: <20080618202226.GG16780@ca-server1.us.oracle.com>
References: <1213813851-7359-1-git-send-email-louis.rilling@kerlabs.com>
	<20080618202226.GG16780@ca-server1.us.oracle.com>
Message-ID: <20080619091003.GJ30804@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed, Jun 18, 2008 at 01:22:26PM -0700, Joel Becker wrote:
> On Wed, Jun 18, 2008 at 08:30:51PM +0200, Louis Rilling wrote:
> >  [ applies on top of http://lkml.org/lkml/2008/6/12/427 ]
> > 
> > config_item_set_name() may fail but its error code is not checked in
> > config_*_init_type_name().
> > 
> > This patch adds the missing error checking and make config_*_init_type_name()
> > report errors. In-tree users are updated to report errors as well.
> 
> 	While this patch is correct on the face, I'd like to try a
> different approach.  I wasn't thinking about it right.
> 	See, config_*_init_type_name() are generally a create-time thing.
> Almost everyone uses it without error checking because they know it is
> safe; they are usually using a static name.  config_item_set_name()
> can only error if strlen(name)>CONFIGFS_ITEM_NAME_LEN.   That's why
> config_*_init_type_name() are void.
> 	In other words, we shouldn't be adding useless error-check
> boilerplate for already-safe things.
> 	But there are a couple of users of config_*_set_type_name() that
> aren't safe.  The lockspace in fs/dlm/config.c is one (lockspace names
> can be 64 characters).  The config_*_init_type_name() helpers are quite
> convenient.
> 	I see two choices:
> 
> 1) Make your changes to return errors from config_*_init_type_name(),
>    but don't check the errors on known-safe usage (small static
>    strings).

I don't like it very much, since users should check for the value of
CONFIGFS_ITEM_NAME_LEN to ensure that this is a safe usage.

> 2) Provide two API, one that is void and one that is not, so that
>    known-safe usage can use the void call (and BUG_ON() if the strlen()
>    is off), while other usage checks the errors.

Ok. What about config_*_init_type_long_name()?

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 189 bytes
Desc: Digital signature
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080619/895bbc9b/attachment.bin 
