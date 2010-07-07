From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 07 Jul 2010 08:42:53 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Zero the tail cluster when
 extending past i_size v2
In-Reply-To: <20100706115827.GG13023@mail.oracle.com>
References: <20100629005403.GC24343@mail.oracle.com>
	<20100629015615.GZ6590@dastard>
	<20100629020420.GE24343@mail.oracle.com>
	<20100629022757.GA6590@dastard>
	<20100629071817.GA4150@mail.oracle.com>
	<20100702224912.GC5800@mail.oracle.com>
	<20100703213219.GB21262@mail.oracle.com>
	<4C3156D0.5090001@oracle.com>
	<20100706071741.GF13023@mail.oracle.com>
	<4C32E152.1090902@oracle.com>
	<20100706115827.GG13023@mail.oracle.com>
Message-ID: <4C33CD8D.4070205@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tao Ma <tao.ma@oracle.com>, Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <Joel.Becker@oracle.com>

Joel Becker wrote:
> On Tue, Jul 06, 2010 at 03:54:58PM +0800, Tao Ma wrote:
>   
>> On 07/06/2010 03:17 PM, Joel Becker wrote:
>>     
>>>>> +	/* Is there a cluster to zero? */
>>>>> +	if (!p_cpos)
>>>>> +		goto out;
>>>>>           
>>>> For unwritten extent, we also need to clear the pages? If yes, the
>>>> solution doesn't complete if we have 2 unwritten extent, one
>>>> contains i_size while one passes i_size. Here we only clear the
>>>> pages for the 1st unwritten extent and leave the 2nd one untouched.
>>>>         
>>> 	We probably don't need to zero unwritten extents.  We cannot
>>> have an extent past i_size, can we?
>>>       
>> we can. AFAICS, ocfs2_change_file_space will allocate unwritten
>> extents and does't change i_size.
>>     
>
> 	Oh, you're right.  We need to walk the entire extent range
> between i_size and pos and figure out what needs CoW.  This needs to
> happen no matter what.
>   
Actually we can only have unwritten extents after i_size and it 
shouldn't hurt you in this case.
So do we really need to CoW all the unwritten extents?
All I want to say is that since they are unwritten, they should also 
mean 'zero' for the user space.
So can we just need to skip clearing pages if i_size is in an unwritten 
extent?
>   
>>> 	But you dropped the check for pos_blkno alignment.
>>> Unconditionally adding the +1 doesn't seem like a good idea.
>>>       
>> You can add it as you wish.
>> I just thought that you add one more extra cluster if pos_blkno
>> isn't aligned so as to zero blocks in [pos_cpos_start_block,
>> pos_blkno).
>> But As I said in the comments, you will soon write pos_blkno(it also
>> needs to be CoW since it is within this refcounted extent), so if we
>> can CoW it out now, maybe we have a chance to not call
>> ocfs2_refcount_cow later.
>>     
>
> 	I'd much rather let the write handle its own contiguousness.  If
> we get lucky, that CoW melds with our CoW.  If we don't get lucky, isn't
> it better to have the newly changed area be fully contiguous rather than
> have the first extent of it not be and then the remaining extents be?
>   
fair enough.

Regards,
Tao
