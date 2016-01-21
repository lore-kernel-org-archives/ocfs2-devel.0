From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 21 Jan 2016 15:42:39 -0800
Subject: [Ocfs2-devel] [PATCH 1/6] ocfs2: o2hb: add negotiate timer
In-Reply-To: <1453259619-5347-2-git-send-email-junxiao.bi@oracle.com>
References: <1453259619-5347-1-git-send-email-junxiao.bi@oracle.com>
	<1453259619-5347-2-git-send-email-junxiao.bi@oracle.com>
Message-ID: <20160121154239.ef8a8581d5acea63bae22436@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 20 Jan 2016 11:13:34 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:

> When storage down, all nodes will fence self due to write timeout.
> The negotiate timer is designed to avoid this, with it node will
> wait until storage up again.
> 
> Negotiate timer working in the following way:
> 
> 1. The timer expires before write timeout timer, its timeout is half
> of write timeout now. It is re-queued along with write timeout timer.
> If expires, it will send NEGO_TIMEOUT message to master node(node with
> lowest node number). This message does nothing but marks a bit in a
> bitmap recording which nodes are negotiating timeout on master node.
> 
> 2. If storage down, nodes will send this message to master node, then
> when master node finds its bitmap including all online nodes, it sends
> NEGO_APPROVL message to all nodes one by one, this message will re-queue
> write timeout timer and negotiate timer.
> For any node doesn't receive this message or meets some issue when
> handling this message, it will be fenced.
> If storage up at any time, o2hb_thread will run and re-queue all the
> timer, nothing will be affected by these two steps.
> 
> ...
>
> +static void o2hb_nego_timeout(struct work_struct *work)
> +{
> +	struct o2hb_region *reg =
> +		container_of(work, struct o2hb_region,
> +			     hr_nego_timeout_work.work);

It's better to just do

	struct o2hb_region *reg;

	reg = container_of(work, struct o2hb_region, hr_nego_timeout_work.work);

and avoid the weird 80-column tricks.

> +	unsigned long live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];

the bitmap.h interfaces might be nicer here.  Perhaps.  A little bit.

> +	int master_node;
> +
> +	o2hb_fill_node_map(live_node_bitmap, sizeof(live_node_bitmap));
> +	/* lowest node as master node to make negotiate decision. */
> +	master_node = find_next_bit(live_node_bitmap, O2NM_MAX_NODES, 0);
> +
> +	if (master_node == o2nm_this_node()) {
> +		set_bit(master_node, reg->hr_nego_node_bitmap);
> +		if (memcmp(reg->hr_nego_node_bitmap, live_node_bitmap,
> +				sizeof(reg->hr_nego_node_bitmap))) {
> +			/* check negotiate bitmap every second to do timeout
> +			 * approve decision.
> +			 */
> +			schedule_delayed_work(&reg->hr_nego_timeout_work,
> +				msecs_to_jiffies(1000));

One second is long enough to unmount the fs (and to run `rmmod
ocfs2'!).  Is there anything preventing the work from triggering in
these situations?

> +
> +			return;
> +		}
> +
> +		/* approve negotiate timeout request. */
> +	} else {
> +		/* negotiate timeout with master node. */
> +	}
> +
>  }
