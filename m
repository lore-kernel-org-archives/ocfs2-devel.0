From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 08 Apr 2010 07:47:00 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: make ocfs2_adjust_resv_from_alloc
	simple.
In-Reply-To: <20100407212423.GP11402@wotan.suse.de>
References: <1270539632-4509-1-git-send-email-tao.ma@oracle.com>
	<20100407212423.GP11402@wotan.suse.de>
Message-ID: <4BBD1974.9040203@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Tue, Apr 06, 2010 at 03:40:32PM +0800, Tao Ma wrote:
>   
>> When we allocate some bits from the reservation, we always
>> allocate from the r_start(see ocfs2_resmap_resv_bits).
>> So there should be no sense for checking between r_start
>> and start. And I don't think we will change this behaviour
>> somehow later by allocating from some bits after r_start.
>> Why not make ocfs2_adjust_resv_from_alloc simple now?
>>     
>
> I wanted ocfs2_resmap_claimed_bits() to be able to accept as many types of
> input as possible. That way, it would stay ready to handle other types of
> bitmaps. You're correct however that it's not really practical to allow for
> allocation which would split our reservation.
>
> Btw, if we took this to it's logical conclusion I think we'd be able to get
> rid of the 'cstart' variable to ocfs2_resmap_claimed_bits(). It's good to at
> least track what the caller *thought* the start of the allocation was so
> IMHO we should leave that part of the api untouched.
>   
yeah, I just want to change your codes as less as possible. ;)
>
> Can you please add a comment in reservations.h that
> ocfs2_resmap_claimed_bits() expects that 'start' is the same as we passed
> back from ocfs2_resmap_resv_bits(). Also, there's a check at the top of
> ocfs2_resmap_claimed_bits() which can become:
>
> BUG_ON(cstart != resv->r_start);
>   
OK, I will add them and resend the patch.

Regards,
Tao
