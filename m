From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 23 Sep 2010 14:57:38 -0700
Subject: [Ocfs2-devel] [PATCH 05/20] ocfs2/cluster: Get all heartbeat
 regions
In-Reply-To: <1284504656-2434-6-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
	<1284504656-2434-6-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100923215738.GA803@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 14, 2010 at 03:50:41PM -0700, Sunil Mushran wrote:
> +int o2hb_get_all_regions(char *region_uuids, u8 max_regions)
> +{
> +	struct o2hb_region *reg;
> +	int numregs = 0;
> +	char *p;
> +
> +	spin_lock(&o2hb_live_lock);
> +
> +	p = region_uuids;
> +	list_for_each_entry(reg, &o2hb_all_regions, hr_all_item) {
> +		mlog(0, "Region: %s\n", config_item_name(&reg->hr_item));
> +		if (numregs < max_regions) {
> +			memcpy(p, config_item_name(&reg->hr_item),
> +			       O2HB_MAX_REGION_NAME_LEN);
> +			p += O2HB_MAX_REGION_NAME_LEN;
> +		}
> +		numregs++;
> +	}

	The way I read this, region_uuids is a single array of length
max_regions*MAX_REGION_NAME_LEN.  That's pretty ugly, no?  I get that
you don't want to allocate strings, but there is no reason that you
can't require someone to pass in char**:

int o2hb_get_all_regions(char **region_uuids, u8 max_regions)
	...
		strncpy(region_uuids[numregs], name, MAX_LEN)
		numregs++

Sure, the memory layout of "region_uuids[max_regions][MAX_LEN]" the same
as "region_uuids[max_regions * MAX_LEN]", but walking it looks better.

Joel

-- 

"But all my words come back to me
 In shades of mediocrity.
 Like emptiness in harmony
 I need someone to comfort me."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
