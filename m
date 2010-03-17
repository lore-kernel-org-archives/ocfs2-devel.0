From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 17 Mar 2010 11:32:17 +0800
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2: allocation reservations
In-Reply-To: <20100317031314.GC11402@wotan.suse.de>
References: <1268188148-5253-1-git-send-email-mfasheh@suse.com>
	<1268188148-5253-2-git-send-email-mfasheh@suse.com>
	<4B9F4CAF.6090904@oracle.com>
	<20100317031314.GC11402@wotan.suse.de>
Message-ID: <4BA04D41.9050101@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

Mark Fasheh wrote:
> On Tue, Mar 16, 2010 at 05:17:35PM +0800, Tao Ma wrote:
>> Hi Mark,
>> 	The idea is cool. Some comments inlined.
> 
> Thanks, and thanks for the detailed review.
> 
> 
>> <snip>
>>> +	} else {
>>> +		unsigned int shrink = lru_resv->r_len / 2;
>>> +
>>> +		mlog(0, "shrink lru resv by %u\n", shrink);
>>> +
>>> +		lru_resv->r_len -= shrink;
>> Do we need to change lru_resv->r_last_len here so that the next search 
>> can start right after the shrinked zone? I am not sure.
> 
> No, I left them unchanged on purpose - they still record the last sucessful
> allocation. In theory we could try adjusting them, but that'd be speculative
> and not based on any actual allocation requests.
oh, thanks for the explanation.
<snip>
>> Besides the comments, I have some other thoughts.
>> 1. Do we need to some additional check in 
>> ocfs2_reserve_local_alloc_bits? The old schema just check the condition 
>> bits_wanted <= free_bits since local_alloc is contiguous enough. But 
>> with reservation window, we can have a fragmented local alloc actually.
>> 2. Current codes don't handle with space reservations(unwritten 
>> extents). Maybe it is because unwritten will allocate contiguous clusters?
>>
>> With these 2 problems, I corrupted the system somehow by the following 
>> scripts(Sorry, Mark, ;) ).
>>
>> echo 'y'|mkfs.ocfs2 -b 4K -C 4K --fs-features=local $DEVICE
>> mount -t ocfs2 $DEVICE $MNT_DIR
>> for((j=0;j<32;j++))
>> do
>>          FILE_NAME=$MNT_DIR/$RANDOM
>>          for((i=0;i<63;i++))
>>          do
>>          cat /mnt/4096 >> $FILE_NAME #4096 is a file with 4096 bytes.
>>          done
>> done
>> FILE_NAME=$MNT_DIR/$RANDOM
>> ./rw_test -f $FILE_NAME -l 0 -u 8192 #this will create a file with an 
>> unwritten extent of 2 clusters length at offset 0.
>> umount $MNT_DIR
>>
>> Now run fsck.ocfs2, you will find duplicated clusters.
>> This is caused by the code here.
>>  >	start = ocfs2_local_alloc_find_clear_bits(osb, alloc, bits_wanted,
>>  >                                                  ac->ac_resv);
>>  >        if (start == -1) {
>>  >                /* TODO: Shouldn't we just BUG here? */
>>  >                status = -ENOSPC;
>>  >                mlog_errno(status);
>>  >                goto bail;
>>  >        }
>>  >        printk("end of start %d\n", start);
>>  >
>>  >        bitmap = la->la_bitmap;
>>  >        *bit_off = le32_to_cpu(la->la_bm_off) + start;
>>  >        /* local alloc is always contiguous by nature -- we never
>>  >         * delete bits from it! */
>>  >        *num_bits = bits_wanted;
>>
>> See here? bit_wanted is 2, while with the script, the local alloc is 
>> divided into 32 parts and every part only have 1 clusters left. But this 
>> code deem that we can always get bits_wanted. :)
> 
> Ahh, yeah we need to pass back the actual allocation from
> ocfs2_local_alloc_find_clear_bits(). That should be simple enough. I
> probably never hit this because all other allocations that went to the local
> alloc were 1 bit at a time (for file write, etc).
yeah except unwritten extents. :)
> 
> 
> Btw, I realized that we don't really need ocfs2_local_alloc_in_range() since
> we don't allocate inode groups from it any more. Or at least, I can simplify
> it quite a bit.
yeah, actually I thought of this when reviewing the patch. But maybe we 
need another ac_max_blocks in the future. Who knows? ;)
I guess currently we can just check bm_off+bg_bits and it is ok for us 
now. And also we can clean your ocfs2_local_alloc_find_clear_bits since 
now we have no chance of a local_resv which only is used for 
ocfs2_local_alloc_in_range now. ;)

Regards,
Tao
