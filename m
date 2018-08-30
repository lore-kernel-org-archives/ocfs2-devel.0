From: Larry Chen <lchen@suse.com>
Date: Thu, 30 Aug 2018 16:24:56 +0800
Subject: [Ocfs2-devel] [PATCH] fix dead lock caused by
	ocfs2_defrag_extent
In-Reply-To: <HK0PR06MB256185E6D7A3330541D5D3E2D5080@HK0PR06MB2561.apcprd06.prod.outlook.com>
References: <20180827080121.31145-1-lchen@suse.com>
	<HK0PR06MB2561A612E5A95B60E7F8E22FD50A0@HK0PR06MB2561.apcprd06.prod.outlook.com>
	<4265c81b-26bf-fb54-e911-59773c40f788@suse.com>
	<HK0PR06MB2561632790BCD8DCD5936F47D5080@HK0PR06MB2561.apcprd06.prod.outlook.com>
	<42f7fbf5-9b7c-966e-887d-3b5ae51511e8@suse.com>
	<HK0PR06MB256185E6D7A3330541D5D3E2D5080@HK0PR06MB2561.apcprd06.prod.outlook.com>
Message-ID: <a51bc2c7-1350-5218-916b-7c1893d0e926@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

On 08/30/2018 03:52 PM, Changwei Ge wrote:
> Hi Larry,
> 
> 
> On 2018/8/30 14:26, Larry Chen wrote:
>> Hi Changwei,
>>
>> Maybe we need more investigation.
>>
>> The following is your fix:
>> lock truncate log inode
>>  ??? __ocfs2_flush_truncate_log()
>>  ????ocfs2_lock_allocators_move_extents()
>>  ??????? unlock truncate log inode
>>
>> The lock action will happen like following:
>> lock(truncate_inode)
>>  ????lock(sub allocat)
>>  ????lock(local_alloc) or lock(global_bitmap)
> 
> I don't think we have to worry much about mixed order? of cluster lock
> and inode mutex since cluster lock granted node will directly succeed
> instead of waiting for itself.
> 
>>
>> I'm not sure if there is another code path that tries to get the same
>> locks but in different order, which may causes dead locks.

Yeah, I use lock to mean both inode_lock and ocfs2_inode_lock.
As too many types of lock and inode locks are involved, I can not 
guarantee that there is no logic error.

>>
>> Indeed ocfs2 involves too many locks, I would like to reduce the
>> deadlock risk at max extent.
>>
>> Another way is to add an new argument for __ocfs2_flush_truncate which
>> indicates whether global bitmap is needed to be locked.
> 
> Sounds a feasible way :)

Haha, I also prefer this way :)
I'll send another patch and run test cases on my environment.


Thanks,
Larry
