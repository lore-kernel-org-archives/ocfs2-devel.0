From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 23 Sep 2010 15:31:26 -0700
Subject: [Ocfs2-devel] [PATCH 10/20] ocfs2/cluster: Check slots for
 unconfigured live nodes
In-Reply-To: <1284504656-2434-11-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
	<1284504656-2434-11-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100923223126.GD803@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 14, 2010 at 03:50:46PM -0700, Sunil Mushran wrote:
> +	if (!node) {
> +		spin_lock(&o2hb_live_lock);
> +		tmp = test_bit(slot->ds_node_num, o2hb_live_node_bitmap);
> +		spin_unlock(&o2hb_live_lock);
> +		if (!tmp)
> +			return 0;
> +		printk(KERN_NOTICE "o2hb: Live node %d is not registered\n",
> +		       slot->ds_node_num);

	This notice is ill-placed, I think.  I do believe a NOTICE is
warranted when the user has removed a node from configfs but that node
is still heartbeating.  Maybe we only print the NOTICE when it goes down
or up?  Or perhaps we print this notice here, but we only do so once.
I think printing this notice every 30 seconds forever would be awful.
	I would also change the text.  Something like "o2hb: Node number
%d is still heartbeating, but its configuration has been removed."

Joel

-- 

"There is no sincerer love than the love of food."  
         - George Bernard Shaw 

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
