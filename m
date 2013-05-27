From: Jeff Liu <jeff.liu@oracle.com>
Date: Mon, 27 May 2013 19:56:46 +0800
Subject: [Ocfs2-devel] [patch 1/4] ocfs2: fix a couple of memory leaks
 at o2hb_map_slot_data()
In-Reply-To: <51A34453.3080102@huawei.com>
References: <51A34453.3080102@huawei.com>
Message-ID: <51A349FE.4080705@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 05/27/2013 07:32 PM, Joseph Qi wrote:

> These memory will be freed in o2hb_region_release. If we free them here,
> then it will lead to double freed issue.

You're right. Thanks for letting me know about this.

-Jeff

> 
>> This patch can fix a couple of potential memory leaks at
>> o2hb_map_slot_data().
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>>
>> ---
>>  fs/ocfs2/cluster/heartbeat.c |   33 +++++++++++++++++++++++++--------
>>  1 files changed, 25 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
>> index a4e855e..1b6ce53 100644
>> --- a/fs/ocfs2/cluster/heartbeat.c
>> +++ b/fs/ocfs2/cluster/heartbeat.c
>> @@ -1638,7 +1638,7 @@ static void o2hb_init_region_params(struct
>> o2hb_region *reg)
>>
>>  static int o2hb_map_slot_data(struct o2hb_region *reg)
>>  {
>> -	int i, j;
>> +	int ret = 0, i, j;
>>  	unsigned int last_slot;
>>  	unsigned int spp = reg->hr_slots_per_page;
>>  	struct page *page;
>> @@ -1654,8 +1654,8 @@ static int o2hb_map_slot_data(struct o2hb_region *reg)
>>  	reg->hr_slots = kcalloc(reg->hr_blocks,
>>  				sizeof(struct o2hb_disk_slot), GFP_KERNEL);
>>  	if (reg->hr_slots == NULL) {
>> -		mlog_errno(-ENOMEM);
>> -		return -ENOMEM;
>> +		ret = -ENOMEM;
>> +		goto free;
>>  	}
>>
>>  	for(i = 0; i < reg->hr_blocks; i++) {
>> @@ -1673,15 +1673,15 @@ static int o2hb_map_slot_data(struct o2hb_region
>> *reg)
>>  	reg->hr_slot_data = kcalloc(reg->hr_num_pages, sizeof(struct page *),
>>  				    GFP_KERNEL);
>>  	if (!reg->hr_slot_data) {
>> -		mlog_errno(-ENOMEM);
>> -		return -ENOMEM;
>> +		ret = -ENOMEM;
>> +		goto free;
>>  	}
>>
>>  	for(i = 0; i < reg->hr_num_pages; i++) {
>>  		page = alloc_page(GFP_KERNEL);
>>  		if (!page) {
>> -			mlog_errno(-ENOMEM);
>> -			return -ENOMEM;
>> +			ret = -ENOMEM;
>> +			goto free;
>>  		}
>>
>>  		reg->hr_slot_data[i] = page;
>> @@ -1701,7 +1701,24 @@ static int o2hb_map_slot_data(struct o2hb_region
>> *reg)
>>  		}
>>  	}
>>
>> -	return 0;
>> +	return ret;
>> +
>> +free:
>> +	mlog_errno(ret);
>> +
>> +	kfree(reg->hr_tmp_block);
>> +	kfree(reg->hr_slots);
>> +
>> +	if (reg->hr_slot_data) {
>> +		for (i = 0; i < reg->hr_num_pages; i++) {
>> +			page = reg->hr_slot_data[i];
>> +			if (page)
>> +				__free_page(reg->hr_slot_data[i]);
>> +		}
>> +		kfree(reg->hr_slot_data);
>> +	}
>> +
>> +	return ret;
>>  }
>>
>>  /* Read in all the slots available and populate the tracking
>>
> 
