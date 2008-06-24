From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 24 Jun 2008 10:03:10 -0700
Subject: [Ocfs2-devel] [RFC] configfs: Pin configfs
	subsystems	separately from new config_items.
In-Reply-To: <20080624050423.GA4193@localdomain>
References: <20080618161215.GA16780@ca-server1.us.oracle.com>
	<20080618165101.GI30804@localhost>
	<20080618200713.GE16780@ca-server1.us.oracle.com>
	<20080619111357.GM30804@localhost>
	<20080619220739.GC10888@mail.oracle.com>
	<20080620124644.GQ30804@localhost>
	<20080620223614.GD21416@mail.oracle.com>
	<20080623154457.GW30804@localhost>
	<20080623191027.GF592@mail.oracle.com>
	<20080624050423.GA4193@localdomain>
Message-ID: <20080624170310.GB4184@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Tue, Jun 24, 2008 at 07:04:23AM +0200, Louis Rilling wrote:
> Yup, I realized it this night (prevented me from sleeping by the way).
> The previous arguments remain valid though. I hope that you won't discard
> them because of this buggy one :)

	I'm quite happy with the current code, and I figure to leave it
(taking a module_get() on item->owner).  Thanks for thinking it out with
me.

> struct config_item * item = to_item(filp->f_path.dentry->d_parent);
> [...]
> if (item)
> 	config_item_put(item);
> 
> It looks strange:
> 1/ either item may be NULL, and there is a probable memory leak because of the
> reference grabbed in configfs_open_file();
> 2/ or item may never be NULL and this check is just useless and (at least for
> me) misleading.
> 
> If I understand correctly, option 2 is correct because

	I think you are right about (2), but I'm not changing it.  That
code comes from sysfs and I try not to change it unless its wrong.
sysfs has actually changed their handling over time.  What I try to do
is keep track of such changes and sometimes bring them over if
warranted.  I haven't had a chance to look at the new way sysfs does it.

Joel

-- 

	f/8 and be there.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
