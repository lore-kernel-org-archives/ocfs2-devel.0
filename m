From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Fri, 22 Jan 2016 11:19:48 +0800
Subject: [Ocfs2-devel] [PATCH 1/6] ocfs2: o2hb: add negotiate timer
In-Reply-To: <56A17E4D.6040207@huawei.com>
References: <1453259619-5347-1-git-send-email-junxiao.bi@oracle.com>
	<1453259619-5347-2-git-send-email-junxiao.bi@oracle.com>
	<56A17E4D.6040207@huawei.com>
Message-ID: <56A19FD4.3030604@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph,

On 01/22/2016 08:56 AM, Joseph Qi wrote:
> Hi Junxiao,
> 
> On 2016/1/20 11:13, Junxiao Bi wrote:
>> When storage down, all nodes will fence self due to write timeout.
>> The negotiate timer is designed to avoid this, with it node will
>> wait until storage up again.
>>
>> Negotiate timer working in the following way:
>>
>> 1. The timer expires before write timeout timer, its timeout is half
>> of write timeout now. It is re-queued along with write timeout timer.
>> If expires, it will send NEGO_TIMEOUT message to master node(node with
>> lowest node number). This message does nothing but marks a bit in a
>> bitmap recording which nodes are negotiating timeout on master node.
>>
>> 2. If storage down, nodes will send this message to master node, then
>> when master node finds its bitmap including all online nodes, it sends
>> NEGO_APPROVL message to all nodes one by one, this message will re-queue
>> write timeout timer and negotiate timer.
>> For any node doesn't receive this message or meets some issue when
>> handling this message, it will be fenced.
>> If storage up at any time, o2hb_thread will run and re-queue all the
>> timer, nothing will be affected by these two steps.
>>
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>> Reviewed-by: Ryan Ding <ryan.ding@oracle.com>
>> ---
>>  fs/ocfs2/cluster/heartbeat.c |   52 ++++++++++++++++++++++++++++++++++++++----
>>  1 file changed, 48 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
>> index a3cc6d2fc896..b601ee95de50 100644
>> --- a/fs/ocfs2/cluster/heartbeat.c
>> +++ b/fs/ocfs2/cluster/heartbeat.c
>> @@ -272,6 +272,10 @@ struct o2hb_region {
>>  	struct delayed_work	hr_write_timeout_work;
>>  	unsigned long		hr_last_timeout_start;
>>  
>> +	/* negotiate timer, used to negotiate extending hb timeout. */
>> +	struct delayed_work	hr_nego_timeout_work;
>> +	unsigned long		hr_nego_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
>> +
>>  	/* Used during o2hb_check_slot to hold a copy of the block
>>  	 * being checked because we temporarily have to zero out the
>>  	 * crc field. */
>> @@ -320,7 +324,7 @@ static void o2hb_write_timeout(struct work_struct *work)
>>  	o2quo_disk_timeout();
>>  }
>>  
>> -static void o2hb_arm_write_timeout(struct o2hb_region *reg)
>> +static void o2hb_arm_timeout(struct o2hb_region *reg)
>>  {
>>  	/* Arm writeout only after thread reaches steady state */
>>  	if (atomic_read(&reg->hr_steady_iterations) != 0)
>> @@ -338,11 +342,50 @@ static void o2hb_arm_write_timeout(struct o2hb_region *reg)
>>  	reg->hr_last_timeout_start = jiffies;
>>  	schedule_delayed_work(&reg->hr_write_timeout_work,
>>  			      msecs_to_jiffies(O2HB_MAX_WRITE_TIMEOUT_MS));
>> +
>> +	cancel_delayed_work(&reg->hr_nego_timeout_work);
>> +	/* negotiate timeout must be less than write timeout. */
>> +	schedule_delayed_work(&reg->hr_nego_timeout_work,
>> +			      msecs_to_jiffies(O2HB_MAX_WRITE_TIMEOUT_MS)/2);
>> +	memset(reg->hr_nego_node_bitmap, 0, sizeof(reg->hr_nego_node_bitmap));
>>  }
>>  
>> -static void o2hb_disarm_write_timeout(struct o2hb_region *reg)
>> +static void o2hb_disarm_timeout(struct o2hb_region *reg)
>>  {
>>  	cancel_delayed_work_sync(&reg->hr_write_timeout_work);
>> +	cancel_delayed_work_sync(&reg->hr_nego_timeout_work);
>> +}
>> +
>> +static void o2hb_nego_timeout(struct work_struct *work)
>> +{
>> +	struct o2hb_region *reg =
>> +		container_of(work, struct o2hb_region,
>> +			     hr_nego_timeout_work.work);
>> +	unsigned long live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
>> +	int master_node;
>> +
>> +	o2hb_fill_node_map(live_node_bitmap, sizeof(live_node_bitmap));
>> +	/* lowest node as master node to make negotiate decision. */
>> +	master_node = find_next_bit(live_node_bitmap, O2NM_MAX_NODES, 0);
>> +
>> +	if (master_node == o2nm_this_node()) {
>> +		set_bit(master_node, reg->hr_nego_node_bitmap);
>> +		if (memcmp(reg->hr_nego_node_bitmap, live_node_bitmap,
>> +				sizeof(reg->hr_nego_node_bitmap))) {
> Should the access to hr_nego_node_bitmap be protected, for example,
> under o2hb_live_lock?
I didn't see need for this. This bitmap is used by negotiation master
node, every set op is ordered by o2net_wq. And master will check the bit
every second to find whether it's set.

Thanks,
Junxiao.
> 
> Thanks,
> Joseph
> 
>> +			/* check negotiate bitmap every second to do timeout
>> +			 * approve decision.
>> +			 */
>> +			schedule_delayed_work(&reg->hr_nego_timeout_work,
>> +				msecs_to_jiffies(1000));
>> +
>> +			return;
>> +		}
>> +
>> +		/* approve negotiate timeout request. */
>> +	} else {
>> +		/* negotiate timeout with master node. */
>> +	}
>> +
>>  }
>>  
>>  static inline void o2hb_bio_wait_init(struct o2hb_bio_wait_ctxt *wc)
>> @@ -1033,7 +1076,7 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
>>  	/* Skip disarming the timeout if own slot has stale/bad data */
>>  	if (own_slot_ok) {
>>  		o2hb_set_quorum_device(reg);
>> -		o2hb_arm_write_timeout(reg);
>> +		o2hb_arm_timeout(reg);
>>  	}
>>  
>>  bail:
>> @@ -1115,7 +1158,7 @@ static int o2hb_thread(void *data)
>>  		}
>>  	}
>>  
>> -	o2hb_disarm_write_timeout(reg);
>> +	o2hb_disarm_timeout(reg);
>>  
>>  	/* unclean stop is only used in very bad situation */
>>  	for(i = 0; !reg->hr_unclean_stop && i < reg->hr_blocks; i++)
>> @@ -1762,6 +1805,7 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
>>  	}
>>  
>>  	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
>> +	INIT_DELAYED_WORK(&reg->hr_nego_timeout_work, o2hb_nego_timeout);
>>  
>>  	/*
>>  	 * A node is considered live after it has beat LIVE_THRESHOLD
>>
> 
> 
