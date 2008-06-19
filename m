From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 19 Jun 2008 15:08:53 -0700
Subject: [Ocfs2-devel] [RFC][PATCH] configfs: Report errors
	in	config_*_init_type_name()
In-Reply-To: <20080619091003.GJ30804@localhost>
References: <1213813851-7359-1-git-send-email-louis.rilling@kerlabs.com>
	<20080618202226.GG16780@ca-server1.us.oracle.com>
	<20080619091003.GJ30804@localhost>
Message-ID: <20080619220853.GD10888@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Thu, Jun 19, 2008 at 11:10:03AM +0200, Louis Rilling wrote:
> On Wed, Jun 18, 2008 at 01:22:26PM -0700, Joel Becker wrote:
> > 1) Make your changes to return errors from config_*_init_type_name(),
> >    but don't check the errors on known-safe usage (small static
> >    strings).
> 
> I don't like it very much, since users should check for the value of
> CONFIGFS_ITEM_NAME_LEN to ensure that this is a safe usage.

	Yeah, I don't much like it either.  I just threw it out there as
a possibility.

> > 2) Provide two API, one that is void and one that is not, so that
> >    known-safe usage can use the void call (and BUG_ON() if the strlen()
> >    is off), while other usage checks the errors.
> 
> Ok. What about config_*_init_type_long_name()?

	Well, that's better than any names I could come up with.  Let's
run with it.

Joel

-- 

"Every day I get up and look through the Forbes list of the richest
 people in America. If I'm not there, I go to work."
        - Robert Orben

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
