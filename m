From: Eric Ren <zren@suse.com>
Date: Mon, 25 Jan 2016 14:00:32 +0800
Subject: [Ocfs2-devel] [PATCH 4/6] ocfs2: o2hb: add some user/debug log
In-Reply-To: <56A5A491.4050205@oracle.com>
References: <1453259619-5347-1-git-send-email-junxiao.bi@oracle.com>
	<1453259619-5347-5-git-send-email-junxiao.bi@oracle.com>
	<20160125032815.GB7746@laptop.ha> <56A5A491.4050205@oracle.com>
Message-ID: <20160125060032.GD7746@laptop.ha>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Juxiao,

On Mon, Jan 25, 2016 at 12:29:05PM +0800, Junxiao Bi wrote: 
> On 01/25/2016 11:28 AM, Eric Ren wrote:
> >> @@ -449,7 +470,11 @@ static int o2hb_nego_timeout_handler(struct o2net_msg *msg, u32 len, void *data,
> >> >  static int o2hb_nego_approve_handler(struct o2net_msg *msg, u32 len, void *data,
> >> >  				void **ret_data)
> >> >  {
> >> > -	o2hb_arm_timeout((struct o2hb_region *)data);
> >> > +	struct o2hb_region *reg = (struct o2hb_region *)data;
> >> > +
> >> > +	printk(KERN_NOTICE "o2hb: negotiate timeout approved by master node on region %s (%s).\n",
> >> > +		config_item_name(&reg->hr_item), reg->hr_dev_name);
> >> > +	o2hb_arm_timeout(reg);
> > Why mix the use of printk and mlog? Any rules to follow?
> printk is log for user while mlog is log for debug.

Gotcha, thanks!

Eric

> 
> Thanks,
> Junxiao.
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
