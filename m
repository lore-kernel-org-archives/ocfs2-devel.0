From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Tue, 24 Jun 2008 07:04:23 +0200
Subject: [Ocfs2-devel] [RFC] configfs: Pin configfs
	subsystems	separately from new config_items.
In-Reply-To: <20080623191027.GF592@mail.oracle.com>
References: <20080618123134.GC30804@localhost>
	<20080618161215.GA16780@ca-server1.us.oracle.com>
	<20080618165101.GI30804@localhost>
	<20080618200713.GE16780@ca-server1.us.oracle.com>
	<20080619111357.GM30804@localhost>
	<20080619220739.GC10888@mail.oracle.com>
	<20080620124644.GQ30804@localhost>
	<20080620223614.GD21416@mail.oracle.com>
	<20080623154457.GW30804@localhost>
	<20080623191027.GF592@mail.oracle.com>
Message-ID: <20080624050423.GA4193@localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Mon, Jun 23, 2008 at 12:10:28PM -0700, Joel Becker wrote:
> On Mon, Jun 23, 2008 at 05:44:57PM +0200, Louis Rilling wrote:
> > make_item()
> > 	new_item = kmalloc();
> > 	config_item_init_type_long_name();
> > 	return new_item;
> > 
> > drop_item(item)
> > 	config_item_put(item);
> > 	kfree(item);
> 
> 	This is never, ever safe.  Consider that someone has an
> attribute file open - it has a reference to the item.  You can still
> rmdir() the item - doing stuff to the attribute after drop_item() will
> just get ignored.  But you can't free it in drop_item().

Yup, I realized it this night (prevented me from sleeping by the way).
The previous arguments remain valid though. I hope that you won't discard
them because of this buggy one :)

While looking at file.c, I found this in configfs_release():

struct config_item * item = to_item(filp->f_path.dentry->d_parent);
[...]
if (item)
	config_item_put(item);

It looks strange:
1/ either item may be NULL, and there is a probable memory leak because of the
reference grabbed in configfs_open_file();
2/ or item may never be NULL and this check is just useless and (at least for
me) misleading.

If I understand correctly, option 2 is correct because
a/ even if .dentry gets unhashed and .dentry->d_parent gets unhashed as well,
VFS ensures that filp->f_path.dentry->d_parent is unchanged unless .dentry was
renamed, which is not permitted by configfs, and, I guess, will never be
permitted for a configfs attribute;
b/ once dentry->d_fsdata points to a configfs_dirent, it never changes
and remains valid for the rest of dentry's life (until dentry_iput());
c/ configfs_dirent->s_element never changes once it is set.

Am I wrong somewhere?

Thanks

Louis

-- 
Dr Louis Rilling			Kerlabs - IRISA
Skype: louis.rilling			Campus Universitaire de Beaulieu
Phone: (+33|0) 2 99 84 71 52		Avenue du General Leclerc
Fax: (+33|0) 2 99 84 71 71		35042 Rennes CEDEX - France
http://www.kerlabs.com/
