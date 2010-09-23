From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 23 Sep 2010 15:35:12 -0700
Subject: [Ocfs2-devel] [PATCH 16/20] ocfs2/cluster: Maintain bitmap of
 failed regions
In-Reply-To: <1284504656-2434-17-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
	<1284504656-2434-17-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100923223512.GF803@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 14, 2010 at 03:50:52PM -0700, Sunil Mushran wrote:
> +	if (o2hb_global_heartbeat_active()) {
> +		spin_lock_irqsave(&o2hb_live_lock, flags);
> +		if (test_bit(reg->hr_region_num, o2hb_quorum_region_bitmap))
> +			set_bit(reg->hr_region_num, o2hb_failed_region_bitmap);
> +		failed = o2hb_pop_count(&o2hb_failed_region_bitmap,
> +					O2NM_MAX_REGIONS);
> +		quorum = o2hb_pop_count(&o2hb_quorum_region_bitmap,
> +					O2NM_MAX_REGIONS);
> +		spin_unlock_irqrestore(&o2hb_live_lock, flags);
> +
> +		printk(KERN_NOTICE "Number of regions %d, failed regions %d\n",
> +		       quorum, failed);

	This is not worth printing.  Quorum fired, so we know what
happened.

Joel

-- 

"The whole problem with the world is that fools and fanatics are always
 so certain of themselves, and wiser people so full of doubts."
	- Bertrand Russell

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
