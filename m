From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 21 Jan 2016 15:47:07 -0800
Subject: [Ocfs2-devel] [PATCH 2/6] ocfs2: o2hb: add NEGO_TIMEOUT message
In-Reply-To: <1453259619-5347-3-git-send-email-junxiao.bi@oracle.com>
References: <1453259619-5347-1-git-send-email-junxiao.bi@oracle.com>
	<1453259619-5347-3-git-send-email-junxiao.bi@oracle.com>
Message-ID: <20160121154707.569ce8d12cce6cf43bc5e31c@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 20 Jan 2016 11:13:35 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:

> This message is sent to master node when non-master nodes's
> negotiate timer expired. Master node records these nodes in
> a bitmap which is used to do write timeout timer re-queue
> decision.
> 
> ...
>
> +static int o2hb_nego_timeout_handler(struct o2net_msg *msg, u32 len, void *data,
> +				void **ret_data)
> +{
> +	struct o2hb_region *reg = (struct o2hb_region *)data;

It's best not to typecast a void*.  It's unneeded clutter and the cast
can actually hide bugs - if someone changes `data' to a different type
or if there's a different "data" in scope, etc.

> +	struct o2hb_nego_msg *nego_msg;
>  
> +	nego_msg = (struct o2hb_nego_msg *)msg->buf;
> +	if (nego_msg->node_num < O2NM_MAX_NODES)
> +		set_bit(nego_msg->node_num, reg->hr_nego_node_bitmap);
> +	else
> +		mlog(ML_ERROR, "got nego timeout message from bad node.\n");
> +
> +	return 0;
>  }
