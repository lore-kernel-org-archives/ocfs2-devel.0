From: Changwei Ge <ge.changwei@h3c.com>
Date: Wed, 24 Oct 2018 04:56:00 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: Optimize the reading of heartbeat
 data
References: <20d062b0-c91b-dbdb-c2af-b826d9a773a5@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E37301277D8DF5@H3CMLB12-EX.srv.huawei-3com.com>
	<2fb420fb-176e-80d7-95ef-1b3013c414bd@huawei.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E37301277D99A7@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jia,

On 2018/10/24 10:49, Jia Guo wrote:
> Hi Changwei:
> 
> On 2018/10/24 9:21, Changwei Ge wrote:
>> Hi Jia,
>>
>> Your patch was not made properly and can't be applied to my work tree. :-(
>> Please check it.
>>
> I'm very sorry that I chose a wrong code path when executing 'git init'. :-(
> PATCH V2 will fix it.
>> Moreover, I *disagree* with your way trying to boost HB performance.
>> Actually, ocfs2 o2cb/heartbeat mechanism reads and writes region according slot number rather
>> than cluster node number.(Perhaps I missed something or your patch relies on your other patches)
>> And for slot assignment algorithm applied in ocfs2/mounting, the lowest slot number is always the first choice.
>> So your patch should not work...
>>
> I'm afraid you misunderstood the concept of slot number and heartbeat region. The heartbeat region corresponds to
> the cluster node number while the slot number assignment is what you describe.

Oops, you are right. I made mistake here. :-)

Thanks,
Changwei

> Thanks,
> Jia
>> Thanks,
>> Changwei
>>
>> On 2018/10/23 20:33, Jia Guo wrote:
>>> Reading heartbeat data from lowest node rather than from zero, in
>>> cases where the node is not defined from zero, can reduce the number
>>> of sectors read.
>>>
>>> Here is a simple test data obtained with 'iostat -dmx dm-5 2', with
>>> two nodes in the cluster, node number 10, 20, respectively.
>>> Before optimization:
>>> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
>>> dm-5              0.00     0.00    0.50    0.50     0.01     0.00    11.00     0.00    1.00    1.00    1.00   1.50   0.15
>>> After the optimization:
>>> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
>>> dm-5              0.00     0.00    0.50    0.50     0.00     0.00     6.00     0.00    0.50    1.00    0.00   0.50   0.05
>>>
>>> Signed-off-by: Jia Guo <guojia12@huawei.com>
>>> Reviewed-by: Jun Piao <piaojun@huawei.com>
>>> Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
>>> ---
>>>    cluster/heartbeat.c | 23 +++++++++++++++--------
>>>    1 file changed, 15 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/cluster/heartbeat.c b/cluster/heartbeat.c
>>> index 9b2ed62..a9cf984 100644
>>> --- a/cluster/heartbeat.c
>>> +++ b/cluster/heartbeat.c
>>> @@ -582,17 +582,18 @@ bail:
>>>    }
>>>
>>>    static int o2hb_read_slots(struct o2hb_region *reg,
>>> -			   unsigned int max_slots)
>>> +			   unsigned int min_slot,
>>> +			   unsigned int max_slot)
>>>    {
>>> -	unsigned int current_slot=0;
>>> +	unsigned int current_slot = min_slot;
>>>    	int status;
>>>    	struct o2hb_bio_wait_ctxt wc;
>>>    	struct bio *bio;
>>>
>>>    	o2hb_bio_wait_init(&wc);
>>>
>>> -	while(current_slot < max_slots) {
>>> -		bio = o2hb_setup_one_bio(reg, &wc, &current_slot, max_slots,
>>> +	while(current_slot < max_slot) {
>>> +		bio = o2hb_setup_one_bio(reg, &wc, &current_slot, max_slot,
>>>    					 REQ_OP_READ, 0);
>>>    		if (IS_ERR(bio)) {
>>>    			status = PTR_ERR(bio);
>>> @@ -1093,9 +1094,14 @@ static int o2hb_highest_node(unsigned long *nodes, int numbits)
>>>    	return find_last_bit(nodes, numbits);
>>>    }
>>>
>>> +static int o2hb_lowest_node(unsigned long *nodes, int numbits)
>>> +{
>>> +	return find_first_bit(nodes, numbits);
>>> +}
>>> +
>>>    static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
>>>    {
>>> -	int i, ret, highest_node;
>>> +	int i, ret, highest_node, lowest_node;
>>>    	int membership_change = 0, own_slot_ok = 0;
>>>    	unsigned long configured_nodes[BITS_TO_LONGS(O2NM_MAX_NODES)];
>>>    	unsigned long live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
>>> @@ -1120,7 +1126,8 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
>>>    	}
>>>
>>>    	highest_node = o2hb_highest_node(configured_nodes, O2NM_MAX_NODES);
>>> -	if (highest_node >= O2NM_MAX_NODES) {
>>> +	lowest_node = o2hb_lowest_node(configured_nodes, O2NM_MAX_NODES);
>>> +	if (highest_node >= O2NM_MAX_NODES || lowest_node >= O2NM_MAX_NODES) {
>>>    		mlog(ML_NOTICE, "o2hb: No configured nodes found!\n");
>>>    		ret = -EINVAL;
>>>    		goto bail;
>>> @@ -1130,7 +1137,7 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
>>>    	 * yet. Of course, if the node definitions have holes in them
>>>    	 * then we're reading an empty slot anyway... Consider this
>>>    	 * best-effort. */
>>> -	ret = o2hb_read_slots(reg, highest_node + 1);
>>> +	ret = o2hb_read_slots(reg, lowest_node, highest_node + 1);
>>>    	if (ret < 0) {
>>>    		mlog_errno(ret);
>>>    		goto bail;
>>> @@ -1801,7 +1808,7 @@ static int o2hb_populate_slot_data(struct o2hb_region *reg)
>>>    	struct o2hb_disk_slot *slot;
>>>    	struct o2hb_disk_heartbeat_block *hb_block;
>>>
>>> -	ret = o2hb_read_slots(reg, reg->hr_blocks);
>>> +	ret = o2hb_read_slots(reg, 0, reg->hr_blocks);
>>>    	if (ret)
>>>    		goto out;
>>>
>> .
>>
> 
