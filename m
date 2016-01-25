From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Mon, 25 Jan 2016 12:28:08 +0800
Subject: [Ocfs2-devel] [PATCH 2/6] ocfs2: o2hb: add NEGO_TIMEOUT message
In-Reply-To: <20160125031855.GA7746@laptop.ha>
References: <1453259619-5347-1-git-send-email-junxiao.bi@oracle.com>
	<1453259619-5347-3-git-send-email-junxiao.bi@oracle.com>
	<20160125031855.GA7746@laptop.ha>
Message-ID: <56A5A458.9080201@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 01/25/2016 11:18 AM, Eric Ren wrote:
>>  
>> > @@ -2039,13 +2086,30 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
>> >  
>> >  	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
>> >  
>> > +	/* this is the same way to generate msg key as dlm, for local heartbeat,
>> > +	 * name is also the same, so make initial crc value different to avoid
>> > +	 * message key conflict.
>> > +	 */
>> > +	reg->hr_key = crc32_le(reg->hr_region_num + O2NM_MAX_REGIONS,
>> > +		name, strlen(name));
>> > +	INIT_LIST_HEAD(&reg->hr_handler_list);
> Looks no need to initilize ->hr_handler_list here?
Why? It is list head.

Thanks,
Junxiao.
