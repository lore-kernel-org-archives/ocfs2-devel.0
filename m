From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 23 Jun 2008 12:10:28 -0700
Subject: [Ocfs2-devel] [RFC] configfs: Pin configfs
	subsystems	separately from new config_items.
In-Reply-To: <20080623154457.GW30804@localhost>
References: <1213742460-26331-1-git-send-email-joel.becker@oracle.com>
	<20080618123134.GC30804@localhost>
	<20080618161215.GA16780@ca-server1.us.oracle.com>
	<20080618165101.GI30804@localhost>
	<20080618200713.GE16780@ca-server1.us.oracle.com>
	<20080619111357.GM30804@localhost>
	<20080619220739.GC10888@mail.oracle.com>
	<20080620124644.GQ30804@localhost>
	<20080620223614.GD21416@mail.oracle.com>
	<20080623154457.GW30804@localhost>
Message-ID: <20080623191027.GF592@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Mon, Jun 23, 2008 at 05:44:57PM +0200, Louis Rilling wrote:
> make_item()
> 	new_item = kmalloc();
> 	config_item_init_type_long_name();
> 	return new_item;
> 
> drop_item(item)
> 	config_item_put(item);
> 	kfree(item);

	This is never, ever safe.  Consider that someone has an
attribute file open - it has a reference to the item.  You can still
rmdir() the item - doing stuff to the attribute after drop_item() will
just get ignored.  But you can't free it in drop_item().

Joel

-- 

"Vote early and vote often." 
        - Al Capone

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
